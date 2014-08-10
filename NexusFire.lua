-----------------------------------------------------------------------------------------------
-- Client Lua Script for NexusFire
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"

-----------------------------------------------------------------------------------------------
-- Upvalues
-----------------------------------------------------------------------------------------------
local error, floor, ipairs, pairs, tostring = error, math.floor, ipairs, pairs, tostring
local strformat = string.format

-- Wildstar APIs
local Apollo, ApolloColor, ApolloTimer = Apollo, ApolloColor, ApolloTimer
local GameLib = GameLib
local Event_FireGenericEvent, Print = Event_FireGenericEvent, Print

-----------------------------------------------------------------------------------------------
-- NexusFire Module Definition
-----------------------------------------------------------------------------------------------
local NexusFire = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("NexusFire", false)

-----------------------------------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function NexusFire:OnInitialize()
    -- load our form file
  --Event Handlers
  Apollo.RegisterEventHandler("CombatLogDamage", "OnCombatLogDamage")

  --Slash Commands
  Apollo.RegisterSlashCommand("nf", "OnNexusFireOn", self)
end

-----------------------------------------------------------------------------------------------
-- NexusFire OnEnable
-----------------------------------------------------------------------------------------------
function NexusFire:OnEnable()
  Print("Welcom To NexxusFire, I will Warn you When to GTFO, Just Incase you forget!")
end

-----------------------------------------------------------------------------------------------
-- NexusFire Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/nf"
function NexusFire:OnNexusFireOn()
	self.wndMain:Invoke() -- show the window
end


-----------------------------------------------------------------------------------------------
-- NexusFireForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function NexusFire:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
function NexusFire:OnCancel()
	self.wndMain:Close() -- hide the window
end
