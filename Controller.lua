--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local _, addon = ...

local Events = {
    'ACTIONBAR_PAGE_CHANGED',
    'ACTIONBAR_SLOT_CHANGED',
    'PLAYER_FOCUS_CHANGED',
    'PLAYER_TARGET_CHANGED',
    'UNIT_SPELLCAST_CHANNEL_START',
    'UNIT_SPELLCAST_CHANNEL_STOP',
    'UNIT_SPELLCAST_CHANNEL_UPDATE',
    'UNIT_SPELLCAST_DELAYED',
    'UNIT_SPELLCAST_FAILED',
    'UNIT_SPELLCAST_INTERRUPTED',
    'UNIT_SPELLCAST_INTERRUPTIBLE',
    'UNIT_SPELLCAST_NOT_INTERRUPTIBLE',
    'UNIT_SPELLCAST_START',
    'UNIT_SPELLCAST_STOP',
}

local CooldownViewerNames = { "EssentialCooldownViewer", "UtilityCooldownViewer", }

--[[------------------------------------------------------------------------]]--

local function GetAllActionButtons()
    local buttons = {}

    -- Blizzard
    for _, actionButton in pairs(ActionBarButtonEventsFrame.frames) do
        buttons[actionButton] = actionButton.action
    end

    -- Dominos
    if Dominos then
        for actionButton in pairs(Dominos.ActionButtons.buttons) do
            buttons[actionButton] = actionButton.action
        end
    end

    -- EllesmereUI, hostile to other addons due to AI slopcode
    if EABActionButtonController then
        for i = 1, 180 do
            local actionButton = _G["EABButton"..i]
            if actionButton then
                local action = actionButton:GetAttribute("action")
                buttons[actionButton] = action
            end
        end
    end

    -- LibActionButton variants
    -- The %- here is a literal "-"
    for name, lib in LibStub:IterateLibraries() do
        if name:match('^LibActionButton%-1.0') then
            for actionButton in pairs(lib:GetAllButtons()) do
                local actionType, _action = actionButton:GetAction()
                if actionType == "action" then
                    buttons[actionButton] = actionButton.action
                end
            end
        end
    end

    return buttons
end

local function GetAllCDMButtons()
    local buttons = {}
    for _, viewerName in ipairs(CooldownViewerNames) do
        local viewer = _G[viewerName]
        for _, itemFrame in ipairs(viewer:GetItemFrames()) do
            if itemFrame.cooldownID then
                local info = C_CooldownViewer.GetCooldownViewerCooldownInfo(itemFrame.cooldownID)
                if info then
                    buttons[itemFrame] = info.spellID
                end
            end
        end
    end
    return buttons
end

--[[------------------------------------------------------------------------]]--

addon.ControllerMixin = {}

function addon.ControllerMixin:OnLoad()
    self:RegisterEvent('PLAYER_LOGIN')
end

function addon.ControllerMixin:Initialize()
    addon.InitializeOptions()
    addon.db.RegisterCallback(self, 'OnOptionsChanged', 'OnOptionsChanged')

    self.overlayPool = CreateFramePool('Frame', nil, "ABIHOverlayTemplate")

    self.state = {}

    FrameUtil.RegisterFrameForEvents(self, Events)

    -- This fires fairly often and causes a full rebuild of all the cooldown
    -- viewer itemFrames. Very inefficient compared to the actionbars.

    EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged",
        function ()
            self:CreateOverlays()
            self:Update('target')
        end)

    self.interruptsByName = {}
    for spellID in pairs(addon.Interrupts) do
        -- This doesn't seem to need spell load callback, not sure why
        local name = C_Spell.GetSpellName(spellID)
        if name then
            self.interruptsByName[name] = true
        end
    end
end

function addon.ControllerMixin:IsInterruptSpell(spellID)
    if spellID == nil or spellID == 0 then
        return false
    end
    local name = C_Spell.GetSpellName(spellID)
    return self.interruptsByName[name] == true
end

-- This tests not only "is this an interrupt" but "was this an interrupt
-- before and now isn't".
function addon.ControllerMixin:IsChangedActionID(actionID)
    local spellID = C_ActionBar.GetSpell(actionID)
    for overlay in self.overlayPool:EnumerateActive() do
        if overlay.actionID == actionID then
            if overlay.spellID == spellID then
                -- Already overlaying the right spell ID, no change
                return false
            else
                return true
            end
        end
    end
    if self:IsInterruptSpell(spellID) then
        return true
    end
    return false
end

function addon.ControllerMixin:CreateOverlays()
    self.overlayPool:ReleaseAll()
    if addon.db.profile.enableActionBars then
        for actionButton, actionID in pairs(GetAllActionButtons()) do
            local spellID = C_ActionBar.GetSpell(actionID)
            if self:IsInterruptSpell(spellID) then
                local overlay = self.overlayPool:Acquire()
                overlay.actionID = actionID
                overlay.spellID = spellID
                overlay:Attach(actionButton)
            end
        end
    end
    if addon.db.profile.enableCooldownManager then
        for cdmButton, spellID in pairs(GetAllCDMButtons()) do
            if self:IsInterruptSpell(spellID) then
                local overlay = self.overlayPool:Acquire()
                overlay.spellID = spellID
                overlay:Attach(cdmButton)
            end
        end
    end
end

function addon.ControllerMixin:RefreshOverlays()
    for overlay in self.overlayPool:EnumerateActive() do
        local unit = overlay:GetCurrentUnit()
        local state = self.state[unit]
        if state then
            overlay:Update(unpack(state))
        end
   end
end

function addon.ControllerMixin:UpdateUnitState(unit)
    if UnitCanAttack('player', unit) then
        local name, notInterruptible, _

        name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
        if name then
            local duration = UnitCastingDuration(unit)
            self.state[unit] = { true, notInterruptible, duration }
            return
        end

        name, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
        if name then
            local duration = UnitChannelDuration(unit)
            -- or UnitEmpoweredChannelDuration(unit)
            self.state[unit] = { true, notInterruptible, duration }
            return
        end
    end
    self.state[unit] = { false }
end

function addon.ControllerMixin:Update(...)
    for i = 1, select('#', ...) do
        local unit = select(i, ...)
        self:UpdateUnitState(unit)
    end
    self:RefreshOverlays()
end

function addon.ControllerMixin:OnOptionsChanged()
    self:CreateOverlays()
    self:Update('focus', 'target')
end

function addon.ControllerMixin:OnEvent(event, ...)
    if event == 'PLAYER_LOGIN' then
        self:Initialize()
        self:CreateOverlays()
        self:Update('focus', 'target')
    elseif event == 'ACTIONBAR_SLOT_CHANGED' then
        -- This fires CONSTANTLY for various reasons including stack updates
        -- and assistedcombat updates.
        local actionID = ...
        if self:IsChangedActionID(actionID) then
            self:CreateOverlays()
            self:Update('focus', 'target')
        end
    elseif event == 'ACTIONBAR_PAGE_CHANGED' then
        self:CreateOverlays()
        self:Update('focus', 'target')
    elseif event == 'PLAYER_TARGET_CHANGED' then
        self:Update('target')
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        self:Update('focus')
    elseif event:sub(1, 14) == 'UNIT_SPELLCAST' then
        local unit = ...
        if unit == 'focus' or unit == 'target' then
            self:Update(unit)
        end
    end
end
