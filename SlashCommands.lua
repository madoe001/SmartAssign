--Author: Bartlomiej Grabelus

local _G = _G

local SlashCommands = _G.SmartAssign.SlashCommands

-- localization
local SAL = _G.GUI.Locales

-- Assertion
local assert, type = assert, type

-- string functions
local str_lower = string.lowerlocal str_lower, str_format, str_split = string.lower, string.format, string.split

-- table functions
local tbl_remove, unpack, pairs = table.remove, unpack, pairs

-- container for the command list
local CommandList = {
	[""] = function()
		_G.SmartAssign.SA_GUI:Toggle()
	end,
	["slash"] = function()
		SlashCommands:PrintSlash()
	end,
	["reset"] = function(typ)
		SlashCommands:Reset(typ or "all")
	end,
}

-- container which contains the help text
local HelpList = {
	[""] = SAL["/smart - Open the SmartAssign window."],
	["slash"] = SAL["/smart slash - Prints a list of all slash commands."],
}


local resetFunctions = {} -- container for reset functions

-- SlashCommands:Init(): init function.
function SlashCommands:Init()
	SLASH_SMARTASSIGN1 = "/smartassign"
	SLASH_SMARTASSIGN2 = "/smart"
	SlashCmdList["SMARTASSIGN"] = function(msg) -- add to slashcommandlist
		msg = str_lower(msg) -- make lower case
		msg = { str_split(" ", msg) or msg } -- split the msg if can
		if #msg >= 1 then -- if table msg lower equal 1
			local exec = tbl_remove(msg, 1) -- get the exec msg of msg
			SlashCommands:Run(exec, unpack(msg)) -- run the exec
		end
	end
end

-- SlashCommands:Run(): function to run a slashcommand
function SlashCommands:Run(exec, ...)
	if exec and type(exec) == "string" then -- exec not nil  and string
		if CommandList[exec] and type(CommandList[exec]) == "function" then -- if the exec exists in the command list and is a function
			CommandList[exec](...) -- run
		elseif SlashCommands[exec] then -- elseif exists in slashcommands
			SlashCommands[exec](...) -- run
		else -- if not found
			print(str_format(SAL["Command %s not found. Use '/smart slash' for a full list of commands."], exec))
		end
	end
end

-- SlashCommands:PrintSlash(): print all slashcommands, which are available
function SlashCommands:PrintSlash()
	print(SAL["Slash commands:"])
	for k in pairs(CommandList) do -- lopp through the command list
		if k == "reset" then -- if k = reset loop through reset functions
			local resetCommands = "all, frames"
			for k,v in pairs(resetFunctions) do
				if k ~= "frames" then
					resetCommands = resetCommands..", "..k
				end
			end
			resetCommands = "|cff33ff99<"..resetCommands..">|r"
			print(str_format("/sa %s %s%s", k, resetCommands, HelpList[k] or "")) -- print reset functions
		elseif HelpList[k] then -- print helplist
			print(HelpList[k])
		else -- print other slashcommands in commandlist
			print(str_format("/sa %s", k))
		end
	end	
end

-- SlashCommands:Reset(): Reset a Frame
-- needed if want to call reset a frame over slashcommand
--
-- name: of frame
function SlashCommands:Reset(name)
	for tabName,funcTab in pairs(resetFunctions) do
		if not name or name == "all" or name == tabName then
			for func in pairs(funcTab) do
				func()
			end
		end
	end
end

-- SlashCommands:AddResetFunction(): Add a ResetFunction of a Frame
-- if want to reset over slashcommands
--
-- assertion: if func no function
--
-- func: reset function
-- ...: name for frame
function SlashCommands:AddResetFunction(func, ...)
	assert(type(func) == "function", SAL["'func' must be a function."])
	local name
	for i=1,select("#",...) do -- get all from ...
		name = select(i,...)
		if not resetFunctions[name] then resetFunctions[name] = {} end -- if doesnt exist create one
		resetFunctions[name][func] = true
	end
end

-- SlashCommands:Add(): Adds a new slash command
--
-- assertion: if exec no string
-- assertion: if func no function
-- assertion: if helpText no string
--
-- exec: the string under which want to exec
-- func: the function
-- helpText: helpText for the helpList
function SlashCommands:Add(exec, func, helpText)
	assert(type(exec) == "string", SAL["'exec' must be a string."])
	assert(type(func) == "function", SAL["'func' must be a function."])
	assert(type(helpText) == "string", SAL["'helpText' must be a string."])
	assert(not CommandList[exec], str_format(SAL["%s already exists."], exec))
	CommandList[exec] = func
	HelpList[exec] = helpText
end