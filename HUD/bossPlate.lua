--Author: Bartlomiej Grabelus

local _G = _G

local bossPlate = _G.HUD.BossPlate

local HL = _G.HUD.Locales

local unit 
local name
local health
local mana
-- UnitName("target").." "..UnitGUID("target") kriegt man id und name raus

local SA_BossNamePlate -- parent for statusbars, name and debuffs

-- bossPlate:CreateBossPlate(): creates the bossplate
-- At the beginning create SA_BossNamePlate and then the components
--
-- frame: parent frame
function bossPlate:CreateBossPlate(frame)
	SA_BossNamePlate = CreateFrame("Frame", "Nameplate", frame)
	SA_BossNamePlate:SetWidth(160)
	SA_BossNamePlate:SetHeight(100)
	SA_BossNamePlate:ClearAllPoints()
	SA_BossNamePlate:SetPoint("CENTER", frame:GetWidth()*0.15, frame:GetHeight()*0.05)
	bossPlate:RegisterAllEvents()
	SA_BossNamePlate:SetScript("OnEvent",bossPlate.OnEvent)
	SA_BossNamePlate:Show()
	
	bossPlate:CreateNamePlateComp(frame)
end

-- bossPlate:OnEvent(): Is needed for all events, like PLAYER_TARGET_CHANGED
--
-- Events:
-- PLAYER_TARGET_CHANGED: when the player change the target
-- PLAYER_REGEN_DISABLED: when the regenaration of the player is disabled
-- UNIT_HEALTH: when the health of a unit changes
-- UNIT_MANA: when the mana of a unit changes
--
-- event: the event, which was called this function
function bossPlate:OnEvent(event, ...)
	if event ==  "PLAYER_TARGET_CHANGED" then
		unit = UnitGUID("target") -- wird später über unit aus show ersetzt (boss1 bis boss5)
		name = UnitName("target")
		local canAttack = UnitCanAttack("target", "player") -- if the target can attack the player, than true
		if  UnitExists("target") then -- checks if target exists
			if not UnitIsDeadOrGhost("target") then -- check if target is not dead or ghost
				if not UnitIsPlayer("target") then -- check if target is not a player
					if canAttack then -- only when can attack
						manaBar:Hide() -- first hide if have mana show
						bossPlate:CreateBossName()
						bossPlate:ShowHealth()
						bossPlate:ShowMana()
						healthBar:Show()
						SA_BossNamePlate:Show() -- show all
					else
						SA_BossNamePlate:Hide() -- hide all
					end
				else
					SA_BossNamePlate:Hide() -- hide all
				end
			end
		else
			SA_BossNamePlate:Hide() -- hide all
			manaBar:Hide() -- hide manabar
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		manaBar:Hide() -- first hide if have mana show
		bossPlate:ShowHealth()
		bossPlate:ShowMana()
	elseif event == "UNIT_HEALTH" then -- get new mana and health and set new values to the statusbars
		health = UnitHealth("target")
		mana = UnitMana("target")
		bossPlate:SetNewValues(health, mana)
	elseif event == "UNIT_MANA" then -- get new mana and health and set new values to the statusbars
		mana = UnitMana("target")
		health = UnitHealth("target")
		bossPlate:SetNewValues(health, mana)
	end
end

-- bossPlate:RegisterAllEvents(): function to register all events at one time
function bossPlate:RegisterAllEvents()
	SA_BossNamePlate:RegisterEvent("PLAYER_TARGET_CHANGED")
	SA_BossNamePlate:RegisterEvent("PLAYER_REGEN_DISABLED")
	SA_BossNamePlate:RegisterEvent("UNIT_HEALTH")
	SA_BossNamePlate:RegisterEvent("UNIT_MANA")
	SA_BossNamePlate:RegisterEvent("UNIT_AURA")
end

-- bossPlate:CreateNamePlateComp(): function to create the components of the bossnameplate
--
-- frame: parent frame
function bossPlate:CreateNamePlateComp(frame)
	SA_BossNamePlate.name = SA_BossNamePlate:CreateFontString("name-label", "ARTWORK", "GameFontNormalSmall") -- name of boss
	
	healthBar = CreateFrame("StatusBar", nil, SA_BossNamePlate) -- healtBar
	healthBar.label = healthBar:CreateFontString("HealthBar-label", "ARTWORK", "GameFontNormalSmall") -- label how much health of max health the boss have
	
	manaBar = CreateFrame("StatusBar", nil, SA_BossNamePlate) -- manaBar
	manaBar.label = manaBar:CreateFontString("ManaBar-label", "ARTWORK", "GameFontNormalSmall") -- label how much mana of max mana the boss have
end

-- bossPlate:CreateBossName(): function to finally create the bossName label
function bossPlate:CreateBossName()
	SA_BossNamePlate.name:SetHeight(SA_BossNamePlate:GetHeight() * 0.5)
	SA_BossNamePlate.name:SetText(name)
	SA_BossNamePlate.name:ClearAllPoints()
	SA_BossNamePlate.name:SetPoint("TOP", SA_BossNamePlate, 0,0)
