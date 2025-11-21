-- Project Infra — UI + Logic
-- Developer: xylo

-- Safe call wrapper
local function safe(fn)
    return function(...)
        local ok = true
        if typeof(fn) == "function" then
            ok = select(1, pcall(fn, ...))
        end
        return ok
    end
end

-- DMVS flags/functions/settings bridge (will wire up if present)
local G = getgenv()
local DMVS = {
    flags = {
        AutoGun = "AutoGun",
        PullGun = "PullGun",
        AutoKnife = "AutoKnife",
        HitBox = "HitBox",
        PlayerESP = "PlayerESP",
        GunSound = "GunSound",
        Triggerbot = "Triggerbot",
        AutoSlash = "AutoSlash",
        EquipKnife = "EquipKnife",
        AutoTPe = "AutoTPe",
        AutoBuy = "AutoBuy",
    },
    funcs = {
        KillGun    = rawget(_G, "KillGun"),
        KillKnife  = rawget(_G, "KillKnife"),
        PlayerESP  = rawget(_G, "PlayerESP"),
        HitBox     = rawget(_G, "HitBox"),
        Triggerbot = rawget(_G, "Triggerbot"),
        AutoGun    = rawget(_G, "AutoGun"),
        AutoKnife  = rawget(_G, "AutoKnife"),
        GunSound   = rawget(_G, "GunSound"),
        AutoSlash  = rawget(_G, "AutoSlash"),
        EquipKnife = rawget(_G, "EquipKnife"),
        GetTP      = rawget(_G, "GetTP"),
        DelTP      = rawget(_G, "DelTP"),
        AutoTPe    = rawget(_G, "AutoTPe"),
        BuyBox     = rawget(_G, "BuyBox"),
    },
    settings = rawget(_G, "Settings") or {
        Triggerbot = {Cooldown = 3, Waiting = false},
        Teleport   = {Mode = "Everytime", CFrame = CFrame.new(-337,76,19)},
        Slash      = {Cooldown = 0.5},
        Boxes      = {Selected = "Knife Box #1", Price = 500},
        SpamSoundCooldown = 0.2,
    }
}

local function setFlag(name, state, startFnName)
    G[name] = state
    local fn = DMVS.funcs[startFnName or name]
    if typeof(fn) == "function" then
        safe(fn)()
    end
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- Theme and state
local Theme = {
    Base = Color3.fromRGB(26, 20, 36),
    Panel = Color3.fromRGB(40, 30, 60),
    Muted = Color3.fromRGB(33, 26, 50),
    Accent = Color3.fromRGB(130, 80, 190),
    Text = Color3.fromRGB(210, 180, 255),
    SubText = Color3.fromRGB(170, 145, 220),
}

local Infra = {
    Flags = {
        ESP = false,
        Hitbox = false,
        Triggerbot = false,
        AutoTeleportTool = false,
        AutoBuy = false,
        AutoEquipGun = false,
        AutoEquipKnife = false,
    },
    Values = {
        ESPColor = Color3.fromRGB(180, 80, 255),
        HitboxSize = 5,
        TriggerCooldown = DMVS.settings.Triggerbot.Cooldown,
        SlashCooldown = DMVS.settings.Slash.Cooldown,
        SoundCooldown = DMVS.settings.SpamSoundCooldown,
        TeleportMode = DMVS.settings.Teleport.Mode,
        BoxSelected = DMVS.settings.Boxes.Selected,
        BoxPrice = DMVS.settings.Boxes.Price,
    },
    Connections = {},
}

-- UI helpers
local function create(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end
local function corner(r, p) return create("UICorner", {CornerRadius = UDim.new(0, r)}, p) end
local function padding(p, t, r, b, l) return create("UIPadding", {
    PaddingTop = UDim.new(0, t or 0), PaddingRight = UDim.new(0, r or 0),
    PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0)
}, p) end
local function list(p, pad) return create("UIListLayout", {Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder}, p) end

-- Root UI
local sg = create("ScreenGui", {Name="ProjectInfraUI", IgnoreGuiInset=true, ResetOnSpawn=false, Enabled=true}, PlayerGui)
local window = create("Frame", {Name="Window", Size=UDim2.new(0,520,0,350), Position=UDim2.new(0.5,-260,0.5,-175), BackgroundColor3=Theme.Base, BorderSizePixel=0}, sg)
corner(12, window)

