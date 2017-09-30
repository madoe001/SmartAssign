--Author: Bartlomiej Grabelus

local _G = _G

local bossPlate = _G.HUD.BossPlate

local HL = _G.HUD.Locales
 
local name
local health
local mana

local SA_BossNamePlate -- parent for statusbars, name and debuffs
local debuffs = {}

-- bossPlate:CreateBossPlate(): creates the bossplate
-- At the beginning create SA_BossNamePlate and then the components
--
-- frame: parent frame
function bossPlate:CreateBossPlate(frame, unit)
	SA_BossNamePlate = CreateFrame("Frame", "BossNameplate", frame)
	SA_BossNamePlate:SetWidth(160)
	SA_BossNamePlate:SetHeight(100)
	SA_BossNamePlate:ClearAllPoints()
	SA_BossNamePlate:SetPoint("CENTER", frame:GetWidth()*0.15, frame:GetHeight()*0.15)
	
	bossPlate:CreateNamePlateComp(frame)
	
	bossPlate:RegisterAllEvents()
	SA_BossNamePlate:SetScript("OnEvent",bossPlate.OnEvent)
	SA_BossNamePlate:SetScript("OnUpdate", function(elapsed) 
							bossPlate:GetBossDebuffs() -- get debuffs
							bossPlate:ConfigBossDebuffIcons() -- config debuffsend
							end)
	
	SA_BossNamePlate.unit = unit
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
		bossPlate:ReorderAllDebuffs() -- reorder all debuffs
		bossPlate:ResetAll() -- reset all debuffs
		local canAttack = UnitCanAttack(SA_BossNamePlate.unit, "player") -- if the target can attack the player, than true
		if  UnitExists(SA_BossNamePlate.unit) then -- checks if target exists
			if not UnitIsDeadOrGhost(SA_BossNamePlate.unit) then -- check if target is not dead or ghost
				if not UnitIsPlayer(SA_BossNamePlate.unit) then -- check if target is not a player
					if canAttack then -- only when can attack
						manaBar:Hide() -- first hide if have mana show
						bossPlate:CreateBossName()
						bossPlate:ShowHealth()
						bossPlate:ShowMana()
						healthBar:Show()
						bossPlate:GetBossDebuffs() -- get debuffs
						bossPlate:ConfigBossDebuffIcons() -- config debuffs
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
		bossPlate:GetBossDebuffs() -- get debuffs
		bossPlate:ConfigBossDebuffIcons() -- config debuffs
	elseif event == "UNIT_HEALTH" then -- get new mana and health and set new values to the statusbars
		health = UnitHealth(SA_BossNamePlate.unit)
		mana = UnitMana(SA_BossNamePlate.unit)
		bossPlate:GetBossDebuffs() -- get debuffs
		bossPlate:ConfigBossDebuffIcons() -- config debuffs
		bossPlate:SetNewValues(health, mana)
	elseif event == "UNIT_MANA" then -- get new mana and health and set new values to the statusbars
		mana = UnitMana(SA_BossNamePlate.unit)
		health = UnitHealth(SA_BossNamePlate.unit)
		bossPlate:SetNewValues(health, mana)
		bossPlate:GetBossDebuffs() -- get debuffs
		bossPlate:ConfigBossDebuffIcons() -- config debuffs
	elseif event == "UNIT_AURA" then
		bossPlate:ResetExpiredDebuff() -- reset expired ones
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

-- bossPlate:UnRegisterAllEvents(): function to unregister all events at one time
function bossPlate:UnRegisterAllEvents()
	SA_BossNamePlate:UnregisterEvent("PLAYER_TARGET_CHANGED")
	SA_BossNamePlate:UnregisterEvent("PLAYER_REGEN_DISABLED")
	SA_BossNamePlate:UnregisterEvent("UNIT_HEALTH")
	SA_BossNamePlate:UnregisterEvent("UNIT_MANA")
	SA_BossNamePlate:UnregisterEvent("UNIT_AURA")
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
	healthBar.label:SetText(UnitHealth(SA_BossNamePlate.unit).."/"..UnitHealthMax(SA_BossNamePlate.unit))
	manaBar:SetValue(mana)
	manaBar.label:SetText(UnitMana(SA_BossNamePlate.unit).."/"..UnitManaMax(SA_BossNamePlate.unit))
end

-- bossPlate:ShowHealth(): function to create finally all components for the healthBar and show it
function bossPlate:ShowHealth()
	bossPlate:ConfigHealthBar()
	bossPlate:HealthBackground()
	bossPlate:HealthLabel()
					
	healthBar:SetMinMaxValues(0, UnitHealthMax(SA_BossNamePlate.unit)) -- UnitHealthMax(<SA_BossNamePlate.unit>) returns the max health of the unit
	healthBar:SetValue( UnitHealth(SA_BossNamePlate.unit)) -- UnitHealth(<SA_BossNamePlate.unit>) returns current health of unit
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
	healthBar.label:SetText(UnitHealth(SA_BossNamePlate.unit).."/"..UnitHealthMax(SA_BossNamePlate.unit))
	healthBar.label:ClearAllPoints()
	healthBar.label:SetPoint("LEFT", healthBar, "LEFT", 0,0)
