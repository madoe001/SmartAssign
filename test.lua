
local startTime = 0
local endTime = 0
local totalTime = 0
local frame = CreateFrame("Frame")


function SmartAssign_OnEvent(frame, event, ...)
   print("OnEvent registered")
   if event == "PLAYER_REGEN_ENABLED" then
print("test regen enabled")
	endTime = GetTime()
	totalTime = endTime - startTime
	 if totalTime ~= 0 then
         print("Totaltime: " .. totalTime)
      end   
   elseif event == "PLAYER_REGEN_DISABLED" then
      startTime = GetTime()
   end 
end

frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")

frame:SetScript("OnEvent", SmartAssign_OnEvent)




-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- ????

--table
caric = {}
function caric:Init(event, addon)
	if(event == "ADDON_LOADED" and addon == "SmartAssign") then
		caric:CreateGUI(testFrame)
	end
end

-- frame erstellen und events registrieren
--testFrame = CreateFrame("Frame","testFrame",UIParent)
--testFrame:SetScript("OnEvent",caric.Init)
--testFrame:RegisterEvent("ADDON_LOADED")

local closeButton = CreateFrame("Button", "closeButton", testFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", testFrame)
-- when click on Button Hide frame
closeButton:SetScript("OnClick", function (self, button)
	if button == "LeftButton" then
		testFrame:Hide()
	end
end)


function caric:CreateGUI(frame)
	local window  = caric:CreateWindow(frame)
	local editBox = caric:CreateEditBox(frame,"editBox",70,30,100,-45)
	local closeButton = caric:CreateButton(frame, "closeButton", nil, 30, 30, 450,0, "UIPanelCloseBUtton")
	local addButton = caric:CreateButton(frame, "addButton", "add", 30, 30, 200,-45)
	addButton:SetScript("OnClick", function() addExpansionToList(editBox:GetText()) end)
	local deleteButton = caric:CreateButton(frame, "deleteButton", "delete", 40, 30, 310,-230)
	deleteButton:SetScript("OnClick", function() removeExpansionFromList(UIDropDownMenu_GetText(DropDownMenuTest) );
										 UIDropDownMenu_SetSelectedID(DropDownMenuTest, 1) end)
end

function caric:CreateWindow(frame)
	frame:SetWidth(500)
	frame:SetHeight(500)
	frame:SetPoint("CENTER",0,0)
	frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	frame:SetBackdropColor(0.0,0.0,0.0,1.0)
	return (frame)
end

function caric:CreateButton(frame, name, text, width, height, x, y, template)
	if(template == nil) then
		template = "OptionsButtonTemplate"
	end
	local button = CreateFrame("Button", name, frame, template)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetPoint("TOPLEFT",x,y)
	button:SetText(text)
	return (button)
end

function caric:CreateFont(frame, name, text, x, y, size)
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint("TOPLEFT",x,y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	return (fontString)
end

function caric:CreateEditBox(frame, name, width, height, x, y)
	local editBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")
	editBox:SetPoint("TOPLEFT",x,y)
	editBox:SetWidth(width)
	editBox:SetHeight(height)
	editBox:SetAutoFocus(false)
	editBox:Show()
	return (editBox)
end

function caric:CreateDropDownMenu(frame, name, width, x ,y)
	local dropDown = CreateFrame("Button", name, frame, "UIDropDownMenuTemplate")
	dropDown:ClearAllPoints()
	dropDown:SetPoint("TOPLEFT", 0, 0)
	UIDropDownMenu_SetWidth(dropDown, width);
    UIDropDownMenu_SetButtonWidth(dropDown, width + 24)
	
	UIDropDownMenu_Initialize(dropDown, initialize)
	UIDropDownMenu_SetSelectedID(dropDown, 1)
	UIDropDownMenu_JustifyText(dropDown, "LEFT")
	dropDown:Show()
	return (dropDown)
end

------------------------------------------------------------

if not DropDownMenuTest then
   CreateFrame("Button", "DropDownMenuTest", testFrame, "UIDropDownMenuTemplate")
end

DropDownMenuTest:ClearAllPoints()
DropDownMenuTest:SetPoint("CENTER", 0, 0)
DropDownMenuTest:Show()


function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownMenuTest, self:GetID())
end

function initialize(self, level)
	local info = UIDropDownMenu_CreateInfo()
	
	for k,v in pairs(SA_BossList) do
		info = UIDropDownMenu_CreateInfo()
		info.text = k
		info.value = v
		info.func = OnClick
		UIDropDownMenu_AddButton(info, level)
	end
	
end

UIDropDownMenu_Initialize(DropDownMenuTest, initialize)
UIDropDownMenu_SetWidth(DropDownMenuTest, 100);
UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 124)
UIDropDownMenu_SetSelectedID(DropDownMenuTest, 1)
UIDropDownMenu_JustifyText(DropDownMenuTest, "LEFT")