local glow = create("ImageLabel", {Name="Glow", Size=UDim2.new(1,24,1,24), Position=UDim2.new(0,-12,0,-12), BackgroundTransparency=1, Image="rbxassetid://5028857082", ImageColor3=Color3.fromRGB(155,65,200), ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(24,24,276,276)}, window)

local header = create("Frame", {Name="Header", Size=UDim2.new(1,0,0,42), BackgroundColor3=Theme.Panel, BorderSizePixel=0}, window)
local title = create("TextLabel", {Name="Title", Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,16,0,0), BackgroundTransparency=1, Text="PROJECT INFRA", Font=Enum.Font.GothamBold, TextSize=20, TextColor3=Theme.Text, TextXAlignment=Enum.TextXAlignment.Left}, header)
local subtitle = create("TextLabel", {Name="Subtitle", Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,16,0,20), BackgroundTransparency=1, Text="Purple tinted • Minimal • Draggable", Font=Enum.Font.Gotham, TextSize=12, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left}, header)

-- Dragging
do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Tabs and pages
local tabBar = create("Frame", {Name="TabBar", Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,0,42), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, window)
local pages = create("Frame", {Name="Pages", Size=UDim2.new(1,-16,1,-42-36-16), Position=UDim2.new(0,8,0,42+36+8), BackgroundTransparency=1}, window)

local tabs = {}
local function makeTabButton(text, order)
    local btn = create("TextButton", {Size=UDim2.new(0,110,1,0), Position=UDim2.new(0,12+(order-1)*116,0,0), BackgroundColor3=Theme.Panel, TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=14, Text=text, AutoButtonColor=false}, tabBar)
    corner(8, btn)
    return btn
end
local function makePage(name)
    local page = create("Frame", {Name=name, Size=UDim2.new(1,-16,1,-8), Position=UDim2.new(0,8,0,0), BackgroundColor3=Color3.fromRGB(24,18,38), Visible=false}, pages)
    corner(10, page)
    padding(page, 12, 12, 12, 12)
    list(page, 10)
    return page
end
local function registerTab(name, order)
    local btn = makeTabButton(name, order)
    local page = makePage(name)
    tabs[name] = {button=btn, page=page}
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.page.Visible = false; t.button.BackgroundColor3 = Theme.Panel end
        page.Visible = true
        btn.BackgroundColor3 = Theme.Accent
    end)
    return page
end

local pageMain      = registerTab("Main", 1)
local pageGun       = registerTab("Gun", 2)
local pageKnife     = registerTab("Knife", 3)
local pageTeleport  = registerTab("Teleport", 4)
local pageBoxes     = registerTab("Boxes", 5)
local pageCredits   = registerTab("Credits", 6)
tabs["Main"].button:Activate()

-- Control builders
local function section(parent, text)
    local f = create("Frame", {Size=UDim2.new(1,0,0,30), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, parent)
    corner(8, f)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,8,0,0), Text=text, Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Theme.Text, TextXAlignment=Enum.TextXAlignment.Left}, f)
    return f
end

local function toggle(parent, label, default, callback)
    local f = create("Frame", {Size=UDim2.new(1,0,0,46), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, parent)
    corner(8, f)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-110,1,0), Position=UDim2.new(0,10,0,0), Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left}, f)
    local btn = create("TextButton", {Size=UDim2.new(0,84,0,28), Position=UDim2.new(1,-96,0.5,-14), BackgroundColor3=default and Theme.Accent or Theme.Panel, TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, Text=default and "ON" or "OFF", AutoButtonColor=false}, f)
    corner(8, btn)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Theme.Accent or Theme.Panel
        if callback then safe(callback)(state) end
    end)
    return function(v)
        state = v
        btn.Text = v and "ON" or "OFF"
        btn.BackgroundColor3 = v and Theme.Accent or Theme.Panel
        if callback then safe(callback)(v) end
    end
end

