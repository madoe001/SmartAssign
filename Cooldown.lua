local _G = _G
-- ============
-- CLASS LIST
-- ============

local ClassList = _G.ClassList
local SmartAssign = _G.SmartAssign

function ClassList:GetClassSpellNames(class)
   local spellList = SA_Cooldowns[class]
   local spellNames = {}
   if(spellList) then
      for spellId, spellInformation in pairs(spellList) do
         local spellname = spellInformation["Name"]
         table.insert(spellNames, spellId, spellname)
      end
   end
   return spellNames
end

--Zum Testen
function ClassList:GetPartySpells()
print(">> GetPartySpells() << called")
   local playerList = SmartAssign:getAllMembers()
   if(playerList) then
      for name, class in  pairs(playerList) do
         print(name, class)
         SmartAssign:printHashTable(GetClassSpellNames(class))
      end
   end
end