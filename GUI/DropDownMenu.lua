--Author: Bartlomiej Grabelus (10044563)


-- global vars
local _G = _G

local SA_DropDownMenu = _G.GUI.SA_DropDownMenu

-- localization
local SAL = _G.GUI.Locales

-- used in OnClick
local DropDownData = {}

-- for failurehandling
local assert, type = assert, type

local BUTTON_HEIGHT = 25

-- GetArraySize(): lua function to get table size
-- 
-- T: the table
--
-- author: Bartlomiej Grabelus (10044563)
function GetArraySize(T)
	local lengthNum = 0
	for k,v in pairs(T) do -- for every key in the table with a corresponding non-nil value 
		lengthNum = lengthNum + 1
	end
	return lengthNum
end

-- SA_DropDownMenu:SetOnClick(): A setter for the OnClick Event
--
-- assertion: When func isn´t a function
--
-- frame: For which want to set the EventHandling
-- func: The function which want to set for the event
--
-- author: Bartlomiej Grabelus (10044563)
function SA_DropDownMenu:SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownMenu SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

-- SA_DropDownMenu:SetPoint(): To set the Point of the DropDownMenu outside the Class
--
-- framePosition: Region of the Frame
-- relativeToFrame: relative to which Frame want to position
-- relativePos: relative to the Region of the Frame, to which want to position
-- x: x movement of the Frame
-- y: y movement of the Frame
--function SA_DropDownMenu:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
--	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
--end

-- GetSelectedItem(): Getter for the selected item
--
-- DropDownData could be changed to frame.data
--
-- self: of which want to get the selected Item
--
-- author: Bartlomiej Grabelus (10044563)
local function GetSelectedItem(self)
	return DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"]
end

-- OnClick(): OnClickEvent function
--
-- Set the Text of the Button to the selected item
--
-- self: on which do eventhandling
--
-- author: Bartlomiej Grabelus (10044563)
function OnClick(self)
	--print(">> DropDownMenu OnClick << called "..DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"])  
	UIDropDownMenu_SetText(DropDownMenuButton, DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"]); -- geht immer noch nicht
end

-- SetData(): Setter for the data which want to set in the DropDownMenu
--
-- if data is empty then clear all points of the frame and set selectedID, data to nil
-- else set data and the selectedID to the startValue and set the selected ID, which want
-- have as selected with UIDropDownMenu_SetSelectedID()
--
-- frame: the frame on which want to set data and selectedID
-- data: the data which want to set in the DropDownList
--
-- author: Bartlomiej Grabelus (10044563)
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	DropDownData = data
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

-- CreateDropDownList(): Create a DropDownList
--
-- Create a DropDownMenuButton and the DropDownMenu Frame and set the data for the DropDownMenu.
-- Than create a custom label for the DropDownMenu
--
-- UIDropDownMenu_Initialize(): for setting a initialize function
-- UIDropDownMenu_SetButtonWidth(): for setting the width of the Button
-- UIDropDownMenu_SetWidth(): for setting the width of the place for the text
-- UIDropDownMenu_JustifyText(): for justifing the text
--
-- author: Bartlomiej Grabelus (10044563)
local function CreateDropDownButton(frame, buttonName, menuName, data)
	local DropDownMenuButton = CreateFrame("Button", buttonName, frame,"UIDropDownMenuTemplate")
	local DropDownMenu = CreateFrame('Frame', menuName, DropDownMenuButton)
	
	SetData(DropDownMenuButton, data, 1)
	DropDownMenuButton:SetBackdrop({ 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false, tileSize = 10, edgeSize = 20,
	insets = {left = 1, right = 1, top = 5, bottom = 1}
	})
	
	--DropDownMenuButton:SetPoint("LEFT", 20, 0) -- 20 = x
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

-- InitDDL(): initialization function for the DropDownMenu
--
-- Sets at beginning "Player" for the Text of the Button
-- and for selectedName.
-- loop through the data and set the text, value and a function for the value, text
-- then add the info to the Button at level level.
--
-- self: the frame which init
-- level: at which want to set (only 2 levels)
--
-- author: Bartlomiej Grabelus (10044563)
function InitDDM(frame, level) 
frame.selectedName = SAL["Player"];
UIDropDownMenu_SetText(frame, frame.selectedName);

level = level or 1; -- level 1 data (Classes)
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
   end

	-- level 2 of the DropDownMenu, names of the player
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
   end
end

-- SA_DropDownMenu:LoadDropDownMenu(): Loader for the DropDownMenu
--
-- assertion: if the data is no table
--
-- frame: Parent frame
-- data: which want to set in the DropDownMenu
--
-- author: Bartlomiej Grabelus (10044563)
function SA_DropDownMenu:LoadDropDownMenu(frame, buttonName, menuName, data)
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."])
	return CreateDropDownButton(frame, buttonName, menuName, data)
end
