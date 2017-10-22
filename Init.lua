--- Beschreibung: Diese Datei dient zur Initialisierung der im Projekt verwendeten Variablen/Tabellen. Bei erstmaligen Start
--			     werden die Saved Variables auf einen Defaultwert gesetzt. 
--			     Die Saved Variables werden in "...\World of Warcraft\WTF\<AccountName>\SAVED_VARIABLES\SmartAssign"
--			     gespeichert. Blizzard bietet die Moeglichkeit komplette Tabellen inklusive Untertabellen zu speichern.
--			     Allerdings koennen keine Funktionen gespeichert werden. Der Speichervorgang erfolgt beim Ausloggen, 
--			     Aufruf des "/reload" Befehls oder einem Verlust der Internetverbindung. Bei einem Absturz der 
--			     WorldOfWarcraft.exe gehen die nicht gespeicherten Daten der Saved Variables verloren.
--
-- @author Grabelus, Bartlomiej (10044563)	&	Veith, Marvin Justin (10043555)

-- Hole die globale Tabelle _G
local _G = _G

-- INIT DEFAULT SAVED_VARIABLES
if (not SA_WEAKAURA) then
	SA_WEAKAURA = {}
	SA_WEAKAURA.duration = 0
	SA_WEAKAURA.offset = 5
end
-- variablen zur lokalisierung
SA_local = SA_local or ""
SA_local2 = SA_local or ""
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


