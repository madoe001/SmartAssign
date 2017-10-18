--- Beschreibung: Diese Klasse stellt ein PhaseFrame dar, in welchen der Spieler eine Phase für einen Boss anlegen oder löschen kann.
--
-- @modul PhaseFrame
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local GUI = _G.GUI
local SA_PhaseFrame = GUI.SA_PhaseFrame
local EditBox = GUI.SA_EditBox
local CheckBox = GUI.SA_CheckBox
local GUIL = GUI.Locales

--  Variable
local boss

--- Setze die buttonwidth abhängig zu der Sprach, da sich die Länge eines Wortes unterscheidet
local buttonWidth = 0
if GetLocale() == "enUS" or GetLocale() == "enGB" then
	buttonWidth = 60
elseif GetLocale() == "deDE" then
	buttonWidth = 84
else
	buttonWidth = 100
end

--- Ein Popup, um zu Fragen ob der Spieler wirklich eine Phase anlegen möchte.
StaticPopupDialogs["REALLY_APPLY"] = {
  text = GUIL["Do you really want to create this phase: %s ?"],
  button1 = GUIL["Yes"],
  button2 = GUIL["No"],
  OnAccept = function()
	if phaseFrame.firstPhaseCB:GetChecked() == false then -- Prüfe ob es die erste Phase ist
		createPhase(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID, phaseFrame.phaseNameEB:GetText(), UIDropDownMenu_GetText(prevPhaseFrameDropDown), phaseFrame.triggerEB:GetText(), phaseFrame.triggerTypeEB:GetText(), phaseFrame.mythicCB:GetChecked(), phaseFrame.heroicCB:GetChecked(), phaseFrame.normalCB:GetChecked())
	else
		createPhase(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID, phaseFrame.phaseNameEB:GetText(), nil, phaseFrame.triggerEB:GetText(), phaseFrame.triggerTypeEB:GetText(), phaseFrame.heroicCB:GetChecked(), phaseFrame.normalCB:GetChecked())
	end
  end,
  OnCancel = function (_,reason)
      if reason == "clicked" then
          StaticPopup_Hide("REALLY_APPLY")
      end;
  end,
  whileDead = true,
  hideOnEscape = true,
}

--- Ein Popup, um zu Fragen ob der Spieler wirklich die Phase löschen möchte
StaticPopupDialogs["REALLY_DELETE"] = {
  text = GUIL["Do you really want to delete this phase: %s ?"],
  button1 = GUIL["Yes"],
  button2 = GUIL["No"],
  OnAccept = function()
      
  end,
  OnCancel = function (_,reason)
      if reason == "clicked" then
          StaticPopup_Hide("REALLY_APPLY")
      end;
  end,
  whileDead = true,
  hideOnEscape = true,
}

--- Ein Popup, um Informationen zu zeigen. Beispielsweise, wenn der Spieler keinen Namen für eine Phase eingegeben hat.
StaticPopupDialogs["INFO"] = {
  text = "%s",
  button1 = GUIL["Ok"],
  OnAccept = function()
      StaticPopup_Hide("INFO")
  end,
  OnCancel = function (_,reason)
      if reason == "timeout" then
          StaticPopup_Hide("INFO")
      end;
  end,
  timeout = 20,
  whileDead = true,
  hideOnEscape = true,
}


--- Erstellt das Frame und dessen Komponenten, welche dann am Ende auch Konfiguriert werden.
--
-- @tparam Frame frame Ist das Elternframe.
function SA_PhaseFrame:CreateGUI(frame)
	if not phaseFrame then
		CreateWindow(frame)
	end
	
	CreateComponents(phaseFrame)
	ConfigComponents(phaseFrame)
end

--- Erstellt das Hauptfenster für die AbilityFrame.
--
-- @tparam Frame frame Ist das Elternframe.
function CreateWindow(frame)
		CreateFrame("Frame", "phaseFrame", frame)
		phaseFrame:SetWidth(600)
		phaseFrame:SetHeight(400)
		phaseFrame:SetPoint("CENTER",0,0)
		phaseFrame:SetBackdrop({
			bgFile="Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
			});
		phaseFrame:SetBackdropColor(0.0,0.0,0.0,1.0)
		phaseFrame:SetToplevel(true) -- Setze top level
		
		--phaseFrame:Hide()
end