end

-- bossPlate:SetNewValues(): function to set new values to the labels of the
-- statusBars(healthBar, manaBar)
--
-- health: the new health of the boss
-- mana: the new mana of the boss
function bossPlate:SetNewValues(health, mana)
	healthBar:SetValue(health)
	healthBar.label:SetText(UnitHealth("target").."/"..UnitHealthMax("target"))
	manaBar:SetValue(mana)
	manaBar.label:SetText(UnitMana("target").."/"..UnitManaMax("target"))
end

-- bossPlate:ShowHealth(): function to create finally all components for the healthBar and show it
function bossPlate:ShowHealth()
	bossPlate:ConfigHealthBar()
	bossPlate:HealthBackground()
	bossPlate:HealthLabel()
					
	healthBar:SetMinMaxValues(0, UnitHealthMax("target")) -- UnitHealthMax(<unit>) returns the max health of the unit
	healthBar:SetValue( UnitHealth("target")) -- UnitHealth(<unit>) returns current health of unit
end

-- bossPlate:ConfigHealthBar(): configuration of the healthBar, like width, texture or color
function bossPlate:ConfigHealthBar()
	healthBar:ClearAllPoints()
	healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	healthBar:SetWidth(150)
	healthBar:SetHeight(20)
	healthBar:SetStatusBarColor(1,0,0)
	healthBar:SetPoint("RIGHT", SA_BossNamePlate, -12, 0)
end

-- bossPlate:HealthBackground(): creates a background for the healthBar
function bossPlate:HealthBackground()
	healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
	healthBar.bg:SetTexture(0,0,0)
	healthBar.bg:ClearAllPoints()
	healthBar.bg:SetPoint("CENTER", healthBar, 0, -10)
	healthBar.bg:SetWidth(healthBar:GetWidth() + 1.5)
	healthBar.bg:SetHeight(healthBar:GetHeight() + 1.5)
end

-- bossPlate:HealthLabel(): creates a label for the healthBar
function bossPlate:HealthLabel()
	healthBar.label:SetHeight(healthBar:GetHeight() - 1)
	healthBar.label:SetText(UnitHealth("target").."/"..UnitHealthMax("target"))
	healthBar.label:ClearAllPoints()
	healthBar.label:SetPoint("LEFT", healthBar, "LEFT", 0,0)
end

-- bossPlate:ShowMana(): checks at first if the unit have mana and
-- than configurate finally the manaBar and show it
function bossPlate:ShowMana()
	if UnitMana("target") ~= 0 then
		bossPlate:ConfigManaBar()
		bossPlate:ManaBackground()
		bossPlate:ManaLabel()
						
		manaBar:SetMinMaxValues(0, UnitManaMax("target")) -- UnitManaMax(<unit>) returns the max mana of the unit
		manaBar:SetValue( UnitMana("target")) -- UnitMana(<unit>) returns current mana of unit
		manaBar:Show()
	end
end

-- bossPlate:ConfigManaBar(): configurate the manaBar, for example texture and color
function bossPlate:ConfigManaBar()
	manaBar:ClearAllPoints()
	manaBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	manaBar:SetWidth(150)
	manaBar:SetHeight(20)
	manaBar:SetStatusBarColor(0,0,1)
	manaBar:SetPoint("TOP", healthBar, "BOTTOM", 0, 0)
end

-- bossPlate:ManaBackground(): create a background for the manaBar
function bossPlate:ManaBackground()
	manaBar.bg = manaBar:CreateTexture(nil, "BORDER")
	manaBar.bg:SetTexture(0,0,0)
	manaBar.bg:ClearAllPoints()
	manaBar.bg:ClearAllPoints()
	manaBar.bg:SetPoint("CENTER", manaBar, 0, -10)
	manaBar.bg:SetWidth(manaBar:GetWidth() + 1.5)
	manaBar.bg:SetHeight(manaBar:GetHeight() + 1.5)
end

-- bossPlate:ManaLabel(): creates a label for the manaBar
function bossPlate:ManaLabel()
	manaBar.label:SetHeight(manaBar:GetHeight() - 1)
	manaBar.label:SetText(UnitMana("target").."/"..UnitManaMax("target"))
	manaBar.label:ClearAllPoints()
	manaBar.label:SetPoint("LEFT", manaBar, "LEFT", 0,0)
end

-- later needed
-- bossPlate:Show(): shows the bossplate
--
-- isGUID: if have a GUID of boss
-- unit: the boss (boss1 bis boss5)
-- spellID: debuff of the boss
-- duration: duration of the debuff
function bossPlate:Show(isGUID, unit, spellID, duration) -- isGUID --> UnitExists
	if isGUID then
	end
end

-- round(): lua function for round a number
--
-- num: the number want to round
-- numDecimalPlaces: how much decimal places
function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end