-- tables
MBM_GUI = {}

-- for localization
setmetatable({}, {__index = MBM_GUI})

local L = MBM_GUI_Translations

-- function to init when addon has been loaded
function MBM_GUI:Init(event, addon)
--print("addon: "..addon)
	if (event == "ADDON_LOADED" and addon == "Multi-Boss-ModGUI") then
		MBM_GUI:CreateGUI(mainFrame)
		-- color the text |cffHEXCOLOR STRING |r << EndTag
		print("|cff15c39a<|r|cff436eeeMBM|r|cff15c39a>|r"..
		"|cffffa500"..L.START_INFO.."|r")
	end
end

-- create main frame
local mainFrame = CreateFrame("Frame","mainFrame",UIParent)
mainFrame:SetScript("OnEvent",MBM_GUI.Init)
mainFrame:RegisterEvent("ADDON_LOADED")

-- for making a frame movable
function MBM_GUI:MakeMovable(frame)
    frame:EnableMouse(true)
	frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

-- create GUI
function MBM_GUI:CreateGUI(frame)
	local window = MBM_GUI:CreateWindow(frame)
	
	-- close Button
	frame.closeButton = MBM_GUI:CreateButton(frame, "closeButton", nil, 0, 0, "TOPRIGHT", 0, 0, "UIPanelCloseButton")
	
	-- create TitleBar
	MBM_GUI:CreateTitleBar(frame)
	
	-- Title
	frame.title = MBM_GUI:CreateFont(frame, "titleFont", L.TITLE, nil, 0, 5, 22)
	
	-- make main frame movable
	MBM_GUI:MakeMovable(frame)
end

-- create Window
function MBM_GUI:CreateWindow(frame)
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

function MBM_GUI:CreateTitleBar(frame)
	local titleBG = frame:CreateTexture(nil,"ARTWORK");
	titleBG:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
    titleBG:SetWidth(500);
    titleBG:SetHeight(80);
    titleBG:SetPoint("TOP", frame, 0, 20);
    frame.texture = MF_titleBG;
end

-- create a Button
function MBM_GUI:CreateButton(frame, name, text, width, height, position, x, y, template)
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
function MBM_GUI:CreateFont(frame, name, text, position, x, y, size)
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