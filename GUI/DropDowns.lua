function createExpansionDropDown (parentFrame, x, y, width)
	if not ExpansionDropDown then
		CreateFrame("Button", "ExpansionDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	ExpansionDropDown:ClearAllPoints()
	ExpansionDropDown:SetPoint("CENTER", x, y)
	ExpansionDropDown:Show()

	function OnClickExpansionDropDown(self)
		UIDropDownMenu_SetSelectedID(ExpansionDropDown, self:GetID())
		UIDropDownMenu_SetText(RaidDropDown, "Raid")
		UIDropDownMenu_SetText(BossDropDown, "Boss")
		UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		caric.ex = UIDropDownMenu_GetText(ExpansionDropDown)
		caric.ra = ""
		caric.bo = ""
		caric.ab = ""
		caric:prin()
	end

	function initExansionDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(SA_BossList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = OnClickExpansionDropDown
			UIDropDownMenu_AddButton(info, level)
		end	
	end

	UIDropDownMenu_Initialize(ExpansionDropDown, initExansionDropDown)
	UIDropDownMenu_SetWidth(ExpansionDropDown, width);
	UIDropDownMenu_SetButtonWidth(ExpansionDropDown, width +24)
	UIDropDownMenu_SetText(ExpansionDropDown, "Expansion")
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
		caric.ra = UIDropDownMenu_GetText(RaidDropDown)
		UIDropDownMenu_SetText(BossDropDown, "Boss")
		UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		caric.bo = ""
		caric.ab = ""
		caric:prin()
	end

	function initRaidDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		if(SA_BossList[caric.ex] ~= nil) then
			for k,v in pairs(SA_BossList[caric.ex]) do				
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = OnClickRaidDropDown
				UIDropDownMenu_AddButton(info, level)
			end	
		end
	end

	UIDropDownMenu_Initialize(RaidDropDown, initRaidDropDown)
	UIDropDownMenu_SetWidth(RaidDropDown, width);
	UIDropDownMenu_SetButtonWidth(RaidDropDown, width +24)
	UIDropDownMenu_SetText(RaidDropDown, "Raid")
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
		caric.bo = UIDropDownMenu_GetText(BossDropDown)
		UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
		caric.ab = ""
		caric:prin()
	end

	function initBossDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		if(SA_BossList[caric.ex] ~= nil) then
			if(SA_BossList[caric.ex][caric.ra] ~= nil) then
				for k,v in pairs(SA_BossList[caric.ex][caric.ra]) do
					info = UIDropDownMenu_CreateInfo()
					info.text = k
					info.value = v
					info.func = OnClickBossDropDown
					UIDropDownMenu_AddButton(info, level)
				end
			end	
		end
	end

	UIDropDownMenu_Initialize(BossDropDown, initBossDropDown)
	UIDropDownMenu_SetWidth(BossDropDown, width);
	UIDropDownMenu_SetButtonWidth(BossDropDown, width +24)
	UIDropDownMenu_SetText(BossDropDown, "Boss")
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
		caric.ab = UIDropDownMenu_GetText(AbillityDropDown)
		caric:prin()
	end

	function initAbillityDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		if(SA_BossList[caric.ex] ~= nil) then
			if(SA_BossList[caric.ex][caric.ra] ~= nil) then
				if(SA_BossList[caric.ex][caric.ra][caric.bo] ~= nil) then
					for k,v in pairs(SA_BossList[caric.ex][caric.ra][caric.bo]) do
						info = UIDropDownMenu_CreateInfo()
						info.text = k
						info.value = v
						info.func = OnClickAbillityDropDown
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end	
	end

	UIDropDownMenu_Initialize(AbillityDropDown, initAbillityDropDown)
	UIDropDownMenu_SetWidth(AbillityDropDown, width);
	UIDropDownMenu_SetButtonWidth(AbillityDropDown, width +24)
	UIDropDownMenu_SetText(AbillityDropDown, "Abillity")
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