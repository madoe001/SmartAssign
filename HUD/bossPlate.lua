--- Beschreibung: Diese Klasse stellt eine Namensplatte f&uumlr einen Boss zur Verf&uumlgung.
--                Welche die Lebenspunkte, sowie die Manapunkte enth&aumllt.
--                Energie- oder Wutpunkte sind noch nicht implementiert.
--				  Des Weiteren werden unter der Namensplatte die DebuffIcons des Bosses angezeigt.
--
-- @modul bossplate
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local bossPlate = _G.HUD.BossPlate

-- Lokalisierung
local HL = _G.HUD.Locales
 
-- Variablen
local name
local health
local mana

local SA_BossNamePlate -- HauptFrame f&uumlr alle Komponenten
local debuffs = {} -- debuff Container

--- Mithilfe dieser Funktion wird die Namensplatte erstellt, wo dann alle Komponenten drin positioniert werden.
-- Dann werden die Komponenten erstellt.
-- Sowie f&uumlr Events(OnEvent, OnUpdate) Eventhandlingfunktionen gesetzt.
--
-- @tparam Frame frame Ist das Elternframe
function bossPlate:CreateBossPlate(frame, unit)
	SA_BossNamePlate = CreateFrame("Frame", "BossNameplate", frame)
	SA_BossNamePlate:SetWidth(160)
	SA_BossNamePlate:SetHeight(100)
	SA_BossNamePlate:ClearAllPoints()
	SA_BossNamePlate:SetPoint("CENTER", frame:GetWidth()*0.15, frame:GetHeight()*0.15)
	
	bossPlate:CreateNamePlateComp(frame)
	
	bossPlate:RegisterAllEvents()
	SA_BossNamePlate:SetScript("OnEvent",bossPlate.OnEvent)
	SA_BossNamePlate:SetScript("OnUpdate", function(elapsed) 
							bossPlate:GetBossDebuffs() -- get debuffs
							bossPlate:ConfigBossDebuffIcons() -- config debuffsend
							end)
	
	SA_BossNamePlate.unit = unit
end

--- In dieser Funktion wird auf alle Events gepr&uumlft und dann dementsprechen reagiert.
--
-- Gepr&uumlfte Events:
-- PLAYER_TARGET_CHANGED: Wenn der Spieler seinen Fokus wechselt.
-- PLAYER_REGEN_DISABLED: Wird ausgel&oumlst, wenn die Lebens- und Energieregeneration des Spielers unterbrochen wird.
-- UNIT_HEALTH: Wenn sich die Lebenspunkte von jemanden &aumlndern.
-- UNIT_MANA: Wenn sich die Manapunkte von jemanden &aumlndern.
--
-- @tparam Event event Das Event der gefeuert wurde
-- @param ... Restlichen Daten
function bossPlate:OnEvent(event, ...)
	if event ==  "PLAYER_TARGET_CHANGED" then
		local name =  GetUnitName("target") -- get name of target and of the bosses in instance
		local boss1 = GetUnitName("boss1")
		local boss2 = GetUnitName("boss2")
		local boss3 = GetUnitName("boss3")
		local boss4 = GetUnitName("boss4")
		local boss5 = GetUnitName("boss5")
		if name == boss1 then
			SetTarget("boss1")
		elseif name == boss2 then
			SetTarget("boss2")
		elseif name == boss3 then
			SetTarget("boss3")
		elseif name == boss4 then
			SetTarget("boss4")
		elseif name == boss5 then
			SetTarget("boss5")
		end
		bossPlate:ReorderAllDebuffs() -- Ordne alle debuffs neu
		bossPlate:ResetAll() -- reset all debuffs
		local canAttack = UnitCanAttack(SA_BossNamePlate.unit, "player") -- Wenn der Fokusierte den Spieler angreifen kann
		if  UnitExists(SA_BossNamePlate.unit) then -- Pr&uumlfe ob der Fokusierte existiert
			if not UnitIsDeadOrGhost(SA_BossNamePlate.unit) then -- Pr&uumlfe ob der Fokusierte tod oder ein Geist ist
				if not UnitIsPlayer(SA_BossNamePlate.unit) then -- Pr&uumlfe ob der Fokusierte ein Spieler ist
					if canAttack then -- Nur wenn der Fokusierte den Spieler angreifen kann
						manaBar:Hide() -- Verberge erst einmal den Manabalken
						bossPlate:CreateBossName()
						bossPlate:ShowHealth()
						bossPlate:ShowMana()
						healthBar:Show()
						bossPlate:GetBossDebuffs() -- Hole debuffs
						bossPlate:ConfigBossDebuffIcons() -- Konfiguriere debuffs
						SA_BossNamePlate:Show() -- Zeige die Namensplatte
					else
						SA_BossNamePlate:Hide() -- Verberge die Namensplatte
					end
				else
					SA_BossNamePlate:Hide() -- Verberge die Namensplatte
				end
			end
		else
			SA_BossNamePlate:Hide() -- Verberge die Namensplatte
			manaBar:Hide() -- Verberge den Manabalken
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		manaBar:Hide() -- Verberge Manabalken erst, wenn er angezeigt wird
		bossPlate:ShowHealth()
		bossPlate:ShowMana()
		bossPlate:GetBossDebuffs() -- Hole Debuffs
		bossPlate:ConfigBossDebuffIcons() -- Konfiguriere debuffs
	elseif event == "UNIT_HEALTH" then -- Erneuere die Lebens- und Manapunkte
		health = UnitHealth(SA_BossNamePlate.unit)
		mana = UnitMana(SA_BossNamePlate.unit)
		bossPlate:GetBossDebuffs() -- Hole Debuffs
		bossPlate:ConfigBossDebuffIcons() -- Konfiguriere debuffs
		bossPlate:SetNewValues(health, mana)
	elseif event == "UNIT_MANA" then -- Erneuere die Lebens- und Manapunkte
		mana = UnitMana(SA_BossNamePlate.unit)
		health = UnitHealth(SA_BossNamePlate.unit)
		bossPlate:SetNewValues(health, mana)
		bossPlate:GetBossDebuffs() -- Hole Debuffs
		bossPlate:ConfigBossDebuffIcons() -- Konfiguriere debuffs
	elseif event == "UNIT_AURA" then
		bossPlate:ResetExpiredDebuff() -- Setze abgelaufende Debuffs zur&uumlck
		bossPlate:GetBossDebuffs() -- Hole Debuffs
		bossPlate:ConfigBossDebuffIcons() -- Konfiguriere debuffs
	end
