


do

	local Assignmentframe = _G.GUI.AssignmentFrame
	
	local Assignment = _G.GUI.Assignment
	
	function Assignmentframe:new_scrollframe(frame, relativeElement, x, y)
		
		local obj = {
			scrollframe = CreateFrame("Scrollframe", nil, frame),   
			scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate")			
		}
	

		--init des Frames
		obj.scrollframe:SetPoint("TOPLEFT",  10, -10)
		obj.scrollframe:SetPoint("BOTTOMRIGHT",  -10, 10)
		--obj.scrollframe:SetPoint("BOTTOMLEFT", relativeElement, "BOTTOMRIGHT", 10, 10)
		local texture = obj.scrollframe:CreateTexture()
		texture:SetAllPoints()
		texture:SetTexture(.5,.5,.5,1)
		frame.scrollframe = scrollframe
		
		obj.scrollbar:SetPoint("TOPLEFT", obj.scrollframe, "TOPRIGHT", 4, -16)
		obj.scrollbar:SetPoint("BOTTOMLEFT", obj.scrollframe, "BOTTOMRIGHT", 4, 16)
		obj.scrollbar:SetMinMaxValues(1, 200)
		obj.scrollbar:SetValueStep(1)
		obj.scrollbar.scrollStep = 1
		obj.scrollbar:SetValue(0)
		obj.scrollbar:SetWidth(16)
		obj.scrollbar:SetScript("OnValueChanged", function(self, value)
			self:GetParent():SetVerticalScroll(value)
		end)
		local scrollbg = obj.scrollbar:CreateTexture(nil, "BACKGROUND")
		scrollbg:SetAllPoints(scrollbar)
		scrollbg:SetTexture(0,0,0,0.4)
		frame.scrollbar = scrollbar
		
		
	return obj
	end

		
	
end
