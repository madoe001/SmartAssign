local _G = _G

local mainHUD = _G.HUD.mainHUD

local SAL = _G.GUI.Locales

function mainHUD:Show()
	local hudFrame = CreateFrame("Frame","hudFrame",UIParent)
	hudFrame:SetFrameStrata('BACKGROUND')
	return hudFrame
end

function mainHUD:OnUpdate_TestInstance()
	local isInstance, instanceType = IsInInstance()
	if isInstance then
		--print(SAL["Player is in Instance."])
		if instanceType == "party" or instanceType == "raid" then
			mainHUD.instanceType = instanceType
		end
	else
		--print("|cFFFF0000"..SAL["Player is not in Instance."].."|r")
	end
end