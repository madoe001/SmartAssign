--print("test");

TestTable = {
	var1 = "default 1.0",
	var2 = "default 2.0",
	var3 = 3.0,
	var4 = -5
}

function printTest()
	print("var1: " .. TestTable.var1 .. "\nvar2: " .. TestTable.var2 .. "\nvar3: " .. TestTable.var3 .. "\nvar4: " .. TestTable.var4);
end

function changeVars(v1,v2,v3)
	TestTable.var1 = v1;
	TestTable.var2 = v2;
	TestTable.var3 = v3;
end
printTest()