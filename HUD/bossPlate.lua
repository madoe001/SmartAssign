local _G = _G

local bossPlate = _G.HUD.BossPlate

-- UnitName("target").." "..UnitGUID("target") kriegt man id und name raus

local playerName, playerGUID = UnitName("player"), UnitGUID("player")

local SA_BossNamePlate = CreateFrame("Frame", "DBMNameplate", UIParent)
SA_BossNamePlate:SetFrameStrata('BACKGROUND')
SA_BossNamePlate:Hide()

-- NEXT erstellen lebens-, mana- und spellanzeigen plus tex

function bossPlate:Show(isGUID, unit, spellID, duration)
end