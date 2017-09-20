-- Fertig getestet und implementiert
-- Es kann mit den Funktionsaufruf direkt ein Dropdownmenu erstellt werden
-- Die Dropdowns werden direkt an die passende Table mit ihrer Logik gekoppelt


function createExpansionDropDown (parentFrame,x, y, width)
	
	if not ExpansionDropDown then
	 CreateFrame("Button", "ExpansionDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	ExpansionDropDown:ClearAllPoints()
	ExpansionDropDown:SetPoint("CENTER", x, y)
	ExpansionDropDown:Show()

	function OnClickExpansionDropDown(self)
		UIDropDownMenu_SetSelectedID(ExpansionDropDown, self:GetID())
		SA_LastSelected.expansion = UIDropDownMenu_GetText(ExpansionDropDown)
		SA_LastSelected.raid = ""
		SA_LastSelected.boss = ""
		SA_LastSelected.abillity = ""

		UIDropDownMenu_SetText(RaidDropDown, "Raid")
		UIDropDownMenu_SetText(BossDropDown, "Boss")
		if AbillityDropDown then 
			UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		end
	end
	
	function initExpansionDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		for k,v in pairs(SA_BossList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = OnClickExpansionDropDown
			UIDropDownMenu_AddButton(info, level)
			
			-- Vorauswahl, des letzten eintrags
			i = i+1
			if(k == SA_LastSelected.expansion) then				
				j = i
			end
		end	
		if (j ~= 0) then
			UIDropDownMenu_SetSelectedID(ExpansionDropDown, j)
		end
	end
	
	UIDropDownMenu_Initialize(ExpansionDropDown, initExpansionDropDown)
	UIDropDownMenu_SetWidth(ExpansionDropDown, width);
	UIDropDownMenu_SetButtonWidth(ExpansionDropDown, width +24)
	if (SA_LastSelected.expansion == "") then
		UIDropDownMenu_SetText(ExpansionDropDown, "Expansion")
	else
		UIDropDownMenu_SetText(ExpansionDropDown, SA_LastSelected.expansion)
	end
	
	UIDropDownMenu_JustifyText(ExpansionDropDown, "LEFT")
end

function createRaidDropDown (parentFrame, x, y, width)
	if not RaidDropDown then
		CreateFrame("Button", "RaidDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	RaidDropDown:ClearAllPoints()
	RaidDropDown:SetPoint("CENTER", x, y)
	RaidDropDown:Show()

	function OnClickRaidDropDown(self)
		UIDropDownMenu_SetSelectedID(RaidDropDown, self:GetID())
		
		SA_LastSelected.raid = UIDropDownMenu_GetText(RaidDropDown)
		SA_LastSelected.boss = ""
		SA_LastSelected.abillity = ""

		UIDropDownMenu_SetText(BossDropDown, "Boss")
		if AbillityDropDown then 
			UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		end
	end

	function initRaidDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			for k,v in pairs(SA_BossList[SA_LastSelected.expansion]) do				
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = OnClickRaidDropDown
				UIDropDownMenu_AddButton(info, level)
				
				-- Vorauswahl, des letzten eintrags
				i = i+1
				if(k == SA_LastSelected.raid) then				
					j = i
				end
			end	
			if(j ~= 0) then
				UIDropDownMenu_SetSelectedID(RaidDropDown, j)
			end
		end
	end

	UIDropDownMenu_Initialize(RaidDropDown, initRaidDropDown)
	UIDropDownMenu_SetWidth(RaidDropDown, width);
	UIDropDownMenu_SetButtonWidth(RaidDropDown, width +24)
	if (SA_LastSelected.raid == "") then
		UIDropDownMenu_SetText(RaidDropDown, "Raid")
	else
		UIDropDownMenu_SetText(RaidDropDown, SA_LastSelected.raid)
	end
	UIDropDownMenu_JustifyText(RaidDropDown, "LEFT")
end

function createBossDropDown (parentFrame, x, y, width)
	if not BossDropDown then
		CreateFrame("Button", "BossDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	BossDropDown:ClearAllPoints()
	BossDropDown:SetPoint("CENTER", x, y)
	BossDropDown:Show()

	function OnClickBossDropDown(self)
		UIDropDownMenu_SetSelectedID(BossDropDown, self:GetID())
		SA_LastSelected.boss = UIDropDownMenu_GetText(BossDropDown)
		SA_LastSelected.abillity = ""

		if AbillityDropDown then 
			UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		end
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
					info.func = OnClickBossDropDown
					UIDropDownMenu_AddButton(info, level)
					
					-- Vorauswahl, des letzten eintrags
					i = i+1
					if(k == SA_LastSelected.boss) then				
						j = i
					end
				end
				if(j ~= 0) then
					UIDropDownMenu_SetSelectedID(BossDropDown, j)
				end
			end	
		end
	end
	UIDropDownMenu_Initialize(BossDropDown, initBossDropDown)
	UIDropDownMenu_SetWidth(BossDropDown, width);
	UIDropDownMenu_SetButtonWidth(BossDropDown, width +24)
	if (SA_LastSelected.boss == "") then
		UIDropDownMenu_SetText(BossDropDown, "Boss")
	else
		UIDropDownMenu_SetText(BossDropDown, SA_LastSelected.boss)
	end
	UIDropDownMenu_JustifyText(BossDropDown, "LEFT")
end

function createAbillityDropDown (parentFrame, x, y, width)
	if not AbillityDropDown then
		CreateFrame("Button", "AbillityDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	AbillityDropDown:ClearAllPoints()
	AbillityDropDown:SetPoint("CENTER", x, y)
	AbillityDropDown:Show()

	function OnClickAbillityDropDown(self)
		UIDropDownMenu_SetSelectedID(AbillityDropDown, self:GetID())
		SA_LastSelected.abillity = UIDropDownMenu_GetText(AbillityDropDown)
		if AbillityEditBox then
			AbillityEditBox:SetText(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss][SA_LastSelected.abillity].AbillityName)
			SpellIDEditBox:SetText(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss][SA_LastSelected.abillity].SpellID)
			CoolDownEditBox:SetText(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss][SA_LastSelected.abillity].Cooldown)
			StartHPEditBox:SetText(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss][SA_LastSelected.abillity].StartHP)
			EndHPEditBox:SetText(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss][SA_LastSelected.abillity].EndHP)
		end
	end

	function initAbillityDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		local i = 0 -- laufvariable
		local j = 0 -- Saved Value vom letzten eintrag
		if(SA_BossList[SA_LastSelected.expansion] ~= nil) then
			if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] ~= nil) then
				if(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss] ~= nil) then
					for k,v in pairs(SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss]) do
						info = UIDropDownMenu_CreateInfo()
						info.text = k
						info.value = v
						info.func = OnClickAbillityDropDown
						UIDropDownMenu_AddButton(info, level)
						
						-- Vorauswahl, des letzten eintrags
						i = i+1
						if(k == SA_LastSelected.abillity) then				
							j = i
						end
					end
					if(j ~= 0) then
						UIDropDownMenu_SetSelectedID(AbillityDropDown, j)
					end
				end
			end
		end	
	end

	UIDropDownMenu_Initialize(AbillityDropDown, initAbillityDropDown)
	UIDropDownMenu_SetWidth(AbillityDropDown, width);
	UIDropDownMenu_SetButtonWidth(AbillityDropDown, width +24)
	if (SA_LastSelected.abillity == "") then
		UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
	else
		UIDropDownMenu_SetText(AbillityDropDown, SA_LastSelected.abillity)
	end
	UIDropDownMenu_JustifyText(AbillityDropDown, "LEFT")
end

function createPlayerDropDown (parentFrame, x, y, width)
	
	local framus = CreateFrame("Button", "PlayerDropDown"..caric.framusCounter, parentFrame, "UIDropDownMenuTemplate")
	caric["PlayerDropDown"..caric.framusCounter] = framus

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

function createCooldownDropDown (parentFrame, x, y, width, ref)

	local framus = CreateFrame("Button", "CooldownDropDown"..caric.framusCounter, parentFrame, "UIDropDownMenuTemplate")
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