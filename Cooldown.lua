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

function GetClassSpell(class)
   local spellList = classList[class]
   print(spellList)
   if(spellList) then
      for spellId, spellInformation in pairs(spellList) do
         print(spellId)
         for key, value in pairs(spellInformation) do
            print("   ".. key .. " " .. value)
         end
      end
   end
   
end

--GetClassSpell("Warrior") --zum testen