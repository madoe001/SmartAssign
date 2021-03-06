﻿NewAbillityWindow = {}




function NewAbillityWindow:show()
	-- Background für NewAbillityWindow erschaffen
	NewAbillityWindow.frame = CreateFrame("Frame","BossSelectFramus",UIParent)
	NewAbillityWindow.frame:SetWidth(500)
	NewAbillityWindow.frame:SetHeight(700)
	NewAbillityWindow.frame:SetPoint("CENTER",0,0)
	NewAbillityWindow.frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	NewAbillityWindow.frame:SetBackdropColor(0.0,0.0,0.0,1.0)
	
	-- DropDownMenus einfügen
	-- Expansion
	expansionDD = createExpansionDropDown(NewAbillityWindow.frame, -125, 250, 150)
	caric:CreateEditBox(NewAbillityWindow.frame,"ExpansionEditBox",50,250,150,30)	
	caric:CreateButton(NewAbillityWindow.frame, "ExpansionAddButton", "add", 150, 250, 50,30)
	ExpansionAddButton:SetScript("OnClick", function() 
											if(NewAbillityWindow:checkInput(ExpansionEditBox:GetText(),1)) then 
												addExpansion(ExpansionEditBox:GetText())
												ExpansionEditBox:SetText("")
											end	end)
	caric:CreateButton(NewAbillityWindow.frame, "ExpansionDeleteButton", "delete", 200, 250, 50,30)
	ExpansionDeleteButton:SetScript("OnClick", function() removeExpansion(UIDropDownMenu_GetText(ExpansionDropDown) );
										 UIDropDownMenu_SetSelectedID(ExpansionDropDown, 1)
										 UIDropDownMenu_SetText(ExpansionDropDown,"Expansion")
										 UIDropDownMenu_SetText(RaidDropDown,"Raid")
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity")
										 SA_LastSelected.expansion = ""
										 SA_LastSelected.raid = ""
										 SA_LastSelected.boss = ""
										 SA_LastSelected.abillity = ""
										 end)
										 
	-- Raid
	createRaidDropDown (NewAbillityWindow.frame, -125, 200, 150)
	caric:CreateEditBox(NewAbillityWindow.frame,"RaidEditBox",50,200,150,30)
	caric:CreateButton(NewAbillityWindow.frame, "RaidAddButton", "add", 150, 200, 50,30)
	RaidAddButton:SetScript("OnClick", function() 
									   if (NewAbillityWindow:checkInput(RaidEditBox:GetText(),2)) then
											addRaid(SA_LastSelected.expansion, RaidEditBox:GetText())
											RaidEditBox:SetText("")
									   end end)
	caric:CreateButton(NewAbillityWindow.frame, "RaidDeleteButton", "delete", 200, 200, 50,30)
	RaidDeleteButton:SetScript("OnClick", function() removeRaid(SA_LastSelected.expansion, UIDropDownMenu_GetText(RaidDropDown) );
										 UIDropDownMenu_SetSelectedID(RaidDropDown, 1)
										 SA_LastSelected.raid = ""
										 SA_LastSelected.boss = ""
										 SA_LastSelected.abillity = ""
										 UIDropDownMenu_SetText(RaidDropDown,"Raid")
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
										 
										 
	-- Boss									 
	createBossDropDown (NewAbillityWindow.frame,  -125, 150, 150)
	caric:CreateEditBox(NewAbillityWindow.frame,"BossEditBox",50,150,150,30)	
	caric:CreateButton(NewAbillityWindow.frame, "BossAddButton", "add", 150, 150, 50,30)
	BossAddButton:SetScript("OnClick", function() 
										if (NewAbillityWindow:checkInput(BossEditBox:GetText(),3)) then
											addBoss(SA_LastSelected.expansion, SA_LastSelected.raid, BossEditBox:GetText())
											BossEditBox:SetText("")
										end end)
	caric:CreateButton(NewAbillityWindow.frame, "BossDeleteButton", "delete", 200, 150, 50,30)
	BossDeleteButton:SetScript("OnClick", function() removeBoss(SA_LastSelected.expansion, SA_LastSelected.raid, UIDropDownMenu_GetText(BossDropDown) );
										 UIDropDownMenu_SetSelectedID(BossDropDown, 1)
										 SA_LastSelected.boss = ""
										 SA_LastSelected.abillity = ""
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
				
	-- Phase
	createPhaseDropDown (NewAbillityWindow.frame,  -125, 0, 150)
	caric:CreateFont(NewAbillityWindow.frame, "PhaseTriggerFont", "Phase Trigger",50,40,15)
	phaseTriggerOptions = {"%HP","%Energy", "Time","Text"}
	createBlankDropDown (NewAbillityWindow.frame, 50, 10, 150, "PhaseTriggerDD", phaseTriggerOptions, "Trigger")
	
	
	-- Abillity									 
	createAbillityDropDown (NewAbillityWindow.frame,  -125, -280, 150)
	abillityTriggerOptions = {"%HP","%Energy", "Time","Text"}
	createBlankDropDown (NewAbillityWindow.frame, 50, 10, 150, "AbillityTriggerDD", abillityTriggerOptions, "Trigger")
	caric:CreateFont(NewAbillityWindow.frame, "AbillityTriggerFont", "Abillity Trigger",50,-170,15)
	caric:CreateEditBox(NewAbillityWindow.frame,"AbillityEditBox",50,-240,150,30)
	caric:CreateFont(NewAbillityWindow.frame, "AbillityNameFont", "Abillity Name",50,-220,15)
	caric:CreateEditBox(NewAbillityWindow.frame,"CoolDownEditBox",50,-290,150,30)
	caric:CreateFont(NewAbillityWindow.frame, "CoolDownFont", "CoolDown (s)",50,-270,15)
	caric:CreateButton(NewAbillityWindow.frame, "AbillityAddButton", "add", -15, -330, 50,30)
	--TODO Schnittstelle anpassen, weil abgeändert
	AbillityAddButton:SetScript("OnClick", function() if (NewAbillityWindow:checkAbillityInputs()) then
		print("LOL")
		addAbillity(SA_LastSelected.expansion, SA_LastSelected.raid, SA_LastSelected.boss, AbillityEditBox:GetText(), 
														SpellIDEditBox:GetText(),CoolDownEditBox:GetText(), StartHPEditBox:GetText(), EndHPEditBox:GetText())
											AbillityEditBox:SetText("")											
											CoolDownEditBox:SetText("")
										end end)
	caric:CreateButton(NewAbillityWindow.frame, "AbillityDeleteButton", "delete", 100, -330, 50,30)
	--TODO Schnittstelle anpassen, weil abgeändert
	AbillityDeleteButton:SetScript("OnClick", function() removeAbillity(SA_LastSelected.expansion, SA_LastSelected.raid, SA_LastSelected.boss, UIDropDownMenu_GetText(AbillityDropDown) );
										 UIDropDownMenu_SetSelectedID(AbillityDropDown, 1)
										 SA_LastSelected.abillity = ""
										 AbillityEditBox:SetText("")
										 CoolDownEditBox:SetText("")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
	
	caric:CreateButton(NewAbillityWindow.frame, "closeButton", nil, 240,350,30,30, "UIPanelCloseBUtton")	
end

function NewAbillityWindow:checkInput(text, state)
	local ret = true
	text = string.lower(text)
	if SA_LastSelected.expansion == "" and state >= 1 then
		ret = false
	end
	if SA_LastSelected.raid == "" and state >= 2 then
		ret = false
	end
	if SA_LastSelected.boss == "" and state >= 3 then
		ret = false
	end
	if SA_LastSelected.abillity == "" and state >= 4 then
		ret = false
	end
	if(text == "" or text == "custom") then
		ret = false
	end
	
	return ret
end

function NewAbillityWindow:checkAbillityInputs()
	local ret = true
	if(not NewAbillityWindow:checkInput(AbillityEditBox:GetText(),4)) then
		ret = false
	end
	if(not NewAbillityWindow:checkInput(CoolDownEditBox:GetText(),4)) then
		ret = false
	end
	return ret
end