--- Erstellt alle benötigten Komponenten, welche im Hauptfenster angezeigt werden.
--	Es werden DropDowns für die Auswahl des Contents, der Instanz, sowie des Bosses, seiner Fähigkeiten und seinen Phasen erstellt.
--	Sowie zwei Linien, welche in dem Frame eine räumliche Trennung bewirken.
--	Auf der linken Seite sind die DropDowns positioniert.
--	Und auf der rechten Seite haben wir ein paar EditBoxen und CheckBoxen.
--  Unten gibt es zwei Buttons, um die Fähigkeit zu löschen oder zu erstellen.
--
-- @tparam Frame parent Ist das Elternframe.
function CreateComponents(frame)
	boss = BossSelectFrame:new_BossSelectFrame(frame, "Phase", 200, phaseFrame:GetHeight() - 45, "TOPLEFT", 10, 0)
	boss.frame:SetBackdrop({
		bgFile="",
		edgeFile = "", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	createPhaseDropDown(boss.frame,  0, -100, 200 * 0.8, "phaseFrameDropDown")
	
	CreateLine(frame, "bottomLine", frame:GetWidth()-28, 1, "BOTTOM", frame, 0, 50)
	CreateLine(frame, "delimiterLine", 1, frame:GetHeight() * 0.7, "TOPRIGHT", boss.frame, 5, -60)
	
	-- EditBoxes
	frame.phaseNameEB = EditBox:LoadEditBox(frame, "phaseNameEditBox", "string", "name")
	createPhaseDropDown(frame.phaseNameEB,  0, -40, 200 * 0.8, "prevPhaseFrameDropDown")
	frame.triggerTypeEB = EditBox:LoadEditBox(frame, "triggerTypeEditBox", "string", "phaseText")
	frame.triggerEB = EditBox:LoadEditBox(frame, "triggerEditBox", "string", "trigger")
	
	-- CheckBoxes
	frame.firstPhaseCB = CheckBox:LoadCheckBox(frame, "first Phase")
	frame.mythicCB = CheckBox:LoadCheckBox(frame, "mythic")
	frame.heroicCB = CheckBox:LoadCheckBox(frame, "heroic")
	frame.normalCB = CheckBox:LoadCheckBox(frame, "normal")
		
	CreateButton(frame, "applyPhaseButton", GUIL["Apply"], buttonWidth, 25, "BOTTOMLEFT", 20, 20, nil)
	CreateButton(applyPhaseButton, "deletePhaseButton", GUIL["Delete"], buttonWidth, 25, "RIGHT", buttonWidth + 10, 0, nil)
	
	CreateButton(frame, "closePhaseButton", nil, 34, 34, "TOPRIGHT", -4, -4, "UIPanelCloseButton")
end

--- Mithilfe dieser Funktion werden die Komponenten konfiguriert.
--	Es wird ein EventHandler für die Buttons gesetzt.
--	Wenn der Benutzer auf Anlegen drückt, wird eine Phase angelegt.
--  Wenn der Benutzer auf Löschen drückt, wird die Phase gelöscht.
--
-- @tparam Frame frame Ist das Elternframe.
function ConfigComponents(frame)
	frame.phaseNameEB:SetPoint("TOPLEFT", delimiterLine, "TOPRIGHT", 20, 0)
	frame.triggerTypeEB:SetPoint("TOP", prevPhaseFrameDropDown, "BOTTOM", 0, -10)
	frame.triggerEB:SetPoint("LEFT", frame.triggerTypeEB, "RIGHT", 35, 0)
	frame.firstPhaseCB:SetPoint("LEFT", prevPhaseFrameDropDown, "RIGHT", 10, 0)
	frame.mythicCB:SetPoint("BOTTOMLEFT", delimiterLine, "BOTTOMLEFT", 20, 10)
	frame.heroicCB:SetPoint("LEFT", frame.mythicCB, "LEFT", 90, 0)
	frame.normalCB:SetPoint("LEFT", frame.heroicCB, "LEFT", 90, 0)
	SetScripts()
end

--- Setzt alle benötigten EventHandlerfunktionen für die Events.
function SetScripts()
	applyPhaseButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
			if ValidForCreateAbility() then -- Prüfe ob alles Vollständig ist
				if IsOneDifficultyChecked() then -- Prüfe ob mindestens ein Schwierigkeitsgrad gewählt
					StaticPopup_Show("REALLY_APPLY", phaseFrame.phaseNameEB:GetText())
				else
					StaticPopup_Show("INFO", GUIL["You should tick a difficulty!"])
				end
			else
				if phaseFrame.phaseNameEB:GetText() == "" then -- Wenn leer
					phaseFrame.phaseNameEB.label:SetTextColor(1, 0, 0, 1)
				end
				if phaseFrame.triggerTypeEB:GetText() == "" then -- Wenn leer
					phaseFrame.triggerTypeEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- Wenn leer
				if phaseFrame.triggerEB:GetText() == "" then 
					phaseFrame.triggerEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- Prüfe ob es die erste Phase ist und die Eingabe entsprechend richtig ist
				if UIDropDownMenu_GetSelectedID(prevPhaseFrameDropDown) and phaseFrame.firstPhaseCB:GetChecked() == true then
					StaticPopup_Show("INFO", GUIL["Is it the first Phase?"])
				end
				if not UIDropDownMenu_GetSelectedID(prevPhaseFrameDropDown) and phaseFrame.firstPhaseCB:GetChecked() == false then
					StaticPopup_Show("INFO", GUIL["You should check first phase?"])
				end
			end
		end
	end)
	deletePhaseButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
		end
	end)
