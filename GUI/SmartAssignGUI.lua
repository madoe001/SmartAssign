-- Global vars --
local _G = _G
local SmartAssign = _G.SmartAssign
local DropDownMenu = _G.GUI.SA_DropDownMenu
local DropDownList = _G.GUI.SA_DropDownList
local ScrollFrame = _G.GUI.SA_ScrollFrame
local SlashCommands = _G.SmartAssign.SlashCommands
local MiniMapButton = SmartAssign.MiniMapButton

-- for localization
setmetatable({}, {__index = SA_GUI})
local SAL = SmartAssign.Locales

-- tables
local SA_GUI = {}
local SA_GUI_LOCAL = {}
-- make GUI global --
_G.SmartAssign.SA_GUI = SA_GUI

-- Load the whole Frame
function SA_GUI:LoadFrame()
	if not mainFrame then
		CreateFrame("Frame","mainFrame",UIParent)
		SA_GUI.frame = mainFrame
	end
	mainFrame:SetScript("OnEvent",SA_GUI_LOCAL.Init)
	mainFrame:RegisterEvent("ADDON_LOADED")
end

-- function to init when addon has been loaded
function SA_GUI_LOCAL:Init(event, addon)
--print("addon: "..addon)
	if (event == "ADDON_LOADED" and addon == "SmartAssign") then
		SA_GUI_LOCAL:CreateGUI(SA_GUI.frame)
		-- color the text |cffHEXCOLOR STRING |r << EndTag
		print("|cff15c39a<|r|cff436eee"..SAL["SmartAssign"].."|r|cff15c39a>|r"..
		"|cffffa500"..SAL["SmartAssign loaded more information added later."].."|r")
		SlashCommands:Init()
		SlashCommands:AddResetFunction(SA_GUI.ResetFrames, "frames")
		MiniMapButton:Init()
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
	
	frame.leftSide = SA_GUI_LOCAL:CreateLeftSide(frame)
	
	frame.dropDownMenu = SA_GUI_LOCAL:CreateDropDownMenu(frame, DropDownMenu.data)
	
	frame.dropDownList = SA_GUI_LOCAL:CreateDropDownList(frame, DropDownList.data)
	
	frame.scrollFrame = SA_GUI_LOCAL:CreateScrollFrame(LeftSide)
	
	DropDownMenu:SetPoint("LEFT", frame.leftSide, "RIGHT", 0, 0)
	DropDownList:SetPoint("LEFT", frame.dropDownMenu, "RIGHT", 0, 0)
	
	-- make main frame movable
	SA_GUI_LOCAL:MakeMovable(frame)
end

-- create Window
function SA_GUI_LOCAL:CreateWindow(frame)
	frame:ClearAllPoints()
	frame:SetWidth(1000) --Breite in px
	frame:SetHeight(500) -- Hoehe in px
	frame.x = 0
	frame.y = 50
	frame:SetPoint("CENTER",frame.x,frame.y)
	
	frame:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	
	frame:SetToplevel(true)
	
	frame:Hide()
	
	return (frame)
end

function SA_GUI_LOCAL:CreateLeftSide(frame)
	if not LeftSide then
		LeftSide = CreateFrame("Frame", "SA_LeftFrame", frame)
	end
	LeftSide:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 25,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	LeftSide:SetWidth(frame:GetWidth() * 0.3)
	LeftSide:SetHeight(frame:GetHeight()-40)
	LeftSide:SetPoint("TOPLEFT", frame, 20, -20)
	
	return LeftSide
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

function SA_GUI_LOCAL:CreateDropDownMenu(frame, data) 
	return (DropDownMenu:LoadDropDownMenu(frame, data))
end

function SA_GUI_LOCAL:CreateDropDownList(frame, data) 
	return (DropDownList:LoadDropDownList(frame, data))
end

function SA_GUI_LOCAL:CreateScrollFrame(frame)
	return (ScrollFrame:LoadScrollFrame(frame))
end

function SA_GUI:Toggle()
	if mainFrame:IsShown() then
		mainFrame:Hide()
	else
		mainFrame:Show()
	end
end

function SA_GUI.ResetFrames()
	if SA_GUI.frame then
		SA_GUI.frame:ClearAllPoints()
		SA_GUI.frame:SetPoint("CENTER", SA_GUI.frame.x, SA_GUI.frame.y)
	end
end