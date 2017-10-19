--- Beschreibung: Diese Klasse stellt ein ScrollFrame dar, welche eine ScrollBar und ein ContentFrame enth&aumllt. Das ContentFrame enth&aumllt die Liste mit den Buttons.	
--				  Die ScrollBar wird nur angezeigt, wenn die Liste zu lang ist, damit der Spieler unter und hoch scrollen kann.
--				  Das ContentFrame zeigt zurerst eine Liste der Contents(z.B. Classic) an.
--                Diese Liste besteht aus ButtonFrames.
--                Zu Beginn gitb es keinen Header.
--				  Wenn der Spieler jedoch auf einen Content klickt, dann wird dieser zum neuen Header der Liste und wird gehighlighted. 
--				  Nun kann der Spieler eine Instanz ausw&aumlhlen. Die Instanz, welche der Spieler ausw&aumlhlt wird nun als neuer Header angezeigt.
--				  Zuletzt kann der Spieler einen Boss aus dieser Instanz ausw&aumlhlen. 
--				  Den Boss kann der Spieler jederzeit wechseln.
--				  R&uumlckw&aumlrts funktioniert die ScrollFrame genauso, man klickt auf den Header(welcher eine Instanz ist) werden nun wieder alle Instanzen angezeigt.
-- 
--				  Plus und Minus Texturen zeigen an, ob z.B. eine Instanz Bosse enth&aumllt(Kinder).
--				  Enth&aumllt ein Button keine Kinder so hat er keine Textur. 
--                Enth&aumllt er jedoch Kinder erh&aumllt dieser eine Plus Textur, wenn dieser dann angeklickt wird, wird er zum neuen Header und kriegt eine Minus Textur.
--
--				  Nicht mehr in Benutztung, da durch DropDowns.lua ersetzt!
--
-- @modul ScrollFrame
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local SA_ScrollFrame =  _G.GUI.SA_ScrollFrame

local ScrollFrame

-- Lokalisierung
local SAL = _G.GUI.Locales

local BUTTON_HEIGHT = 25

--- Dient zur Erstellung des ScrollFrames.
-- Es wird ein ScrollFrame erstellt und ein Container f&uumlr die Buttons erzeugt, wo die Daten stehen.
-- Setz den Count of main Buttons zu Beginn auf 0.
-- Dann wird eine ScrollBar und das ContentFrame erstellt.
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string name Ist der Name des ScrollFrames
-- @return ScrollFrame
local function CreateScrollFrame(frame, name)
	ScrollFrame = CreateFrame("ScrollFrame", name, frame)

	ScrollFrame.buttons = {}
	ScrollFrame.mainButtonCount = 0
	
	ScrollFrame:SetPoint("TOPLEFT", 10, -10)
	ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
	ScrollFrame:SetWidth(frame:GetWidth() * 0.7)
	
	ScrollFrame.texture = ScrollFrame:CreateTexture()
	ScrollFrame.texture:SetAllPoints()
	ScrollFrame.texture:SetTexture(0, 0, 0, 0)
	
	CreateScrollBar(ScrollFrame)
	CreateContent(ScrollFrame, SA_Dungeons)
	
	return ScrollFrame
end

