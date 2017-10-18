--- Beschreibung: In dieser Datei werden alle Funktionen für die Bearbeitung der SavedVariables geschrieben.
-- @author Grabelus, Bartlomiej (10044563)	&	Veith, Marvin Justin (10043555)

local _G = _G

local SAL = _G.GUI.Locales

SA_Dungeons =  SA_Dungeons or {
	[SAL["Classic"]] = {
		[SAL["Ragefire Chasm"]] = {SAL["Adarogg"],
								   SAL["Dark Shaman Koranthal"],
								   SAL["Slagmaw"],
								   SAL["Lava Guard Gordoth"]},
		[SAL["Deadmines"]] = {SAL["Glubtok"],
							  SAL["Helix Gearbreaker"],
							  SAL["Foe Reaper 5000"],
							  SAL["Admiral Ripsnarl"],
							  SAL["Captain Cookie"],
							  SAL["Vanessa VanCleef"],},
		[SAL["Wailing Caverns"]] = {SAL["Lady Anacondra"],
								    SAL["Kresh"],
								    SAL["Lord Pythas"],
								    SAL["Lord Cobrahn"],
								    SAL["Skum"],
								    SAL["Lord Serpentis"],
								    SAL["Verdan the Everliving"],
								    SAL["Mutanus the Devourer"],
								    },
		[SAL["Shadowfang Keep"]] = {SAL["Baron Ashbury"],
									SAL["Baron Silverlaine"],
									SAL["Commander Springvale"],
									SAL["Lord Walden"],
									SAL["Lord Godfrey"],}},
	[SAL["The Burning Crusade"]] = {},
	[SAL["Wrath of the Lich King"]] = {},
	[SAL["Cataclysm"]] = {},
	[SAL["Mists of Pandaria"]] = {},
	[SAL["Warlords of Draenor"]] = {},
	[SAL["Legion"]] = {},
}

