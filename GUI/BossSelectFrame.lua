-- In andere Frames ladbares Frame. Es erstellt sich seine eigene Liste zum auswählen, 
-- des jeweiligen Contents

BossSelectFrame = {}

function BossSelectFrame:show(parent, width, height, anchor, xOffset, yOffset)
	--Default Parameters
	parent = parent or UIParent
	width = width or 200
	height = height or 400
	anchor = anchor or "LEFT"
	xOffset = xOffset or 10
	yOffset = yOffset or 0
	
	-- Background für BossSelectFrame erschaffen
	BossSelectFrame.frame = CreateFrame("Frame","BossSelectFramus",parent)
	BossSelectFrame.frame:SetWidth(width)
	BossSelectFrame.frame:SetHeight(height)
	BossSelectFrame.frame:SetPoint(anchor,xOffset,-yOffset)
		
	BossSelectFrame.frame:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 4, edgeSize = 32,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
	BossSelectFrame.frame:SetBackdropColor(0.0,0.0,0.0,1.0)
	
	-- DropDownMenus einfügen
	-- Expansion
	local expDD = createExpansionDropDown(BossSelectFrame.frame, 0, 50, width * 0.8, "BossSelectFrame_ExpansionDropDrown")
	local raidDD = createRaidDropDown(BossSelectFrame.frame, 0, 0, width * 0.8, "BossSelectFrame_RaidDropDrown")								 
	local bossDD = createBossDropDown(BossSelectFrame.frame, 0, -50, width * 0.8, "BossSelectFrame_BossDropDrown")
	expDD.raid = raidDD
	expDD.boss = bossDD
	raidDD.boss = bossDD
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