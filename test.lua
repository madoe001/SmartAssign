SA_WA = {}


--- SA_WA:addAssign
-- @author  Veith, Marvin Justin (10043555)
-- @param spellid Die SpellID ist ein von Blizzard eindeutiger Wert, der verwendet wird um verschiedene Zauber zu identifizieren. Die SpellID wird später verwendet um dem Spieler den zu verwendenen Zauber darzustellen.
-- @param timer Bei timerbasierten Assignments wird ein fester Zeitpunkt in Sekunden übergeben. Der Zeitpunktstatisch und meistens eher ungenau.
-- @param assignmentName Gibt dem Assignment einen eindeutigen Namen. Ein vorhandenes Assignment mit dem selben Namenwird überschrieben.
-- @param encounterid Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bekämpfenden Boss zuidentifizieren. Somit werden im Bosskampf nur die Assignments geladen, die für den jeweiligenBoss erstellt wurden.
-- @usage Diese Funktion  erstellt ein Assignment. Das Assignment wird in eine Saved Variable gespeichert, somit bleibt 
			 -- es auch nach Neustart gespeichert. Jedes Assignment wird eindeutig über die Kombination aus EncounterID und
			 -- assignmentName gespeichert. Die EncounterID bestimmt hierbei den zu bekämpfenden Boss. Es können also mehrere
			 -- Assignments erstellt werden und später zu den Bossen geladen.
function SA_WA:addAssign(spellid, timer , assignmentName, encounterid)  -- TODO Ability basierte Assignments hinzufügen
	encounterid = encounterid .. ""
	if (not SA_WEAKAURA[encounterid]) then
		SA_WEAKAURA[encounterid] = {}
	end
	if (not SA_WEAKAURA[encounterid][assignmentName]) then
		SA_WEAKAURA[encounterid][assignmentName] = {}
	end
	SA_WEAKAURA[encounterid][assignmentName].spellid = spellid
	SA_WEAKAURA[encounterid][assignmentName].timer = timer
end


--- SA_WA:addAssign
-- @author  Veith, Marvin Justin (10043555)
-- @param spellid Die SpellID ist ein von Blizzard eindeutiger Wert, der verwendet wird um verschiedene Zauber zu identifizieren. Die SpellID wird später verwendet um dem Spieler den zu verwendenen Zauber darzustellen.
-- @return Zeitpunkt des zunächst verwendenen Zaubers.
-- @usage Es besteht die Möglichkeit, dass in einem Kampf ein Zauber öfter zugeteilt worden ist. Es ist nicht möglich
			 -- in der Weakaura mehrere Zeiten darzustellen. Deswegen wird diese Funktion verwendet, um immer nur den als nächstes
			 -- eintretenden Zeitpunkt zu bestimmen.
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



--- SA_OnEvent
-- @author  Veith, Marvin Justin (10043555)
-- @param frame Wird nicht verwendet. Der Frame wird allerdings als Parameter bei einem Eventstart übergeben.
-- @param event Bestimmt im Stringformat welches Event ausgelöst wurde.
-- @param encounterID Eindeutige Zuweisung des grade bekämpften Bosses.
-- @usage Es handelt sich hierbei um einen Eventhandler. Der Eventhandler "SA_OnEvent" wird bei jedem Event von 
			 -- Spiel automatisch aufgerufen.
			 -- Verwendet werden hierbei:
			 
			 -- ENCOUNTER_START: Initialisiert alle für den Kampf wichtigen Daten. Der SA_WEAKAURA.combat Flag wird auf 
							  -- true gesetzt, um den Status des aktuellen Bosskampfes zu beschreiben. 
							  -- Es werden alle Zeitpunkte gesetzt, somit kann man die Kampflänge bestimmen.
							  -- Es wird der Startpunkt der Abilities und die Startphase gesetzt.
			
			 -- ENCOUNTER_END:	 Setzt den SA_WEAKAURA.combat Flag auf false. Damit wird bestimmt, dass sich der Spieler
							 -- nicht mehr im Kampf befindet. 
							 -- Wenn der Boss erfolgreich besiegt worden ist, werden alle Assignments gelöscht. Damit 
							 -- die Assignments nicht erneut mit einer anderen Gruppe geladen werden.
