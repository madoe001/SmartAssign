


do

	local Assignmentframe = _G.GUI.AssignmentFrame
	
	local Assignment = _G.GUI.Assignment
	
	function Assignmentframe:new_scrollframe(frame, relativeElement, x, y)
	local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate")			
		}

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
	end	

		
	
end
