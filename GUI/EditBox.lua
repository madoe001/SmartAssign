local _G = _G
local SA_EditBox = _G.GUI.SA_EditBox
local SAL = _G.GUI.Locales

-- for failurehandling
local assert, type = assert, type

-- setter for man. setting the position of the editbox
function SA_EditBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	EditBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

local function CreateEditBox(frame, inputType)
	if not EditBox then
	EditBox = CreateFrame("EditBox", "EditBox", frame, "InputBoxTemplate")
	end
	EditBox.inputType = inputType -- determinates if inputType is string or number

	ConfigEditBox()
	-- check which inputType
	if inputType == "number" then
		EditBox:SetWidth(frame:GetWidth() * 0.05)
		EditBox:SetNumeric(true)
		ConfigLabel("Time in sec", 0.5, 0.5, 0.5, 0.8)
	elseif inputType == "string" then
		EditBox:SetWidth(frame:GetWidth() * 0.2)
		ConfigLabel("[SpellID] text", 0.5, 0.5, 0.5, 0.8)
	end
	
	-- when the text inside the editbox changes
	EditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then
			if self.inputType == "number" then
				if self:GetText() ~= "" then
					if tonumber(self:GetText()) <= 0 then
						self:SetText("")
					else
						self:SetText(self:GetText())
					end
				elseif self.inputType == "string" then
					self:SetText(self:GetText())
				end
			end
			self.label:SetText("")
			if string.len(self:GetText()) == 0 then 
				if self.inputType == "string" then
					ConfigLabel("[SpellID] text", 0.5, 0.5, 0.5, 0.8)
				elseif self.inputType == "number" then
					ConfigLabel("Time in sec", 0.5, 0.5, 0.5, 0.8)
				end
			end
		end
	end)
	
	return EditBox
end

-- configure label with text and textcolor
function ConfigLabel(text, r, g, b, a)
	EditBox.label = EditBox:CreateFontString("EditBox-label", "ARTWORK", "GameFontNormalSmall")
	EditBox.label:SetHeight(25)
	EditBox.label:SetTextColor(r, g, b, a)
	EditBox.label:SetText(SAL[text])
	EditBox.label:SetPoint("LEFT", EditBox, "LEFT", 0, 0)
end

-- configure main things for the editbox
function ConfigEditBox()
	EditBox:ClearAllPoints()
	EditBox:SetMultiLine(false)
	EditBox:SetAutoFocus(false)
	EditBox:EnableMouse(true)
	EditBox:SetHeight(25)
	
	EditBox:SetScript("OnHide", function(self)
	self.label:SetText("")
		if self.inputType == "string" then
				ConfigLabel("[SpellID] text", 0.5, 0.5, 0.5, 0.8)
		elseif self.inputType == "number" then
				ConfigLabel("Time in sec", 0.5, 0.5, 0.5, 0.8)
		end
		self:SetText("")
	end)
end

-- setter for max letters
function SA_EditBox:SetMaxLetters(self, max)
	assert(max > 0, SAL["'max' must be higher then 0."])
	self:SetMaxLetters(max)
end

function SA_EditBox:LoadEditBox(frame, inputType)
	assert((inputType == "string" or inputType == "number"), SAL["'inputType' must be string or number."])
	return CreateEditBox(frame, inputType)
end