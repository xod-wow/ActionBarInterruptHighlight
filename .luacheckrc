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
    "LibStub",
    "PixelUtil",
    "UnitCastingDuration",
    "UnitCastingInfo",
    "UnitChannelDuration",
    "UnitChannelInfo",
}
