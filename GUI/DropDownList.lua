--- Beschreibung: Diese Klasse stellt eine DropDownListe dar. Welche mit Daten aus einer Tabelle gef&uumlllt wird.
--				  Diese wird benutzt, um eine Auswahl zwischen Timer und F&aumlhigkeit zu treffen.
--
-- @modul DropDownList
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local SA_DropDownList = _G.GUI.SA_DropDownList

-- Lokalisierung
local SAL = _G.GUI.Locales

-- F&uumlr Fehlerbehandlung
local assert, type = assert, type

-- H&oumlhe des DropDownButtons
local BUTTON_HEIGHT = 25

--- Mithilfe dieser Funktion kann man dem OnClickEvent einen EventHandler zuordnen.
--
-- Assertion: Wenn func keine Funktion ist
--
-- @tparam Frame frame F&uumlr welchen man die EventHandlerFunktion setzen m&oumlchte
-- @tparam function func Die Funktion welche f&uumlr das OnClick Event gesetzt werden soll
function SA_DropDownList:SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownList SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

--- Dient um die Position ausserhalb der Klasse zu ver&aumlndern.
--
-- @tparam string framePosition Region des Frames
-- @tparam string relativeToFrame Relativ zu welchen Frame positioniert werden soll
-- @tparam string relativePos Relativ zur Region des Frames, zu welchen positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
function SA_DropDownList:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

--- Die OnClickEventHandling-Funktion f&uumlr DropDownListe.
-- &aumlndert die SelectedID auf die geklickte ID mithilfe von UIDropDownMenu_SetSelectedID.
--
-- @tparam Frame self Das Item auf welches geklickt wurde
local function OnClick(self)
	if self:GetID() == 1 then
		self.selectedId = SAL["Timer"]
	elseif self:GetID() == 2 then
		self.selectedId = SAL["Ability"]
	end
       -- UIDropDownMenu_SetSelectedID(self, self:GetID())
end

--- Setterfunktion f&uumlr data. Welche dann in der DropDownListe dargestellt werden.
-- Wenn data leer ist dann wird die Position gel&oumlscht, sowie data und selectedID des Frames werden auf nil gesetzt.
-- Ansonsten &uumlbergebe die Tabelle data an das Frame und setze selectedID auf startValue.
-- Wenn startValue gesetzt ist, dann setzte das selectedID der DropDownListe mithilfe von UIDropDownMenu_SetSelectedID().
--
-- @tparam Frame frame Das Frame in welcher die Tabelle und selectedID gesetzt werden soll
-- @tparam table data Die Tabelle welche in der DropDownListe dargestellt werden soll
-- @tparam int startValue Das Item was zum start angezeigt werden soll
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

--- Dient zum erstellen der DropDownListe.
-- Erstellt einen DropDownListButton, welcher die DropDownListe darstellt.
-- Es werden dann die Daten f&uumlr die DropDownListe gesetzt und ein Label erstellt.
--
-- UIDropDownMenu_Initialize(): Damit wird die Initialisierungfunktion gesetz.
-- UIDropDownMenu_SetButtonWidth(): Damit wird die Breite des Buttons gesetzt.
-- UIDropDownMenu_SetWidth(): Damit wird die Breite f&uumlr das Label gesetzt(im Button).
-- UIDropDownMenu_JustifyText(): Damit wird das Label justiert.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam string name Name der DropDownListe
-- @tparam table data Die Daten f&uumlr die DropDownListe
-- @tparam function init Die Initialisierungfunktion
local function CreateDropDownList(frame, name, data, init)
	local DropDownListButton = CreateFrame("Button", name, frame,"UIDropDownMenuTemplate")	
	SetData(DropDownListButton, data, nil)
	
	DropDownListButton:SetPoint("CENTER", 20, 0) -- 20 = x
	DropDownListButton:SetHeight(BUTTON_HEIGHT)
    DropDownListButton:RegisterForClicks("LeftButtonDown") -- nur links Klick
    
    DropDownListButton.label = DropDownListButton:CreateFontString("DropDownListButton-label", "ARTWORK", "GameFontNormalSmall")
	DropDownListButton.label:SetHeight(BUTTON_HEIGHT)
	DropDownListButton.label:SetText("DropDownListButton-label")
	
	DropDownListButton:Show()

	UIDropDownMenu_Initialize(DropDownListButton, init);
    UIDropDownMenu_SetButtonWidth(DropDownListButton, (DropDownListButton.label:GetStringWidth()-(DropDownListButton.label:GetStringWidth()*0.5)))
    UIDropDownMenu_SetWidth(DropDownListButton, DropDownListButton.label:GetStringWidth());
    UIDropDownMenu_JustifyText(DropDownListButton, "CENTER")
    
    return DropDownListButton
end

--- Initialisierungfunktion f&uumlr die DropDownListe.
-- Iteriert durch die Tabelle data und setzt die Daten: text, value und func.
-- func enth&aumllt die Funktion OnClick.
-- Dann f&uumlge alles plus den Level der DropDownListe hinzu.
--
-- @tparam Frame self Die DropDownList 
-- @tparam int level Das Level auf welches das Item gesetzt werden soll(1 Level m&oumlglich)
function InitDDL(self, level)
   local info = UIDropDownMenu_CreateInfo()
   for key,value in pairs(self.data) do
      info = UIDropDownMenu_CreateInfo()
      info.text = value
      info.value = value
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

--- Ein Getter f&uumlr die selectedID
--
-- @tparam Frame frame Die DropDownList
function SA_DropDownList:GetSelectedID(frame)
	return frame.selectedID
end

--- Ein Setter f&uumlr die selectedID
--
-- @tparam int value Auf welche selectedID gesetzt werden soll
function SA_DropDownList:SetSelectedID(value)
	DropDownListButton.selectedID = value
	UIDropDownMenu_SetSelectedID(DropDownListButton, value)
end

--- Loader f&uumlr die DropDownListe.
--
-- Assertion: Wenn data keine Tabelle ist
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam table data Die Tabelle welche in der DropDownListe gesetzt werden soll
function SA_DropDownList:LoadDropDownList(frame, name, data, init)
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownList.data for infos."])
	return CreateDropDownList(frame, name, data, init)
end
