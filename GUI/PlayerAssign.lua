--Klasse, zum einteilen eines Spielers. 
--Mit Hilfe dieser Klasse soll es Möglich sein eine Liste von Spielern in einem Dropdownmenu angezeigt zu bekommen
--im Anschluss soll ausgewählt werden können was der Spieler bei einer Bossfähigkeit oder bei einem bestimmtetn Timer machen soll
	--entweder eine ability benutzen oder dem Spieler wird ein extra Text angezeigt um zum Beispiel den Spieler dazu zu bewegen sich
	--an eine bestimmte Stelle zu bewegen
-- Zuletzt soll ein Offset eingestellt werden können um zum Beispiel bei einem Timer genügend Zeit zur Verfügung gestellt zu bekommen eine Fähigkeit zu Nutzen
--Siehe GUI-Bilder


do 
	--Globale Speicherung der Klasse
	local PlayerAssign = _G.GUI.PlayerAssignment	

	--Benötigte Klasse lokal holen(nicht zwingend notwendig erspart aber Schreibarbeit) 
	local CheckBox = _G.GUI.SA_CheckBox
	
	local DropDownList = _G.GUI.SA_DropDownList
	
	local EditBox = _G.GUI.SA_EditBox

	function PlayerAssign:new_playerAssign(frame, relativeElement, lastElement)
		
		local obj = {
			frame = frame,
			abilityCB = CheckBox:LoadCheckBox(frame, "Ability"),
			textCB = CheckBox:LoadCheckBox(frame, "Extra Text"),
			dropDownPlayer = DropDownList:LoadDropDownList(frame, {"p1", "p2", "p3"}),
			dropDownPlayer = DropDownList:LoadDropDownList(frame, {"a1", "a2", "a3"}),
			offest = EditBox:LoadeditBox(frame, "number"),	
	}
		
		obj.abilityCB:SetScript("OnClick", function(self, button, down)
			if obj.textCB:GetChecked() then
				obj.textCB:Disable()
			else
				obj.textCB:Enable()
			end
		end) 
		obj.textCB:SetScript("OnClick", function(self, button, down)
			if obj.textCB:GetChecked() then
				obj.extraCB:Disable()
			else
				obj.extraCB:Enable()
			end
		end)
	end

end







