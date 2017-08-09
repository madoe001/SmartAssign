local _G = _G

-- muss komplett überarbeitet werden

local DropDownMenu = _G.GUI.DropDownMenu
local SAL = _G.SmartAssign.Locales
local DropDownData = _G.GUI.DropDownMenu.data

-- for failurehandling
local assert, type = assert, type

local BUTTON_HEIGHT = 25

-- lua function to get table size
function GetArraySize(T)
	local lengthNum = 0
	for _ in pairs(T) do -- for every key in the table with a corresponding non-nil value 
		lengthNum = lengthNum + 1
	end
	return lengthNum
end

-- onClick setter
local function SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownMenu SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

-- for getting selected item
local function GetSelectedItem(self)
	return DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"]
end

-- geht noch nicht ändert auf Benutzerdefiniert
function OnClick(self)
	print(">> DropDownMenu OnClick << called "..DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"])  
	UIDropDownMenu_SetSelectedValue(DropDownMenuButton, GetSelectedItem(self)); -- geht immer noch nicht
end

-- clears the dropdownmenu, sets data and a startvalue
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."])
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

-- first create button than init
local function CreateDropDownButton(frame, data)
	if not DropDownMenuButton then
		DropDownMenuButton = CreateFrame("Button", "DropDownMenuButton", frame,"UIDropDownMenuTemplate")
		DropDownMenu = CreateFrame('Frame', "DropDownMenu", DropDownMenuButton)
	end
	
	SetData(DropDownMenuButton, data, 1)
	DropDownMenuButton:SetBackdrop({ 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false, tileSize = 10, edgeSize = 20,
	insets = {left = 1, right = 1, top = 5, bottom = 1}
	})
	
	DropDownMenuButton:SetPoint("LEFT", 20, 0) -- 20 = x
	DropDownMenuButton:SetHeight(BUTTON_HEIGHT)
    DropDownMenuButton:RegisterForClicks("LeftButtonDown", "RightButtonDown") -- only right and left click
    
    DropDownMenuButton.label = DropDownMenuButton:CreateFontString("DropDownMenu-label", "ARTWORK", "GameFontNormalSmall")
	--DropDownMenuButton.label:SetPoint("LEFT", DropDownMenu, "LEFT")
	DropDownMenuButton.label:SetHeight(BUTTON_HEIGHT)
	DropDownMenuButton.label:SetText("DropDownMenu-label")
	
	DropDownMenu:Show()

	UIDropDownMenu_Initialize(DropDownMenuButton, InitDDM, "MENU");
    UIDropDownMenu_SetButtonWidth(DropDownMenuButton, DropDownMenuButton.label:GetStringWidth())
    UIDropDownMenu_SetWidth(DropDownMenuButton, DropDownMenuButton.label:GetStringWidth());
    UIDropDownMenu_JustifyText(DropDownMenuButton, "CENTER")
    
    return DropDownMenuButton
end

-- init the dropdownmenu (only 2 levels)
function InitDDM(frame, level) 
frame.selectedName = SAL["Player"];
UIDropDownMenu_SetText(frame, frame.selectedName);

level = level or 1;
   if (level == 1) then
     for cat, subarray in pairs(frame.data) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = true; -- creates submenu
       info.notCheckable = true;
       info.text = SAL[cat];
       info.value = {
         ["Category"] = cat;
       };
       UIDropDownMenu_AddButton(info, level);
     end -- for category, subarray
   end -- if level 1

   if (level == 2) then
     -- getting values of first menu
     local category = UIDROPDOWNMENU_MENU_VALUE["Category"];
     sub = frame.data[category];
     for key, subsub in pairs(sub) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = false; -- no submenues this time
       info.notCheckable = true;
       info.text = subsub["name"];
       info.func = OnClick
       info.value = {
         ["Category"] = category;
         ["Sublevel_Key"] = key;
       };
       UIDropDownMenu_AddButton(info, level);
     end -- for key,subsub
   end -- if level 2
end

function DropDownMenu:LoadDropDownMenu(frame, data)
	local dropDownMenu = CreateDropDownButton(frame, data)
end