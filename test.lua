--table
caric = {}
caric.framusCounter = 42;
caric.assignCounter = 0;

function caric:Init(event, addon)
	if(event == "ADDON_LOADED" and addon == "SmartAssign") then
		--caric:CreateGUI(testFrame)
		--NewAbillityWindow:show()
		--BossSelectFrame:show(UIParent)
	end
end

--frame erstellen und events registrieren
testFrame = CreateFrame("Frame","testFrame",UIParent)
testFrame:SetScript("OnEvent",caric.Init)
testFrame:RegisterEvent("ADDON_LOADED")

function caric:CreateGUI(frame)
	--Fenster
	local window = caric:CreateWindow(frame)
	caric:CreateButton(frame, "closeButton", nil, 240,240,30,30, "UIPanelCloseButton")
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

--[[
Function Name: caric:CreateWindow
Author: Veith, Marvin Justin (10043555)
Parameters: frame - 
Description: TODO  Dokumentieren, evtl noch etwas �berarbeiten.
]]	
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

--[[
Function Name: caric:CreateButton
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Das Frame in dem der Button angezeigt werden soll
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
				   text - Bestimmt den Text, der auf dem Button angezeigt wird.
					  x - Horizontale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Buttons.
				 height - H�he des Buttons.
			   template - Es gibt verschiedene Buttontypen. Der CloseButton zum Beispiel enth�lt die Funktionalit�t sein Parentframe zu schlie�en.
						  Default: "OptionsButtonTemplate"
Return: Referenz des Buttons.
Description: Bei dieser Funtion handelt es sich um eine Utility-Funktion. Diese Funktion wurde f�r Testzwecke entworfen.
			 Mithilfe dieser Funktion kann ein Button mit nur einem Funktionsaufruf erstellt und positioniert werden.
]]	
function caric:CreateButton(parentFrame, name, text, x,y,width, height, template)
	if(template == nil) then
		template = "OptionsButtonTemplate"
	end
	local button = CreateFrame("Button", name, parentFrame, template)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetPoint("CENTER",x,y)
	button:SetText(text)
	return (button)
end

--[[
Function Name: caric:CreateFont
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Das Frame in dem der Button angezeigt werden soll
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
				   text - Bestimmt den anzuzeigenen Text.
					  x - Horizontale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  size  - Bestimmt die Schriftgr��e.
Return: Referenz des Fonts.
Description: Bei dieser Funtion handelt es sich um eine Utility-Funktion. Diese Funktion wurde f�r Testzwecke entworfen.
			 Mithilfe dieser Funktion kann ein Text mit nur einem Funktionsaufruf erstellt und positioniert werden.
			 ]]
