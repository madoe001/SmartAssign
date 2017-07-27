--> Mainfuntionality of the Addon



function printTable(table)
   if(table) then
      if(#table > 0) then
         for key, value in pairs(table) do
            print(key, value)
         end
      end
   end
   
end


function getAllMembers()
   
   print (">>getAllMembers()<< called\n");
   
   
   local raidSize = GetNumGroupMembers() or 0;
   
   
   
   if(raidSize > 0) then
      
      local playerList = {};
      
      if(not IsInRaid() and  IsInGroup) then
         
         raidSize = raidSize -1;
         
         print(GetUnitName("player"));
         
         table.insert(playerList, GetUnitName("player"));   
      end
      
      
      for i = 1, raidSize  do
         
         if IsInRaid() then
            
            print(GetUnitName("raid"..i)); 
            
            table.insert(playerList, GetUnitName("raid"..i));
            
         else if IsInGroup() then
               
               print(GetUnitName("party"..i));
               
               table.insert(playerList, GetUnitName("party"..i));
               
            end           
            
            
         end
         
      end
      
      return  playerList;
      
   end
   
   return nil;
   
end