--Author: Maik Dömmecke
--
--Lua Datei, die die Graphischen Elemente für eine Assignment für einen Timer repräsentiert

--Neuer Scope damits private ist
do
	local dropDownAssign = _G.GUI.SA_DropDownList

	local pa = _G.GUI.PlayerAssignment
	
	local SAL = _G.GUI.Locales

	local checkBox = _G.GUI.SA_CheckBox

	local editBox = _G.GUI.SA_EditBox
			
	local Assignment = _G.GUI.Assignment

	local function show(self)
		--print("show wurde aufgerufen")
		self.dropDownAssignType:Show()
		self.editTimer:Show()
		self.new:Show()
		for k, v in pairs(self.playerAssigns) do
			v:Show()
		end
	end

	local function hide(self)
		self.dropDownAssignType:Hide()
		self.editTimer:Hide()
		for i = 1, #self.playerAssigns, 1 do
			self.playerAssigns[i]:Hide()
		end
		--print("Hide wurde aufgerufen")
	end

	local function OnClick(self)
		if self:GetID() == 1 then
			self.selectedId = SAL["Timer"]
		elseif self:GetID() == 2 then
			 self.selectedId = SAL["Ability"]
		end	
		UIDropDownMenu_SetSelectedID(dropDownAssign, self:GetID())
	end

	local function createTimerAssign(self)
		self.editTimer:SetScript("OnUpdate", function(self, elapsed)
			if(self:GetText() ~= "" or self:GetText() ~= 0) then
				--print("Text edited")
			end
		end)
		--Positionierung der grafischen Elemente
		--am linken Rand ausgerichtet, 
		--rechts von dem angegebenen Element zum Beispiel das EditField	
		self.editTimer:SetPoint("Left", self.dropDownAssignType, "RIGHT", xVal, yVal )
		editBox:SetMaxLetters(self.editTimer, 6)	
		self.editTimer:Show()	
		if #self.playerAssigns == 0 then
			table.insert(self.playerAssigns, pa:new_playerAssign(self.mainFrame, self.editTimer, 0, 0,0))
		end			
	end
	
	local function updatePlayerAssignPosition(self, toBeDeletedItem)
		local foundElement = false
		local counter = 0
		local ctr = -1
		for k, v in pairs(self.playerAssigns) do
			if foundElement == true then
			
				v:SetPoint( self.dropDownAssignType,  0, -80 * counter)
				print("Counter: "..counter)
				counter = counter + 1
			end
			if v == toBeDeletedItem then
				foundElement = true
			elseif foundElement ~= true then
				counter = counter + 1
			end
			ctr = ctr +1
		end
		print("Anzahl geupdatet: "..ctr)
	end
	

	local function setPoint(self, relativeElement, offsetx, offsety)

	end

	function Assignment:new_assignment(frame, relativeElement, x, y)
		local obj = {
			xVal = x,
			xVal = y,
			mainFrame = CreateFrame("Frame", nil, frame),
			dropDownAssignType = dropDownAssign:LoadDropDownList(mainFrame,"smartB1", dropDownAssign.data, function(self) 
				local info = UIDropDownMenu_CreateInfo()
				for key, value in pairs(self.data) do
					info = UIDropDownMenu_CreateInfo()
					info.text = value
					info.value = value
					info.func = OnClick
					UIDropDownMenu_AddButton(info, level)
				end
			end),
			new = CreateFrame("Button", "newPlayerAssign", mainFrame, "OptionsButtonTemplate"),
			editTimer = editBox:LoadEditBox(frame, "editTimer",  "number"),
			playerAssigns = {},
			deleteButtons = {},
			counter = 1,
			amountPlayer = 0,
			
			SetPoint = setPoint,
			Hide = hide,
			Show = show, 
		}
		--obj.mainFrame:SetPoint("LEFT", obj.dropDownAssignType, "RIGHT", 0 , 0)
		obj.mainFrame:SetWidth(100)
		obj.mainFrame:SetHeight(100)

		obj.new:SetPoint("CENTER", 0, 0)
		-- DropDownMenu von Ability oder Timer 
		--nur zum nachladen der GUI Elemente
		obj.dropDownAssignType:SetScript("OnUpdate", function(self, elapsed)
			if dropDownAssign:GetSelectedID(self) == 1 then
				if #obj.playerAssigns == 0 then
					table.insert(obj.playerAssigns, pa:new_playerAssign(obj.mainFrame, obj.editTimer, 0, 10,0))
				end
				createTimerAssign(obj)
			elseif dropDownAssign:GetSelectedID(self) == 2 then
		
			end
		end)			
		
		obj.dropDownAssignType:SetPoint("Left", relativeElement, "TOPRIGHT", x, y)
		
		obj.new:SetWidth(25)
		obj.new:SetHeight(25)
		obj.new:SetText("+")
		local size = #obj.playerAssigns
		obj.new:SetPoint("LEFT", obj.dropDownAssignType, "RIGHT", 50, 0)
		
		obj.new:SetScript("OnClick", function(self, button, down)
			obj.counter = obj.counter + 1 
			obj.playerAssigns[obj.counter] = pa:new_playerAssign(obj.mainFrame, obj.dropDownAssignType, obj.counter, 0, -80 * obj.amountPlayer)
			obj.amountPlayer = obj.amountPlayer + 1
			
			obj.new:SetPoint("LEFT", obj.dropDownAssignType, "RIGHT", 50, -80 * obj.amountPlayer)
			--obj.new:SetPoint("TOP", obj.playerAssigns[obj.counter].dropDownPlayer, "BOTTOMLEFT", 30, -30)
			local delete = CreateFrame("Button", "deletePlayerAssign"..#obj.playerAssigns, obj.mainFrame, "OptionsButtonTemplate")
			delete:SetWidth(25)
			delete:SetHeight(25)
			delete:SetText("-")
			local index = obj.counter
			print("index:"..index)
			delete:SetPoint("LEFT", obj.playerAssigns[index].offset, "RIGHT", 10, 0)
			delete:SetScript("OnClick", function(self, button, down)
				
				updatePlayerAssignPosition(obj, obj.playerAssigns[index])
				obj.amountPlayer = obj.amountPlayer - 1
				obj.playerAssigns[index]:Hide()
				obj.playerAssigns[index]:Delete()
				obj.playerAssigns[index] = nil
				self:Hide()
				
				obj.new:SetPoint("LEFT", obj.dropDownAssignType, "RIGHT", 50, -80 * obj.amountPlayer)
				self = nil
			end)
			table.insert(obj.deleteButtons, delete)			
		end)
				
		obj.dropDownAssignType:Hide()
		return obj
	end
	
		
end

