--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local _, addon = ...

addon.Interrupts = {
    [  2139] = true,                -- Counterspell (Mage)
    [  8042] = true,                -- Earth Shock (Shaman)
    [  1766] = true,                -- Kick (Rogue)
    [  6552] = true,                -- Pummel (Warrior)
    [425609] = true,                -- Rebuke (Paladin Engrave Pants - Rebuke)
    [    72] = true,                -- Shield Bash
    [410176] = true,                -- Skull Bash (Druid Engrave Gloves - Skull Bash)
    [ 19647] = true,                -- Spell Lock (Warlock Felhunter Pet)
}
