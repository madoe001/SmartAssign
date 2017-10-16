--- @author Maik Doemmecke
-- Mit Hilfe dieser Klasse wird ein Fenster erzeugt, das zum Erstellen von Assignments dient.
-- Die Assignments werden in einer Liste dargestellt.
-- In der Liste besteht die Möglichkeit zu Scrollen
do
	-- Globale Klasse zuweisen
	local AssignmentFrame = _G.GUI.AssignmentFrame
	
	-- Weitere Klassen lokal holen(ersparrt Schreibarbeit)
	local Assignment = _G.GUI.Assignment
	
	--- Anzeigen der grafischen Elemente sowie der Assignments
	function AssignmentFrame:Show()
		self.scrollframe:Show()
		self.scrollbar:Show()
		self.new:Show()
		self.delete:Show()
		for k, v in pairs(self.assignments) do
			v:Show()
		end
	end
	
	--- Verstecken der grafischen Elemente sowie der Assignments
	function AssignmentFrame:Hide()
		self.scrollframe:Hide()
		self.scrollbar:Hide()
		self.new:Hide()
		self.delete:Hide()
		for k, v in pairs(self.assignments) do
			v:Hide()
		end
	end	
	
	-- lokale Funktion zum bereinigen des Frames. 
	-- Nach Aufruf der Funktion enthält der Frame keine Daten mehr und der Frame muss mit neuen Daten gefuellt werden
	local function clearFrame(obj)
			for k, v in pairs(obj.assignments) do
				v:Hide()
				v = nil
			end
			for k, v in pairs(obj.deleteButtons) do
				v:Hide()
				v = nil
			end
			obj.deleteButtons = {}
			obj.assignments = {}
			obj.amountAssigns = 0
	end

	--- Wenn ein neuer Boss in dem Menü ausgewaehlt wird, muss der Frame bereinigt werden und die Daten fuer den 
	-- ausgewaehlten Boss muessen geladen werden 
	function AssignmentFrame:SetFrameData()
		
		clearFrame(self)

		local encounterID = SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID 			
		self.initAssigns(self, relativeElement, SA_Assignments[SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID])
	end

	-- lokale Funktionen zum Aktualisieren der grafischen Oberflaeche
	-- Nach jedem Loeschen eines Assignments wird diese Funktion aufgerufen um die grafische
	-- Positionierung dynamisch zu gestalten
	-- Druch die Funktione bleiben die Eintraege der Liste zusammenhaengend. 
	local function updateAssignmentFrame(self, toBeDeleted)
		local foundElement = false
		local cacheList = {}
		local ctr = 1		

		for k, v in pairs(self.assignments) do
			if v ~= toBeDeleted then
				table.insert(cacheList, v)
			end
		end

		for k, v in pairs(cacheList) do
			if ctr == 1 then
				v.mainFrame:SetPoint("TOPLEFT", self.content, "TOPLEFT", 10, -10)
			else
				v.mainFrame:SetPoint("TOPLEFT", cacheList[ctr - 1].mainFrame, "BOTTOMLEFT")
			end
			ctr = ctr + 1
		end
		self.assignments = cacheList	
		
		if #cacheList > 0 then
			self.lastElement = cacheList[#cacheList].mainFrame
		end
		self.amountAssigns = #cacheList
		
	end

	-- Lokale Funktion zum Initialisieren des Frames
	-- @param self Das Objekt das initialisiert werden soll, in diesem Fall der AssignmentFrame
	-- @param relativeElement Element zu dem das Fenster positioniert werden soll
	-- @param assigns Tabelle in der sich die Daten der darzustellenden Assignments befinden 
	local function init(self, relativeElement, assigns)
		local obj = self
		local counter = 0
		
		if assigns ~= nil then
		for k,v  in pairs(assigns) do
			local assignment = Assignment:new_assignment(obj.content, relativeElement, obj.index, 0, 0)
			table.insert(obj.assignments, assignment)
			assignment:Show()
			assignment:SetFrameStrata("HIGH")
			if obj.amountAssigns == 0 then
				assignment.mainFrame:SetPoint("TOP", obj.content, 0, -10)
				obj.lastElement = assignment.mainFrame
			else
				assignment.mainFrame:SetPoint("TOPLEFT", obj.lastElement, "BOTTOMLEFT")
				obj.lastElement = assignment.mainFrame
			end

			obj.index = obj.index + 1
			obj.scrollframe:SetScrollChild(obj.content)
			local delete = CreateFrame("Button", nil, assignment.mainFrame, "OptionsButtonTemplate")
			delete:SetPoint("BOTTOMLEFT", assignment.mainFrame, "BOTTOMLEFT", 10, 10)
			delete:SetWidth(25)
			delete:SetHeight(25)
			delete:SetText("-")
			delete:SetFrameStrata("HIGH")
			obj.amountAssigns = obj.amountAssigns + 1
			assignment:SetAssign(v)
			delete:SetScript("OnClick", function(self, button, down)	
				assignment:Hide()
				self:Hide()
				updateAssignmentFrame(obj, assignment)
				for k, v in pairs(obj.assignments) do
					if v == assignment then
						obj.assignments[v] = nil
					end
				end

			
			end)
			table.insert(obj.deleteButtons, delete)
			obj.scrollframe:SetScrollChild(obj.content)
		end
	end
	end


	--- Konstruktor zum Erstellen des Listenfenster
	-- @param frame ParentFrame des AsssignmentFrame (normalerweise UIParent oder selbst erstellter Frame)
	-- @param relativeElement Grafisches Element zu dem der Frame positioniert weden soll
	-- @param x Abstand in X-Richtung zum relativen Element
	-- @param y Abstand in Y-Richtung zum relativen Element
	-- @return Referenz auf den AssignmentFrame
	function AssignmentFrame:new_scrollframe(frame, relativeElement, x, y)
	
		local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate"),		
			new = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
			content = CreateFrame("Frame", nil),
			send = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
			assignments = {},
			deleteButtons = {},
			index = 1,
			lastElement = {},
			amountAssigns = 0,
			initAssigns = init,
			save = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
		}
		setmetatable(obj, self)
		self.__index = self

		obj.send:SetPoint("TOPLEFT", obj.scrollframe, "BOTTOMLEFT", 5 , -5)
		obj.send:SetWidth(75)
		obj.send:SetText(Send_String)
		obj.send:SetHeight(25)
		obj.send:SetFrameStrata("HIGH")		


		obj.save:SetPoint("TOPRIGHT", obj.scrollframe, "BOTTOMRIGHT", -5 , -5)
		obj.save:SetWidth(75)
		obj.save:SetText(Save_String)
		obj.save:SetHeight(25)
		obj.save:SetFrameStrata("HIGH")		

		obj.content:SetParent(obj.scrollframe)

		obj.new:SetPoint("RIGHT", obj.save, "LEFT", -5, 0)
		obj.new:SetWidth(75)
		obj.new:SetHeight(25)
		obj.new:SetText(New_String)
		obj.new:SetFrameStrata("HIGH")
		
		-- Main Test Frame
		obj.scrollframe:SetBackdrop({
			bgFile="Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 4, edgeSize = 20,
			insets = { left = 2, right = 2, top = 2, bottom = 4 }
		})
		obj.scrollframe:SetBackdropColor(0.0,0.0,0.0,0.4)
		
		obj.scrollframe:ClearAllPoints()
		obj.scrollframe:SetPoint("TOPLEFT",relativeElement, "TOPRIGHT" , 0, -30)
		obj.scrollframe:SetPoint( "BOTTOMRIGHT" , -10, 50)
		obj.scrollframe:EnableMouse(true)
		obj.scrollframe:RegisterForDrag("LeftButton")
		obj.scrollframe:SetScript("OnDragStart",obj.scrollframe.StartMoving)
		obj.scrollframe:SetScript("OnDragStop",obj.scrollframe.StopMovingOrSizing)
		obj.scrollframe:SetHitRectInsets(10,10,10,10)
		obj.content:SetWidth(obj.scrollframe:GetWidth())
		obj.content:SetHeight(200)
		obj.content:SetPoint("TOPLEFT", obj.scrollframe, "TOPLEFT")
		
		if  SA_BossList[SA_LastSelected.expansion] and SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid] and SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss] then
			obj.initAssigns(obj, relativeElement, SA_Assignments[SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID])
		else 
			obj.initAssigns(obj, relativeElement, {})
		end
		
		-- Scroll Bar
		obj.scrollbar = CreateFrame("Slider","sb",obj.scrollframe,"UIPanelScrollBarTemplate") 
		obj.scrollbar:SetPoint("TOPRIGHT",obj.scrollframe,"TOPRIGHT",-5,-20) 
		obj.scrollbar:SetPoint("BOTTOMRIGHT",obj.scrollframe,"BOTTOMRIGHT",-5,20) 
		obj.scrollbar:SetMinMaxValues(1,2000)
		obj.scrollbar:SetValueStep(1) 
		obj.scrollbar.scrollStep = 1
		obj.scrollbar:SetValue(0) 
		obj.scrollbar:SetWidth(16)
		obj.scrollbar:SetScript("OnValueChanged",function(self,value) 
  	    		self:GetParent():SetVerticalScroll(value) 
		end) 	

		obj.save:SetScript("OnClick", function(self, button, down)
			if IsInRaid() or IsInGroup() then
			local counter = 0
			local encounterID = SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID 			
			SA_Assignments[encounterID] = {}
			SA_WEAKAURA[encounterID..""] = {}
			for k, v in pairs(obj.assignments) do
				local assign = v:GetAssign()
				local name = "assignment" .. v.index
				if not SA_Assignments[encounterID] then
					SA_Assignments[encounterID] = {}
				end
				if not SA_Assignments[encounterID][name] then
					SA_Assignments[encounterID][name] = {}
				end
				SA_Assignments[encounterID][name] = assign
				
				for plk, plv in pairs(v.playerAssigns) do
					local class = UnitClass(UIDropDownMenu_GetText(plv.dropDownPlayer))
					local classCooldowns = SA_Cooldowns[class]
					local spellid = 0
					for ck, cv in pairs(classCooldowns) do
						if cv["Name"] == UIDropDownMenu_GetText(plv.dropDownCooldown) then
							spellid = cv["SpellID"]
						end
					end
				end
					counter = counter + 1
				end
			end
		end)	
		
		obj.send:SetScript("OnClick", function(self, button, down)
			
			--Bevor gesendet wird soll gespeichert werden
			obj.save:GetScript("OnClick")()
			local encounterID = SA_BossList[SA_LastSelected.expansion][SA_LastSelected.raid][SA_LastSelected.boss].encounterID 			
			for k, v in pairs(obj.assignments) do
				
				local assign = v:GetAssign()
				local name = "assignment"..v.index

				for plk, plv in pairs(v.playerAssigns) do
					local class = UnitClass(UIDropDownMenu_GetText(plv.dropDownPlayer))
					local classCooldowns = SA_Cooldowns[class]
					local spellid = 0
					for ck, cv in pairs(classCooldowns) do
						if cv["Name"] == UIDropDownMenu_GetText(plv.dropDownCooldown) then
							spellid = cv["SpellID"]
						end
					end
					caricWrite("", UIDropDownMenu_GetText(plv.dropDownPlayer), "assignment"..v.index, spellid, assign["Timer"], encounterID)
				end
			end

		end)


		obj.new:SetScript("OnClick", function(self, button, down)
				local assignment = Assignment:new_assignment(obj.content, relativeElement, obj.index, 0, 0)
				table.insert(obj.assignments, assignment)
				assignment:Show()
				assignment:SetFrameStrata("HIGH")
				if obj.amountAssigns == 0 then
					assignment.mainFrame:SetPoint("TOP", obj.content, 0, -10)
				obj.lastElement = assignment.mainFrame
				else
					assignment.mainFrame:SetPoint("TOPLEFT", obj.lastElement, "BOTTOMLEFT")
					obj.lastElement = assignment.mainFrame
				end
				obj.index = obj.index + 1
				obj.scrollframe:SetScrollChild(obj.content)
			
				local delete = CreateFrame("Button", nil, assignment.mainFrame, "OptionsButtonTemplate")
				delete:SetPoint("BOTTOMLEFT", assignment.mainFrame, "BOTTOMLEFT", 10, 10)
				delete:SetWidth(25)
				delete:SetHeight(25)
				delete:SetText("-")
				delete:SetFrameStrata("HIGH")

				obj.amountAssigns = obj.amountAssigns + 1	
				delete:SetScript("OnClick", function(self, button, down)
					assignment:Hide()
					self:Hide()
					updateAssignmentFrame(obj, assignment)
					for k, v in pairs(obj.assignments) do
						if v == assignment then
							obj.assignments[v] = nil
						end
					end
				end)
				table.insert(obj.deleteButtons, delete)
				obj.scrollframe:SetScrollChild(obj.content)
		end)

	return obj
	end	
end
