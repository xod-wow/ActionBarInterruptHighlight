codes = true

exclude_files = {
    ".git",
    ".github",
    ".luacheckrc",
    "Libs",
}

-- https://luacheck.readthedocs.io/en/stable/warnings.html

ignore = {
    "211/_.+",              -- Unused
    "212/_.+",              -- Unused argument
    "213/_.+",              -- Unused loop variable
}

globals = {
    "ABIHControllerMixin",
    "ABIHOverlayMixin",
}

read_globals =  {
    "ActionBarButtonEventsFrame",
    "C_ActionBar",
    "C_AddOns",
    "C_CooldownViewer",
    "C_CurveUtil",
    "C_SpellActivationOverlay",
    "CreateColor",
    "CreateFramePool",
    "Dominos",
    "Enum",
    "EventRegistry",
    "FrameUtil",
    "GetActionInfo",
    "GetActionText",
    "GetCVarBool",
    "GetMacroBody",
    "GetModifiedClick",
    "IsModifiedClick",
    "IsModifiedClick",
    "LibStub",
    "PixelUtil",
    "SLASH_CAST1",
    "SLASH_CAST2",
    "SLASH_CAST3",
    "SLASH_CAST4",
    "SLASH_USE1",
    "SLASH_USE2",
    "SecureCmdOptionParse",
    "UnitCanAttack",
    "UnitCastingDuration",
    "UnitCastingInfo",
    "UnitChannelDuration",
    "UnitChannelInfo",
    "UnitExists",
    "UnitIsFriend",
}
