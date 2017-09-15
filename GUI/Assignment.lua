--Author: Maik Dömmecke
--
--Lua Datei, die die Graphischen Elemente für eine Assignment für einen Timer repräsentiert

--Neuer Scope damits private ist
do
	local dropDownAssign = _G.GUI.SA_DropDownList

	local checkBox = _G.GUI.SA_CheckBox

	local editBox = _G.GUI.SA_EditBox
			
	local Assignment = _G.GUI.Assignment

	local function show(self)
		--print("show wurde aufgerufen")
		self.dropDownAssignType:Show()
	end

	local function hide(self)
		self.dropDownAssignType:Hide()
		self.editTimer:Hide()
		--print("Hide wurde aufgerufen")
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
	end

	local function createAbilityAssign(self)
		for key, value in pairs(getAbillities("")) do 
			print(value)
		end	
	end

	function Assignment:new_assignment(frame,  relativeElement, x, y)
			
		local obj = {
			xVal = x,
			yVal = y,
			dropDownAssignType = dropDownAssign:LoadDropDownList(frame, dropDownAssign.data), 
			editTimer = editBox:LoadEditBox(frame, "number"),
			--bn = bossName,
			--en = expansionName,
			--rn = raidName,
			mainFrame = frame,
			Hide = hide,
			Show = show, 
		}

		obj.dropDownAssignType:SetScript("OnUpdate", function(self, elapsed)

			if dropDownAssign:GetSelectedID(self) == 1 then
		--		createTimerAssign(obj)
				createAbilityAssign()
			elseif dropDownAssign:GetSelectedID(self) == 2 then
				--createAbilityAssign()
				createTimerAssign(obj)
			end
		end)			
	
		
		obj.dropDownAssignType:SetPoint("Left", relativeElement, "RIGHT", xVal, yVal)
		return obj
	end
end

