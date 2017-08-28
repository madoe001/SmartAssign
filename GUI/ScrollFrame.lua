local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

local function CreateScrollFrame(frame)
	if not ScrollFrame then
		ScrollFrame = CreateFrame("ScrollFrame", "ScrollFrame", frame)
	end
	ScrollFrame.buttons = {}
	
	ScrollFrame:SetPoint("TOPLEFT", 10, -10)
	ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
	ScrollFrame:SetWidth(frame:GetWidth() * 0.7)
	
	--ScrollFrame:SetScript("OnLoad", onLoad())
	
	ScrollFrame.texture = ScrollFrame:CreateTexture()
	ScrollFrame.texture:SetAllPoints()
	ScrollFrame.texture:SetTexture(0, 0, 0, 0)
	
	CreateScrollBar(ScrollFrame)
	CreateContent(ScrollFrame, _G.Dungeons)
	
	return ScrollFrame
end

local function onLoad(self)
	
end

function CreateScrollBar(frame)
	if not ScrollBar then
		ScrollBar = CreateFrame("Slider", "SA_Slider", ScrollFrame, "UIPanelScrollBarTemplate")
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

function CreateContent(frame, data)
	-- if empty nothing to show
	if next(data) == nil then
		return
	end
	if not Content then
		Content = CreateFrame("Frame", "SA_ScrollFrame_Content", frame)
	end
	Content:SetSize(frame:GetWidth(), frame:GetHeight())
	for i=1,GetArraySize(data, GetDepth(data), 0) do
		ScrollFrame.buttons[i] = CreateFrame("Button",nil,Content)
		local btn = ScrollFrame.buttons[i]
		btn:SetSize(frame:GetWidth(),25)
		btn:SetNormalFontObject("GameFontHighlightLeft")
		btn:RegisterForClicks("LeftButtonUp")
	end
	local i = 1
	for k, v in pairs(data) do
		--print("i:"..i.."k:"..k)
		local btn = ScrollFrame.buttons[i]
		btn:SetText(k)
		if i == 1 then
			btn:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
		else
			btn:SetPoint("TOPLEFT", ScrollFrame.buttons[i -(i-1)], "BOTTOMLEFT", 0, 0)
		end
		btn:Show()
		if type(v) == "table" then
			if GetDepth(v) >= 2 then
				for k, v in pairs(v) do
					local tex = btn:CreateTexture(nil, "ARTWORK")
					tex:SetAllPoints(true)
					tex:SetSize(20, 20)
					tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
					btn:SetNormalTexture(tex)
					btn:GetNormalTexture():ClearAllPoints()
					btn:GetNormalTexture():SetPoint("RIGHT", btn, "RIGHT", 0, 0)
					btn.clicked = false
					
					btn:SetScript("OnClick", function(self, button)
						if button == "LeftButton" then
							if not self.clicked then 
								self.clicked = true
								tex:SetTexture("Interface\\BUTTONS\\UI-MinusButton-UP")
								self:SetPushedTexture(tex)
							else
								self.clicked = false
								tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
								btn:SetNormalTexture(tex)
							end
						end
					end)

					i = i + 1
					
					local btn = ScrollFrame.buttons[i]
					btn:SetText(k)
					btn:Show()
					
					local tex = btn:CreateTexture(nil, "ARTWORK")
					tex:SetAllPoints(true)
					tex:SetSize(20, 20)
					tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
					btn:SetNormalTexture(tex)
					btn:GetNormalTexture():ClearAllPoints()
					btn:GetNormalTexture():SetPoint("RIGHT", btn, "RIGHT", 0, 0)
					btn.clicked = false
					
					btn:SetScript("OnClick", function(self, button)
						if button == "LeftButton" then
							if not self.clicked then 
								self.clicked = true
								tex:SetTexture("Interface\\BUTTONS\\UI-MinusButton-UP")
								self:SetPushedTexture(tex)
							else
								self.clicked = false
								tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
								btn:SetNormalTexture(tex)
							end
						end
					end)
					
					i = SA_ScrollFrame:CreateInnerButton(v, i)
				end
			end
		else
			i = i + 1
			local btn = ScrollFrame.buttons[i]
			btn:SetText(v)
		end
	end
	
	--Content.texture = Content:CreateTexture()
	--Content.texture:SetAllPoints()
	--Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content)
end

function SA_ScrollFrame:CreateInnerButton(T, i)
	if type(T) == "table" then
		for k, v in pairs(T) do
			i = i + 1
			local btn = ScrollFrame.buttons[i]
			btn:SetText(k)
			btn:Hide()
			if type(v) == "table" then
				SA_ScrollFrame:CreateInnerButton(v, i)
			end
		end
	end
	return i
end

function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

function SA_ScrollFrame:LoadScrollFrame(frame)
	return CreateScrollFrame(frame)
end

-- Get the Size of a table
function GetArraySize(T, depth, len)
	local lengthNum = len
	for k,v in pairs(T) do -- for every key in the table with a corresponding non-nil value 
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
function GetDepth(value)
	local depth = 1
	if next(value) == nil then
		return depth
	else
		depth = depth + 1
	end
	for	k, v in pairs(value) do
		if type(v) == "table" then
			GetDepth(v)
		end
	end
	return depth + 1
end