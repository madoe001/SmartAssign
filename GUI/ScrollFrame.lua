local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

local SAL = _G.GUI.Locales

-- Create the full ScrollFrame
local function CreateScrollFrame(frame)
	if not ScrollFrame then
		ScrollFrame = CreateFrame("ScrollFrame", "ScrollFrame", frame)
	end
	ScrollFrame.buttons = {}
	ScrollFrame.mainButtonCount = 0
	
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
	
	ScrollBar:SetAttribute("buttoncount",0)
	
	ScrollBar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -12, -16)
	ScrollBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -12, 16)
	
	ScrollBar:SetMinMaxValues(1, 100)
	ScrollBar:SetValueStep(1)
	ScrollBar.scrollStep = 1
	ScrollBar:SetValue(0)
	ScrollBar:SetWidth(16)
	
	-- when the user use the scrollbar refresh the position of buttons
	ScrollBar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value) -- set to new value
		if ScrollFrame.mainBTN == nil and ScrollFrame.lvlClicked == 0 then
			local mainButtons = GetMainButtons(Content.data)
			for i=1, #mainButtons, 1 do
			    mainButtons[i]:ClearAllPoints()
				mainButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value-1)
			end
		elseif ScrollFrame.mainBTN ~= nil and ScrollFrame.lvlClicked == 1 then
			local instanceButtons = GetInstanceButtons(Content.data)
			for i=1, #instanceButtons, 1 do
				instanceButtons[i]:ClearAllPoints()
				instanceButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value-1)
			end
		elseif ScrollFrame.instanceButton ~= nil and ScrollFrame.lvlClicked == 2 then
			local bossData = GetBossData(ScrollFrame.mainBTN, ScrollFrame.instanceButton:GetText(), Content.data)
			local bossButtons = GetBossButtons(bossData)
			bossButtons[1]:ClearAllPoints()
			bossButtons[1]:SetPoint("LEFT", ScrollFrame.instanceButton, "LEFT", 0, value-25)
			for i=2, #bossButtons, 1 do
				bossButtons[i]:ClearAllPoints()
				bossButtons[i]:SetPoint("LEFT", bossButtons[i-1], "LEFT", 0, -25)
			end
		end
	end)
	
	local ScrollBG = ScrollBar:CreateTexture("ScrollBar_Tex", "BACKGROUND")
	ScrollBG:SetAllPoints(ScrollBar)
	ScrollBG:SetTexture(0, 0, 0, 0.4)
	ScrollBar:Hide()
	
	-- show scrollbar only if too much buttons inside ScrollFrame
	ScrollBar:SetScript("OnAttributeChanged", function(self, name, value)
		if name == "buttoncount" then
			if(value > ((ScrollFrame:GetHeight()-20)/25)) then
				self:Show()
			else
				self:Hide()
			end
		end
	end)
end

