--Author: Maik Dömmecke
--
--Lua Datei, die die Graphischen Elemente für eine Assignment für einen Timer repräsentiert

--Neuer Scope damits private ist
do
	local dropDownAssign = _G.GUI.SA_DropDownList

	local pa = _G.GUI.PlayerAssignment

	local checkBox = _G.GUI.SA_CheckBox

	local editBox = _G.GUI.SA_EditBox
			
	local Assignment = _G.GUI.Assignment

	local function show(self)
		--print("show wurde aufgerufen")
		self.dropDownAssignType:Show()
		self.editTimer:Show()
		for i = 1, #self.playerAssigns, 1 do
			self.playerAssigns[i]:Show()
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
		if self:GetID() == 2 then
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
			editTimer = editBox:LoadEditBox(frame, "editTimer",  "number"),
			playerAssigns = {},
			Hide = hide,
			Show = show, 
		}
		obj.mainFrame:SetPoint("LEFT", relativeElement, "RIGHT", 0 , 0)

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
		
		obj.dropDownAssignType:SetPoint("Left", relativeElement, "RIGHT", xVal, yVal)
		table.insert(obj.playerAssigns, pa:new_playerAssign(obj.mainFrame, obj.dropDownAssignType , #obj.playerAssigns, 20,0))

		table.insert(obj.playerAssigns, pa:new_playerAssign(obj.mainFrame, obj.dropDownAssignType, #obj.playerAssigns, 20, -80))
		obj.dropDownAssignType:Hide()
		return obj
	end
end

