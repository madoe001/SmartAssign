-- Author: Bartlomiej Grabelus (10044563)
-- Description: This Class creates the complett GUI of SmartAssign

-- Global vars --
local _G = _G
local SmartAssign = _G.SmartAssign

local GUI = _G.GUI

-- components
--local DropDownMenu = GUI.SA_DropDownMenu
--local ScrollFrame = GUI.SA_ScrollFrame
--local CheckBox = GUI.SA_CheckBox
--local EditBox = GUI.SA_EditBox
local AssignmentFrame = _G.GUI.AssignmentFrame
local CreateAbilityFrame = GUI.SA_CreateAbilityFrame
local flag = true

-- hud
local mainHUD = _G.HUD.mainHUD

local SlashCommands = _G.SmartAssign.SlashCommands
local MiniMapButton = SmartAssign.MiniMapButton

-- for localization
local GUIL = _G.GUI.Locales

-- tables
local SA_GUI = {}
local SA_GUI_LOCAL = {}

local Assignments = {}

-- make GUI global --
_G.SmartAssign.SA_GUI = SA_GUI

-- SA_GUI:LoadFrame(): Load the whole Frame where want to put the content
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI:LoadFrame()
	if not mainFrame then
		CreateFrame("Frame","mainFrame",UIParent)
		SA_GUI.frame = mainFrame
	end
	mainFrame:SetScript("OnEvent",SA_GUI_LOCAL.Init) -- set init function
	mainFrame:RegisterEvent("ADDON_LOADED")
end

-- SA_GUI_LOCAL:Init(): function to init when addon has been loaded
--
-- event: on which it was called
-- addon: name of addon
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:Init(event, addon)
	if (event == "ADDON_LOADED" and addon == "SmartAssign") then
		SA_GUI_LOCAL:CreateGUI(SA_GUI.frame)
		-- color the text |cffHEXCOLOR STRING |r << EndTag
		print("|cff15c39a<|r|cff436eee"..GUIL["SmartAssign"].."|r|cff15c39a>|r"..
		"|cffffa500"..GUIL["SmartAssign loaded. For more informartion about Slashcommands type in '/smart slash'."].."|r")
		SlashCommands:Init() -- init slashcommands
		SlashCommands:AddResetFunction(SA_GUI_LOCAL.ResetFrames, "frames")
		MiniMapButton:Init() -- init minimapbutton
		mainHUD:CreateMainHUD()
	end
end
	
-- SA_GUI_LOCAL:MakeMovable(): for making a frame movable
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:MakeMovable(frame)
    frame:EnableMouse(true)
	frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

-- SA_GUI_LOCAL:CreateGUI(): create content of the mainFrame
--
-- frame: Parent frame
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:CreateGUI(frame)
	frame = SA_GUI_LOCAL:CreateWindow(frame)
	
	-- close Button
	frame.closeButton = SA_GUI_LOCAL:CreateButton(frame, "closeButton", nil, 0, 0, "TOPRIGHT", -4, -4, "UIPanelCloseButton")
	
	-- create TitleBar
	SA_GUI_LOCAL:CreateTitleBar(frame)
	
	-- Title
	frame.title = SA_GUI_LOCAL:CreateFont(frame, "titleFont", GUIL["SmartAssign"], nil, 0, 5, 22)
	
	--frame.leftSide = SA_GUI_LOCAL:CreateLeftSide(frame) -- here put the scrollframe inside
	
	--frame.dropDownMenu = SA_GUI_LOCAL:CreateDropDownMenu(frame, DropDownMenu.data)
	--frame.dropDownMenu:Hide()
	
	-- frame.scrollFrame = SA_GUI_LOCAL:CreateScrollFrame(LeftSide, "InstanceScrollFrame")
	-- SlashCommands:AddResetFunction(SA_GUI_LOCAL.ScrollFrameReset,"ScrollFrame") -- add the reset function of the scrollframe to slashcommands
	-- SA_GUI_LOCAL:ScrollFrameReset()
		
	local boss = BossSelectFrame:show(frame, 200, frame:GetHeight(), "LEFT", 0, 0, "main")
	local assign = AssignmentFrame:new_scrollframe(frame, BossSelectFramus , 5, -100)
	frame.assign = assign
	table.insert(Assignments, assign)


	CreateAbilityFrame:CreateGUI(UIParent)

	-- make main frame movable
	SA_GUI_LOCAL:MakeMovable(frame)
	
end

-- SA_GUI_LOCAL:CreateWindow(): create Window(the mainFrame)
-- 
-- frame: the mainFrame
--
-- author: Bartlomiej Grabelus (10044563)
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
	
	frame:SetToplevel(false) -- set to top level
	
	frame:Hide() -- hide at beginning, show by slashcommand or clicking on minimapbutton
	
	return (frame)
end


