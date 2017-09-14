--Author: Bartlomiej Grabelus

local _G = _G

-- localization
local HL = _G.HUD.Locales

local bossSpellIcon = _G.HUD.BossSpellIcon
local TimeSinceLastUpdate = 0.0 -- needed for OnUpdate Event
local name
local unit
local channeling = false -- needed to check if unit channels a spell

-- bossSpellIcon:CreatebossSpellIcon(): function to create the bossSpellIcon
function bossSpellIcon:CreatebossSpellIcon(frame)
	iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame.label = iconFrame:CreateFontString("SpellIcon-label", "ARTWORK", "GameFontNormalSmall")
	iconFrame.icon = iconFrame:CreateTexture(nil,"BACKGROUND")
	iconFrame.updateIntervall = 1.0 -- needed for OnUpdate Event, how much call the inner construct of OnUpdate function
	
	iconFrame:SetScript("OnEvent", bossSpellIcon.OnEvent)
	
	RegisterAllEvents()
end

-- ############ NEXT reagiert noch auf Player cast(aber nicht mehr so sensibel)
-- bossSpellIcon:OnEvent(): OnEvent function for the bossSpellIcon
--
-- Events:
-- UNIT_SPELLCAST_START: when a unit starts to cast a spell
-- UNIT_SPELLCAST_CHANNEL_START: when a unit starts to channel a spell
-- UNIT_SPELLCAST_STOP: when a unit stops to cast a spell
-- UNIT_SPELLCAST_CHANNEL_STOP: when a unit stops to channel a spell
-- UNIT_SPELLCAST_SUCCEEDED: caused a failure, cause of that not in use
-- 
--
-- event: event, which call´s the function
function bossSpellIcon:OnEvent(event, ...)
	unit = UnitGUID("target")
	name = UnitName("target")
	local canAttack = UnitCanAttack("target", "player") -- if the target can attack the player, than true
	if event == "UNIT_SPELLCAST_START" then
		if bossSpellIcon:PreCheck(canAttack) then
			bossSpellIcon:BossCastingInfo("target")
			bossSpellIcon:CreateSpellIcon()
			iconFrame:Show()
			iconFrame:SetScript("OnUpdate", bossSpellIcon.IconTextUpdate)
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_START" then
		if bossSpellIcon:PreCheck(canAttack) then
			bossSpellIcon:BossChannelingInfo("target")
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
	iconFrame:RegisterEvent("UNIT_SPELLCAST_START", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_STOP", "target")
	--iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "target")
end

-- bossSpellIcon:PreCheck(): checks if unit exists, is dead or ghost and if is player
-- later a new value is added (boss1 - boss5)
--
-- canAttack: if the unit can attack the player(boolean)
function bossSpellIcon:PreCheck(canAttack)
	local check = false
	if  UnitExists("target") then
		if not UnitIsDeadOrGhost("target") then
			if not UnitIsPlayer("target") then
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
	local name, _, text, texture, startTime, endTime, _, castID, notInterruptible, spellID = UnitCastingInfo(unit)
	local castingTime = select(4, GetSpellInfo(spellID))
	iconFrame.spell = name
	iconFrame.spellID = spellID
	iconFrame.tex = texture
	if castingTime then
		iconFrame.SpellStartsIn = round(castingTime/1e3, 2)
	end
	channeling = false -- is not channeling
end

-- bossSpellIcon:BossChannelingInfo(): get all needed information about the spell which is channeling by a unit
--
-- unit: the unit which channels a spell
function bossSpellIcon:BossChannelingInfo(unit)
	local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
	iconFrame.spell = name
	iconFrame.tex = texture
	channeling = true -- is channeling
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
		iconFrame.label:SetText(iconFrame.spell..HL[" is channeling now!"])
	elseif iconFrame.SpellStartsIn then
		iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
	else
		iconFrame.label:SetText("|cFFFF0000"..HL["Starts to cast "]..iconFrame.spell.."|r")
	end
	TimeSinceLastUpdate = 0.0
end

-- bossSpellIcon:IconTextUpdate(): function for OnUpdate Event
function bossSpellIcon:IconTextUpdate(elapsed)
	if elapsed == nil then -- check if elapsed have a value
		elapsed = 0.0
	end
	if iconFrame.SpellStartsIn then -- check if have a value
		TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
		while TimeSinceLastUpdate > iconFrame.updateIntervall do
			iconFrame.SpellStartsIn = iconFrame.SpellStartsIn - iconFrame.updateIntervall
			if iconFrame.SpellStartsIn <= 0.0 then -- if spell casted
				TimeSinceLastUpdate = 0.0
			else
				iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
			end
			TimeSinceLastUpdate = TimeSinceLastUpdate - iconFrame.updateIntervall
		end
	end
end
