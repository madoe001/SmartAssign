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
	if not PlayerDropDown then
		CreateFrame("Button", "PlayerDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	PlayerDropDown:ClearAllPoints()
	PlayerDropDown:SetPoint("CENTER", x, y)
	PlayerDropDown:Show()

	function OnClickPlayerDropDown(self)
		UIDropDownMenu_SetSelectedID(PlayerDropDown, self:GetID())
	end

	function initPlayerDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(SA_BossList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = OnClickPlayerDropDown
			UIDropDownMenu_AddButton(info, level)
		end	
	end

	UIDropDownMenu_Initialize(PlayerDropDown, initPlayerDropDown)
	UIDropDownMenu_SetWidth(PlayerDropDown, width);
	UIDropDownMenu_SetButtonWidth(PlayerDropDown, width +24)
	UIDropDownMenu_SetText(PlayerDropDown, "Player")
	UIDropDownMenu_JustifyText(PlayerDropDown, "LEFT")
end

function createCooldownDropDown (parentFrame, x, y, width)
	if not CooldownDropDown then
		CreateFrame("Button", "CooldownDropDown", parentFrame, "UIDropDownMenuTemplate")
	end

	CooldownDropDown:ClearAllPoints()
	CooldownDropDown:SetPoint("CENTER", x, y)
	CooldownDropDown:Show()

	function OnClickCooldownDropDown(self)
		UIDropDownMenu_SetSelectedID(CooldownDropDown, self:GetID())
	end

	function initCooldownDropDown(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(SA_BossList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = k
			info.value = v
			info.func = OnClickCooldownDropDown
			UIDropDownMenu_AddButton(info, level)
		end	
	end
	caric:prin()

	UIDropDownMenu_Initialize(CooldownDropDown, initCooldownDropDown)
	UIDropDownMenu_SetWidth(CooldownDropDown, width);
	UIDropDownMenu_SetButtonWidth(CooldownDropDown, width +24)
	UIDropDownMenu_SetText(CooldownDropDown, "Cooldown")
	UIDropDownMenu_JustifyText(CooldownDropDown, "LEFT")
end