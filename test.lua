
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
function caric:Init(event, addon)
	if(event == "ADDON_LOADED" and addon == "SmartAssign") then
		caric:CreateGUI(testFrame)
	end
end

--frame erstellen und events registrieren
testFrame = CreateFrame("Frame","testFrame",UIParent)
testFrame:SetScript("OnEvent",caric.Init)
testFrame:RegisterEvent("ADDON_LOADED")

function caric:CreateGUI(frame)
	--Fenster
	caric:CreateWindow(frame)
	caric:CreateButton(frame, "closeButton", nil, 30, 30, 450,0, "UIPanelCloseBUtton")
	
	-- Expansion
	createExpansionDropDown (testFrame, -150, 200, 100)
	caric:CreateEditBox(frame,"ExpansionEditBox",100,30,170,-35)	
	caric:CreateButton(frame, "ExpansionAddButton", "add", 30, 30, 270,-35)
	ExpansionAddButton:SetScript("OnClick", function() 
											if(ExpansionEditBox:GetText() ~= "" and ExpansionEditBox:GetText() ~= "Expansion") then 
												addExpansion(ExpansionEditBox:GetText())
												ExpansionEditBox:SetText("")
											end	end)
	caric:CreateButton(frame, "ExpansionDeleteButton", "delete", 45, 30, 300,-35)
	ExpansionDeleteButton:SetScript("OnClick", function() removeExpansion(UIDropDownMenu_GetText(ExpansionDropDown) );
										 UIDropDownMenu_SetSelectedID(ExpansionDropDown, 1)
										 caric.ex = ""
										 caric.ra = ""
										 caric.bo = ""
										 caric.ab = ""
										 UIDropDownMenu_SetText(ExpansionDropDown,"Expansion")
										 UIDropDownMenu_SetText(RaidDropDown,"Raid")
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity")end)
										 
	-- Raid
	createRaidDropDown (testFrame, -150, 160, 100)
	caric:CreateEditBox(frame,"RaidEditBox",100,30,170,-75)	
	caric:CreateButton(frame, "RaidAddButton", "add", 30, 30, 270,-75)
	RaidAddButton:SetScript("OnClick", function() 
									   if (RaidEditBox:GetText() ~= "" and RaidEditBox:GetText() ~= "Raid" and caric.ex ~= "") then
											addRaid(caric.ex, RaidEditBox:GetText())
											RaidEditBox:SetText("")
									   end end)
	caric:CreateButton(frame, "RaidDeleteButton", "delete", 45, 30, 300,-75)
	RaidDeleteButton:SetScript("OnClick", function() removeRaid(caric.ex, UIDropDownMenu_GetText(RaidDropDown) );
										 UIDropDownMenu_SetSelectedID(RaidDropDown, 1)
										 caric.ra = ""
										 caric.bo = ""
										 caric.ab = ""
										 UIDropDownMenu_SetText(RaidDropDown,"Raid")
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
										 
	-- Boss									 
	createBossDropDown (testFrame, -150, 120, 100)
	caric:CreateEditBox(frame,"BossEditBox",100,30,170,-115)	
	caric:CreateButton(frame, "BossAddButton", "add", 30, 30, 270,-115)
	BossAddButton:SetScript("OnClick", function() 
										if (BossEditBox:GetText() ~= "" and BossEditBox:GetText() ~= "Boss" and caric.ex ~= "" and caric.ra ~= "") then
											addBoss(caric.ex, caric.ra, BossEditBox:GetText())
											BossEditBox:SetText("")
										end end)
	caric:CreateButton(frame, "BossDeleteButton", "delete", 45, 30, 300,-115)
	BossDeleteButton:SetScript("OnClick", function() removeBoss(caric.ex, caric.ra, UIDropDownMenu_GetText(BossDropDown) );
										 UIDropDownMenu_SetSelectedID(BossDropDown, 1)
										 caric.bo = ""
										 caric.ab = ""
										 UIDropDownMenu_SetText(BossDropDown,"Boss")
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
										 
	-- Abillity									 
	createAbillityDropDown (testFrame, -150, 80, 100)
	caric:CreateEditBox(frame,"AbillityEditBox",100,30,170,-155)	
	caric:CreateEditBox(frame,"SpellIDEditBox",50,30,275,-155)
	caric:CreateButton(frame, "AbillityAddButton", "add", 30, 30, 325,-155)
	AbillityAddButton:SetScript("OnClick", function() if (AbillityEditBox:GetText() ~= "" and SpellIDEditBox:GetText() ~= "" and AbillityEditBox:GetText() ~= "Abillity" and caric.ex ~= "" and caric.ra ~= "" and caric.bo ~= "" ) then
											addAbillity(caric.ex, caric.ra, caric.bo, AbillityEditBox:GetText(), SpellIDEditBox:GetText())
											AbillityEditBox:SetText("")
											SpellIDEditBox:SetText("")
										end end)
	caric:CreateButton(frame, "AbillityDeleteButton", "delete", 45, 30, 355,-155)
	AbillityDeleteButton:SetScript("OnClick", function() removeAbillity(caric.ex, caric.ra, caric.bo, UIDropDownMenu_GetText(AbillityDropDown) );
										 UIDropDownMenu_SetSelectedID(AbillityDropDown, 1)
										 caric.ab = ""
										 UIDropDownMenu_SetText(AbillityDropDown,"Abillity") end)
										 
	-- Player									 
	createPlayerDropDown (testFrame, -150, -100, 100)
	caric:CreateEditBox(frame,"PlayerEditBox",100,30,170,-335)	
	caric:CreateButton(frame, "PlayerAddButton", "add", 30, 30, 270,-335)
	PlayerAddButton:SetScript("OnClick", function() addExpansion(BossEditBox:GetText()) end)
	caric:CreateButton(frame, "PlayerDeleteButton", "delete", 45, 30, 300,-335)
	PlayerDeleteButton:SetScript("OnClick", function() removeExpansion(UIDropDownMenu_GetText(BossDropDown) );
										 UIDropDownMenu_SetSelectedID(BossDropDown, 1) end)
				
	-- Cooldown
	createCooldownDropDown (testFrame, -150, -140, 100)
	caric:CreateEditBox(frame,"CooldownEditBox",100,30,170,-375)	
	caric:CreateButton(frame, "CooldownAddButton", "add", 30, 30, 270,-375)
	CooldownAddButton:SetScript("OnClick", function() addExpansion(BossEditBox:GetText()) end)
	caric:CreateButton(frame, "CooldownDeleteButton", "delete", 45, 30, 300,-375)
	CooldownDeleteButton:SetScript("OnClick", function() removeExpansion(UIDropDownMenu_GetText(BossDropDown) );
										 UIDropDownMenu_SetSelectedID(BossDropDown, 1) end)
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

function caric:CreateButton(frame, name, text, width, height, x, y, template)
	if(template == nil) then
		template = "OptionsButtonTemplate"
	end
	local button = CreateFrame("Button", name, frame, template)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetPoint("TOPLEFT",x,y)
	button:SetText(text)
	return (button)
end

function caric:CreateFont(frame, name, text, x, y, size)
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint("TOPLEFT",x,y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	return (fontString)
end

function caric:CreateEditBox(frame, name, width, height, x, y)
	local editBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")
	editBox:SetPoint("TOPLEFT",x,y)
	editBox:SetWidth(width)
	editBox:SetHeight(height)
	editBox:SetAutoFocus(false)
	editBox:Show()
	return (editBox)
end
caric.ex = ""
caric.ra = ""
caric.bo = ""
caric.ab = ""
caric.pl = ""
caric.cd = ""
function caric:prin()
	print("Expansion: " .. caric.ex .. 
		  "\nRaid: " .. caric.ra .. 
		  "\nBoss: " .. caric.bo ..
		  "\nAbillity: " .. caric.ab ..
		  "\nPlayer: " .. caric.pl ..
		  "\nCooldown: " .. caric.cd)
end