-- Create the Content of the ScrollBar(dependent of data)
function CreateContent(frame, data)
	-- if empty nothing to show
	if next(data) == nil then
		return
	end
	if not Content then
		Content = CreateFrame("Frame", "ScrollFrame_Content", frame)
	end
	
	Content.data = data
	
	Content:SetSize(frame:GetWidth(), frame:GetHeight())
	
	SA_ScrollFrame:CreateButtons(data, frame)
	local i = 1
	for k, v in pairs(data) do
		if type(k) == "string" then
			local btn1 = ConfigMainButton(ScrollFrame.buttons[i], k)

			if i == 1 then -- set position of first button
				btn1:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
			else
				btn1:SetPoint("TOPLEFT", ScrollFrame.buttons[i -(i-1)], "BOTTOMLEFT", 0, 0)
			end
			btn1:Show() -- only first level buttons shown
			if type(v) == "table" then
				if GetDepth(v) >= 2 then -- if the Depth is 2 or higher, we have a second table in the table
					for k, v in pairs(v) do
						btn1.hasChilds = true
						SetPlusTexture(btn1)
					
						btn1:SetScript("OnClick", function(self, button)
							if button == "LeftButton" then
								if not self.clicked then 
									ScrollFrame.lvlClicked = 1
									ScrollFrame.mainBTN = self
									self.clicked = true
									SetMinusTexture(self)
								
									-- hide buttons and set the selected button as Header
									SA_ScrollFrame:HideButtons()
									ClearAllPoints()
									NewHeader(self)
									SetInstanceButtons(self, Content.data[self:GetText()])
								else
									ScrollBar:SetAttribute("buttoncount", 0)
								
									ScrollFrame.lvlClicked = 0
									ScrollFrame.mainBTN = nil
									SetAllClicked(false)
									SetAllPlusTex()
							
									SetMainButtons()
								end
							end
						end)

						i = i + 1
						
						if type(k) == "string" then
							local btn2 = ConfigInstanceButton(ScrollFrame.buttons[i], k)
							if type(v) == "table" then
								btn2.hasChilds = true
							else
								btn2.hasChilds = false
							end
							btn2:SetScript("OnClick", function(self, button)
								if button == "LeftButton" then
									ScrollBar:SetAttribute("buttoncount",0)
									if not self.clicked then 
										ScrollFrame.lvlClicked = 2
										ScrollFrame.instanceButton = self
										self.clicked = true
										SetMinusTexture(self)
										
										-- hide buttons and set the selected button as Header
										SA_ScrollFrame:HideButtons()
										ClearAllPoints()
										NewHeader(self)
										local bossData = GetBossData(ScrollFrame.mainBTN, self:GetText(), Content.data)
										local bossButtons = GetBossButtons(bossData)
										
										ScrollBar:SetAttribute("buttoncount", #bossButtons)
										
										bossButtons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
										bossButtons[1]:Show()
										for i=2, #bossButtons, 1 do
											bossButtons[i]:SetPoint("TOPLEFT", bossButtons[i-1], "TOPLEFT", 0, -25)
											bossButtons[i]:Show()
										end
									else
									ScrollFrame.lvlClicked = 1
									ScrollFrame.instanceButton = nil
									self.clicked = false
									SA_ScrollFrame:HideButtons()
									ClearAllPoints()
									SetAllPlusTex()
									SetInstanceButtons(self, Content.data[ScrollFrame.mainBTN:GetText()])
									end
								end
							end)
						i = CreateBossButton(v, i)
					end
				end
			else
				btn1:SetScript("OnClick", function(self, button)
				print("|cFFFF0000"..self:GetText()..SAL[" has no childs!"].."|r")
				end)
			end
		end
	end
end
	--Content.texture = Content:CreateTexture()
	--Content.texture:SetAllPoints()
	--Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content)
end

function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

function SA_ScrollFrame:LoadScrollFrame(frame)
	return CreateScrollFrame(frame)
end

-- reset function
function SA_ScrollFrame:Reset(frame)
	ScrollFrame.mainBTN = nil
	ScrollFrame.instanceButton = nil
	ScrollFrame.bossButton = nil
	ScrollFrame:SetAttribute("lvlClicked", 0)
	ScrollBar:SetAttribute("buttoncount", 0)
	ScrollBar:SetValue(0)
	ScrollBar:Hide()
	DisableBossButtons()
	ConfigAllButtons()
	SetAllClicked(false)
	SetMainButtons()
	SetAllPlusTex()
	ScrollBar:SetAttribute("buttoncount", ScrollFrame.mainButtonCount)
end

-- Create all Buttons for the ScrollFrame
function SA_ScrollFrame:CreateButtons(data, frame)
	for i=1,GetArraySize(data, GetDepth(data), 0) do
		ScrollFrame.buttons[i] = CreateFrame("Button",nil,Content)
		local btn = ScrollFrame.buttons[i]
		btn.clicked = false
		btn.hasChild = false
		btn:SetSize(frame:GetWidth()-12,25)
		btn:RegisterForClicks("LeftButtonUp") -- only left button click
	end
	ScrollFrame.lvlClicked = 0
end

-- This function is for the boss buttons (third level)
function CreateBossButton(table, i)
	if type(table) == "table" then
		for k, v in pairs(table) do
			i = i + 1
			ConfigBossButtons(ScrollFrame.buttons[i], v)
			
			if type(k) == "table" then
				CreateBossButton(k, i) -- if have fourth level buttons, but at time not wanted
			end
		end
	end
	return i
