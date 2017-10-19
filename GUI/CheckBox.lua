-- Beschreibung: Diese Klasse stellt eine CheckBox dar.
--				 Welche einen Text besitzt, welcher rechts von der CheckBox positioniert ist.
--
-- @modul CheckBox
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

-- Lokalisierung
local GUIL = _G.GUI.Locales

local SA_CheckBox = _G.GUI.SA_CheckBox

-- F&uumlr Fehlerbehandlung
local assert, type = assert, type

--- Dient um die Position ausserhalb der Klasse zu ver&aumlndern.
--
-- @tparam string framePosition Region des Frames
-- @tparam string relativeToFrame Relativ zu welchen Frame positioniert werden soll
-- @tparam string relativePos Relativ zur Region des Frames, zu welchen positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
function SA_CheckBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

--- Dient zum erstellen der CheckBox.
-- Erst wird das Frame erstellt, dann wird die Position des Frames gel&oumlscht.
-- Dann wird der Text erstellt.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam string checkboxText Text welcher rechts gesetzt werden soll
-- @return Die CheckBox
local function CreateCheckBox(frame, checkboxText, name)
	local CheckBoxFrame = CreateFrame("CheckButton", name, frame, "UICheckButtonTemplate")

	CheckBoxFrame:ClearAllPoints()
	CheckBoxFrame:SetText(GUIL[checkboxText])
	
	CheckBoxFrame.label = CheckBoxFrame:CreateFontString("CheckBoxFrame-label", "ARTWORK", "GameFontNormalSmall")
	CheckBoxFrame.label:SetHeight(25)
	CheckBoxFrame.label:SetText(GUIL[checkboxText])
	CheckBoxFrame.label:SetPoint("LEFT", CheckBoxFrame, "RIGHT", 0,0)
	
	return CheckBoxFrame
end

--- F&uumlhrt CreateCheckBox aus.
--
-- Assertion: Wenn checkboxText kein String ist
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string checkboxText Text welcher rechts von der CheckBox dargestellt werden soll
-- @return CheckBox
function SA_CheckBox:LoadCheckBox(frame, checkboxText, name)
	assert(type(checkboxText) == "string", GUIL["'checkboxText' must be a string."])
	return CreateCheckBox(frame, checkboxText, name)
end

function SA_CheckBox:SetChecked(value)
	self:SetChecked(value)
end

--- Gibt zur&uumlck, ob die CheckBox angekreuzt ist.
-- @treturn boolean Ob die CheckBox angekreuzt ist
function SA_CheckBox:GetChecked()
	return self:GetChecked()
end
