
--- Beschreibung: Diese Klasse ist nötig, um SlashKommandos für SmartAssign zu initialisieren.
--				  Sie wird über _G global gemacht und besitzt 3 Container.
--				  Einen Container für die Kommandos, einen für Hilfe informationen und einen für Reset Funktionen
--
-- @module SlashCommands
-- @author Bartlomiej Grabelus (10044563)

--- hole die globale Tabelle
local _G = _G

local SlashCommands = _G.SmartAssign.SlashCommands

--- Lokalisierung
local SAL = _G.GUI.Locales

--- Assertion
local assert, type = assert, type

--- String Funktionen
local str_lower, str_format, str_split = string.lower, string.format, string.split

--- Tabellen Funktionen
local tbl_remove, unpack, pairs = table.remove, unpack, pairs

--- Container für die Kommandos
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

--- Container welche die Hilfe Texte beinhaltet
-- @table HelpList
local HelpList = {
	[""] = SAL["/smart - Open the SmartAssign window."],
	["slash"] = SAL["/smart slash - Prints a list of all slash commands."],
}

--- Container für die Reset Funktionen
-- @table resetFunctions
local resetFunctions = {} 

--- @function SlashCommands:Init
-- Zur initialisierung der Slash Kommandos "/smartassign" und "/smart"
function SlashCommands:Init()
	SLASH_SMARTASSIGN1 = "/smartassign"
	SLASH_SMARTASSIGN2 = "/smart"
	SlashCmdList["SMARTASSIGN"] = function(msg) -- füge function zur globalen slashcommandlist hinzu
		msg = str_lower(msg) -- konvertiere in kleine Buchstaben
		msg = { str_split(" ", msg) or msg } -- splitte msg, wenn möglich
		if #msg >= 1 then -- Es muss mindestens ein Eintrag in der Tabelle msg sein
			local exec = tbl_remove(msg, 1) -- hole den ersten Eintrag
			SlashCommands:Run(exec, unpack(msg)) -- führe exec aus und packe msg aus(gibt den Inhalt zurück)
		end
	end
end

--- @function SlashCommands:Run 
-- Zum ausführen eines Slash Kommandos
-- Wird aufgerufen, wenn der Spieler in WoW einen Slash Kommando im Chat eintippt und ausführt.
--
-- @tparam string exec ist das Slash Kommando 
-- @tparam string ... alle weiteren informationen --> z.B. /smart slash --> slash ist dann in ... enthalten und smart ist exec
function SlashCommands:Run(exec, ...)
	if exec and type(exec) == "string" then -- exec ist nicht nil und ein String
		if CommandList[exec] and type(CommandList[exec]) == "function" then -- Wenn exec in CommandList existiert und eine Funktion ist (Ist eine Funktion)
			CommandList[exec](...) -- führe aus
		elseif SlashCommands[exec] then -- wenn es in SlashCommands enthalten ist(Ist ein Slash Kommando)
			SlashCommands[exec](...) -- führe aus
		else -- wenn nicht vorhanden informiere den Spieler
			print(str_format(SAL["Command %s not found. Use '/smart slash' for a full list of commands."], exec))
		end
	end
end

--- @function SlashCommands:PrintSlash
-- Gibt dem Spieler im Chat alle möglichen Slash Kommandos aus.
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

--- @function SlashCommands:Reset
-- Führt die Reset Funktion eines Frames aus.
-- Wenn der Spieler diese über einen Slash Kommando aufruft.
--
-- @tparam string name Der Name des Frames
function SlashCommands:Reset(name)
	for tabName,funcTab in pairs(resetFunctions) do -- Hole den namen und die Funktione aus dem Container und prüfe, ob name im container enthalten ist.
		if not name or name == "all" or name == tabName then
			for func in pairs(funcTab) do
				func() -- führe die Funktion aus
			end
		end
	end
end

--- @function SlashCommands:AddResetFunction
-- Diese Funktion dient dazu eine Reset Funktion eines Frames hinzuzufügen.
-- Wenn man ein Frame über einen Slash Kommando zurücksetzen möchte.
--
-- @raise Wenn func keine Function ist.
--
-- @tparam string func ist die Reset Funktion
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

--- @function SlashCommands:Add
-- Füge einen neuen Slash Kommando hinzu.
--
-- @raise Wenn exec kein String ist
-- @raise Wenn func keine Funktion ist
-- @raise Wenn helfText kein string ist
--
-- @tparam string exec Der Name unter welchen ausgeführt werden soll
-- @tparam function func Die Funktion
-- @tparam string helpText Hilfe Text für den helpText Container
function SlashCommands:Add(exec, func, helpText)
	assert(type(exec) == "string", SAL["'exec' must be a string."])
	assert(type(func) == "function", SAL["'func' must be a function."])
	assert(type(helpText) == "string", SAL["'helpText' must be a string."])
	assert(not CommandList[exec], str_format(SAL["%s already exists."], exec))
	CommandList[exec] = func
	HelpList[exec] = helpText
end
