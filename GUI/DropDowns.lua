--[[
File Name:  DropDowns.lua
Author: Veith, Marvin Justin (10043555)
Description: In dieser Datei werden die GUI Elemente "Dropdown" erstellt. Hierbei handelt es sich um ein Element, welches eine Liste
			 an Werten �bergeben bekommt. Hierbei wird als Text der aktuelle Wert angezeigt. Mit einem Linksklick, wird die komplette Liste 
			 geladen. Es kann aus der Liste ein Wert ausgew�hlt werden. 
			 
			 Die Dropdowns "ExpansionDropDown", "RaidDropDown" und "BossDropDown" werden verwendet um die jeweiligen Keys f�r die 
			 dahinterliegenden Tables auszuw�hlen. Die Kombination der drei genannten Dropdowns ist zwingend notwendig, um eine eindeutige
			 Identifikation des Bosses zu erm�glichen. Es gibt Bosse, die bisher �fter verwendet wurden. Diese sind zwar per EncounterID eindeutig
			 zuweisbar, allerdings ist eine Liste mit hunderten EncounterIDs nicht tauglich f�r den Benutzer.
			 Mit der Aufteilung in drei Dropdowns kann der Benutzer schnell und intuitiv seinen gew�nschten Boss finden und ausw�hlen.
			 Es gibt hierbei nicht mehr als 14 Eintr�ge pro Dropdown.
			 
			 Die Dropdowns "AbilityDropDown" und "PhaseDropDown" werden f�r das Hinzuf�gen, Editieren und L�schen neuer Phasen und Abilities verwendet.
			 Es besteht in beiden F�llen eine Abh�ngigkeit zu den, im vorherigen Abschnitt genannten, Dropdowns. Die Phasen und Abilities sind abh�ngig
			 von der EncounterID, die beim Ausw�hlen eines Bosses ermittelt wurde.
			 Das GUI Element "AbilityDropDown" wird f�r die Zuteilung von Spielern zu der jeweiligen Ability verwendet.
			 Beide Dropdowns werden ebenfalls verwendet um im Hintergrund Phasen und Abilities an zu legen, welche von ihren zugeh�rigen Handlern 
			 verwaltet werden. 
			 
			 Die Dropdowns "PlayerDropDown" und "CooldownDropDown" werden im Assignment beliebig oft generiert und sind abh�ngig von einander.
			 Die Relation ist 1:0-n. Das GUI Element "PlayerDropDown" zeigt alle in der Gruppe befindenen Spieler an und ist somit unabh�ngig.
			 Im Gegensatz dazu ist "CooldownDropDown" abh�ngig von "PlayerDropDown", da hier nur die Cooldowns angezeigt werden d�rfen, die 
			 der Spieler benutzen kann.
			 
			 Als letztes Element gibt es ein "BlankDropDown". Hierbei gibt es keine Besonderheit. Dieses Dropdown kann nur die in der 
			 Table �bergebenen Werte darstellen.
			 
			 Die Erstellung eines Dropdowns ist in jeder Funktion �hnlich. Erstellt wird der Dropdown mit der von Blizzard vorgegebenen Funktion
			 CreateFrame(...). Im Anschluss wird der Dropdown positioniert, die Gr��e und der defaultText gesetzt. 
			 In der Init-Funktion bzw. ebenfalls in der onClick-Funktion wird die Funktionalit�t des Dropdowns definiert. Hierbei kann die Pr�sentation
			 der Daten und eine Anbindung zur Programmlogik definiert werden.
]]

--[[
Function Name: createExpansionDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "ExpansionDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "ExpansionDropDown" ist eines von drei zusammenarbeitenen
			 Dropdowns. Es wird verwendet um eine Expansion auszuw�hlen. Die Expansion ist der erste Key um einen Boss eindeutig und 
			 benutzerfreundlich ausw�hlen zu k�nnen. Bei n Elementen, wobei n die Anzahl der Expansions beschreibt wird die 
			 Auswahlm�glichkeit der Bosse auf ungef�hr ( 1/n ) reduziert. >>> Es handelt sich hierbei nur um eine ungef�hre Aussage <<< 
			 
			 Durch die Verwendung  der SavedVariable SA_LastSelected.expansion, wird die zuletzt verwendete Expansion, beim neuladen
			 im voraus ausgew�hlt.
]]
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

