local _G = _G

local SmartAssign = _G.SmartAssign
local SlashCommands = SmartAssign.SlashCommands
local MiniMapButton = {}
SmartAssign.MiniMapButton = MiniMapButton
local SAL = SmartAssign.Locales
local minimap = SmartAssign.minimap
local SAButton = LibStub("LibDBIcon-1.0")

-- lua
local type = type
local abs, sqrt = math.abs, math.sqrt

-- LDB
if not LibStub:GetLibrary("LibDataBroker-1.1", true) then return end

--Make an LDB object
local MiniMapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("SmartAssign", {
	type = "launcher",
	text = SAL["SmartAssign"],
	icon = "Interface\\Icons\\achievment_Boss_spineofdeathwing",
	OnTooltipShow = function(tooltip)
		tooltip:AddLine("|cff436eee"..SAL["SmartAssign"].."|r");
		tooltip:AddLine(SAL["SmartAssign_Minimap_Clicks"]);
	end,
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

function MiniMapButton:Init()
	SlashCommands:Add("mmb", MiniMapButton.Toggle, SAL["/sa mmb - Toggle MiniMapButton."])
	SlashCommands:AddResetFunction(MiniMapButton.ResetFrames, "miniMapButton")

	SAButton:Register("SmartAssign", MiniMapLDB, minimap);
end

function MiniMapButton.ResetFrames()
	minimap.minimapPos = 218;
	SAButton:Refresh("SmartAssign");
end

function MiniMapButton.Toggle()
	minimap.shown = not minimap.shown
	minimap.hide = not minimap.hide
	if not minimap.hide then
		SAButton:Show("SmartAssign")
	else
		SAButton:Hide("SmartAssign")
	end
end

function MiniMapButton.Options_Toggle()
	if minimap.shown then
		SAButton:Show("SmartAssign")
		minimap.hide = nil
	else
		SAButton:Hide("SmartAssign")
		minimap.hide = true
	end
end

function MiniMapButton.Lock_Toggle()
	if minimap.locked then
		SAButton:Lock("SmartAssign");
	else
		SAButton:Unlock("SmartAssign");
	end
end
