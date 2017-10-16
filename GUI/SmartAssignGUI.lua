--- @author Bartlomiej Grabelus, Maik Doemmecke
-- Klasse, welche zum Initialisieren und erstellen der grafischen Oberflaeche des Addon´s dient.

-- Global Varieblen --
local _G = _G
local SmartAssign = _G.SmartAssign

local GUI = _G.GUI

-- genutzte Komponenten
local AssignmentFrame = _G.GUI.AssignmentFrame
local CreateAbilityFrame = GUI.SA_CreateAbilityFrame
local PhaseFrame = GUI.SA_PhaseFrame
local flag = true

-- hud
local mainHUD = _G.HUD.mainHUD

local SlashCommands = _G.SmartAssign.SlashCommands
local MiniMapButton = SmartAssign.MiniMapButton

-- Lokalisierung holen
local GUIL = _G.GUI.Locales

-- lokale Tabellen
local SA_GUI = {}
local SA_GUI_LOCAL = {}

local Assignments = {}

-- Lokale GUI wird global gemacht
_G.SmartAssign.SA_GUI = SA_GUI

--- Erstellt den Frame in den der Gesamte Inhalt geladen werden soll 
function SA_GUI:LoadFrame()
	if not mainFrame then
		CreateFrame("Frame","mainFrame",UIParent)
		SA_GUI.frame = mainFrame
	end
	mainFrame:SetScript("OnEvent",SA_GUI_LOCAL.Init) -- set init function
	mainFrame:RegisterEvent("ADDON_LOADED")
end

--- Funktion zum Initialisieren des Addon´s sobald das Addon geladen wird
--
-- @param event Event auf dass das Addon geladen werden soll
-- @param addon Name des Addon´s
function SA_GUI_LOCAL:Init(event, addon)
	if (event == "ADDON_LOADED" and addon == "SmartAssign") then
		SA_GUI_LOCAL:CreateGUI(SA_GUI.frame)
		SlashCommands:Init() -- init slashcommands
		SlashCommands:AddResetFunction(SA_GUI_LOCAL.ResetFrames, "frames")
		MiniMapButton:Init() -- init minimapbutton
	end
end
	
--- Funktion mit der es moeglich ist einen Frame beweglich zu machen
--
-- @param frame Frame, der beweglich gemacht werden soll
function SA_GUI_LOCAL:MakeMovable(frame)
    frame:EnableMouse(true)
	frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

--- Erstellt den Inhalt des Hauptfenster´s 
--
-- @param frame Parentframe in den der Inhalt geladen werden soll 
function SA_GUI_LOCAL:CreateGUI(frame)
	frame = SA_GUI_LOCAL:CreateWindow(frame)
	
	-- close Button
	frame.closeButton = SA_GUI_LOCAL:CreateButton(frame, "closeButton", nil, 0, 0, "TOPRIGHT", 0, 0, "UIPanelCloseButton")
	
	-- create TitleBar
	SA_GUI_LOCAL:CreateTitleBar(frame)
	
	-- Title
	frame.title = SA_GUI_LOCAL:CreateFont(frame, "titleFont", GUIL["SmartAssign"], nil, 0, 5, 22)
	
		
	local boss = BossSelectFrame:new_BossSelectFrame(frame, "MainWindow", 200, frame:GetHeight(), "LEFT", 0, 0)
	local assign = AssignmentFrame:new_scrollframe(frame, boss.frame, 5, -100)
	
	boss.bossDD.assignmentFrame = assign
	frame.assign = assign
	local testFrame = CreateFrame("Frame", "amk", UIParent)
	PhaseFrame:CreateGUI(testFrame)

	-- make main frame movable
	SA_GUI_LOCAL:MakeMovable(frame)
	
end

