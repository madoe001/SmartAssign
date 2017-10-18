-- Beschreibung: Diese Klasse stellt ein DropDownMenu dar, welche mit den Daten aus einer Tabelle gefüllt wird, welche wiederrum eine Tabelle enthält.
--				 Wenn der Spieler auf den DropDownMenuButton klickt, zeigt sich ihm eine Liste mit Einträgen. Diese Einträge beinhalten wieder eine Liste mit Elementen.
--				 Zum Beispiel wird beim Klick auf den DropDownMenuButton eine Liste mit Einträge der Klassen angezeigt und dann wenn man eine Klasse auswählt, 
--               wird eine Liste mit Spieler angezeigt, welche der Klasse entsprechen.
--
-- @modul DropDownMenu
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local SA_DropDownMenu = _G.GUI.SA_DropDownMenu

-- Lokalisierung
local SAL = _G.GUI.Locales

-- wird im OnClick benutzt
local DropDownData = {}

-- Für Fehlerbehandlung
local assert, type = assert, type

local BUTTON_HEIGHT = 25

--- Eine Lua Funktion, um die Größe einer Tabelle zu erfahren.
-- 
-- @tparam table T Die Tabelle von welcher man die größe haben möchte
function GetArraySize(T)
	local lengthNum = 0
	for k,v in pairs(T) do -- für jeden key, welcher nicht nil ist  lengthNum++
		lengthNum = lengthNum + 1
	end
	return lengthNum
end

--- Mithilfe dieser Funktion kann man dem OnClickEvent einen EventHandler zuordnen.
--
-- Assertion: Wenn func keine Funktion ist
--
-- @tparam Frame frame Für welchen man die EventHandlerFunktion setzen möchte
-- @tparam function func Die Funktion welche für das OnClick Event gesetzt werden soll
function SA_DropDownMenu:SetOnClick(frame, func)
    assert(type(func) == "function", SAL["'func' in 'DropDownMenu SetOnClick' must be a function."])
	if func then
		frame.ButtonOnClick = func
	else
		frame.ButtonOnClick = nil
	end
end

--- Dient um die Position ausserhalb der Klasse zu verändern.
--
-- @tparam string framePosition Region des Frames
-- @tparam string relativeToFrame Relativ zu welchen Frame positioniert werden soll
-- @tparam string relativePos Relativ zur Region des Frames, zu welchen positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
function SA_DropDownMenu:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

--- Ein Getter für den ausgewählten Item.
--
-- @tparam Frame self The DropDownMenu
local function GetSelectedItem(self)
	return DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"]
end

