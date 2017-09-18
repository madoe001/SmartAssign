--Author: Bartlomiej Grabelus

-- #### NEXT statusbar zeigt sich nicht und nur ein debufficon wird angezeigt

local _G = _G

local bossPlate = _G.HUD.BossPlate

local HL = _G.HUD.Locales

local unit 
local name
local health
local mana
-- UnitName("target").." "..UnitGUID("target") kriegt man id und name raus

local SA_BossNamePlate -- parent for statusbars, name and debuffs
local debuffs = {}

-- bossPlate:CreateBossPlate(): creates the bossplate
-- At the beginning create SA_BossNamePlate and then the components
--
-- frame: parent frame
function bossPlate:CreateBossPlate(frame)
	SA_BossNamePlate = CreateFrame("Frame", "BossNameplate", frame)
	SA_BossNamePlate:SetWidth(160)
	SA_BossNamePlate:SetHeight(100)
	SA_BossNamePlate:ClearAllPoints()
	SA_BossNamePlate:SetPoint("CENTER", frame:GetWidth()*0.15, frame:GetHeight()*0.05)
	bossPlate:RegisterAllEvents()
	SA_BossNamePlate:SetScript("OnEvent",bossPlate.OnEvent)
	SA_BossNamePlate:SetScript("OnUpdate", function(elapsed) 
								bossPlate:GetBossDebuffs() -- get debuffs
								bossPlate:ConfigBossDebuffIcons() -- config debuffsend
								end)
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
		bossPlate:DeleteAllBossDebuff() -- hide all debufficons
		bossPlate:GetBossDebuffs() -- get debuffs
		bossPlate:ConfigBossDebuffIcons() -- config debuffs
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
	elseif event == "UNIT_AURA" then
		bossPlate:GetBossDebuffs() -- get debuffs
		bossPlate:ConfigBossDebuffIcons() -- config debuffs
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
	
	healthBar = CreateFrame("StatusBar", "healthBar", SA_BossNamePlate) -- healtBar
	healthBar.label = healthBar:CreateFontString("HealthBar-label", "ARTWORK", "GameFontNormalSmall") -- label how much health of max health the boss have
	
	manaBar = CreateFrame("StatusBar", "manaBar", SA_BossNamePlate) -- manaBar
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
	healthBar.bg = healthBar:CreateTexture("healthBarBorderTexture", "BORDER")
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
	manaBar.bg = manaBar:CreateTexture("manaBarBorderTexture", "BORDER")
	manaBar.bg:SetTexture(0,0,0)
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

-- bossPlate:GetSpellCooldown(): function to get the spell cooldown
-- 
-- spell: the spell
-- totalDuration: if want total duration, then true.
--				  if want current duration, then false
function bossPlate:GetSpellCooldown(spell, totalDuration)
	if not spell then 
		return
	end 
	local start, duration, enabled = GetSpellCooldown(spell)
    if not start then 
		return start 
    end 
    if totalDuration then 
		return duration 
	end 
	if start == 0 then 
		return start 
	end
    return (start + duration - GetTime())
end

function bossPlate:ConfigBossDebuffIcons()
	for i = 1, #debuffs do
		local debuff = debuffs[i]
		debuff:SetSize(24, 24)
		print("ConfigBossDebuffIcons() "..debuff.name)
		bossPlate:ConfigDebuffIconTexture(debuff, i)
		if debuff.count ~= 0 then
			bossPlate:ConfigCountLabel(debuff)
		end
		if debuff.expTime then
			 bossPlate:CreateDebuffExpireStatusBar(debuff)
			 --bossPlate:ConfigExpireLabel(debuff)
		end
	end
end

function bossPlate:ConfigDebuffIconTexture(debuff, placeInTable)
	debuff.icon:SetSize(24, 24)
	debuff.icon:ClearAllPoints()
	debuff.icon:SetAlpha(0.3)
	
	if placeInTable == 1 then
		if UnitMana("target") ~= 0 then
			print("ConfigDebuffIconTexture: manaBar")
			debuff.icon:SetPoint("TOPLEFT", manaBar, "BOTTOMLEFT", 0, 0)
		else
			print("ConfigDebuffIconTexture: healthBar")
			debuff.icon:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, 0)
		end
	elseif placeInTable % 6 == 0 then -- only six debufficons i a row
		print("ConfigDebuffIconTexture: next ROW")
		debuff.icon:SetPoint("BOTTOM", debuffs[placeInTable-5], 0, -1)
	else
		print("ConfigDebuffIconTexture: next Debuff")
		debuff.icon:SetPoint("RIGHT", debuffs[placeInTable-1], 1, 0)
	end
	debuff.icon:SetTexture(debuff.tex)
	debuff.icon:SetDesaturated(1) -- make greyscale
	
end

function bossPlate:ConfigCountLabel(debuff)
	debuff.countLabel:ClearAllPoints()
	debuff.countLabel:SetPoint("BOTTOMRIGHT", debuff, -1, 1)
	debuff.countLabel:SetTextHeight(6)
	debuff.countLabel:SetText(debuff.count)
end

-- if want seconds in icon
function bossPlate:ConfigExpireLabel(debuff)
	debuff.expireLabel:ClearAllPoints()
	debuff.expireLabel:SetPoint("CENTER", debuff, 0, 0)
	debuff.expireLabel:SetTextHeight(22)
	debuff.expireLabel:SetText(round(debuff.expTime - GetTime(), 0))
	debuff.isExpireLabel = true
