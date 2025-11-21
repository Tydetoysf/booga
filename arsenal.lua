local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/addons/SaveManager.lua'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "Project Infra | Arsenal | discord.gg/cG6VUgKnzU",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

-- tabs
local Tabs = {
    Main = Window:AddTab("Main"),
    Extra = Window:AddTab("Extras"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}

-- groupboxes container
local AimbotBox = Tabs.Main:AddLeftGroupbox('Aimbot')
local FOVBox = Tabs.Main:AddRightGroupbox('FOV')
local ESPBox = Tabs.Main:AddRightGroupbox('ESP')
local HitboxGroupbox = Tabs.Main:AddLeftGroupbox("Hitbox")
local TriggerbotGroupBox = Tabs.Main:AddRightGroupbox('Triggerbot')
local PlayerGroupbox = Tabs.Extra:AddLeftGroupbox('Player')
local GunModsGroupbox = Tabs.Extra:AddRightGroupbox('Gun Mods')
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- a part of the toggles etc
AimbotBox:AddToggle('AimbotEnabled', { Text = 'Enabled [Hold]', Default = false, Tooltip = 'Toggle the aimbot' })
AimbotBox:AddLabel('Keybind'):AddKeyPicker('AimbotKeybind', { Default = 'MB2', Mode = 'Hold', Text = 'Aimbot Keybind' })
AimbotBox:AddToggle('VisibilityCheck', {Text = 'Visibility Check', Default = false, Tooltip = 'Only aim at visible targets'})
AimbotBox:AddToggle('TeamCheck', {Text = 'Team Check', Default = false, Tooltip = 'Ignore teammates'})
AimbotBox:AddToggle('OffAfterKill', {Text = 'Off After Kill', Default = false, Tooltip = 'Disable aimbot after kill, requires holding keybind again'})
AimbotBox:AddToggle('HighlightTarget', {Text = 'Highlight Target', Default = false, Tooltip = 'Highlight the locked target'})
AimbotBox:AddLabel('Highlight Color'):AddColorPicker('HighlightColor', {Default = Color3.new(1, 1, 1), Title = 'Highlight Color', Tooltip = 'Color for the target highlight'})
AimbotBox:AddToggle('HitpartSwitcher', {Text = 'Hitpart Switcher', Default = false, Tooltip = 'Switch between hitparts'})
AimbotBox:AddSlider('SwitchDelay', {Text = 'Switch Delay', Default = 1, Min = 0.1, Max = 5, Rounding = 1, Suffix = 's', Tooltip = 'Delay between hit part switches'})
AimbotBox:AddDivider()
AimbotBox:AddSlider('MaxDistance', {Text = 'Max Distance', Default = 300, Min = 20, Max = 1000, Rounding = 0, Tooltip = 'Maximum aimbot distance'})
AimbotBox:AddSlider('SmoothnessX', {Text = 'Smoothness X', Default = 0, Min = 0, Max = 10, Rounding = 2, Tooltip = 'Smoothness horizontal'})
AimbotBox:AddSlider('SmoothnessY', {Text = 'Smoothness Y', Default = 0, Min = 0, Max = 10, Rounding = 2, Tooltip = 'Smoothness vertical'})
AimbotBox:AddDropdown('Hitpart', {Text = 'Hitpart', Values = {'Head', 'HumanoidRootPart'}, Default = 1, Multi = false, Tooltip = 'Part to aim at'})
AimbotBox:AddDropdown('Method', {Text = 'Method', Values = {'Closest To Mouse', 'Closest Distance'}, Default = 1, Multi = false, Tooltip = 'Target selection method'})
AimbotBox:AddDropdown('Mode', {Text = 'Mode', Values = {'CFrame', 'Raycast'}, Default = 'CFrame', Multi = false, Tooltip = 'Aim mode'})
FOVBox:AddToggle('FOVEnabled', {Text = 'Enabled', Default = false, Tooltip = 'Enable FOV circle'})
FOVBox:AddToggle('FOVVisible', {Text = 'Visible', Default = false, Tooltip = 'Show circle outline'})
FOVBox:AddToggle('FOVFilled', {Text = 'Filled', Default = false, Tooltip = 'Fill circle'})
FOVBox:AddLabel('FOV Color'):AddColorPicker('FOVColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Circle Line Color', Tooltip = 'Color of FOV circle line'})
FOVBox:AddLabel('Fill Color'):AddColorPicker('FOVFillColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Fill Color', Tooltip = 'Color of FOV circle fill'})
FOVBox:AddSlider('FOVSize', {Text = 'Size', Default = 100, Min = 25, Max = 300, Rounding = 0, Tooltip = 'FOV circle radius'})
FOVBox:AddSlider('FOVTransparency', {Text = 'Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 2, Tooltip = 'FOV fill transparency'})
ESPBox:AddToggle('ESPTeamCheck', {Text = 'Team Check', Default = false, Tooltip = 'Disable ESP for teammates'})
ESPBox:AddToggle('ESPTeamColors', {Text = 'Team Colors', Default = false, Tooltip = 'Use team color for ESP'})
ESPBox:AddDivider()
ESPBox:AddToggle('ESPBox', {Text = 'Box', Default = false, Tooltip = 'Enable box ESP'})
ESPBox:AddToggle('ESPBoxFilled', {Text = 'Filled', Default = false, Tooltip = 'Fill box'})
ESPBox:AddSlider('ESPBoxFillTransparency', {Text = 'Fill Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 2, Tooltip = 'Transparency of box fill'})
ESPBox:AddToggle('ESPHealthBar', {Text = 'Health Bar', Default = false, Tooltip = 'Show health bar ESP'})
ESPBox:AddToggle('ESPTracer', {Text = 'Tracer', Default = false, Tooltip = 'Show tracer ESP'})
ESPBox:AddDropdown('TracerOrigin', {Text = 'Tracer Origin', Values = {'Mouse', 'Bottom', 'Top'}, Default = 1, Multi = false, Tooltip = 'Select the origin of the tracer line'})
ESPBox:AddToggle('ESPNames', {Text = 'Name', Default = false, Tooltip = 'Show player names'})
ESPBox:AddToggle('ESPDistance', {Text = 'Distance', Default = false, Tooltip = 'Show player distance (studs)'})
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('cloudware')
SaveManager:SetFolder('cloudware/configs')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
Library.ToggleKeybind = Options.MenuKeybind

local espObjects = {}
local lastHitpartSwitchTick = 0
local currentHitpartIndex = 1
local hitpartsList = {"Head", "HumanoidRootPart"}
local lockedTarget = nil
local highlightTargetInstance = nil
local isAlive = true

local function bool(opt) return opt and opt.Value end

local function checkhealth()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.HealthChanged:Connect(function(health)
            isAlive = health > 0
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(checkhealth)
if LocalPlayer.Character then
    checkhealth()
end


local function lerpAngle(startAngle,endAngle,t)
    local diff = endAngle - startAngle
    if diff > math.pi then diff = diff - 2*math.pi end
    if diff < -math.pi then diff = diff + 2*math.pi end
    return startAngle + diff * t
end

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local dir = (part.Position - origin)
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.IgnoreWater = true
    local hit = workspace:Raycast(origin, dir, rp)
    return hit and hit.Instance:IsDescendantOf(part.Parent)
end

local function IsInFOV(pos)
    if not (Toggles.FOVEnabled and Toggles.FOVEnabled.Value) then return true end
    local mouse = UserInputService:GetMouseLocation()
    local screen, onScreen = Camera:WorldToViewportPoint(pos)
    if not onScreen then return false end
    local dist = (Vector2.new(screen.X, screen.Y) - mouse).Magnitude
    return dist <= (Options.FOVSize and Options.FOVSize.Value or 100)
end

local function WithinMaxDistance(pos)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not hrp then return false end
    local dist = (pos - hrp.Position).Magnitude
    return dist <= (Options.MaxDistance and Options.MaxDistance.Value or 300)
end

local function IsValidTarget(player)
    if not player or not player.Character then return false end
    local hitPartName = Options.Hitpart and Options.Hitpart.Value or 'Head'
    local part = player.Character:FindFirstChild(hitPartName)
    if not part then return false end
    local human = player.Character:FindFirstChildOfClass('Humanoid')
    if not human or human.Health <= 0 then return false end
    if bool(Toggles.TeamCheck) and player.Team == LocalPlayer.Team then return false end
    if bool(Toggles.VisibilityCheck) and not IsVisible(part) then return false end
    if not WithinMaxDistance(part.Position) then return false end
    return true
end

local function GetClosestToMouse()
    local mouse = UserInputService:GetMouseLocation()
    local closestPlayer, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then
            local hitPart = player.Character:FindFirstChild(Options.Hitpart and Options.Hitpart.Value or 'Head')
            if hitPart and IsInFOV(hitPart.Position) then
                local screen, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X, screen.Y) - mouse).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function GetClosestByDistance()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not hrp then return nil end
    local localPos = hrp.Position
    local closestPlayer, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then
            local hitPart = player.Character:FindFirstChild(Options.Hitpart and Options.Hitpart.Value or 'Head')
            if hitPart and IsInFOV(hitPart.Position) then
                local dist = (hitPart.Position - localPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function smoothAim(targetPos, camPosVec)
    local smoothX = Options.SmoothnessX and Options.SmoothnessX.Value or 0
    local smoothY = Options.SmoothnessY and Options.SmoothnessY.Value or 0

    local desiredLook = (targetPos - camPosVec).Unit
    local currentLook = Camera.CFrame.LookVector

    if desiredLook.Magnitude < 0.01 or currentLook.Magnitude < 0.01 then
        Camera.CFrame = CFrame.new(camPosVec, targetPos)
        return
    end

    local currentYaw = math.atan2(currentLook.Z, currentLook.X)
    local desiredYaw = math.atan2(desiredLook.Z, desiredLook.X)
    local yawDiff = desiredYaw - currentYaw
    if yawDiff > math.pi then yawDiff = yawDiff - 2*math.pi end
    if yawDiff < -math.pi then yawDiff = yawDiff + 2*math.pi end

    local currentPitch = math.asin(currentLook.Y)
    local desiredPitch = math.asin(desiredLook.Y)
    local pitchDiff = desiredPitch - currentPitch

    local lerpX = smoothX == 0 and 1 or math.clamp(0.15/smoothX, 0, 1)
    local lerpY = smoothY == 0 and 1 or math.clamp(0.15/smoothY, 0, 1)

    local newYaw = lerpAngle(currentYaw, desiredYaw, lerpX)
    local newPitch = lerpAngle(currentPitch, desiredPitch, lerpY)

    local newLookVector = Vector3.new(
        math.cos(newPitch)*math.cos(newYaw),
        math.sin(newPitch),
        math.cos(newPitch)*math.sin(newYaw)
    )

    Camera.CFrame = CFrame.new(camPosVec, camPosVec + newLookVector)
end

local function GetPlayerColor(player)
    if bool(Toggles.ESPTeamColors) and player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    else
        return Color3.fromRGB(255, 255, 255)
    end
end

local function CreateESPObjects(player)
    local boxOutline = Drawing.new("Square")
    boxOutline.Color = Color3.new(0,0,0)
    boxOutline.Filled = false
    boxOutline.Thickness = 0.3

    local box = Drawing.new("Square")
    box.Color = Color3.new(1,1,1)
    box.Filled = bool(Toggles.ESPBoxFilled) and Toggles.ESPBoxFilled.Value or false
    box.Thickness = 2

    local healthBar = Drawing.new("Line")
    healthBar.Color = Color3.new(0,1,0)
    healthBar.Thickness = 2

    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(1,1,1)
    tracer.Thickness = 2

    local nameText = Drawing.new("Text")
    nameText.Color = Color3.new(1,1,1)
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = false
    nameText.Text = ""

    local distanceText = Drawing.new("Text")
    distanceText.Color = Color3.new(1,1,1)
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Visible = false
    distanceText.Text = ""

    espObjects[player] = {
        BoxOutline = boxOutline,
        Box = box,
        HealthBar = healthBar,
        Tracer = tracer,
        NameText = nameText,
        DistanceText = distanceText
    }
end

local function RemoveESP(player)
    local esp = espObjects[player]
    if esp then
        for _, obj in pairs(esp) do
            if obj and obj.Visible ~= nil then
                obj:Remove()
            end
        end
        espObjects[player] = nil
    end
end

local FIXED_BOX_SIZE = 50

local function UpdateESPBoxes()
    if not Camera then return end
    local camPos = Camera.CFrame.Position
    local viewportSize = Camera.ViewportSize
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            RemoveESP(player)
            continue
        end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            RemoveESP(player)
            continue
        end
        if bool(Toggles.ESPTeamCheck) and player.Team == LocalPlayer.Team then
            RemoveESP(player)
            continue
        end

        if not espObjects[player] then
            CreateESPObjects(player)
        end

        local esp = espObjects[player]
        local hrp = char.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            for _, obj in pairs(esp) do
                if obj then
                    obj.Visible = false
                end
            end
            continue
        end

        local color = GetPlayerColor(player)
        esp.BoxOutline.Color = Color3.new(0, 0, 0)
        esp.BoxOutline.Thickness = 0.3
        esp.Box.Color = color
        esp.HealthBar.Color = Color3.new(0, 1, 0)
        esp.Tracer.Color = color
        esp.NameText.Color = color
        esp.DistanceText.Color = color

        local size = FIXED_BOX_SIZE
        local x = screenPos.X - size / 2
        local y = screenPos.Y - size / 2

        if esp.BoxOutline then
            esp.BoxOutline.Position = Vector2.new(x - 1, y - 1)
            esp.BoxOutline.Size = Vector2.new(size + 2, size + 2)
            esp.BoxOutline.Visible = bool(Toggles.ESPBox)
        end

        if esp.Box then
            esp.Box.Position = Vector2.new(x, y)
            esp.Box.Size = Vector2.new(size, size)
            esp.Box.Filled = bool(Toggles.ESPBoxFilled)
            esp.Box.Transparency = 1 - (Options.ESPBoxFillTransparency and Options.ESPBoxFillTransparency.Value or 0.5)
            esp.Box.Visible = bool(Toggles.ESPBox)
        end

        local healthPercentage = char.Humanoid.Health / char.Humanoid.MaxHealth
        local healthBarHeight = size * healthPercentage

        if esp.HealthBar then
            esp.HealthBar.From = Vector2.new(x - 6, y + size)
            esp.HealthBar.To = Vector2.new(x - 6, y + size - healthBarHeight)
            esp.HealthBar.Visible = bool(Toggles.ESPHealthBar)
        end

        if esp.Tracer then
            if bool(Toggles.ESPTracer) then
                local tracerOrigin = Options.TracerOrigin and Options.TracerOrigin.Value or "Mouse"
                local tracerStartPos
                if tracerOrigin == "Mouse" then
                    tracerStartPos = mousePos
                elseif tracerOrigin == "Bottom" then
                    tracerStartPos = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                elseif tracerOrigin == "Top" then
                    tracerStartPos = Vector2.new(viewportSize.X / 2, 0)
                else
                    tracerStartPos = mousePos
                end
                esp.Tracer.From = tracerStartPos
                esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                esp.Tracer.Visible = true
            else
                esp.Tracer.Visible = false
                esp.Tracer.From = Vector2.new(0,0)
                esp.Tracer.To = Vector2.new(0,0)
            end
        end

        if esp.NameText then
            esp.NameText.Position = Vector2.new(screenPos.X, y - 15)
            esp.NameText.Text = player.Name
            esp.NameText.Visible = bool(Toggles.ESPNames)
        end

        if esp.DistanceText then
            local distanceStuds = math.floor((camPos - hrp.Position).Magnitude)
            esp.DistanceText.Position = Vector2.new(screenPos.X, y + size + 5)
            esp.DistanceText.Text = distanceStuds .. " studs"
            esp.DistanceText.Visible = bool(Toggles.ESPDistance)
        end
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

local circle = Drawing.new("Circle")
circle.Thickness = 1
circle.NumSides = 128
circle.Filled = false
circle.Visible = false
circle.Color = Color3.new(1,1,1)

local fillCircle = Drawing.new("Circle")
fillCircle.Thickness = 1
fillCircle.NumSides = 128
fillCircle.Filled = true
fillCircle.Visible = false
fillCircle.Color = Color3.new(1,1,1)

RunService.RenderStepped:Connect(function(delta)
    if Toggles.FOVEnabled and Toggles.FOVEnabled.Value then
        local mousePos = UserInputService:GetMouseLocation()
        local size = Options.FOVSize and Options.FOVSize.Value or 100
        circle.Position = mousePos
        circle.Radius = size
        circle.Color = Options.FOVColor and Options.FOVColor.Value or Color3.new(1, 1, 1)
        circle.Visible = Toggles.FOVVisible and Toggles.FOVVisible.Value or false
        circle.Filled = false

        fillCircle.Position = mousePos
        fillCircle.Radius = size
        fillCircle.Color = Options.FOVFillColor and Options.FOVFillColor.Value or Color3.new(1,1,1)
        fillCircle.Visible = (Toggles.FOVVisible and Toggles.FOVVisible.Value and Toggles.FOVFilled and Toggles.FOVFilled.Value) or false
        fillCircle.Transparency = 1 - (Options.FOVTransparency and Options.FOVTransparency.Value or 0.5)
    else
        circle.Visible = false
        fillCircle.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    local isActive = bool(Toggles.AimbotEnabled) and Options.AimbotKeybind and Options.AimbotKeybind:GetState()
    if isActive then
        if lockedTarget and not IsValidTarget(lockedTarget) then
            if bool(Toggles.OffAfterKill) then
                Toggles.AimbotEnabled:SetValue(false)
                lockedTarget = nil
            else
                lockedTarget = nil
            end
            if highlightTargetInstance then
                highlightTargetInstance:Destroy()
                highlightTargetInstance = nil
            end
        end

        if not lockedTarget then
            local method = Options.Method and Options.Method.Value or "Closest To Mouse"
            if method == "Closest To Mouse" then
                lockedTarget = GetClosestToMouse()
            elseif method == "Closest Distance" then
                lockedTarget = GetClosestByDistance()
            end
        end

        if lockedTarget then
            if bool(Toggles.HitpartSwitcher) then
                local now = tick()
                if now - lastHitpartSwitchTick >= (Options.SwitchDelay and Options.SwitchDelay.Value or 1) then
                    lastHitpartSwitchTick = now
                    currentHitpartIndex = currentHitpartIndex + 1
                    if currentHitpartIndex > #hitpartsList then
                        currentHitpartIndex = 1
                    end
                    Options.Hitpart:SetValue(hitpartsList[currentHitpartIndex])
                end
            else
                currentHitpartIndex = table.find(hitpartsList, Options.Hitpart.Value) or 1
            end

            if bool(Toggles.HighlightTarget) then
                if not (highlightTargetInstance and highlightTargetInstance.Parent == workspace and highlightTargetInstance.Adornee == lockedTarget.Character) then
                    if highlightTargetInstance then
                        highlightTargetInstance:Destroy()
                        highlightTargetInstance = nil
                    end
                    highlightTargetInstance = Instance.new("Highlight")
                    highlightTargetInstance.Adornee = lockedTarget.Character
                    highlightTargetInstance.FillColor = Options.HighlightColor.Value
                    highlightTargetInstance.OutlineColor = Options.HighlightColor.Value
                    highlightTargetInstance.FillTransparency = 0.6
                    highlightTargetInstance.OutlineTransparency = 0
                    highlightTargetInstance.Parent = workspace
                else
                    highlightTargetInstance.FillColor = Options.HighlightColor.Value
                    highlightTargetInstance.OutlineColor = Options.HighlightColor.Value
                end
            else
                if highlightTargetInstance then
                    highlightTargetInstance:Destroy()
                    highlightTargetInstance = nil
                end
            end

            local camPosVec = Camera.CFrame.Position
            local hitPartName = Options.Hitpart and Options.Hitpart.Value or "Head"
            local targetPart = lockedTarget.Character and lockedTarget.Character:FindFirstChild(hitPartName)
            if not targetPart then return end

            if Options.Mode and Options.Mode.Value == "Raycast" then
                local rayOrigin = camPosVec
                local rayDirection = (targetPart.Position - rayOrigin)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.IgnoreWater = true
                local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
                if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(lockedTarget.Character) then
                    smoothAim(targetPart.Position, camPosVec)
                end
            else
                smoothAim(targetPart.Position, camPosVec)
            end
        end
    else
        lockedTarget = nil
        if highlightTargetInstance then
            highlightTargetInstance:Destroy()
            highlightTargetInstance = nil
        end
    end
    UpdateESPBoxes()
end)

local flySettings = {fly = false, flyspeed = 50}
local c, h, bv, bav, cam, flying
local buttons = {W = false, S = false, A = false, D = false, Moving = false}
local p = LocalPlayer

local function startFly()
    if not p.Character or not p.Character:FindFirstChild("Head") or flying then return end
    c = p.Character
    h = c:FindFirstChildOfClass("Humanoid")
    h.PlatformStand = true
    cam = workspace:WaitForChild("Camera")
    bv = Instance.new("BodyVelocity")
    bav = Instance.new("BodyAngularVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(10000, 10000, 10000)
    bv.P = 1000
    bav.AngularVelocity = Vector3.new(0, 0, 0)
    bav.MaxTorque = Vector3.new(10000, 10000, 10000)
    bav.P = 1000
    bv.Parent = c.Head
    bav.Parent = c.Head
    flying = true
    h.Died:Connect(function() flying = false end)
end

local function endFly()
    if not p.Character or not flying then return end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand = false end
    if bv then bv:Destroy() end
    if bav then bav:Destroy() end
    flying = false
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    for k, _ in pairs(buttons) do
        if k ~= "Moving" and input.KeyCode == Enum.KeyCode[k] then
            buttons[k] = true
            buttons.Moving = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    local moving = false
    for k, _ in pairs(buttons) do
        if k ~= "Moving" then
            if input.KeyCode == Enum.KeyCode[k] then
                buttons[k] = false
            end
            if buttons[k] then moving = true end
        end
    end
    buttons.Moving = moving
end)

local function setVec(vec)
    return vec * (flySettings.flyspeed / vec.Magnitude)
end

RunService.Heartbeat:Connect(function(step)
    if flying and c and c.PrimaryPart then
        local ppos = c.PrimaryPart.Position
        local cf = cam.CFrame
        local ax, ay, az = cf:ToEulerAnglesXYZ()
        c:SetPrimaryPartCFrame(CFrame.new(ppos) * CFrame.Angles(ax, ay, az))
        if buttons.Moving then
            local t = Vector3.new()
            if buttons.W then t = t + setVec(cf.LookVector) end
            if buttons.S then t = t - setVec(cf.LookVector) end
            if buttons.A then t = t - setVec(cf.RightVector) end
            if buttons.D then t = t + setVec(cf.RightVector) end
            c:TranslateBy(t * step)
        end
    end
end)

PlayerGroupbox:AddToggle("Fly", {
    Text = "Fly",
    Tooltip = "Toggle flying",
    Callback = function(value)
        flySettings.fly = value
        if value then startFly() else endFly() end
    end,
})

PlayerGroupbox:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        flySettings.flyspeed = value
    end,
})

local isWalkSpeedEnabled = false
local settings = {WalkSpeed = 16}

PlayerGroupbox:AddToggle("WalkspeedModifier", {
    Text = "Walkspeed",
    Default = false,
    Tooltip = "Toggle custom walkspeed",
    Callback = function(value)
        isWalkSpeedEnabled = value
    end,
})

PlayerGroupbox:AddSlider("WalkspeedValue", {
    Text = "Walkspeed Value",
    Default = 16,
    Min = 0,
    Max = 500,
    Rounding = 1,
    Tooltip = "Adjust walkspeed value",
    Callback = function(value)
        settings.WalkSpeed = value
    end,
})

local walkMethods = {"Velocity", "Vector", "CFrame"}
local selectedWalkMethod = walkMethods[1]

PlayerGroupbox:AddDropdown("WalkMethod", {
    Values = walkMethods,
    Default = 1,
    Multi = false,
    Text = "Walk Method",
    Tooltip = "Select walk method",
    Callback = function(value)
        selectedWalkMethod = value
    end,
})

local function applyWalkSpeed(player, deltaTime)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        local VS = humanoid.MoveDirection * settings.WalkSpeed
        if selectedWalkMethod == "Velocity" then
            hrp.Velocity = Vector3.new(VS.X, hrp.Velocity.Y, VS.Z)
        elseif selectedWalkMethod == "Vector" then
            local scaleFactor = 0.0001
            hrp.CFrame = hrp.CFrame + (VS * deltaTime * scaleFactor)
        elseif selectedWalkMethod == "CFrame" then
            local scaleFactor = 0.0001
            hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * settings.WalkSpeed * deltaTime * scaleFactor)
        else
            humanoid.WalkSpeed = settings.WalkSpeed
        end
    end
end

RunService.Stepped:Connect(function(deltaTime)
    if isWalkSpeedEnabled then
        local plr = LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            applyWalkSpeed(plr, deltaTime)
        end
    end
end)

local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

GunModsGroupbox:AddToggle("InfiniteAmmo", {
    Text = "Infinite Ammo",
    Default = false,
    Tooltip = "Enable infinite ammo",
    Callback = function(state)
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = state and "Infinite Ammo" or ""
    end,
})

GunModsGroupbox:AddToggle("FastReload", {
    Text = "Fast Reload",
    Default = false,
    Tooltip = "Fast reload weapons",
    Callback = function(state)
        for _, weapon in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if weapon:FindFirstChild("ReloadTime") then
                if state then
                    if not originalValues.ReloadTime[weapon] then originalValues.ReloadTime[weapon] = weapon.ReloadTime.Value end
                    weapon.ReloadTime.Value = 0.01
                else
                    weapon.ReloadTime.Value = originalValues.ReloadTime[weapon] or 0.8
                end
            end
            if weapon:FindFirstChild("EReloadTime") then
                if state then
                    if not originalValues.EReloadTime[weapon] then originalValues.EReloadTime[weapon] = weapon.EReloadTime.Value end
                    weapon.EReloadTime.Value = 0.01
                else
                    weapon.EReloadTime.Value = originalValues.EReloadTime[weapon] or 0.8
                end
            end
        end
    end,
})

GunModsGroupbox:AddToggle("FastFireRate", {
    Text = "Fast Fire Rate",
    Default = false,
    Tooltip = "Increase fire rate of weapons",
    Callback = function(state)
        for _, desc in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if desc.Name == "FireRate" or desc.Name == "BFireRate" then
                if state then
                    if not originalValues.FireRate[desc] then originalValues.FireRate[desc] = desc.Value end
                    desc.Value = 0.02
                else
                    desc.Value = originalValues.FireRate[desc] or 0.8
                end
            end
        end
    end,
})

GunModsGroupbox:AddToggle("AlwaysAuto", {
    Text = "Always Auto",
    Default = false,
    Tooltip = "Enable automatic firing",
    Callback = function(state)
        for _, desc in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if desc.Name == "Auto" or desc.Name == "AutoFire" or desc.Name == "Automatic" or desc.Name == "AutoShoot" or desc.Name == "AutoGun" then
                if state then
                    if not originalValues.Auto[desc] then originalValues.Auto[desc] = desc.Value end
                    desc.Value = true
                else
                    desc.Value = originalValues.Auto[desc] or false
                end
            end
        end
    end,
})

-- No Spread toggle
GunModsGroupbox:AddToggle("NoSpread", {
    Text = "No Spread",
    Default = false,
    Tooltip = "Remove weapon spread",
    Callback = function(state)
        for _, desc in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if desc.Name == "MaxSpread" or desc.Name == "Spread" or desc.Name == "SpreadControl" then
                if state then
                    if not originalValues.Spread[desc] then originalValues.Spread[desc] = desc.Value end
                    desc.Value = 0
                else
                    desc.Value = originalValues.Spread[desc] or 1
                end
            end
        end
    end,
})

GunModsGroupbox:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Tooltip = "Remove weapon recoil",
    Callback = function(state)
        for _, desc in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if desc.Name == "RecoilControl" or desc.Name == "Recoil" then
                if state then
                    if not originalValues.Recoil[desc] then originalValues.Recoil[desc] = desc.Value end
                    desc.Value = 0
                else
                    desc.Value = originalValues.Recoil[desc] or 1
                end
            end
        end
    end,
})