--- Erstellt die ScrollBar f&uumlr die ScrollFrame.
-- Es wird ein Attribut gesetzt, um zur Laufzeit das Attribut sicher pr&uumlfen zu k&oumlnnen, mithilfe
-- des Events OnAttributeChanged. Zu welchen ein EventHandling implementiert wird.
-- Des Weiteren wird ein EventHandler f&uumlr das Event OnValueChanged gesetzt.
--
-- @tparam Frame frame Ist das Elternframe.
function CreateScrollBar(frame)
	if not ScrollBar then
		ScrollBar = CreateFrame("Slider", "ScrollBar", frame, "UIPanelScrollBarTemplate")
	end
	
	-- Setze einen Attribut, welcher &uumlber GetAttribute() geholt werden kann
	ScrollBar:SetAttribute("buttoncount",0)
	
	ScrollBar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -12, -16)
	ScrollBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -12, 16)
	ScrollBar:SetMinMaxValues(1, 100) -- Setze Minimum und Maximum f&uumlr die ScrollBar, welcher der Scrollbereich ist
	ScrollBar:SetValueStep(1) -- Setze fest, um wieviel immer gescrollt werden soll, wenn der Spieler scrollt
	ScrollBar.scrollStep = 1
	ScrollBar:SetValue(0) -- Setze ein start value der ScrollBar fest
	ScrollBar:SetWidth(16)
	
	-- Wenn der Spieler mithilfe der ScrollBar scrollt, dann werden die Buttons neu positioniert
	ScrollBar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value) -- Setze den neuen Value, um welchen verschoben wurde
		if ScrollFrame.mainBTN == nil and ScrollFrame.lvlClicked == 0 then -- Wenn Mainbutton
			local mainButtons = GetMainButtons(Content.data)
			for i=1, #mainButtons, 1 do
			    mainButtons[i]:ClearAllPoints()
				mainButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value - BUTTON_HEIGHT) 
			end
		elseif ScrollFrame.mainBTN ~= nil and ScrollFrame.lvlClicked == 1 then -- Wenn Instanzbutton
			local instanceButtons = GetInstanceButtons(Content.data)
			for i=1, #instanceButtons, 1 do
				instanceButtons[i]:ClearAllPoints()
				instanceButtons[i]:SetPoint("LEFT", ScrollFrame, "LEFT", 0, value - BUTTON_HEIGHT) 
			end
		elseif ScrollFrame.instanceButton ~= nil and ScrollFrame.lvlClicked == 2 then -- Wenn Bossbutton
			local bossData = GetBossData(ScrollFrame.mainBTN, ScrollFrame.instanceButton:GetText(), Content.data)
			local bossButtons = GetBossButtons(bossData)
			bossButtons[1]:ClearAllPoints()
			bossButtons[1]:SetPoint("LEFT", ScrollFrame.instanceButton, "LEFT", 0, value - BUTTON_HEIGHT) 
			for i=2, #bossButtons, 1 do
				bossButtons[i]:ClearAllPoints()
				bossButtons[i]:SetPoint("LEFT", bossButtons[i-1], "LEFT", 0, -BUTTON_HEIGHT) 
			end
		end
	end)
	
	local ScrollBG = ScrollBar:CreateTexture("ScrollBar_Tex", "BACKGROUND") -- Textur f&uumlr die ScrollBar
	ScrollBG:SetAllPoints(ScrollBar)
	ScrollBG:SetTexture(0, 0, 0, 0.4)
	ScrollBar:Hide()
	
	-- Zeigt die ScrollBar nur an, wenn zu viele Buttons in der Liste dargestellt werden
	ScrollBar:SetScript("OnAttributeChanged", function(self, name, value)
		if name == "buttoncount" then
			if(value > ((ScrollFrame:GetHeight()-20)/15)) then
				self:Show()
			else
				self:Hide()
			end
		end
	end)
end

