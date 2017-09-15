
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

-- frame erstellen und events registrieren
--testFrame = CreateFrame("Frame","testFrame",UIParent)
--testFrame:SetScript("OnEvent",caric.Init)
--testFrame:RegisterEvent("ADDON_LOADED")

local closeButton = CreateFrame("Button", "closeButton", testFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", testFrame)
-- when click on Button Hide frame
closeButton:SetScript("OnClick", function (self, button)
	if button == "LeftButton" then
		testFrame:Hide()
	end
end)


function caric:CreateGUI(frame)
	local window  = caric:CreateWindow(frame)
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