local hitboxEnabled = false
local noCollisionEnabled = false
local hitbox_original_properties = {}
local hitboxSize = 21
local hitboxTransparency = 6
local teamCheck = "FFA" 

local defaultBodyParts = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}

local function savedPart(player, part)
    if not hitbox_original_properties[player] then
        hitbox_original_properties[player] = {}
    end
    if not hitbox_original_properties[player][part.Name] then
        hitbox_original_properties[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoredPart(player)
    if hitbox_original_properties[player] then
        for partName, properties in pairs(hitbox_original_properties[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = properties.CanCollide
                part.Transparency = properties.Transparency
                part.Size = properties.Size
            end
        end
    end
end

local function findClosestPart(player, partName)
    if not player.Character then return nil end
    local characterParts = player.Character:GetChildren()
    for _, part in ipairs(characterParts) do
        if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
            return part
        end
    end
    return nil
end

local function extendHitbox(player)
    for _, partName in ipairs(defaultBodyParts) do
        local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
        if part and part:IsA("BasePart") then
            savedPart(player, part)
            part.CanCollide = not noCollisionEnabled
            part.Transparency = hitboxTransparency / 10
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
end

local function isEnemy(player)
    if teamCheck == "FFA" or teamCheck == "Everyone" then
        return true
    end
    local localPlayerTeam = LocalPlayer.Team
    return player.Team ~= localPlayerTeam
end

local function shouldExtendHitbox(player)
    return isEnemy(player)
end

local function updateHitboxes()
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if shouldExtendHitbox(v) then
                extendHitbox(v)
            else
                restoredPart(v)
            end
        end
    end
end

local function startHitboxLoop()
    coroutine.wrap(function()
        while hitboxEnabled do
            updateHitboxes()
            for player, _ in pairs(hitbox_original_properties) do
                if not player.Parent or not player.Character or not player.Character:IsDescendantOf(game) then
                    restoredPart(player)
                    hitbox_original_properties[player] = nil
                end
            end
            wait(0.1)
        end
    end)()
end

HitboxGroupbox:AddToggle("HitboxToggle", {
    Text = "Enable Hitbox",
    Default = false,
    Tooltip = "Enable the hitbox expander",
    Callback = function(state)
        hitboxEnabled = state
        if state then
            startHitboxLoop()
        else
            for _, player in ipairs(Players:GetPlayers()) do
                restoredPart(player)
            end
            hitbox_original_properties = {}
        end
    end,
})

HitboxGroupbox:AddSlider("HitboxSizeSlider", {
    Text = "Hitbox Size",
    Default = 21,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Tooltip = "Adjust the size of the hitbox",
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end,
})

HitboxGroupbox:AddSlider("HitboxTransparencySlider", {
    Text = "Hitbox Transparency",
    Default = 6,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Tooltip = "Adjust transparency of hitbox",
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end,
})

HitboxGroupbox:AddDropdown("HitboxTeamCheckDropdown", {
    Values = { "FFA", "Team-Based", "Everyone" },
    Default = 1,
    Multi = false,
    Text = "Team Check",
    Tooltip = "Choose team check mode",
    Callback = function(value)
        teamCheck = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end,
})

HitboxGroupbox:AddToggle("NoCollisionToggle", {
    Text = "Can Collide",
    Default = false,
    Tooltip = "Disable collision for hitboxes",
    Callback = function(enabled)
        noCollisionEnabled = enabled
        if hitboxEnabled then
            updateHitboxes()
        end
    end,
})

TriggerbotGroupBox:AddToggle('Enabled', {
    Text = "Enabled",
    Tooltip = "Enable or disable the Triggerbot",
    Default = false,
    Callback = function(value)
        getgenv().triggerb = value
    end
})

local teamcheck = "Team-Based"
local delay = 0.2
local isAlive = true

TriggerbotGroupBox:AddDropdown('TeamCheck', {
    Values = {"FFA", "Team-Based", "Everyone"},
    Default = 2,
    Text = "Team Check Mode",
    Tooltip = "Select team check mode for triggerbot",
    Callback = function(selected)
        teamcheck = selected
    end
})

TriggerbotGroupBox:AddSlider('ShotDelay', {
    Text = "Shot Delay",
    Default = 0.2,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Tooltip = "Delay between trigger in seconds",
    Callback = function(value)
        delay = value
    end
})

local function isEnemy(targetPlayer)
    if teamcheck == "FFA" then
        return true
    elseif teamcheck == "Everyone" then
        return targetPlayer ~= game.Players.LocalPlayer
    elseif teamcheck == "Team-Based" then
        local localPlayerTeam = game.Players.LocalPlayer.Team
        return targetPlayer.Team ~= localPlayerTeam
    end
    return false
end

local function checkHealth()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HealthChanged:Connect(function(health)
            isAlive = health > 0
        end)
    end
end
game.Players.LocalPlayer.CharacterAdded:Connect(checkHealth)
checkHealth()

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().triggerb and isAlive then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") and target.Parent.Name ~= player.Name then
            local targetPlayer = game.Players:FindFirstChild(target.Parent.Name)
            if targetPlayer and isEnemy(targetPlayer) then
                mouse1press()
                task.wait(delay)
                mouse1release()
            end
        end
    end
end)

PlayerGroupbox:AddToggle('InfiniteJump', {
    Text = "Infinite Jump",
    Tooltip = "Jump infinite times without a limit",
    Default = false,
    Callback = function(state)
        getgenv().InfiniteJumpEnabled = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled then
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local fovValue = 120
PlayerGroupbox:AddSlider('FOVArsenal', {
    Text = "Change FOV",
    Default = 120,
    Min = 0,
    Max = 150,
    Rounding = 0,
    Tooltip = "Adjust your Field Of View",
    Callback = function(value)
        fovValue = value
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("Settings") and player.Settings:FindFirstChild("FOV") then
            player.Settings.FOV.Value = value
        end
    end
})

local noClipEnabled = false
PlayerGroupbox:AddToggle('NoClip', {
    Text = "No Clip",
    Tooltip = "Go through walls",
    Default = false,
    Callback = function(enabled)
        noClipEnabled = enabled
        local player = game.Players.LocalPlayer
        if noClipEnabled then
            spawn(function()
                while noClipEnabled do
                    local character = player.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait()
                end
            end)
        else
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local xrayOn = false
PlayerGroupbox:AddToggle('Xray', {
    Text = "Xray",
    Tooltip = "Xray through walls",
    Default = false,
    Callback = function(enabled)
        xrayOn = enabled
        if xrayOn then
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if not descendant:FindFirstChild("OriginalTransparency") then
                        local originalTransparency = Instance.new("NumberValue")
                        originalTransparency.Name = "OriginalTransparency"
                        originalTransparency.Value = descendant.Transparency
                        originalTransparency.Parent = descendant
                    end
                    descendant.Transparency = 0.5
                end
            end
        else
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local originalTransparency = descendant:FindFirstChild("OriginalTransparency")
                    if originalTransparency then
                        descendant.Transparency = originalTransparency.Value
                        originalTransparency:Destroy()
                    end
                end
            end
        end
    end
})

Library:OnUnload(function()
    if highlightTargetInstance then
        highlightTargetInstance:Destroy()
        highlightTargetInstance = nil
    end
    for _, esp in pairs(espObjects) do
        for _, obj in pairs(esp) do
            if obj and obj.Visible ~= nil then
                obj:Remove()
            end
        end
    end
    espObjects = {}

    if circle then circle:Remove() end
    if fillCircle then fillCircle:Remove() end
end)
