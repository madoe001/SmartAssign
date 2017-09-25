
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
caric.framusCounter = 42;
caric.assignCounter = 0;

function caric:Init(event, addon)
	if(event == "ADDON_LOADED" and addon == "SmartAssign") then
		--caric:CreateGUI(testFrame)
	end
end

--frame erstellen und events registrieren
testFrame = CreateFrame("Frame","testFrame",UIParent)
testFrame:SetScript("OnEvent",caric.Init)
testFrame:RegisterEvent("ADDON_LOADED")

function caric:CreateGUI(frame)
	--Fenster
	local window = caric:CreateWindow(frame)
	caric:CreateButton(frame, "closeButton", nil, 240,240,30,30, "UIPanelCloseBUtton")
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

function caric:CreateButton(frame, name, text, x,y,width, height, template)
	if(template == nil) then
		template = "OptionsButtonTemplate"
	end
	local button = CreateFrame("Button", name, frame, template)
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetPoint("CENTER",x,y)
	button:SetText(text)
	return (button)
end

function caric:CreateFont(frame, name, text,x,y,size)
	local fontString = frame:CreateFontString(name)
	fontString:SetPoint("CENTER",x,y)
	fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "")
	fontString:SetText(text)
	return (fontString)
end

function caric:CreateEditBox(frame, name, x,y, width, height)
	local editBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")
	editBox:SetPoint("CENTER",x,y)
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


if (not SA_WEAKAURA) then
	SA_WEAKAURA = {}
	SA_WEAKAURA.duration = 0
	SA_WEAKAURA.offset = 5
end
SA_WA = {}
function SA_WA:addPlayer()
	local playerName = GetUnitName("Player")
	
end

function SA_WA:addAssign(spellid, timer , assignmentName)  
	local playerName = GetUnitName("Player")
	if (not SA_WEAKAURA[playerName]) then
		SA_WEAKAURA[playerName] = {}
	end
	if (not SA_WEAKAURA[playerName][assignmentName]) then
		SA_WEAKAURA[playerName][assignmentName] = {}
	end
	SA_WEAKAURA[playerName][assignmentName].spellid = spellid
	SA_WEAKAURA[playerName][assignmentName].timer = timer
end

function SA_WA:getClosestTimer(spellID) 
	local playerName = GetUnitName("Player")
	if (not SA_WEAKAURA[playerName]) then
		return nil
	end  
	local closestKey = nil
	local closestTime = 10000000000
	local deltaTime = 0
	for k,v in pairs (SA_WEAKAURA[playerName]) do
		if (SA_WEAKAURA[playerName][k].spellid == spellID) then
			deltaTime = SA_WEAKAURA[playerName][k].timer - SA_WEAKAURA.duration
			if(deltaTime > 0 and deltaTime < closestTime) then
				closestKey = k;
				closestTime = deltaTime;
			end
		end
	end
	SA_WEAKAURA.closestKey = closestKey
	return closestKey
end

function SA_OnEvent(frame, event, encounterID, ...)
   if event == "ENCOUNTER_START" then
	SA_WEAKAURA.start = GetTime()
	SA_WEAKAURA.combat = true
	SA_WEAKAURA.encounterID = encounterID
   end 
   if event == "ENCOUNTER_END" then
	SA_WEAKAURA.combat = false
   end 
end

function SA_Update()
	if SA_WEAKAURA.combat then
		SA_WEAKAURA.duration = GetTime() - SA_WEAKAURA.start
	else
		SA_WEAKAURA.duration = 0
	end
end

frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")

frame:SetScript("OnEvent", SA_OnEvent)
frame:SetScript("OnUpdate", SA_Update)


local SA_prefix = "<SMART_ASSIGN>"
frame:RegisterEvent("CHAT_MSG_ADDON");
RegisterAddonMessagePrefix(SA_prefix);

SLASH_WRITE1 = "/write";
function SlashCmdList.WRITE(msg, editbox)
	if msg then 
		print(msg); 
		SendAddonMessage(prefix,msg,"PARTY");
	end
end

local function print_msg(...)
	_,_,prefix, msg, channel, sender = ...;
	if(prefix == SA_prefix) then 
		print ("\n" .. sec .. "\n" .. third .. "\n" .. sender .. ": " .. msg .. " in" .. channel);
	end		
end
frame:SetScript("OnEvent", print_msg);

