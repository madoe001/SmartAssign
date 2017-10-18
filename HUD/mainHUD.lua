--- Beschreibung: Diese Klasse stellt eine unsichtbare HUD zur Verfügung. Sie beinhaltet eine Namensplatte für den gerade fokusierten Boss,
-- sowie ein BossSpellIcon, welches die Zauber anzeigt, welche vom Boss gewirkt werden.
--
-- @modul mainHUD
-- @author Bartlomiej Grabelus (10044563)

-- Hole globale Tabelle _G
local _G = _G

local mainHUD = _G.HUD.mainHUD
local bossPlate = _G.HUD.BossPlate
local bossSpellIcon = _G.HUD.BossSpellIcon

local HUDL = _G.HUD.Locales

-- Spielerinformationen
local playerName, playerGUID = UnitName("player"), UnitGUID("player")

-- Variablen 
local isInstance -- Um prüfen zu können ob es sich um eine Instanz handelt
local instanceType -- Um prüfen zu können um was für einen Instanztyp es sich handelt(Raid, Party)
local instanceName -- Um den Instanzennamen zwischen zu speicher zu können
local unit
local hudFrame

--- Erstellt die mainHUD, welche für den Spieler unsichtbar ist.
-- Sie dient nur zur Positionierung anderer HUD-Komponenten.
--
-- Benutzte Events:
-- PLAYER_ENTERING_WORLD: Wird ausgelöst, wenn der Spieler z.B. die Welt oder eine Instanz betritt
-- PLAYER_TARGET_CHANGED: Wird ausgelöst, wenn der fokus des Spielers gewechselt wird
-- PLAYER_REGEN_DISABLED: Wird ausgelöst, wenn die Lebens- und Energieregeneration des Spielers unterbrochen wird
function mainHUD:CreateMainHUD()
	hudFrame = CreateFrame("Frame","hudFrame",UIParent)
	hudFrame:SetFrameStrata('BACKGROUND')
	hudFrame:SetWidth(UIParent:GetWidth())
	hudFrame:SetHeight(UIParent:GetHeight())
	hudFrame:ClearAllPoints()
	hudFrame:SetPoint("CENTER", 0, 0)
	hudFrame:Show()
	
	hudFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	hudFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	hudFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	hudFrame:SetScript("OnEvent", mainHUD.OnEnteringEvent_TestInstance)
	--hudFrame:Hide()
end

--- Eine Funktion, um ausserhalb die mainHUD anzuzeigen.
function mainHUD:Show()
	self:Show()
end

--- Diese Funktion wird aufgerufen wenn ein Event ausgelöst wird, siehe Zeile 45.
-- Hier wird eine Namensplatte und die Spellicons erstellt und angezeigt, wenn ein Boss fokusiert ist.
--
-- @tparam Event event Das Event welches ausgelöst wurde.
function mainHUD:OnEnteringEvent_TestInstance(event)
	local name = UnitName("target") -- Hole den Namen NPC des Spielerfokuses
	local boss1 = UnitName("boss1")
	local boss2 = UnitName("boss2")
	local boss3 = UnitName("boss3")
	local boss4 = UnitName("boss4")
	local boss5 = UnitName("boss5")
	
	if (event == "PLAYER_ENTERING_WORLD" ) then -- Wenn der Spieler die Welt oder Instance betritt
		local isInstance, instanceType = IsInInstance() -- Besorge Informationen über die Instanz
		if isInstance then -- Wenn der Spieler in einer Instanz ist
			isInstance = isInstance
			if instanceType == "party" or instanceType == "raid" then -- Nur wenn der Instanztyp ein Raid oder Party ist erstelle eine Bossplatte und den Spellicon
				instanceType = instanceType
				bossPlate:CreateBossPlate(hudFrame, "target")
				bossSpellIcon:CreatebossSpellIcon(hudFrame, "target")
			end
		end
	elseif "PLAYER_TARGET_CHANGED" or "PLAYER_REGEN_DISABLED" then -- Wenn der Spieler seinen Fokus gewechselt hat oder die Regeneration unterbrochen wird
		if name == boss1 or name == boss2 or name == boss3 or name == boss4 or name == boss5 then -- Nur wenn der Fokus auf einem Boss liegt dann zeige die Namenplatte und Spellicon an
			bossPlate:Show(true)
			bossSpellIcon:Show(true)
		end
	end
end

--- Gibt zurück ob es eine Instanz ist.
-- @return isInstance
function mainHUD:IsInInstance()
	return isInstance
end

--- Gibt den Instanztyp zurück.
-- @return instanceType
function mainHUD:InstanceType()
	return instanceType
end

--- Ruft die Funktion CreateBossPlate der BossPlatte auf, um eine Namensplatte zu erstellen
function CreateBossPlate(frame)
	bossPlate:CreateBossPlate(frame)
end

--- Ruft die Funktion CreatebossSpellIcon des Spellicons auf, um einen Spellicon zu erstellen
function CreateBossSpellIcon(frame)
	bossSpellIcon:CreatebossSpellIcon(frame)
end