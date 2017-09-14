--Author: Bartlomiej Grabelus

local _G = _G

local mainHUD = _G.HUD.mainHUD
local bossPlate = _G.HUD.BossPlate
local bossSpellIcon = _G.HUD.BossSpellIcon

local SAL = _G.GUI.Locales

local playerName, playerGUID = UnitName("player"), UnitGUID("player")

local isInstance
local instanceType
local instanceName
local unit
local hudFrame

function mainHUD:CreateMainHUD()
	hudFrame = CreateFrame("Frame","hudFrame",UIParent)
	--hudFrame:SetFrameStrata('BACKGROUND')
	hudFrame:SetWidth(UIParent:GetWidth())
	hudFrame:SetHeight(UIParent:GetHeight())
	hudFrame:ClearAllPoints()
	hudFrame:SetPoint("CENTER", 0, 0)
	hudFrame:Show()
	
	hudFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	hudFrame:SetScript("OnEvent", mainHUD.OnEnteringEvent_TestInstance)
	--hudFrame:Hide()
	CreateBossPlate(hudFrame)
	CreateBossSpellIcon(hudFrame)
end

function mainHUD:Show()
	self:Show()
end

function mainHUD:OnEnteringEvent_TestInstance(event)
	if (event == "PLAYER_ENTERING_WORLD" ) then
		local isInstance, instanceType = IsInInstance()
		if isInstance then
			--print(SAL["Player is in Instance."])
			isInstance = isInstance
			if instanceType == "party" or instanceType == "raid" then
				instanceType = instanceType
			end
		else
			--print("|cFFFF0000"..SAL["Player is not in Instance."].."|r")
		end
	end
end

function mainHUD:IsInInstance()
	return isInstance
end

function mainHUD:InstanceType()
	return instanceType
end

function CreateBossPlate(frame)
	bossPlate:CreateBossPlate(frame)
end

function CreateBossSpellIcon(frame)
	bossSpellIcon:CreatebossSpellIcon(frame)
end