-- In andere Frames ladbares Frame. Es erstellt sich seine eigene Liste zum auswählen, 
-- des jeweiligen Contents

do 

BossSelectFrame = {}

function BossSelectFrame:show(parent, width, height, anchor, xOffset, yOffset)
end


function BossSelectFrame:hide()
	ExpansionDropDown:Hide()
	RaidDropDown:Hide()
	BossDropDown:Hide()
	BossSelectFramus:Hide()
	tremove(ExpansionDropDown)
	tremove(RaidDropDown)
	tremove(BossDropDown)
	tremove(BossSelectFramus)
end


function BossSelectFrame:new_BossSelectFrame(parent, width, height, anchor, xOffset, yOffset)
	


	--Default Parameters
	local obj = {
		parent = parent or UIParent,
		width = width or 200,
		height = height or 400,
		anchor = anchor or "LEFT",
		xOffset = xOffset or 10,
		yOffset = yOffset or 0,
		expDD = {},
		raidDD = {},
		bossDD = {},
		assignmentFrames = {}
	}
	setmetatable(obj, self)
	self.__index = self

	

	-- Background für BossSelectFrame erschaffen
	obj.frame = CreateFrame("Frame","BossSelectFramus",parent)
	obj.frame:SetWidth(width)
	obj.frame:SetHeight(height)
	obj.frame:SetPoint(anchor,xOffset,-yOffset)
		
	obj.frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	obj.frame:SetBackdropColor(0.0,0.0,0.0,1.0)
	
	-- DropDownMenus einfügen
	-- Expansion
	obj.expDD = createExpansionDropDown(obj.frame, 0, 50, width * 0.8, "BossSelectFrame_ExpansionDropDrown")
	obj.raidDD = createRaidDropDown(obj.frame, 0, 0, width * 0.8, "BossSelectFrame_RaidDropDrown")								 
	obj.bossDD = createBossDropDown(obj.frame, 0, -50, width * 0.8, "BossSelectFrame_BossDropDrown")
	obj.expDD.raid = raidDD
	obj.expDD.boss = bossDD
	obj.raidDD.boss = bossDD

	obj.bossDD:SetScript("OnClick", function(self, button, down)
		print("asdf")
	end)

end

end
