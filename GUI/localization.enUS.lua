if GetLocale() ~= "enUS" then return end

if not _G.GUI.Locales then _G.GUI.Locales = {} end

-- SmartAssign.lua
local L = {}
-- make L global --
_G.GUI.Locales = L

L["SmartAssign"] = "SmartAssign"

L["SmartAssign loaded. For more informartion about Slashcommands type in '/smart slash'."] = "SmartAssign loaded. For more informartion about Slashcommands type in '/smart slash'."

L["Player"] = "Player"

-- DATA
L["Healer"] = "Healer"

L["Tank"] = "Tank"

L["Damage Dealer"] = "Damage Dealer"

L["Ability"] = "Ability"

L["Extra Text"] = "Extra Text"

L["Timer"] = "Timer"

L["Classic"] = "Classic"

L["Ragefire Chasm"] = "Ragefire Chasm"

L["Adarogg"] = "Adarogg"

L["Dark Shaman Koranthal"] = "Dark Shaman Koranthal"

L["Slagmaw"] = "Slagmaw"

L["Lava Guard Gordoth"] = "Lava Guard Gordoth"

L["Deadmines"] = "Deadmines"

L["Glubtok"] = "Glubtok"

L["Helix Gearbreaker"] = "Helix Gearbreaker"

L["Foe Reaper 5000"] = "Foe Reaper 5000"

L["Admiral Ripsnarl"] = "Admiral Ripsnarl"

L["Captain Cookie"] = "Captain Cookie"

L["Vanessa VanCleef"] = "Vanessa VanCleef"

L["Wailing Caverns"] = "Wailing Caverns"

L["Lady Anacondra"] = "Lady Anacondra"

L["Kresh"] = "Kresh"

L["Lord Pythas"] = "Lord Pythas"

L["Lord Cobrahn"] = "Lord Cobrahn"

L["Skum"] = "Skum"

L["Lord Serpentis"] = "Lord Serpentis"

L["Verdan the Everliving"] = "Verdan the Everliving"

L["Mutanus the Devourer"] = "Mutanus the Devourer"

L["Shadowfang Keep"] = "Shadowfang Keep"

L["Baron Ashbury"] = "Baron Ashbury"

L["Baron Silverlaine"] = "Baron Silverlaine"

L["Commander Springvale"] = "Commander Springvale"

L["Lord Walden"] = "Lord Walden"

L["Lord Godfrey"] = "Lord Godfrey"

L["WOTLK"] = "WOTLK"

-- SlashCommands
L["'func' must be a function."] = "'func' must be a function."

L["Command %s not found. Use '/smart slash' for a full list of commands."] = "Command %s not found. Use '/smart slash' for a full list of commands."

L["Slash commands:"] = "Slash commands:"

L["/smart - Open the SmartAssign window."] = "/smart - Open the SmartAssign window."

L["/smart slash - Prints a list of all slash commands."] = "/smart slash - Prints a list of all slash commands."

-- MiniMapButton

L["SmartAssign_Minimap_Clicks"] = "|cffFF0000Click: |cffFFFFFFOpen SmartAssign"

L["/smart mmb - Toggle MiniMapButton."] = "/smart mmb - Toggle MiniMapButton."

-- EditBox

L["Time in sec"] = "Time in sec"

L["[SpellID] text"] = "[SpellID] text"

-- ScrollFrame

L[" has no childs!"] = " has no childs!"

-- mainHUD
L["Player is in Instance."] = "Player is in Instance."

L["Player is not in Instance."] = "Player is not in Instance."

-- ASSERTS
L["'func' in 'DropDownMenu SetOnClick' must be a function."] = "'func' in 'DropDownMenu SetOnClick' must be a function."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."] = "'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."

L["'func' in 'DropDownList SetOnClick' must be a function."] = "'func' in 'DropDownList SetOnClick' must be a function."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."] = "'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."

L["'exec' must be a string."] = "'exec' must be a string."

L["'helpText' must be a string."] = "'helpText' must be a string."

L["%s already exists."] = "%s already exists."

L["'checkboxText' must be a string."] = "'checkboxText' must be a string."

L["'max' must be greater than 0."] = "'max' must be greater than 0."

L["'inputType' must be string or number."] = "'inputType' must be string or number."
