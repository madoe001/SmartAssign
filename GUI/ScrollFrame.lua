--Author: Bartlomiej Grabelus

local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

-- localization
local SAL = _G.GUI.Locales

-- CreateScrollFrame(): Creation of the ScrollFrame
--
-- creates the scrollframe and create a table for the buttons of the scrollframe.
-- Sets the count of main buttons to 0
-- than create the scrollbar and content of the scrollframe
--
-- frame: Parent frame
local function CreateScrollFrame(frame)
	local ScrollFrame = CreateFrame("ScrollFrame", "ScrollFrame", frame)

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

-- CreateScrollBar(): Create the ScrollBar for the ScrollFrame
--
-- frame: Parent frame
function CreateScrollBar(frame)
	if not ScrollBar then
		ScrollBar = CreateFrame("Slider", "ScrollBar", ScrollFrame, "UIPanelScrollBarTemplate")
	end
	
	-- setting a secure frame attribute, on which we can acces with GetAttribute(<name>)
	ScrollBar:SetAttribute("buttoncount",0)
	
	ScrollBar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -12, -16)
	ScrollBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -12, 16)
	
	ScrollBar:SetMinMaxValues(1, 100) -- set minumum and maximum of scrollbar, for scrolling
	ScrollBar:SetValueStep(1) -- set scrolling step value
	ScrollBar.scrollStep = 1 -- set scrolling step value
	ScrollBar:SetValue(0) -- set starting scroll value
	ScrollBar:SetWidth(16)
	
	-- when the user use the scrollbar refresh the position of buttons
	ScrollBar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value) -- set to new value
		print(value)
		if ScrollFrame.mainBTN == nil and ScrollFrame.lvlClicked == 0 then -- when main Buttons
			local mainButtons = GetMainButtons(Content.data)
			for i=1, #mainButtons, 1 do
			    mainButtons[i]:ClearAllPoints()
				mainButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value-25) -- scroll value - buttonheight
			end
		elseif ScrollFrame.mainBTN ~= nil and ScrollFrame.lvlClicked == 1 then -- when Instance Buttons
			local instanceButtons = GetInstanceButtons(Content.data)
			for i=1, #instanceButtons, 1 do
				instanceButtons[i]:ClearAllPoints()
				instanceButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value-25) -- scroll value - buttonheight
			end
		elseif ScrollFrame.instanceButton ~= nil and ScrollFrame.lvlClicked == 2 then -- when instance Buttons
			local bossData = GetBossData(ScrollFrame.mainBTN, ScrollFrame.instanceButton:GetText(), Content.data)
			local bossButtons = GetBossButtons(bossData)
			bossButtons[1]:ClearAllPoints()
			bossButtons[1]:SetPoint("LEFT", ScrollFrame.instanceButton, "LEFT", 0, value-25) -- scroll value - buttonheight
			for i=2, #bossButtons, 1 do
				bossButtons[i]:ClearAllPoints()
				bossButtons[i]:SetPoint("LEFT", bossButtons[i-1], "LEFT", 0, -25) -- scroll value - buttonheight
			end
		end
	end)
	
	local ScrollBG = ScrollBar:CreateTexture("ScrollBar_Tex", "BACKGROUND") -- tex for ScrollBar
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

