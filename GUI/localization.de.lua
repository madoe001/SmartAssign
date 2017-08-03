if GetLocale() ~= "deDE" then 
	return 
end
if not SA_GUI_Translations then 
	SA_GUI_Translations = {} 
end
local L = SA_GUI_Translations

L["SmartAssign"] = "SmartAssign"

L["SmartAssign loaded more information added later."] = "SmartAssign geladen weitere Informationen folgen."