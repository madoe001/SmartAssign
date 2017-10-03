


do

	local AssignmentFrame = _G.GUI.AssignmentFrame
	
	local Assignment = _G.GUI.Assignment
	
	function AssignmentFrame:Show()
		--print("Show wurde aufgerufen")
		self.scrollframe:Show()
		self.scrollbar:Show()
		self.new:Show()
		self.delete:Show()
		for k, v in pairs(self.assignments) do
			v:Show()
		end
	end
	
	function AssignmentFrame:Hide()
		--print("Hide wurde aufgerufen")
		self.scrollframe:Hide()
		self.scrollbar:Hide()
		self.new:Hide()
		self.delete:Hide()
		for k, v in pairs(self.assignments) do
			v:Hide()
		end
	end
	
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
		print("New last element ", cacheList[#cacheList])
		self.amountAssigns = #cacheList
		
	end


	local function init(self, relativeElement, assigns)
		
		local obj = self
		local counter = 0
		if assigns ~= nil then
		for k,v  in pairs(assigns) do
			print("Last Element: ", obj.lastElement)
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
			end)
			table.insert(obj.deleteButtons, delete)
			obj.scrollframe:SetScrollChild(obj.content)
		end
	end
	end

	function AssignmentFrame:new_scrollframe(frame, relativeElement, x, y)
	
		local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate"),		
			new = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
			content = CreateFrame("Frame", nil),
			assignments = {},
			deleteButtons = {},
			index = 1,
			lastElement = {},
			amountAssigns = 0,
			initAssigns = init,
			save = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
		}
		
		obj.save:SetScript("OnClick", function(self, button, down)
			local counter = 0
			for k, v in pairs(obj.assignments) do
				print(SA_LastSelected.boss)
				SA_Assignments[SA_LastSelected.boss] = {}
				SA_Assignments[SA_LastSelected.boss]["assignment"..counter] = v:GetAssign()
			end
		end)
		obj.save:SetPoint("LEFT", obj.new, "RIGHT", 5 ,0)
		obj.save:SetText("Save")
		obj.save:SetFrameStrata("HIGH")		

		obj.content:SetParent(obj.scrollframe)

		obj.new:SetPoint("BOTTOMLEFT", obj.scrollframe, "BOTTOMLEfT", 10, 10)
		obj.new:SetWidth(25)
		obj.new:SetHeight(25)
		obj.new:SetText("+")
		obj.new:SetFrameStrata("HIGH")
		
		-- Main Test Frame
		obj.scrollframe:SetBackdrop({
			bgFile="Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 4, edgeSize = 32,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		obj.scrollframe:SetBackdropColor(0.0,0.0,0.0,0.4)
		
		--obj.scrollframe:SetSize(300,400)
		obj.scrollframe:ClearAllPoints()
		obj.scrollframe:SetPoint("TOPLEFT",relativeElement, "TOPRIGHT" , 0, -25)
		obj.scrollframe:SetPoint( "BOTTOMRIGHT" ,-10, 10)
		obj.scrollframe:EnableMouse(true)
		obj.scrollframe:RegisterForDrag("LeftButton")
		obj.scrollframe:SetScript("OnDragStart",obj.scrollframe.StartMoving)
		obj.scrollframe:SetScript("OnDragStop",obj.scrollframe.StopMovingOrSizing)
		obj.scrollframe:SetHitRectInsets(10,10,10,10)
		obj.content:SetWidth(obj.scrollframe:GetWidth())
		obj.content:SetHeight(200)
		obj.content:SetPoint("TOPLEFT", obj.scrollframe, "TOPLEFT")
		
		obj.initAssigns(obj, relativeElement, SA_Assignments[SA_LastSelected.boss])
		
		-- Scroll Bar
		obj.scrollbar = CreateFrame("Slider","sb",obj.scrollframe,"UIPanelScrollBarTemplate") 
		obj.scrollbar:SetPoint("TOPLEFT",obj.scrollframe,"TOPRIGHT",5,-20) 
		obj.scrollbar:SetPoint("BOTTOMLEFT",obj.scrollframe,"BOTTOMRIGHT",5,20) 
		obj.scrollbar:SetMinMaxValues(1,200)
		obj.scrollbar:SetValueStep(1) 
		obj.scrollbar.scrollStep = 20
		obj.scrollbar:SetValue(0) 
		obj.scrollbar:SetWidth(16)
		obj.scrollbar:SetScript("OnValueChanged",function(self,value) 
  	    		self:GetParent():SetVerticalScroll(value) 
		end) 

		obj.new:SetScript("OnClick", function(self, button, down)
				print("Last Element: ", obj.lastElement)
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
				end)
				table.insert(obj.deleteButtons, delete)
				obj.scrollframe:SetScrollChild(obj.content)
		end)
	--	obj.new:Hide()

	return obj.scrollframe
	end	
end
