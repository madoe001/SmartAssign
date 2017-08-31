local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

-- Create the full ScrollFrame
local function CreateScrollFrame(frame)
	if not ScrollFrame then
		ScrollFrame = CreateFrame("ScrollFrame", "ScrollFrame", frame)
	end
	ScrollFrame.buttons = {}
	
	ScrollFrame:SetPoint("TOPLEFT", 10, -10)
	ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
	ScrollFrame:SetWidth(frame:GetWidth() * 0.7)
	
	ScrollFrame.texture = ScrollFrame:CreateTexture()
	ScrollFrame.texture:SetAllPoints()
	ScrollFrame.texture:SetTexture(0, 0, 0, 0)
	
	CreateScrollBar(ScrollFrame)
	CreateContent(ScrollFrame, _G.Dungeons)
	
	return ScrollFrame
end

-- Create the ScrollBar for the ScrollFrame
function CreateScrollBar(frame)
	if not ScrollBar then
		ScrollBar = CreateFrame("Slider", "ScrollBar", ScrollFrame, "UIPanelScrollBarTemplate")
	end
	
	ScrollBar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -12, -16)
	ScrollBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -12, 16)
	
	ScrollBar:SetMinMaxValues(1, 100)
	ScrollBar:SetValueStep(1)
	ScrollBar.scrollStep = 1
	ScrollBar:SetValue(0)
	ScrollBar:SetWidth(16)
	ScrollBar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value) -- set to new value
	end)
	
	local ScrollBG = ScrollBar:CreateTexture("SA_ScrollBar_Tex", "BACKGROUND")
	ScrollBG:SetAllPoints(ScrollBar)
	ScrollBG:SetTexture(0, 0, 0, 0.4)
	ScrollBar:Hide()
end

-- Create the Content of the ScrollBar(dependent of data)
function CreateContent(frame, data)
	-- if empty nothing to show
	if next(data) == nil then
		return
	end
	if not Content then
		Content = CreateFrame("Frame", "SA_ScrollFrame_Content", frame)
	end
	
	Content.data = data
	
	Content:SetSize(frame:GetWidth(), frame:GetHeight())
	
	SA_ScrollFrame:CreateButtons(data, frame)
	local i = 1
	for k, v in pairs(data) do
		local btn1 = ConfigFirstLevelButton(ScrollFrame.buttons[i], k)

		if i == 1 then -- set position of first button
			btn1:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
		else
			btn1:SetPoint("TOPLEFT", ScrollFrame.buttons[i -(i-1)], "BOTTOMLEFT", 0, 0)
		end
		btn1:Show() -- only first level buttons shown
		if type(v) == "table" then
			if GetDepth(v) >= 2 then -- if the Depth is 2 or higher, we have a second table in the table
				for k, v in pairs(v) do
					SetPlusTexture(btn1)
					
					btn1:SetScript("OnClick", function(self, button)
						if button == "LeftButton" then
							if not self.clicked then 
								self.clicked = true
								SetMinusTexture(self)
								
								-- hide buttons and set the selected button as Header
								SA_ScrollFrame:HideButtons()
								ClearAllPoints()
								NewHeader(self)
								
								local lvl2Buttons = GetSecondButtons(Content.data[self:GetText()])
								lvl2Buttons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
								lvl2Buttons[1]:Show()
								for i=2, #lvl2Buttons, 1 do
									lvl2Buttons[i]:SetPoint("TOPLEFT", lvl2Buttons[i-1], "TOPLEFT", 0, -25)
									lvl2Buttons[i]:Show()
								end
							else
								SetAllClicked(false)
								SetAllPlusTex()
							
								SA_ScrollFrame:SetMainButtons(Content.data)
							end
						end
					end)

					i = i + 1
					
					local btn2 = ConfigSecLevelButton(ScrollFrame.buttons[i], k)
					--################### NEXT ###################
					btn2:SetScript("OnClick", function(self, button)
						if button == "LeftButton" then
							if not self.clicked then 
								self.clicked = true
								SetMinusTexture(self)
							else
								self.clicked = false
								SetPlusTexture(self)
							end
						end
					end)
					i = SA_ScrollFrame:CreateInnerButton(v, i)
				end
			end
		end
	end
	--Content.texture = Content:CreateTexture()
	--Content.texture:SetAllPoints()
	--Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content)
end

-- Create all Buttons for the ScrollFrame
function SA_ScrollFrame:CreateButtons(data, frame)
	for i=1,GetArraySize(data, GetDepth(data), 0) do
		ScrollFrame.buttons[i] = CreateFrame("Button",nil,Content)
		local btn = ScrollFrame.buttons[i]
		btn.clicked = false
		btn:SetSize(frame:GetWidth(),25)
		btn:RegisterForClicks("LeftButtonUp") -- only left button click
	end
