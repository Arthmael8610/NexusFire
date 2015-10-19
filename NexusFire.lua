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
local Apollo, ApolloColor, ApolloTimer, GameLib = Apollo, ApolloColor, ApolloTimer, GameLib
local Event_FireGenericEvent, Print = Event_FireGenericEvent, Print

-----------------------------------------------------------------------------------------------
-- NexusFire Module Definition
-----------------------------------------------------------------------------------------------
local NexusFire = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("NexusFire", false)

local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage
-----------------------------------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------------------------------
local tGTFO
local tGTFOConfig
local wndGTFO
local wndGTFOConfig
local tTimer

-----------------------------------------------------------------------------------------------
-- GeminiGUI
-----------------------------------------------------------------------------------------------
local tNexusFireFormDef = {
  AnchorOffsets = { 69, 13, 548, 431 },
  RelativeToClient = true,
  Template = "CRB_NormalFramedThick_StandardHdrFtr",
  Name = "NexusFireForm",
  Border = true,
  Picture = true,
  SwallowMouseClicks = true,
  Moveable = true,
  Escapable = true,
  Overlapped = true,
  UseTemplateBG = true,
  Children = {
    {
      AnchorOffsets = { 25, 3, -47, 32 },
      AnchorPoints = { 0, 0, 1, 0 },
      RelativeToClient = true,
      Font = "CRB_Interface16_BBO",
      Name = "Title",
      TextColor = "ffc0c0c0",
      DT_VCENTER = true,
      DT_CENTER = true,
      NewControlDepth = 2,
      Text = "NexusFire Config",
    },
    {
      AnchorOffsets = { -146, -73, -26, -32 },
      AnchorPoints = { 1, 1, 1, 1 },
      Class = "Button",
      Base = "CRB_UIKitSprites:btn_square_LARGE_Red",
      Font = "CRB_InterfaceMedium",
      ButtonType = "PushButton",
      DT_VCENTER = true,
      DT_CENTER = true,
      Name = "CancelButton",
      NewControlDepth = 2,
      WindowSoundTemplate = "TogglePhys03",
      TextId = "CRB_Cancel",
      Events = {
        ButtonSignal = "OnCancel",
      },
    },
    {
      AnchorOffsets = { -268, -73, -148, -32 },
      AnchorPoints = { 1, 1, 1, 1 },
      Class = "Button",
      Base = "CRB_UIKitSprites:btn_square_LARGE_Green",
      Font = "CRB_InterfaceMedium",
      ButtonType = "PushButton",
      DT_VCENTER = true,
      DT_CENTER = true,
      Name = "OkButton",
      NewControlDepth = 2,
      WindowSoundTemplate = "TogglePhys02",
      TextId = "CRB_OK",
      Events = {
        ButtonSignal = "OnOK",
      },
    },
    {
      AnchorOffsets = { -29, 5, 3, 39 },
      AnchorPoints = { 1, 0, 1, 0 },
      Class = "Button",
      Base = "CRB_UIKitSprites:btn_close",
      Font = "Thick",
      ButtonType = "PushButton",
      DT_VCENTER = true,
      DT_CENTER = true,
      Name = "CloseButton",
      NewControlDepth = 2,
      WindowSoundTemplate = "CloseWindowPhys",
      Events = {
        ButtonSignal = "OnCancel",
      },
    },
    {
      AnchorOffsets = { 135, 103, 338, 129 },
      Class = "Button",
      Base = "BK3:btnHolo_Check",
      Font = "DefaultButton",
      ButtonType = "PushButton",
      DT_VCENTER = true,
      DT_CENTER = true,
      BGColor = "UI_BtnBGDefault",
      TextColor = "UI_BtnTextDefault",
      NormalTextColor = "UI_BtnTextDefault",
      PressedTextColor = "UI_BtnTextDefault",
      FlybyTextColor = "UI_BtnTextDefault",
      PressedFlybyTextColor = "UI_BtnTextDefault",
      DisabledTextColor = "UI_BtnTextDefault",
      Name = "chkLockUnlock",
      Text = "Unlock / Lock Window",
      Events = {
        ButtonSignal = "OnMoveWindow",
      },
    },
    {
      AnchorOffsets = { 10, 57, 447, 88 },
      RelativeToClient = true,
      Font = "CRB_Interface14_BBO",
      Text = "Check the box to move the GTFO window",
      BGColor = "UI_WindowBGDefault",
      TextColor = "UI_WindowTextDefault",
      Name = "Window",
      DT_CENTER = true,
    },
  },
}