-- CreateContent(): Create the Content of the ScrollBar(dependent of data)
--
-- create a content frame and set the size to the parent size, than create the
-- buttons dependent to the size of the data table.
-- Then fill the buttons which a text and a OnClick EventHandler
--
-- frame: Parent frame
-- data: the buttons
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
			local btn1 = ConfigMainButton(ScrollFrame.buttons[i], k) -- configurate the main button

			if i == 1 then -- set position of first button
				btn1:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
			else
				btn1:SetPoint("TOPLEFT", ScrollFrame.buttons[i -(i-1)], "BOTTOMLEFT", 0, 0)
			end
			btn1:Show() -- only main buttons shown
			if type(v) == "table" then -- if the value is a table
				if GetDepth(v) >= 2 then -- if the Depth is 2 or higher, we have a second table in the table
					for k, v in pairs(v) do -- loop through the instance buttons
						btn1.hasChilds = true
						SetPlusTexture(btn1) -- set a plus for the main button
					
						btn1:SetScript("OnClick", function(self, button) -- OnClick EventHandling for main button
							if button == "LeftButton" then
								if not self.clicked then -- if wasn´t clicked befor
									ScrollFrame.lvlClicked = 1
									ScrollFrame.mainBTN = self -- set the main Button which was clicked
									self.clicked = true
									SetMinusTexture(self) -- now set the plus to minus
								
									-- hide buttons and set the selected button as Header
									SA_ScrollFrame:HideButtons()
									ClearAllPoints()
									NewHeader(self)
									SetInstanceButtons(self, Content.data[self:GetText()]) -- set the instance button dependent to 
								else                                                       -- the main Button
									ScrollBar:SetAttribute("buttoncount", 0) -- if was befor clicked
								
									ScrollFrame.lvlClicked = 0
									ScrollFrame.mainBTN = nil
									SetAllClicked(false) -- by entering the main level all buttons clicked set to false
									SetAllPlusTex() -- restore plus texture
							
									SetMainButtons() -- set all main buttons in scrollframe
								end
							end
						end)

						i = i + 1
						
						if type(k) == "string" then
							local btn2 = ConfigInstanceButton(ScrollFrame.buttons[i], k) -- configurate the instance button
							if type(v) == "table" then -- table in table --> bosses in instance
								btn2.hasChilds = true
							else
								btn2.hasChilds = false
							end
							btn2:SetScript("OnClick", function(self, button) -- OnClick EventHandling
								if button == "LeftButton" then
									ScrollBar:SetAttribute("buttoncount",0)
									if not self.clicked then 
										ScrollFrame.lvlClicked = 2
										ScrollFrame.instanceButton = self -- set instance button
										self.clicked = true
										SetMinusTexture(self) -- set minus
										
										-- hide buttons and set the selected button as Header
										SA_ScrollFrame:HideButtons()
										ClearAllPoints()
										NewHeader(self) -- set a new header
										local bossData = GetBossData(ScrollFrame.mainBTN, self:GetText(), Content.data) -- get teh boss data of the table
										local bossButtons = GetBossButtons(bossData) -- get the boss buttons in the buttons
										
										ScrollBar:SetAttribute("buttoncount", #bossButtons) -- set the buttoncount to the number of bosses
										
										bossButtons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
										bossButtons[1]:Show()
										for i=2, #bossButtons, 1 do
											bossButtons[i]:SetPoint("TOPLEFT", bossButtons[i-1], "TOPLEFT", 0, -25)
											bossButtons[i]:Show()
										end
									else -- if instance button wasn´t clicked befor
										ScrollFrame.lvlClicked = 1
										ScrollFrame.instanceButton = nil
										self.clicked = false
										SA_ScrollFrame:HideButtons() -- hide all buttons
										ClearAllPoints()
										SetAllPlusTex() -- set all plus
										SetInstanceButtons(self, Content.data[ScrollFrame.mainBTN:GetText()]) -- Set all instance buttons dependent to the main button
										
										if ScrollFrame.bossButton then -- if a boss button was clicked, then overwrite the highlighting of the button and the values
											SetNilTex(ScrollFrame.bossButton)
											ScrollFrame.bossButton = nil
											ScrollFrame.bossButton.clicked = false
										end
									end
								end
							end)
						i = CreateBossButton(v, i) -- create the boss button
					end
				end
			else
				btn1:SetScript("OnClick", function(self, button) -- the button which has no child
				print("|cFFFF0000"..self:GetText()..SAL[" has no childs!"].."|r")
				end)
			end
		end
	end
end
	--Content.texture = Content:CreateTexture()
	--Content.texture:SetAllPoints()
	--Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content) -- set the scrollChild for the ScrollFrame
end

-- SA_ScrollFrame:SetPoint(): To set the Point of the ScrollFrame outside the Class
--
-- framePosition: Region of the Frame
-- relativeToFrame: relative to which Frame want to position
-- relativePos: relative to the Region of the Frame, to which want to position
-- x: x movement of the Frame
-- y: y movement of the Frame
function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

-- SA_ScrollFrame:LoadScrollFrame(): Loader for the ScrollFrame
--
-- frame: Parent frame
function SA_ScrollFrame:LoadScrollFrame(frame)
	return CreateScrollFrame(frame)
end

-- SA_ScrollFrame:Reset(): reset function for the ScrollFrame
-- 
-- set all to start
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

-- SA_ScrollFrame:CreateButtons(): Create all Buttons for the ScrollFrame
--
-- data: which are neede to create the buttons text and how much buttons
-- frame: Parent frame
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

-- CreateBossButton(): This function is for the boss buttons (third level)
--
-- table: data for buttons
-- i: needed for the buttons container
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

-- ConfigMainButton(): configure a main button(first level)
-- 
-- button: which button want to configure
-- key: the text want to set in the button
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

-- ConfigMainButtons(): configure the main button, e.g. font
--
-- set a font and a nil texture for the button (overwrite existing texture, for having no texture)
-- raise buttoncount and mainButtonCount by 1
--
-- button: which want to configure
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

-- ConfigInstanceButton(): configure instance buttons(second level)
--
-- set a font and a nil texture for the button (overwrite existing texture, for having no texture)
-- hide the button and set plus texture
-- raise buttoncount by 1
--
-- button: which want to configure
-- key: text which want to set in button
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
					
	button.level = 2 -- level of button
	
	SetPlusTexture(button)
	button.clicked = false
	
	ScrollBar:SetAttribute("buttoncount", ScrollBar:GetAttribute("buttoncount") + 1)
		
	return button