--- Konfiguration des Hauptfensters. Es wird zum Beispiel die Breite, Hoehe und die Position des
-- Fensters gesetzt.
-- 
-- @param frame Fenster, das konfiguriert werden soll
function SA_GUI_LOCAL:CreateWindow(frame)
	frame:ClearAllPoints()
	frame:SetWidth(1000) --Breite in px
	frame:SetHeight(500) -- Hoehe in px
	frame.x = 0
	frame.y = 50
	frame:SetPoint("CENTER",frame.x,frame.y)
	
	frame:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 20,
	insets = {left = 2, right = 2, top = 2, bottom = 2}
	})
	
	frame:SetToplevel(false) -- set to top level
	
	frame:Hide() -- hide at beginning, show by slashcommand or clicking on minimapbutton
	
	return (frame)
end


--- Erstellen des Schriftzugs am Hauptfenster
--
-- @param frame Fenster fuer den der Schriftzug erstellt werden soll
function SA_GUI_LOCAL:CreateTitleBar(frame)
	local titleBG = frame:CreateTexture(nil,"ARTWORK");
	titleBG:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
    titleBG:SetWidth(500);
    titleBG:SetHeight(80);
    titleBG:SetPoint("TOP", frame, 0, 20);
    frame.texture = MF_titleBG;
end

--- Die Funktion erstellt einen einen Button
--
-- @param frame Fenster in dem der Button erstellt werden soll.
-- @param name Name des Button´s (ACHTUNG! MUSS GLOBAL EINDEUTIG SEIN)
-- @param text Text der auf dem Button angezeigt werden soll 
-- @param width Breite des Button´s
-- @param height: Hoehe des Button´s
-- @param position Positionierung des Button´s auf dem Fenster
-- @param x Verschieben der Position in X-Richtung
-- @param y Verschieben der Position in Y-Richtung
-- @param template Gibt den Typ des Button´s an
-- @return Referenz auf den erzeugten Button
function SA_GUI_LOCAL:CreateButton(frame, name, text, width, height, position, x, y, template)
	if template == nil then
		template = "OptionsButtonTemplate"
	end
	if position == nil then
		position = "TOPLEFT"
	end
	-- create CloseButton
	if template == "UIPanelCloseButton" then -- close button
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(position, frame, position, x, y)
		-- when click on Button Hide frame
		button:SetScript("OnClick", function (self, button)
			if button == "LeftButton" then
				frame:Hide()
			end
		end)
	else -- create another button
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(position, x, y)
		button:SetWidth(width)
		button:SetHeight(height)
		button:SetText(text)
	end
	
	return (button)
end

--- Erstellt einen Text auf einem uebergebenen Fenster
--
-- @param frame Fenster auf dem der Text erstellt werden soll
-- @param name Name der Schriftart die genutzt werden soll
-- @param text Text der auf der grafischen Oberflaeche angezeigt werden soll
-- @param position Position auf dem Fenster (bsp. "TOPLEFT", "LEFT" usw.) 
-- @param x Verschieben des Texts von der Position ausgehend in X-Richtung 
-- @param y Verschieben des Texts von der Position ausgehend in Y-Richtung 
-- @param size Groesse der Schriftart
-- @return Referenz auf den Schriftzug
function SA_GUI_LOCAL:CreateFont(frame, name, text, position, x, y, size)
	if size == nil then
		size = 15
	end
	if position == nil then
		position = "TOP"
	end
	
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint(position, x, y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	
	return (fontString)
end

--- Versteckt bzw. Zeigt die Grafische Oberflaeche 
function SA_GUI:Toggle()
	if mainFrame:IsShown() then
		mainFrame:Hide()
	else
		mainFrame:Show()
	end
end

--- Setzt den Frame auf den Ursprungszustand zurueck 
function SA_GUI_LOCAL:ResetFrames()
	if SA_GUI.frame then
		SA_GUI.frame:ClearAllPoints()
		SA_GUI.frame:SetPoint("CENTER", SA_GUI.frame.x, SA_GUI.frame.y)
	end
end

