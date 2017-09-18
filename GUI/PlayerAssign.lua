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
	
	local function hide(self)
		self.abilityCB:Hide()
		self.textCB:Hide()
		self.dropDownPlayer:Hide()
		self.dropDownCooldown:Hide()
		self.offset:Hide()
	end
	
	local function show(self)
		self.abilityCB:Show()
		self.textCB:Show()
		self.dropDownPlayer:Show()
		self.dropDownCooldown:Show()
		self.offset:Show()
	end

	function PlayerAssign:new_playerAssign(frame, relativeElement, lastElement, xVal, yVal)
		
		local obj = {
			--Klassenattribute
			x = xVal,
			y = yVal,
			mainFrame = frame,
			abilityCB = CheckBox:LoadCheckBox(frame, "Ability", "AbilityCheckBox"),
			textCB = CheckBox:LoadCheckBox(frame, "Extra Text", "ExtraTextCheckBox"),
			dropDownPlayer = DropDownList:LoadDropDownList(frame, {"p1", "p2", "p3"}, "PlayerDropDownList"),
			dropDownCooldown = DropDownList:LoadDropDownList(frame, {"a1", "a2", "a3"}, "CDDropDownList"),
			offset = EditBox:LoadEditBox(frame, "number"),	
			
			--Klassenmethoden bzw. referenzen drauf
			Hide = hide,
			Show = show,
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
		
		obj.offset:SetMaxLetters(obj.offset, 6) 

		obj.dropDownPlayer:SetPoint("LEFT",relativeElement, "RIGHT",5, 0)
		obj.abilityCB:SetPoint("LEFT", obj.dropDownPlayer, "RIGHT", xVal, yVal)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0, 0)
		obj.dropDownCooldown:SetPoint("LEFT", obj.textCB, "RIGHT", xVal, yVal)
		obj.offset:SetPoint("LEFT", obj.abilityCB, "RIGHT", 0, 0)
		
		obj.abilityCB:Hide()
		obj.textCB:Hide()
		--obj.dropDownPlayer:Hide()
		obj.dropDownCooldown:Hide()
		obj.offset:Hide()
		return obj
	end

end







