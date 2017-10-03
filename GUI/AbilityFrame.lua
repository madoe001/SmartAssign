-- Author: Bartlomiej Grabelus (10044563)
-- Description: This Class creates a frame for the player, in which the player can delete or create a new ability for a boss
--				of a instance.

-- Global vars --
local _G = _G

local GUI = _G.GUI
local SA_CreateAbilityFrame = GUI.SA_CreateAbilityFrame
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

-- SA_CreateAbilityFrame:CreateGUI(): creates the frame to create and delete abilities
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
function SA_CreateAbilityFrame:CreateGUI(frame)
	if not abilityFrame then
		CreateWindow(frame)
	end
	
	CreateComponents(abilityFrame)
	ConfigComponents(abilityFrame)
end

-- CreateWindow(): creates the main frame
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
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
		
		--abilityFrame:Hide()
end

-- CreateComponents(): creates the components for the main frame.
--					   e.g the dropdowns for the content, instance, boss and abilities
--					   also three lines, which seperate the components.
--					   at the top we have a description text with a information for the player, on the left side the dropdowns,
--					   on the right side we have some editboxes and checkboxes and at the bottom we have two button (apply and delete).
--
-- frame: parent frame
--
-- author: Bartlomiej Grabelus (10044563)
function CreateComponents(frame)
	boss = BossSelectFrame:new_BossSelectFrame(frame, 200, abilityFrame:GetHeight() - 45, "TOPLEFT", 10, 0)
	boss:SetBackdrop({
		bgFile="",
		edgeFile = "", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	createAbillityDropDown(boss,  0, -100, 200 * 0.8, "abilityFrameDropDown")
	
	CreateLine(frame, "bottomLine", frame:GetWidth()-28, 1, "BOTTOM", frame, 0, 50)
	CreateLine(frame, "delimiterLine", 1, frame:GetHeight() * 0.7, "TOPRIGHT", boss, 5, -60)
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
		
	CreateButton(frame, "applyButton", GUIL["Apply"], buttonWidth, 25, "BOTTOMLEFT", 20, 20, nil)
	CreateButton(applyButton, "deleteButton", GUIL["Delete"], buttonWidth, 25, "RIGHT", buttonWidth + 10, 0, nil)
	
	CreateButton(frame, "closeButton", nil, 34, 34, "TOPRIGHT", -4, -4, "UIPanelCloseButton")
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
	applyButton:SetScript("OnClick", function (self, button)
		if button == "LeftButton" then
			 createAbility(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID, frame.abilityNameEB:GetText(), frame.cooldownEB:GetText(), frame.boundCB:GetChecked(), frame.mythicCB:GetChecked(), frame.heroicCB:GetChecked(), frame.normalCB:GetChecked(), frame.loopCB:GetChecked(), frame.resetCB:GetChecked())
		end
	end)
	deleteButton:SetScript("OnClick", function (self, button)
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