function SA_OnEvent(frame, event, encounterID, enc, dif,...)
	if event == "ENCOUNTER_START" then
		SA_WEAKAURA.start = GetTime()
		SA_WEAKAURA.combat = true
		SA_WEAKAURA.encounterID = encounterID	
		local eID = encounterID .. ""
		local difficulty = getDifficulty()
		print(enc, dif)
		if ( SA_PhaseList[eID] ) then
			if ( SA_PhaseList[eID][difficulty] ) then
				SA_PhaseList[eID][difficulty].SA_currentPhase = SA_PhaseList[eID][difficulty].SA_firstPhase
				SA_PhaseList[eID][difficulty][SA_PhaseList[eID][difficulty].SA_currentPhase].start = GetTime()
			end
		end
		if( SA_AbilityList[eID]) then
			if( SA_AbilityList[eID][difficulty] ) then
				for k,v in pairs ( SA_AbilityList[eID][difficulty] ) do
					SA_AbilityList[eID][difficulty][k].counter = 1
					SA_AbilityList[eID][difficulty][k].start = GetTime()
					SA_AbilityList[eID][difficulty][k].nextStart = false
				end
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
   end 
end


--- SA_Update
-- @author  Veith, Marvin Justin (10043555)
-- @usage Diese Funktion wird jeden Frame aufgerufen. Falls der Spieler sich im Kampfbefindet
			 -- wird die Kampfdauer neu berechnet und die Auswertung an verschiedene Handler delegiert.
function SA_Update()
	if SA_WEAKAURA.combat then		
		SA_WEAKAURA.duration = GetTime() - SA_WEAKAURA.start
		updateHP()
		updateEnergy()
		phaseHandler()
		abilityHandler()
	end
end



--- updateHP
-- @author  Veith, Marvin Justin (10043555)
-- @usage Dieser Handler aktualisiert jeden Frame die Lebenspunkte der Bosse in Prozent.
			 -- Die Lebenspunkte werden in SA_WEAKAURA zwischengespeichert.
			 -- Es ist wichtig die Prozentzahl der Lebenspunkte zu messen, da dies ein Indikator
			 -- für das wechseln von Phasen ist.
			 
			 -- Es wird mit Prozentwerten anstatt festen Zahlen gearbeitet, da die Lebenspunkte
			 -- von Blizzard verändert werden können. Außerdem ist sie im "normal" und "heroic" 
			 -- Schwierigkeitsgrad abhängig von der Gruppengröße. 
			 -- Die Prozentwerte bleiben allerdings immer gleich.
function updateHP()
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


--- updateEnergy
-- @author  Veith, Marvin Justin (10043555)
-- @usage Dieser Handler aktualisiert jeden Frame die Energie der Bosse in Prozent.
			 -- Die Energie wird in SA_WEAKAURA zwischengespeichert.
			 -- Es ist wichtig die Prozentzahl der Energie zu messen, da dies ein Indikator
			 -- für das wechseln von Phasen ist.
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

local frame = CreateFrame("Frame")
-- Registriert alle Events beim Server
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")
-- 
frame:SetScript("OnEvent", SA_OnEvent)
frame:SetScript("OnUpdate", SA_Update)


-- Regestriert AddonChat und Events beim Server
local framus = CreateFrame("Frame")
local SA_AddonChat_prefix = "<SMART_ASSIGN>"
framus:RegisterEvent("CHAT_MSG_ADDON");
RegisterAddonMessagePrefix(SA_AddonChat_prefix);


