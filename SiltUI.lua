
local SiltUI = {}

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService       = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

local T = {
    Bg           = Color3.fromRGB(10, 10, 13),
    Surface      = Color3.fromRGB(14, 15, 19),
    Card         = Color3.fromRGB(19, 20, 26),
    CardHover    = Color3.fromRGB(25, 26, 34),
    Border       = Color3.fromRGB(33, 35, 46),
    BorderLight  = Color3.fromRGB(48, 51, 65),
    Accent       = Color3.fromRGB(139, 92, 246),
    AccentDark   = Color3.fromRGB(109, 40, 217),
    AccentLight  = Color3.fromRGB(167, 139, 250),
    AccentGlow   = Color3.fromRGB(139, 92, 246),
    AccentSoft   = Color3.fromRGB(40, 20, 80),
    Text         = Color3.fromRGB(228, 230, 240),
    TextMuted    = Color3.fromRGB(90, 95, 115),
    TextDim      = Color3.fromRGB(38, 42, 56),
    Success      = Color3.fromRGB(52, 211, 153),
    Warn         = Color3.fromRGB(251, 191, 36),
    Danger       = Color3.fromRGB(248, 100, 100),
    ToggleOff    = Color3.fromRGB(24, 26, 35),
    ToggleOn     = Color3.fromRGB(139, 92, 246),
    SliderTrack  = Color3.fromRGB(24, 26, 34),
    SliderFill   = Color3.fromRGB(139, 92, 246),
    Input        = Color3.fromRGB(16, 17, 23),
    Sidebar      = Color3.fromRGB(7, 7, 9),
    Topbar       = Color3.fromRGB(10, 10, 13),
    GridDot      = Color3.fromRGB(28, 22, 45),
    GridDotBright= Color3.fromRGB(70, 15, 30),
}

local function tw(obj, props, dur, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(dur or 0.18,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out),
        props):Play()
end

local function twSpring(obj, props, dur)
    tw(obj, props, dur or 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local _Icons = {
    ["activity"]        = "rbxassetid://94212016861936",
    ["alert-triangle"]  = "rbxassetid://125920361880643",
    ["camera"]          = "rbxassetid://79950339943067",
    ["check"]           = "rbxassetid://93898873302694",
    ["crosshair"]       = "rbxassetid://134242818164054",
    ["eye"]             = "rbxassetid://100033680381365",
    ["flame"]           = "rbxassetid://98218034436456",
    ["gamepad"]         = "rbxassetid://121607283959010",
    ["info"]            = "rbxassetid://124560466474914",
    ["layout-dashboard"]= "rbxassetid://139929981863901",
    ["list"]            = "rbxassetid://113179976918783",
    ["log-in"]          = "rbxassetid://103768533135201",
    ["minus"]           = "rbxassetid://118026365011536",
    ["monitor"]         = "rbxassetid://72664649203050",
    ["palette"]         = "rbxassetid://86350350950064",
    ["scan"]            = "rbxassetid://123104789658180",
    ["settings"]        = "rbxassetid://80758916183665",
    ["shield"]          = "rbxassetid://110987169760162",
    ["sparkles"]        = "rbxassetid://138635884129147",
    ["sword"]           = "rbxassetid://124448418211665",
    ["swords"]          = "rbxassetid://81872698913435",
    ["target"]          = "rbxassetid://87563802520297",
    ["toggle-left"]     = "rbxassetid://85887872573050",
    ["user"]            = "rbxassetid://81589895647169",
    ["wand"]            = "rbxassetid://114580617777835",
    ["wrench"]          = "rbxassetid://112148279212860",
    ["x"]               = "rbxassetid://110786993356448",
    ["zap"]             = "rbxassetid://130551565616516",
}
local _sectionIconMap = {
    combat   = "crosshair", fight = "swords", attack = "sword",
    visual   = "eye",       esp   = "scan",   camera = "camera",
    setting  = "settings",  misc  = "list",   config = "wrench",
    player   = "user",      skin  = "palette",post   = "sparkles",
    flash    = "zap",       black = "zap",    todo   = "gamepad",
}
local function getIcon(name)
    if not name then return _Icons["layout-dashboard"] end
    local id = _Icons[name:lower()]
    if id then return id end
    local low = name:lower()
    for kw, ico in pairs(_sectionIconMap) do
        if low:find(kw, 1, true) then return _Icons[ico] end
    end
    return _Icons["layout-dashboard"]
end

local function IconImg(parent, iconName, size, color, zidx)
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, size or 18, 0, size or 18)
    img.BackgroundTransparency = 1
    img.Image = getIcon(iconName)
    img.ImageColor3 = color or T.TextMuted
    img.ZIndex = zidx or 14
    img.Parent = parent
    return img
end

local function New(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Children" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Children then
        for _, child in ipairs(props.Children) do
            if child then pcall(function() child.Parent = inst end) end
        end
    end
    return inst
end

local function Corner(r)  return New("UICorner",  { CornerRadius = UDim.new(0, r or 8) }) end
local function Stroke(c, t) return New("UIStroke", { Color = c or T.Border, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) end
local function Pad(l, r, top, b)
    return New("UIPadding", {
        PaddingLeft   = UDim.new(0, l or 8),
        PaddingRight  = UDim.new(0, r ~= nil and r or (l or 8)),
        PaddingTop    = UDim.new(0, top ~= nil and top or (l or 8)),
        PaddingBottom = UDim.new(0, b ~= nil and b or (top ~= nil and top or (l or 8))),
    })
end
local function List(dir, spacing, halign, valign)
    return New("UIListLayout", {
        FillDirection       = dir or Enum.FillDirection.Vertical,
        HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = valign or Enum.VerticalAlignment.Top,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Padding             = UDim.new(0, spacing or 0),
    })
end

local function MakeDraggable(handle, mover, onDragEnd)
    local dragging = false
    local dragStart, startPos

    local function onInputBegan(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = mover.Position
        end
    end

    local function onInputMoved(input)
        if not dragging then return end
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mover.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    local function onInputEnded(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if onDragEnd then onDragEnd() end
            end
        end
    end

    handle.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputMoved)
    UserInputService.InputEnded:Connect(onInputEnded)
end


local function CreateGridPattern(parent, w, h)
    local gridContainer = New("Frame", {
        Name             = "GridPattern",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = 9,
        Parent           = parent,
    })
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,    0),
            NumberSequenceKeypoint.new(0.25, 0.1),
            NumberSequenceKeypoint.new(0.55, 0.6),
            NumberSequenceKeypoint.new(0.85, 0.92),
            NumberSequenceKeypoint.new(1,    1),
        }),
        Rotation = 135,
        Parent   = gridContainer,
    })

    local cellSize = 28
    local cols = math.ceil((w or 460) / cellSize) + 1
    local rows = math.ceil((h or 400) / cellSize) + 1

    for col = 0, cols do
        New("Frame", {
            Size             = UDim2.new(0, 1, 1, 0),
            Position         = UDim2.new(0, col * cellSize, 0, 0),
            BackgroundColor3 = T.GridDot,
            BackgroundTransparency = 0.55,
            BorderSizePixel  = 0,
            ZIndex           = 11,
            Parent           = gridContainer,
        })
    end
    for row = 0, rows do
        New("Frame", {
            Size             = UDim2.new(1, 0, 0, 1),
            Position         = UDim2.new(0, 0, 0, row * cellSize),
            BackgroundColor3 = T.GridDot,
            BackgroundTransparency = 0.55,
            BorderSizePixel  = 0,
            ZIndex           = 11,
            Parent           = gridContainer,
        })
    end

    for _ = 1, math.floor(cols * rows * 0.08) do
        local cx = math.random(0, cols) * cellSize
        local cy = math.random(0, rows) * cellSize
        local bright = New("Frame", {
            Size             = UDim2.new(0, 4, 0, 4),
            Position         = UDim2.new(0, cx - 2, 0, cy - 2),
            BackgroundColor3 = T.AccentLight,
            BackgroundTransparency = 0.3,
            BorderSizePixel  = 0,
            ZIndex           = 12,
            Parent           = gridContainer,
        })
        New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bright })
        task.spawn(function()
            task.wait(math.random() * 4)
            while bright and bright.Parent do
                tw(bright, { BackgroundTransparency = 0.8 }, 1.8 + math.random(), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1.8 + math.random())
                tw(bright, { BackgroundTransparency = 0.2 }, 1.8 + math.random(), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1.8 + math.random())
            end
        end)
    end

    return gridContainer
