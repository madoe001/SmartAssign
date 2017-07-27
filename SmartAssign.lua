--> Mainfuntionality of the Addon

--


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