end

-- bossPlate:ShowMana(): checks at first if the unit have mana and
-- than configurate finally the manaBar and show it
function bossPlate:ShowMana()
	if UnitMana(SA_BossNamePlate.unit) ~= 0 then
		bossPlate:ConfigManaBar()
		bossPlate:ManaBackground()
		bossPlate:ManaLabel()
						
		manaBar:SetMinMaxValues(0, UnitManaMax(SA_BossNamePlate.unit)) -- UnitManaMax(<SA_BossNamePlate.unit>) returns the max mana of the unit
		manaBar:SetValue( UnitMana(SA_BossNamePlate.unit)) -- UnitMana(<SA_BossNamePlate.unit>) returns current mana of SA_BossNamePlate.unit
		manaBar:Show()
	end
end

-- bossPlate:ConfigManaBar(): configurate the manaBar, for example texture and color
function bossPlate:ConfigManaBar()
	manaBar:ClearAllPoints()
	manaBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	manaBar:SetWidth(150)
	manaBar:SetHeight(20)
	manaBar:SetStatusBarColor(0,0,1, 0.5)
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
	manaBar.label:SetText(UnitMana(SA_BossNamePlate.unit).."/"..UnitManaMax(SA_BossNamePlate.unit))
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

-- bossPlate:ConfigBossDebuffIcons(): configurate the debuffs
-- by calling other functions
function bossPlate:ConfigBossDebuffIcons()
	for i = 1, #debuffs do
		local debuff = debuffs[i]
		if debuff.expTime then
			 bossPlate:ConfigDebuffExpireStatusBar(debuff)
			 --bossPlate:ConfigExpireLabel(debuff) -- nicht alle code teile implementiert
		end
		bossPlate:ConfigDebuffIconTexture(debuff, i)
		if debuff.count ~= 0 then -- config a count only if a stacked debuff exists
			bossPlate:ConfigCountLabel(debuff)
		end
	end
end

-- bossPlate:ConfigDebuffIconTexture(): configure a debuff icon and position the debuff
--
-- debuff: the debuff, which want to configure
-- placeInTable: at which place the debuff is in the debuff container
function bossPlate:ConfigDebuffIconTexture(debuff, placeInTable)
	debuff.icon:SetSize(25, 25)
	debuff.icon:ClearAllPoints()
	debuff.icon:SetPoint("CENTER", debuff, 0, 0)
	debuff.icon:SetAlpha(1)
	
	if placeInTable == 1 then -- only first debuff
		if UnitMana(SA_BossNamePlate.unit) ~= 0 then
			debuff:SetPoint("TOPLEFT", manaBar, "BOTTOMLEFT", 0, 0)
		else
			debuff:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, 0)
		end
	elseif placeInTable % 6 == 0 then -- only six debufficons i a row
		debuff:SetPoint("TOP", debuffs[placeInTable-5], "BOTTOM", 0, -1)
	elseif placeInTable > 1 and debuffs[1] then -- all next debuffs place to the last debuff
		debuff:SetPoint("LEFT", debuffs[placeInTable-1], "RIGHT", 1, 0)
	end
	debuff.icon:SetTexture(debuff.tex)
	
end

-- bossPlate:ConfigDebuffIconTexture(): configure the count label for a debuff
--
-- debuff: for which want to configure the count label
function bossPlate:ConfigCountLabel(debuff)
	debuff.countLabel:ClearAllPoints()
	debuff.countLabel:SetPoint("BOTTOMRIGHT", debuff, -1, 1)
	debuff.countLabel:SetTextHeight(10)
	debuff.countLabel:SetText(debuff.count)
end

-- bossPlate:ConfigExpireLabel(): an option to configure a label for the debuff,
-- to see the expire time
function bossPlate:ConfigExpireLabel(debuff)
	debuff.expireLabel:ClearAllPoints()
	debuff.expireLabel:SetPoint("CENTER", debuff, 0, 0)
	debuff.expireLabel:SetTextHeight(18)
	debuff.expireLabel:SetText(debuff.expTime)
	debuff.isExpireLabel = false
end

-- bossPlate:GetBossDebuffs(): for retrieve all debuffs of target
function bossPlate:GetBossDebuffs()
	for i=1,40 do
		local name, _, icon, count, _, duration, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff(SA_BossNamePlate.unit,i)
		if name then
			bossPlate:AddBossDebuff(name, icon, count, duration, round(-(GetTime() - expirationTime), 0))
		end
	end
