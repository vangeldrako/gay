local SiltUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/vangeldrako/gay/refs/heads/test/SiltUI.lua"))()

local Window = SiltUI:CreateWindow({
    Title     = "Example Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    OpenButton = {
        Title      = "Menu",
        Enabled    = true,
        OnlyMobile = true,
        X          = 0.9,
        Y          = 0.45,
    },
})

SiltUI:Notify({
    Title    = "Example Hub",
    Desc     = "Loaded successfully",
    Icon     = "check",
    Duration = 3,
})

local CombatSection  = Window:Section({ Title = "Combat", Icon = "crosshair" })
local VisualsSection = Window:Section({ Title = "Visuals", Icon = "eye" })
local MiscSection    = Window:Section({ Title = "Misc", Icon = "settings" })

local MainTab = CombatSection:Tab({ Title = "Main" })

MainTab:Section({ Title = "Targeting" })

MainTab:Toggle({
    Title    = "Lock-On",
    Desc     = "Snap to nearest enemy when activated",
    Flag     = "LockOn",
    Value    = true,
    Callback = function(v)
        _G.lockOn = v
    end,
})

MainTab:Toggle({
    Title    = "Auto Block",
    Flag     = "AutoBlock",
    Value    = false,
    Callback = function(v)
        _G.autoBlock = v
    end,
})

MainTab:Slider({
    Title = "Attack Range",
    Flag  = "AtkRange",
    Value = { Min = 5, Max = 50, Default = 15 },
    Step  = 1,
    Callback = function(v)
        _G.attackRange = v
    end,
})

MainTab:Space()
MainTab:Section({ Title = "Keybinds" })

MainTab:Keybind({
    Title    = "Lock Target",
    Flag     = "LockKey",
    Value    = "F",
    Callback = function(key)
    end,
})

MainTab:Keybind({
    Title    = "Toggle Script",
    Flag     = "ToggleKey",
    Value    = "V",
    Callback = function(key)
    end,
})

MainTab:Space()
MainTab:Section({ Title = "Actions" })

local actionRow = MainTab:Group()
actionRow:Button({
    Title    = "Reset Character",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end,
})
actionRow:Button({
    Title    = "Heal",
    Color    = Color3.fromRGB(52, 211, 153),
    Callback = function()
        SiltUI:Notify({ Title = "Heal", Desc = "Not implemented in this example", Icon = "info", Duration = 2 })
    end,
})

local SkillsTab = CombatSection:Tab({ Title = "Skills" })

SkillsTab:Dropdown({
    Title    = "Active Skill",
    Flag     = "ActiveSkill",
    Values   = {"Divergent Fist", "Focus Strike", "Domain Expansion"},
    Value    = "Divergent Fist",
    Callback = function(v)
        _G.activeSkill = v
    end,
})

SkillsTab:Toggle({
    Title    = "Auto Use Skill",
    Desc     = "Fires the selected skill when in range",
    Flag     = "AutoSkill",
    Value    = false,
    Callback = function(v)
        _G.autoSkill = v
    end,
})

SkillsTab:Slider({
    Title = "Skill Range",
    Flag  = "SkillRange",
    Value = { Min = 5, Max = 30, Default = 12 },
    Step  = 1,
    Callback = function(v)
        _G.skillRange = v
    end,
})

local ESPTab = VisualsSection:Tab({ Title = "ESP" })

ESPTab:Section({ Title = "Player ESP" })

ESPTab:Toggle({
    Title    = "Enable ESP",
    Flag     = "ESP",
    Value    = false,
    Callback = function(v)
        _G.espEnabled = v
    end,
})

ESPTab:Colorpicker({
    Title    = "ESP Color",
    Flag     = "ESPColor",
    Default  = Color3.fromRGB(99, 102, 241),
    Callback = function(c)
        _G.espColor = c
    end,
})

ESPTab:Dropdown({
    Title    = "ESP Type",
    Flag     = "ESPType",
    Values   = {"Box", "Highlight", "Name Only"},
    Value    = "Box",
    Callback = function(v)
        _G.espType = v
    end,
})

ESPTab:Slider({
    Title = "Max Distance",
    Flag  = "ESPDist",
    Value = { Min = 50, Max = 2000, Default = 500 },
    Step  = 50,
    Callback = function(v)
        _G.espMaxDist = v
    end,
})

local CameraTab = VisualsSection:Tab({ Title = "Camera" })

CameraTab:Section({ Title = "Camera Lock" })

