


do

	local Assignmentframe = _G.GUI.AssignmentFrame
	
	local Assignment = _G.GUI.Assignment
	
	local function show(self)
		self.scrollframe:Show()
		self.scrollbar:Show()
		self.new:Show()
		self.delete:Show()
		
		for k, v in pairs(self.assignments) do
			v:Show()
		end
	end
	
	local function hide(self)
		self.scrollframe:Hide()
		self.scrollbar:Hide()
		self.new:Hide()
		self.delete:Hide()
		for k, v in pairs(self.assignments) do
			v:Hide()
		end
	end


	function Assignmentframe:new_scrollframe(frame, relativeElement, x, y)
	local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate"),		
			new = CreateFrame("Button", "newAssignment", scrollframe, "OptionsButtonTemplate"),
			delete = CreateFrame("Button", "deleteAssignment", scrollframe, "OptionsButtonTemplate"),

			assignments = {},
			Show = show,
			Hide = hide,
			
		}



		obj.new:SetScript("OnClick", function(self, button, down)
				local assignment = Assignment:new_assignment(obj.scrollframe, obj.scrollframe, -10, 10)
				table.insert(obj.assignments, assignment)
				--obj.scrollframe:SetScrollChild(assignment)
		end)
		obj.scrollframe:SetScrollChild(obj.assignments[1])
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
		
		obj.new:Hide()
		obj.delete:Hide()

		-- Main Test Frame
		local scrollframe=CreateFrame("ScrollFrame","myFrame",frame)
		obj.scrollframe:SetBackdrop(StaticPopup1:GetBackdrop())
		
		--obj.scrollframe:SetSize(300,400)
		obj.scrollframe:ClearAllPoints()
		obj.scrollframe:SetPoint("TOPLEFT",relativeElement, "TOPRIGHT" ,0,0)
		obj.scrollframe:SetPoint( "BOTTOMRIGHT" ,-10, 10)
		obj.scrollframe:EnableMouse(true)
		obj.scrollframe:SetMovable(true)
		obj.scrollframe:RegisterForDrag("LeftButton")
		obj.scrollframe:SetScript("OnDragStart",scrollframe.StartMoving)
		obj.scrollframe:SetScript("OnDragStop",scrollframe.StopMovingOrSizing)
		obj.scrollframe:SetHitRectInsets(10,10,10,10)
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
	return obj
	end	

		
	
end
