--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local _, addon = ...

addon.Interrupts = {
    [  2139] = true,                -- Counterspell (Mage)
    [  1766] = true,                -- Kick (Rogue)
    [  6552] = true,                -- Pummel (Warrior)
    [425609] = true,                -- Rebuke (Paladin)
    [ 15487] = true,                -- Silence (Priest)
    [410176] = true,                -- Skull Bash (Druid)
    [ 19647] = true,                -- Spell Lock (Warlock Felhunter Pet)
}