--- sendAssignInformations
-- @author  Veith, Marvin Justin (10043555)
-- @param functionname Gibt an welche Funktion aufgerufen werden soll.
-- @param playerName Gibt den Spieler an, der angesprochen werden soll.
-- @param assignmentName Gibt den Assignmentname an. Dieser wird später zum anlegen eines Assignments alsKey verwendet.
-- @param spellID Gibt die SpellID an. Anhand der SpellID wird dem Spieler der zugeteilte Zauber angezeigt. Die SpellID identifiziert jeden Zauber eindeutig.
-- @param timer Falls es sich um ein timerbasiertes Assignment handelt, wird die Zeit in Sekundenangegeben, in das Assignment ausgelöst wird.
-- @param encounterID Gibt den Boss anhand seiner eindeutigen Nummer an. Die EncounterID dient als Schlüssel für den Phasehandler, den Abilityhandler und dem Assignmenthanddler.
-- @usage Diese Funktion sendet über den Addonchatchannel eine Nachricht an alle Gruppen- / Raidmitglieder.
			 -- Es können alle Parameter und die auf zu rufenden Funktionen angegeben werden.
			 -- Mit dieser Funktionalität kann der Raidleiter nach dem erstellen der Assignments, diese an alle Spieler senden.
			 -- Jedes Addon muss sein Prefix registrieren. Dadurch können alle Nachrichten gefiltert werden.
			 -- Es können sogar Phasen und Abilities über diese Funktion gesendet werden. Dadurch erhalten die Raidmitglieder
			 -- alle passenden Informationen.
function sendAssignInformations(functionname, playerName, assignmentName, spellID, timer, encounterID)  -- TODO Name ändern und weiter ausbauen
	local msg = "";
	msg = msg .. "FUNCTIONNAME~" .. functionname .. "§"
	msg = msg .. "PLAYERNAME~" .. playerName .. "§"
	msg = msg .. "ASSIGNMENTNAME~" .. assignmentName .. "§"
	msg = msg .. "SPELLID~" .. spellID .. "§"
	msg = msg .. "TIMER~" .. timer .. "§"
	msg = msg .. "ENCOUNTERID~" .. encounterID
	if ( IsInRaid() ) then
		SendAddonMessage(SA_AddonChat_prefix,msg,"RAID");
	elseif ( IsInGroup() ) then
		SendAddonMessage(SA_AddonChat_prefix,msg,"PARTY");
	end	
end


--- addonChatHandler
-- @author  Veith, Marvin Justin (10043555)
-- @param prefix Identifiziert das Addon. Jedes Addon muss sein Prefix beim Server registrieren.
-- @param msg Zusammenkonkanketinierter String, der alle Parameter enthält. Der Text wird wieder aufgesplittet.
-- @param channel Gibt den Channel an. Kann ignoriert werden.
-- @param sender Gibt den Nachrichtensender an. Wird nicht verwendet.
-- @usage Der Chathandler liest alle Nachrichten mit, die im Addonchatchannel gesendet werden.
			 -- Es werden zuerst alle Nachrichten von diesem Projekt gefiltert. Im nächsten Schritt
			 -- wird geprüft für welchen Spieler die Nachricht adressiert wurde.
			 -- Abhängig von der übergebenen Funktion und Parameter werden diese weiter delegiert.
function addonChatHandler(...)
	
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
		print(arguments.PLAYERNAME)
		ownRealm = ownRealm:gsub("%s+", "") -- Um aus "Tarren Mill" => "TarrenMill" zu machen
		if ( arguments.PLAYERNAME == ownName or arguments.PLAYERNAME == (ownName .. "-" .. ownRealm)) then
			local spellID = tonumber(arguments.SPELLID)
			local timer = tonumber(arguments.TIMER)
			SA_WA:addAssign(spellID, timer , arguments.ASSIGNMENTNAME, arguments.ENCOUNTERID)
		end
	end		
end

framus:SetScript("OnEvent", addonChatHandler)