SA_BossList = {
["Classic"] = { 
		[MoltenCore_string] = { 
			[MC_Lucifron] = { 
 				 ["encounterID"] = 0,
			},
			[MC_Magmadar] = { 
 				 ["encounterID"] = 1,
			},
			[MC_Gehennas] = { 
 				 ["encounterID"] = 2,
			},
			[MC_Garr] = { 
 				 ["encounterID"] = 3,
			},
			[MC_Shazzrah] = { 
 				 ["encounterID"] = 4,
			},
			[MC_BaronGeddon] = { 
 				 ["encounterID"] = 5,
			},
			[MC_SulfuronHarbinger] = { 
 				 ["encounterID"] = 6,
			},
			[MC_GolemaggtheIncinerator] = { 
 				 ["encounterID"] = 7,
			},
			[MC_MajordomoExecutus] = { 
 				 ["encounterID"] = 8,
			},
			[MC_Ragnaros] = { 
 				 ["encounterID"] = 9,
			},
			},
		[BlackwingLair_string] = { 
			[BL_RazorgoretheUntamed] = { 
 				 ["encounterID"] = 10,
			},
			[BL_VaelastrasztheCorrupt] = { 
 				 ["encounterID"] = 11,
			},
			[BL_BroodlordLashlayer] = { 
 				 ["encounterID"] = 12,
			},
			[BL_Firemaw] = { 
 				 ["encounterID"] = 13,
			},
			[BL_Ebonroc] = { 
 				 ["encounterID"] = 14,
			},
			[BL_Flamegor] = { 
 				 ["encounterID"] = 15,
			},
			[BL_Chromaggus] = { 
 				 ["encounterID"] = 16,
			},
			[BL_Nefarian] = { 
 				 ["encounterID"] = 17,
			},
			},
		[RuinsofAhnQiraj_string] = { 
			[RoA_Kurinnaxx] = { 
 				 ["encounterID"] = 18,
			},
			[RoA_GeneralRajaxx] = { 
 				 ["encounterID"] = 19,
			},
			[RoA_Moam] = { 
 				 ["encounterID"] = 20,
			},
			[RoA_BurutheGorger] = { 
 				 ["encounterID"] = 21,
			},
			[RoA_AyamisstheHunter] = { 
 				 ["encounterID"] = 22,
			},
			[RoA_OssiriantheUnscarred] = { 
 				 ["encounterID"] = 23,
			},
			},
		[TempleofAhnQiraj_string] = { 
			[ToA_TheProphetSkeram] = { 
 				 ["encounterID"] = 24,
			},
			[ToA_SilithidRoyalty] = { 
 				 ["encounterID"] = 25,
			},
			[ToA_BattleguardSartura] = { 
 				 ["encounterID"] = 26,
			},
			[ToA_FankrisstheUnyielding] = { 
 				 ["encounterID"] = 27,
			},
			[ToA_Viscidus] = { 
 				 ["encounterID"] = 28,
			},
			[ToA_PrincessHuhuran] = { 
 				 ["encounterID"] = 29,
			},
			[ToA_TheTwinEmperors] = { 
 				 ["encounterID"] = 30,
			},
			[ToA_Ouro] = { 
 				 ["encounterID"] = 31,
			},
			[ToA_Cthun] = { 
 				 ["encounterID"] = 32,
			},
			},
		},
["Burning Crusade"] = { 
		[Karazhan_string] = { 
			[K_ServantsQuarters] = { 
 				 ["encounterID"] = 33,
			},
			[K_AttumentheHuntsman] = { 
 				 ["encounterID"] = 652,
			},
			[K_Moroes] = { 
 				 ["encounterID"] = 653,
			},
			[K_MaidenofVirtue] = { 
 				 ["encounterID"] = 654,
			},
			[K_OperaHall] = { 
 				 ["encounterID"] = 655,
			},
			[K_TheCurator] = { 
 				 ["encounterID"] = 656,
			},
			[K_ShadeofAran] = { 
 				 ["encounterID"] = 658,
			},
			[K_TerestianIllhoof] = { 
 				 ["encounterID"] = 657,
			},
			[K_Netherspite] = { 
 				 ["encounterID"] = 659,
			},
			[K_ChessEvent] = { 
 				 ["encounterID"] = 660,
			},
			[K_PrinceMalchezaar] = { 
 				 ["encounterID"] = 661,
			},
			},
		[GruulsLair_string] = { 
			[GL_HighKingMaulgar] = { 
 				 ["encounterID"] = 649,
			},
			[GL_GruultheDragonkiller] = { 
 				 ["encounterID"] = 650,
			},
			},
		[MagtheridonsLair_string] = { 
			[ML_Magtheridon] = { 
 				 ["encounterID"] = 651,
			},
			},
		[SerpentshrineCavern_string] = { 
			[SC_HydrosstheUnstable] = { 
 				 ["encounterID"] = 623,
			},
			[SC_TheLurkerBelow] = { 
 				 ["encounterID"] = 624,
			},
			[SC_LeotherastheBlind] = { 
 				 ["encounterID"] = 625,
			},
			[SC_FathomLordKarathress] = { 
 				 ["encounterID"] = 626,
			},
			[SC_MorogrimTidewalker] = { 
 				 ["encounterID"] = 627,
			},
			[SC_LadyVashj] = { 
 				 ["encounterID"] = 628,
			},
			},
		[TheEye_string] = { 
			[TE_Alar] = { 
 				 ["encounterID"] = 730,
			},
			[TE_VoidReaver] = { 
 				 ["encounterID"] = 731,
			},
			[TE_HighAstromancerSolarian] = { 
 				 ["encounterID"] = 732,
			},
			[TE_KaelthasSunstrider] = { 
 				 ["encounterID"] = 733,
			},
			},
		[TheBattleforMountHyjal_string] = { 
			[TBfMH_RageWinterchill] = { 
 				 ["encounterID"] = 618,
			},
			[TBfMH_Anetheron] = { 
 				 ["encounterID"] = 619,
			},
			[TBfMH_Kazrogal] = { 
 				 ["encounterID"] = 620,
			},
			[TBfMH_Azgalor] = { 
 				 ["encounterID"] = 621,
			},
			[TBfMH_Archimonde] = { 
 				 ["encounterID"] = 622,
			},
			},
		[BlackTemple_string] = { 
			[BT_HighWarlordNajentus] = { 
 				 ["encounterID"] = 601,
			},
			[BT_Supremus] = { 
 				 ["encounterID"] = 602,
			},
			[BT_ShadeofAkama] = { 
 				 ["encounterID"] = 603,
			},
			[BT_TeronGorefiend] = { 
 				 ["encounterID"] = 604,
			},
			[BT_GurtoggBloodboil] = { 
 				 ["encounterID"] = 605,
			},
			[BT_ReliquaryofSouls] = { 
 				 ["encounterID"] = 606,
			},
			[BT_MotherShahraz] = { 
 				 ["encounterID"] = 607,
			},
			[BT_TheIllidariCouncil] = { 
 				 ["encounterID"] = 608,
			},
			[BT_IllidanStormrage] = { 
 				 ["encounterID"] = 609	,
			},
			},
		[SunwellPlateau_string] = { 
			[SP_Kalecgos] = { 
 				 ["encounterID"] = 724,
			},
			[SP_Brutallus] = { 
 				 ["encounterID"] = 725,
			},
			[SP_Felmyst] = { 
 				 ["encounterID"] = 726,
			},
			[SP_TheEredarTwins] = { 
 				 ["encounterID"] = 727,
			},
			[SP_Muru] = { 
 				 ["encounterID"] = 728,
			},
			[SP_Kiljaeden] = { 
 				 ["encounterID"] = 729,
			},
			},
		},
["Wrath of the Lich King"] = { 
		[VaultofArchavon_string] = { 
			[VoA_ArchavontheStoneWatcher] = { 
 				 ["encounterID"] = 1126,
			},
			[VoA_EmalontheStormWatcher] = { 
 				 ["encounterID"] = 1127,
			},
			[VoA_KoralontheFlameWatcher] = { 
 				 ["encounterID"] = 1128,
			},
			[VoA_ToravontheIceWatcher] = { 
 				 ["encounterID"] = 1129,
			},
			},
		[Naxxramas_string] = { 
			[N_AnubRekhan] = { 
 				 ["encounterID"] = 1107,
			},
			[N_GrandWidowFaerlina] = { 
 				 ["encounterID"] = 1110,
			},
			[N_Maexxna] = { 
 				 ["encounterID"] = 1116,
			},
			[N_NoththePlaguebringer] = { 
 				 ["encounterID"] = 1117,
			},
			[N_HeigantheUnclean] = { 
 				 ["encounterID"] = 1112,
			},
			[N_Loatheb] = { 
 				 ["encounterID"] = 1115,
			},
			[N_InstructorRazuvious] = { 
 				 ["encounterID"] = 1113,
			},
			[N_GothiktheHarvester] = { 
 				 ["encounterID"] = 1109,
			},
			[N_TheFourHorsemen] = { 
 				 ["encounterID"] = 1121,
			},
			[N_Patchwerk] = { 
 				 ["encounterID"] = 1118,
			},
			[N_Grobbulus] = { 
 				 ["encounterID"] = 1111,
			},
			[N_Gluth] = { 
 				 ["encounterID"] = 1108,
			},
			[N_Thaddius] = { 
 				 ["encounterID"] = 1120,
			},
			[N_Sapphiron] = { 
 				 ["encounterID"] = 1119,
			},
			[N_KelThuzad] = { 
 				 ["encounterID"] = 1114,
			},
			},
		[TheObsidianSanctum_string] = { 
			[TOS_Sartharion] = { 
 				 ["encounterID"] = 1190,
			},
			},
		[TheEyeofEternity_string] = { 
			[TEoE_Malygos] = { 
 				 ["encounterID"] = 1094,
			},
			},
		[Ulduar_string] = { 
			[U_FlameLeviathan] = { 
 				 ["encounterID"] = 1132,
			},
			[U_IgnistheFurnaceMaster] = { 
 				 ["encounterID"] = 1136,
			},
			[U_Razorscale] = { 
 				 ["encounterID"] = 1139,
			},
			[U_XT002Deconstructor] = { 
 				 ["encounterID"] = 1142,
			},
			[U_TheAssemblyofIron] = { 
 				 ["encounterID"] = 1140,
			},
			[U_Kologarn] = { 
 				 ["encounterID"] = 1137,
			},
			[U_Auriaya] = { 
 				 ["encounterID"] = 1131,
			},
			[U_Hodir] = { 
 				 ["encounterID"] = 1135,
			},
			[U_Thorim] = { 
 				 ["encounterID"] = 1141,
			},
			[U_Freya] = { 
 				 ["encounterID"] = 1133,
			},
			[U_Mimiron] = { 
 				 ["encounterID"] = 1138,
			},
			[U_GeneralVezax] = { 
 				 ["encounterID"] = 1134,
			},
			[U_YoggSaron] = { 
 				 ["encounterID"] = 1143,
			},
			[U_AlgalontheObserver] = { 
 				 ["encounterID"] = 1130,
			},
			},
		[TrialoftheCrusader_string] = { 
			[TotC_TheNorthrendBeasts] = { 
 				 ["encounterID"] = 1088,
			},
			[TotC_LordJaraxxus] = { 
 				 ["encounterID"] = 1087,
			},
			[TotC_ChampionsoftheHorde] = { 
 				 ["encounterID"] = 1086,
			},
			[TotC_TwinValkyr] = { 
 				 ["encounterID"] = 1089,
			},
			[TotC_Anubarak] = { 
 				 ["encounterID"] = 1085,
			},
			},
		[OnyxiasLair_string] = { 
			[OL_Onyxia] = { 
 				 ["encounterID"] = 34,
			},
			},
		[IcecrownCitadel_string] = { 
			[IC_LordMarrowgar] = { 
 				 ["encounterID"] = 1101,
			},
			[IC_LadyDeathwhisper] = { 
 				 ["encounterID"] = 1100,
			},
			[IC_IcecrownGunshipBattle] = { 
 				 ["encounterID"] = 1099,
			},
			[IC_DeathbringerSaurfang] = { 
 				 ["encounterID"] = 1096,
			},
			[IC_Festergut] = { 
 				 ["encounterID"] = 1097,
			},
			[IC_Rotface] = { 
 				 ["encounterID"] = 1104,
			},
			[IC_ProfessorPutricide] = { 
 				 ["encounterID"] = 1102,
			},
			[IC_BloodPrinceCouncil] = { 
 				 ["encounterID"] = 1095,
			},
			[IC_BloodQueenLanathel] = { 
 				 ["encounterID"] = 1103,
			},
			[IC_ValithriaDreamwalker] = { 
 				 ["encounterID"] = 1098,
			},
			[IC_Sindragosa] = { 
 				 ["encounterID"] = 1105,
			},
			[IC_TheLichKing] = { 
 				 ["encounterID"] = 1106,
			},
			},
		[TheRubySanctum_string] = { 
			[TRS_Halion] = { 
 				 ["encounterID"] = 1150,
			},
			},
		},
["Cataclysm"] = { 
		[BaradinHold_string] = { 
			[BH_Argaloth] = { 
 				 ["encounterID"] = 35,
			},
			[BH_Occuthar] = { 
 				 ["encounterID"] = 36,
			},
			[BH_AlizabalMistressofHate] = { 
 				 ["encounterID"] = 37,
			},
			},
		[BlackwingDescent_string] = { 
			[BD_OmnotronDefenseSystem] = { 
 				 ["encounterID"] = 38,
			},
			[BD_Magmaw] = { 
 				 ["encounterID"] = 39,
			},
			[BD_Atramedes] = { 
 				 ["encounterID"] = 40,
			},
			[BD_Chimaeron] = { 
 				 ["encounterID"] = 41
			},
			[BD_Maloriak] = { 
 				 ["encounterID"] = 42,
			},
			[BD_NefariansEnd] = { 
 				 ["encounterID"] = 43,
			},
			},
		[TheBastionofTwilight_string] = { 
			[TBoT_HalfusWyrmbreaker] = { 
 				 ["encounterID"] = 44,
			},
			[TBoT_TheralionandValiona] = { 
 				 ["encounterID"] = 45,
			},
			[TBoT_AscendantCouncil] = { 
 				 ["encounterID"] = 46,
			},
			[TBoT_Chogall] = { 
 				 ["encounterID"] = 47,
			},
			},
		[ThroneoftheFourWinds_string] = { 
			[TotFW_TheConclaveofWind] = { 
 				 ["encounterID"] = 48,
			},
			[TotFW_AlAkir] = { 
 				 ["encounterID"] = 49,
			},
			},
		[Firelands_string] = { 
			[F_Bethtilac] = { 
 				 ["encounterID"] = 50,
			},
			[F_LordRhyolith] = { 
 				 ["encounterID"] = 51,
			},
			[F_Alysrazor] = { 
 				 ["encounterID"] = 52,
			},
			[F_Shannox] = { 
 				 ["encounterID"] = 53,
			},
			[F_BaleroctheGatekeeper] = { 
 				 ["encounterID"] = 54,
			},
			[F_MajordomoStaghelm] = { 
 				 ["encounterID"] = 55,
			},
			[F_Ragnaros] = { 
 				 ["encounterID"] = 56,
			},
			},
		[DragonSoul_string] = { 
			[DS_Morchok] = { 
 				 ["encounterID"] = 57,
			},
			[DS_WarlordZonozz] = { 
 				 ["encounterID"] = 58,
			},
			[DS_YorsahjtheUnsleeping] = { 
 				 ["encounterID"] = 59,
			},
			[DS_HagaratheStormbinder] = { 
 				 ["encounterID"] = 60,
			},
			[DS_Ultraxion] = { 
 				 ["encounterID"] = 61,
			},
			[DS_WarmasterBlackhorn] = { 
 				 ["encounterID"] = 62,
			},
			[DS_SpineofDeathwing] = { 
 				 ["encounterID"] = 63,
			},
			[DS_MadnessofDeathwing] = { 
 				 ["encounterID"] = 64,
			},
			},
		},
["Mists of Pandaria"] = { 
		[Pandaria_string] = { 
			[P_ShaofAnger] = { 
 				 ["encounterID"] = 65,
			},
			[P_SalyissWarband] = { 
 				 ["encounterID"] = 66,
			},
			[P_NalakTheStormLord] = { 
 				 ["encounterID"] = 67,
			},
			[P_Oondasta] = { 
 				 ["encounterID"] = 68,
			},
			[P_ChiJiTheRedCrane] = { 
 				 ["encounterID"] = 69,
			},
			[P_YulonTheJadeSerpent] = { 
 				 ["encounterID"] = 70,
			},
			[P_NiuzaoTheBlackOx] = { 
 				 ["encounterID"] = 71,
			},
			[P_XuenTheWhiteTiger] = { 
 				 ["encounterID"] = 72,
			},
			[P_OrdosFireGodoftheYaungol] = { 
 				 ["encounterID"] = 73,
			},
			},
		[MogushanVaults_string] = { 
			[MV_TheStoneGuard] = { 
 				 ["encounterID"] = 74,
			},
			[MV_FengtheAccursed] = { 
 				 ["encounterID"] = 75,
			},
			[MV_GarajaltheSpiritbinder] = { 
 				 ["encounterID"] = 76,
			},
			[MV_TheSpiritKings] = { 
 				 ["encounterID"] = 77,
			},
			[MV_Elegon] = { 
 				 ["encounterID"] = 78,
			},
			[MV_WilloftheEmperor] = { 
 				 ["encounterID"] = 79,
			},
			},
		[HeartofFear_string] = { 
			[HoF_ImperialVizierZorlok] = { 
 				 ["encounterID"] = 80,
			},
			[HoF_BladeLordTayak] = { 
 				 ["encounterID"] = 90,
			},
			[HoF_Garalon] = { 
 				 ["encounterID"] = 91,
			},
			[HoF_WindLordMeljarak] = { 
 				 ["encounterID"] = 92,
			},
			[HoF_AmberShaperUnsok] = { 
 				 ["encounterID"] = 93,
			},
			[HoF_GrandEmpressShekzeer] = { 
 				 ["encounterID"] = 94,
			},
			},
		[TerraceofEndlessSpring_string] = { 
			[ToES_ProtectorsoftheEndless] = { 
 				 ["encounterID"] = 95,
			},
			[ToES_Tsulong] = { 
 				 ["encounterID"] = 96,
			},
			[ToES_LeiShi] = { 
 				 ["encounterID"] = 97,
			},
			[ToES_ShaofFear] = { 
 				 ["encounterID"] = 98,
			},
			},
		[ThroneofThunder_string] = { 
			[ToT_JinrokhtheBreaker] = { 
 				 ["encounterID"] = 99,
			},
			[ToT_Horridon] = { 
 				 ["encounterID"] = 100,
			},
			[ToT_CouncilofElders] = { 
 				 ["encounterID"] = 101,
			},
			[ToT_Tortos] = { 
 				 ["encounterID"] = 102,
			},
			[ToT_Megaera] = { 
 				 ["encounterID"] = 103,
			},
			[ToT_JiKun] = { 
 				 ["encounterID"] = 104,
			},
			[ToT_DurumutheForgotten] = { 
 				 ["encounterID"] = 105,
			},
			[ToT_Primordius] = { 
 				 ["encounterID"] = 106,
			},
			[ToT_DarkAnimus] = { 
 				 ["encounterID"] = 107,
			},
			[ToT_IronQon] = { 
 				 ["encounterID"] = 108,
			},
			[ToT_TwinConsorts] = { 
 				 ["encounterID"] = 109,
			},
			[ToT_LeiShen] = { 
 				 ["encounterID"] = 110,
			},
			},
		[SiegeofOrgrimmar_string] = { 
			[SoO_Immerseus] = { 
 				 ["encounterID"] = 111,
			},
			[SoO_TheFallenProtectors] = { 
 				 ["encounterID"] = 112,
			},
			[SoO_Norushen] = { 
 				 ["encounterID"] = 113,
			},
			[SoO_ShaofPride] = { 
 				 ["encounterID"] = 114,
			},
			[SoO_Galakras] = { 
 				 ["encounterID"] = 115,
			},
			[SoO_IronJuggernaut] = { 
 				 ["encounterID"] = 116,
			},
			[SoO_KorkronDarkShaman] = { 
 				 ["encounterID"] = 117,
			},
			[SoO_GeneralNazgrim] = { 
 				 ["encounterID"] = 118,
			},
			[SoO_Malkorok] = { 
 				 ["encounterID"] = 119,
			},
			[SoO_SpoilsofPandaria] = { 
 				 ["encounterID"] = 120,
			},
			[SoO_ThoktheBloodthirsty] = { 
 				 ["encounterID"] = 121,
			},
			[SoO_SiegecrafterBlackfuse] = { 
 				 ["encounterID"] = 122,
			},
			[SoO_ParagonsoftheKlaxxi] = { 
 				 ["encounterID"] = 123,
			},
			[SoO_GarroshHellscream] = { 
 				 ["encounterID"] = 124,
			},
			},
		},
["Warlords of Draenor"] = { 
		[Draenor_string] = { 
			[D_DrovtheRuiner] = { 
 				 ["encounterID"] = 125,
			},
			[D_TarlnatheAgeless] = { 
 				 ["encounterID"] = 126,
			},
			[D_Rukhmar] = { 
 				 ["encounterID"] = 127,
			},
			[D_SupremeLordKazzak] = { 
 				 ["encounterID"] = 128,
			},
			},
		[Highmaul_string] = { 
			[H_KargathBladefist] = { 
 				 ["encounterID"] = 129,
			},
			[H_TheButcher] = { 
 				 ["encounterID"] = 130,
			},
			[H_Tectus] = { 
 				 ["encounterID"] = 131,
			},
			[H_Brackenspore] = { 
 				 ["encounterID"] = 132,
			},
			[H_TwinOgron] = { 
 				 ["encounterID"] = 133,
			},
			[H_Koragh] = { 
 				 ["encounterID"] = 134,
			},
			[H_ImperatorMargok] = { 
 				 ["encounterID"] = 135,
			},
			},
		[BlackrockFoundry_string] = { 
			[BF_Oregorger] = { 
 				 ["encounterID"] = 136,
			},
			[BF_HansgarandFranzok] = { 
 				 ["encounterID"] = 137,
			},
			[BF_BeastlordDarmac] = { 
 				 ["encounterID"] = 138,
			},
			[BF_Gruul] = { 
 				 ["encounterID"] = 139,
			},
			[BF_FlamebenderKagraz] = { 
 				 ["encounterID"] = 140,
			},
			[BF_OperatorThogar] = { 
 				 ["encounterID"] = 141,
			},
			[BF_TheBlastFurnace] = { 
 				 ["encounterID"] = 142,
			},
			[BF_Kromog] = { 
 				 ["encounterID"] = 143,
			},
			[BF_TheIronMaidens] = { 
 				 ["encounterID"] = 144,
			},
			[BF_Blackhand] = { 
 				 ["encounterID"] = 145,
			},
			},
		[HellfireCitadel_string] = { 
			[HC_HellfireAssault] = { 
 				 ["encounterID"] = 146,
			},
			[HC_IronReaver] = { 
 				 ["encounterID"] = 147,
			},
			[HC_Kormrok] = { 
 				 ["encounterID"] = 148,
			},
			[HC_HellfireHighCouncil] = { 
 				 ["encounterID"] = 149,
			},
			[HC_KilroggDeadeye] = { 
 				 ["encounterID"] = 150,
			},
			[HC_Gorefiend] = { 
 				 ["encounterID"] = 151,
			},
			[HC_ShadowLordIskar] = { 
 				 ["encounterID"] = 152,
			},
			[HC_SocrethartheEternal] = { 
 				 ["encounterID"] = 153,
			},
			[HC_FelLordZakuun] = { 
 				 ["encounterID"] = 154,
			},
			[HC_Xhulhorac] = { 
 				 ["encounterID"] = 155,
			},
			[HC_TyrantVelhari] = { 
 				 ["encounterID"] = 156,
			},
			[HC_Mannoroth] = { 
 				 ["encounterID"] = 157,
			},
			[HC_Archimonde] = { 
 				 ["encounterID"] = 158,
			},
			},
		},
["Legion"] = { 
		[BrokenIsles_string] = { 
			[BI_AnaMouz] = { 
 				 ["encounterID"] = 159,
			},
			["Oak Heart"] = {
				["encounterID"] = 1837,
			},
			[BI_Apocron] = { 
 				 ["encounterID"] = 160,
			},
			[BI_Brutallus] = { 
 				 ["encounterID"] = 161,
			},
			[BI_Calamir] = { 
 				 ["encounterID"] = 162,
			},
			[BI_DrugontheFrostblood] = { 
 				 ["encounterID"] = 163,
			},
			[BI_Flotsam] = { 
 				 ["encounterID"] = 164,
			},
			[BI_Humongris] = { 
 				 ["encounterID"] = 165,
			},
			[BI_Levantus] = { 
 				 ["encounterID"] = 166,
			},
			[BI_Malificus] = { 
 				 ["encounterID"] = 167,
			},
			[BI_NazaktheFiend] = { 
 				 ["encounterID"] = 168,
			},
			[BI_Nithogg] = { 
 				 ["encounterID"] = 169,
			},
			[BI_Sharthos] = { 
 				 ["encounterID"] = 170,
			},
			[BI_Sivash] = { 
 				 ["encounterID"] = 171,
			},
			[BI_TheSoultakers] = { 
 				 ["encounterID"] = 172,
			},
			[BI_WitheredJim] = { 
 				 ["encounterID"] = 173,
			},
			},
		[TheEmeraldNightmare_string] = { 
			[TEN_Nythendra] = { 
 				 ["encounterID"] = 174,
			},
			[TEN_IlgynothHeartofCorruption] = { 
 				 ["encounterID"] = 175,
			},
			[TEN_EleretheRenferal] = { 
 				 ["encounterID"] = 176,
			},
			[TEN_Ursoc] = { 
 				 ["encounterID"] = 177,
			},
			[TEN_DragonsofNightmare] = { 
 				 ["encounterID"] = 178,
			},
			[TEN_Cenarius] = { 
 				 ["encounterID"] = 179,
			},
			[TEN_Xavius] = { 
 				 ["encounterID"] = 180,
			},
			},
		[TrialofValor_string] = { 
			[ToV_Odyn] = { 
 				 ["encounterID"] = 181,
			},
			[ToV_Guarm] = { 
 				 ["encounterID"] = 182,
			},
			[ToV_Helya] = { 
 				 ["encounterID"] = 183,
			},
			},
		[TheNighthold_string] = { 
			[TN_Skorpyron] = { 
 				 ["encounterID"] = 184,
			},
			[TN_ChronomaticAnomaly] = { 
 				 ["encounterID"] = 185,
			},
			[TN_Trilliax] = { 
 				 ["encounterID"] = 186,
			},
			[TN_SpellbladeAluriel] = { 
 				 ["encounterID"] = 187,
			},
			[TN_Tichondrius] = { 
 				 ["encounterID"] = 188,
			},
			[TN_Krosus] = { 
 				 ["encounterID"] = 189,
			},
			[TN_HighBotanistTelarn] = { 
 				 ["encounterID"] = 190,
			},
			[TN_StarAugurEtraeus] = { 
 				 ["encounterID"] = 191,
			},
			[TN_GrandMagistrixElisande] = { 
 				 ["encounterID"] = 192,
			},
			[TN_Guldan] = { 
 				 ["encounterID"] = 193,
			},
			},
		[TombofSargeras_string] = { 
			[ToS_Goroth] = { 
 				 ["encounterID"] = 194,
			},
			[ToS_DemonicInquisition] = { 
 				 ["encounterID"] = 195,
			},
			[ToS_Harjatan] = { 
 				 ["encounterID"] = 196,
			},
			[ToS_SistersoftheMoon] = { 
 				 ["encounterID"] = 197,
			},
			[ToS_MistressSasszine] = { 
 				 ["encounterID"] = 198,
			},
			[ToS_TheDesolateHost] = { 
 				 ["encounterID"] = 199,
			},
			[ToS_MaidenofVigilance] = { 
 				 ["encounterID"] = 200,
			},
			[ToS_FallenAvatar] = { 
 				 ["encounterID"] = 201,
			},
			[ToS_Kiljaeden] = { 
 				 ["encounterID"] = 202,
			},
			},
		[AntorustheBurningThrone_string] = { 
			[AtBT_GarothiWorldbreaker] = { 
 				 ["encounterID"] = 203,
			},
			[AtBT_FelhoundsofSargeras] = { 
 				 ["encounterID"] = 204,
			},
			[AtBT_AntoranHighCommand] = { 
 				 ["encounterID"] = 205,
			},
			[AtBT_PortalKeeperHasabel] = { 
 				 ["encounterID"] = 206,
			},
			[AtBT_EonartheLifeBinder] = { 
 				 ["encounterID"] = 207,
			},
			[AtBT_ImonartheSoulhunter] = { 
 				 ["encounterID"] = 208,
			},
			[AtBT_Kingaroth] = { 
 				 ["encounterID"] = 209,
			},
			[AtBT_Varimathras] = { 
 				 ["encounterID"] = 210,
			},
			[AtBT_TheCovenofShivarra] = { 
 				 ["encounterID"] = 211,
			},
			[AtBT_Aggramar] = { 
 				 ["encounterID"] = 212,
			},
			[AtBT_ArgustheUnmaker] = { 
 				 ["encounterID"] = 213,
			},
			},
		[InvasionPoints_string] = { 
			[IP_MatronFolnuna] = { 
 				 ["encounterID"] = 214,
			},
			[IP_MistressAlluradel] = { 
 				 ["encounterID"] = 215,
			},
			[IP_InquisitorMeto] = { 
 				 ["encounterID"] = 216,
			},
			[IP_Occularus] = { 
 				 ["encounterID"] = 217,
			},
			[IP_Sotanathor] = { 
 				 ["encounterID"] = 218,
			},
			[IP_PitLordVilemus] = { 
 				 ["encounterID"] = 219,
			},
			},
		},
	}

