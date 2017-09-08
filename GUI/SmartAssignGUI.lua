-- Global vars --
local _G = _G
local SmartAssign = _G.SmartAssign

local GUI = _G.GUI
local DropDownMenu = GUI.SA_DropDownMenu
local DropDownList = GUI.SA_DropDownList
local ScrollFrame = GUI.SA_ScrollFrame
local CheckBox = GUI.SA_CheckBox
local EditBox = GUI.SA_EditBox
local TimerGUI = GUI.SA_TimerGUI

local mainHUD = _G.HUD.mainHUD

local SlashCommands = _G.SmartAssign.SlashCommands
local MiniMapButton = SmartAssign.MiniMapButton

-- for localization
local SAL = _G.GUI.Locales

-- tables
local SA_GUI = {}
local SA_GUI_LOCAL = {}
local Assignments = {}
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
		"|cffffa500"..SAL["SmartAssign loaded. For more informartion about Slashcommands type in '/smart slash'."].."|r")
		SlashCommands:Init()
		SlashCommands:AddResetFunction(SA_GUI_LOCAL.ResetFrames, "frames")
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
-- ######################## NEXT Container für Frames und Hide über eine func welche im container sucht und Hide ausführt und ein HideAll
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
	frame.dropDownMenu:Hide()
	
	frame.dropDownList = SA_GUI_LOCAL:CreateDropDownList(frame, DropDownList.data)
	frame.dropDownList:Hide()
	
	frame.scrollFrame = SA_GUI_LOCAL:CreateScrollFrame(LeftSide, frame.dropDownList)
	SlashCommands:AddResetFunction(SA_GUI_LOCAL.ScrollFrameReset,"ScrollFrame")
		
	local timerGUI = TimerGUI:new_assignment(frame, frame.dropDownList , 5, 0)
	timerGUI:Hide()
	frame.tg = timerGUI
	
	table.insert(Assignments, timerGUI)

	frame.timerCheckBox = SA_GUI_LOCAL:CreateCheckBox(frame, SAL["Ability"])
	frame.timerCheckBox:Hide()
	
	frame.extraCheckBox = SA_GUI_LOCAL:CreateCheckBox(frame, SAL["Extra Text"])
	frame.extraCheckBox:Hide()
	
	frame.editbox = SA_GUI_LOCAL:CreateEditBox(frame, "number")
	EditBox:SetMaxLetters(frame.editbox, 6) -- number size --> 6
	frame.editbox:Hide()
	

	
	SA_GUI_LOCAL:SetScripts()
	

	
	DropDownList:SetPoint("TOPLEFT", frame, 20 + frame.leftSide:GetWidth(), -50 * #Assignments )
	EditBox:SetPoint("LEFT", frame.dropDownList, "RIGHT", 5, 0)
	DropDownMenu:SetPoint("LEFT", frame.editbox, "RIGHT", 0, 0)
	frame.timerCheckBox:SetPoint("TOP", frame.dropDownMenu, "BOTTOM", 0, 0)
	frame.extraCheckBox:SetPoint("TOP", frame.timerCheckBox, "BOTTOM", 0, 0)
	
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
		LeftSide = CreateFrame("Frame", "LeftSide", frame)
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
		button:SetScript("OnClick", function (self, button)
			if button == "LeftButton" then
				frame:Hide()
			end
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

function SA_GUI_LOCAL:CreateCheckBox(frame, checkboxText)
	return (CheckBox:LoadCheckBox(frame, checkboxText))
end

function SA_GUI_LOCAL:CreateEditBox(frame, inputType)
	return (EditBox:LoadEditBox(frame,  inputType))
end

function LoadHUD()
	mainHUD:LoadHUD()
end

function SA_GUI_LOCAL:SetScripts()
	mainFrame.timerCheckBox:SetScript("OnClick", function(self, button, down)
		if mainFrame.timerCheckBox:GetChecked() then
			mainFrame.extraCheckBox:Disable()
		else
			mainFrame.extraCheckBox:Enable()
		end
	end)
	
	mainFrame.extraCheckBox:SetScript("OnClick", function(self, button, down)
	if mainFrame.extraCheckBox:GetChecked() then
			mainFrame.timerCheckBox:Disable()
		else
			mainFrame.timerCheckBox:Enable()
		end
	end)
	
	mainFrame:SetScript("OnUpdate", function(self, elapsed)
		if mainFrame.scrollFrame.instanceButton ~= nil then
			if mainFrame.scrollFrame.bossButton ~= nil then
				mainFrame.dropDownList:Show()
			else
				mainFrame.dropDownList:Hide()
			end
		end
		if DropDownList:GetSelectedID(mainFrame.dropDownList) ~= nil then
			--[[if DropDownList:GetSelectedID(frame.dropDownList) == 1 then
				frame.editbox:Show()
			else
				frame.editbox:Hide()
			end]]
			if DropDownList:GetSelectedID(mainFrame.dropDownList) == 2 and mainFrame.scrollFrame.bossButton then
				mainFrame.tg:Show()
				--mainFrame.editbox:Show()
			else
				mainFrame.tg:Hide()
				--mainFrame.editbox:Hide()
			end
		end
		--if (mainFrame.editbox:GetText() == "" or mainFrame.editbox:GetText() == "0") then
		--	mainFrame.dropDownMenu:Hide()
		--	mainFrame.timerCheckBox:Hide()
		--	mainFrame.extraCheckBox:Hide()
		--else
		--	mainFrame.dropDownMenu:Show()
		--	mainFrame.timerCheckBox:Show()
		--	mainFrame.extraCheckBox:Show()
		--end
	end)
end

function SA_GUI:Toggle()
	if mainFrame:IsShown() then
		mainFrame:Hide()
	else
		mainFrame:Show()
	end
end

function SA_GUI_LOCAL:ResetFrames()
	if SA_GUI.frame then
		SA_GUI.frame:ClearAllPoints()
		SA_GUI.frame:SetPoint("CENTER", SA_GUI.frame.x, SA_GUI.frame.y)
		SA_GUI.frame.dropDownList:Hide()
		DropDownList:SetSelectedID(nil) -- wird zu benutzerdefiniert
		SA_GUI.frame.editbox:Hide()
		SA_GUI.frame.dropDownMenu:Hide()
		SA_GUI.frame.timerCheckBox:Hide()
		SA_GUI.frame.extraCheckBox:Hide()
		ScrollFrame:Reset(mainFrame)
	end
end

function SA_GUI_LOCAL:ScrollFrameReset()
	ScrollFrame:Reset(mainFrame)
end