end

--- Erstellt ein Button.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam string name Name des Buttons
-- @tparam string text Text welcher im Button dargestellt wird
-- @tparam int width Buttonbreite
-- @tparam int height Buttonhöhe
-- @tparam string position Wo der Button positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
-- @tparam string template Name des Templates
function CreateButton(frame, name, text, width, height, position, x, y, template)
	if template == nil then
		template = "OptionsButtonTemplate"
	end
	if position == nil then
		position = "TOPLEFT"
	end
	local button = CreateFrame("Button", name, frame, template)
	button:SetPoint(position, x, y)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetText(text)
	
	return (button)
end

--- Funktion um eine Linie mithilfe von einer Textur zu erstellen.
-- Wenn die Linie Horizontal dargestellt werden soll: height = 1 oder 2.
-- Wenn die Linie Vertikal dargestellt werden soll: width = 1 oder 2.
--
-- @tparam Frame parent Ist das Elternframe.
-- @tparam string name Der Name der Texture
-- @tparam int width Linienbreite
-- @tparam int height Linienhöhe
-- @tparam string region Region wo die Linie ausgerichtet werden soll
-- @tparam string frame Frame an welchen relativ positioniert werden soll
-- @tparam int x Bewegung der Linie in x-Richtung
-- @tparam int y Bewegung der Linie in y-Richtung
function CreateLine(parent, name,width, height, region, frame, x, y)
	local line = parent:CreateTexture(name)
	line:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    
	line:SetSize(width , height)
	line:SetPoint(region, frame, x, y)
end

--- Erstellt einen Text(FontString).
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string name Name des FontStrings
-- @tparam string text Text welcher über den FontString dargestellt werden soll
-- @tparam string position Wo der Text positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
-- @tparam int size Größe der Schrift
function CreateFont(frame, name, text, position, x, y, size)
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

--- Prüfe ob der Spieler einen Namen, phaseText und trigger eingegeben hat.
function ValidForCreateAbility()
	return(phaseFrame.phaseNameEB:GetText() ~= "" and phaseFrame.triggerTypeEB:GetText() ~= "" and phaseFrame.triggerEB:GetText() ~= "") 
end

--- Prüft ob der Spieler nur einen Schwierigkeitsgrad ausgewählt hat.
function IsOnlyOneDifficultyChecked()
	return((not phaseFrame.heroicCB:GetChecked() and not phaseFrame.mythicCB:GetChecked() and phaseFrame.normalCB:GetChecked())
		or (phaseFrame.heroicCB:GetChecked() and not phaseFrame.mythicCB:GetChecked() and not phaseFrame.normalCB:GetChecked())
		or (not phaseFrame.heroicCB:GetChecked() and phaseFrame.mythicCB:GetChecked() and not phaseFrame.normalCB:GetChecked()))
end

--- Prüft ob der Spieler mindestens einen Schwierigkeitsgrad ausgewählt hat.
function IsOneDifficultyChecked()
	return (phaseFrame.heroicCB:GetChecked() or phaseFrame.mythicCB:GetChecked() or phaseFrame.normalCB:GetChecked())
end