end

-- bossPlate:AddBossDebuff(): create a StatusBar for debufficon and add it to the debuffs container
--
-- name: spellname
-- texture: icon of the debuff
-- count: how many debuffs are stacked
-- duration: how long the debuff durate
-- expirationTime: expirationtime of the debuff
function bossPlate:AddBossDebuff(name, texture, count, duration, expirationTime)
	if not bossPlate:BossDebuffContains(name) then -- if debuff contains
		local debuffIconFrame = CreateFrame("StatusBar", name.."debuffIconFrame", SA_BossNamePlate)
		debuffIconFrame.name = name
		debuffIconFrame.tex = texture
		debuffIconFrame.count = count
		debuffIconFrame.duration = duration
		debuffIconFrame.expTime = expirationTime
		debuffIconFrame:SetAttribute("exptime", expirationTime) -- set a attributes for controlling later
		debuffIconFrame:SetAttribute("count", count)
		debuffIconFrame:SetScript("OnAttributeChanged", bossPlate.DebuffOnAttributeChanged) -- when a attribute changes, then call bossPlate.DebuffOnAttributeChanged
		debuffIconFrame:SetScript("OnUpdate", bossPlate.UpdateBossDebuffs)
		debuffIconFrame:SetScript("OnHide", bossPlate.OnIconHide)
		
		bossPlate:CreateDebuffIconComp(debuffIconFrame, count) -- create components
		tinsert(debuffs, debuffIconFrame) -- insert in container
		debuffIconFrame.place = #debuffs
	else
	end
end

-- bossPlate:UpdateBossDebuffs(): get debuff information of a target
-- needed for updating the debuffs of a boss
function bossPlate:UpdateBossDebuffs()
	for i=1,40 do
		local name, _, _, count, _, _, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff(SA_BossNamePlate.unit,i)
		if name then
			bossPlate:UpdateDebuff(name, count, round(-(GetTime() - expirationTime), 0))
		end
	end
	for i = 1, #debuffs do -- reorder all
		bossPlate:ReorderDebuffIcon(debuffs[i], i)
	end
end

-- bossPlate:UpdateDebuff(): updates a debuff icon
--
-- name: spellname
-- count: how many debuffs are stacked
-- expirationTime: update the expiration time
function bossPlate:UpdateDebuff(name, count, expirationTime)
	if expirationTime > 1 then
		local debuff = bossPlate:GetBossDebuff(name)
		debuff:SetSize(28,28)
		if debuff then
			if count > 0 then -- only if have a stacked debuff
				debuff.count = count
				debuff:SetAttribute("count", count)
			end
			debuff.expTime = expirationTime
			debuff:SetAttribute("exptime", expirationTime) -- set a attributes for controlling later
		end
	else
		local debuff = bossPlate:GetBossDebuff(name)
		if debuff then
			debuff:SetAttribute("exptime", 0)
		end
	end
end

-- bossPlate:CreateDebuffIconComp(): create debuff icon components
--
-- debuffIconFrame: the debuff for which create comps
-- count: number of stacked debuffs
function bossPlate:CreateDebuffIconComp(debuffIconFrame, count)
	if count ~= 0 then
		debuffIconFrame.countLabel = debuffIconFrame:CreateFontString(debuffIconFrame.name.."debuffIconFrameCount-label", "OVERLAY", "GameFontNormal") -- on top OVERLAY
	end
	debuffIconFrame.expireLabel = debuffIconFrame:CreateFontString(debuffIconFrame.name.."debuffIconFrameExpire-label", "OVERLAY", "GameFontNormal")
	debuffIconFrame.icon = debuffIconFrame:CreateTexture(debuffIconFrame.name.."debuffIcon","BACKGROUND") -- icon in background
end

-- bossPlate:ConfigDebuffExpireStatusBar():  configurate the debuff statusbar
--
-- debuff: the debuff(statusbar)
function bossPlate:ConfigDebuffExpireStatusBar(debuff)
	debuff:SetOrientation("VERTICAL")
	debuff:ClearAllPoints()
	debuff:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	debuff:SetSize(28, 28)
	debuff:SetStatusBarColor(0, 0, 0, 0.6)
	debuff:SetValue(debuff:GetAttribute("exptime"))
	debuff:SetMinMaxValues(0, debuff.duration)
	debuff:Show()
end