end

--- Eine Funktion um alle Events in einem Zug zu registrieren.
function bossPlate:RegisterAllEvents()
	SA_BossNamePlate:RegisterEvent("PLAYER_TARGET_CHANGED")
	SA_BossNamePlate:RegisterEvent("PLAYER_REGEN_DISABLED")
	SA_BossNamePlate:RegisterEvent("UNIT_HEALTH")
	SA_BossNamePlate:RegisterEvent("UNIT_MANA")
	SA_BossNamePlate:RegisterEvent("UNIT_AURA")
end

--- Eine Funktion um alle Events in einem Zug zu deregistrieren.
function bossPlate:UnRegisterAllEvents()
	SA_BossNamePlate:UnregisterEvent("PLAYER_TARGET_CHANGED")
	SA_BossNamePlate:UnregisterEvent("PLAYER_REGEN_DISABLED")
	SA_BossNamePlate:UnregisterEvent("UNIT_HEALTH")
	SA_BossNamePlate:UnregisterEvent("UNIT_MANA")
	SA_BossNamePlate:UnregisterEvent("UNIT_AURA")
end

--- Diese Funktion Konfiguriert die Komponenten der Namensplatte.
-- Komponenten sind Name, ManaBar, HealthBar
--
-- @tparam Frame frame Ist das Elternframe
function bossPlate:CreateNamePlateComp(frame)
	SA_BossNamePlate.name = SA_BossNamePlate:CreateFontString("name-label", "ARTWORK", "GameFontNormalSmall") -- name of boss
	
	healthBar = CreateFrame("StatusBar", "healthBar", SA_BossNamePlate) -- healtBar
	healthBar.label = healthBar:CreateFontString("HealthBar-label", "ARTWORK", "GameFontNormalSmall") -- label how much health of max health the boss have
	
	manaBar = CreateFrame("StatusBar", "manaBar", SA_BossNamePlate) -- manaBar
	manaBar.label = manaBar:CreateFontString("ManaBar-label", "ARTWORK", "GameFontNormalSmall") -- label how much mana of max mana the boss have
end