-- Cooldown.lua
_G.ClassList = {
   ["Warrior"] = {
		["97462"] = { -- Shout
			["SpellID"] = "97462",
			["Name"] = "Commanding Shout",
			["Duration"] = "12",
			["Cooldown"] = "180"
		}
	}, 
	["Death Knight"] = {
	}, 
	["Paladin"] = {
		["31821"] = { -- Aura Mastery
			["SpellID"] = "31821",
			["Name"] = "Aura Mastery",
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["204150"] = { -- Aegis of Light
			["SpellID"] = "204150",
			["Name"] = "Aegis of Light",
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["6940"] = { -- Blessing of Sacrifice
			["SpellID"] = "6940",
			["Name"] = "Blessing of Sacrifice",
			["Duration"] = "12",
			["Cooldown"] = "150"
		},
		["204018"] = { -- Blessing of Spellwarding
			["SpellID"] = "196718",
			["Name"] = "Blessing of Spellwarding",
			["Duration"] = "10",
			["Cooldown"] = "180"
		},
		["1022"] = { -- Blessing of Protection
			["SpellID"] = "1022",
			["Name"] = "Blessing of Protection",
			["Duration"] = "10",
			["Cooldown"] = "300"
		}
	},
	["Shaman"] = {
		["108280"] = { -- Healing Tide Totem
			["SpellID"] = "108280",
			["Name"] = "Healing Tide Totem",
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["207399"] = { -- Ancestral Protection Totem
			["SpellID"] = "207399",
			["Name"] = "Ancestral Protection Totem",
			["Duration"] = "30",
			["Cooldown"] = "300"
		},
		["98008"] = { -- Spirit Link Totem
			["SpellID"] = "98008",
			["Name"] = "Spirit Link Totem",
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["192077"] = { -- Wind Rush Totem
			["SpellID"] = "192077",
			["Name"] = "Wind Rush Totem",
			["Duration"] = "15",
			["Cooldown"] = "120"
		}
	}, 
	["Hunter"] = {
	}, 
	["Demon Hunter"] = {
		["196718"] = { -- Darkness
			["SpellID"] = "196718",
			["Name"] = "Darkness",
			["Duration"] = "8",
			["Cooldown"] = "180"
		}
	},
	["Rogue"] = {
	}, 
	["Druid"] = {
		["740"] = { -- Tranquility
			["SpellID"] = "740",
			["Name"] = "Tranquility",
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["102342"] = { -- Iron Bark
			["SpellID"] = "102342",
			["Name"] = "Iron Bark",
			["Duration"] = "12",
			["Cooldown"] = "90"
		},
		["106898"] = { -- Stampeding Roar
			["SpellID"] = "106898",
			["Name"] = "Stampeding Roar",
			["Duration"] = "15",
			["Cooldown"] = "120"
		}
	}, 
	["Monk"] = {
		["115310"] = { -- Revival
			["SpellID"] = "115310",
			["Name"] = "Revival",
			["Duration"] = "1",
			["Cooldown"] = "180"
		},
		["116849"] = { -- Life Cocoon
			["SpellID"] = "116849",
			["Name"] = "Life Cocoon",
			["Duration"] = "12",
			["Cooldown"] = "180"
		}
	}, 
	["Priest"] = {
		["62618"] = { -- Power Word: Barrier
			["SpellID"] = "62618",
			["Name"] = "Power Word: Barrier",
			["Duration"] = "10",
			["Cooldown"] = "180"
		},
		["64843"] = { -- Divine Hymn
			["SpellID"] = "64843",
			["Name"] = "Divine Hymn",
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["15268"] = { -- Vampiric Embrace
			["SpellID"] = "15268",
			["Name"] = "Vampiric Embrace",
			["Duration"] = "15",
			["Cooldown"] = "180"
		},
		["47788"] = { -- Guardian Spirit
			["SpellID"] = "47788",
			["Name"] = "Guardian Spirit",
			["Duration"] = "10",
			["Cooldown"] = "240"
		},
		["33206"] = { -- Pain Suppression
			["SpellID"] = "33206",
			["Name"] = "Pain Suppression",
			["Duration"] = "8",
			["Cooldown"] = "240"
		}
	}, 
	["Warlock"] = {
	}, 
	["Mage"] = {
	}, 
}

_G.GUI.SA_DropDownMenu.data = {
   ["Healer"] = {		-- category
			[1] = {		-- entry number
				["id"]			= "H1",		-- unique id
				["name"]		= "Henny",
			},
			[2] = {		-- entry number
				["id"]			= "H2",		-- unique id
				["name"]		= "HealBoy",
			},
		},
	[SAL["Tank"]] = {		-- category
			[1] = {		-- entry number
				["id"]			= "T1",		-- unique id
				["name"]		= "BadBoy",
			},
		},
	[SAL["Damage Dealer"]] = {		-- category
			[1] = {		-- entry number
				["id"]			= "D1",		-- unique id
				["name"]		= "BigDealer",
			},
		}
 }

 _G.GUI.SA_DropDownList.data = {SAL["Ability"],  SAL["Timer"]}

_G.SmartAssign.minimap = {
		shown = true,
		locked = false,
		minimapPos = 210,
		clicked = false,
	}

SA_BossList = SA_BossList or {};
	

--- addExpansion
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @usage Der Expansionname wird als Key in der SA_BossList verwendet, muss also eindeutig sein.
			 -- Es wird eine neue Table unter der Verwendung von dem Key erstellt.
function addExpansion(expansionName)
	SA_BossList[expansionName] = {};
end

--- removeExpansion
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @usage Der Wert des übergebenen Schlüssels ("expansionName"), wird gelöscht.
function removeExpansion(expansionName)
	SA_BossList[expansionName] = nil;
end


--- addRaid
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @param raidName Der Name des Raids.
-- @usage Der RaidName wird als Key in der SA_BossList[expansionName] verwendet, muss also eindeutig und vorhanden sein.
function addRaid(expansionName, raidName)
	if(SA_BossList[expansionName]) then
		SA_BossList[expansionName][raidName] = {};
	end	
end

--- removeRaid
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @param raidName Der Name des Raids.
-- @usage Die Tabelle des übergebenen Schlüssels [expansionName]("raidName"), wird gelöscht.
function removeRaid(expansionName, raidName)
	if ( SA_BossList[expansionName] ) then
		SA_BossList[expansionName][raidName] = nil;
	end
end


--- addBoss
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @param raidName Der Name des Raids.
-- @param bossName Der Name des Bosses.
-- @param encounterID Eindeutige ID des Bosses
-- @usage Der bossName wird als Key in der SA_BossList[expansionName][raidName] verwendet, muss also eindeutig und vorhanden sein.
function addBoss(expansionName, raidName, bossName, encounterID)
	if ( SA_BossList[expansionName] ) then
		if ( SA_BossList[expansionName][raidName] ) then
			SA_BossList[expansionName][raidName][bossName] = {};
			SA_BossList[expansionName][raidName][bossName].encounterID = encounterID
		end
	end	
end

--- removeBoss
-- @author  Veith, Marvin Justin (10043555)
-- @param expansionName Der Name der Expansion.
-- @param raidName Der Name des Raids.
-- @param bossName Der Name des Bosses.
-- @usage Entfernt Boss und den dazugehörigen Schlüssel.	
function removeBoss(expansionName, raidName, bossName)
	if ( SA_BossList[expansionName] ) then
		if ( SA_BossList[expansionName][raidName] ) then
			SA_BossList[expansionName][raidName][bossName] = nil;
		end
	end
end