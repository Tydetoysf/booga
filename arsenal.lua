-- Project Infra — Arsenal Hub
-- Developer: xylo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local Infra = {
    Flags = {
        SilentAim = false,
        Triggerbot = false,
        KillAura = false,
        ESP = false,
        Hitbox = false,
        SpeedBoost = false,
        AutoReload = false,
        AutoKnife = false,
    },
    Values = {
        AuraRange = 20,
        FOV = 90,
        HitboxSize = 5,
        Speed = 0.03,
        ESPColor = Color3.fromRGB(255,0,0),
    },
}

-- Silent Aim (basic raycast hook)
local function setSilentAim(state)
    Infra.Flags.SilentAim = state
    -- hook raycast / mouse target logic here
end

-- Triggerbot
local lastTrigger = 0
local function runTriggerbot(state)
    Infra.Flags.Triggerbot = state
    if not state then return end
    RunService.RenderStepped:Connect(function()
        if not Infra.Flags.Triggerbot then return end
        if time() - lastTrigger < 0.2 then return end
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
            mouse1click() -- simulate click
            lastTrigger = time()
        end
    end)
end

-- Kill Aura
local function killAuraLoop()
    while Infra.Flags.KillAura do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (HRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < Infra.Values.AuraRange then
                    local ev = ReplicatedStorage:FindFirstChild("AttackEvent")
                    if ev then ev:FireServer(plr.Character) end
                end
            end
        end
        task.wait(0.2)
    end
end

-- ESP
local espMap = {}
local function setESP(state)
    Infra.Flags.ESP = state
    for _, h in pairs(espMap) do h:Destroy() end
    table.clear(espMap)
    if not state then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = Instance.new("Highlight")
            hl.FillColor = Infra.Values.ESPColor
            hl.OutlineColor = Infra.Values.ESPColor
            hl.Adornee = plr.Character
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = plr.Character
            espMap[plr] = hl
        end
    end
end

-- Hitbox Expander
local function setHitbox(state)
    Infra.Flags.Hitbox = state
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            hrp.Size = state and Vector3.new(Infra.Values.HitboxSize,Infra.Values.HitboxSize,Infra.Values.HitboxSize) or Vector3.new(2,2,1)
        end
    end
end

-- Speed Boost
RunService.RenderStepped:Connect(function()
    if Infra.Flags.SpeedBoost and Character and HRP and Humanoid then
        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            HRP.CFrame = HRP.CFrame + (dir.Unit * Infra.Values.Speed)
        end
    end
end)

-- Auto Reload
local function autoReloadLoop()
    while Infra.Flags.AutoReload do
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Ammo") and tool.Ammo.Value == 0 then
            tool:Activate()
        end
        task.wait(0.2)
    end
end

-- Auto Knife
local function autoKnifeLoop()
    while Infra.Flags.AutoKnife do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (HRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < 5 then
                    local bp = LocalPlayer.Backpack
                    for _, tool in ipairs(bp:GetChildren()) do
                        if tool.Name:lower():find("knife") then
                            tool.Parent = LocalPlayer.Character
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end

-- UI Tabs
local Tabs = {
    Combat  = Window:Tab({ Title = "Combat",  Icon = "sword" }),
    Vision  = Window:Tab({ Title = "Vision",  Icon = "eye" }),
    Utility = Window:Tab({ Title = "Utility", Icon = "tool" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "script" }),
}
Window:SelectTab(1)

-- Combat Tab
local combatSection = Tabs.Combat:Section({ Title = "Combat Tools" })
combatSection:Toggle({ Title="Silent Aim", Value=false, Callback=function(v) setSilentAim(v) end })
combatSection:Toggle({ Title="Triggerbot", Value=false, Callback=function(v) runTriggerbot(v) end })
combatSection:Toggle({ Title="Kill Aura", Value=false, Callback=function(v) Infra.Flags.KillAura=v if v then task.spawn(killAuraLoop) end end })
combatSection:Slider({ Title="Aura Range", Value={Min=5,Max=50,Default=Infra.Values.AuraRange}, Callback=function(val) Infra.Values.AuraRange=val end })

-- Vision Tab
local visionSection = Tabs.Vision:Section({ Title = "Visuals" })
visionSection:Toggle({ Title="ESP", Value=false, Callback=function(v) setESP(v) end })
visionSection:Toggle({ Title="Hitbox Expander", Value=false, Callback=function(v) setHitbox(v) end })
visionSection:Slider({ Title="Hitbox Size", Value={Min=2,Max=15,Default=Infra.Values.HitboxSize}, Callback=function(val) Infra.Values.HitboxSize=val if Infra.Flags.Hitbox then setHitbox(true) end end })
visionSection:Slider({ Title="FOV", Value={Min=60,Max=120,Default=Infra.Values.FOV}, Callback=function(val) Infra.Values.FOV=val end })

-- Utility Tab
local utilSection = Tabs.Utility:Section({ Title = "Utility" })
utilSection:Toggle({ Title="Speed Boost", Value=false, Callback=function(v) Infra.Flags.SpeedBoost=v end })
utilSection:Slider({ Title="Speed", Value={Min=0.01,Max=0.1,Default=Infra.Values.Speed}, Callback=function(val) Infra.Values.Speed=val end })
utilSection:Toggle({ Title="Auto Reload", Value=false, Callback=function(v) Infra.Flags.AutoReload=v if v then task.spawn(autoReloadLoop) end end })
utilSection:Toggle({ Title="Auto Knife", Value=false, Callback=function(v) Infra.Flags.AutoKnife=v if v then task.spawn(autoKnifeLoop) end end })
utilSection:Button({ Title="Teleport Safe Zone", Callback=function() if Workspace:FindFirstChild("SafeZone") then HRP.CFrame=Workspace.SafeZone.CFrame+Vector3.new(0,5,0) end end })

-- Credits Tab
local creditsSection = Tabs.Credits:Section({ Title = "Developer Info" })
creditsSection:Label("Project Infra - Arsenal Hub")
creditsSection:Label("Developer: xylo")
creditsSection:Button({ Title="Join Discord", Callback=function() setclipboard("https://discord.gg/5EJmv76J") end })