--- mysplit
-- @author  Veith, Marvin Justin (10043555)
-- @param inputstr Hierbei handelt es sich um den zu splittenden String
-- @param sep Seperator. Der Seperator bestimmt das Zeichen, bei welchem der String getrennt werden soll. WICHTIG !!! Falls mehrere Zeichen als Seperator verwendet werden, wird für jedesZeichen einzeln gesplittet !!! 
-- @return Tabelle mit allen Teilstrings.
-- @usage Die Funktion "mysplit" wurde hauptsächlich für das Parsen der gesendeten Nachrichten verwendet.
			 -- Der übergebene String wird in mehrere Strings abhängig von dem Seperator getrennt und in eine Tabelle 
			 -- gespeichert.
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

--- createPhase
-- @author  Veith, Marvin Justin (10043555)
-- @param encounterID Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bekämpfenden Boss zu identifizieren. Die EncounterID ist eines von drei Keys um die Phase eindeutig zu identifizieren.
-- @param phaseName Der Phasenname beschreibt neben der EncounterID und dem Schwierigkeitsgrad eindeutig. Der Phasenname ist eines von drei Keys um die Phase eindeutig zu identifizieren.
-- @param previousPhase Gibt die vorherige Phase an. Wenn keine Phase angegeben wird, ist diese Phase die erste Phase.
-- @param trigger Schreibt die Bedinung für den Wechsel in die eigene Phase in die vorherige Phase.
-- @param triggerTyp Bestimmt ob die Phase abhängig von Leben, Energie, Zeit oder einem Text gewechselt werden soll. Der genaue Wert hierfür steht in "trigger".
-- @param mythicFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Mythic" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @param heroicFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Heroic" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @param normalFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Normal" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @usage Die Funktion legt eine Phase abhängig der encounterID, den Phasennamen und dem Schwierigkeitsgrad an.
			 -- Für den Schwierigkeitsgrad gibt es drei Flags, wovon mindestens ein Flag gesetzt sein muss.
			 -- Für jeden angegebenen Schwierigkeitsgrad wird die selbe Phase erstellt. 
			 -- Es wird die aktuelle und die erste Phase fest gespeichert. Die Phasen sind aneinander gekettet. Hierbei
			 -- muss immer das vorherige Element und die Bedinung für den Phasenwechsel angegeben werden. 
			 -- Es handelt sich also um eine Art von einer einfach verketteten Liste, mit sich selbst definierten Auslöser
			 -- für den Wechsel der Phasen.
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

--- createAbility
-- @author  Veith, Marvin Justin (10043555)
-- @param encounterID Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bekämpfenden Boss zu identifizieren. Die EncounterID ist eines von drei Keys um die Phase eindeutig zu identifizieren.
-- @param abilityName Der Abilityname beschreibt neben der EncounterID und dem Schwierigkeitsgrad eindeutig. Der Abilityname ist eines von drei Keys um die Phase eindeutig zu identifizieren.
-- @param cooldown Es kann ein bis mehrere Timer für eine Ability übergeben werden. Bei der Verwendung von mehreren Timern, müssen die Timer durch Semikolons getrennt werden. Die Zeit wird in Sekunden angegeben.
-- @param boundedPhases Es können keine bis mehrere Phasen für eine Ability übergeben werden. Bei der Verwendung von mehreren Phasen, müssen die Phasen durch Semikolons getrennt werden.
-- @param loopingListFlag Falls mehrere Timer für eine Ability verwendet werden, muss eine Methode für das Iterieren ausgewählt werden. Es gibt hierbei folgende Möglichkeiten: true  = Die Liste wird beim ersten Element wiederholt, falls sie durchlaufen ist. false = Wenn die Liste durchlaufen ist, wird nur noch die letzte Zeit ausgewählt.
-- @param mythicFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Mythic" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @param heroicFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Heroic" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @param normalFlag Falls gesetzt wird die Phase für den Schwierigkeitsgrad "Normal" erstellt. Es muss mindestens einer der Flags gesetzt sein.
-- @param resetTimerOnPhaseStartFlag - Wenn dieses Flag gesetzt ist, wird der Timer abhängig vom Phasenwechsel neu gestartet.  Dies ist bei manchen Bossen notwendig, da es sonst zu verschobenen Timern und somit zu unmöglich spielbaren Kombinationen an Fähigkeiten kommen kann.
-- @usage Die Funktion legt eine Ability abhängig der encounterID, den Abilitynamen und dem Schwierigkeitsgrad an.
			 -- Für den Schwierigkeitsgrad gibt es drei Flags, wovon mindestens ein Flag gesetzt sein muss.
			 -- Für jeden angegebenen Schwierigkeitsgrad wird die selbe Ability erstellt. 
			 -- In der Ability wird der Cooldown bzw. die Cooldownliste mit der zugehörigen Iterierungsmethode gespeichert. 
			 -- Außerdem wird gespeichert ob der Timer fest vorkommt oder sich mit einem Phasenwechsel verschiebt. 
			 -- Manche Fähigkeiten treten im gesamten Kampf auf, beziehungsweise nur in bestimmten Phasen. Also wird eine Zuordnung von
			 -- Ability zu Phase ebenfalls erstellt.
