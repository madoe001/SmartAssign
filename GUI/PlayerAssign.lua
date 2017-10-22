--- @author Maik Dömmecke
--
-- Klasse, zum einteilen eines Spielers. 
-- Mit Hilfe dieser Klasse soll es Möglich sein eine Liste von Spielern in einem Dropdownmenu angezeigt zu bekommen
-- im Anschluss soll ausgewählt werden können was der Spieler bei einer Bossfähigkeit oder bei einem bestimmtetn Timer machen soll
	--entweder eine ability benutzen oder dem Spieler wird ein extra Text angezeigt um zum Beispiel den Spieler dazu zu bewegen sich
	--an eine bestimmte Stelle zu bewegen
-- Zuletzt soll ein Offset eingestellt werden können um zum Beispiel bei einem Timer genügend Zeit zur Verfügung gestellt zu bekommen eine Fähigkeit zu Nutzen
-- Siehe GUI-Bilder


do 
	-- Globale Speicherung der Klasse
	local PlayerAssign = _G.GUI.PlayerAssignment	

	-- Benötigte Klassen lokal holen(nicht zwingend notwendig erspart aber Schreibarbeit) 
	local CheckBox = _G.GUI.SA_CheckBox
	
	local DropDownList = _G.GUI.SA_DropDownList
	
	local EditBox = _G.GUI.SA_EditBox
	
	--- Die Funktion dient zum verschwinden lassen der Grafischen Elemente eines PlayerAssignment
	-- @param subs The replacement pattern.
	-- @param find The pattern to find.
	function PlayerAssign:Hide()
		self.abilityCB:Hide()
		self.textCB:Hide()
		self.dropDownPlayer:Hide()
		self.dropDownCooldown:Hide()	
		self.playerString:Hide()
		self.offsetString:Hide()
		self.actionString:Hide()
		if self.textCB:GetChecked() then
			self.extraText:Hide()
		else
			self.dropDownCooldown:Hide()
		end
		self.offset:Hide()
	end
	
	--- Die Funktion dient zum anzeigen lassen der Grafischen Elemente eines PlayerAssignment
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

	--- Setzen der Grafischen Elemente eines PlayerAssignment an eine bestimmte Position
	-- @param relativeElement Element zu dem das PlayerAssignment ausgerichtet werden soll
	-- @param x Gibt den Abstand zum Relativen Element in X-Richtung an
	-- @param y Gibt den Abstand zum Relativen Element in Y-Richtung an
	function PlayerAssign:SetPoint(relativeElement, x, y)
		self.x = x
		self.y = y
		
		self.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, self.y)
	
		self.abilityCB:SetPoint("LEFT", self.dropDownPlayer, "RIGHT", self.x, 0)
		self.textCB:SetPoint("TOP", self.abilityCB, "BOTTOM", 0,0)
		self.dropDownCooldown:SetPoint("LEFT", self.abilityCB, "RIGHT", self.x+30,0)
	end

	--- Löschen eines PlayerAssignment inklusive der grafischen Elemente. 
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

	--- Setzt die Z-Stelligkeit der grafischen Elemente eines PlayerAssigns. 
	-- @param priority Ist die Stelligkeit in Form eines Strings (z.B. "HIGH")
	function PlayerAssign:SetFrameStrata(priority)
		self.abilityCB:SetFrameStrata(priority)
		self.textCB:SetFrameStrata(priority)
		self.dropDownPlayer:SetFrameStrata(priority)
		self.dropDownCooldown:SetFrameStrata(priority)
		self.offset:SetFrameStrata(priority)
	end

	--- Verpackt die in der Grafischen Oberfläche eingetragenen Daten in eine Tabelle und gibt diese zurück
	-- @return Daten des PlayerAssignment als Tabelle
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

	--- Werte der Grafischen Elemente werden gesetzt
	-- @param playerData Daten die in die grafischen Elemente eingetragen werden sollen
	function PlayerAssign:SetPlayerAssign(playerData)
		
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

	-- Function zum Erstellen eines Schriftzug auf der grafischen Obberfläche
	-- lokale Funktion wird nicht weiter beschrieben
	local function createFont(frame, name, text, relativeElement, fontString, height)
		local font = frame:CreateFontString(name)
		font:SetPoint("BOTTOM", relativeElement, "TOP")
		font:SetFont(fontString, height )
		font:SetText(text)
		return font
	end

	--- Konstruktor der Klasse PlayerAssign 
	-- Es wird ein Objekt der Klasse erzeugt, initialisiert und zurückgegeben
	-- @param frame ParentFrame des PlayerAssignment
	-- @param relativeElement Wird zur Positionierung der PlayerAssignment genutzt
	-- @param lastElement Index zum erstellen eines eindeutigen globalen Namen für das PlayerAssignment
	-- @param xVal Abstand des PlayerAssignment zum relativen Element in X-Richtung
	-- @param yVal Abstand des PlayerAssignment zum relativen Element in Y-Richtung
	-- @return Referenz auf das erstellte PlayerAssignment 
	function PlayerAssign:new_playerAssign(frame, relativeElement,lastElement, xVal, yVal)
		
		local obj = {
			--Klassenattribute
			x = xVal,
			y = yVal,
			mainFrame = frame,
			index = lastElement,
			
			-- Erstellen einer Checkbox mit dem Text Ability 
			-- Genaue Doku siehe CheckBox.lua
			abilityCB = CheckBox:LoadCheckBox(frame, "Ability"),
			
			-- Erstellen einer Checkbox mit dem Text Extra Text
			-- Genaue Doku siehe CheckBox.lua
			textCB = CheckBox:LoadCheckBox(frame, "Extra Text"),
			
			-- Erstellen eines DropDownmenu zum Auswählen der sich in der Gruppe oder im Raid befindlichen spieler				      -- Genaue Doku siehe DropDowns.lua
			dropDownPlayer = createPlayerDropDown(frame, 0, 0, 100, "mb1"..lastElement), 
			dropDownCooldown = {},
			
			-- Erstellen einer EditBox in der nur Zahlen eintragbar sind
			-- Genaue Doku siehe EditBox.lua
			offset = EditBox:LoadEditBox(frame, "offs"..lastElement, "number", "offset"),	

			-- Erstellen eines Textfelds in dem ein anzuzeigender Text eingetragen werden kann 
			extraText = CreateFrame("EditBox", "extraText"..lastElement, frame,"InputBoxTemplate"), 
			playerString = {},
			offsetString = {},
			actionString = {},
		}

		-- Setzen der Metatabelle des Objekts 
		-- Durch den Aufruf wird erzeugt das dem Objekt die Funktionen der Tabelle PlayerAssign zugeordnet werden
		setmetatable(obj, self)
		self.__index = self
		
		-- Erzeugen eiens Dropdown menu
		-- Siehe Oben oder DropDowns.lua
		obj.dropDownCooldown = createCooldownDropDown(frame, 0,0, 100, "cooldown"..lastElement, obj.dropDownPlayer)

		-- Konfigurieren des Textfelds
		obj.extraText:SetWidth(100)
		obj.extraText:SetHeight(50)
		obj.extraText:SetAutoFocus(false)
		obj.extraText.inputType = "String"
		obj.extraText:Hide()
		obj.dropDownCooldown:Hide()
		
		-- Skripte der Checkboxen setzen 
		-- Es wird ein Comboxbox ähnliches Verhalten erzeugt
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
		
		--weitere Konfigurationen und Positionierungen
		obj.offset:SetWidth(60)
		obj.dropDownPlayer:SetPoint("LEFT", relativeElement, "RIGHT", 0, obj.y)

		--Erzeugen von Texten auf der GUI
		obj.playerString = createFont(obj.mainFrame, "player"..obj.index, Player_String, obj.dropDownPlayer, "Fonts\\MORPHEUS.ttf", 15)
		obj.actionString = createFont(obj.mainFrame, "action"..obj.index, Action_String, obj.dropDownCooldown, "Fonts\\MORPHEUS.ttf", 15)
		obj.offsetString = createFont(obj.mainFrame, "offset"..obj.index, Offset_String , obj.offset, "Fonts\\MORPHEUS.ttf", 15)
	
		--weitere Konfigurationen und Positionierungen
		obj.abilityCB:SetPoint("LEFT", obj.dropDownPlayer, "RIGHT", obj.x, 0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0,0)
		obj.abilityCB:SetChecked(true)
		
		obj.dropDownCooldown:SetPoint("LEFT", obj.abilityCB, "RIGHT", obj.x+30,0)
		obj.textCB:SetPoint("TOP", obj.abilityCB, "BOTTOM", 0,0)
		obj.extraText:SetPoint("LEFT", obj.abilityCB, "RIGHT", obj.x+50,0)
		obj.offset:SetPoint("LEFT", obj.dropDownCooldown, "RIGHT", obj.x, 0)

		-- Zu Beginn sollen die Grafischen Elemente versteckt
		obj.abilityCB:Hide()
		obj.textCB:Hide()
		obj.dropDownPlayer:Hide()
		obj.dropDownCooldown:Hide()
		obj.offset:Hide()
		return obj
	end

end







