-- SlideursHub-inspired Booga GUI (Clean, Custom UI)

local expectedKey = "gooning123"

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
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Active = true
    frame.Draggable = true

    local function makeToggle(name, y, default, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 280, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Text = name .. ": " .. (default and "ON" or "OFF")
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.MouseButton1Click:Connect(function()
            default = not default
            btn.Text = name .. ": " .. (default and "ON" or "OFF")
            btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
            callback(default)
        end)
    end

    makeToggle("Kill Aura", 10, false, function(state) getgenv().killAura = state end)
    makeToggle("ESP Boxes", 50, false, function(state) getgenv().esp = state end)
    makeToggle("Auto-Loot", 90, false, function(state) getgenv().autoLoot = state end)
    makeToggle("Auto-Heal", 130, false, function(state) getgenv().autoHeal = state end)
    makeToggle("Anti-AFK", 170, false, function(state)
        if state then
            for _, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                v:Disable()
            end
        end
    end)

    local tpBtn = Instance.new("TextButton", frame)
    tpBtn.Size = UDim2.new(0, 280, 0, 30)
    tpBtn.Position = UDim2.new(0, 10, 0, 210)
    tpBtn.Text = "Teleport to Random Player"
    tpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 170)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Font = Enum.Font.SourceSansBold
    tpBtn.TextSize = 18
    tpBtn.MouseButton1Click:Connect(function()
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
    if getgenv().killAura then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                if part and (part.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end

    -- ESP
    if getgenv().esp then
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
    if getgenv().autoLoot then
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") and (item.Position - char.HumanoidRootPart.Position).Magnitude < 10 then
                firetouchinterest(char.HumanoidRootPart, item, 0)
                firetouchinterest(char.HumanoidRootPart, item, 1)
            end
        end
    end

    -- Auto-Heal
    if getgenv().autoHeal then
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health < 50 then
            hum.Health = hum.Health + 5
        end
    end
end)