end

-- This function is for the third level buttons
function SA_ScrollFrame:CreateInnerButton(table, i)
	if type(table) == "table" then
		for k, v in pairs(table) do
			i = i + 1
			ConfigThirdLevelButtons(ScrollFrame.buttons[i], k)
			
			if type(v) == "table" then
				SA_ScrollFrame:CreateInnerButton(v, i) -- if have fourth level buttons, but at time not wanted
			end
		end
	end
	return i
end

-- Setter for buttons, if all are clicked or not
function SetAllClicked(clicked)
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i].clicked = clicked
	end
end

-- Setter for setting all buttons(only level 1 and 2) a plus texture
function SetAllPlusTex()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		if ScrollFrame.buttons[i].level == 1 or ScrollFrame.buttons[i].level == 2 then
			local button = ScrollFrame.buttons[i]
			local tex = button:CreateTexture(nil, "ARTWORK")
			tex:SetAllPoints(true)
			tex:SetSize(20, 20)
			tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
			button:SetNormalTexture(tex)
			button:GetNormalTexture():ClearAllPoints()
			button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
		end
	end
end

-- set the plus texture in a button
function SetPlusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

-- set the minus texture in a button
function SetMinusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

-- configure first level buttons
function ConfigFirstLevelButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
		
	button.level = 1
		
	return button
end

-- configure second level buttons
function ConfigSecLevelButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(13)
	fontstring:SetPoint("LEFT", button, "LEFT", 3, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	button:Hide()
					
	button.level = 2
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button.clicked = false
		
	return button
end

-- configure third level buttons
function ConfigThirdLevelButtons(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(12)
	fontstring:SetPoint("LEFT", button, "LEFT", 4, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	button.level = 3
	button:Hide()
end

-- set a new header, needed if get a new level of buttons
function NewHeader(button)
	button:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(15)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
	button:Show()
end

-- configure the main buttons, e.g. font
function ConfigMainButtons(button)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
end

-- Hide all buttons, needed if click on a button
function SA_ScrollFrame:HideButtons()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:Hide()
	end
end

-- Clear all points of the buttons, needed if set ne Points
function ClearAllPoints()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:ClearAllPoints()
	end
end

-- Get all second level buttons
function GetSecondButtons(data)
	local secondBTNS = copySecButtons(data)
	local score = {}
	for i=1,#secondBTNS, 1 do
		for j=1, #ScrollFrame.buttons, 1 do
		-- check if really second level button
			if (secondBTNS[i] == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 2) then
				score[i] = ScrollFrame.buttons[j]
				--print("score["..i.."]: "..score[i]:GetText())
			end
		end
	end
	return score
end

-- set all Buttons which where shown at start
function SA_ScrollFrame:SetMainButtons()
	SA_ScrollFrame:HideButtons()
	ClearAllPoints()
	ConfigMainButtons(ScrollFrame.buttons[1])
	ScrollFrame.buttons[1]:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	ScrollFrame.buttons[1]:Show()
	
	local last = ScrollFrame.buttons[1]
	for i=2,#ScrollFrame.buttons, 1 do
		if (ScrollFrame.buttons[i].level == 1) then
			ConfigMainButtons(ScrollFrame.buttons[i])
			ScrollFrame.buttons[i]:SetPoint("TOPLEFT", last, "TOPLEFT", 0, -25)
			ScrollFrame.buttons[i]:Show()
			last = ScrollFrame.buttons[i]
		end
	end
end

function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

function SA_ScrollFrame:LoadScrollFrame(frame)
	return CreateScrollFrame(frame)
end

-- Get the Size of a table
function GetArraySize(table, depth, len)
	local lengthNum = len
	for k,v in pairs(table) do -- for every key in the table with a corresponding non-nil value 
		lengthNum = lengthNum + 1
		if depth >= 2 then
			if type(v) == "table" then
				lengthNum = GetArraySize(v, depth-1, lengthNum)
			end
		end
	end
	return lengthNum
end

-- Get depth of a table
function GetDepth(table)
	local depth = 1
	if next(table) == nil then
		return depth
	else
		depth = depth + 1
	end
	for	k, v in pairs(table) do
		if type(v) == "table" then
			GetDepth(v)
		end
	end
	return depth + 1
end

-- needed for copy all second level buttons in new table
function copySecButtons(orig)
    local copy = {}
    local i = 1
    for k, v in pairs(orig) do
		if k ~= nil then
			tinsert(copy, k)
			i = i + 1
		end
    end
    return copy
end