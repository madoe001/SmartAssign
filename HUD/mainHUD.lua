--Author: Bartlomiej Grabelus (10044563)

-- global vars
local _G = _G

local mainHUD = _G.HUD.mainHUD
local bossPlate = _G.HUD.BossPlate
local bossSpellIcon = _G.HUD.BossSpellIcon

local HUDL = _G.HUD.Locales

local playerName, playerGUID = UnitName("player"), UnitGUID("player") -- info of player

-- vars
local isInstance -- needed to check if is Instance
local instanceType -- needed to check the instance type e.g group
local instanceName -- needed to store the instance name
local unit
local hudFrame

-- NEXT alle holen boss1 bis boss5 und dann nameplates usw erstellen
-- NEXT Debuffs

-- mainHUD:CreateMainHUD(); creates the mainHUD, which is invisible for player, only for orantation, where to place
-- the components
--
-- used Event:
-- PLAYER_ENTERING_WORLD: needed to fire when the player enters the world, instance
--
-- author: Bartlomiej Grabelus (10044563)
function mainHUD:CreateMainHUD()
	hudFrame = CreateFrame("Frame","hudFrame",UIParent)
	hudFrame:SetFrameStrata('BACKGROUND')
	hudFrame:SetWidth(UIParent:GetWidth())
	hudFrame:SetHeight(UIParent:GetHeight())
	hudFrame:ClearAllPoints()
	hudFrame:SetPoint("CENTER", 0, 0)
	hudFrame:Show()
	
	hudFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	hudFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	hudFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	hudFrame:SetScript("OnEvent", mainHUD.OnEnteringEvent_TestInstance)
	--hudFrame:Hide()
end

-- mainHUD:Show(): function to show mainHUD, at moment not needed
--
-- author: Bartlomiej Grabelus (10044563)
function mainHUD:Show()
	self:Show()
end

-- mainHUD:OnEnteringEvent_TestInstance(): function which is called when the event fires
-- where we setup a nameplate and spellicons, when target is one of the bosses
--
-- event: which fires
--
-- author: Bartlomiej Grabelus (10044563)
function mainHUD:OnEnteringEvent_TestInstance(event)
	if (event == "PLAYER_ENTERING_WORLD" ) then -- when player enter world or instance
		local isInstance, instanceType = IsInInstance() -- get information about instance
		if isInstance then -- when player is in a instance 
			isInstance = isInstance
			if instanceType == "party" or instanceType == "raid" then -- only if raid or party than create bossnameplate and spellicons
				instanceType = instanceType
				bossPlate:CreateBossPlate(hudFrame, "target")
				bossSpellIcon:CreatebossSpellIcon(hudFrame, "target")
			end
		end
	elseif "PLAYER_TARGET_CHANGED" or "PLAYER_REGEN_DISABLED" then -- if player is change the target or is attacked
		local name = UnitName("target") -- get name of target and of the bosses in instance
		local boss1 = UnitName("boss1")
		local boss2 = UnitName("boss2")
		local boss3 = UnitName("boss3")
		local boss4 = UnitName("boss4")
		local boss5 = UnitName("boss5")
		
		if name == boss1 or name == boss2 or name == boss3 or name == boss4 or name == boss5 then -- when target is a boss than show nameplate and spellicons
			bossPlate:Show(true)
			bossSpellIcon:Show(true)
		end
	end
end

-- mainHUD:IsInInstance(): returns isInstance
--
-- author: Bartlomiej Grabelus (10044563)
function mainHUD:IsInInstance()
	return isInstance
end

-- mainHUD:InstanceType(): returns instanceType
--
-- author: Bartlomiej Grabelus (10044563)
function mainHUD:InstanceType()
	return instanceType
end

-- CreateBossPlate(): calls the function of bossPlate to create it
-- later only needed one time and than use Show function of bossPlate
--
-- author: Bartlomiej Grabelus (10044563)
function CreateBossPlate(frame)
	bossPlate:CreateBossPlate(frame)
end

-- CreateBossSpellIcon(): calls the function of bossSpellIco to create the spellIcon
-- later overgive boss1 to boss5 to check inside bossSpellIcon, if is tareted
--
-- author: Bartlomiej Grabelus (10044563)
function CreateBossSpellIcon(frame)
	bossSpellIcon:CreatebossSpellIcon(frame)
end