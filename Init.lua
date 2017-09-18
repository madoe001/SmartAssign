--Author: Bartlomiej Grabelus
-- this lua file init all global tables

-- Global vars --
local _G = _G

-- create globals
-- GUI
_G.SmartAssign = {}

_G.SmartAssign.SA_GUI = {}

_G.SmartAssign.SlashCommands = {}

_G.GUI = {}

_G.GUI.Locales = {}

_G.GUI.Assignment = {}

_G.GUI.PlayerAssignment = {}

_G.GUI.SA_DropDownMenu = {}

_G.GUI.SA_DropDownList = {}
 
_G.GUI.SA_ScrollFrame = {}
 
_G.GUI.SA_CheckBox = {}
 
_G.GUI.SA_EditBox = {}
 
_G.HUD = {}

_G.HUD.Locales = {}
 
_G.HUD.mainHUD = {}
 
_G.HUD.BossPlate = {} 

_G.HUD.BossSpellIcon = {}


SA_BossList = {
	["Legion"] = {
		["Antorus, the Burning Throne"] = {
			["Varimathras"] = {
			},
			["Imonar the Soulhunter"] = {
			},
			["The Covern of Shivarra"] = {
			},
			["Eonar the Life-Binder"] = {
			},
			["Portal Keeper Hasabel"] = {
			},
			["Garothi Worldbreaker"] = {
			},
			["Felhounds of Sargeras"] = {
			},
			["Antoran High Command"] = {
			},
			["Aggramar"] = {
			},
			["Argus the Unmaker"] = {
			},
			["Kin'garoth"] = {
			},
		},
		["Broken Isles"] = {
			["Levantus"] = {
			},
			["Brutallus"] = {
			},
			["Apocron"] = {
			},
			["Calamir"] = {
			},
			["Malificus"] = {
			},
			["Ana-Mouz"] = {
			},
			["Nithogg"] = {
			},
			["The Soultakers"] = {
			},
			["Flotsam"] = {
			},
			["Na'zak the Fiend"] = {
			},
			["Shar'thos"] = {
			},
			["Si'vash"] = {
			},
			["Withered J'im"] = {
			},
			["Drugon the Frostblood"] = {
			},
		},
		["Tomb of Sargeras"] = {
			["Demonic Inquisition"] = {
			},
			["Maiden of Vigilance"] = {
			},
			["Kil'jaeden"] = {
			},
			["Sisters of the Moon"] = {
			},
			["Goroth"] = {
			},
			["Harjatan"] = {
			},
			["The Desolate Host"] = {
			},
			["Fallen Avatar"] = {
			},
			["Mistress Sassz'ine"] = {
			},
		},
		["The Nighthold"] = {
			["High Botanish Tel'arn"] = {
			},
			["Trilliax"] = {
			},
			["Krosus"] = {
			},
			["Spellblade Aluriel"] = {
			},
			["Tichondrius"] = {
			},
			["Skorpyron"] = {
			},
			["Chronomatic Anomaly"] = {
			},
			["Gul'dan"] = {
			},
			["Grand Magistrix Elisande"] = {
			},
		},
		["Trial of Valor"] = {
			["Helya"] = {
			},
			["Guarm"] = {
			},
			["Odyn"] = {
			},
		},
		["The Emerald Nightmare"] = {
			["Elerethe Renferal"] = {
			},
			["Ursoc"] = {
			},
			["Nythendra"] = {
				["Rot"] = {
					["AbillityName"] = "Rot",
					["SpellID"] = "203096",
				},
			},
			["Dragons of Nightmare"] = {
			},
			["Il'gynoth, Heart of Corruption"] = {
			},
			["Cenarius"] = {
			},
			["Xavius"] = {
			},
		},
		["Invasion Points"] = {
			["Occularus"] = {
			},
			["Matron Folnuna"] = {
			},
			["Mistress Alluradel"] = {
			},
			["Sotanathor"] = {
			},
			["Inquisitor Meto"] = {
			},
			["Pit Lord Vilemus"] = {
			},
		},
	},
	["Warlords of Draenor"] = {
		["Highmaul"] = {
			["Brackenspore"] = {
			},
			["Tectus"] = {
			},
			["Ko'ragh"] = {
			},
			["The Butcher"] = {
			},
			["Imperator Mar'gok"] = {
			},
			["Kargath Bladefist"] = {
			},
			["Twin Ogron"] = {
			},
		},
		["Draenor"] = {
			["Supreme Lord Kazzak"] = {
			},
			["Drov the Ruiner"] = {
			},
			["Tarlna the Ageless"] = {
			},
			["Rukhmar"] = {
			},
		},
		["Blackrock Foundry"] = {
			["Oregorger"] = {
			},
			["Flamebender Ka'graz"] = {
			},
			["Operator Thogar"] = {
			},
			["Gruul"] = {
			},
			["Hans'gar and Franzok"] = {
			},
			["The Blast Furnace"] = {
			},
			["Blackhand"] = {
			},
			["Beastlord Darmac"] = {
			},
			["The Iron Maidens"] = {
			},
			["Kromog"] = {
			},
		},
		["Hellfire Citadel"] = {
			["Hellfire Assault"] = {
			},
			["Shadow-Lord Iskar"] = {
			},
			["Kormrok"] = {
			},
			["Fel Lord Zakuun"] = {
			},
			["Iron Reaver"] = {
			},
			["Kilrogg Deadeye"] = {
			},
			["Mannoroth"] = {
			},
			["Socrethar the Eternal"] = {
			},
			["Gorefiend"] = {
			},
			["Hellfire High Council"] = {
			},
			["Xhul'horac"] = {
			},
			["Archimonde"] = {
			},
		},
	},
	["Cataclysm"] = {
		["Baradin Hold"] = {
		},
		["Throne of the Four Winds"] = {
		},
		["The Bastion of Twilight"] = {
		},
		["Blackwing Descent"] = {
		},
		["Dragon Soul"] = {
		},
		["Firelands"] = {
		},
	},
	["Wrath of the Lich King"] = {
		["Ulduar"] = {
		},
		["Trial of the Crusader"] = {
		},
		["The Obsidian Sanctum"] = {
		},
		["Vault of Archavon"] = {
		},
		["The Ruby Sanctum"] = {
		},
		["Onyxia's Lair"] = {
		},
		["Naxxramas"] = {
		},
		["Icecrown Citadel"] = {
		},
		["The Eye of Eternity"] = {
		},
	},
	["Mist of Pandaria"] = {
		["Mogu'shan Vaults"] = {
		},
		["Heart of Fear"] = {
		},
		["Terrace of Endless Spring"] = {
		},
		["Siege of Orgrimmar"] = {
		},
		["Pandaria"] = {
		},
		["Throne of Thunder"] = {
		},
	},
	["Classic"] = {
		["Blackwing Lair"] = {
		},
		["Ruins of Ahn'Qiraj"] = {
		},
		["Molten Core"] = {
		},
		["Temple of Ahn'Qiraj"] = {
		},
	},
	["Burning Crusade"] = {
		["Karazhan"] = {
		},
		["Magtheridon's Lair"] = {
		},
		["The Eye"] = {
		},
		["Serpentshrine Cavern"] = {
		},
		["Gruul's Lair"] = {
		},
		["The Battle for Mount Hyjal"] = {
		},
		["Black Temple"] = {
		},
		["Sunwell Plateau"] = {
		},
	},
}
SA_Cooldowns = nil
