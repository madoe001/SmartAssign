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
	
	function PlayerAssign:Hide()
		self.abilityCB:Hide()
		self.textCB:Hide()
		self.dropDownPlayer:Hide()
		self.dropDownCooldown:Hide()
		if self.textCB:GetChecked() then
			self.extraText:Hide()
		else
			self.dropDownCooldown:Hide()
		end
		self.offset:Hide()
	end
	
	function PlayerAssign:Show()
		self.abilityCB:Show()
		self.textCB:Show()
		self.dropDownPlayer:Show()
		if self.textCB:GetChecked() then
			self.extraText:Show()
		else
			self.dropDownCooldown:Show()
		end
		self.offset:Show()
	end

	function PlayerAssign:SetPoint(relativeElement, x, y)
		self.x = x
		self.y = y
		
		self.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, self.y)
	
		self.abilityCB:SetPoint("LEFT", self.dropDownPlayer, "RIGHT", self.x, 0)
		self.textCB:SetPoint("TOP", self.abilityCB, "BOTTOM", 0,0)
		self.dropDownCooldown:SetPoint("LEFT", self.abilityCB, "RIGHT", self.x+30,0)
	end

	function PlayerAssign:Delete()
		x = nil
		y = nil
		abilityCB = nil
		textCB = nil
		dropDownPlayer = nil
		dropDownCooldown = nil
		_G["mb1"..self.index] = nil
		_G["mb2"..self.index] = nil
	end

	function PlayerAssign:SetFrameStrata(priority)
		self.abilityCB:SetFrameStrata(priority)
		self.textCB:SetFrameStrata(priority)
		self.dropDownPlayer:SetFrameStrata(priority)
		self.dropDownCooldown:SetFrameStrata(priority)
		self.offset:SetFrameStrata(priority)
	end

	function PlayerAssign:GetPlayerAssign()
		local playerData = {}
		
		playerData["Player"] = UIDropDownMenu_GetText(self.dropDownPlayer)
		if self.abilityCB:GetChecked() then
			playerData["TextOrCoolDown"] = "ability" 
			playerData["Text"] = UIDropDownMenu_GetText(self.dropDownCooldown) or ""
		else
			playerData["TextOrCoolDown"] = "text" or ""
			playerData["Text"] = self.extraText:GetText() or ""
		end
		playerData["offset"] = self.offset:GetText() or ""
		return playerData
	end


	function PlayerAssign:SetPlayerAssign(playerData)
		
		print(playerData["Player"])
		UIDropDownMenu_SetText(self.dropDownPlayer, playerData["Player"])
		if playerData["TextOrCoolDown"] == "ability" then
			self.abilityCB:SetChecked(true)
			self.textCB:SetChecked(false)
			UIDropDownMenu_SetText(self.dropDownCooldown, playerData["Text"])
			self.extraText:Hide()
			self.dropDownCooldown:Show()
		elseif playerData["TextOrCoolDown"] == "text" then
			self.textCB:SetChecked(true)
			self.abilityCB:SetChecked(false)
			self.extraText:SetText(playerData["Text"] )
			self.extraText:Show()
			self.dropDownCooldown:Hide()
		end
		self.offset.label:SetText("")
		self.offset:SetText(playerData["offset"])
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
			dropDownPlayer = createPlayerDropDown(frame, 0, 0, 80, "mb1"..lastElement), 
			dropDownCooldown = {},
			offset = EditBox:LoadEditBox(frame, "offs"..lastElement, "number", "timer"),	
			extraText = CreateFrame("EditBox", "extraText"..lastElement, frame,"InputBoxTemplate"), 
			
			--Klasseamethoden bzw. referenzen drauf
		}
		setmetatable(obj, self)
		self.__index = self
		
		obj.dropDownCooldown = createCooldownDropDown(frame, 0,0, 80, "cooldown"..lastElement, obj.dropDownPlayer)
		obj.extraText:SetWidth(80)
		obj.extraText:SetHeight(50)
		obj.extraText:SetAutoFocus(false)
		obj.extraText.inputType = "String"
		obj.extraText:Hide()
		obj.dropDownCooldown:Hide()
		
		
		obj.abilityCB:SetScript("OnClick", function(self, button, down)
			if obj.textCB:GetChecked() then
				obj.textCB:SetChecked(false)
				obj.extraText:Hide()
			end
			obj.dropDownCooldown:Show()
			obj.offset:Show()
		end) 

		obj.textCB:SetScript("OnClick", function(self, button, down)
			if obj.abilityCB:GetChecked() then
				obj.abilityCB:SetChecked(false)
				obj.dropDownCooldown:Hide()
			end
			obj.extraText:Show()
		end)
		
		obj.offset:SetWidth(60)
		obj.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, obj.y)
		
		obj.abilityCB:SetPoint("LEFT", obj.dropDownPlayer, "RIGHT", obj.x, 0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0,0)
		obj.abilityCB:SetChecked(true)
		
		obj.dropDownCooldown:SetPoint("LEFT", obj.abilityCB, "RIGHT", obj.x+30,0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0,0)
		obj.extraText:SetPoint("LEFT", obj.abilityCB, "RIGHT", obj.x+50,0)
		obj.offset:SetPoint("LEFT", obj.dropDownCooldown, "RIGHT", obj.x, 0)

		obj.abilityCB:Hide()
		obj.textCB:Hide()
		obj.dropDownPlayer:Hide()
		obj.dropDownCooldown:Hide()
		obj.offset:Hide()
		return obj
	end

end