end

-- configure a main button(first level)
function ConfigMainButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
		
	button.level = 1
		
	return button
end

-- configure the main buttons, e.g. font
function ConfigMainButtons(button)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	ScrollFrame.mainButtonCount = ScrollFrame.mainButtonCount + 1
	
	ScrollBar:SetAttribute("buttoncount", ScrollBar:GetAttribute("buttoncount") + 1)
end

-- configure instance buttons(second level)
function ConfigInstanceButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(13)
	fontstring:SetPoint("LEFT", button, "LEFT", 3, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	button:Hide()
					
	button.level = 2
	
	SetPlusTexture(button)
	button.clicked = false
	
	ScrollBar:SetAttribute("buttoncount", ScrollBar:GetAttribute("buttoncount") + 1)
		
	return button
end

-- configure boss buttons(third level)
function ConfigBossButtons(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(12)
	fontstring:SetPoint("LEFT", button, "LEFT", 4, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	button.level = 3
	button.clicked = false
	button:Hide()
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	button:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			if self.clicked == false then
				ScrollFrame.lvlClicked = 3
				self.clicked = true
				ScrollFrame.bossButton = self 
				
				-- set highlight
				local tex = self:CreateTexture(nil, "ARTWORK")
				tex:SetAllPoints(true)
				tex:SetSize(20, 20)
				tex:SetTexture("Interface\\BUTTONS\\UI-ListBox-Highlight")
				self:SetNormalTexture(tex)
				self:GetNormalTexture():ClearAllPoints()
				self:GetNormalTexture():SetPoint("RIGHT", self, "RIGHT", 0, 0)
				self:GetNormalTexture():SetPoint("LEFT", self, "LEFT", 0, 0)
				DisableBossButtons()
			else
				ScrollFrame.lvlClicked = 2
				self.clicked = false
				ScrollFrame.bossButton = nil
				
				-- clear highlight
				local tex = self:CreateTexture(nil, "ARTWORK")
				tex:SetAllPoints(true)
				tex:SetTexture(nil)
				self:SetNormalTexture(tex)
				self:GetNormalTexture():ClearAllPoints()
				self:GetNormalTexture():SetPoint("RIGHT", self, "RIGHT", 0, 0)
				self:GetNormalTexture():SetPoint("LEFT", self, "LEFT", 0, 0)
				DisableBossButtons()
			end
		end
	end)
end

-- ######################### NEXT ConfigAllButtons für Reset, um alle Buttons wieder die alte Texture zu geben etc
function ConfigAllButtons()
	for i=1, #ScrollFrame.buttons, 1 do
		if ScrollFrame.buttons[i].level == 1 then
			ConfigMainButtons(ScrollFrame.buttons[i])
		elseif ScrollFrame.buttons[i].level == 2 then
			ConfigInstanceButton(ScrollFrame.buttons[i], ScrollFrame.buttons[i]:GetText())
		elseif ScrollFrame.buttons[i].level == 3 then
			ConfigBossButtons(ScrollFrame.buttons[i], ScrollFrame.buttons[i]:GetText())
		end
	end
end
-- Setter for buttons, if all are clicked or not
function SetAllClicked(clicked)
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		if ScrollFrame.lvlClicked == 1 and ScrollFrame.mainBTN ~= nil then
			if ScrollFrame.mainBTN:GetText() == button:GetText() then
				ScrollFrame.buttons[i].clicked = true
			end
		elseif ScrollFrame.lvlClicked == 2 and ScrollFrame.instanceButton ~= nil then
			if ScrollFrame.instanceButton:GetText() == button:GetText() then
				ScrollFrame.buttons[i].clicked = true
			end
		else
			ScrollFrame.buttons[i].clicked = clicked
		end
	end
end

-- Setter for setting all buttons(only level 1 and 2) a plus texture
function SetAllPlusTex()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		local button = ScrollFrame.buttons[i]
		if button.hasChilds then
			SetPlusTexture(button)
		end
	end
	if(ScrollFrame.mainBTN ~= nil) then
		SetMinusTexture(ScrollFrame.mainBTN)
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

-- set a new header, needed if get a new level of buttons
function NewHeader(button)
	button:SetFrameLevel(255) -- to be a top of ui
	button:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(15)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetSize(button:GetWidth(), button:GetHeight()+8)
	tex:SetAllPoints(true)
	tex:SetTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	button:Show()
end

-- Clear all points of the buttons, needed if set ne Points
function ClearAllPoints()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:ClearAllPoints()
	end
end

-- Hide all buttons, needed if click on a button
function SA_ScrollFrame:HideButtons()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:Hide()
	end
end

function DisableBossButtons()
	if ScrollFrame.bossButton ~= nil then
		local bossButtons = SA_ScrollFrame:GetBossButtons()
		for i=1, #bossButtons, 1 do
			if bossButtons[i]:GetText() ~= ScrollFrame.bossButton:GetText() then
				bossButtons[i]:Disable()
			end
		end
	else
		local bossButtons = SA_ScrollFrame:GetBossButtons()
		for i=1, #bossButtons, 1 do
			bossButtons[i]:Enable()
		end
	end
end

function GetMainButtons(data)
	local score = {}
	for k, v in pairs(data) do
		for j=1, #ScrollFrame.buttons, 1 do
		-- check if really first level button
			if (k == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 1) then
				score[i] = ScrollFrame.buttons[j]
				--print("score["..i.."]: "..score[i]:GetText())
			end
		end
	end
	return score
end

-- Get all instance buttons(second level)
function GetInstanceButtons(data)
	local instanceButtons = copyButtons(data)
	local score = {}
	for i=1, #instanceButtons, 1 do
		for j=1, #ScrollFrame.buttons, 1 do
		-- check if really second level button
			if (instanceButtons[i] == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 2) then
				score[i] = ScrollFrame.buttons[j]
				--print("score["..i.."]: "..score[i]:GetText())
			end
		end
	end
	return score
end

-- Get all Boss buttons(third level)
function GetBossButtons(data)
	local bossButtons = data
	local score = {}
	for i=1, #bossButtons, 1 do
		for j=1, #ScrollFrame.buttons, 1 do
			if (bossButtons[i] == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 3) then
				score[i] = ScrollFrame.buttons[j]
				--print("score[i]: "..score[i]:GetText())
			end
		end
	end
	return score
end

-- Get the Bosses of an Instance
function GetBossData(mainBTN, buttonText, data)
	local nextLvlData = data[mainBTN:GetText()]
	return nextLvlData[buttonText]
end

function SA_ScrollFrame:GetBossButtons()
	local score = {}
	for i=1, #ScrollFrame.buttons, 1 do
		if(ScrollFrame.buttons[i].level == 3) then
			tinsert(score, ScrollFrame.buttons[i])
		end
	end
	return score
end

-- set all Buttons which where shown at start
function SetMainButtons()
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
	SetAllPlusTex()
end

-- set all instanceButton(second level)
function SetInstanceButtons(self, data)
	local instanceButtons = GetInstanceButtons(data)
	ConfigInstanceButton(instanceButtons[1], instanceButtons[1]:GetText())
	if ScrollFrame.mainBTN ~= nil then
		if ScrollFrame.mainBTN == self:GetText() then
			instanceButtons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
		else
			NewHeader(ScrollFrame.mainBTN)
			instanceButtons[1]:SetPoint("TOPLEFT", ScrollFrame.mainBTN, "TOPLEFT", 0, -25)
		end
	end
	instanceButtons[1]:Show()
	for i=2, #instanceButtons, 1 do
		instanceButtons[i]:SetPoint("TOPLEFT", instanceButtons[i-1], "TOPLEFT", 0, -25)
		ConfigInstanceButton(instanceButtons[i], instanceButtons[i]:GetText())
		instanceButtons[i]:Show()
	end
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
function copyButtons(orig)
    local copy = {}
    for k, v in pairs(orig) do
		if k ~= nil then
			tinsert(copy, k)
		end
    end
    return copy
end