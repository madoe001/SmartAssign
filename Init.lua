--[[
File Name: Init.lua
Author: Grabelus, Bartlomiej (10044563)	&	Veith, Marvin Justin (10043555)
Description: Diese Datei dient zur Initialisierung der im Projekt verwendeten Variablen. Bei erstmaligen Start
			 werden die Saved Variables auf einen Defaultwert gesetzt. 
			 Die Saved Variables werden in "...\World of Warcraft\WTF\<AccountName>\SAVED_VARIABLES\SmartAssign"
			 gespeichert. Blizzard bietet die Möglichkeit komplette Tabellen inklusive Untertabellen zu speichern.
			 Allerdings können keine Funktionen gespeichert werden. Der Speichervorgang erfolgt beim Ausloggen, 
			 Aufruf des "/reload" Befehls oder einem Verlust der Internetverbindung. Bei einem Absturz der 
			 WorldOfWarcraft.exe gehen die nicht gespeicherten Daten der Saved Variables verloren.
]]

-- Global vars --
local _G = _G

-- INIT DEFAULT SAVED_VARIABLES
if (not SA_WEAKAURA) then
	SA_WEAKAURA = {}
	SA_WEAKAURA.duration = 0
	SA_WEAKAURA.offset = 5
end
SA_AbilityList = SA_AbilityList or {}
SA_PhaseList = SA_PhaseList or {}
if ( not SA_LastSelected ) then
	SA_LastSelected = {}
	SA_LastSelected.expansion = ""
	SA_LastSelected.raid = ""
	SA_LastSelected.boss = ""
	SA_LastSelected.phase = ""
	SA_LastSelected.abillity = ""
end

SA_Assignments = SA_Assignments or {}

SA_Cooldowns = SA_Cooldowns or {
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
	[Paladin_String] = {
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
	["Rouge"] = {
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
-- GUI
_G.SmartAssign = {}

_G.SmartAssign.SA_GUI = {}

_G.SmartAssign.SlashCommands = {}

_G.GUI = {}

_G.GUI.Locales = {}

_G.GUI.Assignment = {}

_G.GUI.PlayerAssignment = {}

_G.GUI.AssignmentFrame = {}

_G.GUI.SA_DropDownMenu = {}

_G.GUI.SA_DropDownList = {}
 
_G.GUI.SA_ScrollFrame = {}
 
_G.GUI.SA_CheckBox = {}
 
_G.GUI.SA_EditBox = {}

_G.GUI.SA_CreateAbilityFrame = {}

_G.GUI.SA_PhaseFrame = {}
 
_G.HUD = {}

_G.HUD.Locales = {}
 
_G.HUD.mainHUD = {}
 
_G.HUD.BossPlate = {} 

_G.HUD.BossSpellIcon = {}