end

local function CreateShimmerSweep(parent, height, zidx)
    local shimmer = New("Frame", {
        Name             = "Shimmer",
        Size             = UDim2.new(0.4, 0, 0, height or 2),
        Position         = UDim2.new(-0.4, 0, 1, -(height or 2)),
        BackgroundColor3 = T.AccentLight,
        BackgroundTransparency = 0.15,
        BorderSizePixel  = 0,
        ZIndex           = zidx or 22,
        Parent           = parent,
    })
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.2),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.7, 0.2),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = shimmer,
    })

    task.spawn(function()
        while shimmer and shimmer.Parent do
            shimmer.Position = UDim2.new(-0.45, 0, 1, -(height or 2))
            tw(shimmer, { Position = UDim2.new(1.05, 0, 1, -(height or 2)) }, 2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            task.wait(5)
        end
    end)

    return shimmer
end

local function CreateGlowPulse(parent, zidx)
    local stroke = New("UIStroke", {
        Color         = T.Accent,
        Thickness     = 1.5,
        Transparency  = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent        = parent,
    })
    local glowFrame = New("ImageLabel", {
        Name             = "BorderGlow",
        Size             = UDim2.new(1, 100, 1, 100),
        Position         = UDim2.new(0, -50, 0, -50),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://5028857084",
        ImageColor3      = T.Accent,
        ImageTransparency = 0.82,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(24, 24, 276, 276),
        ZIndex           = (zidx or 9),
        Parent           = parent,
    })
    task.spawn(function()
        while stroke and stroke.Parent do
            tw(stroke, { Transparency = 0.2, Thickness = 2, Color = T.AccentLight }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tw(glowFrame, { ImageTransparency = 0.7 }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
            tw(stroke, { Transparency = 0.6, Thickness = 1, Color = T.AccentDark }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tw(glowFrame, { ImageTransparency = 0.9 }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)
    return stroke, glowFrame
end

local function CreateFloatingParticles(parent, count, zidx)
    local container = New("Frame", {
        Name             = "Particles",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = zidx or 11,
        Parent           = parent,
    })
    for i = 1, (count or 8) do
        local sz = math.random(3, 7)
        local startX = math.random(5, 95) / 100
        local startY = math.random(20, 90) / 100
        local p = New("Frame", {
            Size             = UDim2.new(0, sz, 0, sz),
            Position         = UDim2.new(startX, 0, startY, 0),
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 0.35,
            BorderSizePixel  = 0,
            ZIndex           = zidx or 11,
            Parent           = container,
        })
        New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = p })
        task.spawn(function()
            task.wait(math.random() * 3)
            while p and p.Parent do
                local dur = 4 + math.random() * 4
                local dx  = (math.random() - 0.5) * 0.2
                local dy  = -math.random(15, 40) / 100
                local nx  = math.clamp(startX + dx, 0.02, 0.98)
                local ny  = math.clamp(startY + dy, 0.05, 0.95)
                tw(p, { Position = UDim2.new(nx, 0, ny, 0), BackgroundTransparency = 0.15, Size = UDim2.new(0, sz + 2, 0, sz + 2) }, dur / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(dur / 2)
                tw(p, { Position = UDim2.new(startX, 0, startY, 0), BackgroundTransparency = 0.6, Size = UDim2.new(0, sz, 0, sz) }, dur / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(dur / 2)
            end
        end)
    end
    return container
end

local function CreateAccentTopLine(parent, zidx)
    local line = New("Frame", {
        Name             = "AccentLine",
        Size             = UDim2.new(0.6, 0, 0, 3),
        Position         = UDim2.new(0.2, 0, 0, 0),
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0,
        BorderSizePixel  = 0,
        ZIndex           = zidx or 25,
        Parent           = parent,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 2), Parent = line })
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0),
            NumberSequenceKeypoint.new(0.85, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = line,
    })
    task.spawn(function()
        while line and line.Parent do
            tw(line, { Size = UDim2.new(0.7, 0, 0, 3), Position = UDim2.new(0.15, 0, 0, 0), BackgroundTransparency = 0 }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
            tw(line, { Size = UDim2.new(0.45, 0, 0, 3), Position = UDim2.new(0.275, 0, 0, 0), BackgroundTransparency = 0.15 }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)
    return line
end

local Root = New("ScreenGui", {
    Name            = "SiltUI",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset  = true,
    DisplayOrder    = 999,
    Parent          = (pcall(function() return gethui() end) and gethui and gethui())
                      or game:GetService("CoreGui"),
})

local NotifContainer = New("Frame", {
    Name                = "Notifs",
    Size                = UDim2.new(0, 290, 1, -20),
    Position            = UDim2.new(1, -300, 0, 10),
    BackgroundTransparency = 1,
    ZIndex              = 500,
    Parent              = Root,
})
local notifLayout = List(Enum.FillDirection.Vertical, 6)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Parent = NotifContainer

local ICONS = {
    info            = "ℹ",
    ["alert-triangle"] = "⚠",
    ["log-in"]      = "⇢",
    trash           = "✕",
    flame           = "◈",
    crosshair       = "◎",
    check           = "✓",
    warning         = "⚠",
    star            = "★",
}

local function Notify(cfg)
    cfg = cfg or {}
    local dur    = cfg.Duration or 4
    local iconName = cfg.Icon or "info"
    local isErr  = cfg.Icon == "alert-triangle"
    local accCol = isErr and T.Warn or T.Accent

    local card = New("Frame", {
        Size                   = UDim2.new(1, 0, 0, 70),
        BackgroundColor3       = T.Card,
        BackgroundTransparency = 0,
        ClipsDescendants       = true,
        ZIndex                 = 501,
        Parent                 = NotifContainer,
        Children               = { Corner(2), Stroke(T.Border, 1) }
    })
    local notifGrad = New("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundColor3       = accCol,
        BackgroundTransparency = 0.92,
        BorderSizePixel        = 0,
        ZIndex                 = 501,
        Parent                 = card,
        Children               = { Corner(2) }
    })
    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1,   Color3.new(0, 0, 0)),
        }),
        Rotation = 0,
        Parent = notifGrad,
    })
    New("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accCol,
        BorderSizePixel  = 0,
        ZIndex           = 502,
        Parent           = card,
        Children         = { Corner(2) }
    })
    local pBar = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accCol,
        BorderSizePixel  = 0,
        ZIndex           = 502,
        Parent           = card,
        Children         = { Corner(1) }
    })
    New("ImageLabel", {
        Size                 = UDim2.new(0, 18, 0, 18),
        Position             = UDim2.new(0, 14, 0.5, -9),
        BackgroundTransparency = 1,
        Image                = getIcon(iconName),
        ImageColor3          = accCol,
        ZIndex               = 503,
        Parent               = card,
    })
    New("TextLabel", {
        Size                 = UDim2.new(1, -56, 0, 22),
        Position             = UDim2.new(0, 46, 0, 13),
        BackgroundTransparency = 1,
        Text                 = cfg.Title or "",
        TextColor3           = T.Text,
        TextSize             = 13,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 503,
        Parent               = card,
    })
    New("TextLabel", {
        Size                 = UDim2.new(1, -56, 0, 26),
        Position             = UDim2.new(0, 46, 0, 35),
        BackgroundTransparency = 1,
        Text                 = cfg.Desc or "",
        TextColor3           = T.TextMuted,
        TextSize             = 11,
        Font                 = Enum.Font.Gotham,
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextWrapped          = true,
        ZIndex               = 503,
        Parent               = card,
    })

    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundTransparency = 1
    twSpring(card, { Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 0 }, 0.3)

    tw(pBar, { Size = UDim2.new(0, 0, 0, 2) }, dur, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        tw(card, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.22)
        task.delay(0.25, function() pcall(function() card:Destroy() end) end)
    end)
