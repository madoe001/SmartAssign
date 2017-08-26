local _G = _G

local SA_DropDownList = _G.GUI.SA_DropDownList
local SAL = _G.SmartAssign.Locales

-- for failurehandling
local assert, type = assert, type

local BUTTON_HEIGHT = 25

-- onClick setter
function SA_DropDownList:SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownList SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

function SA_DropDownList:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	DropDownListButton:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

-- onclick event handling
local function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownListButton, self:GetID())
end

-- clears the dropdownlist, sets data and a startvalue
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

-- first create button than init
local function CreateDropDownList(frame, data)
	if not DropDownListButton then
		DropDownListButton = CreateFrame("Button", "DropDownListButton", frame,"UIDropDownMenuTemplate")
	end
	
	SetData(DropDownListButton, data, 1)
	
	DropDownListButton:SetPoint("CENTER", 20, 0) -- 20 = x
	DropDownListButton:SetHeight(BUTTON_HEIGHT)
    DropDownListButton:RegisterForClicks("LeftButtonDown", "RightButtonDown") -- only right and left click
    
    DropDownListButton.label = DropDownListButton:CreateFontString("DropDownListButton-label", "ARTWORK", "GameFontNormalSmall")
	DropDownListButton.label:SetHeight(BUTTON_HEIGHT)
	DropDownListButton.label:SetText("DropDownListButton-label")
	
	DropDownListButton:Show()

	UIDropDownMenu_Initialize(DropDownListButton, InitDDL);
    UIDropDownMenu_SetButtonWidth(DropDownListButton, (DropDownListButton.label:GetStringWidth()-(DropDownListButton.label:GetStringWidth()*0.5)))
    UIDropDownMenu_SetWidth(DropDownListButton, DropDownListButton.label:GetStringWidth());
    UIDropDownMenu_JustifyText(DropDownListButton, "CENTER")
    
    return DropDownListButton
end

function InitDDL(self, level)
   UIDropDownMenu_SetText(DropDownListButton, "");
   local info = UIDropDownMenu_CreateInfo()
   for key,value in pairs(self.data) do
      info = UIDropDownMenu_CreateInfo()
      info.text = value
      info.value = value
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

function SA_DropDownList:LoadDropDownList(frame, data)
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."])
	return CreateDropDownList(frame, data)
end