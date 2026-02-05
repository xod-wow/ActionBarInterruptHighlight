exclude_files = {
    ".git",
    ".github",
    ".luacheckrc",
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
    "Enum",
    "FrameUtil",
    "GetActionInfo",
    "PixelUtil",
    "UnitCastingDuration",
    "UnitCastingInfo",
    "UnitChannelDuration",
    "UnitChannelInfo",
}
