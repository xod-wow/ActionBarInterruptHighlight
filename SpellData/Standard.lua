--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local _, addon = ...

-- Note about warlocks: the interrupt pet abilities are the override spell
-- for Command Demon (119898): not the spell the pet casts, but the spell the
-- player casts to make the pet cast their spell.

addon.Interrupts = {
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
    [119910] = true,                -- Spell Lock (Warlock Felhunter Pet)
    [132409] = true,                -- Spell Lock (Warlock Fel Ravager)
    [119914] = true,                -- Axe Toss (Warlock Felguard Pet)
    [  6552] = true,                -- Pummel (Warrior)
    [351338] = true,                -- Quell (Evoker)
}
