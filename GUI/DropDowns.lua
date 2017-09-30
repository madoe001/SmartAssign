-- Fertig getestet und implementiert
-- Es kann mit den Funktionsaufruf direkt ein Dropdownmenu erstellt werden
-- Die Dropdowns werden direkt an die passende Table mit ihrer Logik gekoppelt


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

function createBossDropDown (parentFrame, x, y, width, name)
	
	local framus = CreateFrame("Button", name, parentFrame, "UIDropDownMenuTemplate")

	framus:ClearAllPoints()
	framus:SetPoint("CENTER", x, y)
	framus:Show()

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

function createPhaseDropDown (parentFrame, x, y, width)
	if not PhaseDropDown then
		CreateFrame("Button", "PhaseDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	PhaseDropDown:ClearAllPoints()
	PhaseDropDown:SetPoint("CENTER", x, y)
	PhaseDropDown:Show()

	function OnClickPhaseDropDown(self)
		UIDropDownMenu_SetSelectedID(PhaseDropDown, self:GetID())
		SA_LastSelected.phase = UIDropDownMenu_GetText(PhaseDropDown)
		SA_LastSelected.abillity = ""

		if PhaseDropDown then 
			UIDropDownMenu_SetText(PhaseDropDown, "Phase")
		end
	end

	function initPhaseDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] ~= nil) then
				if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss] ~= nil) then
					for k,v in pairs(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss]) do
						if k ~= "encounterID" then
							info = UIDropDownMenu_CreateInfo()
							info.text = k
							info.value = v
							info.func = OnClickPhaseDropDown
							UIDropDownMenu_AddButton(info, level)
					
							-- Vorauswahl, des letzten eintrags
							i = i+1
							if(k == SA_LastSelected.phase) then				
								j = i
							end
						end
					end
				
					if(j ~= 0) then
						UIDropDownMenu_SetSelectedID(PhaseDropDown, j)
					end
				end
			end	
		end
	end
	UIDropDownMenu_Initialize(PhaseDropDown, initPhaseDropDown)
	UIDropDownMenu_SetWidth(PhaseDropDown, width);
	UIDropDownMenu_SetButtonWidth(PhaseDropDown, width +24)
	if (SA_LastSelected.phase == "") then
		UIDropDownMenu_SetText(PhaseDropDown, "Phase")
	else
		UIDropDownMenu_SetText(PhaseDropDown, SA_LastSelected.phase)
	end
	UIDropDownMenu_JustifyText(PhaseDropDown, "LEFT")
end

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
		for k,v in pairs(list) do
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
	UIDropDownMenu_SetText(framus, SA_LastSelected.abillity)
	UIDropDownMenu_JustifyText(framus, "LEFT")
	
	return (framus) 
	
end

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
