--- DropDowns.lua
-- @author  Veith, Marvin Justin (10043555)
--
-- In dieser Datei werden die GUI Elemente "Dropdown" erstellt. Hierbei handelt es sich um ein Element, welches eine Liste
			 -- an Werten uebergeben bekommt. Hierbei wird als Text der aktuelle Wert angezeigt. Mit einem Linksklick, wird die komplette Liste 
			 -- geladen. Es kann aus der Liste ein Wert ausgewaehlt werden. 
			 
			 -- Die Dropdowns "ExpansionDropDown", "RaidDropDown" und "BossDropDown" werden verwendet um die jeweiligen Keys fuer die 
			 -- dahinterliegenden Tables auszuwaehlen. Die Kombination der drei genannten Dropdowns ist zwingend notwendig, um eine eindeutige
			 -- Identifikation des Bosses zu ermoeglichen. Es gibt Bosse, die bisher oefter verwendet wurden. Diese sind zwar per EncounterID eindeutig
			 -- zuweisbar, allerdings ist eine Liste mit hunderten EncounterIDs nicht tauglich fuer den Benutzer.
			 -- Mit der Aufteilung in drei Dropdowns kann der Benutzer schnell und intuitiv seinen gewuenschten Boss finden und auswaehlen.
			 -- Es gibt hierbei nicht mehr als 14 Eintraege pro Dropdown.
			 
			 -- Die Dropdowns "AbilityDropDown" und "PhaseDropDown" werden fuer das Hinzufuegen, Editieren und Loeschen neuer Phasen und Abilities verwendet.
			 -- Es besteht in beiden Faellen eine Abhaengigkeit zu den, im vorherigen Abschnitt genannten, Dropdowns. Die Phasen und Abilities sind abhaengig
			 -- von der EncounterID, die beim Auswaehlen eines Bosses ermittelt wurde.
			 -- Das GUI Element "AbilityDropDown" wird fuer die Zuteilung von Spielern zu der jeweiligen Ability verwendet.
			 -- Beide Dropdowns werden ebenfalls verwendet um im Hintergrund Phasen und Abilities an zu legen, welche von ihren zugehoerigen Handlern 
			 -- verwaltet werden. 
			 
			 -- Die Dropdowns "PlayerDropDown" und "CooldownDropDown" werden im Assignment beliebig oft generiert und sind abhaengig von einander.
			 -- Die Relation ist 1:0-n. Das GUI Element "PlayerDropDown" zeigt alle in der Gruppe befindenen Spieler an und ist somit unabhaengig.
			 -- Im Gegensatz dazu ist "CooldownDropDown" abhaengig von "PlayerDropDown", da hier nur die Cooldowns angezeigt werden duerfen, die 
			 -- der Spieler benutzen kann.
			 
			 -- Als letztes Element gibt es ein "BlankDropDown". Hierbei gibt es keine Besonderheit. Dieses Dropdown kann nur die in der 
			 -- Table uebergebenen Werte darstellen.
			 
			 -- Die Erstellung eines Dropdowns ist in jeder Funktion aehnlich. Erstellt wird der Dropdown mit der von Blizzard vorgegebenen Funktion
			 -- CreateFrame(...). Im Anschluss wird der Dropdown positioniert, die Groesse und der defaultText gesetzt. 
			 -- In der Init-Funktion bzw. ebenfalls in der onClick-Funktion wird die Funktionalitaet des Dropdowns definiert. Hierbei kann die Praesentation
			 -- der Daten und eine Anbindung zur Programmlogik definiert werden.



---  createExpansionDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "ExpansionDropDown" angezeigt werden soll.
-- @param x  Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y  Vertikale Koordinate zum ausrichten des Dropdowns (Abhaengig von dem Mittelpunkt des parentFrames). Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "ExpansionDropDown" ist eines von drei zusammenarbeitenen
			 -- Dropdowns. Es wird verwendet um eine Expansion auszuwaehlen. Die Expansion ist der erste Key um einen Boss eindeutig und 
			 -- benutzerfreundlich auswaehlen zu koennen. Bei n Elementen, wobei n die Anzahl der Expansions beschreibt wird die 
			 -- Auswahlmoeglichkeit der Bosse auf ungefaehr ( 1/n ) reduziert. >>> Es handelt sich hierbei nur um eine ungefaehre Aussage <<< 
			 
			 -- Durch die Verwendung  der SavedVariable SA_LastSelected.expansion, wird die zuletzt verwendete Expansion, beim neuladen
			 -- im voraus ausgewaehlt.