--- In dieser Funktion wird der Text f&uumlr den Namen des Bosses Konfiguriert.
function bossPlate:CreateBossName()
	SA_BossNamePlate.name:SetHeight(SA_BossNamePlate:GetHeight() * 0.5)
	SA_BossNamePlate.name:SetText(name)
	SA_BossNamePlate.name:ClearAllPoints()
	SA_BossNamePlate.name:SetPoint("TOP", SA_BossNamePlate, 0,0)
end

--- Diese Funktion benutzt man, um der HealthBar und der ManaBar ein Value neu zuzuordnen.
-- Damit kann man die ManaBar und HealthBar aktuallisieren.
--
-- @tparam int health Die neuen Lebenspunkte
-- @tparam int mana Die neuen Manapunkte
function bossPlate:SetNewValues(health, mana)
	healthBar:SetValue(health)
	healthBar.label:SetText(UnitHealth(SA_BossNamePlate.unit).."/"..UnitHealthMax(SA_BossNamePlate.unit))
	manaBar:SetValue(mana)
	manaBar.label:SetText(UnitMana(SA_BossNamePlate.unit).."/"..UnitManaMax(SA_BossNamePlate.unit))
end

--- Mit dieser Funktion wird die HealthBar und seine Komponenten erstellt, sowie konfiguriert.
-- Am Ende wird die maximalen Lebenspunkte und die aktuellen Lebenspunkte gesetzt.
function bossPlate:ShowHealth()
	bossPlate:ConfigHealthBar()
	bossPlate:HealthBackground()
	bossPlate:HealthLabel()
					
	healthBar:SetMinMaxValues(0, UnitHealthMax(SA_BossNamePlate.unit)) -- UnitHealthMax(<SA_BossNamePlate.unit>) gibt maximale Lebenspunkte zur&uumlck
	healthBar:SetValue( UnitHealth(SA_BossNamePlate.unit)) -- UnitHealth(<SA_BossNamePlate.unit>) gibt aktuelle Lebenspunkte zur&uumlck
end

--- Mit dieser Funktion kann man die HealthBar konfigurieren
function bossPlate:ConfigHealthBar()
	healthBar:ClearAllPoints()
	healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	healthBar:SetWidth(150)
	healthBar:SetHeight(20)
	healthBar:SetStatusBarColor(1,0,0)
	healthBar:SetPoint("RIGHT", SA_BossNamePlate, -12, 0)
end

--- Mit dieser Funktion wird der Hintergrund der HealthBar konfiguriert und gesetzt.
function bossPlate:HealthBackground()
	healthBar.bg = healthBar:CreateTexture("healthBarBorderTexture", "BORDER")
	healthBar.bg:SetTexture(0,0,0)
	healthBar.bg:ClearAllPoints()
	healthBar.bg:SetPoint("CENTER", healthBar, 0, -10)
	healthBar.bg:SetWidth(healthBar:GetWidth() + 1.5)
	healthBar.bg:SetHeight(healthBar:GetHeight() + 1.5)
end

--- Mit dieser Funktion wird der FontString f&uumlr die HealthBar konfiguriert
function bossPlate:HealthLabel()
	healthBar.label:SetHeight(healthBar:GetHeight() - 1)
	healthBar.label:SetText(UnitHealth(SA_BossNamePlate.unit).."/"..UnitHealthMax(SA_BossNamePlate.unit))
	healthBar.label:ClearAllPoints()
	healthBar.label:SetPoint("LEFT", healthBar, "LEFT", 0,0)
end

--- Mit dieser Funktion wird nach einer Pr&uumlfung, ob der Boss Mana besitzt die ManaBar und seine Komponenten erstellt, sowie konfiguriert.
-- Am Ende wird die maximalen Manapunkte und die aktuellen Manapunkte gesetzt.
function bossPlate:ShowMana()
	if UnitMana(SA_BossNamePlate.unit) ~= 0 then
		bossPlate:ConfigManaBar()
		bossPlate:ManaBackground()
		bossPlate:ManaLabel()
						
		manaBar:SetMinMaxValues(0, UnitManaMax(SA_BossNamePlate.unit)) -- UnitManaMax(<SA_BossNamePlate.unit>) gibt maximale Manapunkte zur&uumlck
		manaBar:SetValue( UnitMana(SA_BossNamePlate.unit)) -- UnitMana(<SA_BossNamePlate.unit>) gibt aktuelle Manapunkte zur&uumlck
		manaBar:Show()
	end
end

