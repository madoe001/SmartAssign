local _G = _G

if GetLocale() ~= "deDE" then 
	return 
end

-- SmartAssign.lua
_G.SmartAssign = {}
local L = {}
-- make L global --
_G.SmartAssign.Locales = L

L["SmartAssign"] = "SmartAssign"

L["SmartAssign loaded more information added later."] = "SmartAssign geladen weitere Informationen folgen."

L["Player"] = "Spieler"

-- DATA
L["Healer"] = "Heiler"

L["Tank"] = "Tank"

L["Damage Dealer"] = "Damage Dealer"

L["Ability"] = "F\195\164higkeit"

L["Timer"] = "Timer"

-- SlashCommands
L["'func' must be a function"] = "'func' muss eine Funktion sein" 

L["Command %s not found. Use '/sa slash' for a full list of commands"] = "Kommando %s nicht gefunden. Benutze '/sa slash' f\195\188r eine \195\156bersicht aller Kommandos"

L["Slash commands:"] = "Slash Kommandos:"

L["/sa - Open the SmartAssign window."] = "/sa - SmartAssign Fenster \195\182ffnen"

L["/sa slash - Prints a list of all slash commands."] = "/sa slash - Zeige alle m\195\182glichen Slash Kommandos"

-- MiniMapButton

L["SmartAssign_Minimap_Clicks"] = "|cffFF0000Klicken: |cffFFFFFFSmartAssign \195\182ffnen"

L["/sa mmb - Toggle MiniMapButton."] = "/sa mmb - Aktiviert/Deaktiviert den Minikartenbutton."

-- ASSERTS
L["'func' in 'DropDownMenu SetOnClick' must be a function."] = "'func' in 'DropDownMenu SetOnClick' muss eine Funktion sein."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownMenu.data an."

L["'func' in 'DropDownList SetOnClick' must be a function."] = "'func' in 'DropDownList SetOnClick' muss eine Funktion sein."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownList.data an."

L["'exec' must be a string."] = "'exec' muss ein String sein."

L["'helpText' must be a string."] = "'helpText' muss ein String sein."

L["%s already exists."] = "%s existiert bereits."

L["'checkboxText' must be a string."] = "'checkboxText' muss ein String sein."