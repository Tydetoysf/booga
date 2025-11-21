-- Project Infra — BedWars Hub
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

local Infra = {
    Flags = {
        KillAura=false, Triggerbot=false, SilentAim=false,
        ESP=false, BedESP=false, ResourceESP=false, Hitbox=false,
        AutoFarm=false, AutoBuy=false, AutoHeal=false, LootMagnet=false,
        SpeedBoost=false, Fly=false, Noclip=false, LongJump=false, HighJump=false, InfJump=false,
    },
    Values = {
        AuraRange=20, HitboxSize=5, Speed=0.03, FOV=90,
    }
}

-- Combat Logic
local function killAuraLoop()
    while Infra.Flags.KillAura do
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist=(HRP.Position-plr.Character.HumanoidRootPart.Position).Magnitude
                if dist<Infra.Values.AuraRange then
                    local ev=ReplicatedStorage:FindFirstChild("AttackRemote")
                    if ev then ev:FireServer(plr.Character) end
                end
            end
        end
        task.wait(0.2)
    end
end

local function triggerbotLoop()
    while Infra.Flags.Triggerbot do
        local mouse=LocalPlayer:GetMouse()
        if mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
            mouse1click()
        end
        task.wait(0.1)
    end
end

local function setHitbox(state)
    Infra.Flags.Hitbox=state
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=plr.Character.HumanoidRootPart
            hrp.Size=state and Vector3.new(Infra.Values.HitboxSize,Infra.Values.HitboxSize,Infra.Values.HitboxSize) or Vector3.new(2,2,1)
        end
    end
end

-- Vision Logic
local espMap={}
local function setESP(state)
    Infra.Flags.ESP=state
    for _,h in pairs(espMap) do h:Destroy() end
    table.clear(espMap)
    if not state then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character then
            local hl=Instance.new("Highlight")
            hl.FillColor=Infra.Values.ESPColor
            hl.OutlineColor=Infra.Values.ESPColor
            hl.Adornee=plr.Character
            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent=plr.Character
            espMap[plr]=hl
        end
    end
end

local function setBedESP(state)
    Infra.Flags.BedESP=state
    for _,bed in ipairs(Workspace:GetDescendants()) do
        if bed:IsA("BasePart") and bed.Name:lower():find("bed") then
            if state then
                local hl=Instance.new("Highlight")
                hl.FillColor=Color3.fromRGB(255,255,0)
                hl.Adornee=bed
                hl.Parent=bed
            else
                for _,h in ipairs(bed:GetChildren()) do
                    if h:IsA("Highlight") then h:Destroy() end
                end
            end
        end
    end
end

-- Utility Logic
local function autoFarmLoop()
    while Infra.Flags.AutoFarm do
        for _,genName in ipairs({"Iron","Diamond","Emerald"}) do
            local gen=Workspace:FindFirstChild(genName.."Generator")
            if gen then
                HRP.CFrame=gen.CFrame+Vector3.new(0,3,0)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end

local function autoHealLoop()
    while Infra.Flags.AutoHeal do
        if Humanoid.Health<50 then Humanoid.Health=Humanoid.MaxHealth end
        task.wait(1)
    end
end

local function lootMagnetLoop()
    while Infra.Flags.LootMagnet do
        for _,obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("drop") then
                obj.CFrame=HRP.CFrame+Vector3.new(math.random(-2,2),2,math.random(-2,2))
            end
        end
        task.wait(0.2)
    end
end

local function teleportTo(location)
    if Workspace:FindFirstChild(location) then
        HRP.CFrame=Workspace[location].CFrame+Vector3.new(0,5,0)
    end
end

-- Movement Logic
RunService.RenderStepped:Connect(function()
    if Infra.Flags.SpeedBoost and Character and HRP and Humanoid then
        local dir=Humanoid.MoveDirection
        if dir.Magnitude>0 then
            HRP.CFrame=HRP.CFrame+(dir.Unit*Infra.Values.Speed)
        end
    end
end)

local flyConn
local function setFly(state)
    Infra.Flags.Fly=state
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if not state then return end
    flyConn=RunService.RenderStepped:Connect(function()
        HRP.Velocity=Vector3.new(0,50,0)
    end)
end

local function setNoclip(state)
    Infra.Flags.Noclip=state
    for _,part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide=not state
        end
    end
end

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if Infra.Flags.InfJump and input.KeyCode==Enum.KeyCode.Space then
        HRP.Velocity=Vector3.new(0,50,0)
    end
end)

