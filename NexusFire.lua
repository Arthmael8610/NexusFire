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
local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage
-----------------------------------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------------------------------
local wndGTFO

-----------------------------------------------------------------------------------------------
-- GeminiGUI
-----------------------------------------------------------------------------------------------
local tFloatingTextDef = {
  AnchorOffsets = { 209, 81, 501, 140 },
  RelativeToClient = true,
  Font = "CRB_Header24_O",
  Text = "GTFO!!!",
  BGColor = "UI_WindowBGDefault",
  TextColor = "UI_WindowTextDefault",
  Name = "FloatingText",
  Picture = true,
  Moveable = true,
  Overlapped = true,
  DT_CENTER = true,
  IgnoreMouse = true,
}

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function NexusFire:OnInitialize()

  --Event Handlers
  Apollo.RegisterEventHandler("CombatLogDamage", "OnCombatLogDamage")

  --Slash Commands
  Apollo.RegisterSlashCommand("nf", "OnNexusFireOn", self)

  --Create Window
  wndGTFO = GeminiGUI:Create(tFloatingTextDef)
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

function NexusFire:OnCombatLogDamage(tEventArgs)
  --enviroment damage is treated as if it were the player casting on him / her self.
  if tEventArgs.unitCaster then
    Print("UnitCasterExists")
    if tEventArgs.unitCaster == tEventArgs.unitTarget then
      wndGTFO:GetInstance()
      wndGTFO:Show(false)
    end
  end
  --if tEventArgs.strCasterName then
    Print("strCasterName Exists!")
    local AOETargetInfo = tEventArgs.splCallingSpell.GetAOETargetInfo()
    Event_FireGenericEvent("SendVarToRover", "AOETargetInfo", AOETargetInfo)
    if AOETargetInfo.eSelectionType ~= 0 then
      wndGTFO:GetInstance()
    else
      wndGTFO:Show(false)
    end
  --end

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
