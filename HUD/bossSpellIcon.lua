--Author: Bartlomiej Grabelus

local _G = _G

local bossSpellIcon = _G.HUD.BossSpellIcon
local TimeSinceLastUpdate = 0.0
local name
local unit

function bossSpellIcon:CreatebossSpellIcon(frame)
	iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame.label = iconFrame:CreateFontString("SpellIcon-label", "ARTWORK", "GameFontNormalSmall")
	iconFrame.icon = iconFrame:CreateTexture(nil,"BACKGROUND")
	iconFrame.updateIntervall = 1.0
	
	iconFrame:SetScript("OnEvent", bossSpellIcon.OnEvent)
	
	RegisterAllEvents()
end

-- ############ NEXT reagiert noch auf Player cast
function bossSpellIcon:OnEvent(event, ...)
	unit = UnitGUID("target")
	name = UnitName("target")
	local canAttack = UnitCanAttack("target", "player")
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
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
		end
	end
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
		end
	end
end

function RegisterAllEvents()
	iconFrame:RegisterEvent("UNIT_SPELLCAST_START", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_STOP", "target")
	iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "target")
end

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

function bossSpellIcon:BossCastingInfo(unit)
	local name, _, text, texture, startTime, endTime, _, castID, notInterruptible, spellID = UnitCastingInfo(unit)
	local castingTime = select(4, GetSpellInfo(spellID))
	iconFrame.spell = name
	iconFrame.spellID = spellID
	iconFrame.tex = texture
	iconFrame.SpellStartsIn = round(castingTime/1e3, 2)
end

function bossSpellIcon:BossChannelingInfo(unit)
	local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
	iconFrame.spell = name
	iconFrame.tex = texture
end

function bossSpellIcon:CreateSpellIcon()
	iconFrame:SetSize(80, 80)
	
	iconFrame.icon:SetSize(50, 50)
	iconFrame.icon:ClearAllPoints()
	iconFrame.icon:SetPoint("CENTER", iconFrame, 0, 0)
	iconFrame.icon:SetTexture(iconFrame.tex)
	
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint('CENTER', frame, 0, 100)
	
	iconFrame.label:ClearAllPoints()
	iconFrame.label:SetPoint("TOP", iconFrame, "BOTTOM", 0, -10)
	iconFrame.label:SetTextHeight(16)
	if iconFrame.name then
		iconFrame.label:SetText(iconFrame.spell.." is channeling now!")
	else
		iconFrame.label:SetText("Starts in "..iconFrame.SpellStartsIn.." sec")
	end
end

function bossSpellIcon:IconTextUpdate(elapsed)
	if elapsed == nil then
		elapsed = 0.0
	end
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
	while TimeSinceLastUpdate > iconFrame.updateIntervall do
		iconFrame.SpellStartsIn = iconFrame.SpellStartsIn - 1.0
		iconFrame.label:SetText("Starts in "..iconFrame.SpellStartsIn.." sec")
		TimeSinceLastUpdate = TimeSinceLastUpdate - iconFrame.updateIntervall
	end
end