--- Mit dieser Funktion kann man die ManaBar konfigurieren
function bossPlate:ConfigManaBar()
	manaBar:ClearAllPoints()
	manaBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	manaBar:SetWidth(150)
	manaBar:SetHeight(20)
	manaBar:SetStatusBarColor(0,0,1, 0.5)
	manaBar:SetPoint("TOP", healthBar, "BOTTOM", 0, 0)
end

--- Mit dieser Funktion wird der Hintergrund der ManaBar konfiguriert und gesetzt.
function bossPlate:ManaBackground()
	manaBar.bg = manaBar:CreateTexture("manaBarBorderTexture", "BORDER")
	manaBar.bg:SetTexture(0,0,0)
	manaBar.bg:ClearAllPoints()
	manaBar.bg:SetPoint("CENTER", manaBar, 0, -10)
	manaBar.bg:SetWidth(manaBar:GetWidth() + 1.5)
	manaBar.bg:SetHeight(manaBar:GetHeight() + 1.5)
end

--- Mit dieser Funktion wird der FontString f&uumlr die ManaBar konfiguriert
function bossPlate:ManaLabel()
	manaBar.label:SetHeight(manaBar:GetHeight() - 1)
	manaBar.label:SetText(UnitMana(SA_BossNamePlate.unit).."/"..UnitManaMax(SA_BossNamePlate.unit))
	manaBar.label:ClearAllPoints()
	manaBar.label:SetPoint("LEFT", manaBar, "LEFT", 0,0)
end

--- Mithilfe dieser Funktion erh&aumllt man den Cooldown des Debuffs.
-- 
-- @tparam string spell Der Debuffname
-- @tparam float totalDuration Gibt bei True die ganze Zeit zur&uumlck, bei false die &uumlbrige Zeit
-- @return einen float wert
function bossPlate:GetSpellCooldown(spell, totalDuration)
	if not spell then 
		return
	end 
	local start, duration, enabled = GetSpellCooldown(spell)
    if not start then 
		return start 
    end 
    if totalDuration then 
		return duration 
	end 
	if start == 0 then 
		return start 
	end
    return (start + duration - GetTime())
end

--- Konfiguriert mithilfe von anderen Funktionen die Debuffs.
function bossPlate:ConfigBossDebuffIcons()
	for i = 1, #debuffs do
		local debuff = debuffs[i]
		if debuff.expTime then
			 bossPlate:ConfigDebuffExpireStatusBar(debuff)
			 --bossPlate:ConfigExpireLabel(debuff) -- nicht alle Codeteile implementiert
		end
		bossPlate:ConfigDebuffIconTexture(debuff, i)
		if debuff.count ~= 0 then -- Nur wenn der Zauber gestapelt werden kann
			bossPlate:ConfigCountLabel(debuff)
		end
	end
end

--- Konfiguriert einen Debufficon und positioniere ihn.
--
-- @tparam Frame debuff Der Debuff f&uumlr welchen der Icon konfiguriert werden soll
-- @tparam int placeInTable Platz des Debuffs im Container
function bossPlate:ConfigDebuffIconTexture(debuff, placeInTable)
	debuff.icon:SetSize(25, 25)
	debuff.icon:ClearAllPoints()
	debuff.icon:SetPoint("CENTER", debuff, 0, 0)
	debuff.icon:SetAlpha(1)
	
	if placeInTable == 1 then -- der erste Debuff
		if UnitMana(SA_BossNamePlate.unit) ~= 0 then
			debuff:SetPoint("TOPLEFT", manaBar, "BOTTOMLEFT", 0, 0)
		else
			debuff:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, 0)
		end
	elseif placeInTable % 6 == 0 then -- Nur 6 Debuffs in einer Reihe
		debuff:SetPoint("TOP", debuffs[placeInTable-5], "BOTTOM", 0, -1)
	elseif placeInTable > 1 and debuffs[1] then -- Sonst werden sie nebeneinander platziert
		debuff:SetPoint("LEFT", debuffs[placeInTable-1], "RIGHT", 1, 0)
	end
	debuff.icon:SetTexture(debuff.tex)
	
end

--- Mit dieser Function kann man im Debufficon einen FontString konfigurieren, anzeigt wie oft der Debuff gestapelt wurde.
--
-- @tparam Frame debuff In welchen der FontString konfiguriert werden soll
function bossPlate:ConfigCountLabel(debuff)
	debuff.countLabel:ClearAllPoints()
	debuff.countLabel:SetPoint("BOTTOMRIGHT", debuff, -1, 1)
	debuff.countLabel:SetTextHeight(10)
	debuff.countLabel:SetText(debuff.count)