function caric:CreateFont(frame, name, text,x,y,size) -- TODO anpassen
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint("CENTER",x,y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	return (fontString)
end

--[[
Function Name: caric:CreateEditBox
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Das Frame in dem der Button angezeigt werden soll
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
					  x - Horizontale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Buttons. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Buttons.
				 height - H�he des Buttons.
Return: Referenz der Editbox.
Description: Bei dieser Funtion handelt es sich um eine Utility-Funktion. Diese Funktion wurde f�r Testzwecke entworfen.
			 Mithilfe dieser Funktion kann eine Editbox mit nur einem Funktionsaufruf erstellt und positioniert werden.
]]	
function caric:CreateEditBox(parentFrame, name, x,y, width, height)
	local editBox = CreateFrame("EditBox", name, parentFrame, "InputBoxTemplate")
	editBox:SetPoint("CENTER",x,y)
	editBox:SetWidth(width)
	editBox:SetHeight(height)
	editBox:SetAutoFocus(false)
	editBox:Show()
	return (editBox)
end

SA_WA = {}

--[[
Function Name: SA_WA:addAssign
Author: Veith, Marvin Justin (10043555)
Parameters:        spellid - Die SpellID ist ein von Blizzard eindeutiger Wert, der verwendet wird um verschiedene Zauber 
							 zu identifizieren. Die SpellID wird sp�ter verwendet um dem Spieler den zu verwendenen 
							 Zauber darzustellen.
			         timer - Bei timerbasierten Assignments wird ein fester Zeitpunkt in Sekunden �bergeben. Der Zeitpunkt
							 statisch und meistens eher ungenau.
			assignmentName - Gibt dem Assignment einen eindeutigen Namen. Ein vorhandenes Assignment mit dem selben Namen
							 wird �berschrieben.
			   encounterid - Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bek�mpfenden Boss zu
							 identifizieren. Somit werden im Bosskampf nur die Assignments geladen, die f�r den jeweiligen
							 Boss erstellt wurden.
Description: Diese Funktion  erstellt ein Assignment. Das Assignment wird in eine Saved Variable gespeichert, somit bleibt 
			 es auch nach Neustart gespeichert. Jedes Assignment wird eindeutig �ber die Kombination aus EncounterID und
			 assignmentName gespeichert. Die EncounterID bestimmt hierbei den zu bek�mpfenden Boss. Es k�nnen also mehrere
			 Assignments erstellt werden und sp�ter zu den Bossen geladen.
]]	

function SA_WA:addAssign(spellid, timer , assignmentName, encounterid)  -- TODO Ability basierte Assignments hinzuf�gen
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

--[[
Function Name: SA_WA:addAssign
Author: Veith, Marvin Justin (10043555)
Parameters:  spellid - Die SpellID ist ein von Blizzard eindeutiger Wert, der verwendet wird um verschiedene Zauber 
   					   zu identifizieren. Die SpellID wird sp�ter verwendet um dem Spieler den zu verwendenen 
					   Zauber darzustellen.
Return: Zeitpunkt des zun�chst verwendenen Zaubers.
Description: Es besteht die M�glichkeit, dass in einem Kampf ein Zauber �fter zugeteilt worden ist. Es ist nicht m�glich
			 in der Weakaura mehrere Zeiten darzustellen. Deswegen wird diese Funktion verwendet, um immer nur den als n�chstes
			 eintretenden Zeitpunkt zu bestimmen.
]]	
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


--[[
Function Name: SA_OnEvent
Author: Veith, Marvin Justin (10043555)
Parameters:  frame - Wird nicht verwendet. Der Frame wird allerdings als Parameter bei einem Eventstart �bergeben.
			 event - Bestimmt im Stringformat welches Event ausgel�st wurde.
			 encounterID - Eindeutige Zuweisung des grade bek�mpften Bosses.
Description: Es handelt sich hierbei um einen Eventhandler. Der Eventhandler "SA_OnEvent" wird bei jedem Event von 
			 Spiel automatisch aufgerufen.
			 Verwendet werden hierbei:
			 
			 ENCOUNTER_START: Initialisiert alle f�r den Kampf wichtigen Daten. Der SA_WEAKAURA.combat Flag wird auf 
							  true gesetzt, um den Status des aktuellen Bosskampfes zu beschreiben. 
							  Es werden alle Zeitpunkte gesetzt, somit kann man die Kampfl�nge bestimmen.
							  Es wird der Startpunkt der Abilities und die Startphase gesetzt.
			
			ENCOUNTER_END:	 Setzt den SA_WEAKAURA.combat Flag auf false. Damit wird bestimmt, dass sich der Spieler
							 nicht mehr im Kampf befindet. 
							 Wenn der Boss erfolgreich besiegt worden ist, werden alle Assignments gel�scht. Damit 
							 die Assignments nicht erneut mit einer anderen Gruppe geladen werden.
]]	
function SA_OnEvent(frame, event, encounterID, ...)
	if event == "ENCOUNTER_START" then
		SA_WEAKAURA.start = GetTime()
		SA_WEAKAURA.combat = true
		SA_WEAKAURA.encounterID = encounterID	
		local eID = encounterID .. ""
		local difficulty = getDifficulty()
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
	if (endStatus == 1) then -- L�scht Assignment nach Bosskampf
		eID = SA_WEAKAURA.encounterID .. ""
		SA_WEAKAURA[eID] = nil
	end
   end 
end

--[[
Function Name: SA_Update
Author: Veith, Marvin Justin (10043555)
Description: Diese Funktion wird jeden Frame aufgerufen. Falls der Spieler sich im Kampfbefindet
			 wird die Kampfdauer neu berechnet und die Auswertung an verschiedene Handler delegiert.
]]
function SA_Update()
	if SA_WEAKAURA.combat then		
		SA_WEAKAURA.duration = GetTime() - SA_WEAKAURA.start
		updateHP()
		updateEnergy()
		phaseHandler()
		abilityHandler()
	end
end


--[[
Function Name: updateHP
Author: Veith, Marvin Justin (10043555)
Description: Dieser Handler aktualisiert jeden Frame die Lebenspunkte der Bosse in Prozent.
			 Die Lebenspunkte werden in SA_WEAKAURA zwischengespeichert.
			 Es ist wichtig die Prozentzahl der Lebenspunkte zu messen, da dies ein Indikator
			 f�r das wechseln von Phasen ist.
			 
			 Es wird mit Prozentwerten anstatt festen Zahlen gearbeitet, da die Lebenspunkte
			 von Blizzard ver�ndert werden k�nnen. Au�erdem ist sie im "normal" und "heroic" 
			 Schwierigkeitsgrad abh�ngig von der Gruppengr��e. 
			 Die Prozentwerte bleiben allerdings immer gleich.
]]
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

--[[
Function Name: updateEnergy
Author: Veith, Marvin Justin (10043555)
Description: Dieser Handler aktualisiert jeden Frame die Energie der Bosse in Prozent.
			 Die Energie wird in SA_WEAKAURA zwischengespeichert.
			 Es ist wichtig die Prozentzahl der Energie zu messen, da dies ein Indikator
			 f�r das wechseln von Phasen ist.
]]
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

-- ??? NIL ???
local frame = CreateFrame("Frame")
-- Registriert alle Events beim Server
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")
-- 
frame:SetScript("OnEvent", SA_OnEvent)
frame:SetScript("OnUpdate", SA_Update)


-- Regestriert AddonChat und Events beim Server
local framus = CreateFrame("Frame")
local SA_prefix = "<SMART_ASSIGN>"
framus:RegisterEvent("CHAT_MSG_ADDON");
RegisterAddonMessagePrefix("<SMART_ASSIGN>"); --TODO auf SA_prefix �ndern.


--[[
Function Name: caricWrite
Author: Veith, Marvin Justin (10043555)
Parameters:   functionname - Gibt an welche Funktion aufgerufen werden soll.
			    playerName - Gibt den Spieler an, der angesprochen werden soll.
			assignmentName - Gibt den Assignmentname an. Dieser wird sp�ter zum anlegen eines Assignments als
							 Key verwendet.
				   spellID - Gibt die SpellID an. Anhand der SpellID wird dem Spieler der zugeteilte Zauber 
							 angezeigt. Die SpellID identifiziert jeden Zauber eindeutig.
					 timer - Falls es sich um ein timerbasiertes Assignment handelt, wird die Zeit in Sekunden
							 angegeben, in das Assignment ausgel�st wird.
			   encounterID - Gibt den Boss anhand seiner eindeutigen Nummer an. Die EncounterID dient als 
							 Schl�ssel f�r den Phasehandler, den Abilityhandler und dem Assignmenthanddler.
Description: Diese Funktion sendet �ber den Addonchatchannel eine Nachricht an alle Gruppen- / Raidmitglieder.
			 Es k�nnen alle Parameter und die auf zu rufenden Funktionen angegeben werden.
			 Mit dieser Funktionalit�t kann der Raidleiter nach dem erstellen der Assignments, diese an alle Spieler senden.
			 Jedes Addon muss sein Prefix registrieren. Dadurch k�nnen alle Nachrichten gefiltert werden.
			 Es k�nnen sogar Phasen und Abilities �ber diese Funktion gesendet werden. Dadurch erhalten die Raidmitglieder
			 alle passenden Informationen.
]]

function caricWrite(functionname, playerName, assignmentName, spellID, timer, encounterID)  -- TODO Name �ndern und weiter ausbauen
	local msg = "";
	msg = msg .. "FUNCTIONNAME~" .. functionname .. "�"
	msg = msg .. "PLAYERNAME~" .. playerName .. "�"
	msg = msg .. "ASSIGNMENTNAME~" .. assignmentName .. "�"
	msg = msg .. "SPELLID~" .. spellID .. "�"
	msg = msg .. "TIMER~" .. timer .. "�"
	msg = msg .. "ENCOUNTERID~" .. encounterID
	if ( IsInRaid() ) then
		SendAddonMessage(SA_prefix,msg,"RAID");
	elseif ( IsInGroup() ) then
		SendAddonMessage(SA_prefix,msg,"PARTY");
	end	
end

--[[
Function Name: caricWrite
Author: Veith, Marvin Justin (10043555)
Parameters: prefix - Identifiziert das Addon. Jedes Addon muss sein Prefix beim Server registrieren.
			   msg - Zusammenkonkanketinierter String, der alle Parameter enth�lt. Der Text wird wieder
					 aufgesplittet.
		   channel - Gibt den Channel an. Kann ignoriert werden.
			sender - Gibt den Nachrichtensender an. Wird nicht verwendet.
Description: Der Chathandler liest alle Nachrichten mit, die im Addonchatchannel gesendet werden.
			 Es werden zuerst alle Nachrichten von diesem Projekt gefiltert. Im n�chsten Schritt
			 wird gepr�ft f�r welchen Spieler die Nachricht adressiert wurde.
			 Abh�ngig von der �bergebenen Funktion und Parameter werden diese weiter delegiert.
]]
function print_msg(...) -- TODO umbenennen
	
	_,_,prefix, msg, channel, sender = ...;
	
	if(prefix == "<SMART_ASSIGN>") then 
		local argList = mysplit(msg, "�")
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
			print "deine mudda wird erstellt"
			SA_WA:addAssign(spellID, timer , arguments.ASSIGNMENTNAME, arguments.ENCOUNTERID)
		end
	end		
end

framus:SetScript("OnEvent", print_msg);
--[[
Function Name: mysplit
Author: Veith, Marvin Justin (10043555)
Parameters: inputstr - Hierbei handelt es sich um den zu splittenden String
			sep - Seperator. Der Seperator bestimmt das Zeichen, bei welchem der String getrennt werden soll.
				  WICHTIG !!! Falls mehrere Zeichen als Seperator verwendet werden, wird f�r jedes
							  Zeichen einzeln gesplittet !!! 
Return: Tabelle mit allen Teilstrings.
Description: Die Funktion "mysplit" wurde haupts�chlich f�r das Parsen der gesendeten Nachrichten verwendet.
			 Der �bergebene String wird in mehrere Strings abh�ngig von dem Seperator getrennt und in eine Tabelle 
			 gespeichert.
]]
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

--[[
Function Name: createPhase
Author: Veith, Marvin Justin (10043555)
Parameters:   encounterID - Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bek�mpfenden Boss zu
							identifizieren. Die EncounterID ist eines von drei Keys um die Phase eindeutig zu identifizieren.
			    phaseName - Der Phasenname beschreibt neben der EncounterID und dem Schwierigkeitsgrad eindeutig.
							Der Phasenname ist eines von drei Keys um die Phase eindeutig zu identifizieren.
			previousPhase - Gibt die vorherige Phase an. Wenn keine Phase angegeben wird, ist diese Phase die erste Phase.
			      trigger - Schreibt die Bedinung f�r den Wechsel in die eigene Phase in die vorherige Phase.
			   triggerTyp - Bestimmt ob die Phase abh�ngig von Leben, Energie, Zeit oder einem Text gewechselt werden soll. 
							Der genaue Wert hierf�r steht in "trigger".
			   mythicFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Mythic" erstellt.
			   heroicFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Heroic" erstellt.
			   normalFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Normal" erstellt.
							Es muss mindestens einer der Flags gesetzt sein.
Description: Die Funktion legt eine Phase abh�ngig der encounterID, den Phasennamen und dem Schwierigkeitsgrad an.
			 F�r den Schwierigkeitsgrad gibt es drei Flags, wovon mindestens ein Flag gesetzt sein muss.
			 F�r jeden angegebenen Schwierigkeitsgrad wird die selbe Phase erstellt. 
			 Es wird die aktuelle und die erste Phase fest gespeichert. Die Phasen sind aneinander gekettet. Hierbei
			 muss immer das vorherige Element und die Bedinung f�r den Phasenwechsel angegeben werden. 
			 Es handelt sich also um eine Art von einer einfach verketteten Liste, mit sich selbst definierten Ausl�ser
			 f�r den Wechsel der Phasen.
]]
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

--[[
Function Name: createAbility
Author: Veith, Marvin Justin (10043555)
Parameters:   			   encounterID - Bei der EncounterID handelt es sich um einen eindeutigen Wert um den zu bek�mpfenden Boss zu
										 identifizieren. Die EncounterID ist eines von drei Keys um die Phase eindeutig zu identifizieren.
						   abilityName - Der Abilityname beschreibt neben der EncounterID und dem Schwierigkeitsgrad eindeutig.
										 Der Abilityname ist eines von drei Keys um die Phase eindeutig zu identifizieren.
							  cooldown - Es kann ein bis mehrere Timer f�r eine Ability �bergeben werden. Bei der Verwendung
										 von mehreren Timern, m�ssen die Timer durch Semikolons getrennt werden. Die Zeit wird in Sekunden
										 angegeben.
						 boundedPhases - Es k�nnen keine bis mehrere Phasen f�r eine Ability �bergeben werden. Bei der Verwendung
										 von mehreren Phasen, m�ssen die Phasen durch Semikolons getrennt werden.
					   loopingListFlag - Falls mehrere Timer f�r eine Ability verwendet werden, muss eine Methode f�r das Iterieren 
										 ausgew�hlt werden. Es gibt hierbei folgende M�glichkeiten:
										 true  = Die Liste wird beim ersten Element wiederholt, falls sie durchlaufen ist.
										 false = Wenn die Liste durchlaufen ist, wird nur noch die letzte Zeit ausgew�hlt.
							mythicFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Mythic" erstellt.
							heroicFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Heroic" erstellt.
							normalFlag - Falls gesetzt wird die Phase f�r den Schwierigkeitsgrad "Normal" erstellt.
										 Es muss mindestens einer der Flags gesetzt sein.
			resetTimerOnPhaseStartFlag - Wenn dieses Flag gesetzt ist, wird der Timer abh�ngig vom Phasenwechsel neu gestartet. 
										 Dies ist bei manchen Bossen notwendig, da es sonst zu verschobenen Timern und somit zu unm�glich
										 spielbaren Kombinationen an F�higkeiten kommen kann.
Description: Die Funktion legt eine Ability abh�ngig der encounterID, den Abilitynamen und dem Schwierigkeitsgrad an.
			 F�r den Schwierigkeitsgrad gibt es drei Flags, wovon mindestens ein Flag gesetzt sein muss.
			 F�r jeden angegebenen Schwierigkeitsgrad wird die selbe Ability erstellt. 
			 In der Ability wird der Cooldown bzw. die Cooldownliste mit der zugeh�rigen Iterierungsmethode gespeichert. 
			 Au�erdem wird gespeichert ob der Timer fest vorkommt oder sich mit einem Phasenwechsel verschiebt. 
			 Manche F�higkeiten treten im gesamten Kampf auf, beziehungsweise nur in bestimmten Phasen. Also wird eine Zuordnung von
			 Ability zu Phase ebenfalls erstellt.
]]
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

--[[
Function Name: abilityHandler
Author: Veith, Marvin Justin (10043555)
Description: Der Abilityhandler �berpr�ft zuerst ob es einen Eintrag gibt. Hierbei wird die EncounterID, welche den 
			 aktuell bek�mpften Boss eindeutig identifiziert und der Schwierigkeitsgrad �berpr�ft. 
			 Falls kein Eintrag vorhanden ist, wird der Handler verlassen.
			 
			 Im zweiten Schritt wird die Iterierungsmethode bestimmt und ein Counter angelegt. Der Counter z�hlt mit
			 zum wie vielten mal eine Ability gewirkt wird. Der Counter ist notwendig, weil zum Beispiel bei jeder 
			 Ability ein Spieler sein Cooldown benutzen soll, aber nicht alle gleichzeitig. Das mitz�hlen und merken
			 ist nicht Praxis tauglich, also wird der Counter gespeichert von diesem Projekt gespeichert.
			 
			 Im dritten Schritt wird �berpr�ft, ob die Ability ausgel�st werden kann. Abilities die nicht phasengebunden sind,
			 k�nnen immer ausgel�st werden. Bei phasengebunden Abilities wird �berpr�ft, ob die Ability an die aktuelle Phase
			 gebunden ist.
			 
			 Zum Schluss werden die Zeitstempel f�r das Ausl�sen der Ability gesetzt. Au�erdem wird �berpr�ft, ob bereits einer 
			 der Zeitstempel �berschritten wurde. Falls ja wird ein neuer Zeitstempel erzeugt und der Counter um eins erh�ht.
]]
function abilityHandler()
	-- �berpr�ft ob Eintrag vorhanden ist.
	local eID = SA_WEAKAURA.encounterID .. ""
	local difficulty = getDifficulty()
	if(not SA_AbilityList[eID]) then
		return false
	end
	if(not SA_AbilityList[eID][difficulty]) then
		return false
	end
	
	local totalDuruation = SA_WEAKAURA.duration -- Gesamtlaufzeit f�r nicht an Phasen gebundene Abilities
	
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
		
		-- Bestimmt ob die Ability ausgel�st werden kann, abh�ngig ob die dazugeh�rige Phase aktiv ist bzw. ob 
		-- Ability phasenunabh�ngig ist.
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
			--Erh�ht Counter und setzt neuen Timer fest, falls der aktuelle Zeitstempel �berschritten ist.
			if ( SA_AbilityList[eID][difficulty][k].start + SA_AbilityList[eID][difficulty][k].cooldown[listIndex] < GetTime() ) then
				SA_AbilityList[eID][difficulty][k].counter = SA_AbilityList[eID][difficulty][k].counter + 1
				SA_AbilityList[eID][difficulty][k].nextStart = true
			end			
		end
	end	
end


--[[
Function Name: phaseHandler
Author: Veith, Marvin Justin (10043555)
Description: Der Phasehandler �berpr�ft zuerst ob es einen Eintrag gibt. Hierbei wird die EncounterID, welche den 
			 aktuell bek�mpften Boss eindeutig identifiziert und der Schwierigkeitsgrad �berpr�ft. 
			 Falls kein Eintrag vorhanden ist, wird der Handler verlassen.
			 
			 Im zweiten Schritt wird die Laufzeit der Phase berechnet. Nebenbei wird der Trigger und der Triggertyp
			 der aktuellen Phase bestimmt.
			 
			 Im dritten Schritt wird abh�ngig von dem Triggertyp und dem Trigger gepr�ft ob die Kriterien f�r das wechseln
			 in die neue Phase erf�llt sind.
			 
			 Der Aufgabe des Handlers ist also die Berechnung der Dauer der aktuellen Phase, welche von den Abilities 
			 verwendet wird. Au�erdem �berpr�ft der Phasehandler in jedem Frame, ob die Phase gewechselt werden muss.
]]
function phaseHandler()

	-- �berpr�ft ob Eintrag vorhanden ist.
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

--[[
Function Name: getDifficulty
Author: Veith, Marvin Justin (10043555)
Return: Gibt den Schwierigkeitsgrad an, in dem sich der Spieler derzeit befindet.
Description: Es gibt bereits von Blizzard eine Funktion um den Schwierigkeitsgrad zu bestimmen, allerdings wird hierbei in 25
			 verschiedene Schwierigkeitsgrade unterschieden. Die Vielfalt an Schwierigkeitsgraden ist historisch bedingt.
			 Die Funktion getDifficulty() fast die verschiedenen Schwierigkeitsgrade zusammen. Es bleiben nur noch die drei
			 g�ngigen Schwierigkeitsgrade "Normal", "Heroic" und "Mythic" �ber.
]]
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
Function Name: getDifficulty
Author: Veith, Marvin Justin (10043555)
Description: Die Funktion in ihrer Grundform zuf�llig entdeckt. Die Funktion wurde im nachhinein stark �berarbeitet.
			 Die Funktion besteht aus drei ineinander verschachtelten Schleifen. 
			 Die �u�ere Schleife iteriert �ber alle m�glichen Expansions und legt diese in der Saved Variable SA_BossList an.
			 Die mittlere Schleife iteriert �ber alle Raids, abh�ngig von der Expansion. Dieser Zusammenhang wird 
			 in der Saved Variable SA_BossList gespeichert.
			 Die innere Schleife iteriert �ber alle Bosse, abh�ngig von dem Raid. Dieser Zusammenhang wird in der Saved
			 Variable SA_BossList gespeichert. Es wird hierbei die EncounterID gespeichert. 
			 Es ist also m�glich eindeutig den Boss �ber die drei Keys "Expansion", "Raid" und "Boss" zu finden.
			 F�r die interne Verwendung wird die EncounterID verwendet. 
			 Hier f�r gibt es zwei Gr�nde. Erstens: Die EncounterID ist viel k�rzer als alle drei Keys zu speichern.
			 Zweitens: Das Event liefert nur die EncounterID als Parameter. Somit kann funktioniert das Addon unabh�nhig
			 der Sprache des Spiels.
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

--- Funktion zum Erstellen der Lokalisierungsvariablen
-- @author Maik Doemmecke
function printBosses()
   local t = 1
   SA_local = ""
  local ctr = 1
	 for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      print(tiername)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            
	    SA_local = SA_local .. "\n" .. SA_bossnameList[ctr] .. "=" .. "\"" .. bossname .. "\""
            j = j+1
	ctr = ctr + 1
         end
      end
   end
end

function printRaids()
   local t = 1
   SA_local = ""
  local ctr = 1
	 for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
	 local bossString = SA_name
         EJ_SelectInstance(SA_instanceId)
         local zwischen, _ = string.gsub(SA_name, " ", "" )
         SA_name,_ = string.gsub(zwischen, "'","")
         zwischen = string.gsub(SA_name, "-","")
         SA_name = string.gsub(zwischen, ",","")
	SA_local = SA_local .. "\n" .. SA_raidNames[ctr] .. "=" .. "\"" .. bossString .. "\"" 

	 --table.insert(SA_local, SA_name .. "_string")
	 ctr = ctr + 1
         i = i+1
         
       end
   end
	
end



function createLocalizationNameList()
  local t = 1
   SA_local = {}
  for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      --print(tiername)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            table.insert(SA_local, (newName.."_"..name))
            j = j+1
         end
      end
   end
end


function creatBossList()
   local t = 1
   SA_local = ""
  local ctr = 1
	 for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      print(tiername)
      SA_local = SA_local .. "[" .. tiername .. "] = {"  
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         SA_local = SA_local .. "[" .. SA_name
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            
	    SA_local = SA_local .. "\n" .. SA_bossnameList[ctr] .. "=" .. "\"" .. bossname .. "\""
            j = j+1
	ctr = ctr + 1
         end
      end
   end
end


