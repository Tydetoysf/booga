-- Project Infra — Steal A Brainrot integration
-- Developer: xylo
-- UI framework assumed: Window:Tab / :Section / :Toggle / :Button / :Slider / :Keybind

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- State
local Infra = {
    Flags = {
        Desync = false,
        AntiHit = false,
        FastSteal = false,
        AutoCollect = false,
        TakeAbove = false,
        ShowESP = false,
    },
    Values = {
        DesyncAmplitude = 6,
        DesyncFrequency = 18,
        FastStealRadius = 20,
        ESPColor = Color3.fromRGB(180, 80, 255),
    },
    Connections = {},
    Targets = {}, -- tracked brainrots
}

-- Helper: safe pcall
local function safe(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        -- print(err)
    end
end

-- Helper: distance
local function dist(a, b)
    return (a - b).Magnitude
end

-- Detect brainrot parts (common names; adapt as needed)
local function isBrainrot(inst)
    if not inst or not inst.Name then return false end
    local n = inst.Name:lower()
    return inst:IsA("BasePart") and (
        n:find("brainrot") or
        n:find("brain") or
        n:find("rot") or
        n:find("head") or
        n:find("item")
    )
end

-- Scan and track brainrots
local function rescanBrainrots()
    table.clear(Infra.Targets)
    for _, d in ipairs(Workspace:GetDescendants()) do
        if isBrainrot(d) then
            Infra.Targets[d] = true
        end
    end
end
rescanBrainrots()

Workspace.DescendantAdded:Connect(function(inst)
    if isBrainrot(inst) then
        Infra.Targets[inst] = true
    end
end)
Workspace.DescendantRemoving:Connect(function(inst)
    if Infra.Targets[inst] then
        Infra.Targets[inst] = nil
    end
end)

-- ESP using Highlight (client-side)
local espMap = {}
local function setESP(state)
    Infra.Flags.ShowESP = state
    for part, _ in pairs(espMap) do
        if espMap[part] and espMap[part].Parent then
            safe(espMap[part].Destroy, espMap[part])
        end
        espMap[part] = nil
    end
    if not state then return end

    for part, _ in pairs(Infra.Targets) do
        if part and part:IsDescendantOf(Workspace) then
            local hl = Instance.new("Highlight")
            hl.FillColor = Infra.Values.ESPColor
            hl.OutlineColor = Infra.Values.ESPColor
            hl.FillTransparency = 0.7
            hl.Adornee = part
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = part
            espMap[part] = hl
        end
    end
end

-- Desync: jitter HRP locally while Humanoid moves smoothly
-- Idea: apply sinusoidal lateral offsets to HRP CFrame; optionally spoof velocity
local desyncConn
local function setDesync(state)
    Infra.Flags.Desync = state
    if desyncConn then desyncConn:Disconnect() desyncConn = nil end
    if not state then
        -- restore baseline
        HRP.AssemblyLinearVelocity = Vector3.zero
        return
    end
    local t0 = tick()
    desyncConn = RunService.RenderStepped:Connect(function(dt)
        if not Infra.Flags.Desync or not Character.Parent then return end
        local t = tick() - t0
        local amp = Infra.Values.DesyncAmplitude
        local freq = Infra.Values.DesyncFrequency
        local offsetX = math.sin(t * freq) * amp
        local offsetZ = math.cos(t * freq * 0.85) * amp

        -- base CF from current HRP, apply client-side lateral wobble
        local baseCF = HRP.CFrame
        local wobble = CFrame.new(offsetX, 0, offsetZ)
        HRP.CFrame = baseCF * wobble

        -- velocity spoofing to add unpredictability (client-side)
        local velX = math.cos(t * (freq * 0.5)) * amp * 2
        local velZ = math.sin(t * (freq * 0.55)) * amp * 2
        HRP.AssemblyLinearVelocity = Vector3.new(velX, HRP.AssemblyLinearVelocity.Y, velZ)
    end)
end

-- Anti-hit: shrink hitbox and temporarily no-collide around impact windows
local antiHitConn
local function setAntiHit(state)
    Infra.Flags.AntiHit = state
    if antiHitConn then antiHitConn:Disconnect() antiHitConn = nil end
    if not state then
        -- restore defaults
        HRP.Size = Vector3.new(2, 2, 1)
        HRP.CanCollide = true
        return
    end
    -- Reduce HRP size and disable collisions; keep Y stable
    HRP.Size = Vector3.new(1.2, 1.2, 0.8)
    HRP.CanCollide = false

    -- Periodic micro-elevate to "phase" above ground slightly
    antiHitConn = RunService.RenderStepped:Connect(function()
        if not Infra.Flags.AntiHit then return end
        local cf = HRP.CFrame
        HRP.CFrame = CFrame.new(cf.X, cf.Y + 0.015, cf.Z)
    end)
end

-- Fast steal: move to nearest brainrot then snap back
local lastPos
local function nearestBrainrot(radius)
    local best, bestDist = nil, math.huge
    for part, _ in pairs(Infra.Targets) do
        if part and part:IsDescendantOf(Workspace) then
            local d = dist(HRP.Position, part.Position)
            if d < (radius or Infra.Values.FastStealRadius) and d < bestDist then
                best, bestDist = part, d
            end
        end
    end
    return best, bestDist
end

local function doFastSteal()
    local target = nearestBrainrot(Infra.Values.FastStealRadius)
    if not target then return end
    lastPos = HRP.Position
    -- brief platform stand to avoid physics pop
    Humanoid.PlatformStand = true
    HRP.CFrame = CFrame.new(target.Position + Vector3.new(0, 2.2, 0))
    task.wait(0.08)
    HRP.CFrame = CFrame.new(lastPos)
    Humanoid.PlatformStand = false
end

-- Auto collect loop (periodic fast steal)
local autoCollectThread
local function setAutoCollect(state)
    Infra.Flags.AutoCollect = state
    if autoCollectThread then autoCollectThread = nil end
    if not state then return end
    task.spawn(function()
        autoCollectThread = coroutine.running()
        while Infra.Flags.AutoCollect do
            doFastSteal()
            task.wait(0.3)
        end
    end)
end

-- Take-Above: maintain position slightly above target brainrot (for contested pickups)
local takeAboveConn
local function setTakeAbove(state)
    Infra.Flags.TakeAbove = state
    if takeAboveConn then takeAboveConn:Disconnect() takeAboveConn = nil end
    if not state then return end
    takeAboveConn = RunService.Heartbeat:Connect(function()
        local target = nearestBrainrot(40)
        if target then
            local tp = target.Position
            local desired = Vector3.new(tp.X, tp.Y + 2.75, tp.Z)
            Humanoid:MoveTo(desired)
        end
    end)
end

-- Build UI within your existing tab system
local Tabs = {
    Match   = Window:Tab({ Title = "Match",   Icon = "volleyball" }),
    Player  = Window:Tab({ Title = "Player",  Icon = "user" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "script" }),
}
Window:SelectTab(1)

-- Credits
do
    local s = Tabs.Credits:Section({ Title = "Developer" })
    s:Label("Project Infra")
    s:Label("Developer: xylo")
    s:Button({
        Title = "Join Discord",
        Callback = function() setclipboard("https://discord.gg/5EJmv76J") end
    })
end

-- Match: Vision / ESP
do
    local s = Tabs.Match:Section({ Title = "Vision" })
    s:Toggle({
        Title = "Brainrot ESP",
        Desc = "Highlights pickup targets.",
        Value = false,
        Callback = function(v) setESP(v) end
    })
    s:Dropdown({
        Title = "ESP Color",
        Values = { "Purple", "Magenta", "Cyan", "Red", "Green" },
        Default = "Purple",
        Callback = function(val)
            local map = {
                Purple = Color3.fromRGB(180,80,255),
                Magenta= Color3.fromRGB(255,80,200),
                Cyan   = Color3.fromRGB(80,200,255),
                Red    = Color3.fromRGB(255,80,80),
                Green  = Color3.fromRGB(80,255,120),
            }
            Infra.Values.ESPColor = map[val] or Infra.Values.ESPColor
            if Infra.Flags.ShowESP then setESP(true) end
        end
    })
    s:Button({
        Title = "Rescan Targets",
        Desc = "Refresh brainrot list.",
        Callback = function()
            rescanBrainrots()
            if Infra.Flags.ShowESP then setESP(true) end
        end
    })
}