-- SA_GUI_LOCAL:CreateTitleBar(): create a TitleBar(title header)
--
-- frame: Parent frame
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:CreateTitleBar(frame)
	local titleBG = frame:CreateTexture(nil,"ARTWORK");
	titleBG:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
    titleBG:SetWidth(500);
    titleBG:SetHeight(80);
    titleBG:SetPoint("TOP", frame, 0, 20);
    frame.texture = MF_titleBG;
end

-- SA_GUI_LOCAL:CreateButton(): create a Button
--
-- frame: Parent frame
-- name: name of button
-- text: which want to set in button
-- width: width of button
-- height: height of button
-- position: region, where want to position
-- x: x movement
-- y: y movement
-- template: of the button
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:CreateButton(frame, name, text, width, height, position, x, y, template)
	if template == nil then
		template = "OptionsButtonTemplate"
	end
	if position == nil then
		position = "TOPLEFT"
	end
	-- create CloseButton
	if template == "UIPanelCloseButton" then -- close button
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(position, frame, position, x, y)
		-- when click on Button Hide frame
		button:SetScript("OnClick", function (self, button)
			if button == "LeftButton" then
				frame:Hide()
			end
		end)
	else -- create another button
		local button = CreateFrame("Button", name, frame, template)
		button:SetPoint(position, x, y)
		button:SetWidth(width)
		button:SetHeight(height)
		button:SetText(text)
	end
	
	return (button)
end

-- SA_GUI_LOCAL:CreateFont(): create a FontString (Text)
--
-- frame: Parent frame
-- name: name of font
-- text: which want to set
-- position: region, where want to position
-- x: x movement
-- y: y movement
-- size: size of font
--
-- author: Bartlomiej Grabelus (10044563)
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

-- ALL COMMENTED NOT IN USE
-- SA_GUI_LOCAL:CreateLeftSide(): create a empty frame for the scrollframe
--
-- frame: Parent frame
--
-- author: Bartlomiej Grabelus (10044563)
-- function SA_GUI_LOCAL:CreateLeftSide(frame)
	-- if not LeftSide then
		-- LeftSide = CreateFrame("Frame", "LeftSide", frame)
	-- end
	-- LeftSide:SetBackdrop({
	-- bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	-- edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	-- tile = true, tileSize = 32, edgeSize = 25,
	-- insets = {left = 4, right = 4, top = 4, bottom = 4}
	-- })
	-- LeftSide:SetWidth(frame:GetWidth() * 0.3)
	-- LeftSide:SetHeight(frame:GetHeight()-40)
	-- LeftSide:SetPoint("TOPLEFT", frame, 20, -20)
	
	-- create a line
	--SA_GUI_LOCAL:CreateLine(LeftSide ,1, frame:GetHeight()-40, "RIGHT", LeftSide, 10, 0)
	-- 
	-- return LeftSide
-- end

-- SA_GUI_LOCAL:CreateScrollFrame(): create a ScrollFrame
--
-- frame: Parent frame
--
-- author: Bartlomiej Grabelus (10044563)
-- function SA_GUI_LOCAL:CreateScrollFrame(frame, name)
	-- return (ScrollFrame:LoadScrollFrame(frame, name))
-- end

--- SA_GUI_LOCAL:CreateLine(): function to create a line
-- if horizontal: height = 1 to 2
-- if vertical: width = 1 to 2
--
-- region: where to position
-- frame: relative to which frame
-- x: x movement
-- y: y movement
--
-- author: Bartlomiej Grabelus (10044563)
-- function SA_GUI_LOCAL:CreateLine(parent ,width, height, region, frame, x, y)
	-- local line = parent:CreateTexture()
	-- line:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    -- 
	-- line:SetSize(width , height)
	-- line:SetPoint(region, frame, x, y)
-- end
-- 

-- SA_GUI:Toggle(): toggle the GUI
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI:Toggle()
	if mainFrame:IsShown() then
		mainFrame:Hide()
	else
		mainFrame:Show()
	end
end

-- SA_GUI_LOCAL:ResetFrames(): reset function for the frames
-- ## IN DEVELOPMENT
--
-- author: Bartlomiej Grabelus (10044563)
function SA_GUI_LOCAL:ResetFrames()
	if SA_GUI.frame then
		SA_GUI.frame:ClearAllPoints()
		SA_GUI.frame:SetPoint("CENTER", SA_GUI.frame.x, SA_GUI.frame.y)
		--ScrollFrame:Reset(mainFrame)
	end
end

-- NOT IN USE
-- SA_GUI_LOCAL:ScrollFrameReset(): reset function for the scrollframe
--
-- author: Bartlomiej Grabelus (10044563)
-- function SA_GUI_LOCAL:ScrollFrameReset()
	-- ScrollFrame:Reset(mainFrame)
-- end