function createExpansionDropDown (parentFrame,x, y, width, name)
	
	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()
	framus.raid = nil
	framus.boss = nil

	function initExpansionDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		for k,v in pairs(SA_BossList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = function (self) -----------------------------------------------------  FUNCTION --------
							UIDropDownMenu_SetSelectedID(framus, self:GetID())
							SA_LastSelected.expansion = UIDropDownMenu_GetText(framus)
							SA_LastSelected.raid = ""
							SA_LastSelected.boss = ""
							
							if ( framus.raid ) then
								UIDropDownMenu_SetText(framus.raid, "Raid")
							end
							if ( framus.boss ) then
								UIDropDownMenu_SetText(framus.boss, "Boss")
							end							
						end  ----------------------------------------------------------------  FUNCTION --------
						
			UIDropDownMenu_AddButton(info, level)
			
			-- Vorauswahl, des letzten eintrags
			i = i+1
			if(k == SA_LastSelected.expansion) then				
				j = i
			end
		end	
		if (j ~= 0) then
			UIDropDownMenu_SetSelectedID(framus, j)
		end
	end
	
	UIDropDownMenu_Initialize(framus, initExpansionDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	if (SA_LastSelected.expansion == "") then
		UIDropDownMenu_SetText(framus, "Expansion")
	else
		UIDropDownMenu_SetText(framus, SA_LastSelected.expansion)
	end	
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus)
end


--- createRaidDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame - Hierbei handelt es sich um das Frame, in welches das "RaidDropDown" angezeigt werden soll.
-- @param x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y - Vertikale Koordinate zum ausrichten des Dropdowns (Abhaengig von dem Mittelpunkt des parentFrames). Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width - Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "RaidDropDown" ist eines von drei zusammenarbeitenen
			 -- Dropdowns. Es wird verwendet um einen Raid auszuwaehlen. Der Raid ist der zweite Key um einen Boss eindeutig und 
			 -- benutzerfreundlich auswaehlen zu koennen. Bei [n] und [m] Elementen, wobei [n] die Anzahl der Expansions und [m] die Anzahl der Raids 
			 -- beschreibt wird die Auswahlmoeglichkeit der Bosse auf ungefaehr ( (1/n)/m ) reduziert. 
			 -- >>> Es handelt sich hierbei nur um eine ungefaehre Aussage <<< 
			 
			 -- Durch die Verwendung  der SavedVariable SA_LastSelected.raid, wird der zuletzt verwendete Raid, beim neuladen
			 -- im voraus ausgewaehlt.
function createRaidDropDown (parentFrame, x, y, width, name)

	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")
	
	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()
	
	framus.boss = nil

	function initRaidDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			for k,v in pairs(SA_BossList[SA_LastSelected.expansion]) do				
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = function (self) ----------------------------------------------- FUNCTION ------
								UIDropDownMenu_SetSelectedID(framus, self:GetID())
		
								SA_LastSelected.raid = UIDropDownMenu_GetText(framus)
								SA_LastSelected.boss = ""
		
								if ( framus.boss ) then
									UIDropDownMenu_SetText(framus.boss, "Boss")
								end
							end ----------------------------------------------------------- FUNCTION -------
				UIDropDownMenu_AddButton(info, level)
				
				-- Vorauswahl, des letzten eintrags
				i = i+1
				if(k == SA_LastSelected.raid) then				
					j = i
				end
			end	
			if(j ~= 0) then
				UIDropDownMenu_SetSelectedID(framus, j)
			end
		end
	end

	UIDropDownMenu_Initialize(framus, initRaidDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	if (SA_LastSelected.raid == "") then
		UIDropDownMenu_SetText(framus, "Raid")
	else
		UIDropDownMenu_SetText(framus, SA_LastSelected.raid)
	end
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus)
end

--- createBossDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "BossDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames) Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "BossDropDown" ist eines von drei zusammenarbeitenen
			 -- Dropdowns. Es wird verwendet um einen Raid auszuwaehlen. Der Raid ist der dritte und somit letzte Key um einen Boss eindeutig und 
			 -- benutzerfreundlich auswaehlen zu koennen. Mit der Vorauswahl der Expansion und dem Raid kann nun eindeutig der gewuenschte Boss ausgewaehlt
			 -- werden. Hierbei handelt es sich um eine Liste von 3-14 Bossen (Das ueberschreiten der Grenzen ist relativ unwahrscheinlich).
			 
			 -- Durch die Verwendung  der SavedVariable SA_LastSelected.boss, wird der zuletzt verwendete Boss, beim neuladen
			 -- im voraus ausgewaehlt.
--
function createBossDropDown (parentFrame, x, y, width, name)
	
	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()
	framus.assignmentFrame = nil

	function OnClickBossDropDown(self)
		UIDropDownMenu_SetSelectedID(framus, self:GetID())
		SA_LastSelected.boss = UIDropDownMenu_GetText(framus)
	end

	function initBossDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] ~= nil) then
				for k,v in pairs(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid]) do
					
					info = UIDropDownMenu_CreateInfo()
					info.text = k
					info.value = v
					info.func = function (self)

									UIDropDownMenu_SetSelectedID(framus, self:GetID())
									SA_LastSelected.boss = UIDropDownMenu_GetText(framus)
									-- FUeR MAIK
									if framus.assignmentFrame then
										framus.assignmentFrame:SetFrameData()		
									-- FUeR MAIK
									end
							end
					UIDropDownMenu_AddButton(info, level)
					
					-- Vorauswahl, des letzten eintrags
					i = i+1
					if(k == SA_LastSelected.boss) then				
						j = i
					end
				end
				if(j ~= 0) then
					UIDropDownMenu_SetSelectedID(framus, j)
				end
			end	
		end
	end
	UIDropDownMenu_Initialize(framus, initBossDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	if (SA_LastSelected.boss == "") then
		UIDropDownMenu_SetText(framus, "Boss")
	else
		UIDropDownMenu_SetText(framus, SA_LastSelected.boss)
	end
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus)
end

--- createPhaseDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "PhaseDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "PhaseDropDown" wird nur zum Hinzufuegen, Editieren und Loeschen 
			 -- von Phasen verwendet.
			 -- Der Grund fuer die Verwendung eines Dropdowns ist, dass zum Editieren und Loeschen nur die existierenden Phasen zu dem jeweiligen
			 -- Boss angezeigt werden. Der Benutzer behaelt den Ueberblick ueber die Phasen und sieht direkt, welche Phase er bearbeitet.
function createPhaseDropDown (parentFrame, x, y, width, name)
	
	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()

	function initPhaseDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] ~= nil) then
				if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss] ~= nil) then
					local eID = SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID .. ""
				end
			end
		end
		local list = {}
		if (eID) then
			if ( SA_PhaseList[eID] ) then
				for dif, num in pairs( SA_PhaseList[eID] ) do
					for name, v in pairs ( SA_PhaseList[eID][dif] ) do
						local checkNewElement = true
						for checkNum, checkName in ipairs ( list ) do
							if( name == checkName ) then
								checkNewElement = false
							end
						end
						if (checkNewElement == true ) then
							table.insert(list, name )
						end
					end
				end
			end
		end
		
		for k,v in ipairs(list) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = function (self)
							UIDropDownMenu_SetSelectedID(framus, self:GetID())
							SA_LastSelected.phase = UIDropDownMenu_GetText(framus)
						end
			UIDropDownMenu_AddButton(info, level)
		
			-- Vorauswahl, des letzten eintrags
			i = i+1
			if(k == SA_LastSelected.phase) then				
				j = i
			end
		end

		if(j ~= 0) then
			UIDropDownMenu_SetSelectedID(framus, j)
		end
	end
	
	
	UIDropDownMenu_Initialize(framus, initPhaseDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	if (SA_LastSelected.phase == "") then
		UIDropDownMenu_SetText(framus, "Phase")
	else
		UIDropDownMenu_SetText(framus, SA_LastSelected.phase)
	end
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus)
end

--- createAbillityDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "AbillityDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames) Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "AbillityDropDown" wird nur zum Hinzufuegen, Editieren und Loeschen 
			 -- von Abilities verwendet. Ausserdem wird es verwendet um eine Zuordnung von Spieler (inklusiv seiner Aufgabe) Abillity zu schaffen.
			 
			 -- Der Grund fuer die Verwendung eines Dropdowns ist, dass zum Editieren und Loeschen nur die existierenden Abilities zu dem jeweiligen
			 -- Boss angezeigt werden. Der Benutzer behaelt den Ueberblick ueber die Phasen und sieht direkt, welche Phase er bearbeitet.
			 -- Bei der Zuordnung der Spieler, kann die Zeit variieren. Die Abilities sind relativ zu den Phasenuebergaengen.
function createAbillityDropDown (parentFrame, x, y, width, name)

	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")
	
	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)	
	framus:Show()

	function initAbillityDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		local eID = nil
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] ~= nil) then
				if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss] ~= nil) then
					eID = SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID .. ""
				end
			end
		end
		local list = {"Timer"}
		if (eID) then
			if ( SA_AbilityList[eID] ) then
				for dif, num in pairs( SA_AbilityList[eID] ) do
					for name, v in pairs ( SA_AbilityList[eID][dif] ) do
						local checkNewElement = true
						for checkNum, checkName in ipairs ( list ) do
							if( name == checkName ) then
								checkNewElement = false
							end
						end
						if (checkNewElement == true ) then
							table.insert(list, name )
						end
					end
				end
			end
		end
		for k,v in ipairs(list) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = function (self)
							UIDropDownMenu_SetSelectedID(framus, self:GetID())
						end
			UIDropDownMenu_AddButton(info, level)
		end		
	end

	UIDropDownMenu_Initialize(framus, initAbillityDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	UIDropDownMenu_SetText(framus, Ability_String)
	if SA_LastSelected.abillity ~= "" then
		UIDropDownMenu_SetText(framus, SA_LastSelected.abillity)
	end
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus) 
	
end


--- createPlayerDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "PlayerDropDown" ist eigenstaendig, wird aber fuer "CooldownDropDown"
			 -- benoetigt. Mit Hilfe dieses Dropdowns kann ein beliebiger Spieler aus der Gruppe bzw. aus dem Raid ausgewaehlt werden. 
			 -- Zu dem jeweiligen Spieler wird die Klasse ermittelt und gespeichert. Da jede Klasse ueber andere Cooldowns verfuegt ist es wichtig
			 -- den passenden Spieler auszuwaehlen. 
			 -- Aus Sicht der Assignments muss der zugeordnete Spieler, eindeutig angesprochen werden. Die Verwendung eines Dropdowns im Vergleich 
			 -- zu beispielsweise Editboxen besteht darin, dass sich der Spieler in der Gruppe befindet und der Benutzer sich nicht vertippen kann.
function createPlayerDropDown (parentFrame, x, y, width, name)
	
	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()	

	function initPlayerDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		SA_Players = SmartAssign:getAllMembers()
		if(SA_Players ~= nil) then
			for k,v in pairs(SA_Players) do
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = function (self)
							UIDropDownMenu_SetSelectedID(framus, self:GetID())	
							end
				UIDropDownMenu_AddButton(info, level)
			end	
		end
	end

	UIDropDownMenu_Initialize(framus, initPlayerDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	UIDropDownMenu_SetText(framus, Player_String)
	UIDropDownMenu_JustifyText(framus, "LEFT")
	return framus
end

--- createCooldownDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames) Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @param ref Die Referenz zu dem "PlayerDropDown". Der "PlayerDropDown" wird verwendet um die Klasse des jeweiligen Spielers zu ermitteln. Abhaengig von der Klasse koennen die Cooldowns geladen werden.
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage In dieser Funktion wird das GUI Element Dropdown erstellt. "CooldownDropDown" ist in seiner Funktion abhaengig von dem "PlayerDropDown",
			 -- genauer gesagt sogar von dem ausgewaehlten Spieler. Zu jedem Spieler wird die Klasse gespeichert. Jede Klasse hat verschiedene Cooldowns.
			 -- Es sollen daher nur die Cooldowns angezeigt werden, die von dem Spieler verwendet werden koennen. 
			
			-- Die Verwendung eines Dropdowns im Gegensatz zu anderen GUI Elementen dominiert aus folgenden Gruenden. Der Raidleiter muss die Cooldowns
			-- aus der Liste erkennen. Er muss nicht eigenstaendig ueberlegen, welcher Cooldown zu welcher Klasse gehoert. Ausserdem ist das auswaehlen 
			-- des Cooldowns sicher vor Tippfehlern. Darueber hinaus werden im Backend die Cooldowns und ihre SpellIDs verwaltet.  Es waere ein zu grosser
			-- Aufwand fuer den Benutzer sich in die Strukturen des Backends einzuarbeiten. 
