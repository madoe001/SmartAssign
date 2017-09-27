


do

	local AssignmentFrame = _G.GUI.AssignmentFrame
	
	local Assignment = _G.GUI.Assignment
	
	local function show(self)
		print("Show wurde aufgerufen")
		self.scrollframe:Show()
		self.scrollbar:Show()
		self.new:Show()
		self.delete:Show()
		for k, v in pairs(self.assignments) do
			v:Show()
		end
	end
	
	local function hide(self)
		print("Hide wurde aufgerufen")
		self.scrollframe:Hide()
		self.scrollbar:Hide()
		self.new:Hide()
		self.delete:Hide()
		for k, v in pairs(self.assignments) do
			v:Hide()
		end
	end


	function AssignmentFrame:new_scrollframe(frame, relativeElement, x, y)
	local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate"),		
			new = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),
			delete = CreateFrame("Button", nil, frame, "OptionsButtonTemplate"),

			content = CreateFrame("Frame", nil),
			assignments = {},
			index = 0,
			lastElement = {},
			Show = show,
			Hide = hide,
			
		}

		obj.content:SetParent(obj.scrollframe)

		obj.new:SetPoint("BOTTOMLEFT", obj.scrollframe, "BOTTOMLEfT", 10, 10)
		obj.new:SetWidth(25)
		obj.new:SetHeight(25)
		obj.new:SetText("+")
		obj.new:SetFrameStrata("HIGH")
		
		obj.delete:SetPoint("BOTTOMLEFT", obj.new, "BOTTOMRIGHT", 0, 0)
		obj.delete:SetWidth(25)
		obj.delete:SetHeight(25)
		obj.delete:SetText("-")
		obj.delete:SetFrameStrata("HIGH")
		
		--obj.new:Hide()
		--obj.delete:Hide()

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
		obj.scrollframe:SetPoint("TOPLEFT",relativeElement, "TOPRIGHT" ,0,0)
		obj.scrollframe:SetPoint( "BOTTOMRIGHT" ,-10, 10)
		obj.scrollframe:EnableMouse(true)
		obj.scrollframe:RegisterForDrag("LeftButton")
		obj.scrollframe:SetScript("OnDragStart",obj.scrollframe.StartMoving)
		obj.scrollframe:SetScript("OnDragStop",obj.scrollframe.StopMovingOrSizing)
		obj.scrollframe:SetHitRectInsets(10,10,10,10)
		obj.content:SetWidth(obj.scrollframe:GetWidth())
		obj.content:SetHeight(200)
		obj.content:SetPoint("TOPLEFT", obj.scrollframe, "TOPLEFT")
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
				local assignment = Assignment:new_assignment(obj.content, relativeElement, obj.index, 100, 0)
				table.insert(obj.assignments, assignment)
				assignment:Show()
				assignment:SetFrameStrata("HIGH")
				if obj.index == 0 then
					assignment.mainFrame:SetPoint("TOP", obj.content)
				obj.lastElement = assignment.mainFrame
				else
					assignment.mainFrame:SetPoint("TOPLEFT", obj.lastElement, "BOTTOMLEFT")
					obj.lastElement = assignment.mainFrame
				end
				obj.index = obj.index + 1
				obj.scrollframe:SetScrollChild(obj.content)
		end)
		
		obj.delete:SetScript("OnClick", function(self, button, down)
				assignment:Show()
				assignment:SetFrameStrata("HIGH")
				obj.scrollframe:SetScrollChild(assignment.mainFrame)
		end)


	return obj.scrollframe
	end	
end
