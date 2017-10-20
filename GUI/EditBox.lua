-- Beschreibung: Die Klasse stellt eine EditBox dar, welche in anderen Programmiersprachen auch unter anderem als ein TextField bekannt ist.
--
-- @modul EditBox
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local SA_EditBox = _G.GUI.SA_EditBox

-- Lokalisierung
local GUIL = _G.GUI.Locales

-- F&uumlr Fehlerbehandlung
local assert, type = assert, type

--- Dient um die Position ausserhalb der Klasse zu ver&aumlndern.
--
-- @tparam string framePosition Region des Frames
-- @tparam string relativeToFrame Relativ zu welchen Frame positioniert werden soll
-- @tparam string relativePos Relativ zur Region des Frames, zu welchen positioniert werden soll
-- @tparam int x Bewegung des Buttons in x-Richtung
-- @tparam int y Bewegung des Buttons in y-Richtung
function SA_EditBox:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
	self:SetPoint(framePosition, relativeToFrame,relativePos, x, y)
end

--- Setzt den Text des Labels neu
--
-- @tparam FontString self Die EditBox
-- @tparam string text Der Text welcher im FontString gesetzt werden soll
local function SetLabelText(self, text)
	self.label:SetText(GUIL[text])
end

--- Erstellt einen FontString f&uumlr die EditBox und setzt Text, sowie Fontfarbe.
--
-- @tparam Frame self Die EditBox
-- @tparam string text Welcher den Text f&uumlr den FontString enth&aumllt
-- @tparam float r Rotanteil
-- @tparam float g Gr&uumlnanteil
-- @tparam float b Blauanteil
-- @tparam float a Alphaanteil
local function CreateLabel(self, name, text, r, g, b, a)
	self.label = self:CreateFontString(name.."EditBox-label", "ARTWORK", "GameFontNormalSmall")
	self.label:SetPoint("LEFT", self, "LEFT", 0, 0)
	self.label:SetHeight(25)
	self.label:SetTextColor(r, g, b, a)
	self.label:SetText(GUIL[text])
end

--- Konfiguriert die EditBox, indem die Position gel&oumlscht wird und dann
-- keine mehreren Zeilen erlaubt werden und kein automatischer Fokus gesetzt wird.
--
-- @tparam Frame self Die EditBox
local function ConfigEditBox(self)
	self:ClearAllPoints()
	self:SetMultiLine(false)
	self:SetAutoFocus(false)
	self:ClearFocus() 
	self:EnableMouse(true)
	self:SetHeight(25)
	
	--[[self:SetScript("OnHide", function(self)
	--self.label:SetText("")
		if self.inputType == "string" and self.usedFor == "spell" then
				ConfigLabel(self, "[SpellID] text", 0.5, 0.5, 0.5, 0.8) -- config the label for the editbox
		elseif inputType == "string" and self.usedFor == "name" then
				ConfigLabel(self, "name", 0.5, 0.5, 0.5, 0.8)
		elseif inputType == "string" and self.usedFor == "phaseText" then
				ConfigLabel(self, "Text/HP/Energy/Time", 0.5, 0.5, 0.5, 0.8)
		elseif inputType == "string" and self.usedFor == "phasename" then
				ConfigLabel(self, "phasename(s)", 0.5, 0.5, 0.5, 0.8) 
		elseif inputType == "string" and self.usedFor == "trigger" then
				ConfigLabel(self, "trigger", 0.5, 0.5, 0.5, 0.8)
		elseif self.inputType == "number" and self.usedFor == "timer" then
				ConfigLabel(self, "Time in sec", 0.5, 0.5, 0.5, 0.8)
		elseif self.inputType == "number" and self.usedFor == "cooldown" then
				ConfigLabel(self, "cooldown(s) in sec", 0.5, 0.5, 0.5, 0.8)
		end
		--self:SetText("")
	end)]]
end