-- Match: Movement / Desync
do
    local s = Tabs.Match:Section({ Title = "Movement" })
    s:Toggle({
        Title = "Desync V4",
        Desc = "Client-side wobble & velocity spoof.",
        Value = false,
        Callback = function(v) setDesync(v) end
    })
    s:Slider({
        Title = "Desync amplitude",
        Desc = "Wobble width",
        Value = { Min = 0, Max = 20, Default = Infra.Values.DesyncAmplitude },
        Callback = function(val) Infra.Values.DesyncAmplitude = val end
    })
    s:Slider({
        Title = "Desync frequency",
        Desc = "Wobble speed",
        Value = { Min = 1, Max = 30, Default = Infra.Values.DesyncFrequency },
        Callback = function(val) Infra.Values.DesyncFrequency = val end
    })
    s:Toggle({
        Title = "Anti-Hit",
        Desc = "Shrink hitbox & no-collide",
        Value = false,
        Callback = function(v) setAntiHit(v) end
    })
}

-- Match: Steal
do
    local s = Tabs.Match:Section({ Title = "Steal" })
    s:Toggle({
        Title = "Auto Collect",
        Desc = "Periodic fast-steal loop",
        Value = false,
        Callback = function(v) setAutoCollect(v) end
    })
    s:Button({
        Title = "Fast Steal (O)",
        Desc = "Snap to nearest and back",
        Callback = function() doFastSteal() end
    })
    s:Slider({
        Title = "Fast Steal radius",
        Desc = "Search distance",
        Value = { Min = 5, Max = 60, Default = Infra.Values.FastStealRadius },
        Callback = function(val) Infra.Values.FastStealRadius = val end
    })
    s:Toggle({
        Title = "Take-Above",
        Desc = "Hold position above nearest",
        Value = false,
        Callback = function(v) setTakeAbove(v) end
    })
}

-- Player: Mobility
do
    local s = Tabs.Player:Section({ Title = "Mobility" })
    local speedBoost = false
    local speedScalar = 1
    s:Toggle({
        Title = "Speed Boost",
        Desc = "Client-side push",
        Value = false,
        Callback = function(v) speedBoost = v end
    })
    s:Slider({
        Title = "Boost scale",
        Desc = "Push strength",
        Value = { Min = 1, Max = 8, Default = 2 },
        Callback = function(val) speedScalar = val end
    })
    RunService.RenderStepped:Connect(function()
        if speedBoost and Character and HRP and Humanoid then
            local dir = Humanoid.MoveDirection
            if dir.Magnitude > 0 then
                HRP.CFrame = HRP.CFrame + (dir.Unit * (0.03 * speedScalar))
            end
        end
    end)
}

-- Hotkey: Fast Steal
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.O then
        doFastSteal()
    end
end)