function createCooldownDropDown (parentFrame, x, y, width,name, ref)

	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")
	framus.ref = ref

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()	

	function initCooldownDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo
		
		local playerName = UIDropDownMenu_GetText(ref)
		if(SA_Players ~= nil) then
			local playerClass = SA_Players[playerName]		
			if(SA_Players[playerName] ~= nil)then
				for k,v in pairs(ClassList:GetClassSpellNames(SA_Players[playerName])) do
					info = UIDropDownMenu_CreateInfo()
					info.text = v
					info.value = v
					info.func = function (self)	UIDropDownMenu_SetSelectedID(framus, self:GetID()) end
					UIDropDownMenu_AddButton(info, level)
				end	
			end
		end
	end
	UIDropDownMenu_Initialize(framus, initCooldownDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	UIDropDownMenu_SetText(framus, "Cooldown")
	UIDropDownMenu_JustifyText(framus, "LEFT")
	return framus
end


--- createBlankDropDown
-- @author  Veith, Marvin Justin (10043555)
-- @param parentFrame Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
-- @param x Horizontale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)
-- @param y Vertikale Koordinate zum ausrichten des Dropdowns. (Abhaengig von dem Mittelpunkt des parentFrames)Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei einer negativen Y-Koordinate nach unten ausgerichtet.
-- @param width Breite des Dropdowns. Es werden noch zusaetzlich 24 Pixel fuer den Button hinzugefuegt.
-- @param name Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt dieglobale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten GUI Elemente auf.
-- @param tablus Die mit Werten gefuellte zu uebergebende Tabelle. Im Dropdown werden alle Elemente angezeigt, welche in der Table vordefiniert sind.
-- @param defaultText Der Standardtext wenn kein Wert ausgewaehlt wurde. Besonders beim Neuerstellen des Dropdowns kann hierbei eine Beschreibung bzw. der Verwendungszweck, des Dropdowns angegeben werden
-- @return	Es wird die Referenz des neu erstellten Dropdowns zurueck gegeben. 
-- @usage Diese Funktion soll es ermoeglichen schnell und einfach neue Dropdowns mit nur einem Funktionsaufruf zu erstellen. 
			 -- Es wird nur die Moeglichkeit geboten, die Werte eine vorgegebende Tabelle anzuzeigen. Die Verwendung von speziellen
			 -- Funktionalitaeten ist nicht moeglich. Hierfuer muss wie bei den anderen Dropdowns ein eigenes Dropdown mitsamt Init-Funktion,
			 -- onClick-Funktion und darin enthaltener Logikanbindung geschrieben werden.
function createBlankDropDown (parentFrame, x, y, width, name, tablus, defaultText)

	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()	

	function initBlankDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo
		for k,v in pairs(tablus) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = function (self)	UIDropDownMenu_SetSelectedID(framus, self:GetID()) end
			UIDropDownMenu_AddButton(info, level)
		end		
	end

	UIDropDownMenu_Initialize(framus, initBlankDropDown)
	UIDropDownMenu_SetWidth(framus, width);
	UIDropDownMenu_SetButtonWidth(framus, width +24)
	UIDropDownMenu_SetText(framus, defaultText)
	UIDropDownMenu_JustifyText(framus, "LEFT")
	return framus
end
