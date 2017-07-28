-- ============
-- CLASS LIST
-- ============

classList = {
   ["Warrior"] = {
		["97462"] = { -- Shout
			["SpellID"] = "97462",
			["Name"] = "Shout",
			["Duration"] = "12",
			["Cooldown"] = "180"
		},
      --118038 = "Die by Swords"
   }, 
   ["Death Knight"] = {
   }, 
   ["Paladin"] = {
   },
   ["Demon Hunter"] = {
      [196718] = "Darkness"
   }
}

function GetClassSpellNames(class)
   local spellList = classList[class]
   local spellNames = {}
   if(spellList) then
      for spellId, spellInformation in pairs(spellList) do
         print(spellId)
         table.insert(spellNames, spellInformation["Name"])
      end
   end
   return spellNames
end

--Zum Testen
function GetPartySpells()
   print(getAllMembers())
   local playerList = getAllMembers()
   
   if(playerList) then
      for name, class in  pairs(playerList) do
         printHashTable(GetClassSpellNames(class))
      end
   end
end