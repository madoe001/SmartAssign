local _G = _G

local SAL = _G.GUI.Locales
local SA_CheckBox = _G.GUI.SA_CheckBox

-- for failurehandling
local assert, type = assert, type

function SA_CheckBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	CheckBoxFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

local function CreateCheckBox(frame, checkboxText)
	local CheckBoxFrame = CreateFrame("CheckButton", "CheckButton", frame, "UICheckButtonTemplate")

	CheckBoxFrame:ClearAllPoints()
	CheckBoxFrame:SetText(checkboxText)
	
	CheckBoxFrame.label = CheckBoxFrame:CreateFontString("CheckBoxFrame-label", "ARTWORK", "GameFontNormalSmall")
	CheckBoxFrame.label:SetHeight(25)
	CheckBoxFrame.label:SetText(checkboxText)
	CheckBoxFrame.label:SetPoint("LEFT", CheckBoxFrame, "RIGHT", 0,0)
	
	return CheckBoxFrame
end

function SA_CheckBox:LoadCheckBox(frame, checkboxText)
	assert(type(checkboxText) == "string", SAL["'checkboxText' must be a string."])
	return CreateCheckBox(frame, checkboxText, x, y)
end

function SA_CheckBox:GetChecked()
	return CheckBoxFrame:GetChecked()
end
