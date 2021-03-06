
--- Funktionen zum Erstellen der Lokalisierungsvariablen
-- Die folgenden Funktionen dienen lediglich dazu die Lokalisierung schneller erstellen zu können
-- Da WoW ueber 100 Raidbosse hat erspart dies die Arbeit
--
-- @author Maik Doemmecke
function printBosses()
   local t = 1
   SA_local = ""
  local ctr = 1
	 for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      print(tiername)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            
	    SA_local = SA_local .. "\n" .. SA_bossnameList[ctr] .. "=" .. "\"" .. bossname .. "\""
            j = j+1
	ctr = ctr + 1
         end
      end
   end
end

function printRaids()
   local t = 1
   SA_local = ""
  local ctr = 1
	 for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
	 local bossString = SA_name
         EJ_SelectInstance(SA_instanceId)
         local zwischen, _ = string.gsub(SA_name, " ", "" )
         SA_name,_ = string.gsub(zwischen, "'","")
         zwischen = string.gsub(SA_name, "-","")
         SA_name = string.gsub(zwischen, ",","")
	SA_local = SA_local .. "\n" .. SA_raidNames[ctr] .. "=" .. "\"" .. bossString .. "\"" 

	 --table.insert(SA_local, SA_name .. "_string")
	 ctr = ctr + 1
         i = i+1
         
       end
   end
	
end



function createLocalizationNameList()
  local t = 1
   SA_local = {}
  for t = 1, EJ_GetNumTiers(), 1 do
      
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      --print(tiername)
      
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            table.insert(SA_local, (newName.."_"..name))
            j = j+1
         end
      end
   end
end


function createBossList()
   local t = 1
   SA_local = ""
  local bossctr = 1
  local raidctr = 1

  for t = 1, EJ_GetNumTiers(), 1 do
      EJ_SelectTier(t)
      tiername,_ = EJ_GetTierInfo(t)
      print(tiername)
      SA_local = SA_local .. "[\"" .. tiername .. "\"] = { \r"  
      local i = 1
      while EJ_GetInstanceByIndex(i, true) do
         SA_instanceId, SA_name = EJ_GetInstanceByIndex(i, true)
         EJ_SelectInstance(SA_instanceId)
         SA_local = SA_local .. "\\t\\t[" .. SA_raidNames[raidctr] .. "] = { \r" 
         local newName = ""
         
         for i in string.gmatch(SA_name, "%S+") do
            newName = newName .. string.sub(i, 1, 1)
         end
         print(newName)
         i = i+1
         raidctr = raidctr + 1
         local j = 1
         while EJ_GetEncounterInfoByIndex(j, instanceId) do
            local name, _, encounterId = EJ_GetEncounterInfoByIndex(j, instanceId)
            local bossname = name
            
            local zwischen, _ = string.gsub(name, " ", "" )
            name,_ = string.gsub(zwischen, "'","")
            zwischen = string.gsub(name, "-","")
            name = string.gsub(zwischen, ",","")
            
	    SA_local = SA_local .. "\\t\\t\\t[" .. SA_bossnameList[bossctr] .. "] = { \r \\t\\t\\t\\t [\"encounterID\"] = ,\r\\t\\t\\t},\r" 
            j = j+1
	    bossctr = bossctr + 1
         end
	 SA_local  = SA_local .. "\\t\\t},\r"
      end
	 SA_local  = SA_local .. "\\t},\r"

   end
end







