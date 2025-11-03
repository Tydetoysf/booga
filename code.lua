-- Booga Booga Reborn GUI with Custom Key System + Kavo UI

local expectedKey = "TEST1234" -- 🔑 Set your custom key here
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local function promptKey()
    local keyGui = Instance.new("ScreenGui", game.CoreGui)
    keyGui.Name = "KeyPrompt"

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Enter Script Key"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0, 30)
    input.Position = UDim2.new(0.1, 0, 0.4, 0)
    input.PlaceholderText = "Enter key..."
    input.Text = ""
    input.TextColor3 = Color3.new(1, 1, 1)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 18

    local submit = Instance.new("TextButton", frame)
    submit.Size = UDim2.new(0.8, 0, 0, 30)
    submit.Position = UDim2.new(0.1, 0, 0.7, 0)
    submit.Text = "Submit"
    submit.TextColor3 = Color3.new(1, 1, 1)
    submit.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    submit.Font = Enum.Font.SourceSansBold
    submit.TextSize = 18

    submit.MouseButton1Click:Connect(function()
        if input.Text == expectedKey then
            keyGui:Destroy()
            loadGUI()
        else
            submit.Text = "Wrong Key!"
            submit.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end)
end

function loadGUI()
    local Window = Library.CreateLib("Booga Suite", "Midnight")
    local combatTab = Window:NewTab("Combat")
    local combat = combatTab:NewSection("Combat Tools")

    combat:NewToggle("Kill Aura", "Auto-damages nearby players", function(state)
        getgenv().killAuraEnabled = state
    end)

    combat:NewSlider("Kill Aura Range", "Set kill aura distance", 30, 5, function(val)
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

    local utilityTab = Window:NewTab("Utility")
    local utility = utilityTab:NewSection("Teleport & Misc")

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

    utility:NewToggle("Anti-AFK", "Prevents idle kick", function(state)
        if state then
            for _, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                v:Disable()
            end
        end
    end)
end

-- Start key prompt
promptKey()

-- Background logic
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    if getgenv().killAuraEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                if part and (part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (getgenv().killAuraRange or 15) then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)
