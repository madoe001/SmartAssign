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
		self.editTimer:Show()
	end

	local function hide(self)
		self.editTimer:Hide()
	end

	local function complete(self)
		return self.compl
	end

	function Assignment:new_assignment(frame, relativeElement, x, y)
			
		local obj = {
			xVal = x,
			yVal = y,
			compl = 0,
			dropDownAssignType = dropDownAssign:Load
			editTimer = editBox:LoadEditBox(frame, "number"),
			cb = checkBox:LoadCheckBox(frame, "test"),
			Hide = hide,
			Show = show, 
		}


		--Anonyme function zum an- und auschalten der restlichen Elemente
		obj.editTimer:SetScript("OnUpdate", function(self, elapsed)
			if(self:GetText() == "" or self:GetText() == 0) then
				obj.cb:Hide()
			else
				obj.cb:Show(dropDownAssign:Load)
			end
		end)				
		
		--Positionierung der grafischen Elemente
		--am linken Rand ausgerichtet, 
		--rechts von dem angegebenen Element zum Beispiel das EditField	
		obj.editTimer:SetPoint("Left", relativeElement, "RIGHT", xVal, yVal )
		obj.cb:SetPoint("Left", obj.editTimer, "RIGHT", xVal, yVal)
		
		--grafische Elemente am Anfang ausschalten
		obj.cb:Hide()

		return obj
	end
end