SA_bossnameList = {
	"MC_Lucifron", -- [1]
	"MC_Magmadar", -- [2]
	"MC_Gehennas", -- [3]
	"MC_Garr", -- [4]
	"MC_Shazzrah", -- [5]
	"MC_BaronGeddon", -- [6]
	"MC_SulfuronHarbinger", -- [7]
	"MC_GolemaggtheIncinerator", -- [8]
	"MC_MajordomoExecutus", -- [9]
	"MC_Ragnaros", -- [10]
	"BL_RazorgoretheUntamed", -- [11]
	"BL_VaelastrasztheCorrupt", -- [12]
	"BL_BroodlordLashlayer", -- [13]
	"BL_Firemaw", -- [14]
	"BL_Ebonroc", -- [15]
	"BL_Flamegor", -- [16]
	"BL_Chromaggus", -- [17]
	"BL_Nefarian", -- [18]
	"RoA_Kurinnaxx", -- [19]
	"RoA_GeneralRajaxx", -- [20]
	"RoA_Moam", -- [21]
	"RoA_BurutheGorger", -- [22]
	"RoA_AyamisstheHunter", -- [23]
	"RoA_OssiriantheUnscarred", -- [24]
	"ToA_TheProphetSkeram", -- [25]
	"ToA_SilithidRoyalty", -- [26]
	"ToA_BattleguardSartura", -- [27]
	"ToA_FankrisstheUnyielding", -- [28]
	"ToA_Viscidus", -- [29]
	"ToA_PrincessHuhuran", -- [30]
	"ToA_TheTwinEmperors", -- [31]
	"ToA_Ouro", -- [32]
	"ToA_Cthun", -- [33]
	"K_ServantsQuarters", -- [34]
	"K_AttumentheHuntsman", -- [35]
	"K_Moroes", -- [36]
	"K_MaidenofVirtue", -- [37]
	"K_OperaHall", -- [38]
	"K_TheCurator", -- [39]
	"K_ShadeofAran", -- [40]
	"K_TerestianIllhoof", -- [41]
	"K_Netherspite", -- [42]
	"K_ChessEvent", -- [43]
	"K_PrinceMalchezaar", -- [44]
	"GL_HighKingMaulgar", -- [45]
	"GL_GruultheDragonkiller", -- [46]
	"ML_Magtheridon", -- [47]
	"SC_HydrosstheUnstable", -- [48]
	"SC_TheLurkerBelow", -- [49]
	"SC_LeotherastheBlind", -- [50]
	"SC_FathomLordKarathress", -- [51]
	"SC_MorogrimTidewalker", -- [52]
	"SC_LadyVashj", -- [53]
	"TE_Alar", -- [54]
	"TE_VoidReaver", -- [55]
	"TE_HighAstromancerSolarian", -- [56]
	"TE_KaelthasSunstrider", -- [57]
	"TBfMH_RageWinterchill", -- [58]
	"TBfMH_Anetheron", -- [59]
	"TBfMH_Kazrogal", -- [60]
	"TBfMH_Azgalor", -- [61]
	"TBfMH_Archimonde", -- [62]
	"BT_HighWarlordNajentus", -- [63]
	"BT_Supremus", -- [64]
	"BT_ShadeofAkama", -- [65]
	"BT_TeronGorefiend", -- [66]
	"BT_GurtoggBloodboil", -- [67]
	"BT_ReliquaryofSouls", -- [68]
	"BT_MotherShahraz", -- [69]
	"BT_TheIllidariCouncil", -- [70]
	"BT_IllidanStormrage", -- [71]
	"SP_Kalecgos", -- [72]
	"SP_Brutallus", -- [73]
	"SP_Felmyst", -- [74]
	"SP_TheEredarTwins", -- [75]
	"SP_Muru", -- [76]
	"SP_Kiljaeden", -- [77]
	"VoA_ArchavontheStoneWatcher", -- [78]
	"VoA_EmalontheStormWatcher", -- [79]
	"VoA_KoralontheFlameWatcher", -- [80]
	"VoA_ToravontheIceWatcher", -- [81]
	"N_AnubRekhan", -- [82]
	"N_GrandWidowFaerlina", -- [83]
	"N_Maexxna", -- [84]
	"N_NoththePlaguebringer", -- [85]
	"N_HeigantheUnclean", -- [86]
	"N_Loatheb", -- [87]
	"N_InstructorRazuvious", -- [88]
	"N_GothiktheHarvester", -- [89]
	"N_TheFourHorsemen", -- [90]
	"N_Patchwerk", -- [91]
	"N_Grobbulus", -- [92]
	"N_Gluth", -- [93]
	"N_Thaddius", -- [94]
	"N_Sapphiron", -- [95]
	"N_KelThuzad", -- [96]
	"TOS_Sartharion", -- [97]
	"TEoE_Malygos", -- [98]
	"U_FlameLeviathan", -- [99]
	"U_IgnistheFurnaceMaster", -- [100]
	"U_Razorscale", -- [101]
	"U_XT002Deconstructor", -- [102]
	"U_TheAssemblyofIron", -- [103]
	"U_Kologarn", -- [104]
	"U_Auriaya", -- [105]
	"U_Hodir", -- [106]
	"U_Thorim", -- [107]
	"U_Freya", -- [108]
	"U_Mimiron", -- [109]
	"U_GeneralVezax", -- [110]
	"U_YoggSaron", -- [111]
	"U_AlgalontheObserver", -- [112]
	"TotC_TheNorthrendBeasts", -- [113]
	"TotC_LordJaraxxus", -- [114]
	"TotC_ChampionsoftheHorde", -- [115]
	"TotC_TwinValkyr", -- [116]
	"TotC_Anubarak", -- [117]
	"OL_Onyxia", -- [118]
	"IC_LordMarrowgar", -- [119]
	"IC_LadyDeathwhisper", -- [120]
	"IC_IcecrownGunshipBattle", -- [121]
	"IC_DeathbringerSaurfang", -- [122]
	"IC_Festergut", -- [123]
	"IC_Rotface", -- [124]
	"IC_ProfessorPutricide", -- [125]
	"IC_BloodPrinceCouncil", -- [126]
	"IC_BloodQueenLanathel", -- [127]
	"IC_ValithriaDreamwalker", -- [128]
	"IC_Sindragosa", -- [129]
	"IC_TheLichKing", -- [130]
	"TRS_Halion", -- [131]
	"BH_Argaloth", -- [132]
	"BH_Occuthar", -- [133]
	"BH_AlizabalMistressofHate", -- [134]
	"BD_OmnotronDefenseSystem", -- [135]
	"BD_Magmaw", -- [136]
	"BD_Atramedes", -- [137]
	"BD_Chimaeron", -- [138]
	"BD_Maloriak", -- [139]
	"BD_NefariansEnd", -- [140]
	"TBoT_HalfusWyrmbreaker", -- [141]
	"TBoT_TheralionandValiona", -- [142]
	"TBoT_AscendantCouncil", -- [143]
	"TBoT_Chogall", -- [144]
	"TotFW_TheConclaveofWind", -- [145]
	"TotFW_AlAkir", -- [146]
	"F_Bethtilac", -- [147]
	"F_LordRhyolith", -- [148]
	"F_Alysrazor", -- [149]
	"F_Shannox", -- [150]
	"F_BaleroctheGatekeeper", -- [151]
	"F_MajordomoStaghelm", -- [152]
	"F_Ragnaros", -- [153]
	"DS_Morchok", -- [154]
	"DS_WarlordZonozz", -- [155]
	"DS_YorsahjtheUnsleeping", -- [156]
	"DS_HagaratheStormbinder", -- [157]
	"DS_Ultraxion", -- [158]
	"DS_WarmasterBlackhorn", -- [159]
	"DS_SpineofDeathwing", -- [160]
	"DS_MadnessofDeathwing", -- [161]
	"P_ShaofAnger", -- [162]
	"P_SalyissWarband", -- [163]
	"P_NalakTheStormLord", -- [164]
	"P_Oondasta", -- [165]
	"P_ChiJiTheRedCrane", -- [166]
	"P_YulonTheJadeSerpent", -- [167]
	"P_NiuzaoTheBlackOx", -- [168]
	"P_XuenTheWhiteTiger", -- [169]
	"P_OrdosFireGodoftheYaungol", -- [170]
	"MV_TheStoneGuard", -- [171]
	"MV_FengtheAccursed", -- [172]
	"MV_GarajaltheSpiritbinder", -- [173]
	"MV_TheSpiritKings", -- [174]
	"MV_Elegon", -- [175]
	"MV_WilloftheEmperor", -- [176]
	"HoF_ImperialVizierZorlok", -- [177]
	"HoF_BladeLordTayak", -- [178]
	"HoF_Garalon", -- [179]
	"HoF_WindLordMeljarak", -- [180]
	"HoF_AmberShaperUnsok", -- [181]
	"HoF_GrandEmpressShekzeer", -- [182]
	"ToES_ProtectorsoftheEndless", -- [183]
	"ToES_Tsulong", -- [184]
	"ToES_LeiShi", -- [185]
	"ToES_ShaofFear", -- [186]
	"ToT_JinrokhtheBreaker", -- [187]
	"ToT_Horridon", -- [188]
	"ToT_CouncilofElders", -- [189]
	"ToT_Tortos", -- [190]
	"ToT_Megaera", -- [191]
	"ToT_JiKun", -- [192]
	"ToT_DurumutheForgotten", -- [193]
	"ToT_Primordius", -- [194]
	"ToT_DarkAnimus", -- [195]
	"ToT_IronQon", -- [196]
	"ToT_TwinConsorts", -- [197]
	"ToT_LeiShen", -- [198]
	"SoO_Immerseus", -- [199]
	"SoO_TheFallenProtectors", -- [200]
	"SoO_Norushen", -- [201]
	"SoO_ShaofPride", -- [202]
	"SoO_Galakras", -- [203]
	"SoO_IronJuggernaut", -- [204]
	"SoO_KorkronDarkShaman", -- [205]
	"SoO_GeneralNazgrim", -- [206]
	"SoO_Malkorok", -- [207]
	"SoO_SpoilsofPandaria", -- [208]
	"SoO_ThoktheBloodthirsty", -- [209]
	"SoO_SiegecrafterBlackfuse", -- [210]
	"SoO_ParagonsoftheKlaxxi", -- [211]
	"SoO_GarroshHellscream", -- [212]
	"D_DrovtheRuiner", -- [213]
	"D_TarlnatheAgeless", -- [214]
	"D_Rukhmar", -- [215]
	"D_SupremeLordKazzak", -- [216]
	"H_KargathBladefist", -- [217]
	"H_TheButcher", -- [218]
	"H_Tectus", -- [219]
	"H_Brackenspore", -- [220]
	"H_TwinOgron", -- [221]
	"H_Koragh", -- [222]
	"H_ImperatorMargok", -- [223]
	"BF_Oregorger", -- [224]
	"BF_HansgarandFranzok", -- [225]
	"BF_BeastlordDarmac", -- [226]
	"BF_Gruul", -- [227]
	"BF_FlamebenderKagraz", -- [228]
	"BF_OperatorThogar", -- [229]
	"BF_TheBlastFurnace", -- [230]
	"BF_Kromog", -- [231]
	"BF_TheIronMaidens", -- [232]
	"BF_Blackhand", -- [233]
	"HC_HellfireAssault", -- [234]
	"HC_IronReaver", -- [235]
	"HC_Kormrok", -- [236]
	"HC_HellfireHighCouncil", -- [237]
	"HC_KilroggDeadeye", -- [238]
	"HC_Gorefiend", -- [239]
	"HC_ShadowLordIskar", -- [240]
	"HC_SocrethartheEternal", -- [241]
	"HC_FelLordZakuun", -- [242]
	"HC_Xhulhorac", -- [243]
	"HC_TyrantVelhari", -- [244]
	"HC_Mannoroth", -- [245]
	"HC_Archimonde", -- [246]
	"BI_AnaMouz", -- [247]
	"BI_Apocron", -- [248]
	"BI_Brutallus", -- [249]
	"BI_Calamir", -- [250]
	"BI_DrugontheFrostblood", -- [251]
	"BI_Flotsam", -- [252]
	"BI_Humongris", -- [253]
	"BI_Levantus", -- [254]
	"BI_Malificus", -- [255]
	"BI_NazaktheFiend", -- [256]
	"BI_Nithogg", -- [257]
	"BI_Sharthos", -- [258]
	"BI_Sivash", -- [259]
	"BI_TheSoultakers", -- [260]
	"BI_WitheredJim", -- [261]
	"TEN_Nythendra", -- [262]
	"TEN_IlgynothHeartofCorruption", -- [263]
	"TEN_EleretheRenferal", -- [264]
	"TEN_Ursoc", -- [265]
	"TEN_DragonsofNightmare", -- [266]
	"TEN_Cenarius", -- [267]
	"TEN_Xavius", -- [268]
	"ToV_Odyn", -- [269]
	"ToV_Guarm", -- [270]
	"ToV_Helya", -- [271]
	"TN_Skorpyron", -- [272]
	"TN_ChronomaticAnomaly", -- [273]
	"TN_Trilliax", -- [274]
	"TN_SpellbladeAluriel", -- [275]
	"TN_Tichondrius", -- [276]
	"TN_Krosus", -- [277]
	"TN_HighBotanistTelarn", -- [278]
	"TN_StarAugurEtraeus", -- [279]
	"TN_GrandMagistrixElisande", -- [280]
	"TN_Guldan", -- [281]
	"ToS_Goroth", -- [282]
	"ToS_DemonicInquisition", -- [283]
	"ToS_Harjatan", -- [284]
	"ToS_SistersoftheMoon", -- [285]
	"ToS_MistressSasszine", -- [286]
	"ToS_TheDesolateHost", -- [287]
	"ToS_MaidenofVigilance", -- [288]
	"ToS_FallenAvatar", -- [289]
	"ToS_Kiljaeden", -- [290]
	"AtBT_GarothiWorldbreaker", -- [291]
	"AtBT_FelhoundsofSargeras", -- [292]
	"AtBT_AntoranHighCommand", -- [293]
	"AtBT_PortalKeeperHasabel", -- [294]
	"AtBT_EonartheLifeBinder", -- [295]
	"AtBT_ImonartheSoulhunter", -- [296]
	"AtBT_Kingaroth", -- [297]
	"AtBT_Varimathras", -- [298]
	"AtBT_TheCovenofShivarra", -- [299]
	"AtBT_Aggramar", -- [300]
	"AtBT_ArgustheUnmaker", -- [301]
	"IP_MatronFolnuna", -- [302]
	"IP_MistressAlluradel", -- [303]
	"IP_InquisitorMeto", -- [304]
	"IP_Occularus", -- [305]
	"IP_Sotanathor", -- [306]
	"IP_PitLordVilemus", -- [307]
}