-- bossPlate:DebuffOnAttributeChanged(): function for OnAttributeChanged event
--
-- name: name of the attribute
-- value: new value of the attribute
function bossPlate:DebuffOnAttributeChanged(name, value)
	if name == "exptime" then
		if value == 0 then
			bossPlate:ResetDebuff(self)
		elseif value > 0 then
			self:SetValue(value)
		end
	elseif self.isExpireLabel then
		if value == 1 then
			self.expireLabel:Hide()
			self:Hide()
			self.icon:SetTexture(nil)
		elseif value > 1 then
			self.expireLabel:SetText(round(value, 0))
		end 
	end
	if name == "count" then
		if value == 1 then
			if self.countLabel then
				self.countLabel:Hide()
			end
		elseif value > 1 then
			self.countLabel:SetText(value)
		end
	end
end

-- bossPlate:OnIconHide(): function for the OnHide event
-- set a nil texture for the debuff icon and remove it from
-- the container. Than reorder the debuffs
function bossPlate:OnIconHide()
	self.icon:SetTexture(nil)
	tremove(debuffs, self.place)
	for i = 1, #debuffs do
		if #debuffs > 0 then
			bossPlate:ReorderDebuffIcon(debuffs[i], i)
		end
	end
end

-- bossPlate:ReorderAllDebuffs(): reorder all debuffs of the container
function bossPlate:ReorderAllDebuffs()
	for i = 1, #debuffs do
		if #debuffs > 0 then
			bossPlate:ReorderDebuffIcon(debuffs[i], i)
		end
	end
end

-- bossPlate:ReorderDebuffIcon(): reorder a debuff
--
-- debuff: the debuff which want to reorder
-- placeInTable: at which place in the container
function bossPlate:ReorderDebuffIcon(debuff, placeInTable)
	if debuff then
		if debuff.icon then
			debuff.icon:SetPoint("CENTER", debuff, 0, 0)
			if placeInTable == 1 then
				if UnitMana(SA_BossNamePlate.unit) ~= 0 then
					debuff:SetPoint("TOPLEFT", manaBar, "BOTTOMLEFT", 0, 0)
				else
					debuff:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, 0)
				end
			elseif placeInTable % 6 == 0 then -- only six debufficons i a row
				debuff:SetPoint("TOP", debuffs[placeInTable - 5], "BOTTOM", 0, -1)
			elseif placeInTable > 1 and debuffs[1] then
				debuff:SetPoint("LEFT", debuffs[placeInTable - 1], "RIGHT", 1, 0)
			end
		else
			debuff.icon:ClearAllPoints()
		end
	else
		debuff:ClearAllPoints()
	end
end

-- bossPlate:GetBossDebuff(): get a debuff of the debuffs container
--
-- spell: the name of a spell, which want to get
function bossPlate:GetBossDebuff(spell)
	local debuff = nil
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			debuff = debuffs[i]
		end
	end
	return debuff
end

-- bossPlate:BossDebuffContains(): for checking if the container contains a debuff
--
-- spell: name of the spell, which want to check
function bossPlate:BossDebuffContains(spell)
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			return true
		end
	end
	return false
end

-- bossPlate:HideAllBossDebuff(): hide all debuffs, by setting the attribute exptime to 0
-- and than hide all debuffs in the function bossPlate:DebuffOnAttributeChanged()
function bossPlate:HideAllBossDebuff()
	for i = 1, #debuffs do
		if(debuffs[i]) then
			debuffs[i]:SetAttribute("exptime", 0)
		end
	end
end

-- bossPlate:ResetAll(): reset all debuffs by calling ResetDebuff
function bossPlate:ResetAll()
	for i = 1, #debuffs do
		if debuffs[i] then
			bossPlate:ResetDebuff(debuffs[i])
		end
	end
	debuffs = table.wipe(debuffs)
end

-- bossPlate:ResetExpiredDebuff(): reset all expired debuffs
function bossPlate:ResetExpiredDebuff()
	for i = 1, #debuffs do
		if debuffs[i] and debuffs[i].expTime == 0 then
			bossPlate:ResetDebuff(debuffs[i])
		end
		bossPlate:ReorderDebuffIcon(debuffs[i], i)
	end
end

-- bossPlate:ResetDebuff(): reset a debuff
--
-- self: the debuff which want to reset
function bossPlate:ResetDebuff(self)
		self.tex = nil
		self.icon = self:CreateTexture(nil)
		self.icon:SetAlpha(0)
		self.icon:SetSize(0,0)
		self.icon:ClearAllPoints()
		self.icon:Hide()
		self:SetSize(0,0)
		self:SetValue(0)
		self:SetAlpha(0)
		self:Hide()
		self:SetScript("OnUpdate", nil)
		self:SetScript("OnHide", nil)
		self:SetScript("OnAttributeChanged",nil)
		self:ClearAllPoints()
		self = nil
end

-- bossPlate:Show(): shows the bossplate
--
-- isGUID: if have a GUID of boss
function bossPlate:Show(isGUID) -- isGUID --> UnitExists
	if isGUID then
		SA_BossNamePlate:Show()
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