local function slider(parent, label, min, max, step, default, onChange)
    local f = create("Frame", {Size=UDim2.new(1,0,0,60), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, parent)
    corner(8, f)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-10,0,20), Position=UDim2.new(0,10,0,6), Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left}, f)
    local bar = create("Frame", {Size=UDim2.new(1,-110,0,8), Position=UDim2.new(0,10,0,36), BackgroundColor3=Theme.Panel, BorderSizePixel=0}, f)
    corner(8, bar)
    local fill = create("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=Theme.Accent, BorderSizePixel=0}, bar)
    corner(8, fill)
    local valLabel = create("TextLabel", {Size=UDim2.new(0,84,0,22), Position=UDim2.new(1,-96,0,28), BackgroundColor3=Theme.Panel, TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, Text=tostring(default)}, f)
    corner(8, valLabel)

    local function set(v)
        v = math.clamp(v, min, max)
        v = math.floor(v/step+0.5)*step
        local pct = (v-min)/(max-min)
        fill.Size = UDim2.new(pct,0,1,0)
        valLabel.Text = tostring(v)
        if onChange then safe(onChange)(v) end
    end
    set(default)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local rel = (input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
            set(min + rel*(max-min))
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
            set(min + rel*(max-min))
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return set
end

local function dropdown(parent, label, options, default, onChange)
    local f = create("Frame", {Size=UDim2.new(1,0,0,74), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, parent)
    corner(8, f)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-10,0,20), Position=UDim2.new(0,10,0,6), Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left}, f)
    local box = create("TextButton", {Size=UDim2.new(1,-20,0,32), Position=UDim2.new(0,10,0,34), BackgroundColor3=Theme.Panel, TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=12, Text=default or options[1], AutoButtonColor=false}, f)
    corner(8, box)

    local open = false
    local listFrame = create("Frame", {Size=UDim2.new(1,-20,0,#options*28), Position=UDim2.new(0,10,0,68), BackgroundColor3=Theme.Panel, BorderSizePixel=0, Visible=false}, f)
    corner(8, listFrame)
    padding(listFrame,6,6,6,6)
    list(listFrame,6)

    local function set(val)
        box.Text = val
        listFrame.Visible = false
        open = false
        if onChange then safe(onChange)(val) end
    end

    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {Size=UDim2.new(1,0,0,22), BackgroundColor3=Theme.Muted, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=12, Text=opt, AutoButtonColor=false}, listFrame)
        corner(6, optBtn)
        optBtn.MouseButton1Click:Connect(function() set(opt) end)
    end

    box.MouseButton1Click:Connect(function() open = not open; listFrame.Visible = open end)
    set(default or options[1])
    return set
end

local function button(parent, label, onClick)
    local f = section(parent, label)
    f.Size = UDim2.new(1,0,0,46)
    local btn = create("TextButton", {Size=UDim2.new(0,110,0,28), Position=UDim2.new(1,-122,0.5,-14), BackgroundColor3=Theme.Accent, TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, Text="Run", AutoButtonColor=false}, f)
    corner(8, btn)
    btn.MouseButton1Click:Connect(function() if onClick then safe(onClick)() end end)
end

-- Logic helpers
local highlights = {}
local function refreshESP()
    for _, h in pairs(highlights) do pcall(function() h:Destroy() end) end
    table.clear(highlights)
    if not Infra.Flags.ESP then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hl = Instance.new("Highlight")
            hl.FillColor = Infra.Values.ESPColor
            hl.OutlineColor = Infra.Values.ESPColor
            hl.FillTransparency = 0.7
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = plr.Character
            hl.Parent = plr.Character
            highlights[plr] = hl
        end
    end
end

local resized = {}
local function applyHitbox(state)
    for plr, _ in pairs(resized) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
        end
    end
    table.clear(resized)
    if not state then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            hrp.Size = Vector3.new(Infra.Values.HitboxSize, Infra.Values.HitboxSize, Infra.Values.HitboxSize)
            hrp.Massless = true
            hrp.CanCollide = false
            resized[plr] = true
        end
    end
end

local function equipToolByNames(names)
    local bp = LP:FindFirstChildOfClass("Backpack")
    if not bp then return end
    for _, t in ipairs(bp:GetChildren()) do
        local n = string.lower(t.Name)
        for _, key in ipairs(names) do
            if n:find(key) then
                t.Parent = LP.Character
                return t
            end
        end
    end
end

local lastTrigger = 0
local function runTriggerbot(state)
    Infra.Flags.Triggerbot = state
    setFlag(DMVS.flags.Triggerbot, state, "Triggerbot")
    if not state then return end
    table.insert(Infra.Connections, RunService.RenderStepped:Connect(function()
        if not Infra.Flags.Triggerbot then return end
        if time() - lastTrigger < Infra.Values.TriggerCooldown then return end
        if not LP.Character or not LP.Character:FindFirstChild("Head") then return end

        -- nearest enemy head
        local bestHead, bestDist
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head.Position
                local dist = (LP.Character.Head.Position - head).Magnitude
                if not bestDist or dist < bestDist then bestHead, bestDist = head, dist end
            end
        end
        if not bestHead then return end

        -- raycast check
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LP.Character}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local hit = Workspace:Raycast(LP.Character.Head.Position, (bestHead - LP.Character.Head.Position).Unit * 1000, params)
        if hit then
            local gun = equipToolByNames({"gun","revolver","pistol"})
            if gun then
                pcall(function() gun:Activate() end)
                lastTrigger = time()
            end
        end
    end))
end

local TeleportToolName = "InfraTeleport"
local function giveTPTool()
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:WaitForChild("Backpack")
    local tool = bp:FindFirstChild(TeleportToolName)
    if not tool then
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = TeleportToolName
        tool.Parent = bp
        tool.Activated:Connect(function()
            local mouse = LP:GetMouse()
            if mouse and mouse.Hit and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local cf = mouse.Hit
                LP.Character.HumanoidRootPart.CFrame = CFrame.new(cf.X, cf.Y + 3, cf.Z)
            end
        end)
    end
end
local function removeTPTool()
    local bp = LP:FindFirstChildOfClass("Backpack")
    local char = LP.Character
    if bp then local t = bp:FindFirstChild(TeleportToolName) if t then t:Destroy() end end
    if char then local t2 = char:FindFirstChild(TeleportToolName) if t2 then t2:Destroy() end end
end

local function buySelectedBox()
    if typeof(DMVS.funcs.BuyBox) == "function" then
        safe(DMVS.funcs.BuyBox)(Infra.Values.BoxSelected)
    else
        local ev = ReplicatedStorage:FindFirstChild("BuyBox")
        if ev and ev:IsA("RemoteEvent") then ev:FireServer(Infra.Values.BoxSelected) end
    end
end

-- Main page controls
section(pageMain, "Player ESP")
toggle(pageMain, "Enable ESP", false, function(state)
    Infra.Flags.ESP = state
    setFlag(DMVS.flags.PlayerESP, state, "PlayerESP")
    refreshESP()
end)

section(pageMain, "Hitbox Expander")
toggle(pageMain, "Expand Hitboxes", false, function(state)
    Infra.Flags.Hitbox = state
    setFlag(DMVS.flags.HitBox, state, "HitBox")
    applyHitbox(state)
end)

slider(pageMain, "Hitbox Size", 2, 25, 1, Infra.Values.HitboxSize, function(v)
    Infra.Values.HitboxSize = v
    if Infra.Flags.Hitbox then applyHitbox(true) end
end)

dropdown(pageMain, "ESP Color", {"Purple","Magenta","Cyan","Red","Green"}, "Purple", function(val)
    local map = {
        Purple = Color3.fromRGB(180,80,255),
        Magenta = Color3.fromRGB(255,80,200),
        Cyan    = Color3.fromRGB(80,200,255),
        Red     = Color3.fromRGB(255,80,80),
        Green   = Color3.fromRGB(80,255,120),
    }
    Infra.Values.ESPColor = map[val] or Infra.Values.ESPColor
    if Infra.Flags.ESP then refreshESP() end
end)

-- Gun page
section(pageGun, "Triggerbot")
toggle(pageGun, "Enable", false, function(state) runTriggerbot(state) end)
slider(pageGun, "Shoot cooldown (s)", 0.05, 5, 0.05, Infra.Values.TriggerCooldown, function(v)
    Infra.Values.TriggerCooldown = v
    DMVS.settings.Triggerbot.Cooldown = v
end)

section(pageGun, "Actions")
button(pageGun, "Kill All (Gun)", function()
    if typeof(DMVS.funcs.KillGun) == "function" then safe(DMVS.funcs.KillGun)() else
        local gun = equipToolByNames({"gun","revolver","pistol"})
        if gun then for i=1,10 do pcall(function() gun:Activate() end); task.wait(0.05) end end
    end
end)

toggle(pageGun, "Auto Kill", false, function(state)
    setFlag(DMVS.flags.AutoGun, state, "AutoGun")
end)

toggle(pageGun, "Auto Equip Gun", false, function(state)
    setFlag(DMVS.flags.PullGun, state, "PullGun")
    Infra.Flags.AutoEquipGun = state
end)

toggle(pageGun, "Spam Sound", false, function(state)
    setFlag(DMVS.flags.GunSound, state, "GunSound")
end)
slider(pageGun, "Sound cooldown (s)", 0, 1, 0.05, Infra.Values.SoundCooldown, function(v)
    Infra.Values.SoundCooldown = v
    DMVS.settings.SpamSoundCooldown = v
end)

-- Knife page
section(pageKnife, "Actions")
button(pageKnife, "Kill All (Knife)", function()
    if typeof(DMVS.funcs.KillKnife) == "function" then safe(DMVS.funcs.KillKnife)() end
end)

toggle(pageKnife, "Auto Kill", false, function(state)
    setFlag(DMVS.flags.AutoKnife, state, "AutoKnife")
end)

toggle(pageKnife, "Auto Slash", false, function(state)
    setFlag(DMVS.flags.AutoSlash, state, "AutoSlash")
end)
slider(pageKnife, "Slash cooldown (s)", 0.05, 2, 0.05, Infra.Values.SlashCooldown, function(v)
    Infra.Values.SlashCooldown = v
    DMVS.settings.Slash.Cooldown = v
end)

toggle(pageKnife, "Auto Equip Knife", false, function(state)
    setFlag(DMVS.flags.EquipKnife, state, "EquipKnife")
    Infra.Flags.AutoEquipKnife = state
end)

-- Teleport page
section(pageTeleport, "Teleport tool")
button(pageTeleport, "Get Tool", function()
    if typeof(DMVS.funcs.GetTP) == "function" then safe(DMVS.funcs.GetTP)() else giveTPTool() end
end)
button(pageTeleport, "Remove Tool", function()
    if typeof(DMVS.funcs.DelTP) == "function" then safe(DMVS.funcs.DelTP)() else removeTPTool() end
end)
toggle(pageTeleport, "Permanent tool", false, function(state)
    setFlag(DMVS.flags.AutoTPe, state, "AutoTPe")
    Infra.Flags.AutoTeleportTool = state
    if state and Infra.Values.TeleportMode == "Everytime" then giveTPTool() end
end)

section(pageTeleport, "Teleport mode")
dropdown(pageTeleport, "Mode", {"Everytime","Tools Load"}, Infra.Values.TeleportMode, function(v)
    Infra.Values.TeleportMode = v
    DMVS.settings.Teleport.Mode = v
end)

-- Boxes page
section(pageBoxes, "Select box")
dropdown(pageBoxes, "Box", {"Knife Box #1","Knife Box #2","Gun Box #1","Gun Box #2","Mythic Box #1"}, Infra.Values.BoxSelected, function(val)
    Infra.Values.BoxSelected = val
    Infra.Values.BoxPrice = (val:find("Mythic") and 1500) or 500
    DMVS.settings.Boxes.Selected = val
    DMVS.settings.Boxes.Price = Infra.Values.BoxPrice
end)

section(pageBoxes, "Purchase")
button(pageBoxes, "Buy selected", function() buySelectedBox() end)
toggle(pageBoxes, "Auto buy", false, function(state)
    setFlag(DMVS.flags.AutoBuy, state, "AutoBuy")
    Infra.Flags.AutoBuy = state
    if state then
        task.spawn(function()
            while Infra.Flags.AutoBuy do
                buySelectedBox()
                task.wait(1.25)
            end
        end)
    end
end)

-- Credits page
do
    local card = create("Frame", {Size=UDim2.new(1,0,0,140), BackgroundColor3=Theme.Muted, BorderSizePixel=0}, pageCredits)
    corner(12, card)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-24,0,32), Position=UDim2.new(0,12,0,12), Text="PROJECT INFRA", Font=Enum.Font.GothamBlack, TextSize=20, TextColor3=Theme.Text, TextXAlignment=Enum.TextXAlignment.Left}, card)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-24,0,22), Position=UDim2.new(0,12,0,50), Text="Developer: xylo", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left}, card)
    create("TextLabel", {BackgroundTransparency=1, Size=UDim2.new(1,-24,0,48), Position=UDim2.new(0,12,0,80), Text="Purple-tinted UI, made by ", Font=Enum.Font.Gotham, TextSize=12, TextColor3=Theme.SubText, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top}, card)
end

-- Passive updates
table.insert(Infra.Connections, Players.PlayerAdded:Connect(function(plr)
    if Infra.Flags.ESP then
        plr.CharacterAdded:Connect(function() task.wait(0.2); refreshESP() end)
    end
end))
table.insert(Infra.Connections, Players.PlayerRemoving:Connect(function(plr)
    local h = highlights[plr]
    if h then pcall(function() h:Destroy() end); highlights[plr] = nil end
end))
table.insert(Infra.Connections, RunService.RenderStepped:Connect(function()
    if Infra.Flags.AutoEquipGun then equipToolByNames({"gun","revolver","pistol"}) end
    if Infra.Flags.AutoEquipKnife then equipToolByNames({"knife","blade","katana"}) end
end))