function createAbility(encounterID, abilityName, cooldown,boundedPhases, mythicFlag, heroicFlag, normalFlag, loopingListFlag, resetTimerOnPhaseStartFlag)
	encounterID = encounterID .. ""
	if ( not mythicFlag and not heroicFlag and not normalFlag ) then
		return false
	end
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
	for number,difficulty in ipairs ( difficulties ) do
		if (not SA_AbilityList[encounterID][difficulty] ) then
			SA_AbilityList[encounterID][difficulty] = {}
		end
		if (not SA_AbilityList[encounterID][difficulty][abilityName] ) then
			SA_AbilityList[encounterID][difficulty][abilityName] = {}
		end
		if ( resetTimerOnPhaseStartFlag ) then
			SA_AbilityList[encounterID][difficulty][abilityName].resetTimerOnPhaseStart = true
		end		
		if ( loopingListFlag ) then
			SA_AbilityList[encounterID][difficulty][abilityName].iterateMethod = "Looping"
		else
			SA_AbilityList[encounterID][difficulty][abilityName].iterateMethod = "Iterating"
		end
		if( boundedPhases ) then
			local phases = mysplit(boundedPhases, ";")
			SA_AbilityList[encounterID][difficulty][abilityName].boundToPhase = true
			SA_AbilityList[encounterID][difficulty][abilityName].boundedPhases = {}
			SA_AbilityList[encounterID][difficulty][abilityName].boundedPhases = phases;
		end
			local cooldowns = mysplit(cooldown, ";")
			SA_AbilityList[encounterID][difficulty][abilityName].cooldown = {}
			SA_AbilityList[encounterID][difficulty][abilityName].cooldown = cooldowns
			SA_AbilityList[encounterID][difficulty][abilityName].start = 0
			SA_AbilityList[encounterID][difficulty][abilityName].nextStart = true
			SA_AbilityList[encounterID][difficulty][abilityName].SA_lastPhase = ""
	end
end


--- abilityHandler
-- @author  Veith, Marvin Justin (10043555)
-- @usage Der Abilityhandler überprüft zuerst ob es einen Eintrag gibt. Hierbei wird die EncounterID, welche den 
			 -- aktuell bekämpften Boss eindeutig identifiziert und der Schwierigkeitsgrad überprüft. 
			 -- Falls kein Eintrag vorhanden ist, wird der Handler verlassen.
			 
			 -- Im zweiten Schritt wird die Iterierungsmethode bestimmt und ein Counter angelegt. Der Counter zählt mit
			 -- zum wie vielten mal eine Ability gewirkt wird. Der Counter ist notwendig, weil zum Beispiel bei jeder 
			 -- Ability ein Spieler sein Cooldown benutzen soll, aber nicht alle gleichzeitig. Das mitzählen und merken
			 -- ist nicht Praxis tauglich, also wird der Counter gespeichert von diesem Projekt gespeichert.
			 
			 -- Im dritten Schritt wird überprüft, ob die Ability ausgelöst werden kann. Abilities die nicht phasengebunden sind,
			 -- können immer ausgelöst werden. Bei phasengebunden Abilities wird überprüft, ob die Ability an die aktuelle Phase
			 -- gebunden ist.
			 
			 -- Zum Schluss werden die Zeitstempel für das Auslösen der Ability gesetzt. Außerdem wird überprüft, ob bereits einer 
			 -- der Zeitstempel überschritten wurde. Falls ja wird ein neuer Zeitstempel erzeugt und der Counter um eins erhöht.