--[[
Function Name: createRaidDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "RaidDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "RaidDropDown" ist eines von drei zusammenarbeitenen
			 Dropdowns. Es wird verwendet um einen Raid auszuw�hlen. Der Raid ist der zweite Key um einen Boss eindeutig und 
			 benutzerfreundlich ausw�hlen zu k�nnen. Bei [n] und [m] Elementen, wobei [n] die Anzahl der Expansions und [m] die Anzahl der Raids 
			 beschreibt wird die Auswahlm�glichkeit der Bosse auf ungef�hr ( (1/n)/m ) reduziert. 
			 >>> Es handelt sich hierbei nur um eine ungef�hre Aussage <<< 
			 
			 Durch die Verwendung  der SavedVariable SA_LastSelected.raid, wird der zuletzt verwendete Raid, beim neuladen
			 im voraus ausgew�hlt.
]]
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

--[[
Function Name: createBossDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "BossDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "BossDropDown" ist eines von drei zusammenarbeitenen
			 Dropdowns. Es wird verwendet um einen Raid auszuw�hlen. Der Raid ist der dritte und somit letzte Key um einen Boss eindeutig und 
			 benutzerfreundlich ausw�hlen zu k�nnen. Mit der Vorauswahl der Expansion und dem Raid kann nun eindeutig der gew�nschte Boss ausgew�hlt
			 werden. Hierbei handelt es sich um eine Liste von 3-14 Bossen (Das �berschreiten der Grenzen ist relativ unwahrscheinlich).
			 
			 Durch die Verwendung  der SavedVariable SA_LastSelected.boss, wird der zuletzt verwendete Boss, beim neuladen
			 im voraus ausgew�hlt.
]]
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
									-- F�R MAIK
									if framus.assignmentFrame then
										framus.assignmentFrame:SetFrameData()		
									-- F�R MAIK
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

--[[
Function Name: createPhaseDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "PhaseDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "PhaseDropDown" wird nur zum Hinzuf�gen, Editieren und L�schen 
			 von Phasen verwendet.
			 Der Grund f�r die Verwendung eines Dropdowns ist, dass zum Editieren und L�schen nur die existierenden Phasen zu dem jeweiligen
			 Boss angezeigt werden. Der Benutzer beh�lt den �berblick �ber die Phasen und sieht direkt, welche Phase er bearbeitet.
]]
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

--[[
Function Name: createAbillityDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "AbillityDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "AbillityDropDown" wird nur zum Hinzuf�gen, Editieren und L�schen 
			 von Abilities verwendet. Au�erdem wird es verwendet um eine Zuordnung von Spieler (inklusiv seiner Aufgabe) Abillity zu schaffen.
			 
			 Der Grund f�r die Verwendung eines Dropdowns ist, dass zum Editieren und L�schen nur die existierenden Abilities zu dem jeweiligen
			 Boss angezeigt werden. Der Benutzer beh�lt den �berblick �ber die Phasen und sieht direkt, welche Phase er bearbeitet.
			 Bei der Zuordnung der Spieler, kann die Zeit variieren. Die Abilities sind relativ zu den Phasen�berg�ngen.
]]
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
	UIDropDownMenu_SetText(framus, "Abillity")
	if SA_LastSelected.abillity ~= "" then
		UIDropDownMenu_SetText(framus, SA_LastSelected.abillity)
	end
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus) 
	
end

