-- Author: Bartlomiej Grabelus (10044563)

-- Description: This file is needed for initialize ShlashCommands for SmartAssign.
--              This Class is made global and have three cotainers, one for the commands, one for helpText and one for reset functions.

local _G = _G

local SlashCommands = _G.SmartAssign.SlashCommands

-- localization
local SAL = _G.GUI.Locales

-- Assertion
local assert, type = assert, type

-- string functions
local str_lower, str_format, str_split = string.lower, string.format, string.split

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
-- Initialize the slashcommands "/smartassign" and "/smart"
--
-- author: Bartlomiej Grabelus (10044563)
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
-- called when the player type in a slashcommand in the chat
--
-- author: Bartlomiej Grabelus (10044563)
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

-- SlashCommands:PrintSlash(): print all available slashcommands
-- called when the player type "/smart slash" into chat
--
-- author: Bartlomiej Grabelus (10044563)
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
-- needed if want to call reset a frame over a slashcommand
--
-- name: of frame
--
-- author: Bartlomiej Grabelus (10044563)
function SlashCommands:Reset(name)
	for tabName,funcTab in pairs(resetFunctions) do -- get name and function of container and check if name exists in function container
		if not name or name == "all" or name == tabName then
			for func in pairs(funcTab) do
				func() -- call function
			end
		end
	end
end

-- SlashCommands:AddResetFunction(): Add a ResetFunction of a Frame
-- if want to reset the frame over slashcommands
--
-- assertion: if func no function
--
-- func: reset function
-- ...: name for frame
--
-- author: Bartlomiej Grabelus (10044563)
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
--
-- author: Bartlomiej Grabelus (10044563)
function SlashCommands:Add(exec, func, helpText)
	assert(type(exec) == "string", SAL["'exec' must be a string."])
	assert(type(func) == "function", SAL["'func' must be a function."])
	assert(type(helpText) == "string", SAL["'helpText' must be a string."])
	assert(not CommandList[exec], str_format(SAL["%s already exists."], exec))
	CommandList[exec] = func
	HelpList[exec] = helpText
end
