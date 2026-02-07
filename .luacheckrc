exclude_files = {
    ".git",
    ".github",
    ".luacheckrc",
    "Libs",
}

-- https://luacheck.readthedocs.io/en/stable/warnings.html

ignore = {
    "212/*.*",              -- Unused argument
    "213/_.*",              -- Unused loop variable
}

globals = {
    "ABIHControllerMixin",
    "ABIHOverlayMixin",
}

read_globals =  {
    "ActionBarButtonEventsFrame",
    "C_CurveUtil",
    "C_SpellActivationOverlay",
    "CreateColor",
    "CreateFramePool",
    "Dominos",
    "Enum",
    "FrameUtil",
    "GetActionInfo",
    "LibStub",
    "PixelUtil",
    "UnitCastingDuration",
    "UnitCastingInfo",
    "UnitChannelDuration",
    "UnitChannelInfo",
}