end

--- Mit dieser Function kann man im Debufficon einen FontString konfigurieren, welcher einen Countdown anzeigt.
-- Wie lange der Debuff noch wirkt.
--
-- @tparam Frame debuff In welchen der FontString konfiguriert werden soll
function bossPlate:ConfigExpireLabel(debuff)
	debuff.expireLabel:ClearAllPoints()
	debuff.expireLabel:SetPoint("CENTER", debuff, 0, 0)
	debuff.expireLabel:SetTextHeight(18)
	debuff.expireLabel:SetText(debuff.expTime)
	debuff.isExpireLabel = false
end

--- Mit dieser Funktion bekommt man alle Debuffs eines fokusierten Bosses.
-- Jeder Debuff wird dann mit AddBossDebuff konfiguriert und in den Debuffcontainer gepackt.
function bossPlate:GetBossDebuffs()
	for i=1,40 do
		local name, _, icon, count, _, duration, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff(SA_BossNamePlate.unit,i)
		if name then
			bossPlate:AddBossDebuff(name, icon, count, duration, round(-(GetTime() - expirationTime), 0))
		end
	end
end

--- In dieser Funktion wird der Frame f&uumlr den Debuff erstellt und alle n&oumltigen Variablen gesetzt.
-- Dann wird dieser und die Komponenten konfiguriert.
-- Der Debuff ist eine StatusBar mit einem Icon als Hintergrund.
--
-- @tparam string name Debuffname
-- @tparam string texture Der Texturname zu dem Debuff
-- @tparam int count Wie oft der Debuff gestapelt ist
-- @tparam float duration Wie lange der Debuff dauert(Komplette Dauer nicht Restdauer)
-- @tparam float expirationTime Zeit wann der Debuff abl&aumluft, man hat aber nicht imme eine Zeit
function bossPlate:AddBossDebuff(name, texture, count, duration, expirationTime)
	if not bossPlate:BossDebuffContains(name) then -- if debuff contains
		local debuffIconFrame = CreateFrame("StatusBar", name.."debuffIconFrame", SA_BossNamePlate)
		debuffIconFrame.name = name
		debuffIconFrame.tex = texture
		debuffIconFrame.count = count
		debuffIconFrame.duration = duration
		debuffIconFrame.expTime = expirationTime
		debuffIconFrame:SetAttribute("exptime", expirationTime) -- Setze den Attribut, um sp&aumlter in OnAttributeChanged zu pr&uumlfen
		debuffIconFrame:SetAttribute("count", count)
		debuffIconFrame:SetScript("OnAttributeChanged", bossPlate.DebuffOnAttributeChanged) -- Wenn ein Attribut sich &aumlndert, dann wird bossPlate.DebuffOnAttributeChanged aufgerufen
		debuffIconFrame:SetScript("OnUpdate", bossPlate.UpdateBossDebuffs)
		debuffIconFrame:SetScript("OnHide", bossPlate.OnIconHide)
		
		bossPlate:CreateDebuffIconComp(debuffIconFrame, count) -- Erstelle Komponenten
		tinsert(debuffs, debuffIconFrame) -- F&uumlge in den Container hinzu
		debuffIconFrame.place = #debuffs
	else
	end
end

--- Diese Funktion aktuallisiert die Debufficons.
function bossPlate:UpdateBossDebuffs()
	for i=1,40 do
		local name, _, _, count, _, _, expirationTime,
		_, _, _, spellId, _, _, _, _, _, _, _ = UnitDebuff(SA_BossNamePlate.unit,i)
		if name then
			bossPlate:UpdateDebuff(name, count, round(-(GetTime() - expirationTime), 0))
		end
	end
	for i = 1, #debuffs do -- Ordne Debuffs neu
		bossPlate:ReorderDebuffIcon(debuffs[i], i)
	end
end

