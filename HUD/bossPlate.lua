--Author: Bartlomiej Grabelus

local _G = _G

local bossPlate = _G.HUD.BossPlate

local SAL = _G.GUI.Locales

local unit
local name
local health
local mana
-- UnitName("target").." "..UnitGUID("target") kriegt man id und name raus

local SA_BossNamePlate

function bossPlate:CreateBossPlate(frame)
	SA_BossNamePlate = CreateFrame("Frame", "Nameplate", frame)
	SA_BossNamePlate:SetWidth(160)
	SA_BossNamePlate:SetHeight(80)
	SA_BossNamePlate:ClearAllPoints()
	SA_BossNamePlate:SetPoint("CENTER", frame:GetWidth()*0.15, frame:GetHeight()*0.05)
	bossPlate:RegisterAllEvents()
	SA_BossNamePlate:SetScript("OnEvent",bossPlate.OnEvent)
	SA_BossNamePlate:Show()
	
	bossPlate:CreateNamePlateComp(frame)
end

-- NEXT spellanzeigen plus tex
-- alle holen boss1 bis boss5 und dann checken ob gleich name und dann statusbars erstellen

function bossPlate:OnEvent(event, ...)
	if event ==  "PLAYER_TARGET_CHANGED" then 
		unit = UnitGUID("target")
		name = UnitName("target")
		local canAttack = UnitCanAttack("target", "player")
		if  UnitExists("target") then
			if not UnitIsDeadOrGhost("target") then
				if not UnitIsPlayer("target") then
					if canAttack then
						manaBar:Hide() -- first hide if have mana show
						bossPlate:CreateBossName()
						bossPlate:ShowHealth()
						bossPlate:ShowMana()
						healthBar:Show()
						SA_BossNamePlate:Show()
					else
						SA_BossNamePlate:Hide()
					end
				else
					SA_BossNamePlate:Hide()
				end
			end
		else
			SA_BossNamePlate:Hide()
			manaBar:Hide()
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		manaBar:Hide() -- first hide if have mana show
		bossPlate:ShowHealth()
		bossPlate:ShowMana()
	elseif event == "UNIT_HEALTH" then
		health = UnitHealth("target")
		mana = UnitMana("target")
		bossPlate:SetNewValues(health, mana)
	elseif event == "UNIT_MANA" then
		mana = UnitMana("target")
		health = UnitHealth("target")
		bossPlate:SetNewValues(health, mana)
	end
end

function bossPlate:RegisterAllEvents()
	SA_BossNamePlate:RegisterEvent("PLAYER_TARGET_CHANGED")
	SA_BossNamePlate:RegisterEvent("PLAYER_REGEN_DISABLED")
	SA_BossNamePlate:RegisterEvent("UNIT_HEALTH")
	SA_BossNamePlate:RegisterEvent("UNIT_MANA")
	SA_BossNamePlate:RegisterEvent("UNIT_AURA")
end

function bossPlate:CreateNamePlateComp(frame)
	SA_BossNamePlate.name = SA_BossNamePlate:CreateFontString("name-label", "ARTWORK", "GameFontNormalSmall")
	
	healthBar = CreateFrame("StatusBar", nil, SA_BossNamePlate)
	healthBar.label = healthBar:CreateFontString("HealthBar-label", "ARTWORK", "GameFontNormalSmall")
	
	manaBar = CreateFrame("StatusBar", nil, SA_BossNamePlate)
	manaBar.label = manaBar:CreateFontString("ManaBar-label", "ARTWORK", "GameFontNormalSmall")
end

function bossPlate:CreateBossName()
	SA_BossNamePlate.name:SetHeight(SA_BossNamePlate:GetHeight() * 0.5)
	SA_BossNamePlate.name:SetText(name)
	SA_BossNamePlate.name:ClearAllPoints()
	SA_BossNamePlate.name:SetPoint("TOP", SA_BossNamePlate, 0,0)
end

function bossPlate:SetNewValues(health, mana)
	healthBar:SetValue(health)
	healthBar.label:SetText(UnitHealth("target").."/"..UnitHealthMax("target"))
	manaBar:SetValue(mana)
	manaBar.label:SetText(UnitMana("target").."/"..UnitManaMax("target"))
end

function bossPlate:ShowHealth()
	bossPlate:ConfigHealthBar()
	bossPlate:HealthBackground()
	bossPlate:HealthLabel()
					
	healthBar:SetMinMaxValues(0, UnitHealthMax("target"))
	healthBar:SetValue( UnitHealth("target"))
end

function bossPlate:ConfigHealthBar()
	healthBar:ClearAllPoints()
	healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	healthBar:SetWidth(150)
	healthBar:SetHeight(16)
	healthBar:SetStatusBarColor(1,0,0)
	healthBar:SetPoint("RIGHT", SA_BossNamePlate, -12, 0)
end

function bossPlate:HealthBackground()
	healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
	healthBar.bg:SetTexture(0,0,0)
	healthBar.bg:ClearAllPoints()
	healthBar.bg:SetPoint("CENTER", healthBar, 0, -10)
	healthBar.bg:SetWidth(healthBar:GetWidth() + 1.5)
	healthBar.bg:SetHeight(healthBar:GetHeight() + 1.5)
end

function bossPlate:HealthLabel()
	healthBar.label:SetHeight(healthBar:GetHeight() - 1)
	healthBar.label:SetText(UnitHealth("target").."/"..UnitHealthMax("target"))
	healthBar.label:ClearAllPoints()
	healthBar.label:SetPoint("LEFT", healthBar, "LEFT", 0,0)
end

function bossPlate:ShowMana()
	if UnitMana("target") ~= 0 then
		bossPlate:ConfigManaBar()
		bossPlate:ManaBackground()
		bossPlate:ManaLabel()
						
		manaBar:SetMinMaxValues(0, UnitManaMax("target"))
		manaBar:SetValue( UnitMana("target"))
		manaBar:Show()
	end
end

function bossPlate:ConfigManaBar()
	manaBar:ClearAllPoints()
	manaBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	manaBar:SetWidth(150)
	manaBar:SetHeight(16)
	manaBar:SetStatusBarColor(0,0,1)
	manaBar:SetPoint("TOP", healthBar, "BOTTOM", 0, 0)
end

function bossPlate:ManaBackground()
	manaBar.bg = manaBar:CreateTexture(nil, "BORDER")
	manaBar.bg:SetTexture(0,0,0)
	manaBar.bg:ClearAllPoints()
	manaBar.bg:ClearAllPoints()
	manaBar.bg:SetPoint("CENTER", manaBar, 0, -10)
	manaBar.bg:SetWidth(manaBar:GetWidth() + 1.5)
	manaBar.bg:SetHeight(manaBar:GetHeight() + 1.5)
end

function bossPlate:ManaLabel()
	manaBar.label:SetHeight(manaBar:GetHeight() - 1)
	manaBar.label:SetText(UnitMana("target").."/"..UnitManaMax("target"))
	manaBar.label:ClearAllPoints()
	manaBar.label:SetPoint("LEFT", manaBar, "LEFT", 0,0)
end

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