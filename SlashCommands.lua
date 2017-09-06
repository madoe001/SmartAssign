local _G = _G

local SlashCommands = _G.SmartAssign.SlashCommands

local SAL = _G.SmartAssign.Locales

-- Assertion
local assert, type = assert, type

-- string functions
local str_lower = string.lowerlocal str_lower, str_format, str_split = string.lower, string.format, string.split

-- table functions
local tbl_remove, unpack, pairs = table.remove, unpack, pairs

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

local HelpList = {
	[""] = SAL["/smart - Open the SmartAssign window."],
	["slash"] = SAL["/smart slash - Prints a list of all slash commands."],
}


local resetFunctions = {} -- container for reset functions

function SlashCommands:Init()
print("INIT SlashCommands")
	SLASH_SMARTASSIGN1 = "/smartassign"
	SLASH_SMARTASSIGN2 = "/smart"
	SlashCmdList["SMARTASSIGN"] = function(msg)
		msg = str_lower(msg)
		msg = { str_split(" ", msg) or msg }
		if #msg >= 1 then
			local exec = tbl_remove(msg, 1)
			SlashCommands:Run(exec, unpack(msg))
		end
	end
end

function SlashCommands:Run(exec, ...)
	if exec and type(exec) == "string" then
		if CommandList[exec] and type(CommandList[exec]) == "function" then
			CommandList[exec](...)
		elseif SlashCommands[exec] then
			SlashCommands[exec](...)
		else
			print(str_format(SAL["Command %s not found. Use '/smart slash' for a full list of commands."], exec))
		end
	end
end

function SlashCommands:PrintSlash()
	print(SAL["Slash commands:"])
	for k in pairs(CommandList) do
		if k == "reset" then
			local resetCommands = "all, frames"
			for k,v in pairs(resetFunctions) do
				if k ~= "frames" then
					resetCommands = resetCommands..", "..k
				end
			end
			resetCommands = "|cff33ff99<"..resetCommands..">|r"
			print(str_format("/sa %s %s%s", k, resetCommands, HelpList[k] or ""))
		elseif HelpList[k] then
			print(HelpList[k])
		else
			print(str_format("/sa %s", k))
		end
	end	
end

-- Reset a Frame
function SlashCommands:Reset(name)
	for tabName,funcTab in pairs(resetFunctions) do
		if not name or name == "all" or name == tabName then
			for func in pairs(funcTab) do
				func()
			end
		end
	end
end

-- Add a ResetFunction of a Frame
function SlashCommands:AddResetFunction(func, ...)
print(func)
	assert(type(func) == "function", SAL["'func' must be a function."])
	local name
	for i=1,select("#",...) do
		name = select(i,...)
		if not resetFunctions[name] then resetFunctions[name] = {} end
		resetFunctions[name][func] = true
	end
end

-- Adds a new slash command
function SlashCommands:Add(exec, func, helpText)
	assert(type(exec) == "string", SAL["'exec' must be a string."])
	assert(type(func) == "function", SAL["'func' must be a function."])
	assert(type(helpText) == "string", SAL["'helpText' must be a string."])
	assert(not CommandList[exec], str_format(SAL["%s already exists."], exec))
	CommandList[exec] = func
	HelpList[exec] = helpText
end