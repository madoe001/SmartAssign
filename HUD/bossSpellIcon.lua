--- Beschreibung: Diese Klasse stellt ein SpellIcon zur Verfügung.
--                Welche ein Icon des Zaubers und die verbleibende Zeit beinhaltet
--
-- @modul bossSpellIcon
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

-- Lokalisierung
local HL = _G.HUD.Locales

local bossSpellIcon = _G.HUD.BossSpellIcon

-- Variablen
local TimeSinceLastUpdate = 0.0 -- Zeit die welche vergangen ist, seit dem letzten OnUpdate Event
local name
local channeling = false -- Zum Prüfen, ob der Boss einen Zauber kanalisiert
local iconFrame

--- Funktion zum erstellen des SpellIcons.
-- Es wird ein FonstString und ein Icon für den SpellIcon erstellt.
--
-- @tparam Frame frame Ist das Elternframe
-- @tparam string unit Ist immer target
function bossSpellIcon:CreatebossSpellIcon(frame, unit)
	iconFrame = CreateFrame("Frame", "iconFrame", frame)
	iconFrame.label = iconFrame:CreateFontString("SpellIcon-label", "ARTWORK", "GameFontNormalSmall")
	iconFrame.icon = iconFrame:CreateTexture("iconFrameTexture","BACKGROUND")
	iconFrame.updateIntervall = 1.0 -- Wird gebraucht um festzusetzen wann immer der innere Teil des OnUpdateHandlers aufgerufen werden soll
	
	iconFrame.unit = unit
end

--- EventHandlingfunktion für den bossSpellIcon.
-- Es wird geprüft, ob der Boss einen Zauber aufruft oder kanalisiert.
-- Sowie ob er den beenedet hat.
-- Vorbedingungen werden immer mit PreCheck geprüft, bevor was zu dem
-- entsprechenden Event passiert.
--
-- Geprüfte Events:
-- UNIT_SPELLCAST_START: Wenn jemand einen Zauber startet.
-- UNIT_SPELLCAST_CHANNEL_START: Wenn jemand einen Zauber anfängt zu kanalisieren.
-- UNIT_SPELLCAST_STOP: Wenn jemand seinen Zauber stopt.
-- UNIT_SPELLCAST_CHANNEL_STOP: Wenn jemand die Kanalisierung seines Zaubers stopt.
-- UNIT_SPELLCAST_SUCCEEDED: Verursachte einen Fehler, weswegen nicht mehr in Benutztung.
-- 
-- @tparam Event event Das Event der gefeuert wurde
-- @param ... Restlichen Daten
function bossSpellIcon:OnEvent(event, ...)
	name = UnitName(iconFrame.unit)
	local canAttack = UnitCanAttack(iconFrame.unit, "player") -- Ob der fokusierte den Spieler angreifen kann
	if event == "UNIT_SPELLCAST_START" then
		if bossSpellIcon:PreCheck(canAttack) then 
			bossSpellIcon:BossCastingInfo(iconFrame.unit)
			bossSpellIcon:CreateSpellIcon()
			iconFrame:Show()
			iconFrame:SetScript("OnUpdate", bossSpellIcon.IconTextUpdate)
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_START" then
		if bossSpellIcon:PreCheck(canAttack) then
			bossSpellIcon:BossChannelingInfo(iconFrame.unit)
			bossSpellIcon:CreateSpellIcon()
			iconFrame:Show()
		end
	end
	if event == "UNIT_SPELLCAST_STOP" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
			iconFrame.SpellStartsIn = 0.0
		end
	end
	if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
		end
	end
	--[[if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if bossSpellIcon:PreCheck(canAttack) then
			iconFrame:Hide()
			iconFrame:SetScript("OnUpdate", nil)
		end
	end]] -- makes problems
end

--- Eine Funktion um alle Events in einem Zug zu registrieren.
function RegisterAllEvents()
	iconFrame:RegisterEvent("UNIT_SPELLCAST_START", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", iconFrame.unit)
	iconFrame:RegisterEvent("UNIT_SPELLCAST_STOP", iconFrame.unit)
	--iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
end

--- Eine Funktion um alle Events in einem Zug zu deregistrieren.
function UnRegisterAllEvents()
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_START", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", iconFrame.unit)
	iconFrame:UnregisterEvent("UNIT_SPELLCAST_STOP", iconFrame.unit)
	--iconFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
end

