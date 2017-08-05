local _G = _G

-- muss komplett überarbeitet werden und ergänzt

local DropDown = {}
SmartAssign.SA_GUI.DropDown = DropDown

-- for failurehandling
local assert, type = assert, type

local BUTTON_HEIGHT = 25

-- onClick setter
local function SetOnClick(self, func)
	if func and type(func) == "function" then
		self.ButtonOnClick = func
	else
		self.ButtonOnClick = nil
	end
end

local function SetWidth(level)
	local width = 100;
	if level = 2 then
		for cat, sub in pairs(DropDown.data) do
			local catStrLenght = string.len(cat)
			for key, subsub in pairs(sub)
				local subStrLength = string.len(subsub["name"])
				if catStrLenght < subStrLength then
					width = subStrLenght
				end
			end
		end
	else
		for i = 1, #DropDown.data, 1 do
			local lastStrLength = string.len(data[i])
			for j = i, #DropDown.data, 1 do
				local nextStrLength = string.len(data[j])
				if lastStrLenght > nextStrLength then
					width = lastStrLenght
				end
			end
		end
	end
	UIDropDownMenu_SetWidth(dropdown, width);
end

local function SetData(self, data, startValue)
	if not data then
		self:Clear()
		self.data = nil
		self.selectedId = nil
		return
	end
	assert(type(data) == "table", "'data' must be a table. See 'Init.lua' at testData for infos.")
	self.data = data
	self.selectedId = startValue
	if startValue then
		self:SetSelected(startValue)
	end
end

-- first create button than init
local function CreateDropDownButton(frame, data)
	if not DropDownMenu then
		CreateFrame("Button", "DropDownMenu", frame, "UIDropDownMenuTemplate")
	end
	SetData(DropDownMenu, DropDown.data, 1)
	SetWidth(DropDownMenu, 2);
	
	DropDownMenu:SetPoint("LEFT", 5, 0)
	DropDownMenu:SetHeight(BUTTON_HEIGHT)
	DropDownMenu:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    DropDownMenu:RegisterForClicks("LeftButtonDown", "RightButtonDown") -- only right and left click
    
    DropDownMenu.label = DropDownMenu:CreateFontString("DropDownMenu-label", "ARTWORK", "GameFontNormalSmall")
	DropDownMenu.label:SetPoint("LEFT", DropDownMenu, "LEFT")
	DropDownMenu.label:SetHeight(BUTTON_HEIGHT)
	DropDownMenu.label:SetJustifyH("LEFT")
	DropDownMenu.label:SetText("DropDownMenu-label")
	
	DropDownMenu.check = DropDownMenu:CreateTexture("DropDownMenu-check", "ARTWORK")
	DropDownMenu.check:SetPoint("LEFT", DropDownMenu, "LEFT", 0, 0)
	DropDownMenu.check:SetHeight(BUTTON_HEIGHT)
	DropDownMenu.check:SetWidth(BUTTON_HEIGHT)
	DropDownMenu.check:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
	DropDownMenu.check:SetTexCoord(0,0.5,0.5,1.0)
	DropDownMenu.check:Hide()
	
	DropDownMenu:SetScript("OnClick", ButtonOnClick)
	
	DropDownMenu:ClearAllPoints()
	DropDownMenu:Show()
	
	UIDropDownMenu_Initialize(DropDownMenu, Init)
    UIDropDownMenu_SetButtonWidth(DropDownMenu, 124)
    UIDropDownMenu_JustifyText(DropDownMenu, "LEFT")
    
    return DropDownMenu
end

-- init the dropdownmenu
local function Init(self, level)
level = level or 1;
   if (level == 1) then
     for cat, subarray in pairs(self.data) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = true; -- creates submenu
       info.notCheckable = true;
       info.text = cat.info.name;
       info.value = {
         ["Category"] = key;
       };
       UIDropDownMenu_AddButton(info, level);
     end -- for key, subarray
   end -- if level 1

   if (level == 2) then
     -- getting values of first menu
     local category = UIDROPDOWNMENU_MENU_VALUE["Category"];
     sub = self.data[category];
     for key, subsub in pairs(sub) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = false; -- no submenues this time
       info.notCheckable = true;
       info.text = subsub["name"];
       -- use info.func to set a function to be called at "click"
       info.value = {
         ["Category"] = category;
         ["Sublevel_Key"] = key;
       };
       UIDropDownMenu_AddButton(info, level);
     end -- for key,subsubarray
   end -- if level 2
end

function DropDown:LoadDropDownMenu(frame, data)
	local dropdown = CreateDropDownButton(frame, data)
	UIDropDownMenu_Initialize(dropdown, Init, "MENU");
	ToggleDropDownMenu(1, nil, dropdown, self, -20, 0);
end