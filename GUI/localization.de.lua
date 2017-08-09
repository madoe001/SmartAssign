if GetLocale() ~= "deDE" then 
	return 
end

local L = {}
-- make L global --
_G.SmartAssign.Locales = L

L["SmartAssign"] = "SmartAssign"

L["SmartAssign loaded more information added later."] = "SmartAssign geladen weitere Informationen folgen."

L["Player"] = "Spieler"

-- DATA
L["Healer"] = "Heiler"

L["Tank"] = "Tank"

L["DD"] = "Schaden"


-- ASSERTS
L["'func' in 'DropDownMenu SetOnClick' must be a function."] = "'func' in 'DropDownMenu SetOnClick' muss eine Funktion sein"

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownMenu.data an."

L["'func' in 'DropDownList SetOnClick' must be a function."] = "'func' in 'DropDownList SetOnClick' muss eine Funktion sein"

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownList.data an."