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
			abilityCB = CheckBox:LoadCheckBox(frame, "Ability"),
			textCB = CheckBox:LoadCheckBox(frame, "Extra Text"),
			dropDownPlayer = DropDownList:LoadDropDownList(frame,"mb1",  {"p1", "p2", "p3"}),
			dropDownCooldown = DropDownList:LoadDropDownList(frame,"mb2", {"a1", "a2", "a3"}),
			--offset = caric:CreateEditBox(frame, "off", 50, 20),
			offset = EditBox:LoadEditBox(frame, "offs", "number"),	
			
			--Klassenmethoden bzw. referenzen drauf
			Hide = hide,
			Show = show,
		}
		
		obj.abilityCB:SetScript("OnClick", function(self, button, down)
			if obj.textCB:GetChecked() then
				obj.textCB:SetChecked(false)
			end
			obj.dropDownCooldown:Show()
			obj.offset:Show()
		end) 

		obj.textCB:SetScript("OnClick", function(self, button, down)
			if obj.abilityCB:GetChecked() then
				obj.abilityCB:SetChecked(false)
			end
		end)

		obj.dropDownPlayer:SetPoint("LEFT",relativeElement, "RIGHT",5, 0)
		obj.abilityCB:SetPoint("LEFT", obj.dropDownPlayer, "RIGHT", 5, 0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0, 0)
		obj.dropDownCooldown:SetPoint("LEFT", obj.abilityCB, "RIGHT", 50,0)
		obj.offset:SetPoint("LEFT", obj.dropDownCooldown, "RIGHT", 10, 0)
	
		obj.abilityCB:Hide()
		obj.textCB:Hide()
		obj.dropDownPlayer:Hide()
		obj.dropDownCooldown:Hide()
		obj.offset:Hide()
		return obj
	end

end