SA_raidNames = {
	"MoltenCore_string", -- [1]
	"BlackwingLair_string", -- [2]
	"RuinsofAhnQiraj_string", -- [3]
	"TempleofAhnQiraj_string", -- [4]
	"Karazhan_string", -- [5]
	"GruulsLair_string", -- [6]
	"MagtheridonsLair_string", -- [7]
	"SerpentshrineCavern_string", -- [8]
	"TheEye_string", -- [9]
	"TheBattleforMountHyjal_string", -- [10]
	"BlackTemple_string", -- [11]
	"SunwellPlateau_string", -- [12]
	"VaultofArchavon_string", -- [13]
	"Naxxramas_string", -- [14]
	"TheObsidianSanctum_string", -- [15]
	"TheEyeofEternity_string", -- [16]
	"Ulduar_string", -- [17]
	"TrialoftheCrusader_string", -- [18]
	"OnyxiasLair_string", -- [19]
	"IcecrownCitadel_string", -- [20]
	"TheRubySanctum_string", -- [21]
	"BaradinHold_string", -- [22]
	"BlackwingDescent_string", -- [23]
	"TheBastionofTwilight_string", -- [24]
	"ThroneoftheFourWinds_string", -- [25]
	"Firelands_string", -- [26]
	"DragonSoul_string", -- [27]
	"Pandaria_string", -- [28]
	"MogushanVaults_string", -- [29]
	"HeartofFear_string", -- [30]
	"TerraceofEndlessSpring_string", -- [31]
	"ThroneofThunder_string", -- [32]
	"SiegeofOrgrimmar_string", -- [33]
	"Draenor_string", -- [34]
	"Highmaul_string", -- [35]
	"BlackrockFoundry_string", -- [36]
	"HellfireCitadel_string", -- [37]
	"BrokenIsles_string", -- [38]
	"TheEmeraldNightmare_string", -- [39]
	"TrialofValor_string", -- [40]
	"TheNighthold_string", -- [41]
	"TombofSargeras_string", -- [42]
	"AntorustheBurningThrone_string", -- [43]
	"InvasionPoints_string", -- [44]
}

