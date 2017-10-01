--Author: Bartlomiej Grabelus

local _G = _G

-- localization
local HL = _G.HUD.Locales

local bossSpellIcon = _G.HUD.BossSpellIcon
local TimeSinceLastUpdate = 0.0 -- needed for OnUpdate Event
local name
local channeling = false -- needed to check if unit channels a spell
local iconFrame

-- bossSpellIcon:CreatebossSpellIcon(): function to create the bossSpellIcon
--
-- frame: parent
-- unit: the unit --> e.g target
function bossSpellIcon:CreatebossSpellIcon(frame, unit)
	iconFrame = CreateFrame("Frame", "iconFrame", frame)
	iconFrame.label = iconFrame:CreateFontString("SpellIcon-label", "ARTWORK", "GameFontNormalSmall")
	iconFrame.icon = iconFrame:CreateTexture("iconFrameTexture","BACKGROUND")
	iconFrame.updateIntervall = 1.0 -- needed for OnUpdate Event, how much call the inner construct of OnUpdate function
	
	iconFrame.unit = unit
end

-- bossSpellIcon:OnEvent(): OnEvent function for the bossSpellIcon
--
-- Events:
-- UNIT_SPELLCAST_START: when a unit starts to cast a spell
-- UNIT_SPELLCAST_CHANNEL_START: when a unit starts to channel a spell
-- UNIT_SPELLCAST_STOP: when a unit stops to cast a spell
-- UNIT_SPELLCAST_CHANNEL_STOP: when a unit stops to channel a spell
-- UNIT_SPELLCAST_SUCCEEDED: caused a failure, cause of that not in use
-- 
-- event: event, which call´s the function
function bossSpellIcon:OnEvent(event, ...)
	name = UnitName(iconFrame.unit)
	local canAttack = UnitCanAttack(iconFrame.unit, "player") -- if the target can attack the player, than true
	if event == "UNIT_SPELLCAST_START" then
		if bossSpellIcon:PreCheck(canAttack) then
			bossSpellIcon:BossCastingInfo(iconFrame.unit)
			bossSpellIcon:CreateSpellIcon()
			iconFrame:Show()
			iconFrame:SetScript("OnUpdate", bossSpellIcon.IconTextUpdate)
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_START" then
		if bossSpellIcon:PreCheck(canAttack) then
			bossSpellIcon:BossChannelingInfo(iconFrame.unit)
			bossSpellIcon:CreateSpellIcon()
			iconFrame:Show()
		end
	end
	if event == "UNIT_SPELLCAST_STOP" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
			iconFrame.SpellStartsIn = 0.0
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
		end
	end
	--[[if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
			print("SUCC")
		end
	end]] -- makes problems
end

-- RegisterAllEvents(): registers all events at one time 
function RegisterAllEvents()
	iconFrame:RegisterEvent("UNIT_SPELLCAST_START", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_STOP", iconFrame.unit)
	--iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
end

-- UnRegisterAllEvents(): unregisters all events at one time 
function UnRegisterAllEvents()
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_START", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_STOP", iconFrame.unit)
	--iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
end

-- bossSpellIcon:PreCheck(): checks if unit exists, is dead or ghost and if is player
-- later a new value is added (boss1 - boss5)
--
-- canAttack: if the unit can attack the player(boolean)
function bossSpellIcon:PreCheck(canAttack)
	local check = false
	if  UnitExists(iconFrame.icon) then
		if not UnitIsDeadOrGhost(iconFrame.unit) then
			if not UnitIsPlayer(iconFrame.unit) then
				if canAttack then
					check = true
				end
			end
		end
	end
	return check
end

-- bossSpellIcon:BossCastingInfo(): get all needed informationabout the spell which a unit casts
--
-- unit: the unit which is casting a spell
function bossSpellIcon:BossCastingInfo(unit)
	local name, _, _, texture, _, _, _, _, notInterruptible, spellID = UnitCastingInfo(unit)
	iconFrame.spell = name
	iconFrame.spellID = spellID
	iconFrame.tex = texture
	iconFrame.SpellStartsIn = bossSpellIcon:BossCastingTime(iconFrame.spell, unit, true)

	channeling = false -- is not channeling
end

-- bossSpellIcon:UnitIsCasting(): used to get spellname, spellStart and spellEnd, which is needed in bossSpellIcon:BossCastingTime
--
-- spell: the spellname
-- unit: e.g "boss1"
-- 
-- returns the spellname, the start time of the spell end the end time
function bossSpellIcon:BossIsCasting(spell, unit)
	unit = unit or not 'player'
	if not UnitExists(unit) then 
		return 
	end
	local spellName, _, _, _, spellStart, spellEnd, _, spellId = UnitCastingInfo(unit)
	if not spellName then 
		return 
	end
	if spell then
		if type(spell) == "string" then
			if spellName == spell then 
				return spellName, spellStart, spellEnd
			end
		elseif type(tonumber(spell)) == "number" then
			if tonumber(spell) == spellId then 
				return spellName, spellStart, spellEnd
			end
		end    
	else
		return spellName, spellStart, spellEnd
	end
end

