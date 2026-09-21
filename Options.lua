--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local addonName, addon = ...


--[[------------------------------------------------------------------------]]--

local defaults = {
    global = {
    },
    profile = {
        enableActionBars = true,
        enableCooldownManager = true,
        enableTimer = true,
    },
    char = {
    },
}


--[[------------------------------------------------------------------------]]--

addon.CheckboxControlMixin = CreateFromMixins(SettingsCheckboxControlMixin)

function addon.CheckboxControlMixin:Init(initializer)
    SettingsCheckboxControlMixin.Init(self, initializer)

    local leftPad = self:GetIndent()

    self.Checkbox:ClearAllPoints()
    self.Checkbox:SetPoint("LEFT", self, "LEFT", leftPad, 0)

    leftPad = leftPad + self.Checkbox:GetWidth() + 8
    self.Text:ClearAllPoints()
    self.Text:SetPoint("LEFT", self, "LEFT", leftPad, 0)
end


--[[------------------------------------------------------------------------]]--

local function Register(category, layout)

    -- enableActionBars
    do
        local setting = Settings.RegisterProxySetting(
            category,
            "ABHIEnableActionBars",
            Settings.VarType.Boolean,
            "Highlight buttons on action bars.",
            function () return defaults.profile.enableActionBars end,
            function () return addon.db.profile.enableActionBars end,
            function (v)
                addon.db.profile.enableActionBars = v
                addon.db.callbacks:Fire('OnOptionsChanged')
            end
        )
        local initializer = Settings.CreateControlInitializer("ABIHCheckboxControlTemplate", setting)
        layout:AddInitializer(initializer)
    end

    -- enableCooldownManager
    do
        local setting = Settings.RegisterProxySetting(
            category,
            "ABHIEnableCooldownManager",
            Settings.VarType.Boolean,
            "Highlight buttons on cooldown manager bars.",
            function () return defaults.profile.enableCooldownManager end,
            function () return addon.db.profile.enableCooldownManager end,
            function (v)
                addon.db.profile.enableCooldownManager = v
                addon.db.callbacks:Fire('OnOptionsChanged')
            end
        )
        local initializer = Settings.CreateControlInitializer("ABIHCheckboxControlTemplate", setting)
        layout:AddInitializer(initializer)
    end

    -- enableTimer
    do
        local setting = Settings.RegisterProxySetting(
            category,
            "ABHIEnableTimer",
            Settings.VarType.Boolean,
            "Also show timer on highlighted buttons.",
            function () return defaults.profile.enableTimer end,
            function () return addon.db.profile.enableTimer end,
            function (v)
                addon.db.profile.enableTimer = v
                addon.db.callbacks:Fire('OnOptionsChanged')
            end
        )
        local initializer = Settings.CreateControlInitializer("ABIHCheckboxControlTemplate", setting)
        layout:AddInitializer(initializer)
    end
end

function addon.InitializeOptions()
    addon.db = LibStub("AceDB-3.0"):New("ActionBarInterruptHighlightDB", defaults, true)

    -- A convenience so other things just listen for OnOptionsChanged
    local function refire() addon.db.callbacks:Fire('OnOptionsChanged') end
    addon.db.RegisterCallback(addon, 'OnProfileChanged', refire)
    addon.db.RegisterCallback(addon, 'OnProfileReset', refire)
    addon.db.RegisterCallback(addon, 'OnProfileCopied', refire)

    local title = C_AddOns.GetAddOnTitle(addonName)
    local category, layout = Settings.RegisterVerticalLayoutCategory(title)
    SettingsRegistrar:AddRegistrant(function () Register(category, layout) end)
    Settings.RegisterAddOnCategory(category)

    SlashCmdList[addonName] =
        function ()
            if not InCombatLockdown() then
                SettingsPanel:Open()
                SettingsPanel:SelectCategory(category, true)
            end
        end
    _G["SLASH_"..addonName.."1"] = "/abih"
end