-- UI Tabs
local Tabs={
    Combat=Window:Tab({Title="Combat",Icon="sword"}),
    Vision=Window:Tab({Title="Vision",Icon="eye"}),
    Utility=Window:Tab({Title="Utility",Icon="tool"}),
    Movement=Window:Tab({Title="Movement",Icon="zap"}),
    Credits=Window:Tab({Title="Credits",Icon="script"}),
}
Window:SelectTab(1)

-- Combat Tab
local combatSection=Tabs.Combat:Section({Title="Combat Tools"})
combatSection:Toggle({Title="Kill Aura",Value=false,Callback=function(v) Infra.Flags.KillAura=v if v then task.spawn(killAuraLoop) end end})
combatSection:Slider({Title="Aura Range",Value={Min=5,Max=50,Default=Infra.Values.AuraRange},Callback=function(val) Infra.Values.AuraRange=val end})
combatSection:Toggle({Title="Triggerbot (Bow)",Value=false,Callback=function(v) Infra.Flags.Triggerbot=v if v then task.spawn(triggerbotLoop) end end})
combatSection:Toggle({Title="Silent Aim",Value=false,Callback=function(v) Infra.Flags.SilentAim=v end})
combatSection:Toggle({Title="Hitbox Expander",Value=false,Callback=function(v) setHitbox(v) end})
combatSection:Slider({Title="Hitbox Size",Value={Min=2,Max=15,Default=Infra.Values.HitboxSize},Callback=function(val) Infra.Values.HitboxSize=val if Infra.Flags.Hitbox then setHitbox(true) end end})

-- Vision Tab
local visionSection=Tabs.Vision:Section({Title="Visuals"})
visionSection:Toggle({Title="Player ESP",Value=false,Callback=function(v) setESP(v) end})
visionSection:Toggle({Title="Bed ESP",Value=false,Callback=function(v) setBedESP(v) end})
visionSection:Toggle({Title="Resource ESP",Value=false,Callback=function(v) Infra.Flags.ResourceESP=v end})
visionSection:Slider({Title="FOV",Value={Min=60,Max=120,Default=Infra.Values.FOV},Callback=function(val) Infra.Values.FOV=val end})

-- Utility Tab
local utilSection=Tabs.Utility:Section({Title="Utility"})
utilSection:Toggle({Title="Auto Farm Generators",Value=false,Callback=function(v) Infra.Flags.AutoFarm=v if v then task.spawn(autoFarmLoop) end end})
utilSection:Toggle({Title="Auto Buy",Value=false,Callback=function(v) Infra.Flags.AutoBuy=v end})
utilSection:Toggle({Title="Auto Heal",Value=false,Callback=function(v) Infra.Flags.AutoHeal=v if v then task.spawn 
utilSection:Toggle({
    Title="Auto Heal",
    Value=false,
    Callback=function(v)
        Infra.Flags.AutoHeal=v
        if v then task.spawn(autoHealLoop) end
    end
})
utilSection:Toggle({
    Title="Loot Magnet",
    Value=false,
    Callback=function(v)
        Infra.Flags.LootMagnet=v
        if v then task.spawn(lootMagnetLoop) end
    end
})
utilSection:Dropdown({
    Title="Teleport Menu",
    Values={"Shop","DiamondGen","EmeraldGen","EnemyBase","Bed"},
    Default="Shop",
    Callback=function(val)
        teleportTo(val)
    end
})

-- Movement Tab
local moveSection=Tabs.Movement:Section({Title="Movement"})
moveSection:Toggle({
    Title="Speed Boost",
    Value=false,
    Callback=function(v) Infra.Flags.SpeedBoost=v end
})
moveSection:Slider({
    Title="Speed",
    Value={Min=0.01,Max=0.1,Default=Infra.Values.Speed},
    Callback=function(val) Infra.Values.Speed=val end
})
moveSection:Toggle({
    Title="Fly",
    Value=false,
    Callback=function(v) setFly(v) end
})
moveSection:Toggle({
    Title="Noclip",
    Value=false,
    Callback=function(v) setNoclip(v) end
})
moveSection:Toggle({
    Title="Long Jump",
    Value=false,
    Callback=function(v) Infra.Flags.LongJump=v end
})
moveSection:Toggle({
    Title="High Jump",
    Value=false,
    Callback=function(v) Infra.Flags.HighJump=v end
})
moveSection:Toggle({
    Title="Infinite Jump",
    Value=false,
    Callback=function(v) Infra.Flags.InfJump=v end
})

-- Credits Tab
local creditsSection=Tabs.Credits:Section({Title="Developer Info"})
creditsSection:Label("Project Infra - BedWars Hub")
creditsSection:Label("Developer: xylo")
creditsSection:Button({
    Title="Join Discord",
    Callback=function() setclipboard("https://discord.gg/yourinvite") end
})
