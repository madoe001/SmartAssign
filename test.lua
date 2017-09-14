
local startTime = 0
local endTime = 0
local totalTime = 0
local frame = CreateFrame("Frame")


function SmartAssign_OnEvent(frame, event, ...)
   print("OnEvent registered")
   if event == "PLAYER_REGEN_ENABLED" then
print("test regen enabled")
	endTime = GetTime()
	totalTime = endTime - startTime
	 if totalTime ~= 0 then
         print("Totaltime: " .. totalTime)
      end   
   elseif event == "PLAYER_REGEN_DISABLED" then
      startTime = GetTime()
   end 
end

frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")

frame:SetScript("OnEvent", SmartAssign_OnEvent)

bar = bar or {"Classic", "Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mist of Pandaria",
		"Warlords of Draenor", "Legion"};
		
function addExpansionToList(expansionName)
	bar[expansionName] = {ExpansionName = expansionName};
end
function removeExpansionFromList(expansionName)
	bar[expansionName] = nil;
end

function addRaidToList(expansionName, raidName)
	bar[expansionName][raidName] = {RaidName = raidName};
end
function removeRaidFromList(expansionName, raidName)
	bar[expansionName][raidName] = nil;
end

function addBossToList(expansionName, raidName, bossName)
	bar[expansionName][raidName][bossName] = {BossName = bossName};
end
function removeBossFromList(expansionName, raidName, BossName)
	bar[expansionName][raidName][bossName] = nil;
end

function addAbillityToList(expansionName, raidName, bossName, abillityName, spellID)
	bar[expansionName][raidName][bossName][abillityName] = {AbillityName = abillityName,
															SpellID = spellID};
end
function removeBossFromList(expansionName, raidName, BossName)
	bar[expansionName][raidName][bossName][abillityName] = nil;
end