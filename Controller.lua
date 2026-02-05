--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local Interrupts = {
    [ 47528] = true,                -- Mind Freeze (Death Knight)
    [183752] = true,                -- Disrupt (Demon Hunter)
    [ 78675] = true,                -- Solar Beam (Druid)
    [106839] = true,                -- Skull Bash (Druid)
    [147362] = true,                -- Counter Shot (Hunter)
    [187707] = true,                -- Muzzle (Hunter)
    [  2139] = true,                -- Counterspell (Mage)
    [116705] = true,                -- Spear Hand Strike (Monk)
    [ 96231] = true,                -- Rebuke (Paladin)
    [ 15487] = true,                -- Silence (Priest)
    [  1766] = true,                -- Kick (Rogue)
    [ 57994] = true,                -- Wind Shear (Shaman)
    [ 19647] = true,                -- Spell Lock (Warlock Felhunter Pet)
    [ 89766] = true,                -- Axe Toss (Warlock Felguard Pet)
    [  6552] = true,                -- Pummel (Warrior)
    [351338] = true,                -- Quell (Evoker)
}

local Events = {
    'ACTIONBAR_SLOT_CHANGED',
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

ABIHControllerMixin = {}

function ABIHControllerMixin:OnLoad()
    self:RegisterEvent('PLAYER_LOGIN')
end

function ABIHControllerMixin:Initialize()
    self.overlayPool = CreateFramePool('Frame', nil, "ABIHOverlayTemplate")

    FrameUtil.RegisterFrameForEvents(self, Events)
end

function ABIHControllerMixin:IsRelevantActionID(actionID)
    local _, spellID = GetActionInfo(actionID)
    if Interrupts[spellID] then
        return true
    end
    for overlay in self.overlayPool:EnumerateActive() do
        if overlay:GetParent().action == actionID then
            return true
        end
    end
    return false
end

function ABIHControllerMixin:CreateOverlays()
    self.overlayPool:ReleaseAll()
    for _, actionButton in pairs(ActionBarButtonEventsFrame.frames) do
        local _, spellID = GetActionInfo(actionButton.action)
        if Interrupts[spellID] then
            local overlay = self.overlayPool:Acquire()
            overlay:Attach(actionButton)
        end
    end
end

function ABIHControllerMixin:RefreshOverlays(isActive, notInterruptible, duration)
    for overlay in self.overlayPool:EnumerateActive() do
        overlay:Update(isActive, notInterruptible, duration)
   end
end

function ABIHControllerMixin:Update(unit)
    local name, notInterruptible, _

    name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
    if name then
        local duration = UnitCastingDuration(unit)
        self:RefreshOverlays(true, notInterruptible, duration)
        return
    end

    name, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
    if name then
        local duration = UnitChannelDuration(unit)
        self:RefreshOverlays(true, notInterruptible, duration)
        return
    end

    self:RefreshOverlays(false)
end

function ABIHControllerMixin:OnEvent(event, ...)
    if event == 'PLAYER_LOGIN' then
        self:Initialize()
        self:CreateOverlays()
        self:Update('target')
    elseif event == 'ACTIONBAR_SLOT_CHANGED' then
        -- This fires CONSTANTLY when assistedcombat is on a bar
        local actionID = ...
        if self:IsRelevantActionID(actionID) then
            self:CreateOverlays()
            self:Update('target')
        end
    else
        local unit = ...
        if unit == 'target' then
            self:Update(unit)
        end
    end
end
