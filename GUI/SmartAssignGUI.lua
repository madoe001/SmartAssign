-- tables
SA_GUI = {}

-- for localization
setmetatable({}, {__index = SA_GUI})

local L = SA_GUI_Translations

-- function to init when addon has been loaded
function SA_GUI:Init(event, addon)
--print("addon: "..addon)
	if (event == "ADDON_LOADED" and addon == "SmartAssign") then
		SA_GUI:CreateGUI(mainFrame)
		-- color the text |cffHEXCOLOR STRING |r << EndTag
		print("|cff15c39a<|r|cff436eeeMBM|r|cff15c39a>|r"..
		"|cffffa500"..L["SmartAssign loaded more information added later."].."|r")
	end
end

-- create main frame
local mainFrame = CreateFrame("Frame","mainFrame",UIParent)
mainFrame:SetScript("OnEvent",SA_GUI.Init)
mainFrame:RegisterEvent("ADDON_LOADED")

-- for making a frame movable
function SA_GUI:MakeMovable(frame)
    frame:EnableMouse(true)
	frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

-- create GUI
function SA_GUI:CreateGUI(frame)
	local window = SA_GUI:CreateWindow(frame)
	
	-- close Button
	frame.closeButton = SA_GUI:CreateButton(frame, "closeButton", nil, 0, 0, "TOPRIGHT", 0, 0, "UIPanelCloseButton")
	
	-- create TitleBar
	SA_GUI:CreateTitleBar(frame)
	
	-- Title
	frame.title = SA_GUI:CreateFont(frame, "titleFont", L["SmartAssign"], nil, 0, 5, 22)
	
	-- make main frame movable
	SA_GUI:MakeMovable(frame)
end

-- create Window
function SA_GUI:CreateWindow(frame)
	frame:SetWidth(1000) --Breite in px
	frame:SetHeight(500) -- Hoehe in px
	local x = 0
	local y = 50
	frame:SetPoint("CENTER",x,y)
	
	frame:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	
	return (frame)
end

function SA_GUI:CreateTitleBar(frame)
	local titleBG = frame:CreateTexture(nil,"ARTWORK");
	titleBG:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
    titleBG:SetWidth(500);
    titleBG:SetHeight(80);
    titleBG:SetPoint("TOP", frame, 0, 20);
    frame.texture = MF_titleBG;
end

-- create a Button
function SA_GUI:CreateButton(frame, name, text, width, height, position, x, y, template)
	if template == nil then
		template = "OptionsButtonTemplate"
	end
	if position == nil then
		position = "TOPLEFT"
	end
	-- create CloseButton
	if template == "UIPanelCloseButton" then
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(position, frame, position)
		-- when click on Button Hide frame
		button:SetScript("OnClick", function ()
		frame:Hide()
		end)
	else
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(positon, x, y)
		button:SetWidth(width)
		button:SetHeight(height)
		button:SetText(text)
	end
	
	return (button)
end

-- create a Font
function SA_GUI:CreateFont(frame, name, text, position, x, y, size)
	if size == nil then
		size = 15
	end
	if position == nil then
		position = "TOP"
	end
	
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint(position, x, y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	
	return (fontString)
end