--- Erstellt den Content des ScrollFrames.
-- Es wird ein ContentFrame erstellt und die Gr&oumlße wird vom parent &uumlbernommen.
-- Dann werden leere Buttons erstellt, soviele wie die Tabelle an Daten enth&aumllt.
-- Daraufhin wird der Text der Buttons gesetzt, welcher aus der Tabelle data genommen wird.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam table data Die Tabelle mit den Daten
function CreateContent(frame, data)
	-- Wenn data leer ist
	if next(data) == nil then
		return
	end
	
	if not Content then
		Content = CreateFrame("Frame", "ScrollFrame_Content", frame)
	end
	
	Content.data = data
	
	Content:SetSize(frame:GetWidth(), frame:GetHeight())
	
	SA_ScrollFrame:CreateButtons(data, frame) -- Erstelle alle ben&oumltigten Buttons
	local i = 1
	local lastContent = 1
	for k, v in pairs(data) do -- Durch laufe komplette Tabelle
		if type(k) == "string" then
			local btn1 = ConfigMainButton(ScrollFrame.buttons[i], k) -- Konfiguriere den Mainbutton
			if i == 1 then -- Setze den ersten Button
				btn1:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
			else -- Die restlichen Buttons
				btn1:SetPoint("TOPLEFT", ScrollFrame.buttons[(lastContent-1)], "BOTTOMLEFT", 0, 0)
			end
			lastContent = i
			i = i + 1
			if type(v) == "table" then -- Wenn value eine Tabelle ist
				if GetDepth(v) >= 2 then --  Wenn die Tabelle eine Tiefe von 2 oder mehr hat
					for k, v in pairs(v) do -- Iteriere durch die Instanzbuttons
						btn1.hasChilds = true
						SetPlusTexture(btn1) -- Setze ein Plus in btn1
					
						btn1:SetScript("OnClick", function(self, button) -- OnClick EventHandling f&uumlr den Mainbutton
							if button == "LeftButton" then
								if not self.clicked then -- Wenn btn1 nicht geklickt war
									ScrollFrame.lvlClicked = 1
									ScrollFrame.mainBTN = self -- Setze den Mainbutton welcher geklickt wurde
									self.clicked = true
									SetMinusTexture(self) -- Und setzte ein Minus im Button
								
									-- Verberge alle Buttons und setze den gew&aumlhlten als Header
									SA_ScrollFrame:HideButtons()
									ClearAllPoints()
									NewHeader(self)
									SetInstanceButtons(self, Content.data[self:GetText()]) -- Setze die Instanzbuttons abh&aumlngig zum gew&aumlhlten Mainbutton 
									
									ScrollBar:SetMinMaxValues(1,GetArraySize(Content.data[self:GetText()], 1, 0) * GetArraySize(Content.data[self:GetText()], 1, 0)/3) -- Setzte Minimum und Maximum der ScrollBar
								else                                                       -- wenn der Button vorher angeklickt war
									ScrollBar:SetAttribute("buttoncount", 0) -- Setze buttoncount auf 0
								
									ScrollFrame.lvlClicked = 0
									ScrollFrame.mainBTN = nil
									SetAllClicked(false) -- Wenn wieder in Ebene/Level 1 ist, dann setze alle Buttons als nicht geklickt
									SetAllPlusTex() -- Und setze wieder alle Plus Texturen
							
									SetMainButtons() -- Setze nun wieder alle Mainbuttons in der ScrollFrame
									ScrollBar:SetMinMaxValues(1,GetArraySize(Content.data, 1, 0) * GetArraySize(Content.data, 1, 0)/3) -- Setzte Minimum und Maximum der ScrollBar
								end
							end
						end)

						i = i + 1
						
						if type(k) == "string" then
							local btn2 = ConfigInstanceButton(ScrollFrame.buttons[i], k) -- Konfiguriere den Instancebutton
							if type(v) == "table" then -- wenn Tabelle in Tabelle, dann hat eine Instanz auch Bosse
								btn2.hasChilds = true
							else
								btn2.hasChilds = false
							end
							btn2:SetScript("OnClick", function(self, button) -- OnClick EventHandling
								if button == "LeftButton" then
									ScrollBar:SetAttribute("buttoncount",0)
									if not self.clicked then 
										ScrollFrame.lvlClicked = 2
										ScrollFrame.instanceButton = self -- Setze den Instancebutton
										self.clicked = true
										SetMinusTexture(self) -- Setze eine Minus Textur
										
										-- Verberge alle Buttons und setze den gew&aumlhlten als Header
										SA_ScrollFrame:HideButtons()
										ClearAllPoints()
										NewHeader(self) -- Setze einen neuen Header
										local bossData = GetBossData(ScrollFrame.mainBTN, self:GetText(), Content.data) -- Hole die BossDaten
										local bossButtons = GetBossButtons(bossData) -- Hole die BossButtons
										
										ScrollBar:SetAttribute("buttoncount", #bossButtons) -- Setze das Attribut = Anzahl bossButtons
										
										bossButtons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
										bossButtons[1]:Show()
										for i=2, #bossButtons, 1 do
											bossButtons[i]:SetPoint("TOPLEFT", bossButtons[i-1], "TOPLEFT", 0, -25)
											bossButtons[i]:Show()
										end
										ScrollBar:SetMinMaxValues(1,GetArraySize(bossButtons, 1, 0)*GetArraySize(bossButtons, 1, 0)/3)
									else -- Wenn Instanzbutton vorher nicht angeklickt wurde
										ScrollFrame.lvlClicked = 1
										ScrollFrame.instanceButton = nil
										self.clicked = false
										SA_ScrollFrame:HideButtons() -- Verberge alle Buttons
										ClearAllPoints()
										SetAllPlusTex() -- Setze alle Plus Texturen
										SetInstanceButtons(self, Content.data[ScrollFrame.mainBTN:GetText()]) -- Setze alle Instanzbuttons abh&aumlngig des Mainbuttons
										
										if ScrollFrame.bossButton then -- Wenn ein Boss angeklickt ist, setze die Textur auf nil und den bossButton auf nil
											SetNilTex(ScrollFrame.bossButton)
											ScrollFrame.bossButton = nil
										end
										ScrollBar:SetMinMaxValues(1,GetArraySize(Content.data[ScrollFrame.mainBTN:GetText()], 1, 0) * GetArraySize(Content.data[ScrollFrame.mainBTN:GetText()], 1, 0)/3) -- Setzte Minimum und Maximum der ScrollBar
									end
								end
							end)
						i = CreateBossButton(v, i) -- Erstelle den Bossbutton
					end
				end
			else
				btn1:SetScript("OnClick", function(self, button) -- Dieser Button hat keine Kinder
				print("|cFFFF0000"..self:GetText()..SAL[" has no childs!"].."|r")
				end)
			end
		end
	end
end
	--Content.texture = Content:CreateTexture()
	--Content.texture:SetAllPoints()
	--Content.texture:SetTexture("Interface/GLUES/MainMenu/Glues-BlizzardLogo")
	
	frame:SetScrollChild(Content) -- Setze das Scrollkind des ScrollFrames
end

--- Dient um die Position ausserhalb der Klasse zu ver&aumlndern.
--
-- @tparam string framePosition Region des Frames
-- @tparam string relativeToFrame Relativ zu welchen Frame positioniert werden soll
-- @tparam string relativePos Relativ zur Region des Frames, zu welchen positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
function SA_ScrollFrame:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

--- Loader f&uumlr die ScrollFrame.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam string name Name des ScrollFrames
-- @return ScrollFrame
function SA_ScrollFrame:LoadScrollFrame(frame, name)
	return CreateScrollFrame(frame, name)
end

--- Resetfunktion f&uumlr die ScrollFrame.
-- Welche f&uumlr die SlashCommands genutzt wird.
-- Setzt alles zu den Anfangswerten.
--
-- @tparam Frame frame Das ScrollFrame
function SA_ScrollFrame:Reset(frame)
	ScrollFrame.mainBTN = nil
	ScrollFrame.instanceButton = nil
	ScrollFrame.bossButton = nil
	ScrollFrame:SetAttribute("lvlClicked", 0)
	ScrollBar:SetAttribute("buttoncount", 0)
	ScrollBar:SetValue(0)
	ScrollBar:Hide()
	DisableBossButtons()
	ConfigAllButtons()
	SetAllClicked(false)
	SetMainButtons()
	SetAllPlusTex()
	ScrollBar:SetAttribute("buttoncount", ScrollFrame.mainButtonCount)
end

--- Erstellt alle Buttons, welche zu Beginn leer sind.
-- Es werden soviele erzeugt, wie die Tabelle groß ist.
--
-- @tparam tabel data: Wird gebraucht um die Gr&oumlße zu erfahren
-- @tparam Frame frame ScrollFrame 
function SA_ScrollFrame:CreateButtons(data, frame)
	for i=1,GetArraySize(data, GetDepth(data), 0) do
		frame.buttons[i] = CreateFrame("Button","button"..i,Content)
		local btn = frame.buttons[i]
		btn.clicked = false
		btn.hasChild = false
		btn:SetSize(frame:GetWidth()-12,25)
		btn:RegisterForClicks("LeftButtonUp") -- Nur links Klick
	end
	frame.lvlClicked = 0
end

--- Diese Funktion dient dazu die &uumlbergegebenen Bossbuttons zu konfigurieren. (drittes Level)
--
-- @tparam table table Tabelle mit den Bossbuttons
-- @tparam int i Muss mit jedem Button erh&oumlht werden
-- @return i
function CreateBossButton(table, i)
	if type(table) == "table" then
		for k, v in pairs(table) do
			i = i + 1
			ConfigBossButtons(ScrollFrame.buttons[i], v)
			
			if type(k) == "table" then
				--CreateBossButton(k, i) -- Wenn noch ein viertes Level da w&aumlre, aber ist normal nicht n&oumltig
			end
		end
	end
	return i
end

--- Konfiguriert einen Mainbutton(erstes level).
-- Es wird nur ein FontString erstellt, sowie das Level bestimmt.
-- 
-- @tparam ButtonFrame button Der Mainbutton
-- @tparam string key Der Text welcher im Mainbutton gesetzt wird
-- @return mainButton
function ConfigMainButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
		
	button.level = 1
		
	return button
end

--- Eine weitere Funktion zum Konfigurieren eines Mainbuttons.
-- Es wird ein FontString erstellt und eine Texture mit dem Wert nil, was bewirkt, dass eine existierende
-- Textur &uumlberschrieben wird.
-- Ausserdem wird der mainButtonCount sowie das Attribut buttoncount um 1 erh&oumlht.
--
-- @tparam ButtonFrame button Der mainButton
function ConfigMainButtons(button)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(14)
	fontstring:SetPoint("LEFT", button, "LEFT", 2, 0)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	ScrollFrame.mainButtonCount = ScrollFrame.mainButtonCount + 1
	
	ScrollBar:SetAttribute("buttoncount", ScrollBar:GetAttribute("buttoncount") + 1)
end

--- Konfiguriert einen instance button(zweites level).
-- Es wird ein FontString erstellt und eine Textur mit dem Wert nil, was bewirkt, dass eine existierende
-- Textur &uumlberschrieben wird.
-- Des Weiteren wird das Attribut buttoncount um 1 erh&oumlht.
-- Dieser Button wird erst einmal verborgen(mit Hide()).
-- Button Level = 2.
--
-- @tparam ButtonFrame button Der Instancebutton
-- @tparam string key Der Text welcher im Instancebutton gesetzt wird
-- @return Instancebutton
function ConfigInstanceButton(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(13)
	fontstring:SetPoint("LEFT", button, "LEFT", 3, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	button:Hide()
					
	button.level = 2 -- Level des Buttons
	
	SetPlusTexture(button)
	button.clicked = false
	
	ScrollBar:SetAttribute("buttoncount", ScrollBar:GetAttribute("buttoncount") + 1)
		
	return button
end

--- Konfiguriert einen Bossbutton(drittes level).
-- Es wird ein FontString erstellt und eine Textur mit dem Wert nil, was bewirkt, dass eine existierende
-- Textur &uumlberschrieben wird.
-- Des Weiteren wird das Attribut buttoncount um 1 erh&oumlht.
-- Sowie ein EventHandler f&uumlr das Event OnClick hinzugef&uumlgt.
-- Dieser Button wird erst einmal verborgen(mit Hide()).
-- Button Level = 3.
--
-- @tparam ButtonFrame button Der Bossbutton
-- @tparam string key Der Text welcher im Bossbutton gesetzt wird
function ConfigBossButtons(button, key)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(12)
	fontstring:SetPoint("LEFT", button, "LEFT", 4, 0)
	fontstring:SetText(key)
	button:SetFontString(fontstring)
	button.level = 3
	button.clicked = false
	button:Hide() -- Verberge
	
	SetNilTex(button) -- Setze eine nil Textur
	
	-- EventHandling f&uumlr den Bossbutton, wenn der Bossbutton angeklickt wird, wird er gehighlighted.
	button:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			if self.clicked == false then -- Wenn vorher nicht geklickt war
				if ScrollFrame.bossButton then
					if self:GetText() ~= ScrollFrame.bossButton:GetText() then -- Wenn ein anderer Bossbutton angeklickt wurde
						SetNilTex(ScrollFrame.bossButton)
						ScrollFrame.bossButton.clicked = false
						ScrollFrame.bossButton = nil
					end
				end
				ScrollFrame.lvlClicked = 3
				self.clicked = true
				ScrollFrame.bossButton = self  -- Setze als aktuell geklickten Bossbutton
				
				-- Setze Highlight Textur
				SetListHightlightTex(self)
			else -- Wenn vorher geklickt war
				ScrollFrame.lvlClicked = 2
				self.clicked = false
				ScrollFrame.bossButton = nil
				
				-- &uumlberschreibe das Highlighting
				SetNilTex(self)
			end
		end
	end)
end

--- Wird f&uumlr das Zur&uumlcksetzen ben&oumltigt.
-- Mit der Funktion werden alle Buttons zur&uumlckgesetzt.
function ConfigAllButtons()
	for i=1, #ScrollFrame.buttons, 1 do
		if ScrollFrame.buttons[i].level == 1 then
			ConfigMainButtons(ScrollFrame.buttons[i])
		elseif ScrollFrame.buttons[i].level == 2 then
			ConfigInstanceButton(ScrollFrame.buttons[i], ScrollFrame.buttons[i]:GetText())
		elseif ScrollFrame.buttons[i].level == 3 then
			ConfigBossButtons(ScrollFrame.buttons[i], ScrollFrame.buttons[i]:GetText())
		end
	end
end

--- Ein Setter f&uumlr alle Buttons, ob sie vorher geklickt wurden/waren oder nicht.
-- Wird benutzt um alle auf nicht geklickt zu setzen.
--
-- @tparam boolean clicked Auf welchen Wert clicked gesetzt wird
function SetAllClicked(clicked)
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		if ScrollFrame.lvlClicked == 1 and ScrollFrame.mainBTN ~= nil then
			if ScrollFrame.mainBTN:GetText() == button:GetText() then
				ScrollFrame.buttons[i].clicked = true
			end
		elseif ScrollFrame.lvlClicked == 2 and ScrollFrame.instanceButton ~= nil then
			if ScrollFrame.instanceButton:GetText() == button:GetText() then
				ScrollFrame.buttons[i].clicked = true
			end
		else
			ScrollFrame.buttons[i].clicked = clicked
		end
	end
end

--- Ein Setter um f&uumlr alle Level 1 und 2 Buttons, welche noch ein Kind enthalten
-- eine Plus Textur zu setzen.
-- Ausser den MainButton, welcher angeklickt wurde, dieser beh&aumllt/bekommt seine Minus Textur.
function SetAllPlusTex()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		local button = ScrollFrame.buttons[i]
		if button.hasChilds then
			SetPlusTexture(button)
		end
	end
	if(ScrollFrame.mainBTN ~= nil) then
		SetMinusTexture(ScrollFrame.mainBTN)
	end
end

--- Setzt die Plus Textur f&uumlr einen Button.
--
-- @tparam ButtonFrame button Welcher die Plus Textur gesetzt bekommt
function SetPlusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

--- Setzt die Minus Textur f&uumlr einen Button.
--
-- @tparam ButtonFrame button Welcher die Minus Textur gesetzt bekommt
function SetMinusTexture(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetSize(20, 20)
	tex:SetTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
end

---  Setzt f&uumlr einen Button eine nil Textur.
-- Wird gebraucht um eine bereits existierende Textur zu &uumlberschreiben.
-- Da eine Textur nicht gel&oumlscht werden kann.
--
-- @tparam ButtonFrame button Welcher die nil textur gesetzt bekommt
function SetNilTex(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture(nil)
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
end

--- Setzt eine Highlight Textur f&uumlr einen Button.
--
-- @tparam ButtonFrame button Welcher die Highlight Textur gesetzt bekommt
function SetListHightlightTex(button)
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints(true)
	tex:SetTexture("Interface\\BUTTONS\\UI-ListBox-Highlight")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
end

--- Mit dieser Funktion setzt man einen Button als Header.
-- Hier wird der Text gr&oumlßer gemacht und der Button kriegt eine Highlight Textur.
-- Ein Header wird immer neu gesetzt, wenn ein neues Level in der ScrollFrame erreicht wird.
-- Wenn der Spieler zum Beispiel auf eine Instanz klickt.
--
-- @tparam ButtonFrame button Welcher als neuer Header gesetzt wird
function NewHeader(button)
	button:SetFrameLevel(255) -- to be at the top of ui
	button:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontNormal)
	fontstring:SetTextHeight(15)
	fontstring:SetText(button:GetText())
	button:SetFontString(fontstring)
	
	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetSize(button:GetWidth(), button:GetHeight()+8)
	tex:SetAllPoints(true)
	tex:SetTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2")
	button:SetNormalTexture(tex)
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button:GetNormalTexture():SetPoint("LEFT", button, "LEFT", 0, 0)
	
	button:Show()
end

--- L&oumlscht die Positionierung alle Buttons, wenn man alle wieder neu setzen m&oumlchte.
function ClearAllPoints()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:ClearAllPoints()
	end
end

--- Mit dieser Funktion werden alle Buttons verborgen.
function SA_ScrollFrame:HideButtons()
	for i=1,GetArraySize(Content.data, GetDepth(Content.data), 0) do
		ScrollFrame.buttons[i]:Hide()
	end
end

--- Mit dieser Funktion kann man alle Bossbuttons deaktivieren.
-- Nur der ausgew&aumlhlte Bossbutton bleibt aktiv.
-- Hierdurch kann der Spieler solange keinen anderen Bossbutton ausw&aumlhlen,
-- bis der ausgew&aumlhlte abgew&aumlhlt wird.
--
-- NICHT IN BENUTZTUNG
function DisableBossButtons()
	if ScrollFrame.bossButton ~= nil then
		local bossButtons = SA_ScrollFrame:GetBossButtons()
		for i=1, #bossButtons, 1 do
			if bossButtons[i]:GetText() ~= ScrollFrame.bossButton:GetText() then
				bossButtons[i]:Disable()
			end
		end
	else
		local bossButtons = SA_ScrollFrame:GetBossButtons()
		for i=1, #bossButtons, 1 do
			bossButtons[i]:Enable()
		end
	end
end

--- Gibt abh&aumlngig zur &uumlbergegebenen Tabelle die Mainbuttons zur&uumlck.
--
-- @tparam table data Container mit den Daten
-- @return Gibt die Mainbuttons zur&uumlck
function GetMainButtons(data)
	local score = {}
	for k, v in pairs(data) do
		for j=1, #ScrollFrame.buttons, 1 do
		-- Nur level 1 Buttons sind Mainbuttons
			if (k == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 1) then
				score[i] = ScrollFrame.buttons[j]
				--print("score["..i.."]: "..score[i]:GetText())
			end
		end
	end
	return score
end

--- Mit dieser Funktion kann man alle Instanzbuttons holen.
-- Diese sind abh&aumlngig von der Tabelle data.
--
-- @tparam table data Container mit den Daten
-- @return Gibt die  Instanzbuttons zur&uumlck
function GetInstanceButtons(data)
	local instanceButtons = copyButtons(data)
	local score = {}
	for i=1, #instanceButtons, 1 do
		for j=1, #ScrollFrame.buttons, 1 do
		-- Nur level 2 sind Instancebuttons
			if (instanceButtons[i] == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 2) then
				score[i] = ScrollFrame.buttons[j]
				--print("score["..i.."]: "..score[i]:GetText())
			end
		end
	end
	return score
end

--- Mit dieser Funktion kann man alle Bossbuttons holen.
-- Diese sind abh&aumlngig von der Tabelle data, welche vorher mit GetBossData gefiltert wurde.
--
-- @tparam table data Container mit den Daten
-- @return Gibt die  Bossbuttons zur&uumlck
function GetBossButtons(data)
	local bossButtons = data
	local score = {}
	for i=1, #bossButtons, 1 do
		for j=1, #ScrollFrame.buttons, 1 do
			if (bossButtons[i] == ScrollFrame.buttons[j]:GetText() and ScrollFrame.buttons[j].level == 3) then
				score[i] = ScrollFrame.buttons[j]
				--print("score[i]: "..score[i]:GetText())
			end
		end
	end
	return score
end

--- Diese Funktion dient dazu die Bosse aus einer Instanz zu filtern.
-- Gefiltert wird aus data.
-- Zuerst wird &uumlber den Mainbutton die Instanz geholt und dann &uumlber die Instanz
-- die Bosse zur&uumlckgegeben.
--
-- @tparam ButtonFrame mainBTN Dieser Button enth&aumllt den ausgew&aumlhlten Content
-- @tparam string buttonText enth&aumllt den Namen der Instanz
-- @tparam table data enth&aumllt alle Daten
-- @return Die Instanzen in einer Tabelle
function GetBossData(mainBTN, buttonText, data)
	local nextLvlData = data[mainBTN:GetText()]
	return nextLvlData[buttonText]
end

--- Diese Funktion gibt alle Bossbuttons aus dem Container zur&uumlck.
-- @return Alle Bossbuttons
function SA_ScrollFrame:GetBossButtons()
	local score = {}
	for i=1, #ScrollFrame.buttons, 1 do
		if(ScrollFrame.buttons[i].level == 3) then
			tinsert(score, ScrollFrame.buttons[i])
		end
	end
	return score
end

--- Mit dieser Funktion kann man im ScrollFrame alle gerade zu sehenden Buttons
-- durch Mainbuttons austauschen.
-- Wird gebraucht wenn der Spieler wieder zum Ebene/Level 1 zur&uumlckkehrt.
function SetMainButtons()
	SA_ScrollFrame:HideButtons()
	ClearAllPoints()
	ConfigMainButtons(ScrollFrame.buttons[1])
	ScrollFrame.buttons[1]:SetPoint("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	ScrollFrame.buttons[1]:Show()
	
	local last = ScrollFrame.buttons[1]
	for i=2,#ScrollFrame.buttons, 1 do
		if (ScrollFrame.buttons[i].level == 1) then
			ConfigMainButtons(ScrollFrame.buttons[i])
			ScrollFrame.buttons[i]:SetPoint("TOPLEFT", last, "TOPLEFT", 0, -25)
			ScrollFrame.buttons[i]:Show()
			last = ScrollFrame.buttons[i]
		end
	end
	SetAllPlusTex()
end

--- Mit dieser Funktion werden alle Instanzbuttons gesetzt, in Abh&aumlngigkeit zum
-- zurzeit ausgew&aumlhlten Mainbutton.
--
-- @tparam ButtonFrame self Der Mainbutton
-- @tparam table data Container mit allen Daten
function SetInstanceButtons(self, data)
	local instanceButtons = GetInstanceButtons(data) -- get filtered buttons, only instance buttons
	ConfigInstanceButton(instanceButtons[1], instanceButtons[1]:GetText())
	if ScrollFrame.mainBTN ~= nil then
		if ScrollFrame.mainBTN == self:GetText() then
			instanceButtons[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
		else
			NewHeader(ScrollFrame.mainBTN)
			instanceButtons[1]:SetPoint("TOPLEFT", ScrollFrame.mainBTN, "TOPLEFT", 0, -25)
		end
	end
	instanceButtons[1]:Show()
	for i=2, #instanceButtons, 1 do
		instanceButtons[i]:SetPoint("TOPLEFT", instanceButtons[i-1], "TOPLEFT", 0, -25)
		ConfigInstanceButton(instanceButtons[i], instanceButtons[i]:GetText())
		instanceButtons[i]:Show()
	end
end

--- Bei dieser Funktion handelt es sich um eine reine LUA Funktion.
-- Mit welcher man die Gr&oumlße einer Tabelle ermitteln kann.
-- Der Benutzer kann die Tiefe, wie weit in die Tabelle reingegangen werden soll
-- ausw&aumlhlen.
--
-- @tparam table table Die Tabelle von welcher man die Gr&oumlße wissen m&oumlchte.
-- @tparam int depth Wie tief die Gr&oumlße gemessen soll
-- @tparam int len Wird benutzt zum Rekursiven durchlaufen der Funktion
-- @return Gibt die Gr&oumlße der Tabelle zur&uumlck
function GetArraySize(table, depth, len)
	local lengthNum = len
	for k,v in pairs(table) do -- for every key in the table with a corresponding non-nil value 
		lengthNum = lengthNum + 1
		if depth >= 2 then
			if type(v) == "table" then
				lengthNum = GetArraySize(v, depth-1, lengthNum)
			end
		end
	end
	return lengthNum
end

--- Bei dieser Funktion handelt es sich um eine reine LUA Funktion.
-- Mit welcher man die Tiefe einer Tabelle ermitteln kann.
-- Wenn die Tabelle eine Tabelle enth&aumllt, wird diese Funktion Rekursiv aufgerufen.
--
-- @return Gibt die tiefe der Tabelle als int zur&uumlck
function GetDepth(table)
	local depth = 1
	if next(table) == nil then
		return depth
	else
		depth = depth + 1
	end
	for	k, v in pairs(table) do
		if type(v) == "table" then
			GetDepth(v)
		end
	end
	return depth + 1
end

--- Bei dieser Funktion handelt es sich um eine reine LUA Funktion.
-- Mit welcher man die Buttons(nur keys) kopiert.
--
-- @tparam table orig Der originale Container gef&uumlllt mit Buttons
-- @return Gibt eine Kopie nur von den Buttons zur&uumlck(keys)
function copyButtons(orig)
    local copy = {}
    for k, v in pairs(orig) do
		if k ~= nil then
			tinsert(copy, k)
		end
    end
    return copy
end
