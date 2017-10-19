--- Beschreibung: Diese Klasse wird benutzt, um f&uumlr SmartAssign einen MiniMapButton an der Minimap von World of Warcraft zu erstellen.
--                Diese Klasse wird &uumlber die globale WoW Tabelle _G global gemacht.
--                Es wird ein SAButton des Typs LibDBIcon benutzt, welche das Icon ist.
--                Mit LibDataBroker werden die Daten f&uumlr den MiniMapButton erstellt und gespeichert.
--				  Der MiniMapButton ist kein richtiger Button sondern ein Icon, mit welchen der Spieler interagieren kann.
--				  Der MiniMapButton wird benutzt, um die grafische Oberfl&aumlche von SmartAssign, &uumlber einen Mausklick aufzurufen.
--
-- @module MiniMapButton
-- @author Bartlomiej Grabelus (10044563)


-- hole die Globale Tabelle
local _G = _G

local SmartAssign = _G.SmartAssign
local SlashCommands = SmartAssign.SlashCommands

local MiniMapButton = {}
SmartAssign.MiniMapButton = MiniMapButton

-- Lokalisierung
local SAL = _G.GUI.Locales

-- Minimap Daten
local minimap = SmartAssign.minimap

-- Der MiniMapButton Icon
local SAButton = LibStub("LibDBIcon-1.0")

-- Lua Funktionen
local type = type
local abs, sqrt = math.abs, math.sqrt

-- Pr&uumlfe ob LibDataBroker-1.1 geladen werden kann, ansonsten return
if not LibStub:GetLibrary("LibDataBroker-1.1", true) then 
	return 
end

--- Erstelle ein LDB Objekt, welche die Daten f&uumlr den MiniMapButton enth&aumllt.
-- Welche f&uumlr den MiniMapButton benutzt werden.
local MiniMapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("SmartAssign", {
	type = "launcher",
	text = SAL["SmartAssign"],
	icon = "Interface\\Icons\\achievment_Boss_spineofdeathwing",
	OnTooltipShow = function(tooltip) -- add a tooltip
		tooltip:AddLine("|cff436eee"..SAL["SmartAssign"].."|r");
		tooltip:AddLine(SAL["SmartAssign_Minimap_Clicks"]);
	end,
	-- Wenn der MiniMapButton geklickt wurde, &oumlffne das grafische Fenster, war das Fenster offen, dann setze alle Frames zur&uumlck
	OnClick = function(self, button)
		if button == "LeftButton" then
			if minimap.clicked == true then
				SlashCommands:Run("reset","frames")
			end
			minimap.clicked = true	
			SlashCommands:Run("")
		end
	end,
})

---  Wird zum initialisieren des MiniMapButtons benutzt.
--  Es wird ein Slash Kommando f&uumlr das Togglen des MiniMapButtons hinzugef&uumlgt, sowie eine Resetfunktion hinzugef&uumlgt.
function MiniMapButton:Init()
	SlashCommands:Add("mmb", MiniMapButton.Toggle, SAL["/smart mmb - Toggle MiniMapButton."])
	SlashCommands:AddResetFunction(MiniMapButton.ResetFrames, "miniMapButton")

	SAButton:Register("SmartAssign", MiniMapLDB, minimap); -- Registriere die Daten f&uumlr den Button(Binding)
end

--- Setze die position des Icons zur&uumlck and f&uumlhre eine Aktualisierung aus.
function MiniMapButton.ResetFrames()
	minimap.minimapPos = 210;
	SAButton:Refresh("SmartAssign");
end

--- F&uumlrs Togglen des MiniMapButtons.
-- Es werden die Variablen shown und hide negiert und dann wird gecheckt, ob der MiniMapButton angezeigt wird.
-- Dementsprechend zeige oder verstecke den MiniMapButton.
function MiniMapButton.Toggle()
	minimap.shown = not minimap.shown
	minimap.hide = not minimap.hide
	if not minimap.hide then
		SAButton:Show("SmartAssign")
	else
		SAButton:Hide("SmartAssign")
	end
end

--- Wird benutzt um das Togglen des MiniMapButtons zu sperren, wenn gew&uumlnscht.
function MiniMapButton.Lock_Toggle()
	if minimap.locked then
		SAButton:Lock("SmartAssign");
	else
		SAButton:Unlock("SmartAssign");
	end
end