end

-- ConfigBossButtons(): configure boss buttons(third level)
--
-- button: which want to configure
-- key: text which want to set in button
function ConfigBossButtons(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(12)
	fontstring:SetPoint("LEFT", button, "LEFT", 4, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	button.level = 3
	button.clicked = false
	button:Hide() -- hide
	
	SetNilTex(button) -- set a nil texture
	
	-- EventHandling for the boss button, if the boss button was clicked highlight him
	button:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			if self.clicked == false then
				if ScrollFrame.bossButton then
					if self:GetText() ~= ScrollFrame.bossButton:GetText() then -- if clicked on another boss button
						SetNilTex(ScrollFrame.bossButton)
						ScrollFrame.bossButton.clicked = false
						ScrollFrame.bossButton = nil
					end
				end
				ScrollFrame.lvlClicked = 3
				self.clicked = true
				ScrollFrame.bossButton = self  -- set to actual clicked boss button
				
				-- set highlight
				SetListHightlightTex(self)
			else
				ScrollFrame.lvlClicked = 2
				self.clicked = false
				ScrollFrame.bossButton = nil
				
				-- clear highlight
				SetNilTex(self)
			end
		end
	end)
end

-- ConfigAllButtons(): needed for reset, to set all buttons to start configuration
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

-- SetAllClicked(): Setter for buttons, if all are clicked or not
--
-- clicked: boolean value to which want to set, if clicked or not
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

-- SetAllPlusTex(): Setter for setting all buttons(only level 1 and 2) a plus texture
-- if they have a child
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

-- SetPlusTexture(): set the plus texture in a button
--
-- button: on which want to set the plus texture
function SetPlusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

-- SetMinusTexture(): set the minus texture in a button
--
-- button: on which want to set the minus texture
function SetMinusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

-- SetNilTex(): set a nil texture in a button
-- needed if want to overwrite a texture
--
-- button: on which want to overwrite the texture
function SetNilTex(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
end

-- SetListHightlightTex(): set a highlight texture on a button, e.g which was clicked
--
-- button: on which want to set the hightlight
function SetListHightlightTex(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture("Interface\\BUTTONS\\UI-ListBox-Highlight")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
end

-- NewHeader(): set a new header, needed if get a new level of buttons
--
-- button: which is the new header
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

-- ClearAllPoints(): Clear all points of the buttons, needed if set new Points
function ClearAllPoints()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:ClearAllPoints()
	end
end

-- SA_ScrollFrame:HideButtons(): Hide all buttons, needed if click on a button
function SA_ScrollFrame:HideButtons()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:Hide()
	end
end

-- DisableBossButtons(): Disable all boss buttons expected the clicked boss button
-- than the user can´t interact with the boss buttons
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

-- GetMainButton(): Get all main buttons of the button container dependent to data
--
-- data: filtered main data
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

-- GetInstanceButtons(): Get all instance buttons(second level) of the button container
--
-- data: filtered instance data
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

-- GetBossButtons(): Get all Boss buttons(third level) of the button container
--
-- filter data with GetBossData()
--
-- data: filtered boss data
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

-- GetBossData(): Get the Bosses of an Instance in the table data
--
-- mainBTN: main Button which was clicked
-- buttonText: instance name
-- data: data of all buttons
function GetBossData(mainBTN, buttonText, data)
	local nextLvlData = data[mainBTN:GetText()]
	return nextLvlData[buttonText]
end

-- SA_ScrollFrame:GetBossButtons(): Get all boss buttons of the button container 
function SA_ScrollFrame:GetBossButtons()
	local score = {}
	for i=1, #ScrollFrame.buttons, 1 do
		if(ScrollFrame.buttons[i].level == 3) then
			tinsert(score, ScrollFrame.buttons[i])
		end
	end
	return score
end

-- SetMainButtons(): set all Buttons which where shown at start to main buttons
-- neede when get back to main buttons
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

-- SetInstanceButtons(): set all instanceButton(second level) under the Header
-- dependent to the main Button(header)
-- neede when clicked on a main button
--
-- self: the main Button
-- data: with the button data(text)
function SetInstanceButtons(self, data)
	local instanceButtons = GetInstanceButtons(data) -- get filtered buttons, only instance buttons
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

-- GetArraySize(): lua function to get the Size of a table
--
-- table: of which want the size
-- depth: how depth want to go
-- len: needed for recursive function
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

-- GetDepth(): lua function to get depth of a table
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

-- copyButtons(): copy the buttons(only keys) of a original container
-- needed for copy all second level buttons in new table
--
-- orig: original button container
function copyButtons(orig)
    local copy = {}
    for k, v in pairs(orig) do
		if k ~= nil then
			tinsert(copy, k)
		end
    end
    return copy
end