SA_Cooldowns = SA_Cooldowns or {
   ["WARRIOR"] = {
		["97462"] = { -- Shout
			["SpellID"] = "97462",
			["Name"] = Commandingshout_String,
			["Duration"] = "12",
			["Cooldown"] = "180"
		}
	}, 
	["DEATHKNIGHT"] = {
	}, 
	["PALADIN"] = {
		["31821"] = { -- Aura Mastery
			["SpellID"] = "31821",
			["Name"] = AuraMastery_String,
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["204150"] = { -- Aegis of Light
			["SpellID"] = "204150",
			["Name"] = AegisofLight_String,
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["6940"] = { -- Blessing of Sacrifice
			["SpellID"] = "6940",
			["Name"] = BlessingofSacrifice_String,
			["Duration"] = "12",
			["Cooldown"] = "150"
		},
		["204018"] = { -- Blessing of Spellwarding
			["SpellID"] = "196718",
			["Name"] = BlessingofSpellwarding_String,
			["Duration"] = "10",
			["Cooldown"] = "180"
		},
		["1022"] = { -- Blessing of Protection
			["SpellID"] = "1022",
			["Name"] = BlessingofPortection_String,
			["Duration"] = "10",
			["Cooldown"] = "300"
		}
	},
	["SHAMAN"] = {
		["108280"] = { -- Healing Tide Totem
			["SpellID"] = "108280",
			["Name"] = HealingTide_String ,
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["207399"] = { -- Ancestral Protection Totem
			["SpellID"] = "207399",
			["Name"] = AncestralProtection_String,
			["Duration"] = "30",
			["Cooldown"] = "300"
		},
		["98008"] = { -- Spirit Link Totem
			["SpellID"] = "98008",
			["Name"] = SpiritLink_String,
			["Duration"] = "6",
			["Cooldown"] = "180"
		},
		["192077"] = { -- Wind Rush Totem
			["SpellID"] = "192077",
			["Name"] = WindRush_String,
			["Duration"] = "15",
			["Cooldown"] = "120"
		}
	}, 
	["HUNTER"] = {
	}, 
	["DEMONHUNTER"] = {
		["196718"] = { -- Darkness
			["SpellID"] = "196718",
			["Name"] = Darkness_String,
			["Duration"] = "8",
			["Cooldown"] = "180"
		}
	},
	["ROUGE"] = {
	}, 
	["DRUID"] = {
		["740"] = { -- Tranquility
			["SpellID"] = "740",
			["Name"] = Tranquility_String,
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["102342"] = { -- Iron Bark
			["SpellID"] = "102342",
			["Name"] = IronBark_String,
			["Duration"] = "12",
			["Cooldown"] = "90"
		},
		["106898"] = { -- Stampeding Roar
			["SpellID"] = "106898",
			["Name"] = StampedingRoar_String,
			["Duration"] = "15",
			["Cooldown"] = "120"
		}
	}, 
	["MONK"] = {
		["115310"] = { -- Revival
			["SpellID"] = "115310",
			["Name"] = Revival_String,
			["Duration"] = "1",
			["Cooldown"] = "180"
		},
		["116849"] = { -- Life Cocoon
			["SpellID"] = "116849",
			["Name"] = LifeCocoon_String,
			["Duration"] = "12",
			["Cooldown"] = "180"
		}
	}, 
	["PRIEST"] = {
		["62618"] = { -- Power Word: Barrier
			["SpellID"] = "62618",
			["Name"] = PowerWord_String,
			["Duration"] = "10",
			["Cooldown"] = "180"
		},
		["64843"] = { -- Divine Hymn
			["SpellID"] = "64843",
			["Name"] = DrivineHymn_String,
			["Duration"] = "8",
			["Cooldown"] = "180"
		},
		["15268"] = { -- Vampiric Embrace
			["SpellID"] = "15268",
			["Name"] = VampiricEmbrace_String,
			["Duration"] = "15",
			["Cooldown"] = "180"
		},
		["47788"] = { -- Guardian Spirit
			["SpellID"] = "47788",
			["Name"] = GuardianSpirit_String,
			["Duration"] = "10",
			["Cooldown"] = "240"
		},
		["33206"] = { -- Pain Suppression
			["SpellID"] = "33206",
			["Name"] = PainSuppression_String,
			["Duration"] = "8",
			["Cooldown"] = "240"
		}
	}, 
	["WARLOCK"] = {
	}, 
	["MAGE"] = {
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


