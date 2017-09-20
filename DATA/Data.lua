--Author: Bartlomiej Grabelus
-- this lua holds all data for smartassign
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
								    "TEST",
								    "TEST1",
								    "TEST2",
								    "TEST3",
								    "TEST4",
								    "TEST5",
								    "TEST6",
								    "TEST7",
								    "TEST8",
								    "TEST9",
								    "TEST0",
								    },
		[SAL["Shadowfang Keep"]] = {SAL["Baron Ashbury"],
									SAL["Baron Silverlaine"],
									SAL["Commander Springvale"],
									SAL["Lord Walden"],
									SAL["Lord Godfrey"],}},
	[SAL["WOTLK"]] = {}
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
		minimapPos = 218,
		clicked = false,
	}

SA_BossList = SA_BossList or {"Classic", "Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mist of Pandaria",
		"Warlords of Draenor", "Legion"};
		
function addExpansion(expansionName)
	SA_BossList[expansionName] = {};
end
function removeExpansion(expansionName)
	SA_BossList[expansionName] = nil;
end

function addRaid(expansionName, raidName)
	SA_BossList[expansionName][raidName] = {};
end
function removeRaid(expansionName, raidName)
	SA_BossList[expansionName][raidName] = nil;
end

function addBoss(expansionName, raidName, bossName)
	SA_BossList[expansionName][raidName][bossName] = {};
end
function removeBoss(expansionName, raidName, bossName)
	SA_BossList[expansionName][raidName][bossName] = nil;
end

function addAbillity(expansionName, raidName, bossName, abillityName, spellID, cooldown, starthp, endhp)
	SA_BossList[expansionName][raidName][bossName][abillityName] = {AbillityName = abillityName,
															SpellID = spellID,
															Cooldown = cooldown,
															StartHP = starthp,
															EndHP = endhp};
end
function removeAbillity(expansionName, raidName, bossName, abillityName)
	SA_BossList[expansionName][raidName][bossName][abillityName] = nil;
end

function getAbillities(expansionName, raidName, bossName)
	local abillities = {}
	for key, value in pairs(SA_BossList[expansionName][raidName][bossName]) do
		if key ~= "BossName" then
			table.insert(abillities, key)
		end
	end
	return abillities
end