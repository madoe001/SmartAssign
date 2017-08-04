-- Global vars --
local _G = _G
local SmartAssign = _G.SmartAssign
local DropDown = _G.SmartAssign.DropDown

-- for localization
setmetatable({}, {__index = SA_GUI})
local SAL = SmartAssign.Locales

-- tables
local SA_GUI = {}
local SA_GUI_LOCAL = {}
-- make GUI global --
SmartAssign.SA_GUI = SA_GUI

-- Load the whole Frame
function SA_GUI:LoadFrame()
	local mainFrame = CreateFrame("Frame","mainFrame",UIParent)
	mainFrame:SetScript("OnEvent",SA_GUI_LOCAL.Init)
	mainFrame:RegisterEvent("ADDON_LOADED")
end

-- function to init when addon has been loaded
function SA_GUI_LOCAL:Init(event, addon)
--print("addon: "..addon)
	if (event == "ADDON_LOADED" and addon == "SmartAssign") then
		SA_GUI_LOCAL:CreateGUI(mainFrame)
		-- color the text |cffHEXCOLOR STRING |r << EndTag
		print("|cff15c39a<|r|cff436eeeMBM|r|cff15c39a>|r"..
		"|cffffa500"..SAL["SmartAssign loaded more information added later."].."|r")
	end
end
	
-- for making a frame movable
function SA_GUI_LOCAL:MakeMovable(frame)
    frame:EnableMouse(true)
	frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

-- create GUI
function SA_GUI_LOCAL:CreateGUI(frame)
	local window = SA_GUI_LOCAL:CreateWindow(frame)
	
	-- close Button
	frame.closeButton = SA_GUI_LOCAL:CreateButton(frame, "closeButton", nil, 0, 0, "TOPRIGHT", 0, 0, "UIPanelCloseButton")
	
	-- create TitleBar
	SA_GUI_LOCAL:CreateTitleBar(frame)
	
	-- Title
	frame.title = SA_GUI_LOCAL:CreateFont(frame, "titleFont", SAL["SmartAssign"], nil, 0, 5, 22)
	
	--SA_GUI_LOCAL:CreateDropDown(frame, "SA_GUI_DropDown")
	
	-- make main frame movable
	SA_GUI_LOCAL:MakeMovable(frame)
end

-- create Window
function SA_GUI_LOCAL:CreateWindow(frame)
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

-- create a TitleBar
function SA_GUI_LOCAL:CreateTitleBar(frame)
	local titleBG = frame:CreateTexture(nil,"ARTWORK");
	titleBG:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
    titleBG:SetWidth(500);
    titleBG:SetHeight(80);
    titleBG:SetPoint("TOP", frame, 0, 20);
    frame.texture = MF_titleBG;
end

-- create a Button
function SA_GUI_LOCAL:CreateButton(frame, name, text, width, height, position, x, y, template)
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
function SA_GUI_LOCAL:CreateFont(frame, name, text, position, x, y, size)
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

function SA_GUI_LOCAL:CreateDropDown(frame, name) 
	DropDown:createMenu(frame, name)
end