local tFloatingTextDef = {
  AnchorOffsets = { 209, 81, 501, 140 },
  RelativeToClient = true,
  Font = "CRB_Header24_O",
  BGColor = "UI_WindowBGDefault",
  TextColor = "UI_WindowTextDefault",
  Name = "FloatingText",
  Picture = true,
  Moveable = true,
  Overlapped = true,
  DT_CENTER = true,
  IgnoreMouse = true,
  Visible = false,
  Sprite = "Alert:NewSprite",
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
  Apollo.RegisterEventHandler("CombatLogDamage", "OnCombatLogDamage", self)

  --Slash Commands
  Apollo.RegisterSlashCommand("nf", "OnNexusFireOn", self)

  --Load The Sprite into the game
  Apollo.LoadSprites("Alert.xml", "assets/")

  --Create Window
  tGTFO       = GeminiGUI:Create(tFloatingTextDef)
  tGTFOConfig = GeminiGUI:Create(tNexusFireFormDef)
end
-----------------------------------------------------------------------------------------------
-- NexusFire OnEnable
-----------------------------------------------------------------------------------------------
function NexusFire:OnEnable()
  Print("Hello my anme is NexusFire, I will warn you when to GTFO, Just Incase you forget!")
  --Create the instance of the window / options Window
  wndGTFO       = tGTFO:GetInstance(self)
  wndGTFOConfig = tGTFOConfig:GetInstance(self)
  wndGTFOConfig:Show(false)
end

-----------------------------------------------------------------------------------------------
-- NexusFire Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/nf"
function NexusFire:OnNexusFireOn(strCommnad, strArg)
  if strArg == "config" then
    wndGTFOConfig:Show(true)
  end
end

function NexusFire:OnCombatLogDamage(tEventArgs)
  local unitMe = GameLib.GetPlayerUnit()
  -- We're only tracking damage to ourselves
  if tEventArgs.unitTarget ~= unitMe then return end

  --enviroment damage is treated as if it were the player casting on him / her self.
  if tEventArgs.unitCaster then
    if tEventArgs.unitCaster == tEventArgs.unitTarget then
      wndGTFO:Show(true)
      tTimer = ApolloTimer.Create(1, false, "OnTimer", self)
    end
  end
  --PVE
  if tEventArgs.strCasterName then
    local AOETargetInfo = tEventArgs.splCallingSpell:GetAOETargetInfo()
    if AOETargetInfo.eSelectionType > 0 then
      wndGTFO:Show(true)
      tTimer = ApolloTimer.Create(2, true, "OnTimer", self)
    else
    end
  end
end

function NexusFire:OnTimer()
  wndGTFO:Show(false)
end

function NexusFire:OnMoveWindow()
  local chklockUnlock = wndGTFOConfig:FindChild("chkLockUnlock")
  if wndGTFO:IsVisible() == true then
    wndGTFO:Show(false)
    chklockUnlock:SetCheck(false)
  else
    wndGTFO:Show(true)
    chklockUnlock:SetCheck(true)
  end
end
-----------------------------------------------------------------------------------------------
-- NexusFireForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function NexusFire:OnOK()
  wndGTFOConfig:Show(false) -- hide the window
end

-- when the Cancel button is clicked
function NexusFire:OnCancel()
  wndGTFOConfig:Show(false) -- hide the window
end
