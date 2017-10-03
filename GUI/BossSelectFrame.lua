--[[
File Name: BossSelectFrame.lua
Author: Veith, Marvin Justin (10043555)
Description: Dieser Frame beinhaltet die drei Dropdowns "ExpansionDropDown", "RaidDropDown" und "BossDropDown". Der "BossSelectFrame" kann
			 in jedes andere Frame geladen werden. Die verwendung dieses Frames eignet sich, da er in seiner Form anpassbar ist, allerdings auch
			 eine default Einstellung besitzt.
			 Die Zusammengehörigkeit der Dropdowns "ExpansionDropDown", "RaidDropDown" und  "BossDropDown" wird über das Frame geregelt.
			 Die Funktionalität des Frames beschränkt sich auf die Selektion eines Bosses. Für die weitere Arbeitsweise mit dem Addon ist es
			 notwendig, einen Boss eindeutig auswählen zu können.
]]


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


function BossSelectFrame:new_BossSelectFrame(parent, name, width, height, anchor, xOffset, yOffset)

-- Erstellen von BossSelectFrame.


--[[
Function Name: BossSelectFrame:show
Author: Veith, Marvin Justin (10043555)
Parameters: parentFrame - Hierbei handelt es sich um das Frame, in welches das "BossSelectFrame" angezeigt werden soll.
						  Default: UIParent (Hauptfenster)
			      width - Breite des Frames. Default: 200 Pixel
				 height - Höhe des Frames. Default 400 Pixel
				 anchor - Anker des Frames. Gibt an zu welchem Punkt der Frame positioniert wird.
						  (Auswahlmöglichkeit:  topleft,    top,	topright
												left,      center, 	rigt
												bottomleft, bottom, bottomright)
							Default: "LEFT"
				xOffset - Versatz des Frames in horizontaler Richtung
				yOffset - Versatz des Frames in vertikaler Richtung. Im Gegensatz zu anderen Systemen wird bei positiven Y-Wert nach oben
						  und bei negativen Y-Wert nach unten Positioniert.
				name    - 
Return:	Es wird die Referenz des neu erstellten Frames zurückgegeben
Description: Es wird abhänhig der Parameter (falls nicht angegeben, default) ein neues Frame erschaffen. 
			 Die Dropdowns werden vordefinieert erstellt und miteinander verlinkt.
]]

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
	return obj.frame
end

--[[
Function Name: BossSelectFrame:show
Author: Veith, Marvin Justin (10043555)
Description: Wird eventuell noch entfernt. Dient nur zu Testzwecken.
]]
end
