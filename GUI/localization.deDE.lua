-- @author Bartlomiej Grabelus (10044563)

local _G = _G

if GetLocale() ~= "deDE" then 
	return 
end

if not _G.GUI.Locales then _G.GUI.Locales = {} end

-- SmartAssign.lua
local L = {}
-- make L global --
_G.GUI.Locales = L

L["SmartAssign"] = "SmartAssign"

L["SmartAssign loaded. For more informartion about Slashcommands type in '/smart slash'."] = "SmartAssign geladen. F\195\188r mehr Informationen zu Slashcommands, gebe '/smart slash' ein."

L["Player"] = "Spieler"

-- DATA
L["Healer"] = "Heiler"

L["Tank"] = "Tank"

L["Damage Dealer"] = "Damage Dealer"

L["Ability"] = "F\195\164higkeit"

L["Extra Text"] = "Extra Text"

L["Timer"] = "Timer"

L["Classic"] = "Classic"

L["Ragefire Chasm"] = "Der Flammenschlund"

L["Adarogg"] = "Adarogg"

L["Dark Shaman Koranthal"] = "Dunkelschamane Koranthal"

L["Slagmaw"] = "Nagma"

L["Lava Guard Gordoth"] = "Lavawache Gordoth"

L["Deadmines"] = "Die Todesminen"

L["Glubtok"] = "Glubtok"

L["Helix Gearbreaker"] = "Helix Ritzelbrecher"

L["Foe Reaper 5000"] = "Feindschnitter 5000"

L["Admiral Ripsnarl"] = "Admiral Knurrreisser"

L["Captain Cookie"] = "Kapit\195\164n Kr\195\188mel"

L["Vanessa VanCleef"] = "Vanessa van Cleef"

L["Wailing Caverns"] = "Die H\195\182hlen des Wehklagens"

L["Lady Anacondra"] = "Lady Anakondra"

L["Kresh"] = "Kresh"

L["Lord Pythas"] = "Lord Pythas"

L["Lord Cobrahn"] = "Lord Kobrahn"

L["Skum"] = "Skum"

L["Lord Serpentis"] = "Lord Serpentis"

L["Verdan the Everliving"] = "Verdan der Ewiglebende"

L["Mutanus the Devourer"] = "Mutanus der Verschlinger"

L["Shadowfang Keep"] = "Burg Schattenfang"

L["Baron Ashbury"] = "Baron Ashbury"

L["Baron Silverlaine"] = "Baron Silberlein"

L["Commander Springvale"] = "Kommandant Gr\195\188ntal"

L["Lord Walden"] = "Lord Walden"

L["Lord Godfrey"] = "Lord Godfrey"

L["Wrath of the Lich King"] = "Wrath of the Lich King"

L["The Burning Crusade"] = "The Burning Crusade"

L["Cataclysm"] = "Cataclysm"

L["Mists of Pandaria"] = "Mists of Pandaria"

L["Warlords of Draenor"] = "Warlords of Draenor"

L["Legion"] = "Legion"

-- SlashCommands
L["'func' must be a function."] = "'func' muss eine Funktion sein." 

L["Command %s not found. Use '/smart slash' for a full list of commands."] = "Kommando %s nicht gefunden. Benutze '/smart slash' f\195\188r eine \195\156bersicht aller Kommandos"

L["Slash commands:"] = "Slash Kommandos:"

L["/smart - Open the SmartAssign window."] = "/smart - SmartAssign Fenster \195\182ffnen"

L["/smart slash - Prints a list of all slash commands."] = "/smart slash - Zeige alle m\195\182glichen Slash Kommandos"

-- MiniMapButton

L["SmartAssign_Minimap_Clicks"] = "|cffFF0000Klicken: |cffFFFFFFSmartAssign \195\182ffnen"

L["/smart mmb - Toggle MiniMapButton."] = "/smart mmb - Aktiviert/Deaktiviert den Minikartenbutton."

-- EditBox

L["Time in sec"] = "Zeit in s"

L["[SpellID] text"] = "[SpellID] Text"

L["name"] = "Name"

L["cooldown(s) in sec"] = "Abklingzeit/en in s"

L["phasename(s)"] = "Phasenname/n"

L["trigger"] = "Trigger"

-- ScrollFrame

L[" has no childs!"] = " hat keine Kinder!"

-- mainHUD

L["Player is in Instance."] = "Der Spieler ist in einer Instanz."

L["Player is not in Instance."] = "Der Spieler ist in keiner Instanz."

-- AbilityFrame/PhaseFrame

L["Apply"] = "Anlegen"

L["Delete"] = "L\195\182schen"

L["For more than one cooldown or phasename use a semicolon as delimiter"] = "F\195\188r mehr als eine Abklingzeit oder einen Phasennamen,\n benutze ein Semikolon zum trennen"

L["loop"] = "Schleife"

L["phasebound"] = "Phasengebunden"

L["reset timer on phase"] = "Timer bei Phase zur\195\188cksetzen"

L["first Phase"] = "erste Phase"

L["mythic"] = "Mytisch"

L["heroic"] = "Heroisch"

L["normal"] = "Normal"

L["Do you really want to create this ability: %s ?"] = "M\195\182chtest du wirklich die F\195\164higkeit \"%s\" erstellen?"

L["Do you really want to delete this ability: %s ?"] = "M\195\182chtest du wirklich die F\195\164higkeit \"%s\" l\195\182schen?"

L["Do you really want to delete this phase: %s ?"] = "M\195\182chtest du wirklich die Phase \"%s\" l\195\182schen?"

L["Do you really want to create this phase: %s ?"] = "M\195\182chtest du wirklich die Phase \"%s\" erstellen?"

L["Text/HP/Energy/Time"] = "Text/HP/Energie/Zeit" 

L["Yes"] = "Ja"

L["No"] = "Nein"

L["Ok"] = "Ok"

L["Do you have forgotten to check phasebounded?"] = "Hast du vergessen Phasengebunden anzukreuzen?"

L["Do you have forgotten the phase?"] = "Hast du die Phase vergessen?"

L["You should tick a difficulty!"] = "Bitte w\195\164hle einen Schwierigkeitsgrad aus!"

L["You should tick only one difficulty!"] = "Bitte w\195\164hle nur einen Schwierigkeitsgrad aus!"

L["Is it the first Phase?"] = "Ist es die erste Phase?"

L["You should check first phase?"] = "Du solltest erste Phase ankreuzen"

L["There is nothing to delete"] = "Es gibt nichts zu löschen"

-- ASSERTS
L["'func' in 'DropDownMenu SetOnClick' must be a function."] = "'func' in 'DropDownMenu SetOnClick' muss eine Funktion sein."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownMenu.data an."

L["'func' in 'DropDownList SetOnClick' must be a function."] = "'func' in 'DropDownList SetOnClick' muss eine Funktion sein."

L["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."] = "'data' muss eine Tabelle sein. Schaue in 'Init.lua' die Tabelle _G.GUI.DropDownList.data an."

L["'exec' must be a string."] = "'exec' muss ein String sein."

L["'helpText' must be a string."] = "'helpText' muss ein String sein."

L["%s already exists."] = "%s existiert bereits."

L["'checkboxText' must be a string."] = "'checkboxText' muss ein String sein."

L["'max' must be greater than 0."] = "'max' muss gr\195\182sser als 0 sein."

L["'inputType' must be string or number."] = "'inputType' muss String oder Nummer sein."
