-- Booga Booga Reborn GUI with ESP, Fast Kill Aura, Auto-Loot, Teleport, Key System

local expectedKey = "TEST1234" -- 🔑 Set your custom key here
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local function promptKey()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0, 30)
    input.Position = UDim2.new(0.1, 0, 0.4, 0)
    input.PlaceholderText = "Enter key..."
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.new(1, 1, 1)

    local submit = Instance.new("TextButton", frame)
    submit.Size = UDim2.new(0.8, 0, 0, 30)
    submit.Position = UDim2.new(0.1, 0, 0.7, 0)
    submit.Text = "Submit"
    submit.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    submit.TextColor3 = Color3.new(1, 1, 1)

    submit.MouseButton1Click:Connect(function()
        if input.Text == expectedKey then
            gui:Destroy()
            loadGUI()
        else
            submit.Text = "Wrong Key!"
            submit.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end)
end

function loadGUI()
    local Window = Library.CreateLib("Booga Suite", "Midnight")
    local combat = Window:NewTab("Combat"):NewSection("Combat Tools")
    local utility = Window:NewTab("Utility"):NewSection("ESP & Teleport")

    getgenv().killAuraEnabled = false
    getgenv().aimbotEnabled = false
    getgenv().espEnabled = false
    getgenv().autoLootEnabled = false
    getgenv().killAuraRange = 15
    getgenv().predictionStrength = 1.0
    getgenv().hitboxSize = 3.0

    combat:NewToggle("Kill Aura", "Fast auto-hit", function(state)
        getgenv().killAuraEnabled = state
    end)

    combat:NewSlider("Kill Aura Range", "Distance to hit", 30, 5, function(val)
        getgenv().killAuraRange = val
    end)

    combat:NewToggle("Aimbot", "Locks aim above head", function(state)
        getgenv().aimbotEnabled = state
    end)

    combat:NewSlider("Prediction Strength", "Arrow drop compensation", 5, 1, function(val)
        getgenv().predictionStrength = val
    end)

    combat:NewSlider("Hitbox Size", "Resize enemy hitboxes", 10, 1, function(val)
        getgenv().hitboxSize = val
    end)

    utility:NewToggle("ESP Boxes", "Draw boxes on players", function(state)
        getgenv().espEnabled = state
    end)

    utility:NewToggle("Auto-Loot", "Grab nearby items", function(state)
        getgenv().autoLootEnabled = state
    end)

    utility:NewButton("Teleport to Random Player", "TP to a random player", function()
        local targets = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p.Character.HumanoidRootPart)
            end
        end
        if #targets > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targets[math.random(1, #targets)].CFrame + Vector3.new(0, 5, 0)
        end
    end)
end

promptKey()

-- Background logic
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end

    -- Kill Aura
    if getgenv().killAuraEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                if part and (part.Position - char.HumanoidRootPart.Position).Magnitude < getgenv().killAuraRange then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end

    -- ESP
    if getgenv().espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if not head:FindFirstChild("ESPBox") then
                    local box = Instance.new("BoxHandleAdornment", head)
                    box.Name = "ESPBox"
                    box.Size = Vector3.new(2, 2, 2)
                    box.Adornee = head
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Color3 = Color3.new(1, 0, 0)
                    box.Transparency = 0.5
                end
            end
        end
    end

    -- Auto-Loot
    if getgenv().autoLootEnabled then
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") and (item.Position - char.HumanoidRootPart.Position).Magnitude < 10 then
                firetouchinterest(char.HumanoidRootPart, item, 0)
                firetouchinterest(char.HumanoidRootPart, item, 1)
            end
        end
    end
end)
