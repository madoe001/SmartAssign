-- Author: Bartlomiej Grabelus (10044563)
-- Components: This Class creates a editbox, which is also called textfield in other programming languages.
--			   It is global

local _G = _G
local SA_EditBox = _G.GUI.SA_EditBox
local GUIL = _G.GUI.Locales

-- for failurehandling
local assert, type = assert, type

-- SA_EditBox:SetPoint(): To set the Point of the EditBox(TextField) outside the Class
--
-- framePosition: Region of the Frame
-- relativeToFrame: relative to which Frame want to position
-- relativePos: relative to the Region of the Frame, to which want to position
-- x: x movement of the Frame
-- y: y movement of the Frame
--
-- author: Bartlomiej Grabelus (10044563)
function SA_EditBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

-- ConfigLabel(): Configuration of label with text and textcolor
--
-- text: which want to set
-- r: red
-- g: green
-- b: blue
-- a: alpha
--
-- author: Bartlomiej Grabelus (10044563)
local function ConfigLabel(self, text, r, g, b, a)
	self.label = self:CreateFontString("EditBox-label", "ARTWORK", "GameFontNormalSmall")
	self.label:SetHeight(25)
	self.label:SetTextColor(r, g, b, a)
	self.label:SetText(GUIL[text])
	self.label:SetPoint("LEFT", self, "LEFT", 0, 0)
end


-- ConfigEditBo(): Configuration of the editbox
--
-- clear all points of the frame.
-- Set to one line editbox and no autofocus
-- And set the Script for OnHide Event, where set a label
--
-- author: Bartlomiej Grabelus (10044563)
local function ConfigEditBox(self)
	self:ClearAllPoints()
	self:SetMultiLine(false)
	self:SetAutoFocus(false)
	self:ClearFocus() 
	self:EnableMouse(true)
	self:SetHeight(25)
	
	self:SetScript("OnHide", function(self)
	self.label:SetText("")
		if self.inputType == "string" and self.usedFor == "spell" then
				ConfigLabel(self, "[SpellID] text", 0.5, 0.5, 0.5, 0.8)
		elseif inputType == "string" and EditBox.usedFor == "name" then
				ConfigLabel(self, "name", 0.5, 0.5, 0.5, 0.8)
		elseif inputType == "string" and EditBox.usedFor == "phasename" then
				ConfigLabel(self, "phasename(s)", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
		elseif self.inputType == "number" and self.usedFor == "timer" then
				ConfigLabel(self, "Time in sec", 0.5, 0.5, 0.5, 0.8)
		elseif self.inputType == "number" and self.usedFor == "cooldown" then
				ConfigLabel(self, "cooldown(s) in sec", 0.5, 0.5, 0.5, 0.8)
		end
		self:SetText("")
	end)
end

-- CreateEditBox(): Creation function for the editbox
--
-- create a editbox frame and set the inputType of the editbox.
-- call the config function, to configurate the editbox.
--
-- frame: Parent frame
-- inputType: which type of editbox(number, string)
--
-- author: Bartlomiej Grabelus (10044563)
local function CreateEditBox(frame, name, inputType, usedFor)
	local EditBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")

	EditBox.inputType = inputType -- determinates if inputType is string or number
	EditBox.usedFor = usedFor

	ConfigEditBox(EditBox)
	-- check which inputType
	if inputType == "number" and EditBox.usedFor == "timer" then
		EditBox:SetWidth(frame:GetWidth() * 0.05)
		EditBox:SetNumeric(true) -- set only numeric input
		ConfigLabel(EditBox, "Time in sec", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
	elseif inputType == "number" and EditBox.usedFor == "cooldown" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		EditBox:SetNumeric(true) -- set only numeric input
		ConfigLabel(EditBox, "cooldown(s) in sec", 0.5, 0.5, 0.5, 0.8)
	elseif inputType == "string" and EditBox.usedFor == "spell" then
		EditBox:SetWidth(frame:GetWidth() * 0.2)
		ConfigLabel(EditBox, "[SpellID] text", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
	elseif inputType == "string" and EditBox.usedFor == "name" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		ConfigLabel(EditBox, "name", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
	elseif inputType == "string" and EditBox.usedFor == "phasename" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		ConfigLabel(EditBox, "phasename(s)", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
	end
	
	-- when the text inside the editbox changes
	EditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then -- if the user has made a input in the editbox
			if self.inputType == "number" then
				if self:GetText() ~= "" then -- when empty
					if tonumber(self:GetText()) <= 0 then -- and the number is smaller than/equal 0 set to ""
						self:SetText("")
					else
						self:SetText(self:GetText())
					end
				elseif self.inputType == "string" then -- elseif the inputType is string than set the text inside the editbox 
					self:SetText(self:GetText())       -- to the input of the user
				end
			end
			self.label:SetText("")
			if string.len(self:GetText()) == 0 then -- when the editbox is empty set the configurated label
				if self.inputType == "string" and self.usedFor == "spell" then
					ConfigLabel(self, "[SpellID] text", 0.5, 0.5, 0.5, 0.8)
				elseif inputType == "string" and EditBox.usedFor == "name" then
					ConfigLabel(self, "name", 0.5, 0.5, 0.5, 0.8)
				elseif inputType == "string" and EditBox.usedFor == "phasename" then
					ConfigLabel(self, "phasename(s)", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
				elseif self.inputType == "number" and self.usedFor == "timer" then
					ConfigLabel(self, "Time in sec", 0.5, 0.5, 0.5, 0.8)
				elseif self.inputType == "number" and self.usedFor == "cooldown" then
					ConfigLabel(self, "cooldown(s) in sec", 0.5, 0.5, 0.5, 0.8)
				end
			end
		end
	end)
	return EditBox
end


-- SA_EditBox:SetMaxLetters(): Setter for setting the maximum of allowed text
--
-- assertion: if the maximum which want to set is lower than/equal 0
--
-- self: on which want to set max
-- max: the max value
--
-- author: Bartlomiej Grabelus (10044563)
function SA_EditBox:SetMaxLetters(self, max)
	assert(max > 0, GUIL["'max' must be greater than 0."])
	self:SetMaxLetters(max)
end

-- SA_EditBox:LoadEditBox(): Loader for the editbox
--
-- assertion: if the inputType is not string or number
--
-- frame: Parent frame
-- inputType: of the editbox 
--
-- author: Bartlomiej Grabelus (10044563)
function SA_EditBox:LoadEditBox(frame, name, inputType, usedFor)
	assert((inputType == "string" or inputType == "number"), GUIL["'inputType' must be string or number."])
	return CreateEditBox(frame, name, inputType, usedFor)
end
