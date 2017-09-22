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

	local function setPoint(self, relativeElement, x, y)
		self.x = x
		self.y = y
		
		self.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, self.y)
	
		self.abilityCB:SetPoint("LEFT", self.dropDownPlayer, "RIGHT", self.x, 0)
		self.textCB:SetPoint("TOP", self.abilityCB, "BOTTOM", 0,0)
		self.dropDownCooldown:SetPoint("LEFT", self.abilityCB, "RIGHT", self.x+30,0)
	end

	local function delete(self)
		x = nil
		y = nil
		abilityCB = nil
		textCB = nil
		dropDownPlayer = nil
		dropDownCooldown = nil
		_G["mb1"..self.index] = nil
		_G["mb2"..self.index] = nil
	end

	local function strata(self, priority)
		self.abilityCB:SetFrameStrata(priority)
		self.textCB:SetFrameStrata(priority)
		self.dropDownPlayer:SetFrameStrata(priority)
		self.dropDownCooldown:SetFrameStrata(priority)
		self.offset:SetFrameStrata(priority)
	end


	function PlayerAssign:new_playerAssign(frame, relativeElement,lastElement, xVal, yVal)
		
		local obj = {
			--Klassenattribute
			x = xVal,
			y = yVal,
			mainFrame = frame,
			index = lastElement,

			abilityCB = CheckBox:LoadCheckBox(frame, "Ability"),
			textCB = CheckBox:LoadCheckBox(frame, "Extra Text"),
			dropDownPlayer = DropDownList:LoadDropDownList(frame,"mb1" .. lastElement,  {"p1", "p2", "p3"}),
			dropDownCooldown = DropDownList:LoadDropDownList(frame,"mb2" .. lastElement, {"a1", "a2", "a3"}),
			offset = EditBox:LoadEditBox(frame, "offs"..lastElement, "number"),	
			
			--Klasseamethoden bzw. referenzen drauf
			Hide = hide,
			Show = show,
			SetFrameStrata = strata,
			SetPoint = setPoint,
			Delete = delete
		}
		setmetatable(obj, self)
		self.__index = self
		
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
		
		--obj.offset:SetMaxLetters(obj.offset, 6) 

		obj.offset:SetWidth(60)
		obj.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, obj.y)
		UIDropDownMenu_SetWidth(obj.dropDownPlayer, 50)
		
		obj.abilityCB:SetPoint("LEFT", obj.dropDownPlayer, "RIGHT", obj.x, 0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0,0)
		obj.dropDownCooldown:SetPoint("LEFT", obj.abilityCB, "RIGHT", obj.x+30,0)
		UIDropDownMenu_SetWidth(obj.dropDownCooldown, 50)
		obj.offset:SetPoint("LEFT", obj.dropDownCooldown, "RIGHT", obj.x, 0)

		obj.abilityCB:Hide()
		obj.textCB:Hide()
		obj.dropDownPlayer:Hide()
		obj.dropDownCooldown:Hide()
		obj.offset:Hide()
		return obj
	end

end