--- Eine OnClickEventHandling-Funktion für den DropDownMenu.
-- Setzt den Text des Buttons auf den, welcher vom Spieler ausgewählt wurde.
--
-- @tparam Frame self Das DropDownMenu
function OnClick(self)
	--print(">> DropDownMenu OnClick << called "..DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"])  
	UIDropDownMenu_SetText(DropDownMenuButton, DropDownData[UIDROPDOWNMENU_MENU_VALUE["Category"]][self:GetID()]["name"]);
end

--- Eine Setterfunktion für data. Welche dann in der DropDownMenu dargestellt werden.
-- Wenn data leer ist dann wird die Position gelöscht, sowie data und selectedID des Frames werden auf nil gesetzt.
-- Ansonsten übergebe die Tabelle data an das Frame und setze selectedID auf startValue.
-- Wenn startValue gesetzt ist, dann setzte das selectedID der DropDownListe mithilfe von UIDropDownMenu_SetSelectedID().
--
-- @tparam Frame frame Das DropDownMenu
-- @tparam table data Die Tabelle welche in der DropDownListe dargestellt werden soll
-- @tparam int startValue Das Item was zum start angezeigt werden soll
local function SetData(frame, data, startValue)
	if not data then
		frame:ClearAllPoints()
		frame.data = nil
		frame.selectedId = nil
		return
	end
	DropDownData = data
	frame.data = data
	frame.selectedId = startValue
	if startValue then
		UIDropDownMenu_SetSelectedID(frame, startValue) 
	end
end

--- Erstellt ein DropDownMenu.
-- Erstellt einen DropDownMenuButton, welcher die DropDownListe darstellt.
-- Hinzu kommt das DropDownMenu, welches das Menu dargestellt.
-- Es werden dann die Daten für das DropDownMenu gesetzt und ein Label erstellt.
--
-- UIDropDownMenu_Initialize(): Damit wird die Initialisierungfunktion gesetz.
-- UIDropDownMenu_SetButtonWidth(): Damit wird die Breite des Buttons gesetzt.
-- UIDropDownMenu_SetWidth(): Damit wird die Breite für das Label gesetzt(im Button).
-- UIDropDownMenu_JustifyText(): Damit wird das Label justiert.
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string name Name der DropDownMenu
-- @tparam table data Die Daten für das DropDownMenu
-- @tparam function init Die Initialisierungfunktion
local function CreateDropDownButton(frame, buttonName, menuName, data)
	local DropDownMenuButton = CreateFrame("Button", buttonName, frame,"UIDropDownMenuTemplate")
	local DropDownMenu = CreateFrame('Frame', menuName, DropDownMenuButton)
	
	SetData(DropDownMenuButton, data, 1)
	DropDownMenuButton:SetBackdrop({ 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false, tileSize = 10, edgeSize = 20,
	insets = {left = 1, right = 1, top = 5, bottom = 1}
	})
	
	--DropDownMenuButton:SetPoint("LEFT", 20, 0) -- 20 = x
	DropDownMenuButton:SetHeight(BUTTON_HEIGHT)
    	DropDownMenuButton:RegisterForClicks("LeftButtonDown", "RightButtonDown") -- links und rechts Klick
    
    	DropDownMenuButton.label = DropDownMenuButton:CreateFontString("DropDownMenu-label", "ARTWORK", "GameFontNormalSmall")
	--DropDownMenuButton.label:SetPoint("LEFT", DropDownMenu, "LEFT")
	DropDownMenuButton.label:SetHeight(BUTTON_HEIGHT)
	DropDownMenuButton.label:SetText("DropDownMenu-label")
	
	DropDownMenu:Show()

	UIDropDownMenu_Initialize(DropDownMenuButton, InitDDM, "MENU");
    UIDropDownMenu_SetButtonWidth(DropDownMenuButton, DropDownMenuButton.label:GetStringWidth())
    UIDropDownMenu_SetWidth(DropDownMenuButton, DropDownMenuButton.label:GetStringWidth());
    UIDropDownMenu_JustifyText(DropDownMenuButton, "CENTER")
    
    return DropDownMenuButton
end

--- Initialisierungfunktion für das DropDownMenu.
-- Am Anfang wird "Player" für den DropDownMenuButton, als Text gesetzt, sowie für selectedName.
-- Iteriere durch die Tabelle data und setzte die Daten: text, value und func.
-- Erst wird durch die Klassen iteriert und dann im SubArray durh die Spieler.
-- func enthält die Funktion OnClick.
-- Dann füge alles plus den Level der DropDownListe hinzu.
--
-- @tparam Frame self Das DropDownMenu
-- @tparam int level Das Level auf welches das Item gesetzt werden soll(2 Level möglich)
function InitDDM(frame, level) 
frame.selectedName = SAL["Player"];
UIDropDownMenu_SetText(frame, frame.selectedName);

level = level or 1; -- Level 1 daten (Klassen)
   if (level == 1) then
     for cat, subarray in pairs(frame.data) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = true; -- hat ein SubArray
       info.notCheckable = true;
       info.text = SAL[cat];
       info.value = {
         ["Category"] = cat;
       };
       UIDropDownMenu_AddButton(info, level);
     end
   end

	-- Level 2 vom DropDownMenu, wo die Spieler hinzugefügt werden
   if (level == 2) then
     -- Hole das Value vom ersten Level
     local category = UIDROPDOWNMENU_MENU_VALUE["Category"];
     sub = frame.data[category];
     for key, subsub in pairs(sub) do
       local info = UIDropDownMenu_CreateInfo();
       info.hasArrow = false; -- das SubMenu hat kein SubArray
       info.notCheckable = true;
       info.text = subsub["name"];
       info.func = OnClick
       info.value = {
         ["Category"] = category;
         ["Sublevel_Key"] = key;
       };
       UIDropDownMenu_AddButton(info, level);
     end
   end
end

--- Loader für die DropDownListe.
--
-- Assertion: Wenn data keine Tabelle ist
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam table data Die Tabelle welche in der DropDownMenu gesetzt werden soll
function SA_DropDownMenu:LoadDropDownMenu(frame, buttonName, menuName, data)
	assert(type(data) == "table", SAL["'data' must be a table. See 'Init.lua' at _G.GUI.DropDownMenu.data for infos."])
	return CreateDropDownButton(frame, buttonName, menuName, data)
end