--- Eine Funktion um alle Vorbedingungen zu prüfen.
-- Ob der fokusierte Boss existiert, sowie nicht Tod oder ein Geist ist.
-- Des Weiteren darf er kein Spieler sein und muss den Spieler angreifen können.
--
-- @tparam boolean canAttack Eine Variable die vorher durch eine Funktion ermittelt wird. Ob der fokusierte Boss den Spieler angreifen kann.
-- @return Ob die Bedingungen erfüllt wurden
function bossSpellIcon:PreCheck(canAttack)
	local check = false
	if  UnitExists(iconFrame.unit) then
		if not UnitIsDeadOrGhost(iconFrame.unit) then
			if not UnitIsPlayer(iconFrame.unit) then
				if canAttack then
					check = true
				end
			end
		end
	end
	return check
end

--- Die Funktion holt alle Informationen zu einen Zauber welche vom Boss gewirkt wird.
-- Und speicher diese ab.
--
-- @tparam string unit Ist immer target
function bossSpellIcon:BossCastingInfo(unit)
	local name, _, _, texture, _, _, _, _, notInterruptible, spellID = UnitCastingInfo(unit)
	iconFrame.spell = name
	iconFrame.spellID = spellID
	iconFrame.tex = texture
	iconFrame.SpellStartsIn = bossSpellIcon:BossCastingTime(iconFrame.spell, unit, true) -- Berechnung mittels Funktion, wann der Zauber gewirkt wird

	channeling = false -- Ist nich am Kanalisieren
end

--- Diese Funktion wird in BossCastingTime benutzt.
-- Es wird zu einem Zauber spellname, spellStart und spellEnd geholt, welche dann in der oben genannten Funktion von nöten sind.
--
-- @tparam string spell der Zauberspruch
-- @tparam string unit Ist immer target
-- 
-- @return spellname, spellStart sowie spellEnd
function bossSpellIcon:BossIsCasting(spell, unit)
	unit = unit or not 'player'
	if not UnitExists(unit) then 
		return 
	end
	local spellName, _, _, _, spellStart, spellEnd, _, spellId = UnitCastingInfo(unit)
	if not spellName then 
		return 
	end
	if spell then -- Ob nicht nil
		if type(spell) == "string" then -- Ob string
			if spellName == spell then -- Ob beide Zauber auch die gleichen sind
				return spellName, spellStart, spellEnd
			end
		elseif type(tonumber(spell)) == "number" then
			if tonumber(spell) == spellId then 
				return spellName, spellStart, spellEnd
			end
		end    
	else
		return spellName, spellStart, spellEnd
	end
end

--- Eine Funktion welche die noch zu verbleibende Zeit berechnet, wann ein Zauber gewirkt wird oder dieser zu ende ist.
-- Um Sekunden zu bekommen wird durch 1e3 geteilt und gerundet mit round.
--
-- @tparam string spell Der Zaubername
-- @tparam string unit Ist immer target
-- @tparam boolean remaining Wenn die verbleibende Zeit bis wann gewirkt wird berechnet werden soll, ansosten False wann zu ende ist
-- @return Gibt eine Zeit in Sekunden zurück
function bossSpellIcon:BossCastingTime(spell, unit, remaining)
	local _, startTime, endTime = bossSpellIcon:BossIsCasting(spell, unit)
	if startTime and endTime then
		if remaining then
			return round(((endTime - (GetTime() * 1e3)) / 1e3), 2)
		else
			return round((((GetTime() * 1e3) - startTime) / 1e3), 2)
		end
	end
end

--- Die Funktion holt alle Informationen zu einen Zauber welche vom Boss kanalisiert wird.
-- Und speicher diese ab.
--
-- @tparam string unit Ist immer target
function bossSpellIcon:BossChannelingInfo(unit)
	local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
	iconFrame.spell = name
	iconFrame.tex = texture
	iconFrame.channelingTime = bossSpellIcon:BossChannelingTime(iconFrame.spell, unit, true)
	channeling = true -- Ist am Kanalisieren
end

--- Diese Funktion wird in BossChannelingTime benutzt.
-- Es wird zu einem Zauber spellname, spellStart und spellEnd geholt, welche dann in der oben genannten Funktion von nöten sind.
--
-- @tparam string spell der Zauberspruch welcher kanalisiert wird
-- @tparam string unit Ist immer target
-- 
-- @return spellname, spellStart sowie spellEnd
function bossSpellIcon:BossIsChanneling(spell, unit)
	unit = unit or 'player'
	if not UnitExists(unit) then
		return 
	end
	local spellName, _, _, _, spellStart, spellEnd = UnitChannelInfo(unit)
	if not spellName then 
		return 
	end
	if spell then
		if type(spell) == 'string' then
			if spellName == spell then 
				return spellName, spellStart, spellEnd 
			end
		end    
	else
		return spellName, spellStart, spellEnd
	end
end