CameraTab:Toggle({
    Title    = "Camera Lock",
    Desc     = "Keeps camera focused on locked target",
    Flag     = "CamLock",
    Value    = true,
    Callback = function(v)
        _G.camLock = v
    end,
})

CameraTab:Slider({
    Title = "Lock Smoothness",
    Flag  = "CamSmooth",
    Value = { Min = 1, Max = 100, Default = 85 },
    Step  = 5,
    Callback = function(v)
        _G.camSmooth = v / 100
    end,
})

CameraTab:Space()
CameraTab:Section({ Title = "Field of View" })

CameraTab:Slider({
    Title = "FOV",
    Flag  = "FOV",
    Value = { Min = 30, Max = 120, Default = 70 },
    Step  = 1,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end,
})

local ToolsTab = MiscSection:Tab({ Title = "Tools" })

ToolsTab:Input({
    Title       = "Chat Message",
    Flag        = "ChatMsg",
    Placeholder = "Type something to send...",
    Value       = "",
    Callback    = function(text)
    end,
})

ToolsTab:Button({
    Title    = "Send Message",
    Callback = function()
    end,
})

ToolsTab:Space()
ToolsTab:Section({ Title = "Teleport" })

ToolsTab:Dropdown({
    Title    = "Destination",
    Flag     = "TpDest",
    Values   = {"Spawn", "Shop", "Arena", "Boss Room"},
    Value    = "Spawn",
    Callback = function(v)
        _G.tpDest = v
    end,
})

ToolsTab:Button({
    Title    = "Teleport",
    Color    = Color3.fromRGB(79, 70, 229),
    Callback = function()
        SiltUI:Notify({ Title = "Teleport", Desc = "Teleporting to " .. (_G.tpDest or "Spawn"), Icon = "log-in", Duration = 2 })
    end,
})

ToolsTab:Space()
ToolsTab:Section({ Title = "Server" })

local serverRow = ToolsTab:Group()
serverRow:Button({
    Title    = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end,
})
serverRow:Button({
    Title    = "Server Hop",
    Callback = function()
        SiltUI:Notify({ Title = "Server", Desc = "Looking for a new server...", Icon = "log-in", Duration = 3 })
    end,
})

local SettingsTab = MiscSection:Tab({ Title = "Settings" })

SettingsTab:Section({ Title = "Window" })

SettingsTab:Keybind({
    Title    = "Toggle Window",
    Flag     = "WindowToggleKey",
    Value    = "RightShift",
    Callback = function(key)
        -- update the window toggle key when the user rebinds it
        local kc = Enum.KeyCode[key]
        if kc then
            Window:SetToggleKey(kc)
        end
    end,
})

local ConfigTab = MiscSection:Tab({ Title = "Config" })

local CM = Window.ConfigManager
local selectedCfg = ""

ConfigTab:Input({
    Title       = "Config Name",
    Placeholder = "Enter a name...",
    Callback    = function(text)
        selectedCfg = text
    end,
})

ConfigTab:Dropdown({
    Title    = "Saved Configs",
    Values   = CM:AllConfigs(),
    Value    = "",
    Callback = function(v)
        selectedCfg = v
    end,
})

ConfigTab:Space()

local cfgRow = ConfigTab:Group()
cfgRow:Button({
    Title    = "Save",
    Callback = function()
        if selectedCfg == "" then
            SiltUI:Notify({ Title = "Config", Desc = "Enter a name first", Icon = "alert-triangle", Duration = 3 })
            return
        end
        Window.CurrentConfig = CM:Config(selectedCfg)
        local ok = Window.CurrentConfig:Save()
        SiltUI:Notify({
            Title    = "Config",
            Desc     = ok and ("Saved: " .. selectedCfg) or "Failed to save",
            Icon     = ok and "check" or "x",
            Duration = 3,
        })
    end,
})
cfgRow:Button({
    Title    = "Load",
    Callback = function()
        if selectedCfg == "" then return end
        Window.CurrentConfig = CM:Config(selectedCfg)
        local ok = Window.CurrentConfig:Load()
        SiltUI:Notify({
            Title    = "Config",
            Desc     = ok and ("Loaded: " .. selectedCfg) or "Failed to load",
            Icon     = ok and "check" or "x",
            Duration = 3,
        })
    end,
})

ConfigTab:Space()

ConfigTab:Button({
    Title    = "Delete Config",
    Color    = Color3.fromRGB(248, 72, 48),
    Callback = function()
        if selectedCfg == "" then return end
        CM:Config(selectedCfg):Delete()
        SiltUI:Notify({ Title = "Config", Desc = "Deleted: " .. selectedCfg, Icon = "check", Duration = 3 })
    end,
})
