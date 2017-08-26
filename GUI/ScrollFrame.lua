local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

local function CreateScrollFrame(frame)
	if not ScrollFrame then
		ScrollFrame = CreateFrame("ScrollFrame", "ScrollFrame", frame)
	end
	ScrollFrame:SetPoint("TOPLEFT", 10, -10)
	ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
	ScrollFrame:SetWidth(frame:GetWidth() * 0.7)
	
	ScrollFrame.texture = ScrollFrame:CreateTexture()
	ScrollFrame.texture:SetAllPoints()
	ScrollFrame.texture:SetTexture(0, 0, 0, 0)
	
	CreateScrollBar(ScrollFrame)
	CreateContent(ScrollFrame)
	
	return ScrollFrame
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
end

function CreateContent(frame)
	if not Content then
		Content = CreateFrame("Frame", "SA_ScrollFrame_Content", frame)
	end
	Content:SetSize(frame:GetWidth(), frame:GetHeight())
	
	Content.texture = Content:CreateTexture()
	Content.texture:SetAllPoints()
	Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content)
end

function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

function SA_ScrollFrame:LoadScrollFrame(frame)
	return CreateScrollFrame(frame)
end