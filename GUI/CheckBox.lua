--Author: Bartlomiej Grabelus

local _G = _G

-- Localization
local GUIL = _G.GUI.Locales

-- Get Global table for CheckBox
local SA_CheckBox = _G.GUI.SA_CheckBox

-- for failurehandling
local assert, type = assert, type

-- SA_CheckBox:SetPoint(): To set the Point of the CheckBox outside the Class
--
-- framePosition: Region of the Frame
-- relativeToFrame: relative to which Frame want to position
-- relativePos: relative to the Region of the Frame, to which want to position
-- x: x movement of the Frame
-- y: y movement of the Frame
function SA_CheckBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

-- CreateCheckBox(): Creates a CheckBox
--
-- First creation of the frame, than clearing all points of the frame.
-- Than create a label with the text.
--
-- frame: Parent frame
-- checkboxText: Text which want to set on the right side
local function CreateCheckBox(frame, checkboxText, name)
	local CheckBoxFrame = CreateFrame("CheckButton", name, frame, "UICheckButtonTemplate")

	CheckBoxFrame:ClearAllPoints()
	CheckBoxFrame:SetText(checkboxText)
	
	CheckBoxFrame.label = CheckBoxFrame:CreateFontString("CheckBoxFrame-label", "ARTWORK", "GameFontNormalSmall")
	CheckBoxFrame.label:SetHeight(25)
	CheckBoxFrame.label:SetText(checkboxText)
	CheckBoxFrame.label:SetPoint("LEFT", CheckBoxFrame, "RIGHT", 0,0)
	
	return CheckBoxFrame
end

-- SA_CheckBox:LoadCheckBox(): load the CheckBox
--
-- assertion: when the text isn´t a string
--
-- frame: Parent frame
-- checkboxText: the text which want to set
function SA_CheckBox:LoadCheckBox(frame, checkboxText, name)
	assert(type(checkboxText) == "string", GUIL["'checkboxText' must be a string."])
	return CreateCheckBox(frame, checkboxText, name)
end

-- SA_CheckBox:GetChecked(): returns boolean, if the checkbox is checked
function SA_CheckBox:GetChecked()
print("HH")
	return self:GetChecked()
end