function abilityHandler()
	-- Überprüft ob Eintrag vorhanden ist.
	local eID = SA_WEAKAURA.encounterID .. ""
	local difficulty = getDifficulty()
	if(not SA_AbilityList[eID]) then
		return false
	end
	if(not SA_AbilityList[eID][difficulty]) then
		return false
	end
	
	local totalDuruation = SA_WEAKAURA.duration -- Gesamtlaufzeit für nicht an Phasen gebundene Abilities
	
	-- Berechnet den Counter und bestimmt die Iterierungsmethode um die Cooldownliste zu durchlaufen.
	for k,v in pairs(SA_AbilityList[eID][difficulty]) do
		local iterateMethod = SA_AbilityList[eID][difficulty][k].iterateMethod
		local listIndex = SA_AbilityList[eID][difficulty][k].counter
		local t = SA_AbilityList[eID][difficulty][k].cooldown
		local amountCooldowns = #t
		if ( iterateMethod == "Looping" ) then
			if ( amountCooldowns > 0 ) then
				listIndex = listIndex % amountCooldowns
				if ( listIndex == 0 ) then
					listIndex = amountCooldowns
				end
			end
		elseif ( iterateMethod == "Iterating" ) then
			if ( listIndex > amountCooldowns ) then
				listIndex = amountCooldowns
			end 
		end
		
		local isTriggerable = false
		
		-- Bestimmt ob die Ability ausgelöst werden kann, abhängig ob die dazugehörige Phase aktiv ist bzw. ob 
		-- Ability phasenunabhängig ist.
		if ( SA_AbilityList[eID][difficulty][k].boundToPhase) then
			if ( SA_PhaseList[eID] ) then
				if(SA_PhaseList[eID][difficulty] ) then
					for num, phaseName in ipairs ( SA_AbilityList[eID][difficulty][k].boundedPhases ) do
						if ( SA_PhaseList[eID][difficulty].SA_currentPhase == phaseName ) then
							isTriggerable = true
						end
					end
				end
			end
		else
			isTriggerable = true
		end
		SA_AbilityList[eID][difficulty][k].active = isTriggerable
		-- Legt die Zeitstempel zum triggern fest.
		if ( isTriggerable ) then
			if ( SA_AbilityList[eID][difficulty][k].resetTimerOnPhaseStart ) then
				if ( SA_PhaseList[eID] ) then
					if ( SA_PhaseList[eID][difficulty] ) then			
						if ( SA_AbilityList[eID][difficulty][k].SA_lastPhase ~= SA_PhaseList[eID][difficulty].SA_currentPhase) then
							SA_AbilityList[eID][difficulty][k].SA_lastPhase = SA_PhaseList[eID][difficulty].SA_currentPhase
							SA_AbilityList[eID][difficulty][k].nextStart = true
						end
					end
				end
			end
			if ( SA_AbilityList[eID][difficulty][k].nextStart ) then
				SA_AbilityList[eID][difficulty][k].nextStart = false
				SA_AbilityList[eID][difficulty][k].start = GetTime()
			end
			--Erhöht Counter und setzt neuen Timer fest, falls der aktuelle Zeitstempel überschritten ist.
			if ( SA_AbilityList[eID][difficulty][k].start + SA_AbilityList[eID][difficulty][k].cooldown[listIndex] < GetTime() ) then
				SA_AbilityList[eID][difficulty][k].counter = SA_AbilityList[eID][difficulty][k].counter + 1
				SA_AbilityList[eID][difficulty][k].nextStart = true
			end			
		end
	end	
end



