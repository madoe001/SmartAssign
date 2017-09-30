
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




-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- ????

--table
caric = {}
caric.framusCounter = 42;
caric.assignCounter = 0;

function caric:Init(event, addon)
	if(event == "ADDON_LOADED" and addon == "SmartAssign") then
		--caric:CreateGUI(testFrame)
		--NewAbillityWindow:show()
		BossSelectFrame:show(UIParent)
	end
end

--frame erstellen und events registrieren
testFrame = CreateFrame("Frame","testFrame",UIParent)
testFrame:SetScript("OnEvent",caric.Init)
testFrame:RegisterEvent("ADDON_LOADED")

function caric:CreateGUI(frame)
	--Fenster
	local window = caric:CreateWindow(frame)
	caric:CreateButton(frame, "closeButton", nil, 240,240,30,30, "UIPanelCloseBUtton")
	caric:CreateButton(frame, "menu", "MENU", 0,0,30,30)
	menu:SetScript("OnClick", function() BossSelectFrame:hide()
								BossSelectFrame:show()
								 end) 
	--[[
											 
	-- Player		
	local playerDP1 = createPlayerDropDown (testFrame, -150, -100, 100)
	createCooldownDropDown (testFrame, -20, -100, 100, playerDP1)
	local playerDP2 = createPlayerDropDown (testFrame, -150, -140, 100)					
	-- Cooldown
	createCooldownDropDown (testFrame, -20, -140, 100, playerDP2)
	]]
	--BossSelectFrame:show(window)
	--NewAbillityWindow:show()
end

function caric:CreateWindow(frame)
	frame:SetWidth(500)
	frame:SetHeight(500)
	frame:SetPoint("CENTER",0,0)
	frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	frame:SetBackdropColor(0.0,0.0,0.0,1.0)
	return (frame)
end

function caric:createAssignmentBackground(parent)
	caric.assignCounter = caric.assignCounter + 1
	local frame = CreateFrame("Frame","assign"..caric.assignCounter,parent)
	frame:SetWidth(400)
	frame:SetHeight(70)
	frame:SetPoint("TOP",0,-20)
	frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	frame:SetBackdropColor(0.0,0.0,0.0,0.65)
	return (frame)
end

function caric:createFramusBackground(parent)
	caric.framusCounter = caric.framusCounter + 1
	local frame = CreateFrame("Frame","framus"..caric.framusCounter,parent)
	frame:SetWidth(300)
	frame:SetHeight(30)
	frame:SetPoint("RIGHT",-10,0)
	frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	frame:SetBackdropColor(0.0,0.0,0.0,0.65)
	return (frame)
end

function caric:CreateButton(frame, name, text, x,y,width, height, template)
	if(template == nil) then
		template = "OptionsButtonTemplate"
	end
	local button = CreateFrame("Button", name, frame, template)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetPoint("CENTER",x,y)
	button:SetText(text)
	return (button)
end

