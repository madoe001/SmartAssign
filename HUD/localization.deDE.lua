--Author: Bartlomiej Grabelus

local _G = _G

if GetLocale() ~= "deDE" then 
	return 
end

if not _G.HUD.Locales then _G.HUD.Locales = {} end

-- SmartAssign.lua
local L = {}
-- make L global --
_G.HUD.Locales = L

-- BossSpellIcon
L["Starts to cast "] = "Startet den Zauber "

L["Starts in "] = "Startet in "

L[" sec"] = " s"

L[" is channeling now!"] = " ist am kanalisieren!"