-- bossSpellIcon:UnitCastingTime(): function to get the boss casting time
--
-- spell: the spellname
-- unit: e.g "boss1"
-- remaining: if want remaining casting time --> true else false
function bossSpellIcon:BossCastingTime(spell, unit, remaining)
	local _, startTime, endTime = bossSpellIcon:BossIsCasting(spell, unit)
	if startTime and endTime then
		if remaining then
			return round(((endTime - (GetTime() * 1e3)) / 1e3), 2)
		else
			return round((((GetTime() * 1e3) - startTime) / 1e3), 2)
		end
	end
end

-- bossSpellIcon:BossChannelingInfo(): get all needed information about the spell which is channeling by a unit
--
-- unit: the unit which channels a spell
function bossSpellIcon:BossChannelingInfo(unit)
	local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
	iconFrame.spell = name
	iconFrame.tex = texture
	iconFrame.channelingTime = bossSpellIcon:BossChannelingTime(iconFrame.spell, unit, true)
	channeling = true -- is channeling
end

-- bossSpellIcon:BossIsChanneling(): used to get spellname, spellStart and spellEnd, which is needed in bossSpellIcon:
--
-- spell: the spellname
-- unit: e.g "boss1"
-- 
-- returns the spellname, the start time of the spell end the end time
function bossSpellIcon:BossIsChanneling(spell, unit)
	unit = unit or 'player'
	if not UnitExists(unit) then
		return 
	end
	local spellName, _, _, _, spellStart, spellEnd = UnitChannelInfo(unit)
	if not spellName then 
		return 
	end
	if spell then
		if type(spell) == 'string' then
			if spellName == spell then 
				return spellName, spellStart, spellEnd 
			end
		end    
	else
		return spellName, spellStart, spellEnd
	end
end

-- bossSpellIcon:BossChannelingTime(): function to get the boss channeling time
--
-- spell: the spellname
-- unit: e.g "boss1"
-- remaining: if want remaining channeling time --> true else false
function bossSpellIcon:BossChannelingTime(spell, unit, remaining)
local _, startTime, endTime = bossSpellIcon:BossIsChanneling(spell, unit)
	if startTime and endTime then
		if remaining then
			return ((endTime - (GetTime() * 1e3)) / 1e3)
		else
			return (((GetTime() * 1e3) - startTime) / 1e3)
		end
	end
end

-- bossSpellIcon:CreateSpellIcon(): createt all needed components for the spell icon
function bossSpellIcon:CreateSpellIcon()
	iconFrame:SetSize(80, 80)
	
	iconFrame.icon:SetSize(50, 50)
	iconFrame.icon:ClearAllPoints()
	iconFrame.icon:SetPoint("CENTER", iconFrame, 0, 0)
	iconFrame.icon:SetTexture(iconFrame.tex)
	
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint('CENTER', frame, 0, 300)
	
	iconFrame.label:ClearAllPoints()
	iconFrame.label:SetPoint("TOP", iconFrame, "BOTTOM", 0, -10)
	iconFrame.label:SetTextHeight(16)
	if channeling then -- check if spell is channeling
		iconFrame.label:SetText(iconFrame.spell..HL[" is channeling now!"].."\n".."|cFFFF0000"..iconFrame.channelingTime..HL[" sec remaining"].."|r")
	elseif iconFrame.SpellStartsIn then
		iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
	else
		iconFrame.label:SetText("|cFFFF0000"..HL["Starts to cast "]..iconFrame.spell.."|r")
	end
	TimeSinceLastUpdate = 0.0
end

-- bossSpellIcon:IconTextUpdate(): function for OnUpdate Event
--
-- elapsed: time which is elapsed
function bossSpellIcon:IconTextUpdate(elapsed)
	if elapsed == nil then -- check if elapsed have a value
		elapsed = 0.0
	end
	if iconFrame.SpellStartsIn then -- check if have a value
		TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
		while TimeSinceLastUpdate > iconFrame.updateIntervall do
			if iconFrame.SpellStartsIn then
				iconFrame.SpellStartsIn = iconFrame.SpellStartsIn - iconFrame.updateIntervall
				if iconFrame.SpellStartsIn <= 0.0 then -- if spell casted
					TimeSinceLastUpdate = 0.0
				else
					iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
				end
			elseif iconFrame.channelingTime then
				iconFrame.channelingTime = iconFrame.channelingTime - iconFrame.updateIntervall
				if iconFrame.channelingTime <= 0.0 then -- if spell casted
					TimeSinceLastUpdate = 0.0
				else
					iconFrame.label:SetText("|cFFFF0000"..iconFrame.channelingTime..HL[" sec remaining"].."|r")
				end
			end
			TimeSinceLastUpdate = TimeSinceLastUpdate - iconFrame.updateIntervall
		end
	end
end

-- bossSpellIcon:Show(): shows the bossSpellIcon
--
-- isGUID: if is a unitGUID
function bossSpellIcon:Show(isGUID)
	if iconFrame then
		if isGUID then
			iconFrame:SetScript("OnEvent", bossSpellIcon.OnEvent)
			RegisterAllEvents()
		else
			UnRegisterAllEvents()
		end
	end
end
