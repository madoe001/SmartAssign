-- Author: Bartlomiej Grabelus (10044563)
-- Description: This Class creates a frame for the player, in which the player can delete or create a new phase for a boss
--				of a instance.

-- Global vars --
local _G = _G

local GUI = _G.GUI
local SA_PhaseFrame = GUI.SA_PhaseFrame
local EditBox = GUI.SA_EditBox
local CheckBox = GUI.SA_CheckBox
local GUIL = GUI.Locales

-- vars
local boss

-- set the buttonwidth dependent to the language of the player, which is set ingame
local buttonWidth = 0
if GetLocale() == "enUS" or GetLocale() == "enGB" then
	buttonWidth = 60
elseif GetLocale() == "deDE" then
	buttonWidth = 84
else
	buttonWidth = 100
end

-- Popup for asking if want to apply
StaticPopupDialogs["REALLY_APPLY"] = {
  text = GUIL["Do you really want to create this phase: %s ?"],
  button1 = GUIL["Yes"],
  button2 = GUIL["No"],
  OnAccept = function()
	if phaseFrame.firstPhaseCB:GetChecked() == false then
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

-- Popup for asking if want to delete
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

-- Popup for asking if want to delete
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


-- SA_Phase<Frame:CreateGUI(): creates the frame to create and delete phase
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
function SA_PhaseFrame:CreateGUI(frame)
	if not phaseFrame then
		CreateWindow(frame)
	end
	
	CreateComponents(phaseFrame)
	ConfigComponents(phaseFrame)
end

-- CreateWindow(): creates the main frame
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
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
		phaseFrame:SetToplevel(true) -- set to top level
		
		--phaseFrame:Hide()
end

-- CreateComponents(): creates the components for the main frame.
--					   e.g the dropdowns for the content, instance, boss and abilities
--					   also three lines, which seperate the components.
--					   at the top we have some editboxes and checkboxes, on the left side the dropdowns
--					   and at the bottom we have two button (apply and delete).
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
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

-- ConfigComponents(): for configurate the components
--					   for the buttons we set event handler function.
--					   on apply we create a new ability
--					   on delete we delete the ability
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
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

-- SetScripts(): Sets all scripts for the components
--
-- author: Bartlomiej Grabelus (10044563)
function SetScripts()
	applyPhaseButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
			if ValidForCreateAbility() then -- check if all is valid
				if IsOneDifficultyChecked() then -- check if a dificulty is checked
					StaticPopup_Show("REALLY_APPLY", phaseFrame.phaseNameEB:GetText())
				else
					StaticPopup_Show("INFO", GUIL["You should tick a difficulty!"])
				end
			else
				if phaseFrame.phaseNameEB:GetText() == "" then -- if empty
					phaseFrame.phaseNameEB.label:SetTextColor(1, 0, 0, 1)
				end
				if phaseFrame.triggerTypeEB:GetText() == "" then -- if empty
					phaseFrame.triggerTypeEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- if empty
				if phaseFrame.triggerEB:GetText() == "" then 
					phaseFrame.triggerEB.label:SetTextColor(1, 0, 0, 1)
				end
				-- check if have not checked first pahse and no selected phase
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

-- CreateButton(): creates a button
--
-- frame: parent frame
-- name: name of button
-- text: text which is set in button
-- width: buttonwidth
-- height: buttonheight
-- position: where to position the button
-- x: x movement
-- y: y movement
-- template: template of buttons
--
-- author: Bartlomiej Grabelus (10044563)
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

--- CreateLine(): function to create a line
-- if horizontal: height = 1 to 2
-- if vertical: width = 1 to 2
--
-- region: where to position
-- frame: relative to which frame
-- x: x movement
-- y: y movement
--
-- author: Bartlomiej Grabelus (10044563)
function CreateLine(parent, name,width, height, region, frame, x, y)
	local line = parent:CreateTexture(name)
	line:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    
	line:SetSize(width , height)
	line:SetPoint(region, frame, x, y)
end

-- CreateFont(): create a Font
--
-- frame: Parent frame
-- name: name of font
-- text: which want to set
-- position: region, where want to position
-- x: x movement
-- y: y movement
-- size: size of font
--
-- author: Bartlomiej Grabelus (10044563)
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

-- ValidForCreateAbility(): Checks if the player has typed in a name, phaseText and trigger
--
-- author: Bartlomiej Grabelus (10044563)
function ValidForCreateAbility()
	return(phaseFrame.phaseNameEB:GetText() ~= "" and phaseFrame.triggerTypeEB:GetText() ~= "" and phaseFrame.triggerEB:GetText() ~= "") 
end

-- IsOnlyOneDifficultyChecked(): Checks if the player has checked only one difficulty
--
-- author: Bartlomiej Grabelus (10044563)
function IsOnlyOneDifficultyChecked()
	return((not phaseFrame.heroicCB:GetChecked() and not phaseFrame.mythicCB:GetChecked() and phaseFrame.normalCB:GetChecked())
		or (phaseFrame.heroicCB:GetChecked() and not phaseFrame.mythicCB:GetChecked() and not phaseFrame.normalCB:GetChecked())
		or (not phaseFrame.heroicCB:GetChecked() and phaseFrame.mythicCB:GetChecked() and not phaseFrame.normalCB:GetChecked()))
end

-- IsOneDifficultyChecked(): Checks if the player has checked a difficulty or not
--
-- author: Bartlomiej Grabelus (10044563)
function IsOneDifficultyChecked()
	return (phaseFrame.heroicCB:GetChecked() or phaseFrame.mythicCB:GetChecked() or phaseFrame.normalCB:GetChecked())
end
