-- @author Maik Dömmecke
--
--Lua Datei, die die Graphischen Elemente für eine Assignment für einen Timer repraesentiert

--Neuer Scope wird angelegt
do
	-- Globale Speicherung der Klasse
	local dropDownAssign = _G.GUI.SA_DropDownList

	-- Benoetigte Klassen lokal holen(nicht zwingend notwendig erspart aber Schreibarbeit) 
	local pa = _G.GUI.PlayerAssignment
	
	local SAL = _G.GUI.Locales

	local checkBox = _G.GUI.SA_CheckBox

	local editBox = _G.GUI.SA_EditBox
			
	local Assignment = _G.GUI.Assignment

	-- Die Funktion dient zum Anzeigen der grafischen Elemente
	function Assignment:Show()
		self.dropDownAssignType:Show()
		self.editTimer:Show()
		self.new:Show()

		for k, v in pairs(self.deleteButtons) do
			v:Show()
		end

		for k, v in pairs(self.playerAssigns) do
			v:Show()
		end
	end

	-- Die Funktion dient zum Verstecken der grafischen Elemente
	function Assignment:Hide()
		self.dropDownAssignType:Hide()
		self.editTimer:Hide()
		self.new:Hide()
		self.mainFrame:Hide()	
		for k, v in pairs(self.deleteButtons) do
			v:Hide()
		end

		for i = 1, #self.playerAssigns, 1 do
			self.playerAssigns[i]:Hide()
		end
	end

	-- lokale Funktionen zum Aktualisieren der grafischen Oberflaeche
	-- Nach jedem Loeschen eines PlayerAssignments wird diese Funktion aufgerufen um die grafische
	-- Positionierung dynamisch zu gestalten
	local function updatePlayerAssignPosition(self, toBeDeletedItem)
		
		-- Zählvariable für die Positionierung
		local counter = 0

		-- Tabelle die als Zwischentabelle genutzt wird.
		-- In dieserm Liste werden alle PlayerAssignments eingetragen bis auf das zu loeschende
		-- Element. Dadurch entsteht indexbasierte Tabelle. (Ermöglicht das Nutzen des Operators für größen von Tabellen (#))
		local cacheList = {}

		-- Durch die Tabelle iterieren um zu schauen ob das Element in der Tabelle ist
		-- Alle Elemente die nicht geloescht werden sollen werden zur Zwischentabelle hinzugefuegt
		for k, v in pairs(self.playerAssigns) do
			if v ~= toBeDeletedItem then
				table.insert(cacheList, v)
			end
		end

		-- Es wird durch die Zwischentabelle iteriert und die Position der noch vorhandenen PlayerAssignments wird
		-- aktualisiert
		for k, v in pairs(cacheList) do
			v:SetPoint(self.editTimer, 0, -100 * counter)
			counter = counter + 1
		end

		-- da in Lua jede Tabelle eine Referenz ist aktualisiere ich 
		-- die PlayerAssigntabelle einfach mit meiner Zwischentabelle.
		-- Durch das Setzen der Tabelle wird das zu loeschende Element nicht mehr referenziert und kann durch den
		-- Garbagecollector von Lua entfernt werden
		self.playerAssigns = cacheList

		-- Die neue Groeße der Liste wird gespeichert
		self.amountPlayer = #cacheList

	end
	
	-- Setzen der Z-Position der grafischen Elemente
	-- @param priority Gibt die Z-Zurdnung an (z.B. "HIGH")
	function Assignment:SetFrameStrata(priority )
		self.dropDownAssignType:SetFrameStrata(priority)
		self.editTimer:SetFrameStrata(priority)
		self.new:SetFrameStrata(priority)
		
		for k, v in pairs(self.deleteButtons) do
			v:SetFrameStrata(priority)
		end
		
		for i = 1, #self.playerAssigns, 1 do
			self.playerAssigns[i]:SetFrameStrata(priority)
		end

	end

	-- Hoehe des Frames zurueckgeben
	-- @return aktuelle Hoehe des Frames 
	function Assignment:GetHeight()
		return self.mainFrame:GetHeight() + 10
	end
	
	-- Die in der grafischen Obeferflaeche eingetragenen Daten werden in eine Tabelle verpackt und zurueckgegeben
	-- @return Tabelle ,die die Daten der grafischen Oberflaeche enthaelt 
	function Assignment:GetAssign()
		local assignmentData = {}

		assignmentData["Type"] = UIDropDownMenu_GetText(self.dropDownAssignType) or ""
		assignmentData["Timer"] = tonumber(self.editTimer:GetText()) or 0

		local index = 1
		assignmentData["assigns"] = {}
		for k, v in pairs(self.playerAssigns) do
			assignmentData["assigns"]["playerAssign" .. index] = v:GetPlayerAssign()
			index = index + 1
		end

		return assignmentData
	end

	-- Setzen des der Werte der grafischen Elemente eines Assignments.
	-- @param assign Tabelle, die die Daten enthaelt fuer die grafische Elemente erzeugt werden sollen
	function Assignment:SetAssign(assign)
		UIDropDownMenu_SetText(self.dropDownAssignType, assign["Type"])
		self.editTimer.label:SetText("")
		self.editTimer:SetText(assign["Timer"])

		local obj = self
		local counter = 0
		obj.playerAssigns = {}
		for k, v in pairs(assign["assigns"]) do
			local playerAssign = pa:new_playerAssign(obj.mainFrame, obj.editTimer, obj.index .. counter, 0, -100 * counter)
			table.insert(obj.playerAssigns, playerAssign)
			
			obj.new:SetPoint("LEFT", obj.editTimer, "RIGHT", 5, -100 * obj.amountPlayer)
			local delete = CreateFrame("Button", "deletePlayerAssign"..#obj.playerAssigns, obj.mainFrame, "OptionsButtonTemplate")
			delete:SetWidth(25)
			delete:SetHeight(25)
			delete:SetText("-")
			local index = obj.counter
			delete:SetPoint("LEFT", playerAssign.offset, "RIGHT", 10, 0)
			local height = obj.mainFrame:GetHeight()
			obj.mainFrame:SetHeight(height + 100)
			playerAssign:SetPlayerAssign(v)
			delete:SetScript("OnClick", function(self, button, down)
				
				updatePlayerAssignPosition(obj, playerAssign)
				self:Hide()
				playerAssign:Hide()
				playerAssign:Delete()
				
				for k, v in pairs(obj.playerAssigns) do
					if v == playerAssign then
						obj.playerAssigns[k] = nil
					end
				end
				
				
				local height = obj.mainFrame:GetHeight()
				
				
				obj.mainFrame:SetHeight(height - 100)
				
				obj.new:SetPoint("LEFT", obj.editTimer, "RIGHT", 5, -100 * obj.amountPlayer)
			end)
			table.insert(obj.deleteButtons, delete)	
			playerAssign:Show()
			counter = counter + 1
		
		end
		obj.amountPlayer = counter
		self.new:SetPoint("LEFT", self.editTimer, "RIGHT", 5, -100 * #self.playerAssigns)

	end

	-- Konstruktor der Klasse
	-- @param frame Parentframe fuer die grafischen Elemente des Assignment
	-- @param relativeElement grafisches Element zu dem das Assignment positioniert werden soll
	-- @param number Nummer des Assignment um einen eindeutigen Globalen Name zu generieren
	-- @param x Abstand in X-Richtung zum relativen Element
	-- @param y Abstand in Yx-Richtung zum relativen Element
	-- @return Referenz auf das erstellte Assignment
	function Assignment:new_assignment(frame, relativeElement, number, x, y)
		
		local obj = {
			xVal = x,
			xVal = y,
			name = "assignment" .. number, 
			mainFrame = CreateFrame("Frame", "assignmentFrame"..number, frame),
			dropDownAssignType = {},
			editTimer = {}, 
			new = {},
			playerAssigns = {},
			deleteButtons = {},
			counter = 1,
			amountPlayer = 0,
			index = number,
		}
		setmetatable(obj, self)
		self.__index = self
	
		obj.editTimer = editBox:LoadEditBox(obj.mainFrame, "editTimer"..obj.index,  "number", "timer")
		obj.new =  CreateFrame("Button", "newPlayerAssign"..obj.index, obj.mainFrame, "OptionsButtonTemplate")
		obj.dropDownAssignType = createAbillityDropDown(obj.mainFrame, 0,0, 100, "smartB" .. obj.index)

		obj.mainFrame:SetWidth(frame:GetWidth() - 20)
		obj.mainFrame:SetHeight(120)
		
		obj.mainFrame:SetBackdrop({
			bgFile="Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 4, edgeSize = 32,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
			});
		obj.mainFrame:SetBackdropColor(0.0,0.0,0.0,0.65)
		
		
		-- DropDownMenu von Ability oder Timer 
		--nur zum nachladen der GUI Elemente
		obj.dropDownAssignType:SetPoint("TOPLEFT", obj.mainFrame, "TOPLEFT", 10, y - 40)
		obj.editTimer:SetPoint("TOPLEFT", obj.dropDownAssignType, "TOPRIGHT", 0, 0)
		obj.editTimer:SetWidth(60)
		obj.new:SetWidth(25)
		obj.new:SetHeight(25)
		obj.new:SetText("+")
		local size = #obj.playerAssigns
		obj.new:SetPoint("LEFT", obj.editTimer, "RIGHT", 5, 0)
		
		obj.new:SetScript("OnClick", function(self, button, down)
			obj.counter = obj.counter + 1 
			
			local playerAssign = pa:new_playerAssign(obj.mainFrame, obj.editTimer, obj.index .. obj.counter, 0, -100 * obj.amountPlayer)
			
			table.insert(obj.playerAssigns, playerAssign)
			
			obj.amountPlayer = obj.amountPlayer + 1
			
			obj.new:SetPoint("LEFT", obj.editTimer, "RIGHT", 5, -100 * obj.amountPlayer)
			local delete = CreateFrame("Button", "deletePlayerAssign"..#obj.playerAssigns, obj.mainFrame, "OptionsButtonTemplate")
			delete:SetWidth(25)
			delete:SetHeight(25)
			delete:SetText("-")
			local index = obj.counter
			delete:SetPoint("LEFT", playerAssign.offset, "RIGHT", 10, 0)
			local height = obj.mainFrame:GetHeight()
			obj.mainFrame:SetHeight(height + 100)
			delete:SetScript("OnClick", function(self, button, down)
				
				updatePlayerAssignPosition(obj, playerAssign)
				playerAssign:Hide()
				playerAssign:Delete()
				
				for k, v in pairs(obj.playerAssigns) do
					if v == playerAssign then
						obj.playerAssigns[k] = nil
					end
				end

				playerAssign = nil
				
				local height = obj.mainFrame:GetHeight()
				
				obj.mainFrame:SetHeight(height - 100)
				self:Hide()
				
				obj.new:SetPoint("LEFT", obj.editTimer, "RIGHT", 5, -100 * obj.amountPlayer)
			end)
			table.insert(obj.deleteButtons, delete)		
			playerAssign:Show()
		end)				
		obj.dropDownAssignType:Hide()
		return obj
	end
		
end

