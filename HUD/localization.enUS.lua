--Author: Bartlomiej Grabelus

local _G = _G

if GetLocale() ~= "enUS" then return end

if not _G.HUD.Locales then _G.HUD.Locales = {} end

-- SmartAssign.lua
local L = {}
-- make L global --
_G.HUD.Locales = L

L["Starts to cast "] = "Starts to cast "

L["Starts in "] = "Starts in "

L[" sec"] = " sec"

L[" is channeling now!"] = " is channeling now!"