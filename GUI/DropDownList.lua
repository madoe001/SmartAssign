--Author: Bartlomiej Grabelus

local _G = _G

local SA_DropDownList = _G.GUI.SA_DropDownList

-- localization
local SAL = _G.GUI.Locales

-- for failurehandling
local assert, type = assert, type

-- height of the button
local BUTTON_HEIGHT = 25

-- SA_DropDownList:SetOnClick(): A setter for the OnClick Event
--
-- assertion: When func isn´t a function
--
-- frame: For which want to set the EventHandling
-- func: The function which want to set for the event
function SA_DropDownList:SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownList SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

-- SA_DropDownList:SetPoint(): To set the Point of the DropDownList outside the Class
--
-- framePosition: Region of the Frame
-- relativeToFrame: relative to which Frame want to position
-- relativePos: relative to the Region of the Frame, to which want to position
-- x: x movement of the Frame
-- y: y movement of the Frame
function SA_DropDownList:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

-- OnClick(): The OnClickEventHandling function for the DropDownList
--
-- Set the selectedID to the clicked ID
-- And set the selected ID of the DropDownList to the clicked ID with
-- UIDropDownMenu_SetSelectedID
--
-- self: The frame on which was clicked
local function OnClick(self)
	if self:GetID() == 1 then
		self.selectedId = SAL["Timer"]
	elseif self:GetID() == 2 then
		self.selectedId = SAL["Ability"]
	end
	print(self.selectedId)
       -- UIDropDownMenu_SetSelectedID(self, self:GetID())
end

-- SetData(): Setter for the data which want to set in the DropDownList
--
-- if data is empty then clear all points of the frame and set selectedID, data to nil
-- else set data and the selectedID to the startValue and set the selected ID, which want
-- have as selected with UIDropDownMenu_SetSelectedID()
--
-- frame: the frame on which want to set data and selectedID
-- data: the data which want to set in the DropDownList
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

-- CreateDropDownList(): Create a DropDownList
--
-- Create a DropDownListButton Frame and set the data for the DropDownList.
-- Than create a custom label for the DropDownList
--
-- UIDropDownMenu_Initialize(): for setting a initialize function
-- UIDropDownMenu_SetButtonWidth(): for setting the width of the Button
-- UIDropDownMenu_SetWidth(): for setting the width of the place for the text
-- UIDropDownMenu_JustifyText(): for justifing the text

local function CreateDropDownList(frame, name, data)
	local DropDownListButton = CreateFrame("Button", name, frame,"UIDropDownMenuTemplate")	
	SetData(DropDownListButton, data, nil)
	
	DropDownListButton:SetPoint("CENTER", 20, 0) -- 20 = x
	DropDownListButton:SetHeight(BUTTON_HEIGHT)
    DropDownListButton:RegisterForClicks("LeftButtonDown") -- only left click
    
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

-- InitDDL(): initialization function for the DropDownList
--
-- Sets at beginning "" for the Text of the Button
-- loop through the data and set the text, value and a function for the value, text
-- then add the info to the Button at level level.
--
-- self: the frame which init
-- level: at which want to set
function InitDDL(self, level)
   UIDropDownMenu_SetText(self, "");
   local info = UIDropDownMenu_CreateInfo()
   for key,value in pairs(self.data) do
      info = UIDropDownMenu_CreateInfo()
      info.text = value
      info.value = value
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

-- SA_DropDownList:GetSelectedID(): Getter for the selectedID
--
-- frame: of which want to get the selected ID
function SA_DropDownList:GetSelectedID(frame)
	return frame.selectedID
end

-- SA_DropDownList:SetSelectedID(): Setter for the selectedID
--
-- value: which want to set
function SA_DropDownList:SetSelectedID(value)
	DropDownListButton.selectedID = value
	UIDropDownMenu_SetSelectedID(DropDownListButton, value)
end

-- SA_DropDownList:LoadDropDownList(): Loader for the DropDownList
--
-- assertion: if the data is no table
--
-- frame: Parent frame
-- data: which want to set in the DropDownList

function SA_DropDownList:LoadDropDownList(frame, name, data)
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."])
	return CreateDropDownList(frame, name, data)
end