function caric:CreateFont(frame, name, text,x,y,size)
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint("CENTER",x,y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	return (fontString)
end

function caric:CreateEditBox(frame, name, x,y, width, height)
	local editBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")
	editBox:SetPoint("CENTER",x,y)
	editBox:SetWidth(width)
	editBox:SetHeight(height)
	editBox:SetAutoFocus(false)
	editBox:Show()
	return (editBox)
end

if (not SA_WEAKAURA) then
	SA_WEAKAURA = {}
	SA_WEAKAURA.duration = 0
	SA_WEAKAURA.offset = 5
end
SA_WA = {}

function SA_WA:addAssign(spellid, timer , assignmentName, encounterid)  
	if (not SA_WEAKAURA[encounterid]) then
		SA_WEAKAURA[encounterid] = {}
	end
	if (not SA_WEAKAURA[encounterid][assignmentName]) then
		SA_WEAKAURA[encounterid][assignmentName] = {}
	end
	SA_WEAKAURA[encounterid][assignmentName].spellid = spellid
	SA_WEAKAURA[encounterid][assignmentName].timer = timer
end

function SA_WA:getClosestTimer(spellID) 
	local eID = SA_WEAKAURA.encounterID .. ""
	if (not SA_WEAKAURA[eID]) then
		return nil
	end  
	local closestKey = nil
	local closestTime = 10000000000
	local deltaTime = 0
	for k,v in pairs (SA_WEAKAURA[eID]) do
		if (SA_WEAKAURA[eID][k].spellid == spellID) then
			deltaTime = SA_WEAKAURA[eID][k].timer - SA_WEAKAURA.duration
			if(deltaTime > 0 and deltaTime < closestTime) then
				closestKey = k;
				closestTime = deltaTime;
			end
		end
	end
	SA_WEAKAURA.closestKey = closestKey
	return closestKey
end

function SA_OnEvent(frame, event, encounterID, ...)
	if event == "ENCOUNTER_START" then
		SA_WEAKAURA.start = GetTime()
		SA_WEAKAURA.combat = true
		SA_WEAKAURA.encounterID = encounterID	
		local eID = encounterID .. ""
		local difficulty = getDifficulty()
		if ( SA_PhaseList[eID][difficulty] ) then
			SA_PhaseList[eID][difficulty].SA_currentPhase = SA_PhaseList[eID][difficulty].SA_firstPhase
			SA_PhaseList[eID][difficulty][SA_PhaseList[eID][difficulty].SA_currentPhase].start = GetTime()
		end
		if( SA_AbilityList[eID][difficulty] ) then
			for k,v in pairs ( SA_AbilityList[eID][difficulty] ) do
				SA_AbilityList[eID][difficulty][k].counter = 0
			end
		end
	end 
   if event == "ENCOUNTER_END" then
	SA_WEAKAURA.combat = false
	_,_,_,endStatus = ...
	SA_WEAKAURA.bossKill = endStatus
	if (endStatus == 1) then -- Löscht Assignment nach Bosskampf
		eID = SA_WEAKAURA.encounterID .. ""
		SA_WEAKAURA[eID] = nil
	end
	SA_WEAKAURA.duration = 0
   end 
end

function SA_Update()
	if SA_WEAKAURA.combat then
		SA_WEAKAURA.duration = GetTime() - SA_WEAKAURA.start
		updateHP()
		updateEnergy()
		phaseHandler()
		abilityHandler()
	end
end

function updateHP ()
	if UnitExists("Boss1") then
		SA_WEAKAURA.boss1HP = UnitHealth("Boss1")/UnitHealthMax("Boss1")*100
	end
	if UnitExists("Boss2") then
		SA_WEAKAURA.boss2HP = UnitHealth("Boss2")/UnitHealthMax("Boss2")*100
	end
	if UnitExists("Boss3") then
		SA_WEAKAURA.boss3HP = UnitHealth("Boss3")/UnitHealthMax("Boss3")*100
	end
	if UnitExists("Boss4") then
		SA_WEAKAURA.boss4HP = UnitHealth("Boss4")/UnitHealthMax("Boss4")*100
	end
	if UnitExists("Boss5") then
		SA_WEAKAURA.boss5HP = UnitHealth("Boss5")/UnitHealthMax("Boss5")*100
	end
end
function updateEnergy ()
	if UnitExists("Boss1") then
		SA_WEAKAURA.boss1Energy = UnitPower("Boss1")/UnitPowerMax("Boss1")*100
	end
	if UnitExists("Boss2") then
		SA_WEAKAURA.boss2Energy = UnitPower("Boss2")/UnitPowerMax("Boss2")*100
	end
	if UnitExists("Boss3") then
		SA_WEAKAURA.boss3Energy = UnitPower("Boss3")/UnitPowerMax("Boss3")*100
	end
	if UnitExists("Boss4") then
		SA_WEAKAURA.boss4Energy = UnitPower("Boss4")/UnitPowerMax("Boss4")*100
	end
	if UnitExists("Boss5") then
		SA_WEAKAURA.boss5Energy = UnitPower("Boss5")/UnitPowerMax("Boss5")*100
	end
end
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")

frame:SetScript("OnEvent", SA_OnEvent)
frame:SetScript("OnUpdate", SA_Update)


local framus = CreateFrame("Frame")
local SA_prefix = "<SMART_ASSIGN>"
framus:RegisterEvent("CHAT_MSG_ADDON");
RegisterAddonMessagePrefix("<SMART_ASSIGN>");

function caricWrite(functionname,playerName, assignmentName, spellID, timer) 
	local msg = "";
	msg = msg .. "FUNCTIONNAME~" .. functionname .. "§"
	msg = msg .. "PLAYERNAME~" .. playerName .. "§"
	msg = msg .. "ASSIGNMENTNAME~" .. assignmentName .. "§"
	msg = msg .. "SPELLID~" .. spellID .. "§"
	msg = msg .. "TIMER~" .. timer
	print (msg)
	if ( IsInRaid() ) then
		SendAddonMessage(SA_prefix,msg,"RAID");
	elseif ( IsInGroup() ) then
		SendAddonMessage(SA_prefix,msg,"PARTY");
	end	
end

local function print_msg(...)
	--
	_,_,prefix, msg, channel, sender = ...;
	if(prefix == "<SMART_ASSIGN>") then 
		local argList = mysplit(msg, "§")
		arguments = {}
		for num,arg in pairs (argList) do
			local a = mysplit(arg, "~")
			arguments[a[1]] = a[2]
		end	
		local ownName = GetUnitName("PLAYER")
		local ownRealm = GetRealmName()
		ownRealm = ownRealm:gsub("%s+", "") -- Um aus "Tarren Mill" => "TarrenMill" zu machen
		if ( arguments.PLAYERNAME == ownName or arguments.PLAYERNAME == (ownName .. "-" .. ownRealm)) then
			local spellID = tonumber(arguments.SPELLID)
			local timer = tonumber(arguments.TIMER)
			SA_WA:addAssign(spellID, timer , arguments.ASSIGNMENTNAME)
		end
	end		
end
framus:SetScript("OnEvent", print_msg);

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function createPhase(encounterID, phaseName, previousPhase, trigger, triggerTyp, mythicFlag, heroicFlag, normalFlag)
	encounterID = encounterID .. ""
	if ( not mythicFlag and not heroicFlag and not normalFlag ) then
		return false
	end
	if (not SA_PhaseList[encounterID]) then
		SA_PhaseList[encounterID] = {}
		SA_PhaseList[encounterID].SA_firstPhase = phaseName
		SA_PhaseList[encounterID].SA_currentPhase = phaseName
	end
	local difficulties = {}
	if ( mythicFlag ) then
		table.insert(difficulties, "Mythic")
	end
	if ( heroicFlag ) then
		table.insert(difficulties, "Heroic")
	end
	if ( normalFlag ) then
		table.insert(difficulties, "Normal")
	end
	for number, difficulty in ipairs ( difficulties ) do
		if (not SA_PhaseList[encounterID][difficulty]) then
			SA_PhaseList[encounterID][difficulty] = {}
			SA_PhaseList[encounterID][difficulty].SA_firstPhase = phaseName
			SA_PhaseList[encounterID][difficulty].SA_currentPhase = phaseName
		end
		SA_PhaseList[encounterID][difficulty][phaseName] = {}
		SA_PhaseList[encounterID][difficulty][phaseName].start = ""
		SA_PhaseList[encounterID][difficulty][phaseName].duration = 0
		if ( not previousPhase ) then
			SA_PhaseList[encounterID][difficulty].SA_firstPhase = phaseName
			SA_PhaseList[encounterID][difficulty].SA_currentPhase = phaseName
		else
			SA_PhaseList[encounterID][difficulty][previousPhase].nextPhase = phaseName
			SA_PhaseList[encounterID][difficulty][previousPhase].nextTriggerTyp = triggerTyp
			if ( triggerTyp == "text" ) then
				SA_PhaseList[encounterID][difficulty][previousPhase].nextTrigger = trigger
			else
				SA_PhaseList[encounterID][difficulty][previousPhase].nextTrigger = tonumber(trigger)
			end		
		end	
	end
	
end

--/script createAbility("1737", "Eyes", 10, true , true , true)
--/script createAbility("1737", "Knock back", 7, true , true , true)
--/script createPhase("1837", "P1", nil, nil, nil, true, nil, true)
--/script createPhase("1837", "P2", "P1", 90, "HP", true, nil, true)
--/script createPhase("1837", "P3", "P2", 80, "HP", true, nil, true)
--/script createPhase("1837", "P4", "P3", 30, "Time", true, nil, true)
function createAbility(encounterID, abilityName, cooldown, mythicFlag, heroicFlag, normalFlag)
	encounterID = encounterID .. ""
	if ( not mythicFlag and not heroicFlag and not normalFlag ) then
		return false
	end
	print ("1")
	if (not SA_AbilityList[encounterID] ) then
		SA_AbilityList[encounterID] = {}
	end
	local difficulties = {}
	if ( mythicFlag ) then
		table.insert(difficulties, "Mythic")
	end
	if ( heroicFlag ) then
		table.insert(difficulties, "Heroic")
	end
	if ( normalFlag ) then
		table.insert(difficulties, "Normal")
	end
	print ("2")
	for number,difficulty in ipairs ( difficulties ) do
		if (not SA_AbilityList[encounterID][difficulty] ) then
			SA_AbilityList[encounterID][difficulty] = {}
		end
		if (not SA_AbilityList[encounterID][difficulty][abilityName] ) then
			SA_AbilityList[encounterID][difficulty][abilityName] = {}
		end
		SA_AbilityList[encounterID][difficulty][abilityName].cooldown = cooldown
	end
end

function abilityHandler()
	local eID = SA_WEAKAURA.encounterID .. ""
	local difficulty = getDifficulty()
	if(not SA_AbilityList[eID] or not SA_PhaseList[eID]) then
		return false
	end
	if(not SA_AbilityList[eID][difficulty] or not SA_PhaseList[eID][difficulty]) then
		return false
	end
	for k,v in pairs(SA_AbilityList[eID][difficulty]) do
		local phase = SA_PhaseList[eID][difficulty].SA_currentPhase
		local duration = SA_PhaseList[eID][difficulty][phase].duration
		local oldCounter = SA_AbilityList[eID][difficulty][k].counter
		SA_AbilityList[eID][difficulty][k].counter = tonumber(string.format("%i", (duration / SA_AbilityList[eID][difficulty][k].cooldown))) -- Trennen der Nachkommastellen
		if(oldCounter < SA_AbilityList[eID][difficulty][k].counter) then
			SendChatMessage(k .. " ".. SA_AbilityList[eID][difficulty][k].counter, "SAY", "Common");
		end
	end
end

function phaseHandler()
	local eID = SA_WEAKAURA.encounterID .. ""
	if ( not SA_PhaseList[eID] ) then
		return false 
	end
	
	local difficulty = getDifficulty()
	if ( not SA_PhaseList[eID][difficulty] ) then
		return false
	end
	
	local currentPhase = SA_PhaseList[eID][difficulty].SA_currentPhase
	SA_PhaseList[eID][difficulty][currentPhase].duration = GetTime() - SA_PhaseList[eID][difficulty][currentPhase].start
	local triggerTyp = SA_PhaseList[eID][difficulty][currentPhase].nextTriggerTyp
	local trigger = SA_PhaseList[eID][difficulty][currentPhase].nextTrigger
	
	if ( triggerTyp == "Energy" ) then
		if ( SA_WEAKAURA.boss1Energy <= trigger ) then
			SA_PhaseList[eID][difficulty].SA_currentPhase = SA_PhaseList[eID][difficulty][currentPhase].nextPhase
			SA_PhaseList[eID][difficulty][SA_PhaseList[eID].SA_currentPhase].start = GetTime()
			SendChatMessage(SA_PhaseList[eID][difficulty][currentPhase].nextPhase, "SAY", "Common");
		end
	elseif ( triggerTyp == "HP" ) then
		if ( SA_WEAKAURA.boss1HP <= trigger ) then
			SA_PhaseList[eID][difficulty].SA_currentPhase = SA_PhaseList[eID][difficulty][currentPhase].nextPhase
			SA_PhaseList[eID][difficulty][SA_PhaseList[eID][difficulty].SA_currentPhase].start = GetTime()
			SendChatMessage(SA_PhaseList[eID][difficulty][currentPhase].nextPhase, "SAY", "Common");
		end
	elseif ( triggerTyp == "Time" ) then
		if ( SA_PhaseList[eID][difficulty][currentPhase].duration >= trigger ) then
			SA_PhaseList[eID][difficulty].SA_currentPhase = SA_PhaseList[eID][difficulty][currentPhase].nextPhase
			SA_PhaseList[eID][difficulty][SA_PhaseList[eID][difficulty].SA_currentPhase].start = GetTime()
			SendChatMessage(SA_PhaseList[eID][difficulty][currentPhase].nextPhase, "SAY", "Common");
		end
	elseif ( triggerTyp == "Text") then --TODO
	end
	
end

function getDifficulty() 
	local difficultyID  = select(3, GetInstanceInfo())
	if ( difficultyID == 1 or difficultyID == 3 or difficultyID == 4 or difficultyID ==  14 ) then
		return "Normal" 
	elseif ( difficultyID == 2 or difficultyID == 5 or difficultyID == 6 or difficultyID ==  15 ) then
		return "Heroic" 
	elseif ( difficultyID == 16 or difficultyID == 23 ) then
		return "Mythic" 
	else
		return false
	end		
end
--[[
	Justin Funktion. Mit der Funktion kann man alle RaidBosse aus allen Expansions 
	in die Saved Variables speichern. Hierbei werden sogar die MapIDs und BossIDs 
	mit gespeichert. Die Boss / EncounterIDs können später zum filtern genutzt werden.
]]
function fillRaidsAndBosses()
	local t = 1
	for t = 1, EJ_GetNumTiers() , 1 do
	
		EJ_SelectTier(t)
		tiername,_ = EJ_GetTierInfo(t)
		SA_BossList[tiername] = {}
		
		local i = 1
		while EJ_GetInstanceByIndex(i, true) do
			SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
			print(SA_instanceId, SA_name)
			SA_BossList[tiername][SA_name] = {}
			EJ_SelectInstance(SA_instanceId)
			i = i+1
    
			local j = 1
			while EJ_GetEncounterInfoByIndex(j, instanceId) do
				local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
				SA_BossList[tiername][SA_name][name] = {}
				SA_BossList[tiername][SA_name][name].encounterID = encounterId
				print("--> ",encounterId, name)
				j = j+1
			end
		end
	end
end