--- Aktualisiere einen Debuff und seine Variablen, sowie Attribute.
--
-- @tparam string name Der Debuffname
-- @tparam int count Wie oft der Debuff gestapelt ist
-- @tparam float expirationTime Zum aktuallisieren der Restzeit
function bossPlate:UpdateDebuff(name, count, expirationTime)
	if expirationTime > 1 then
		local debuff = bossPlate:GetBossDebuff(name)
		debuff:SetSize(28,28)
		if debuff then
			if count > 0 then -- Nur wenn Debuff gestapelt
				debuff.count = count
				debuff:SetAttribute("count", count)
			end
			debuff.expTime = expirationTime
			debuff:SetAttribute("exptime", expirationTime) -- Setze den Attribut, um sp&aumlter in OnAttributeChanged zu pr&uumlfen
		end
	else
		local debuff = bossPlate:GetBossDebuff(name)
		if debuff then
			debuff:SetAttribute("exptime", 0)
		end
	end
end

--- Erstellt die Debuff Komponenten.
--
-- @tparam Frame debuffIconFrame Der DebuffFrame f&uumlr welchen die Komponenten erstellt werden.
-- @tparam int count Wie oft der Debuff gestapelt ist
function bossPlate:CreateDebuffIconComp(debuffIconFrame, count)
	if count ~= 0 then
		debuffIconFrame.countLabel = debuffIconFrame:CreateFontString(debuffIconFrame.name.."debuffIconFrameCount-label", "OVERLAY", "GameFontNormal") -- Oben drauf deswegen OVERLAY
	end
	debuffIconFrame.expireLabel = debuffIconFrame:CreateFontString(debuffIconFrame.name.."debuffIconFrameExpire-label", "OVERLAY", "GameFontNormal")
	debuffIconFrame.icon = debuffIconFrame:CreateTexture(debuffIconFrame.name.."debuffIcon","BACKGROUND") -- Icon im BACKGROUND
end

--- Konfiguriert den Debuff(StatusBar).
--
-- @tparam Frame debuff Der Debuff
function bossPlate:ConfigDebuffExpireStatusBar(debuff)
	debuff:SetOrientation("VERTICAL")
	debuff:ClearAllPoints()
	debuff:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	debuff:SetSize(28, 28)
	debuff:SetStatusBarColor(0, 0, 0, 0.6)
	debuff:SetValue(debuff:GetAttribute("exptime"))
	debuff:SetMinMaxValues(0, debuff.duration)
	debuff:Show()
end


--- OnAttributeChanged Eventhandlingfunktion.
-- In dieser Funktion wird gepr&uumlft welches Attribut sich ge&aumlndert hat und dementsprechend wird ein FontString gesetzt.
-- Oder auch verborgen, wenn der Count z.B. 0 wird.
--
-- @tparam string name Name des Attributes, welcher sich ge&aumlndert hat
-- @param value Der neue Wert des Attributes
function bossPlate:DebuffOnAttributeChanged(name, value)
	if name == "exptime" then
		if value == 0 then
			bossPlate:ResetDebuff(self)
		elseif value > 0 then
			self:SetValue(value)
		end
	elseif self.isExpireLabel then
		if value == 1 then
			self.expireLabel:Hide()
			self:Hide()
			self.icon:SetTexture(nil)
		elseif value > 1 then
			self.expireLabel:SetText(round(value, 0))
		end 
	end
	if name == "count" then
		if value == 1 then
			if self.countLabel then
				self.countLabel:Hide()
			end
		elseif value > 1 then
			self.countLabel:SetText(value)
		end
	end
end

--- Eventhandlingfunktion f&uumlr den Event OnHide.
-- Es wird eine nil Textur gesetzt und der Debuff wird aus dem Container gel&oumlsct.
-- Sowie die Debuffs werden neu geordnet.
function bossPlate:OnIconHide()
	self.icon:SetTexture(nil)
	tremove(debuffs, self.place)
	for i = 1, #debuffs do
		if #debuffs > 0 then
			bossPlate:ReorderDebuffIcon(debuffs[i], i)
		end
	end
end

--- Diese Funktion ordnet alle Debuffs aus dem Container neu.
-- Indem alle Debuffs durchlaufen werden und an die Funktion ReorderDebuffIcon &uumlbergeben werden.
function bossPlate:ReorderAllDebuffs()
	for i = 1, #debuffs do
		if #debuffs > 0 then
			bossPlate:ReorderDebuffIcon(debuffs[i], i)
		end
	end
end