--- phaseHandler
-- @author  Veith, Marvin Justin (10043555)
-- @usage Der Phasehandler überprüft zuerst ob es einen Eintrag gibt. Hierbei wird die EncounterID, welche den 
			 -- aktuell bekämpften Boss eindeutig identifiziert und der Schwierigkeitsgrad überprüft. 
			 -- Falls kein Eintrag vorhanden ist, wird der Handler verlassen.
			 
			 -- Im zweiten Schritt wird die Laufzeit der Phase berechnet. Nebenbei wird der Trigger und der Triggertyp
			 -- der aktuellen Phase bestimmt.
			 
			 -- Im dritten Schritt wird abhängig von dem Triggertyp und dem Trigger geprüft ob die Kriterien für das wechseln
			 -- in die neue Phase erfüllt sind.
			 
			 -- Der Aufgabe des Handlers ist also die Berechnung der Dauer der aktuellen Phase, welche von den Abilities 
			 -- verwendet wird. Außerdem überprüft der Phasehandler in jedem Frame, ob die Phase gewechselt werden muss.
function phaseHandler()

	-- Überprüft ob Eintrag vorhanden ist.
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


--- getDifficulty
-- @author Veith, Marvin Justin (10043555)
-- @return Gibt den Schwierigkeitsgrad an, in dem sich der Spieler derzeit befindet.
-- @usage Es gibt bereits von Blizzard eine Funktion um den Schwierigkeitsgrad zu bestimmen, allerdings wird hierbei in 25
			 -- verschiedene Schwierigkeitsgrade unterschieden. Die Vielfalt an Schwierigkeitsgraden ist historisch bedingt.
			 -- Die Funktion getDifficulty() fast die verschiedenen Schwierigkeitsgrade zusammen. Es bleiben nur noch die drei
			 -- gängigen Schwierigkeitsgrade "Normal", "Heroic" und "Mythic" über.
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


--- fillRaidsAndBosses
-- @author  Veith, Marvin Justin (10043555)
-- @usage Die Funktion in ihrer Grundform zufällig entdeckt. Die Funktion wurde im nachhinein stark überarbeitet.
			 -- Die Funktion besteht aus drei ineinander verschachtelten Schleifen. 
			 -- Die äußere Schleife iteriert über alle möglichen Expansions und legt diese in der Saved Variable SA_BossList an.
			 -- Die mittlere Schleife iteriert über alle Raids, abhängig von der Expansion. Dieser Zusammenhang wird 
			 -- in der Saved Variable SA_BossList gespeichert.
			 -- Die innere Schleife iteriert über alle Bosse, abhängig von dem Raid. Dieser Zusammenhang wird in der Saved
			 -- Variable SA_BossList gespeichert. Es wird hierbei die EncounterID gespeichert. 
			 -- Es ist also möglich eindeutig den Boss über die drei Keys "Expansion", "Raid" und "Boss" zu finden.
			 -- Für die interne Verwendung wird die EncounterID verwendet. 
			 -- Hier für gibt es zwei Gründe. Erstens: Die EncounterID ist viel kürzer als alle drei Keys zu speichern.
			 -- Zweitens: Das Event liefert nur die EncounterID als Parameter. Somit kann funktioniert das Addon unabhänhig
			 -- der Sprache des Spiels.
function fillRaidsAndBosses()
	local t = 1
	for t = 1, EJ_GetNumTiers() , 1 do
	
		EJ_SelectTier(t)
		tiername,_ = EJ_GetTierInfo(t)
		SA_BossList[tiername] = {}
		
		local i = 1
		while EJ_GetInstanceByIndex(i, true) do
			SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
			SA_BossList[tiername][SA_name] = {}
			EJ_SelectInstance(SA_instanceId)
			i = i+1
    
			local j = 1
			while EJ_GetEncounterInfoByIndex(j, instanceId) do
				local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
				SA_BossList[tiername][SA_name][name] = {}
				SA_BossList[tiername][SA_name][name].encounterID = encounterId
				j = j+1
			end
		end
	end
end