local _G = _G

local mainHUD = _G.mainHUD

local SAL = _G.GUI.Locales

function mainHUD:LoadHUD()
	local isInstance, instanceType = IsInInstance()
	if isInstance then
		print(SAL["Player is in Instance."])
	else
		print(SAL["Player is not in Instance."])
	end
end