--- Mit dieser Funktion wird ein Debuff neu geordnet.
--
-- @tparam Frame debuff Der Debuff welcher neu geordnet werden soll
-- @tparam int placeInTable Platz des Debuffs im Container
function bossPlate:ReorderDebuffIcon(debuff, placeInTable)
	if debuff then
		if debuff.icon then
			debuff.icon:SetPoint("CENTER", debuff, 0, 0)
			if placeInTable == 1 then
				if UnitMana(SA_BossNamePlate.unit) ~= 0 then
					debuff:SetPoint("TOPLEFT", manaBar, "BOTTOMLEFT", 0, 0)
				else
					debuff:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, 0)
				end
			elseif placeInTable % 6 == 0 then -- Nur 6 Debuffs in einer Reihe
				debuff:SetPoint("TOP", debuffs[placeInTable - 5], "BOTTOM", 0, -1)
			elseif placeInTable > 1 and debuffs[1] then
				debuff:SetPoint("LEFT", debuffs[placeInTable - 1], "RIGHT", 1, 0)
			end
		else
			debuff.icon:ClearAllPoints()
		end
	else
		debuff:ClearAllPoints()
	end
end

--- Zum holen eines Debuffs aus dem Debuffcontainer, mithilfe des Namens.
--
-- @tparam string spell Der Debuffname
-- @return Der Debuff
function bossPlate:GetBossDebuff(spell)
	local debuff = nil
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			debuff = debuffs[i]
		end
	end
	return debuff
end

--- Mit dieser Funktion kann man pr&uumlfen,ob ein Debuff bereits im Container enthalten ist.
--
-- @tparam string spell Name des zu &uumlberpr&uumlfenden Debuffs
-- @return Ob der Debuff im Container enthalten ist
function bossPlate:BossDebuffContains(spell)
	for i = 1, #debuffs do
		if debuffs[i].name == spell then
			return true
		end
	end
	return false
end

--- In dieser Funktion werden alle Debuffs mit Hilfe von bossPlate:DebuffOnAttributeChanged() verborgen.
-- Es wird dem Attribut exttime 0 zugewiesen.
function bossPlate:HideAllBossDebuff()
	for i = 1, #debuffs do
		if(debuffs[i]) then
			debuffs[i]:SetAttribute("exptime", 0)
		end
	end
end

--- Die Funktion setzt alle Debuffs zur&uumlck, indem ein Debuff in die Funktion ResetDebuff &uumlbergeben wird.
function bossPlate:ResetAll()
	for i = 1, #debuffs do
		if debuffs[i] then
			bossPlate:ResetDebuff(debuffs[i])
		end
	end
	debuffs = table.wipe(debuffs)
end

--- Setzt alle abgelaufenen Debuffs zur&uumlck und ordnet die restlichen neu.
-- Ein Debuff ist abgelaufen, wenn exttime == 0 ist.
function bossPlate:ResetExpiredDebuff()
	for i = 1, #debuffs do
		if debuffs[i] and debuffs[i].expTime == 0 then
			bossPlate:ResetDebuff(debuffs[i])
		end
		bossPlate:ReorderDebuffIcon(debuffs[i], i)
	end
end

--- Setzt einen Debuff zur&uumlck.
--
-- @tparam Frame self Der Debuff selbst
function bossPlate:ResetDebuff(self)
		self.tex = nil
		self.icon = self:CreateTexture(nil)
		self.icon:SetAlpha(0)
		self.icon:SetSize(0,0)
		self.icon:ClearAllPoints()
		self.icon:Hide()
		self:SetSize(0,0)
		self:SetValue(0)
		self:SetAlpha(0)
		self:Hide()
		self:SetScript("OnUpdate", nil)
		self:SetScript("OnHide", nil)
		self:SetScript("OnAttributeChanged",nil)
		self:ClearAllPoints()
		self = nil
end

--- Diese Funktion dient um die Namensplatte von aussen anzeigen zu lassen.
--
-- @tparam boolean isGUID Ob eine GUID da ist(Eines Bosses)
function bossPlate:Show(isGUID) -- isGUID --> UnitExists
	if SA_BossNamePlate then
		if isGUID then
			SA_BossNamePlate:Show()
		else
			bossPlate:UnRegisterAllEvents()
		end
	end
end

--- Eine Setter Funktion, um die Variable unit zu setzen.
function SetTarget(unit)
	SA_BossNamePlate.unit = unit
end

--- Dies ist eine reine LUA Funktion, mit welcher man eine Dezimalzahl,
-- auf bestimmte Nachkommastellen runden kann.
--
-- @tparam float num Die zu rundende Zahl
-- @tparam int numDecimalPlaces Anzahl der Nachkommastellen
function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end