--[[
Function Name: createPlayerDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "PlayerDropDown" ist eigenst�ndig, wird aber f�r "CooldownDropDown"
			 ben�tigt. Mit Hilfe dieses Dropdowns kann ein beliebiger Spieler aus der Gruppe bzw. aus dem Raid ausgew�hlt werden. 
			 Zu dem jeweiligen Spieler wird die Klasse ermittelt und gespeichert. Da jede Klasse �ber andere Cooldowns verf�gt ist es wichtig
			 den passenden Spieler auszuw�hlen. 
			 Aus Sicht der Assignments muss der zugeordnete Spieler, eindeutig angesprochen werden. Die Verwendung eines Dropdowns im Vergleich 
			 zu beispielsweise Editboxen besteht darin, dass sich der Spieler in der Gruppe befindet und der Benutzer sich nicht vertippen kann.
]]
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
	UIDropDownMenu_SetText(framus, "Player")
	UIDropDownMenu_JustifyText(framus, "LEFT")
	return framus
end

--[[
Function Name: createCooldownDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
					ref - Die Referenz zu dem "PlayerDropDown". Der "PlayerDropDown" wird verwendet um die Klasse des jeweiligen Spielers zu 
						  ermitteln. Abh�ngig von der Klasse k�nnen die Cooldowns geladen werden.
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: In dieser Funktion wird das GUI Element Dropdown erstellt. "CooldownDropDown" ist in seiner Funktion abh�ngig von dem "PlayerDropDown",
			 genauer gesagt sogar von dem ausgew�hlten Spieler. Zu jedem Spieler wird die Klasse gespeichert. Jede Klasse hat verschiedene Cooldowns.
			 Es sollen daher nur die Cooldowns angezeigt werden, die von dem Spieler verwendet werden k�nnen. 
			
			Die Verwendung eines Dropdowns im Gegensatz zu anderen GUI Elementen dominiert aus folgenden Gr�nden. Der Raidleiter muss die Cooldowns
			aus der Liste erkennen. Er muss nicht eigenst�ndig �berlegen, welcher Cooldown zu welcher Klasse geh�rt. Au�erdem ist das ausw�hlen 
			des Cooldowns sicher vor Tippfehlern. Dar�ber hinaus werden im Backend die Cooldowns und ihre SpellIDs verwaltet.  Es w�re ein zu gro�er
			Aufwand f�r den Benutzer sich in die Strukturen des Backends einzuarbeiten. 
]]
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


--[[
Function Name: createBlankDropDown
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "PlayerDropDown" angezeigt werden soll.
					  x - Horizontale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
					  y - Vertikale Koordinate zum ausrichten des Dropdowns. (Abh�ngig von dem Mittelpunkt des parentFrames)
						  Im Vergleich zu anderen Systemen, wird das Element bei einer positiven Y-Koordinate nach oben, bei 
						  einer negativen Y-Koordinate nach unten ausgerichtet.
				  width - Breite des Dropdowns. Es werden noch zus�tzlich 24 Pixel f�r den Button hinzugef�gt.
				   name - Der Name wird als globaler Variablennamen verwendet. Die von der Blizzard vorgegebenden Funktion erstellt die
						  globale Variable. Der Name sollte eindeutig bleiben! Ansonsten treten Probleme aller gleich genannten 
						  GUI Elemente auf.
				 tablus - Die mit Werten gef�llte zu �bergebende Tabelle. Im Dropdown werden alle Elemente angezeigt, welche in der Table 
						  vordefiniert sind.
			defaultText - Der Standardtext wenn kein Wert ausgew�hlt wurde. Besonders beim Neuerstellen des Dropdowns kann hierbei eine 
						  Beschreibung bzw. der Verwendungszweck, des Dropdowns angegeben werden
Return:	Es wird die Referenz des neu erstellten Dropdowns zur�ck gegeben. 
Description: Diese Funktion soll es erm�glichen schnell und einfach neue Dropdowns mit nur einem Funktionsaufruf zu erstellen. 
			 Es wird nur die M�glichkeit geboten, die Werte eine vorgegebende Tabelle anzuzeigen. Die Verwendung von speziellen
			 Funktionalit�ten ist nicht m�glich. Hierf�r muss wie bei den anderen Dropdowns ein eigenes Dropdown mitsamt Init-Funktion,
			 onClick-Funktion und darin enthaltener Logikanbindung geschrieben werden.
]]
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
