--> Mainfuntionality of the Addon


function findClassOfPlayer()
	
local playerClass = UnitClass("player");
	
return playerClass;

end


function printGroup()
   
   
	ret = {}
   
   
	if IsInRaid() then
      
      
		local amountMember = GetNumGroupMembers()
      
		for i = 1, amountMember do
         
         
			local name = GetUnitName("raid" .. i)
         
			ret[name] = UnitClass(name)  
      
		end 
   
	elseif IsInGroup() then 
      
      
		local amountMember = GetNumSubgroupMembers()
      
		ret[GetUnitName("player")] = UnitClass("player")   
      
		for i = 1, amountMember do
         
         
			local name = GetUnitName("party" .. i) 
         
		ret[name] = UnitClass(name)         
      
		end        
  
	else
      
		print "Player is not in Group "
   
	end
   
   
	return ret

end



function printTable(table)
   
	for key, value in pairs(table) do
      
		print(key, value)
   
	end

end



printTable(printGroup())


function getAllMembers()
   
	print (">>getAllMembers()<< called\n");
   
 
	local raidSize = GetNumGroupMembers() or 0;
 

 
   	if(raidSize > 0) then
      
		local playerList = {};
      
		if(not IsInRaid() and  IsInGroup) then
       
  			raidSize = raidSize -1;
        
 			print(GetUnitName("player"));
  
			table.insert(playerList, GetUnitName("player)";   
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
        
 	return nill;
      
end
      
      


getAllMembers()

