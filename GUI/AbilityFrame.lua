--- Beschreibung: Diese Klasse stellt ein Frame dar, im welchem der Spieler eine Fähigkeit für eine Boss löschen oder erstellen kann.
--
-- @modul AbilityFrame
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local GUI = _G.GUI
local SA_CreateAbilityFrame = GUI.SA_CreateAbilityFrame
local EditBox = GUI.SA_EditBox
local CheckBox = GUI.SA_CheckBox
local GUIL = GUI.Locales

--  Variable
local boss

--- Setze die buttonwidth abhängig zu der Sprache, da sich die Länge eines Wortes unterscheidet
local buttonWidth = 0
if GetLocale() == "enUS" or GetLocale() == "enGB" then
	buttonWidth = 60
elseif GetLocale() == "deDE" then
	buttonWidth = 84
else
	buttonWidth = 100
end

--- Ein Popup, um zu Fragen ob der Spieler wirklich eine Fähigkeit anlegen möchte.
StaticPopupDialogs["REALLY_APPLY"] = {
  text = GUIL["Do you really want to create this ability/ies: %s ?"],
  button1 = GUIL["Yes"],
  button2 = GUIL["No"],
  OnAccept = function()
	if frame.boundCB:GetChecked() == false then
		createAbility(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID, frame.abilityNameEB:GetText(), frame.cooldownEB:GetText(), nil, frame.mythicCB:GetChecked(), frame.heroicCB:GetChecked(), frame.normalCB:GetChecked(), frame.loopCB:GetChecked(), frame.resetCB:GetChecked())
	else
		createAbility(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID, frame.abilityNameEB:GetText(), frame.cooldownEB:GetText(), frame.abilityPhaseNameEB:GetText(), frame.mythicCB:GetChecked(), frame.heroicCB:GetChecked(), frame.normalCB:GetChecked(), frame.loopCB:GetChecked(), frame.resetCB:GetChecked())
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

--- Ein Popup, um zu Fragen ob der Spieler wirklich die Fähigkeit löschen möchte.
StaticPopupDialogs["REALLY_DELETE"] = {
  text = GUIL["Do you really want to delete this ability: %s ?"],
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

--- Ein Popup, um Informationen zu zeigen. Beispielsweise, wenn der Spieler keinen Namen für eine Fähigkeit eingegeben hat.
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


--- Erstellt das Frame und dessen Komponenten, welche dann am Ende Konfiguriert werden.
--
-- @tparam Frame frame Ist das Elternframe.
function SA_CreateAbilityFrame:CreateGUI(frame)
	if not abilityFrame then
		CreateWindow(frame)
	end
	
	CreateComponents(abilityFrame)
	ConfigComponents(abilityFrame)
end

--- Erstellt das Hauptfenster für die AbilityFrame.
--
-- @tparam Frame frame Ist das Elternframe.
function CreateWindow(frame)
		CreateFrame("Frame", "abilityFrame", frame)
		abilityFrame:SetWidth(600)
		abilityFrame:SetHeight(400)
		abilityFrame:SetPoint("CENTER",0,0)
		abilityFrame:SetBackdrop({
			bgFile="Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
			});
		abilityFrame:SetBackdropColor(0.0,0.0,0.0,1.0)
		abilityFrame:SetToplevel(true) -- set to top level
		
	
end

--- Erstellt alle benötigten Komponenten, welche im Hauptfenster angezeigt werden.
--	Es werden DropDowns für die Auswahl des Contents, der Instanz, sowie des Bosses und seiner Fähigkeiten erstellt.
--	Sowie drei Linien, welche in dem Frame eine räumliche Trennung bewirken.
--	Oben im Frame wird ein Informationstext für den Spieler angezeigt, auf der linken Seite sind die DropDowns positioniert.
--	Und auf der rechten Seite haben wir ein paar EditBoxen und CheckBoxen.
--  Unten gibt es zwei Buttons, um die Fähigkeit zu löschen oder zu erstellen.
--
-- @tparam Frame frame Ist das Elternframe.
function CreateComponents(frame)
	boss = BossSelectFrame:new_BossSelectFrame(frame, "Ability", 200, abilityFrame:GetHeight() - 45, "TOPLEFT", 10, 0)
	boss.frame:SetBackdrop({
		bgFile="",
		edgeFile = "", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	createAbillityDropDown(boss.frame,  0, -100, 200 * 0.8, "abilityFrameDropDown")
	
	CreateLine(frame, "bottomLine", frame:GetWidth()-28, 1, "BOTTOM", frame, 0, 50)
	CreateLine(frame, "delimiterLine", 1, frame:GetHeight() * 0.7, "TOPRIGHT", boss.frame, 5, -60)
	CreateLine(frame, "TopLine", frame:GetWidth()-28, 1, "TOP", frame, 0, -55)
	
	frame.descText = CreateFont(frame, "descriptionFontString", GUIL["For more than one cooldown or phasename use a semicolon as delimiter"], "TOPLEFT", 20, -20, 14)
	
	-- EditBoxes
	frame.abilityNameEB = EditBox:LoadEditBox(frame, "abilityNameEditBox", "string", "name")
	frame.cooldownEB = EditBox:LoadEditBox(frame, "cooldownEditBox", "number", "cooldown")
	frame.abilityPhaseNameEB = EditBox:LoadEditBox(frame, "abilityPhaseNameEditBox", "string", "phasename")
	
	-- CheckBoxes
	frame.loopCB = CheckBox:LoadCheckBox(frame, "loop")
	frame.boundCB = CheckBox:LoadCheckBox(frame, "phasebound")
	frame.resetCB = CheckBox:LoadCheckBox(frame, "reset timer on phase")
	frame.mythicCB = CheckBox:LoadCheckBox(frame, "mythic")
	frame.heroicCB = CheckBox:LoadCheckBox(frame, "heroic")
	frame.normalCB = CheckBox:LoadCheckBox(frame, "normal")
		
	CreateButton(frame, "applyAbilityButton", GUIL["Apply"], buttonWidth, 25, "BOTTOMLEFT", 20, 20, nil)
	CreateButton(applyButton, "deleteAbilityButton", GUIL["Delete"], buttonWidth, 25, "RIGHT", buttonWidth + 10, 0, nil)
	
	CreateButton(frame, "closeAbilityButton", nil, 34, 34, "TOPRIGHT", -4, -4, "UIPanelCloseButton")
end

--- Mithilfe dieser Funktion werden die Komponenten konfiguriert.
--	Es wird ein EventHandler für die Buttons gesetzt.
--	Wenn der Benutzer auf Anlegen drückt, wird eine Fähigkeit angelegt.
--  Wenn der Benutzer auf Löschen drückt, wird die Fähigkeit gelöscht.
--
-- @tparam Frame frame Ist das Elternframe.
function ConfigComponents(frame)
	frame.descText:SetJustifyH("LEFT")
	frame.abilityNameEB:SetPoint("TOPLEFT", delimiterLine, "TOPRIGHT", 20, -36)
	frame.cooldownEB:SetPoint("TOP", frame.abilityNameEB, "BOTTOM", 0, -10)
	frame.abilityPhaseNameEB:SetPoint("TOP", frame.cooldownEB, "BOTTOM", 0, -10)
	frame.loopCB:SetPoint("LEFT", frame.cooldownEB, "RIGHT", 10, 0)
	frame.boundCB:SetPoint("LEFT", frame.abilityPhaseNameEB, "RIGHT", 10, 0)
	frame.resetCB:SetPoint("TOPLEFT", frame.abilityPhaseNameEB, "BOTTOMLEFT", 0, -12)
	frame.mythicCB:SetPoint("BOTTOMLEFT", delimiterLine, "BOTTOMLEFT", 20, 10)
	frame.heroicCB:SetPoint("LEFT", frame.mythicCB, "LEFT", 90, 0)
	frame.normalCB:SetPoint("LEFT", frame.heroicCB, "LEFT", 90, 0)
	SetScripts()
end

--- Setzt alle benötigten EventHandlerfunktionen für die Events.
function SetScripts()

	applyAbilityButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
			if ValidForCreateAbility() then -- Prüfe ob Eingabe gültig
				if IsOneDifficultyChecked() then -- Prüfe ob mindestens ein Schwierigkeitsgrad gewählt wurde
					StaticPopup_Show("REALLY_APPLY", abilityFrame.abilityNameEB:GetText())
				else
					StaticPopup_Show("INFO", GUIL["You should tick a difficulty!"])
				end
			else
				if abilityFrame.abilityNameEB:GetText() == "" then -- Wenn leer
					abilityFrame.abilityNameEB.label:SetTextColor(1, 0, 0, 1)
				end
				if abilityFrame.cooldownEB:GetText() == "" then -- Wenn leer
					abilityFrame.cooldownEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- Prüfe ob Phasengebunden und Eingabe getätigt wurde
				if abilityFrame.abilityPhaseNameEB:GetText() == "" and abilityFrame.boundCB:GetChecked() == true then 
					abilityFrame.abilityPhaseNameEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- Und ob nicht Phasengebunden
				if abilityFrame.abilityPhaseNameEB:GetText() ~= "" and abilityFrame.boundCB:GetChecked() == false then
					StaticPopup_Show("INFO", GUIL["Do you have forgotten to check phasebounded?"])
				end
			end
		end
	end)
	deleteAbilityButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
		end
	end)
end

--- Erstellt ein Button.
--
-- @tparam Frame frame Ist das Elternframe.
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
-- @tparam Frame frame Ist das Elternframe.
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

--- Prüfe, ob der Spieler einen Namen, Cooldown und ob der Spieler Phasengebunden angeklickt hat.
--	Wenn der Spieler Phasengebunden ausgewählt hat, dann muss der Spieler eine Phase eingeben.
function ValidForCreateAbility()
	return(abilityFrame.abilityNameEB:GetText() ~= "" and abilityFrame.cooldownEB:GetText() ~= "" 
		   and (abilityFrame.abilityPhaseNameEB:GetText() ~= "" and abilityFrame.boundCB:GetChecked() == true 
		   or abilityFrame.abilityPhaseNameEB:GetText() == "" and abilityFrame.boundCB:GetChecked() == false))
end

--- Prüft ob der Spieler nur einen Schwierigkeitsgrad ausgewählt hat.
function IsOnlyOneDifficultyChecked()
	return((not abilityFrame.heroicCB:GetChecked() and not abilityFrame.mythicCB:GetChecked() and abilityFrame.normalCB:GetChecked())
		or (abilityFrame.heroicCB:GetChecked() and not abilityFrame.mythicCB:GetChecked() and not abilityFrame.normalCB:GetChecked())
		or (not abilityFrame.heroicCB:GetChecked() and abilityFrame.mythicCB:GetChecked() and not abilityFrame.normalCB:GetChecked()))
end

--- Prüft ob der Spieler mindestens einen Schwierigkeitsgrad ausgewählt hat.
function IsOneDifficultyChecked()
	return (abilityFrame.heroicCB:GetChecked() or abilityFrame.mythicCB:GetChecked() or abilityFrame.normalCB:GetChecked())
end
