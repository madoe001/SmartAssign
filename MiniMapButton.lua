--Author: Bartlomiej Grabelus

local _G = _G

local SmartAssign = _G.SmartAssign
local SlashCommands = SmartAssign.SlashCommands

local MiniMapButton = {}
SmartAssign.MiniMapButton = MiniMapButton

-- localization
local SAL = _G.GUI.Locales

-- minimap data
local minimap = SmartAssign.minimap

-- the minimap button
local SAButton = LibStub("LibDBIcon-1.0")

-- lua
local type = type
local abs, sqrt = math.abs, math.sqrt

-- get the LDB libary over libstub
if not LibStub:GetLibrary("LibDataBroker-1.1", true) then return end

--Make an LDB object, with data of the button
local MiniMapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("SmartAssign", {
	type = "launcher",
	text = SAL["SmartAssign"],
	icon = "Interface\\Icons\\achievment_Boss_spineofdeathwing",
	OnTooltipShow = function(tooltip) -- add a tooltip
		tooltip:AddLine("|cff436eee"..SAL["SmartAssign"].."|r");
		tooltip:AddLine(SAL["SmartAssign_Minimap_Clicks"]);
	end,
	-- when minimapbutton was clicked then reset all else show GUI
	OnClick = function(self, button)
		if button == "LeftButton" then
			if minimap.clicked == true then
				SlashCommands:Run("reset","frames")
			end
			minimap.clicked = true	
			SlashCommands:Run("")
		end
	end,
})

-- MiniMapButton:Init(): init function for the minimapbutton
-- 
-- add a slashcommand to toggle the minimapbutton and add a reset function for the minimapbutton
function MiniMapButton:Init()
	SlashCommands:Add("mmb", MiniMapButton.Toggle, SAL["/smart mmb - Toggle MiniMapButton."])
	SlashCommands:AddResetFunction(MiniMapButton.ResetFrames, "miniMapButton")

	SAButton:Register("SmartAssign", MiniMapLDB, minimap); -- register the data to the button
end

-- MiniMapButton.ResetFrames(): reset the minimap position and refresh the position of the button
function MiniMapButton.ResetFrames()
	minimap.minimapPos = 210;
	SAButton:Refresh("SmartAssign");
end

-- MiniMapButton.Toggle(): for toggle the minimapbutton
-- 
-- negate the variable shown and hide
-- and check if the minimapbutton is shown.
-- Then hide or show the minimapbutton
function MiniMapButton.Toggle()
	minimap.shown = not minimap.shown
	minimap.hide = not minimap.hide
	if not minimap.hide then
		SAButton:Show("SmartAssign")
	else
		SAButton:Hide("SmartAssign")
	end
end

-- MiniMapButton.Lock_Toggle(): for locking the minimapbutton,
-- if wanted
function MiniMapButton.Lock_Toggle()
	if minimap.locked then
		SAButton:Lock("SmartAssign");
	else
		SAButton:Unlock("SmartAssign");
	end
end