--- Die Funktion um eine EditBox zu erstellen.
-- Je nachdem was im inputType und usedFor steht, wird der FontString konfiguriert.
-- Des Weiteren wird f&uumlr den OnTextChanged Event ein EventHandler erstellt.
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string name Ist der Name der EditBox
-- @tparam string inputType Ist der Inputtyp(number or string)
-- @tparam string usedFor Gibt an wof&uumlr die EditBox benutzt wird(timer, cooldown, spell, name, phasename, phaseText, trigger)
-- @return Die EditBox
local function CreateEditBox(frame, name, inputType, usedFor)
	local EditBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")

	EditBox.inputType = inputType -- determinates if inputType is string or number
	EditBox.usedFor = usedFor

	ConfigEditBox(EditBox)
	-- Pr&uumlfe den inputType und wof&uumlr die EditBox benutzt wird
	if inputType == "number" and EditBox.usedFor == "timer" then
		EditBox:SetWidth(frame:GetWidth() * 0.05)
		EditBox:SetNumeric(true) -- set only numeric input
		CreateLabel(EditBox, name, "Time in sec", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "number" and EditBox.usedFor == "offset" then
		EditBox:SetWidth(frame:GetWidth() * 0.05)
		--EditBox:SetNumeric(true) -- set only numeric input
		CreateLabel(EditBox, name, "Time in sec", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "number" and EditBox.usedFor == "cooldown" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		EditBox:SetNumeric(true) -- set only numeric input
		CreateLabel(EditBox, name, "cooldown(s) in sec", 0.5, 0.5, 0.5, 0.8)
	elseif inputType == "string" and EditBox.usedFor == "spell" then
		EditBox:SetWidth(frame:GetWidth() * 0.2)
		CreateLabel(EditBox, name, "[SpellID] text", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "string" and EditBox.usedFor == "name" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		CreateLabel(EditBox, name, "name", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "string" and EditBox.usedFor == "phasename" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		CreateLabel(EditBox, name, "phasename(s)", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "string" and EditBox.usedFor == "phaseText" then
		EditBox:SetWidth(frame:GetWidth() * 0.3)
		CreateLabel(EditBox, name, "Text/HP/Energy/Time", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	elseif inputType == "string" and EditBox.usedFor == "trigger" then
		EditBox:SetWidth(frame:GetWidth() * 0.2)
		CreateLabel(EditBox, name, "trigger", 0.5, 0.5, 0.5, 0.8) -- Konfiguriere den FontString
	end
	
	-- Wenn der Text ge&aumlndert wird, dann f&uumlhre folgendes aus
	EditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then -- Pr&uumlfe ob eine Eingabe geschehen ist
			if self.inputType == "number" then
				if self:GetText() ~= "" then -- Wenn nicht leer
					if self.usedFor == "offset" then
						if tonumber(self:GetText()) then
							if tonumber(self:GetText()) >= -9 and tonumber(self:GetText()) <= 9 then
								self.last = self:GetText()
							else
								if self.last then
									self:SetText(self.last)
								else
									self:SetText("")
								end
							end
						elseif self:GetText() == "-" then
							self:SetText("-")
						else
							self:SetText("")
						end
					elseif tonumber(self:GetText()) <= 0 then -- Wenn die Zahl kleiner gleich 0 ist, dann setzte auf ""
						self:SetText("")
					else
						self:SetText(self:GetText())
					end
				end
			elseif EditBox.inputType == "string" then -- Wenn es ein String ist, setze diesen zu dem
				self:SetText(self:GetText())       -- qas der Spieler eingegeben hat
			end
			self.label:SetText("")
			if string.len(self:GetText()) == 0 then -- Wenn die EditBox leer ist, konfiguriere den FontString erneut
				if self.inputType == "string" and self.usedFor == "spell" then
					SetLabelText(self, "[SpellID] text")
				elseif inputType == "string" and self.usedFor == "name" then
					SetLabelText(self, "name")
				elseif inputType == "string" and self.usedFor == "phasename" then
					SetLabelText(self, "phasename(s)") 
				elseif inputType == "string" and self.usedFor == "phaseText" then
					SetLabelText(self, "Text/HP/Energy/Time")
				elseif inputType == "string" and self.usedFor == "trigger" then
					SetLabelText(self, "trigger")
				elseif self.inputType == "number" and self.usedFor == "timer" then
					SetLabelText(self, "Time in sec")
				elseif self.inputType == "number" and self.usedFor == "cooldown" then
					SetLabelText(self, "cooldown(s) in sec")
				elseif inputType == "number" and self.usedFor == "offset" then
					SetLabelText(self, "Time in sec") -- Konfiguriere den FontString
				end
			end
		end
	end
	end)
	return EditBox
end


--- Mit diesem Setter setzt man die maximal erlaubten Zeichen, welche der Spieler
-- in die EditBox eingeben kann.
--
-- Assertion: Wenn max kleiner gleich 0 ist
--
-- @tparam Frame self Die EditBox
-- @tparam int max Die Begrenzung(Anzahl Zeichen)
function SA_EditBox:SetMaxLetters(self, max)
	assert(max > 0, GUIL["'max' must be greater than 0."])
	self:SetMaxLetters(max)
end

--- Loader f&uumlr die EditBox.
--
-- Assertion: Wenn der inputType nicht gleich string oder number ist
--
-- @tparam Frame frame Ist das Elternframe.
-- @tparam string inputType Ist der Inputtyp(number or string)
-- @tparam string usedFor Gibt an wof&uumlr die EditBox benutzt wird(timer, cooldown, spell, name, phasename, phaseText, trigger)
-- @return EditBox
function SA_EditBox:LoadEditBox(frame, name, inputType, usedFor)
	assert((inputType == "string" or inputType == "number"), GUIL["'inputType' must be string or number."])
	return CreateEditBox(frame, name, inputType, usedFor)
end
