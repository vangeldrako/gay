# SiltUI

Roblox UI library with animated grid patterns, glow effects, and smooth transitions. Works on PC and mobile. Built for executor environments.

## Setup

```lua
local SiltUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/vangeldrako/gay/refs/heads/main/SiltUI.lua"))()
```

## Creating a Window

```lua
local Window = SiltUI:CreateWindow({
    Title     = "My Script",
    ToggleKey = Enum.KeyCode.RightShift,
    OpenButton = {
        Title      = "Open",
        Enabled    = true,
        OnlyMobile = true,
        X          = 0.85,
        Y          = 0.5,
    },
})
```

`OpenButton` is optional. If included, it creates a draggable floating button that toggles the window. Set `OnlyMobile = true` to hide it on PC.

`ToggleKey` is optional. Sets the keyboard shortcut to show/hide the window. Defaults to `RightShift`. Accepts any `Enum.KeyCode` or `Enum.UserInputType`. Can also be changed after creation with `Window:SetToggleKey(key)`.

## Sections

Sections show up in the left sidebar. Each section holds tabs.

```lua
local Combat = Window:Section({ Title = "Combat", Icon = "crosshair" })
local Visual = Window:Section({ Title = "Visuals", Icon = "eye" })
```

`Icon` is optional. If left out, it auto-matches from the title (e.g. "Combat" picks "crosshair"). See the icon list below.

## Tabs

Tabs appear as a horizontal strip inside each section.

```lua
local MainTab     = Combat:Tab({ Title = "Main" })
local SettingsTab = Combat:Tab({ Title = "Settings" })
```

## Elements

All elements are added to tabs. Every element that holds a value supports `Flag` for config saving.

### Toggle

```lua
MainTab:Toggle({
    Title    = "Auto Parry",
    Desc     = "Blocks incoming attacks automatically",
    Flag     = "AutoParry",
    Value    = false,
    Callback = function(enabled)
        _G.autoParry = enabled
    end,
})
```

`Desc` is optional. Cards are taller when a description is included.

### Slider

```lua
MainTab:Slider({
    Title = "Walk Speed",
    Flag  = "WalkSpeed",
    Value = { Min = 0, Max = 100, Default = 16 },
    Step  = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})
```

### Button

```lua
MainTab:Button({
    Title    = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end,
})
```

Optional: `Color = Color3.fromRGB(r, g, b)` to override the button color.

### Dropdown

```lua
MainTab:Dropdown({
    Title    = "Attack Type",
    Flag     = "AttackType",
    Values   = {"Melee", "Ranged", "Magic"},
    Value    = "Melee",
    Callback = function(selected)
        _G.attackType = selected
    end,
})
```

Call `:Refresh(newValues)` on the returned element to update the options list at runtime.

### Input

```lua
MainTab:Input({
    Title       = "Target Player",
    Flag        = "TargetName",
    Placeholder = "Enter username...",
    Value       = "",
    Callback    = function(text)
        _G.targetName = text
    end,
})
```

### Keybind

```lua
MainTab:Keybind({
    Title    = "Toggle Key",
    Flag     = "ToggleKey",
    Value    = "F",
    Callback = function(keyName)
        print("Bound to " .. keyName)
    end,
})
```

Supports keyboard keys and mouse buttons. Click the keybind box, then press any key to rebind.

### Colorpicker

```lua
MainTab:Colorpicker({
    Title    = "ESP Color",
    Flag     = "ESPColor",
    Default  = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        _G.espColor = color
    end,
})
```

Opens an HSV picker with a hex input box.

### Section Header

```lua
MainTab:Section({ Title = "Movement Options" })
```

Adds a labeled divider to visually group elements within a tab.

### Space

```lua
MainTab:Space()
```

Adds a small vertical gap between elements.

### Group (Inline Buttons)

```lua
local row = MainTab:Group()
row:Button({
    Title    = "Start",
    Callback = function() end,
})
row:Button({
    Title    = "Stop",
    Color    = Color3.fromRGB(255, 72, 48),
    Callback = function() end,
})
```

Places buttons side by side in a single row. `row:Space()` adds a small gap between them.

## Notifications

```lua
SiltUI:Notify({
    Title    = "Script Loaded",
    Desc     = "Everything is ready to go",
    Icon     = "check",
    Duration = 4,
})
```

Notifications stack from the bottom-right corner and auto-dismiss. The accent bar on the left and progress bar match the icon type (warning icons use yellow).

## Config System

Every window has a `ConfigManager` for saving and loading element states.

```lua
local CM = Window.ConfigManager

local config = CM:Config("my_preset")
config:Save()
config:Load()
config:Delete()

local allNames = CM:AllConfigs()
```

Only elements with a `Flag` are included in saves. Configs are stored as JSON files in the `SiltUI/` folder.

## Destroy

```lua
Window:Destroy()
```

Animates the window out and removes it.

## Icons

These icon names can be used in `Section`, `Notify`, or anywhere an icon is accepted:

`activity` `alert-triangle` `camera` `check` `crosshair` `eye` `flame` `gamepad` `info` `layout-dashboard` `list` `log-in` `minus` `monitor` `palette` `scan` `settings` `shield` `sparkles` `sword` `swords` `target` `toggle-left` `user` `wand` `wrench` `x` `zap`

Section icons auto-match from title keywords. For example, a section titled "Combat" automatically gets the crosshair icon.

## Element Methods

All value-holding elements return a handle with a `:Set(value)` method for programmatic updates:

```lua
local toggle = MainTab:Toggle({ Title = "Aimbot", Flag = "Aimbot", Value = false })
toggle:Set(true)

local slider = MainTab:Slider({ Title = "FOV", Value = { Min = 1, Max = 120, Default = 70 } })
slider:Set(90)

local dropdown = MainTab:Dropdown({ Title = "Mode", Values = {"A", "B"}, Value = "A" })
dropdown:Set("B")
dropdown:Refresh({"A", "B", "C"})
```

## Window Methods

### SetToggleKey

Changes the keyboard shortcut to show/hide the window after creation. Accepts any `Enum.KeyCode` or `Enum.UserInputType`.

```lua
Window:SetToggleKey(Enum.KeyCode.Insert)
Window:SetToggleKey(Enum.UserInputType.MouseButton3)
```
