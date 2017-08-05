local _G = _G

-- muss komplett überarbeitet werden

local DropDown = _G.GUI.DropDown

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
    assert(type(func) == "function", "'func' in 'DropDown SetOnClick' must be a function.")
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

-- geht noch nicht ändert auf Benutzerdefiniert
function OnClick(self)
	print(">> DropDown OnClick << called")   
	UIDropDownMenu_SetSelectedValue(DropDownButton, self:GetName());
end

-- clears the dropdownmenu, sets data and a startvalue
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	assert(type(data) == "table", "'data' must be a table. See 'Init.lua' at testData for infos.")
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

-- first create button than init
local function CreateDropDownButton(frame, data)
	if not DropDownButton then
		DropDownButton = CreateFrame("Button", "DropDownButton", frame,"UIDropDownMenuTemplate")
		DropDownMenu = CreateFrame('Frame', "DropDownMenu", DropDownButton)
	end
	
	SetData(DropDownButton, data, 1)
	
	DropDownButton:SetPoint("LEFT", 0, 0)
	DropDownButton:SetHeight(BUTTON_HEIGHT)
	DropDownButton:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")
    DropDownButton:RegisterForClicks("LeftButtonDown", "RightButtonDown") -- only right and left click
    
    DropDownButton.label = DropDownButton:CreateFontString("DropDownMenu-label", "ARTWORK", "GameFontNormalSmall")
	DropDownButton.label:SetPoint("LEFT", DropDownMenu, "LEFT")
	DropDownButton.label:SetHeight(BUTTON_HEIGHT)
	DropDownButton.label:SetJustifyH("LEFT")
	DropDownButton.label:SetText("DropDownMenu-label")
	
	DropDownMenu:Show()

	UIDropDownMenu_Initialize(DropDownButton, Init, "MENU");
    UIDropDownMenu_SetButtonWidth(DropDownButton, 124)
    UIDropDownMenu_SetWidth(DropDownButton, 130);
    UIDropDownMenu_JustifyText(DropDownButton, "LEFT")
    
    return DropDownButton
end

-- init the dropdownmenu (only 2 levels)
function Init(frame, level) 
frame.selectedName = "Player";
UIDropDownMenu_SetText(frame, frame.selectedName);

level = level or 1;
   if (level == 1) then
     for cat, subarray in pairs(frame.data) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = true; -- creates submenu
       info.notCheckable = true;
       info.text = cat;
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

function DropDown:LoadDropDownMenu(frame, data)
	local dropdown = CreateDropDownButton(frame, data)
end