end

SiltUI.Notify = Notify

function SiltUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title   = cfg.Title  or "SiltUI"
    local isMobi  = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local vp = workspace.CurrentCamera.ViewportSize
    local W  = math.min(460, vp.X - 32)
    local H  = isMobi and math.min(560, vp.Y - 60) or math.min(400, vp.Y - 80)
    local winX = isMobi and UDim2.new(0, 4, 0, 56) or UDim2.new(0.5, -W/2, 0.5, -H/2)

    local Win = New("Frame", {
        Name             = "SiltWindow",
        Size             = UDim2.new(0, W, 0, H),
        Position         = winX,
        BackgroundColor3 = T.Bg,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 10,
        Parent           = Root,
        Children         = { Stroke(T.Border, 1) }
    })

    local TopH = 32
    local Topbar = New("Frame", {
        Name             = "Topbar",
        Size             = UDim2.new(1, 0, 0, TopH),
        BackgroundColor3 = T.Bg,
        BorderSizePixel  = 0,
        ZIndex           = 20,
        Parent           = Win,
    })
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 21,
        Parent           = Topbar,
    })
    MakeDraggable(Topbar, Win)

    local minBtn

    local titleLabel = New("TextLabel", {
        Size                 = UDim2.new(1, -24, 1, 0),
        Position             = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text                 = title,
        TextColor3           = T.Text,
        TextSize             = 12,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 22,
        Parent               = Topbar,
    })

    local SideW = 90
    local Body  = New("Frame", {
        Size                 = UDim2.new(1, 0, 1, -TopH),
        Position             = UDim2.new(0, 0, 0, TopH),
        BackgroundTransparency = 1,
        ClipsDescendants     = true,
        ZIndex               = 10,
        Parent               = Win,
    })

    local SidebarWrap = New("Frame", {
        Name                 = "Sidebar",
        Size                 = UDim2.new(0, SideW, 1, 0),
        BackgroundColor3     = T.Sidebar,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        ZIndex               = 14,
        Parent               = Body,
    })
    local sideBorder = New("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel  = 0,
        ZIndex           = 16,
        Parent           = SidebarWrap,
    })
    local Sidebar = New("ScrollingFrame", {
        Size                   = UDim2.new(1, -1, 1, -52),
        BackgroundTransparency = 1,
        ScrollBarThickness     = 0,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        ScrollingDirection     = Enum.ScrollingDirection.Y,
        ZIndex                 = 15,
        Parent                 = SidebarWrap,
    })

    -- Avatar + username at bottom of sidebar
    local userFrame = New("Frame", {
        Size             = UDim2.new(1, -1, 0, 48),
        Position         = UDim2.new(0, 0, 1, -48),
        BackgroundColor3 = T.Sidebar,
        BorderSizePixel  = 0,
        ZIndex           = 15,
        Parent           = SidebarWrap,
    })
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = T.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel  = 0,
        ZIndex           = 16,
        Parent           = userFrame,
    })
    local avatarImg = New("ImageLabel", {
        Size                 = UDim2.new(0, 28, 0, 28),
        Position             = UDim2.new(0, 8, 0.5, -14),
        BackgroundColor3     = T.Card,
        BackgroundTransparency = 0,
        Image                = "",
        ZIndex               = 16,
        Parent               = userFrame,
        Children             = { Corner(2) }
    })
    New("TextLabel", {
        Size                 = UDim2.new(1, -46, 0, 14),
        Position             = UDim2.new(0, 42, 0.5, -7),
        BackgroundTransparency = 1,
        Text                 = LocalPlayer.Name,
        TextColor3           = T.Text,
        TextSize             = 11,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextTruncate         = Enum.TextTruncate.AtEnd,
        ZIndex               = 16,
        Parent               = userFrame,
    })
    -- load avatar thumbnail async
    task.spawn(function()
        local ok, result = pcall(function()
            return game:GetService("Players"):GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size48x48
            )
        end)
        if ok and result then
            avatarImg.Image = result
        end
    end)
    New("UIListLayout", {
        FillDirection       = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment   = Enum.VerticalAlignment.Top,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Padding             = UDim.new(0, 0),
        Parent              = Sidebar,
    })
    New("UIPadding", {
        PaddingTop    = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft   = UDim.new(0, 0),
        PaddingRight  = UDim.new(0, 0),
        Parent        = Sidebar,
    })

    local ContentPane = New("Frame", {
        Size                 = UDim2.new(1, -SideW - 1, 1, 0),
        Position             = UDim2.new(0, SideW + 1, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants     = true,
        ZIndex               = 14,
        Parent               = Body,
    })

    local TabStrip = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = T.Bg,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 16,
        Parent           = ContentPane,
    })
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 17,
        Parent           = TabStrip,
    })
    local TabStripScroll = New("ScrollingFrame", {
        Size                = UDim2.new(1, -16, 1, 0),
        Position            = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness  = 0,
        CanvasSize          = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ZIndex              = 17,
        Parent              = TabStrip,
    })
    List(Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center).Parent = TabStripScroll
    Pad(0, 0, 5, 5).Parent = TabStripScroll

    local TabScroll = New("ScrollingFrame", {
        Size                = UDim2.new(1, -12, 1, -30),
        Position            = UDim2.new(0, 6, 0, 30),
        BackgroundTransparency = 1,
        ScrollBarThickness  = 2,
        ScrollBarImageColor3 = T.AccentSoft,
        ScrollBarImageTransparency = 0.4,
        CanvasSize          = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection  = Enum.ScrollingDirection.Y,
        ZIndex              = 15,
        Parent              = ContentPane,
    })
    Pad(4, 8, 8, 16).Parent = TabScroll

    local WindowObj      = {}
    local _sections      = {}
    local _allTabs       = {}
    local _flagElems     = {}
    local _tabBtns       = {}
    local _activeSec     = nil
    local _activeTab     = nil

    local function ActivateTab(tab)
        if _activeTab == tab then return end
        _activeTab = tab

        for _, t in ipairs(_allTabs) do
            if t._frame then t._frame.Visible = (t == tab) end
        end
        for _, rec in ipairs(_tabBtns) do
            if rec.tab == tab then
                tw(rec.lb, { TextColor3 = T.Text }, 0.15)
                if rec.glow then tw(rec.glow, { BackgroundTransparency = 0 }, 0.15) end
            else
                tw(rec.lb, { TextColor3 = T.TextMuted }, 0.15)
                if rec.glow then tw(rec.glow, { BackgroundTransparency = 1 }, 0.15) end
            end
        end
        TabScroll.CanvasPosition = Vector2.zero
    end

    local function ActivateSection(sec)
        if _activeSec == sec then return end
        _activeSec = sec

        for _, s in ipairs(_sections) do
            if s._btnBg then
                if s == sec then
                    tw(s._btnBg, { BackgroundColor3 = T.Sidebar, BackgroundTransparency = 0 }, 0.18)
                    if s._textLb then tw(s._textLb, { TextColor3 = T.AccentLight }, 0.18) end
                    if s._indicator then tw(s._indicator, { BackgroundTransparency = 0 }, 0.22) end
                else
                    tw(s._btnBg, { BackgroundColor3 = T.Sidebar, BackgroundTransparency = 0 }, 0.18)
                    if s._textLb then tw(s._textLb, { TextColor3 = T.TextMuted }, 0.18) end
                    if s._indicator then tw(s._indicator, { BackgroundTransparency = 1 }, 0.18) end
                end
            end
        end

        for _, child in ipairs(TabStripScroll:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        _tabBtns = {}

        for i, tab in ipairs(sec._tabs) do
            local first = (i == 1)
            local bg = New("Frame", {
                Size                 = UDim2.new(0, 0, 1, 0),
                AutomaticSize        = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                ZIndex               = 16,
                Parent               = TabStripScroll,
            })
            local lb = New("TextLabel", {
                Size                 = UDim2.new(0, 0, 1, 0),
                AutomaticSize        = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text                 = tab._title,
                TextColor3           = first and T.Text or T.TextMuted,
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                ZIndex               = 17,
                Parent               = bg,
            })
            Pad(10, 10, 0, 0).Parent = lb

            local tabGlow = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 2),
                Position         = UDim2.new(0, 0, 1, -2),
                BackgroundColor3 = T.Accent,
                BackgroundTransparency = first and 0 or 1,
                BorderSizePixel  = 0,
                ZIndex           = 17,
                Parent           = bg,
            })

            table.insert(_tabBtns, { tab = tab, bg = bg, lb = lb, glow = tabGlow })

            local hitbox = New("TextButton", {
                Size                 = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                 = "",
                ZIndex               = 18,
                Parent               = bg,
            })
            hitbox.MouseButton1Click:Connect(function() ActivateTab(tab) end)
        end

        if #sec._tabs > 0 then ActivateTab(sec._tabs[1]) end
    end

    function WindowObj:Section(sCfg)
        sCfg = sCfg or {}
        local secTitle = sCfg.Title or "Section"
        local secIcon  = sCfg.Icon  or secTitle

        local sec   = { _title = secTitle, _tabs = {} }

        local btnBg = New("Frame", {
            Size                 = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ZIndex               = 13,
            Parent               = Sidebar,
        })
        local indicatorBar = New("Frame", {
            Size             = UDim2.new(0, 2, 1, 0),
            Position         = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ZIndex           = 14,
            Parent           = btnBg,
        })
        local iconImg = New("Frame", {
            Size                 = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ZIndex               = 14,
            Parent               = btnBg,
        })
        New("TextLabel", {
            Size                 = UDim2.new(1, -16, 1, 0),
            Position             = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text                 = secTitle:upper(),
            TextColor3           = T.TextMuted,
            TextSize             = 10,
            Font                 = Enum.Font.GothamMedium,
            TextXAlignment       = Enum.TextXAlignment.Left,
            TextTruncate         = Enum.TextTruncate.AtEnd,
            ZIndex               = 14,
            Parent               = btnBg,
        })
        New("TextButton", {
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                 = "",
            ZIndex               = 15,
            Parent               = btnBg,
        }).MouseButton1Click:Connect(function()
            ActivateSection(sec)
        end)

        sec._btnBg  = btnBg
        sec._btnLb  = iconImg
        sec._iconImg = iconImg
        sec._textLb  = btnBg:FindFirstChildOfClass("TextLabel")
        sec._indicator = indicatorBar
        table.insert(_sections, sec)

        if #_sections == 1 then
            task.defer(function() ActivateSection(sec) end)
        end

        function sec:Tab(tCfg)
            tCfg = tCfg or {}
            local tabTitle = tCfg.Title or "Tab"

            local tab = { _title = tabTitle }

            local tabFrame = New("Frame", {
                Name                 = "Tab_" .. tabTitle,
                Size                 = UDim2.new(1, 0, 0, 0),
                AutomaticSize        = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Visible              = false,
                ZIndex               = 13,
                Parent               = TabScroll,
            })
            List(Enum.FillDirection.Vertical, 1).Parent = tabFrame

            tab._frame = tabFrame
            table.insert(sec._tabs, tab)
            table.insert(_allTabs, tab)


            local function RegFlag(flag, elem)
                if flag and flag ~= "" then _flagElems[flag] = elem end
            end

            local function BaseCard(h, parent)
                local card = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, h or 38),
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ZIndex           = 14,
                    Parent           = parent or tabFrame,
                })
                return card
            end

            function tab:Section(hCfg)
                hCfg = hCfg or {}
                local wrap = New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    ZIndex               = 14,
                    Parent               = tabFrame,
                })
                New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 14),
                    Position             = UDim2.new(0, 0, 0, 4),
                    BackgroundTransparency = 1,
                    Text                 = (hCfg.Title or ""):upper(),
                    TextColor3           = T.Accent,
                    TextSize             = 9,
                    Font                 = Enum.Font.GothamBold,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    LetterSpacing        = 1,
                    ZIndex               = 15,
                    Parent               = wrap,
                })
                New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel  = 0,
                    ZIndex           = 15,
                    Parent           = wrap,
                })
            end

            function tab:Space()
                New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 3),
                    BackgroundTransparency = 1,
                    ZIndex               = 14,
                    Parent               = tabFrame,
                })
            end

            function tab:Toggle(cfg2)
                cfg2 = cfg2 or {}
                local val     = cfg2.Value ~= nil and cfg2.Value or false
                local cb      = cfg2.Callback
                local hasDesc = cfg2.Desc and cfg2.Desc ~= ""
                local cardH   = hasDesc and 42 or 30

                local card = BaseCard(cardH)
                Pad(14, 14, 0, 0).Parent = card

                local txtWrap = New("Frame", {
                    Size                 = UDim2.new(1, -56, 1, 0),
                    BackgroundTransparency = 1,
                    ZIndex               = 15,
                    Parent               = card,
                })
                New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    Position             = UDim2.new(0, 0, 0.5, hasDesc and -12 or -8),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.Text,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 15,
                    Parent               = txtWrap,
                })
                if hasDesc then
                    New("TextLabel", {
                        Size                 = UDim2.new(1, 0, 0, 13),
                        Position             = UDim2.new(0, 0, 0.5, 6),
                        BackgroundTransparency = 1,
                        Text                 = cfg2.Desc,
                        TextColor3           = T.TextMuted,
                        TextSize             = 11,
                        Font                 = Enum.Font.Gotham,
                        TextXAlignment       = Enum.TextXAlignment.Left,
                        TextTruncate         = Enum.TextTruncate.AtEnd,
                        ZIndex               = 15,
                        Parent               = txtWrap,
                    })
                end

                local pill = New("Frame", {
                    Size             = UDim2.new(0, 16, 0, 16),
                    Position         = UDim2.new(1, -16, 0.5, -8),
                    BackgroundColor3 = val and T.ToggleOn or T.ToggleOff,
                    BorderSizePixel  = 0,
                    ZIndex           = 15,
                    Parent           = card,
                    Children         = { Corner(2), Stroke(val and T.Accent or T.Border, 1) }
                })
                local pillGlow = New("Frame", {
                    Size             = UDim2.new(0, 16, 0, 16),
                    Position         = UDim2.new(1, -16, 0.5, -8),
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ZIndex           = 14,
                    Parent           = card,
                })
                local knob = New("Frame", {
                    Size             = UDim2.new(0, 8, 0, 8),
                    Position         = UDim2.new(0.5, -4, 0.5, -4),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = val and 0 or 1,
                    BorderSizePixel  = 0,
                    ZIndex           = 16,
                    Parent           = pill,
                    Children         = { Corner(1) }
                })

                local elem = { _val = val }
                local function apply(v, fromConfig)
                    elem._val = v
                    tw(pill, { BackgroundColor3 = v and T.ToggleOn or T.ToggleOff }, 0.15)
                    tw(knob, { BackgroundTransparency = v and 0 or 1 }, 0.15)
                    local s = pill:FindFirstChildOfClass("UIStroke")
                    if s then tw(s, { Color = v and T.Accent or T.Border }, 0.15) end
                    if cb then pcall(cb, v) end
                end

                function elem:Set(v) apply(v ~= nil and v or false, true) end

                local hit = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 17,
                    Parent               = card,
                })
                hit.MouseButton1Click:Connect(function() apply(not elem._val, false) end)
                hit.MouseEnter:Connect(function() tw(card, { BackgroundTransparency = 0.85 }, 0.15) end)
                hit.MouseLeave:Connect(function() tw(card, { BackgroundTransparency = 1 }, 0.15) end)

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Slider(cfg2)
                cfg2 = cfg2 or {}
                local vCfg   = cfg2.Value or {}
                local mn     = vCfg.Min     or 0
                local mx     = vCfg.Max     or 100
                local step   = cfg2.Step    or 1
                local cb     = cfg2.Callback
                local cur

                local function snap(v)
                    return math.floor((v - mn) / step + 0.5) * step + mn
                end
                cur = snap(math.clamp(vCfg.Default or mn, mn, mx))

                local card = BaseCard(46)
                Pad(14, 14, 8, 10).Parent = card

                local titleRow = New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    ZIndex               = 15,
                    Parent               = card,
                })
                New("TextLabel", {
                    Size                 = UDim2.new(1, -55, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.Text,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 15,
                    Parent               = titleRow,
                })
                local valLbl = New("TextLabel", {
                    Size                 = UDim2.new(0, 55, 1, 0),
                    Position             = UDim2.new(1, -55, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = tostring(cur),
                    TextColor3           = T.AccentLight,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Right,
                    ZIndex               = 15,
                    Parent               = titleRow,
                })

                local track = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 2),
                    Position         = UDim2.new(0, 0, 1, -2),
                    BackgroundColor3 = T.SliderTrack,
                    BorderSizePixel  = 0,
                    ZIndex           = 15,
                    Parent           = card,
                    Children         = { Corner(3) }
                })
                local pct0 = (cur - mn) / (mx - mn)
                local fill = New("Frame", {
                    Size             = UDim2.new(pct0, 0, 1, 0),
                    BackgroundColor3 = T.SliderFill,
                    BorderSizePixel  = 0,
                    ZIndex           = 16,
                    Parent           = track,
                    Children         = { Corner(3) }
                })
                local thumb = New("Frame", {
                    Size             = UDim2.new(0, 10, 0, 10),
                    Position         = UDim2.new(pct0, -5, 0.5, -5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel  = 0,
                    ZIndex           = 17,
                    Parent           = track,
                    Children         = { Corner(5) }
                })
                local thumbGlow = New("Frame", {
                    Size             = UDim2.new(0, 10, 0, 10),
                    Position         = UDim2.new(pct0, -5, 0.5, -5),
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ZIndex           = 16,
                    Parent           = track,
                })

                local elem = { _val = cur }
                local function setVal(v, fromCfg)
                    v = snap(math.clamp(v, mn, mx))
                    elem._val = v
                    cur = v
                    local p = (v - mn) / (mx - mn)
                    tw(fill,  { Size     = UDim2.new(p, 0, 1, 0)       }, 0.07)
                    tw(thumb, { Position = UDim2.new(p, -5, 0.5, -5)   }, 0.07)
                    tw(thumbGlow, { Position = UDim2.new(p, -5, 0.5, -5) }, 0.07)
                    valLbl.Text = tostring(v)
                    if cb then pcall(cb, v) end
                end
                function elem:Set(v) setVal(tonumber(v) or cur, true) end

                local dragging = false
                local function posToVal(inputPos)
                    local rx = math.clamp((inputPos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    return mn + rx * (mx - mn)
                end
                local hitbox = New("TextButton", {
                    Size                 = UDim2.new(1, 8, 2, 12),
                    Position             = UDim2.new(0, -4, 0, -6),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 18,
                    Parent               = track,
                })
                hitbox.InputBegan:Connect(function(inp)
                    local t = inp.UserInputType
                    if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
                        dragging = true; setVal(posToVal(inp.Position))
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if not dragging then return end
                    local t = inp.UserInputType
                    if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
                        setVal(posToVal(inp.Position))
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    local t = inp.UserInputType
                    if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Button(cfg2)
                cfg2 = cfg2 or {}
                local cb    = cfg2.Callback
                local color = cfg2.Color or T.Accent

                local card = BaseCard(32)

                local inner = New("Frame", {
                    Size                 = UDim2.new(1, 0, 1, -4),
                    Position             = UDim2.new(0, 0, 0, 2),
                    BackgroundColor3     = color,
                    BackgroundTransparency = 0.7,
                    BorderSizePixel      = 0,
                    ZIndex               = 15,
                    Parent               = card,
                    Children             = { Corner(2) }
                })
                New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "Button",
                    TextColor3           = T.Text,
                    TextSize             = 13,
                    Font                 = Enum.Font.GothamBold,
                    TextXAlignment       = cfg2.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Center,
                    ZIndex               = 16,
                    Parent               = inner,
                })
                local hit = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 17,
                    Parent               = inner,
                })
                hit.MouseButton1Click:Connect(function()
                    tw(inner, { BackgroundTransparency = 0.5 }, 0.07)
                    task.delay(0.14, function() tw(inner, { BackgroundTransparency = 0.15 }, 0.15) end)
                    if cb then pcall(cb) end
                end)
                hit.MouseEnter:Connect(function() tw(inner, { BackgroundTransparency = 0    }, 0.12) end)
                hit.MouseLeave:Connect(function() tw(inner, { BackgroundTransparency = 0.15 }, 0.12) end)

                return {}
            end

            function tab:Dropdown(cfg2)
                cfg2 = cfg2 or {}
                local vals  = cfg2.Values or {}
                local cur   = cfg2.Value or (vals[1] or "")
                local cb    = cfg2.Callback
                local open  = false

                local card = New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 44),
                    BackgroundTransparency = 1,
                    BorderSizePixel      = 0,
                    ClipsDescendants     = false,
                    ZIndex               = 20,
                    Parent               = tabFrame,
                })
                Pad(14, 14, 6, 6).Parent = card

                New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.TextMuted,
                    TextSize             = 11,
                    Font                 = Enum.Font.Gotham,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 21,
                    Parent               = card,
                })
                local selRow = New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 22),
                    Position             = UDim2.new(0, 0, 1, -22),
                    BackgroundTransparency = 1,
                    ZIndex               = 21,
                    Parent               = card,
                })
                local selLbl = New("TextLabel", {
                    Size                 = UDim2.new(1, -22, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cur,
                    TextColor3           = T.AccentLight,
                    TextSize             = 13,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 21,
                    Parent               = selRow,
                })
                local chevron = New("TextLabel", {
                    Size                 = UDim2.new(0, 22, 1, 0),
                    Position             = UDim2.new(1, -22, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = "⌄",
                    TextColor3           = T.TextMuted,
                    TextSize             = 13,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Center,
                    ZIndex               = 21,
                    Parent               = selRow,
                })

                local panel = New("ScrollingFrame", {
                    Size                       = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3           = T.Card,
                    BorderSizePixel            = 0,
                    ClipsDescendants           = true,
                    ZIndex                     = 100,
                    Visible                    = false,
                    ScrollingDirection         = Enum.ScrollingDirection.Y,
                    AutomaticCanvasSize        = Enum.AutomaticSize.Y,
                    CanvasSize                 = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness         = 3,
                    ScrollBarImageColor3       = T.AccentSoft,
                    ScrollBarImageTransparency = 0.3,
                    ElasticBehavior            = Enum.ElasticBehavior.Never,
                    Parent                     = Root,
                    Children                   = { Corner(3), Stroke(T.BorderLight, 1) }
                })
                local panelList = List(Enum.FillDirection.Vertical, 0)
                panelList.Parent = panel

                local elem = { _val = cur }

                local function rebuildPanel(v2)
                    for _, c in ipairs(panel:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for i, opt in ipairs(v2) do
                        local isSel = opt == cur
                        local row2 = New("TextButton", {
                            Size                 = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3     = isSel and T.AccentDark or T.Card,
                            BackgroundTransparency = isSel and 0.5 or 0.95,
                            Text                 = opt,
                            TextColor3           = isSel and T.AccentLight or T.Text,
                            TextSize             = 12,
                            Font                 = Enum.Font.GothamMedium,
                            TextXAlignment       = Enum.TextXAlignment.Left,
                            ZIndex               = 101,
                            Parent               = panel,
                            Children             = { Pad(12, 4, 0, 0) }
                        })
                        if i == #v2 then
                            New("UICorner", {CornerRadius=UDim.new(0,2)}).Parent = row2
                        end
                        row2.MouseButton1Click:Connect(function()
                            cur = opt; elem._val = opt
                            selLbl.Text = opt
                            open = false
                            local s2 = panel:FindFirstChildOfClass("UIStroke")
                            if s2 then tw(s2, { Transparency = 1 }, 0.18) end
                            tw(panel, { Size = UDim2.new(0, panel.Size.X.Offset, 0, 0) }, 0.18)
                            task.delay(0.2, function()
                                panel.Visible = false
                                if s2 then s2.Transparency = 0 end
                            end)
                            tw(chevron, { Rotation = 0 }, 0.18)
                            rebuildPanel(vals)
                            if cb then pcall(cb, opt) end
                        end)
                        row2.MouseEnter:Connect(function()
                            if opt ~= cur then tw(row2, {BackgroundTransparency=0.6}, 0.1) end
                        end)
                        row2.MouseLeave:Connect(function()
                            if opt ~= cur then tw(row2, {BackgroundTransparency=0.9}, 0.1) end
                        end)
                    end
                end

                rebuildPanel(vals)

                local hit = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 22,
                    Parent               = card,
                })
                hit.MouseButton1Click:Connect(function()
                    open = not open
                    local optH = math.min(#vals * 28, 120)
                    if open then
                        local absPos  = card.AbsolutePosition
                        local absSize = card.AbsoluteSize
                        panel.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
                        panel.Size     = UDim2.new(0, absSize.X, 0, 0)
                        panel.Visible  = true
                        twSpring(panel, { Size = UDim2.new(0, absSize.X, 0, optH) }, 0.22)
                        tw(chevron, { Rotation = 180 }, 0.18)
                    else
                        local s = panel:FindFirstChildOfClass("UIStroke")
                        if s then tw(s, { Transparency = 1 }, 0.18) end
                        tw(panel, { Size = UDim2.new(0, panel.Size.X.Offset, 0, 0) }, 0.18)
                        task.delay(0.2, function()
                            panel.Visible = false
                            if s then s.Transparency = 0 end
                        end)
                        tw(chevron, { Rotation = 0 }, 0.18)
                    end
                end)

                function elem:Set(v)
                    cur = tostring(v or ""); elem._val = cur
                    selLbl.Text = cur
                    rebuildPanel(vals)
                    if cb then pcall(cb, cur) end
                end
                function elem:Refresh(newVals)
                    vals = newVals or {}
                    rebuildPanel(vals)
                end

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Input(cfg2)
                cfg2 = cfg2 or {}
                local cb  = cfg2.Callback

                local card = BaseCard(52)
                Pad(14, 14, 8, 8).Parent = card

                New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.TextMuted,
                    TextSize             = 11,
                    Font                 = Enum.Font.Gotham,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 15,
                    Parent               = card,
                })
                local inputWrap = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 30),
                    Position         = UDim2.new(0, 0, 1, -30),
                    BackgroundColor3 = T.Input,
                    BorderSizePixel  = 0,
                    ZIndex           = 15,
                    Parent           = card,
                    Children         = { Corner(3), Stroke(T.Border, 1) }
                })
                local tb = New("TextBox", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Value or "",
                    PlaceholderText      = cfg2.Placeholder or cfg2.Desc or "Enter value...",
                    TextColor3           = T.Text,
                    PlaceholderColor3    = T.TextDim,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ClearTextOnFocus     = false,
                    ZIndex               = 16,
                    Parent               = inputWrap,
                })
                Pad(10, 10, 0, 0).Parent = tb

                tb.Focused:Connect(function()
                    tw(inputWrap, { BackgroundColor3 = Color3.fromRGB(22, 23, 30) }, 0.15)
                    Stroke(T.Accent, 1).Parent = inputWrap
                end)
                tb.FocusLost:Connect(function(enter)
                    tw(inputWrap, { BackgroundColor3 = T.Input }, 0.15)
                    local s = inputWrap:FindFirstChildOfClass("UIStroke")
                    if s then s:Destroy() end
                    Stroke(T.Border, 1).Parent = inputWrap
                    if enter and cb then pcall(cb, tb.Text) end
                end)

                local elem = { _val = "" }
                function elem:Set(v)
                    tb.Text = tostring(v or "")
                    elem._val = tb.Text
                    if cb then pcall(cb, tb.Text) end
                end

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Keybind(cfg2)
                cfg2 = cfg2 or {}
                local cb      = cfg2.Callback
                local cur     = tostring(cfg2.Value or "None")
                local waiting = false
                local conn

                local card = BaseCard(30)
                Pad(14, 14, 0, 0).Parent = card

                New("TextLabel", {
                    Size                 = UDim2.new(1, -88, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.Text,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 15,
                    Parent               = card,
                })
                local bindWrap = New("Frame", {
                    Size             = UDim2.new(0, 78, 0, 26),
                    Position         = UDim2.new(1, -78, 0.5, -13),
                    BackgroundColor3 = T.Input,
                    BorderSizePixel  = 0,
                    ZIndex           = 15,
                    Parent           = card,
                    Children         = { Corner(3), Stroke(T.Border, 1) }
                })
                local bindLbl = New("TextLabel", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cur,
                    TextColor3           = T.AccentLight,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Center,
                    ZIndex               = 16,
                    Parent               = bindWrap,
                })
                local bindBtn = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 17,
                    Parent               = bindWrap,
                })

                local elem -- forward declare so capture closure can write _val

                bindBtn.MouseButton1Click:Connect(function()
                    if waiting then return end
                    waiting = true
                    bindLbl.Text       = "..."
                    bindLbl.TextColor3 = T.Warn
                    tw(bindWrap, { BackgroundColor3 = Color3.fromRGB(34, 32, 10) }, 0.12)

                    task.defer(function()
                        conn = UserInputService.InputBegan:Connect(function(inp)
                            local name
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                if inp.KeyCode ~= Enum.KeyCode.Unknown then
                                    name = inp.KeyCode.Name
                                end
                            elseif inp.UserInputType == Enum.UserInputType.MouseButton2 then
                                name = "MouseButton2"
                            elseif inp.UserInputType == Enum.UserInputType.MouseButton3 then
                                name = "MouseButton3"
                            end
                            if name then
                                cur = name
                                if elem then elem._val = name end
                                bindLbl.Text = name
                                bindLbl.TextColor3 = T.AccentLight
                                tw(bindWrap, { BackgroundColor3 = T.Input }, 0.15)
                                waiting = false
                                conn:Disconnect()
                                if cb then pcall(cb, name) end
                            end
                        end)
                    end)
                end)

                elem = { _val = cur }
                function elem:Set(v)
                    cur = tostring(v or "None"); elem._val = cur
                    bindLbl.Text = cur
                    if cb then pcall(cb, cur) end
                end

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Colorpicker(cfg2)
                cfg2 = cfg2 or {}
                local cb     = cfg2.Callback
                local cur    = cfg2.Default or Color3.fromRGB(255,255,255)
                local h, s, v = Color3.toHSV(cur)
                local open   = false

                local card = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ClipsDescendants = false,
                    ZIndex           = 18,
                    Parent           = tabFrame,
                })
                Pad(14, 14, 0, 0).Parent = card

                New("TextLabel", {
                    Size                 = UDim2.new(1, -54, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = cfg2.Title or "",
                    TextColor3           = T.Text,
                    TextSize             = 12,
                    Font                 = Enum.Font.GothamMedium,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 19,
                    Parent               = card,
                })
                local swatch = New("Frame", {
                    Size             = UDim2.new(0, 28, 0, 16),
                    Position         = UDim2.new(1, -28, 0.5, -8),
                    BackgroundColor3 = cur,
                    BorderSizePixel  = 0,
                    ZIndex           = 19,
                    Parent           = card,
                    Children         = { Corner(3), Stroke(T.Border, 1) }
                })

                -- popup parented to Root so it floats above everything
                local popup = New("Frame", {
                    Size             = UDim2.new(0, 0, 0, 0),
                    Position         = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = T.Surface,
                    BorderSizePixel  = 0,
                    ClipsDescendants = true,
                    ZIndex           = 200,
                    Visible          = false,
                    Parent           = Root,
                    Children         = { Corner(2), Stroke(T.BorderLight, 1) }
                })
                Pad(10, 10, 10, 10).Parent = popup

                local elem
                local popW = 160
                local popH = 148

                local function closePopup()
                    if not open then return end
                    open = false
                    tw(popup, { Size = UDim2.new(0, popW, 0, 0) }, 0.15)
                    task.delay(0.17, function() popup.Visible = false end)
                end

                local function updateColor()
                    cur = Color3.fromHSV(h, s, v)
                    swatch.BackgroundColor3 = cur
                    if elem then elem._val = cur end
                    if cb then pcall(cb, cur) end
                end

                -- SV square: hue background
                local svSquare = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 100),
                    Position         = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel  = 0,
                    ZIndex           = 201,
                    Parent           = popup,
                    Children         = { Corner(2) }
                })
                -- white overlay: left=opaque white, right=transparent (shows hue)
                local svWhite = New("Frame", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel  = 0,
                    ZIndex           = 202,
                    Parent           = svSquare,
                    Children         = { Corner(2) }
                })
                New("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                    Parent = svWhite,
                })
                -- black overlay: top=transparent, bottom=opaque black
                local svDark = New("Frame", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BorderSizePixel  = 0,
                    ZIndex           = 203,
                    Parent           = svSquare,
                    Children         = { Corner(2) }
                })
                New("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0),
                    }),
                    Rotation = 90,
                    Parent = svDark,
                })
                -- SV cursor (above overlays)
                local svCursor = New("Frame", {
                    Size             = UDim2.new(0, 10, 0, 10),
                    Position         = UDim2.new(s, -5, 1-v, -5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel  = 0,
                    ZIndex           = 204,
                    Parent           = svSquare,
                    Children         = { New("UICorner", {CornerRadius=UDim.new(1,0)}), Stroke(Color3.new(0,0,0), 1) }
                })

                -- Hue bar
                local hueBar = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 12),
                    Position         = UDim2.new(0, 0, 0, 108),
                    BorderSizePixel  = 0,
                    ZIndex           = 201,
                    Parent           = popup,
                    Children         = { Corner(2) }
                })
                New("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1, 1)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                        ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                        ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1, 1)),
                    }),
                    Parent = hueBar,
                })
                local hueCursor = New("Frame", {
                    Size             = UDim2.new(0, 4, 1, 4),
                    Position         = UDim2.new(h, -2, 0, -2),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel  = 0,
                    ZIndex           = 202,
                    Parent           = hueBar,
                    Children         = { Corner(2), Stroke(Color3.new(0,0,0), 1) }
                })

                -- Hex input
                local hexWrap = New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    Position         = UDim2.new(0, 0, 0, 126),
                    BackgroundColor3 = T.Input,
                    BorderSizePixel  = 0,
                    ZIndex           = 201,
                    Parent           = popup,
                    Children         = { Corner(2), Stroke(T.Border, 1) }
                })
                local hexTb = New("TextBox", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = "",
                    PlaceholderText      = "#RRGGBB",
                    TextColor3           = T.Text,
                    PlaceholderColor3    = T.TextDim,
                    TextSize             = 11,
                    Font                 = Enum.Font.GothamMedium,
                    ClearTextOnFocus     = false,
                    ZIndex               = 202,
                    Parent               = hexWrap,
                })
                Pad(8,8,0,0).Parent = hexTb
                hexTb.FocusLost:Connect(function(enter)
                    if enter then
                        pcall(function()
                            local txt = hexTb.Text:gsub("#","")
                            local _r,_g,_b = tonumber(txt:sub(1,2),16),tonumber(txt:sub(3,4),16),tonumber(txt:sub(5,6),16)
                            local c2 = Color3.fromRGB(_r or 0, _g or 0, _b or 0)
                            h, s, v = Color3.toHSV(c2)
                            svSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                            svCursor.Position = UDim2.new(s, -5, 1-v, -5)
                            hueCursor.Position = UDim2.new(h, -2, 0, -2)
                            updateColor()
                        end)
                    end
                end)

                -- SV drag
                local svDragging = false
                local svHitbox = New("TextButton", {
                    Size = UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=205, Parent=svSquare
                })
                local function setSV(inp)
                    local rx = math.clamp((inp.Position.X - svSquare.AbsolutePosition.X)/svSquare.AbsoluteSize.X, 0, 1)
                    local ry = math.clamp((inp.Position.Y - svSquare.AbsolutePosition.Y)/svSquare.AbsoluteSize.Y, 0, 1)
                    s = rx; v = 1 - ry
                    svCursor.Position = UDim2.new(rx, -5, ry, -5)
                    updateColor()
                end
                svHitbox.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        svDragging = true; setSV(inp)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if not svDragging then return end
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                        setSV(inp)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        svDragging = false
                    end
                end)

                -- Hue drag
                local hueDragging = false
                local hueHitbox = New("TextButton", {
                    Size = UDim2.new(1,0,1,8), Position=UDim2.new(0,0,0,-4), BackgroundTransparency=1, Text="", ZIndex=203, Parent=hueBar
                })
                local function setHue(inp)
                    local rx = math.clamp((inp.Position.X - hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X, 0, 1)
                    h = rx
                    hueCursor.Position = UDim2.new(rx, -2, 0, -2)
                    svSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    updateColor()
                end
                hueHitbox.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true; setHue(inp)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if not hueDragging then return end
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                        setHue(inp)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = false
                    end
                end)

                -- close on any click outside
                UserInputService.InputBegan:Connect(function(inp)
                    if not open then return end
                    if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                    if svDragging or hueDragging then return end
                    local pos = inp.Position
                    local px, py = popup.AbsolutePosition.X, popup.AbsolutePosition.Y
                    local pw, ph2 = popup.AbsoluteSize.X, popup.AbsoluteSize.Y
                    if pos.X < px or pos.X > px+pw or pos.Y < py or pos.Y > py+ph2 then
                        task.defer(closePopup)
                    end
                end)

                local swBtn = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "",
                    ZIndex               = 20,
                    Parent               = swatch,
                })
                swBtn.MouseButton1Click:Connect(function()
                    if open then closePopup() return end
                    open = true
                    local absPos = card.AbsolutePosition
                    local absSize = card.AbsoluteSize
                    local px2 = absPos.X
                    local py2 = absPos.Y + absSize.Y + 4
                    -- keep popup on screen
                    local vp = workspace.CurrentCamera.ViewportSize
                    if py2 + popH > vp.Y - 10 then py2 = absPos.Y - popH - 4 end
                    popup.Position = UDim2.new(0, px2, 0, py2)
                    popup.Size = UDim2.new(0, popW, 0, 0)
                    popup.Visible = true
                    twSpring(popup, { Size = UDim2.new(0, popW, 0, popH) }, 0.22)
                end)

                elem = { _val = cur }
                function elem:Set(c2)
                    if typeof(c2) == "Color3" then
                        cur = c2; elem._val = c2
                        h, s, v = Color3.toHSV(c2)
                        swatch.BackgroundColor3 = c2
                        svSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        svCursor.Position = UDim2.new(s, -5, 1-v, -5)
                        hueCursor.Position = UDim2.new(h, -2, 0, -2)
                        if cb then pcall(cb, c2) end
                    end
                end

                RegFlag(cfg2.Flag, elem)
                return elem
            end

            function tab:Group(_gCfg)
                local groupWrap = New("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 0),
                    AutomaticSize        = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ZIndex               = 14,
                    Parent               = tabFrame,
                })
                List(Enum.FillDirection.Horizontal, 6).Parent = groupWrap

                local g = {}
                function g:Button(bCfg)
                    bCfg = bCfg or {}
                    local cb    = bCfg.Callback
                    local color = bCfg.Color or T.Accent
                    local btn = New("TextButton", {
                        Size                 = UDim2.new(0.5, -3, 0, 28),
                        BackgroundColor3     = color,
                        BackgroundTransparency = 0.15,
                        Text                 = bCfg.Title or "Button",
                        TextColor3           = T.Text,
                        TextSize             = 13,
                        Font                 = Enum.Font.GothamBold,
                        ZIndex               = 15,
                        Parent               = groupWrap,
                        Children             = { Corner(3) }
                    })
                    btn.MouseButton1Click:Connect(function()
                        tw(btn, {BackgroundTransparency=0.5},0.07)
                        task.delay(0.14, function() tw(btn,{BackgroundTransparency=0.15},0.15) end)
                        if cb then pcall(cb) end
                    end)
                    btn.MouseEnter:Connect(function() tw(btn,{BackgroundTransparency=0},0.1) end)
                    btn.MouseLeave:Connect(function() tw(btn,{BackgroundTransparency=0.15},0.1) end)
                    return {}
                end
                function g:Space()
                    New("Frame",{Size=UDim2.new(0,4,0,4),BackgroundTransparency=1,Parent=groupWrap})
                end
                return g
            end

            return tab
        end -- :Tab

        return sec
    end -- :Section

    function WindowObj:Destroy()
        tw(Win, { Size = UDim2.new(0,W,0,0), BackgroundTransparency = 1 }, 0.22, Enum.EasingStyle.Quart)
        task.delay(0.28, function() pcall(function() Win:Destroy() end) end)
    end

    local FOLDER    = "SiltUI"
    local SUBFOLDER = FOLDER .. "/Silt"
    local CFGFOLDER = SUBFOLDER .. "/config"

    local function ensureFolders()
        if not makefolder then return end
        pcall(function()
            if not isfolder(FOLDER)    then makefolder(FOLDER)    end
            if not isfolder(SUBFOLDER) then makefolder(SUBFOLDER) end
            if not isfolder(CFGFOLDER) then makefolder(CFGFOLDER) end
        end)
    end

    local CM = {}

    function CM:Config(name)
        local c = {}
        function c:Save()
            ensureFolders()
            local ok = pcall(function()
                local data = {}
                for flag, elem in pairs(_flagElems) do
                    if elem._val ~= nil then
                        local v = elem._val
                        if typeof(v) == "Color3" then
                            data[flag] = { __type="Color3", r=v.R, g=v.G, b=v.B }
                        else
                            data[flag] = v
                        end
                    end
                end
                writefile(CFGFOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
            end)
            return ok
        end
        function c:Load()
            local ok = pcall(function()
                if not isfile then return end
                local path = CFGFOLDER .. "/" .. name .. ".json"
                if not isfile(path) then return end
                local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
                if not ok or type(data) ~= "table" then return end
                task.defer(function()
                    for flag, val in pairs(data) do
                        local elem = _flagElems[flag]
                        if elem then
                            pcall(function()
                                if type(val) == "table" and val.__type == "Color3" then
                                    elem:Set(Color3.new(val.r, val.g, val.b))
                                else
                                    elem:Set(val)
                                end
                            end)
                        end
                    end
                end)
            end)
            return ok
        end
        function c:Delete()
            local ok = pcall(function()
                local path = CFGFOLDER .. "/" .. name .. ".json"
                if isfile and isfile(path) then delfile(path) end
            end)
            return ok
        end
        return c
    end

    function CM:AllConfigs()
        local list = {}
        pcall(function()
            if not (listfiles and isfolder) then return end
            if not isfolder(CFGFOLDER) then return end
            for _, f in ipairs(listfiles(CFGFOLDER)) do
                local n = f:match("([^/\\]+)%.json$")
                if n then table.insert(list, n) end
            end
        end)
        return list
    end

    WindowObj.ConfigManager  = CM
    WindowObj.CurrentConfig  = nil
    WindowObj._flagElems     = _flagElems

    if cfg.OpenButton and cfg.OpenButton.Enabled ~= false then
        local ob = cfg.OpenButton
        local visible = isMobi

        -- scale button with screen resolution: ~7% of the shorter viewport edge, clamped
        local _vp = workspace.CurrentCamera.ViewportSize
        local _btnSize = math.clamp(math.floor(math.min(_vp.X, _vp.Y) * 0.07), 52, 96)
        local _txtSize = math.clamp(math.floor(_btnSize * 0.24), 12, 22)

        local OpenBtn = New("Frame", {
            Name                   = "SiltOpenBtn",
            Size                   = UDim2.new(0, _btnSize, 0, _btnSize),
            Position               = UDim2.new(ob.X or 0.85, 0, ob.Y or 0.5, 0),
            BackgroundColor3       = Color3.fromRGB(12, 12, 16),
            BackgroundTransparency = 0,
            ZIndex                 = 200,
            Visible                = visible,
            Parent                 = Root,
            Children               = {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { Color = T.Accent, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            }
        })
        New("TextLabel", {
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                 = ob.Title or "S",
            TextColor3           = T.Accent,
            TextSize             = _txtSize,
            Font                 = Enum.Font.GothamBold,
            TextXAlignment       = Enum.TextXAlignment.Center,
            ZIndex               = 201,
            Parent               = OpenBtn,
        })
        local oBtnClick = New("TextButton", {
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                 = "",
            ZIndex               = 202,
            Parent               = OpenBtn,
        })

        local _dragging = false
        local _dragStart, _startPos, _moved
        oBtnClick.InputBegan:Connect(function(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
                _dragging  = true
                _moved     = false
                _dragStart = input.Position
                _startPos  = OpenBtn.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not _dragging then return end
            local t = input.UserInputType
            if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
                local delta = input.Position - _dragStart
                if delta.Magnitude > 6 then _moved = true end
                if _moved then
                    OpenBtn.Position = UDim2.new(
                        _startPos.X.Scale, _startPos.X.Offset + delta.X,
                        _startPos.Y.Scale, _startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
                _dragging = false
            end
        end)

        oBtnClick.MouseButton1Click:Connect(function()
            if _moved then return end
            Win.Visible = not Win.Visible
            if Win.Visible then
                Win.BackgroundTransparency = 1
                twSpring(Win, { BackgroundTransparency = 0 }, 0.32)
            end
        end)
    end

    Win.BackgroundTransparency = 1
    Win.Position = UDim2.new(winX.X.Scale, winX.X.Offset, winX.Y.Scale, winX.Y.Offset + 12)
    twSpring(Win, { BackgroundTransparency = 0, Position = winX }, 0.38)

    local minimized = false

    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local toggleIsMouseBtn = false

    function WindowObj:SetToggleKey(key)
        if typeof(key) == "EnumItem" then
            toggleKey = key
            toggleIsMouseBtn = key.EnumType == Enum.UserInputType
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local match = false
        if toggleIsMouseBtn then
            match = input.UserInputType == toggleKey
        else
            match = input.KeyCode == toggleKey
        end
        if match then
            Win.Visible = not Win.Visible
            if Win.Visible then
                Win.BackgroundTransparency = 1
                twSpring(Win, { BackgroundTransparency = 0 }, 0.32)
            end
        end
    end)

    return WindowObj
end

function SiltUI:Notify(cfg2)
    Notify(cfg2)
end

return SiltUI
