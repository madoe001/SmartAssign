if GetLocale() ~= "deDE" then 
	return 
end
if not SA_GUI_Translations then 
	SA_GUI_Translations = {} 
end
local L = SA_GUI_Translations

L.TITLE = "SmartAssign"

L.START_INFO = "SmartAssign geladen weitere Informationen folgen."