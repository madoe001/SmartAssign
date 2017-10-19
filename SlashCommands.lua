--- Beschreibung: Diese Klasse ist n&oumltig, um Slash Kommandos f&uumlr SmartAssign zu initialisieren.
--				  Sie wird &uumlber _G global gemacht und besitzt 3 Container.
--				  Einen Container f&uumlr die Kommandos, einen f&uumlr Hilfe informationen und einen f&uumlr Reset Funktionen.
--
-- @author Bartlomiej Grabelus (10044563)

-- hole die globale Tabelle
local _G = _G

local SlashCommands = _G.SmartAssign.SlashCommands

-- Lokalisierung
local SAL = _G.GUI.Locales

-- F&uumlr Fehlerbehandlung
local assert, type = assert, type

-- String Funktionen
local str_lower, str_format, str_split = string.lower, string.format, string.split

-- Tabellen Funktionen
local tbl_remove, unpack, pairs = table.remove, unpack, pairs

--- Container f&uumlr die Kommandos.
-- @table CommandList
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

--- Container welche die Hilfe Texte beinhaltet.
-- @table HelpList
local HelpList = {
	[""] = SAL["/smart - Open the SmartAssign window."],
	["slash"] = SAL["/smart slash - Prints a list of all slash commands."],
}

--- Container f&uumlr die Reset Funktionen
-- @table resetFunctions
local resetFunctions = {} 

--- Zur initialisierung der Slash Kommandos "/smartassign" und "/smart".
function SlashCommands:Init()
	SLASH_SMARTASSIGN1 = "/smartassign"
	SLASH_SMARTASSIGN2 = "/smart"
	SlashCmdList["SMARTASSIGN"] = function(msg) -- f&uumlge function zur globalen slashcommandlist hinzu
		msg = str_lower(msg) -- konvertiere in kleine Buchstaben
		msg = { str_split(" ", msg) or msg } -- splitte msg, wenn m&oumlglich
		if #msg >= 1 then -- Es muss mindestens ein Eintrag in der Tabelle msg sein
			local exec = tbl_remove(msg, 1) -- hole den ersten Eintrag
			SlashCommands:Run(exec, unpack(msg)) -- f&uumlhre exec aus und packe msg aus(gibt den Inhalt zur&uumlck)
		end
	end
end

--- Zum ausf&uumlhren eines Slash Kommandos.
-- Wird aufgerufen, wenn der Spieler in WoW einen Slash Kommando im Chat eintippt und ausf&uumlhrt.
--
-- @param exec ist das Slash Kommando 
-- @param ... alle weiteren informationen --> z.B. /smart slash --> slash ist dann in ... enthalten und smart ist exec
function SlashCommands:Run(exec, ...)
	if exec and type(exec) == "string" then -- exec ist nicht nil und ein String
		if CommandList[exec] and type(CommandList[exec]) == "function" then -- Wenn exec in CommandList existiert und eine Funktion ist (Ist eine Funktion)
			CommandList[exec](...) -- f&uumlhre aus
		elseif SlashCommands[exec] then -- wenn es in SlashCommands enthalten ist(Ist ein Slash Kommando)
			SlashCommands[exec](...) -- f&uumlhre aus
		else -- wenn nicht vorhanden informiere den Spieler
			print(str_format(SAL["Command %s not found. Use '/smart slash' for a full list of commands."], exec))
		end
	end
end

--- Gibt dem Spieler im Chat alle m&oumlglichen Slash Kommandos aus.
-- @usage Der Spieler gibt im Chat "/smart slash" ein.
function SlashCommands:PrintSlash()
	print(SAL["Slash commands:"])
	for k in pairs(CommandList) do -- Iteriere durch die Kommando Liste
		if k == "reset" then -- Wenn k = reset iteriere duch den Reset Funktionen Container
			local resetCommands = "all, frames"
			for k,v in pairs(resetFunctions) do
				if k ~= "frames" then
					resetCommands = resetCommands..", "..k
				end
			end
			resetCommands = "|cff33ff99<"..resetCommands..">|r"
			print(str_format("/sa %s %s%s", k, resetCommands, HelpList[k] or "")) -- Gebe im Chat die Reset Funktion aus
		elseif HelpList[k] then -- Gebe im Chat den Hilfstext aus
			print(HelpList[k])
		else -- Gebe alle anderen Slash Kommandos im Chat aus.
			print(str_format("/sa %s", k))
		end
	end	
end

--- F&uumlhrt die Reset Funktion eines Frames aus.
-- Wenn der Spieler diese &uumlber einen Slash Kommando aufruft.
--
-- @param name Der Name des Frames
function SlashCommands:Reset(name)
	for tabName,funcTab in pairs(resetFunctions) do -- Hole den namen und die Funktione aus dem Container und pr&uumlfe, ob name im container enthalten ist.
		if not name or name == "all" or name == tabName then
			for func in pairs(funcTab) do
				func() -- f&uumlhre die Funktion aus
			end
		end
	end
end

--- Diese Funktion dient dazu eine Reset Funktion eines Frames hinzuzuf&uumlgen.
-- Wenn man ein Frame &uumlber einen Slash Kommando zur&uumlcksetzen m&oumlchte.
--
-- Assertion: 'Wenn func keine Function ist.'
--
-- @param func ist die Reset Funktion
-- @param ... Name des Frames
function SlashCommands:AddResetFunction(func, ...)
	assert(type(func) == "function", SAL["'func' must be a function."])
	local name
	for i=1,select("#",...) do -- Durchlaufe alle in ...
		name = select(i,...)
		if not resetFunctions[name] then resetFunctions[name] = {} end -- Wenn keins existiert dann erstelle eins
		resetFunctions[name][func] = true
	end
end

--- F&uumlge einen neuen Slash Kommando hinzu.
--
-- Assertion: 'Wenn exec kein String ist'
-- Assertion: 'Wenn func keine Funktion ist'
-- Assertion: 'Wenn helfText kein string ist'
--
-- @param exec Der Name unter welchen ausgef&uumlhrt werden soll
-- @param func Die Funktion
-- @param helpText Hilfe Text f&uumlr den helpText Container
function SlashCommands:Add(exec, func, helpText)
	assert(type(exec) == "string", SAL["'exec' must be a string."])
	assert(type(func) == "function", SAL["'func' must be a function."])
	assert(type(helpText) == "string", SAL["'helpText' must be a string."])
	assert(not CommandList[exec], str_format(SAL["%s already exists."], exec))
	CommandList[exec] = func
	HelpList[exec] = helpText
end