end

function bossPlate:GetBossDebuffs()
	for i=1,40 do
		local name, _, icon, count, _, _, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff("target",i)
		if name then
			bossPlate:AddBossDebuff(name, icon, count, expirationTime)
		end
	end
end

function bossPlate:AddBossDebuff(name, texture, count, expirationTime)
	if not bossPlate:BossDebuffContains(name) then
		local debuffIconFrame = CreateFrame("Frame", "debuffIconFrame", SA_BossNamePlate)
		debuffIconFrame.name = name
		debuffIconFrame.tex = texture
		debuffIconFrame.count = count
		debuffIconFrame.expTime = expirationTime - GetTime()
		debuffIconFrame:SetAttribute("expTime", round(expirationTime - GetTime(), 0)) -- set a attributes for controlling later
		debuffIconFrame:SetAttribute("count", count)
		debuffIconFrame:SetScript("OnAttributeChanged", bossPlate.DebuffOnAttributeChanged)
		debuffIconFrame:SetScript("OnUpdate", bossPlate.UpdateBossDebuffs)
		debuffIconFrame:SetScript("OnHide", bossPlate.OnIconHide)
		
		bossPlate:CreateDebuffIconComp(debuffIconFrame, count)
		tinsert(debuffs, debuffIconFrame)
	end
end

function bossPlate:UpdateBossDebuffs()
	for i=1,40 do
		local name, _, _, count, _, _, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff("target",i)
		if name then
			bossPlate:UpdateDebuff(name, count, expirationTime)
		end
	end
end

function bossPlate:UpdateDebuff(name, count, expirationTime)
	local debuff = bossPlate:GetBossDebuff(name)
	debuff.count = count
	debuff.expTime = expirationTime - GetTime()
	debuff:SetAttribute("expTime", round(expirationTime - GetTime(), 0)) -- set a attributes for controlling later
	debuff:SetAttribute("count", count)
end

function bossPlate:CreateDebuffIconComp(debuffIconFrame, count)
	if count ~= 0 then
		debuffIconFrame.countLabel = debuffIconFrame:CreateFontString("debuffIconFrameCount-label", "ARTWORK", "GameFontNormalSmall")
	end
	debuffIconFrame.expireLabel = debuffIconFrame:CreateFontString("debuffIconFrameExpire-label", "ARTWORK", "GameFontNormalSmall")
	debuffIconFrame.icon = debuffIconFrame:CreateTexture("DebuffIcon","BACKGROUND")
	debuffIconFrame.statusBar = CreateFrame("StatusBar", "CDStatusBar", debuffIconFrame)
end

function bossPlate:CreateDebuffExpireStatusBar(debuff)
	debuff.statusBar:SetOrientation("VERTICAL")
	debuff.statusBar:ClearAllPoints()
	debuff.statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	debuff.statusBar:SetSize(280, 28)
	debuff.statusBar:SetStatusBarColor(0, 1, 0, 1)
	debuff.statusBar:SetPoint("TOP", SA_BossNamePlate, "TOP", 0, 0)
	debuff.statusBar:SetValue(round(debuff.expTime - GetTime(), 0))
	debuff.statusBar:SetMinMaxValues(0, round(debuff.expTime - GetTime(), 0))
	debuff.statusBar:Show()
end

function bossPlate:DebuffOnAttributeChanged(name, value)
	if name == "exptime" then
		if self.statusBar then
			if value == 0 then
				self.statusBar:Hide()
				self.icon:Hide()
			elseif value > 0 then
				self.statusBar:SetValue(round(value - GetTime(), 0))
			end
		elseif self.isExpireLabel then
			if value == 0 then
				self.expireLabel:Hide()
				self.icon:Hide()
			elseif value > 0 then
				self.expireLabel:SetText(round(value - GetTime(), 0))
			end
		end 
	end
	if name == "count" then
		if value == 0 then
			if self.countLabel then
				self.countLabel:Hide()
			end
		elseif value > 0 then
			self.countLabel:SetText(self.count)
		end
	end
end

function bossPlate:OnIconHide(self)
	tremove(debuffs, self)
	for i = 1, #debuffs do
		bossPlate:ReorderDebuffIcon(debuffs[i], i)
	end
end

function bossPlate:ReorderDebuffIcon(debuff, placeInTable)
	if placeInTable == 1 then
		if UnitMana("target") ~= 0 then
			debuff.icon:SetPoint("LEFT", manaBar, 0, 0)
		else
			debuff.icon:SetPoint("LEFT", healthBar, 0, 0)
		end
	elseif placeInTable % 6 == 0 then -- only six debufficons i a row
		debuff.icon:SetPoint("BOTTOM", debuffs[placeInTable - 5], 0, -1)
	else
		debuff.icon:SetPoint("RIGHT", debuffs[placeInTable - 1], 1, 0)
	end
end

function bossPlate:HideAllDebuffs()
	for i = 1, #debuffs do
		debuffs[i]:Hide()
	end
end

function bossPlate:GetBossDebuff(spell)
	local debuff = nil
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			debuff = debuffs[i]
		end
	end
	return debuff
end

function bossPlate:BossDebuffContains(spell)
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			return true
		end
	end
	return false
end

function bossPlate:DeleteAllBossDebuff()
	for i = 1, #debuffs do
		debuffs[i]:Hide()
		tremove(debuffs, debuffs[i])
	end
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