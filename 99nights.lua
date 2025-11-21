
-- Project Infra — 99 Nights in the Forest Hub
-- Developer: xylo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- State
local Infra = {
    Flags = {
        ESP = false,
        AutoFarm = false,
        KillAura = false,
        AutoCollect = false,
        BringItems = false,
        GodMode = false,
        InfiniteStamina = false,
        AutoHeal = false,
        AutoCampfire = false,
        ResourceESP = false,
        Fly = false,
        Noclip = false,
        LootMagnet = false,
    },
    Values = {
        ESPColor = Color3.fromRGB(0,255,0),
        FarmInterval = 1.5,
        AuraRange = 20,
        DesyncAmplitude = 6,
        DesyncFrequency = 18,
    },
    Connections = {},
}

-- Helpers
local function safe(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn(err) end
end

-- ESP
local espMap = {}
local function setESP(state)
    Infra.Flags.ESP = state
    for _, h in pairs(espMap) do safe(h.Destroy, h) end
    table.clear(espMap)
    if not state then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hl = Instance.new("Highlight")
            hl.FillColor = Infra.Values.ESPColor
            hl.OutlineColor = Infra.Values.ESPColor
            hl.Adornee = obj
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = obj
            espMap[obj] = hl
        end
    end
end

-- Resource ESP
local function setResourceESP(state)
    Infra.Flags.ResourceESP = state
    for _, h in pairs(espMap) do safe(h.Destroy, h) end
    table.clear(espMap)
    if not state then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local hl = Instance.new("Highlight")
            if obj.Name:lower():find("tree") then
                hl.FillColor = Color3.fromRGB(0,255,0)
            elseif obj.Name:lower():find("rock") then
                hl.FillColor = Color3.fromRGB(150,150,150)
            elseif obj.Name:lower():find("item") then
                hl.FillColor = Color3.fromRGB(255,255,0)
            else
                hl.FillColor = Infra.Values.ESPColor
            end
            hl.Adornee = obj
            hl.Parent = obj
            espMap[obj] = hl
        end
    end
end

-- Auto Farm
local function autoFarmLoop()
    while Infra.Flags.AutoFarm do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("tree") then
                HRP.CFrame = obj.CFrame + Vector3.new(0,3,0)
                task.wait(0.2)
            end
        end
        task.wait(Infra.Values.FarmInterval)
    end
end

-- Kill Aura
local function killAuraLoop()
    while Infra.Flags.KillAura do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (HRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < Infra.Values.AuraRange then
                    local ev = ReplicatedStorage:FindFirstChild("AttackEvent")
                    if ev and ev:IsA("RemoteEvent") then
                        ev:FireServer(plr.Character)
                    end
                end
            end
        end
        task.wait(0.3)
    end
end

-- Auto Collect
local function autoCollectLoop()
    while Infra.Flags.AutoCollect do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("item") then
                HRP.CFrame = obj.CFrame + Vector3.new(0,2,0)
                task.wait(0.1)
            end
        end
        task.wait(0.5)
    end
end

-- Bring Items
local function bringItems()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("item") then
            obj.CFrame = HRP.CFrame + Vector3.new(math.random(-3,3),2,math.random(-3,3))
        end
    end
end

-- God Mode
local function setGodMode(state)
    Infra.Flags.GodMode = state
    if state then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end
end

-- Infinite Stamina
local function setInfiniteStamina(state)
    Infra.Flags.InfiniteStamina = state
    if state and LocalPlayer:FindFirstChild("Stats") and LocalPlayer.Stats:FindFirstChild("Stamina") then
        LocalPlayer.Stats.Stamina.Value = math.huge
    end
end

-- Auto Heal
local function autoHealLoop()
    while Infra.Flags.AutoHeal do
        if Humanoid.Health < 50 then
            Humanoid.Health = Humanoid.MaxHealth
        end
        task.wait(1)
    end
end

-- Teleports
local function teleportSafeZone()
    if Workspace:FindFirstChild("SafeZone") then
        HRP.CFrame = Workspace.SafeZone.CFrame + Vector3.new(0,5,0)
    end
end
local function teleportTo(location)
    if Workspace:FindFirstChild(location) then
        HRP.CFrame = Workspace[location].CFrame + Vector3.new(0,5,0)
    end
end

-- Night Cycle
local function setDay()
    if Workspace:FindFirstChild("Lighting") then
        Workspace.Lighting.ClockTime = 12
    end
end
local function setNight()
    if Workspace:FindFirstChild("Lighting") then
        Workspace.Lighting.ClockTime = 0
    end
end
local function freezeTime()
    if Workspace:FindFirstChild("Lighting") then
        Workspace.Lighting.ClockTime = 12
        Workspace.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            Workspace.Lighting.ClockTime = 12
        end)
    end
end

-- Auto Campfire
local function autoCampfireLoop()
    while Infra.Flags.AutoCampfire do
        if Workspace.Lighting.ClockTime >= 18 or Workspace.Lighting.ClockTime <= 6 then
            if Workspace:FindFirstChild("Campfire") then
                HRP.CFrame = Workspace.Campfire.CFrame + Vector3.new(0,3,0)
            end
        end
        task.wait(5)
    end
end

-- Fly / Noclip
local flyConn
local function setFly(state)
    Infra.Flags.Fly = state
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if not state then return end
    flyConn = RunService.RenderStepped:Connect(function()
        HRP.Velocity = Vector3.new(0,50,0)
    end)
end
local function setNoclip(state)
    Infra.Flags.Noclip = state
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Loot Magnet
local function lootMagnetLoop()
    while Infra.Flags.LootMagnet do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("item") then
                obj.CFrame = HRP.CFrame + Vector3.new(math.random(-2,2),2,math.random(-2,2))
            end
        end
        task.wait(0.2)
    end
end

-- UI Tabs
local Tabs = {
    Combat  = Window:Tab({ Title = "Combat",  Icon = "sword" }),
    Utility = Window:Tab({ Title = "Utility", Icon = "tool" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "script" }),
}
Window:SelectTab(1)

-- Combat Tab
local combatSection = Tabs.Combat:Section({ Title = "Combat Tools" })
combatSection:Toggle({
    Title = "Kill Aura",
    Desc = "Attack enemies in range",
    Value = false,
    Callback = function(v)
        Infra.Flags.KillAura = v
        if v then task.spawn(killAuraLoop) end
    end
})
combatSection:Slider({
    Title = "Aura Range",
    Desc = "Distance to attack",
    Value = { Min = 5, Max = 50, Default = Infra.Values.AuraRange },
    Callback = function(val) Infra.Values.AuraRange = val end
})
combatSection:Toggle({
    Title = "God Mode",
    Desc = "Infinite health",
    Value = false,
    Callback = function(v) setGodMode(v) end
})

-- Utility Tab
local utilSection = Tabs.Utility:Section({ Title = "Utility" })
utilSection:Toggle({
    Title = "ESP",
    Desc = "Highlight enemies",
    Value = false,
    Callback = function(v) setESP(v) end
})
utilSection:Toggle({
    Title = "Resource ESP",
    Desc = "Highlight trees, rocks, items",
    Value = false,
    Callback = function(v) setResourceESP(v) end
})
utilSection:Toggle({
    Title = "Auto Farm Trees",
    Desc = "Teleport to trees and farm",
    Value = false,
    Callback = function(v)
        Infra.Flags.AutoFarm = v
        if v then task.spawn(autoFarmLoop) end
    end
})
utilSection:Toggle({
    Title = "Auto Collect Items",
    Desc = "Teleport to items and collect",
    Value = false,
    Callback = function(v)
        Infra.Flags.AutoCollect = v
        if v then task.spawn(autoCollectLoop) end
    end
})
utilSection:Button({
    Title = "Bring Items",
    Desc = "Teleport items to you",
    Callback = function() bringItems() end
})
utilSection:Button({
    Title = "Teleport Safe Zone",
    Desc = "Teleport to safe zone",
    Callback = function() teleportSafeZone() end
})
utilSection:Dropdown({
    Title = "Teleport Menu",
    Values = {"SafeZone","Campfire","Cave","Lake"},
    Default = "SafeZone",
    Callback = function(val) teleportTo(val) end
})
utilSection:Toggle({
    Title = "Infinite Stamina",
    Desc = "Never run out of stamina",
    Value = false,
    Callback = function(v) setInfiniteStamina(v) end
})
utilSection:Toggle({
    Title = "Auto Heal",
    Desc = "Restore health automatically",
    Value = false,
    Callback = function(v)
        Infra.Flags.AutoHeal = v
        if v then task.spawn(autoHealLoop) end
    end
})
utilSection:Button({
    Title = "Set Day",
    Desc = "Skip to daytime",
    Callback = function() setDay() end
})
utilSection:Button({
    Title = "Set Night",
    Desc = "Skip to nighttime",
    Callback = function() setNight() end
})
utilSection:Toggle({
    Title = "Freeze Time",
    Desc = "Lock time at noon",
    Value = false,
    Callback = function(v) if v then freezeTime() end end
})
utilSection:Toggle({
    Title = "Auto Campfire",
    Desc = "Teleport to campfire at night",
    Value = false,
    Callback = function(v)
        Infra.Flags.AutoCampfire = v
        if v then task.spawn(autoCampfireLoop) end
    end
})
utilSection:Toggle({
    Title = "Fly",
    Desc = "Fly upwards",
    Value = false,
    Callback = function(v) setFly(v) end
})
utilSection:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Value = false,
    Callback = function(v) setNoclip(v) end
})
utilSection:Toggle({
    Title = "Loot Magnet",
    Desc = "Pull items to you",
    Value = false,
    Callback = function(v)
        Infra.Flags.LootMagnet = v
        if v then task.spawn(lootMagnetLoop) end
    end
})

-- Credits Tab
local creditsSection = Tabs.Credits:Section({ Title = "Developer Info" })
creditsSection:Label("Project Infra - 99 Nights in the Forest")
creditsSection:Label("Developer: xylo")
creditsSection:Button({
    Title = "Join Discord",
    Callback = function() setclipboard("https://discord.gg/5EJmv76J") end
})