--- Eine Funktion welche die noch zu verbleibende Zeit berechnet, wie lange ein Zauber kanalisiert wird oder wann er kanalisiert wird.
-- Um Sekunden zu bekommen wird durch 1e3 geteilt und gerundet mit round.
--
-- @tparam string spell Der Zaubername
-- @tparam string unit Ist immer target
-- @tparam boolean remaining Wenn die verbleibende Zeit bis wann kanalisiert wird berechnet werden soll, ansosten False wann die Restzeit der Kanalisierung benötigt wird.
-- @return Gibt eine Zeit in Sekunden zurück
function bossSpellIcon:BossChannelingTime(spell, unit, remaining)
local _, startTime, endTime = bossSpellIcon:BossIsChanneling(spell, unit)
	if startTime and endTime then
		if remaining then
			return ((endTime - (GetTime() * 1e3)) / 1e3)
		else
			return (((GetTime() * 1e3) - startTime) / 1e3)
		end
	end
end

--- Mit dieser Funktion erstellt man alle nötigen Komponenten für den SpellIcon.
-- Einen Icon und Label(als Textur).
function bossSpellIcon:CreateSpellIcon()
	iconFrame:SetSize(80, 80)
	
	iconFrame.icon:SetSize(50, 50)
	iconFrame.icon:ClearAllPoints()
	iconFrame.icon:SetPoint("CENTER", iconFrame, 0, 0)
	iconFrame.icon:SetTexture(iconFrame.tex)
	
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint('CENTER', frame, 0, 300)
	
	iconFrame.label:ClearAllPoints()
	iconFrame.label:SetPoint("TOP", iconFrame, "BOTTOM", 0, -10)
	iconFrame.label:SetTextHeight(16)
	if channeling then -- Prüfe ob Zauber kanalisiert wird
		iconFrame.label:SetText(iconFrame.spell..HL[" is channeling now!"].."\n".."|cFFFF0000"..iconFrame.channelingTime..HL[" sec remaining"].."|r")
	elseif iconFrame.SpellStartsIn then
		iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
	else
		iconFrame.label:SetText("|cFFFF0000"..HL["Starts to cast "]..iconFrame.spell.."|r")
	end
	TimeSinceLastUpdate = 0.0
end

--- Die OnUpdate EventHandlingfunktion.
-- In welcher geprüft wird ob seit dem letzten OnUpdateEvent zeit vergangen ist.
-- Wenn nil dann return.
-- Ansonsten ob ein Zauber gestartet oder kanalisiert wird und ob genug Zeit vergangen ist, seit dem letzen OnUpdate.
-- Dementsprechend aktualisiere die Zeit im Label.
--
-- @tparam float elapsed Die Zeit, die seit dem letzten OnUpdateEvent vergangen ist)
function bossSpellIcon:IconTextUpdate(elapsed)
	if elapsed == nil then -- Prüfe ob elapsed nicht nil ist, wenn ja initialisiere
		elapsed = 0.0
	end
	if iconFrame.SpellStartsIn then -- Prüfe ob ein Wert gespeichert ist
		TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
		while TimeSinceLastUpdate > iconFrame.updateIntervall do
			if iconFrame.SpellStartsIn then
				iconFrame.SpellStartsIn = iconFrame.SpellStartsIn - iconFrame.updateIntervall
				if iconFrame.SpellStartsIn <= 0.0 then -- Wenn der Zauber gewirkt wurde
					TimeSinceLastUpdate = 0.0
				else
					iconFrame.label:SetText(HL["Starts in "]..iconFrame.SpellStartsIn..HL[" sec"])
				end
			elseif iconFrame.channelingTime then -- Prüfe ob ein Zauber kanalisiert wird
				iconFrame.channelingTime = iconFrame.channelingTime - iconFrame.updateIntervall
				if iconFrame.channelingTime <= 0.0 then -- Wenn der Zauber zu ende kanalisiert wurde
					TimeSinceLastUpdate = 0.0
				else
					iconFrame.label:SetText("|cFFFF0000"..iconFrame.channelingTime..HL[" sec remaining"].."|r")
				end
			end
			TimeSinceLastUpdate = TimeSinceLastUpdate - iconFrame.updateIntervall
		end
	end
end

--- Eine Funktion, um ausserhalb den SpellIcon anzuzeigen.
--
-- @tparam boolean isGUID Ob eine GUID da ist(Eines Bosses)
function bossSpellIcon:Show(isGUID)
	if iconFrame then
		if isGUID then
			iconFrame:SetScript("OnEvent", bossSpellIcon.OnEvent)
			RegisterAllEvents()
		else
			UnRegisterAllEvents()
		end
	end
end
