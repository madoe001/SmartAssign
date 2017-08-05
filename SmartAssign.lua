-- Global vars --
local _G = _G

local SmartAssign = _G.SmartAssign
local ClassList = _G.ClassList

--> Mainfuntionality of the Addon

function SmartAssign:printHashTable(table)
   if(table) then
      for key, value in pairs(table) do
         print(key, value)
      end
   else
      print("Undefined reference")
      
   end
   
end




function SmartAssign:getAllMembers()
   
   print (">> getAllMembers() << called\n");
   
   
   local raidSize = GetNumGroupMembers() or 0;
   
   
   if(raidSize > 0) then
      -- global machen um in der DropDownListe zugreifen zu können!!!
      local playerList = {}
      
      if(not IsInRaid() and  IsInGroup) then
         
         raidSize = raidSize -1;
         
         local name = UnitName("player")
         local class = UnitClass(name)
         playerList[name..""] =  class
      end
      
      
      for i = 1, raidSize do
         
         if IsInRaid() then
            
            local name, realm = UnitName("raid"..i)
            local key 
            
            if(realm) then
               key = name.."-"..realm
            else
               key = name
            end
            print(key)
            local class = UnitClass(key)
            playerList[key] =  class
            
         else if IsInGroup() then
               local memberName, realm = UnitName("party"..i)
               local key
               if(realm ~= "" ) then
                  key = memberName.."-"..realm
               else
                  key = memberName
               end
               local class = UnitClass(key)
               playerList[key] =  class
            end                       
         end
         
      end
      return  playerList;
      
   end
   return nil;
   
end

function SmartAssign:printNumericTable(table)
   if(table) then
      if(#table > 0) then
         for i = 1, #table do
            print(table[i])
         end
      end
   end
end

function SmartAssign:printClass(table)
   if(table)then      
      for key, class in pairs(table) do
         print(class)
      end      
   end
end

do
	-- load the GUI
	SmartAssign.SA_GUI:LoadFrame()
	ClassList:GetPartySpells()
end