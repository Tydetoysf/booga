print([[



Project Infra loading



                                                                        



]])





do

    local SoulsHub = loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/3a930cb943c37a8e"))()



    local Window = SoulsHub:CreateWindow({

       Name = "Project Infra MM2",

       LoadingTitle = "Welcome",

       LoadingSubtitle = "Project Infra",

       ConfigurationSaving = { Enabled = false },

       Discord = { Enabled = false },

       KeySystem = false

    })



    local MainTab = Window:CreateTab("Main")

    local VisualsTab = Window:CreateTab("Visuals")

    local CombatTab = Window:CreateTab("Combat")

    local MovementTab = Window:CreateTab("Movement")

    local FarmTab = Window:CreateTab("Farm")

    local MiscTab = Window:CreateTab("Misc")



    local Players = game:GetService("Players")

    local RunService = game:GetService("RunService")

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Workspace = game:GetService("Workspace")

    local CurrentCamera = Workspace.CurrentCamera

    local LocalPlayer = Players.LocalPlayer

    local CoreGui = game:GetService("CoreGui")

    local CharacterSettings = {

        WalkSpeed = {Value = 16, Default = 16, Locked = false},

        JumpPower = {Value = 50, Default = 50, Locked = false}

    }

    local function updateCharacter()

        local character = LocalPlayer.Character

        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then

            if not CharacterSettings.WalkSpeed.Locked then

                humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value

            end

            if not CharacterSettings.JumpPower.Locked then

                humanoid.JumpPower = CharacterSettings.JumpPower.Value

            end

        end

    end

    MainTab:CreateLabel("Walkspeed")

    MainTab:CreateSlider({

        Name = "Walkspeed",

        Range = {0, 200},

        Increment = 1,

        CurrentValue = 16,

        Callback = function(value)

            CharacterSettings.WalkSpeed.Value = value

            updateCharacter()

        end

    })

    MainTab:CreateButton({

        Name = "Reset walkspeed",

        Callback = function()

            CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default

            updateCharacter()

        end

    })

    MainTab:CreateToggle({

        Name = "Block walkspeed",

        CurrentValue = false,

        Callback = function(state)

            CharacterSettings.WalkSpeed.Locked = state

            updateCharacter()

        end

    })

    MainTab:CreateLabel("JumpPower")

    MainTab:CreateSlider({

        Name = "Jumppower",

        Range = {0, 200},

        Increment = 1,

        CurrentValue = 50,

        Callback = function(value)

            CharacterSettings.JumpPower.Value = value

            updateCharacter()

        end

    })

    MainTab:CreateButton({

        Name = "Reset jumppower",

        Callback = function()

            CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default

            updateCharacter()

        end

    })

    MainTab:CreateToggle({

        Name = "Block jumppower",

        CurrentValue = false,

        Callback = function(state)

            CharacterSettings.JumpPower.Locked = state

            updateCharacter()

        end

    })

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Players = game:GetService("Players")

    local RunService = game:GetService("RunService")

    local LP = Players.LocalPlayer

    local ESPConfig = {HighlightMurderer = false, HighlightInnocent = false, HighlightSheriff = false}

    local Murder, Sheriff, Hero

    local roles = {}

    function CreateHighlight(player)

        if ((player ~= LP) and player.Character and not player.Character:FindFirstChild("Highlight")) then

            local highlight = Instance.new("Highlight")

            highlight.Parent = player.Character

            highlight.Adornee = player.Character

            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            return highlight

        end

        return player.Character and player.Character:FindFirstChild("Highlight")

    end

    function RemoveAllHighlights()

        for _, player in pairs(Players:GetPlayers()) do

            if (player.Character and player.Character:FindFirstChild("Highlight")) then

                player.Character.Highlight:Destroy()

            end

        end

    end

    function UpdateHighlights()

        for _, player in pairs(Players:GetPlayers()) do

            if ((player ~= LP) and player.Character) then

                local highlight = player.Character:FindFirstChild("Highlight")

                if not (ESPConfig.HighlightMurderer or ESPConfig.HighlightInnocent or ESPConfig.HighlightSheriff) then

                    if highlight then

                        highlight:Destroy()

                    end

                    return

                end

                local shouldHighlight = false

                local color = Color3.new(0, 1, 0)

                if ((player.Name == Murder) and IsAlive(player) and ESPConfig.HighlightMurderer) then

                    color = Color3.fromRGB(255, 0, 0)

                    shouldHighlight = true

                elseif ((player.Name == Sheriff) and IsAlive(player) and ESPConfig.HighlightSheriff) then

                    color = Color3.fromRGB(0, 0, 255)

                    shouldHighlight = true

                elseif

                    (ESPConfig.HighlightInnocent and IsAlive(player) and (player.Name ~= Murder) and

                        (player.Name ~= Sheriff) and

                        (player.Name ~= Hero))

                 then

                    color = Color3.fromRGB(0, 255, 0)

                    shouldHighlight = true

                elseif

                    ((player.Name == Hero) and IsAlive(player) and not IsAlive(game.Players[Sheriff]) and

                        ESPConfig.HighlightSheriff)

                 then

                    color = Color3.fromRGB(255, 250, 0)

                    shouldHighlight = true

                end

                if shouldHighlight then

                    highlight = CreateHighlight(player)

                    if highlight then

                        highlight.FillColor = color

                        highlight.OutlineColor = color

                        highlight.Enabled = true

                    end

                elseif highlight then

                    highlight.Enabled = false

                end

            end

        end

    end

    function IsAlive(player)

        for name, data in pairs(roles) do

            if (player.Name == name) then

                return not data.Killed and not data.Dead

            end

        end

        return false

    end

    local function UpdateRoles()

        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

        for name, data in pairs(roles) do

            if (data.Role == "Murderer") then

                Murder = name

            elseif (data.Role == "Sheriff") then

                Sheriff = name

            elseif (data.Role == "Hero") then

                Hero = name

            end

        end

    end

    VisualsTab:CreateLabel("Special ESP")

    VisualsTab:CreateToggle({

        Name = "Higlight Murder",

        CurrentValue = false,

        Callback = function(state)

            ESPConfig.HighlightMurderer = state

            if not state then

                UpdateHighlights()

            end

        end

    })

    VisualsTab:CreateToggle({

        Name = "Highlight Innocent",

        CurrentValue = false,

        Callback = function(state)

            ESPConfig.HighlightInnocent = state

            if not state then

                UpdateHighlights()

            end

        end

    })

    VisualsTab:CreateToggle({

        Name = "Highlight Sheriff",

        CurrentValue = false,

        Callback = function(state)

            ESPConfig.HighlightSheriff = state

            if not state then

                UpdateHighlights()

            end

        end

    })

    local gunDropESPEnabled = false

    local gunDropHighlight = nil

    local mapPaths = {

        "ResearchFacility",

        "Hospital3",

        "MilBase",

        "House2",

        "Workplace",

        "Mansion2",

        "BioLab",

        "Hotel",

        "Factory",

        "Bank2",

        "PoliceStation"

    }

    local function createGunDropHighlight(gunDrop)

        if (gunDropESPEnabled and gunDrop and not gunDrop:FindFirstChild("GunDropHighlight")) then

            local highlight = Instance.new("Highlight")

            highlight.Name = "GunDropHighlight"

            highlight.FillColor = Color3.fromRGB(255, 215, 0)

            highlight.OutlineColor = Color3.fromRGB(255, 165, 0)

            highlight.Adornee = gunDrop

            highlight.Parent = gunDrop

        end

    end

    local function updateGunDropESP()

        for _, mapName in pairs(mapPaths) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                local gunDrop = map:FindFirstChild("GunDrop")

                if (gunDrop and gunDrop:FindFirstChild("GunDropHighlight")) then

                    gunDrop.GunDropHighlight:Destroy()

                end

            end

        end

        if gunDropESPEnabled then

            for _, mapName in pairs(mapPaths) do

                local map = workspace:FindFirstChild(mapName)

                if map then

                    local gunDrop = map:FindFirstChild("GunDrop")

                    if gunDrop then

                        createGunDropHighlight(gunDrop)

                    end

                end

            end

        end

    end

    local function monitorGunDrops()

        for _, mapName in pairs(mapPaths) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                map.ChildAdded:Connect(

                    function(child)

                        if (child.Name == "GunDrop") then

                            createGunDropHighlight(child)

                        end

                    end

                )

            end

        end

    end

    monitorGunDrops()

    VisualsTab:CreateToggle({

        Name = "GunDrop Highlight",

        CurrentValue = false,

        Callback = function(state)

            gunDropESPEnabled = state

            updateGunDropESP()

        end

    })

    workspace.ChildAdded:Connect(

        function(child)

            if table.find(mapPaths, child.Name) then

                task.wait(2)

                updateGunDropESP()

            end

        end

    )

    RunService.RenderStepped:Connect(

        function()

            UpdateRoles()

            if (ESPConfig.HighlightMurderer or ESPConfig.HighlightInnocent or ESPConfig.HighlightSheriff) then

                UpdateHighlights()

            end

        end

    )

    Players.PlayerRemoving:Connect(

        function(player)

            if (player == LP) then

                RemoveAllHighlights()

            end

        end

    )

    local teleportTarget = nil

    local teleportDropdown = nil

    local function updateTeleportPlayers()

        local playersList = {"Select Player"}

        for _, player in pairs(Players:GetPlayers()) do

            if (player ~= LocalPlayer) then

                table.insert(playersList, player.Name)

            end

        end

        return playersList

    end

    MovementTab:CreateDropdown({

        Name = "Players",

        Options = updateTeleportPlayers(),

        CurrentOption = "Select Player",

        Callback = function(selected)

            if (selected ~= "Select Player") then

                teleportTarget = Players:FindFirstChild(selected)

            else

                teleportTarget = nil

            end

        end

    })

    Players.PlayerAdded:Connect(

        function(player)

            task.wait(1)

            -- Refresh dropdown if possible, but since no Refresh in lib, assume manual

        end

    )

    Players.PlayerRemoving:Connect(

        function(player)

            -- Refresh dropdown

        end

    )

    local function teleportToPlayer()

        if (teleportTarget and teleportTarget.Character) then

            local targetRoot = teleportTarget.Character:FindFirstChild("HumanoidRootPart")

            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if (targetRoot and localRoot) then

                localRoot.CFrame = targetRoot.CFrame

            end

        end

    end

    MovementTab:CreateButton({Name = "Teleport to player", Callback = teleportToPlayer})

    MovementTab:CreateButton({

        Name = "Update players list",

        Callback = function()

            -- Refresh if method available

        end

    })

    local function teleportToLobby()

        local lobby = workspace:FindFirstChild("Lobby")

        if not lobby then

            return

        end

        local spawnPoint = lobby:FindFirstChild("SpawnPoint") or lobby:FindFirstChildOfClass("SpawnLocation")

        if not spawnPoint then

            spawnPoint = lobby:FindFirstChildWhichIsA("BasePart") or lobby

        end

        if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then

            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPoint.Position + Vector3.new(0, 3, 0))

        end

    end

    MovementTab:CreateButton({Name = "Teleport to Lobby", Callback = teleportToLobby})

    MovementTab:CreateButton({

        Name = "Teleport to Sheriff",

        Callback = function()

            UpdateRoles()

            if Sheriff then

                local sheriffPlayer = Players:FindFirstChild(Sheriff)

                if (sheriffPlayer and sheriffPlayer.Character) then

                    local targetRoot = sheriffPlayer.Character:FindFirstChild("HumanoidRootPart")

                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if (targetRoot and localRoot) then

                        localRoot.CFrame = targetRoot.CFrame

                    end

                end

            end

        end

    })

    MovementTab:CreateButton({

        Name = "Teleport to Murderer",

        Callback = function()

            UpdateRoles()

            if Murder then

                local murderPlayer = Players:FindFirstChild(Murder)

                if (murderPlayer and murderPlayer.Character) then

                    local targetRoot = murderPlayer.Character:FindFirstChild("HumanoidRootPart")

                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if (targetRoot and localRoot) then

                        localRoot.CFrame = targetRoot.CFrame

                    end

                end

            end

        end

    })

    local roles = {}

    local Murder, Sheriff

    local isCameraLocked = false

    local isSpectating = false

    local lockedRole = nil

    local cameraConnection = nil

    local originalCameraType = Enum.CameraType.Custom

    local originalCameraSubject = nil

    function IsAlive(player)

        for name, data in pairs(roles) do

            if (player.Name == name) then

                return not data.Killed and not data.Dead

            end

        end

        return false

    end

    local function UpdateRoles()

        local success, result =

            pcall(

            function()

                return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

            end

        )

        if success then

            roles = result or {}

            Murder, Sheriff = nil, nil

            for name, data in pairs(roles) do

                if (data.Role == "Murderer") then

                    Murder = name

                elseif (data.Role == "Sheriff") then

                    Sheriff = name

                end

            end

        end

    end

    CombatTab:CreateLabel("Default AimBot")

    CombatTab:CreateDropdown({

        Name = "Target Role",

        Options = {"None", "Sheriff", "Murderer"},

        CurrentOption = "None",

        Callback = function(selected)

            lockedRole = ((selected ~= "None") and selected) or nil

        end

    })

    CombatTab:CreateToggle({

        Name = "Spectate Mode",

        CurrentValue = false,

        Callback = function(state)

            isSpectating = state

            if state then

                originalCameraType = CurrentCamera.CameraType

                originalCameraSubject = CurrentCamera.CameraSubject

                CurrentCamera.CameraType = Enum.CameraType.Scriptable

            else

                CurrentCamera.CameraType = originalCameraType

                CurrentCamera.CameraSubject = originalCameraSubject

            end

        end

    })

    CombatTab:CreateToggle({

        Name = "Lock Camera",

        CurrentValue = false,

        Callback = function(state)

            isCameraLocked = state

            if (not state and not isSpectating) then

                CurrentCamera.CameraType = originalCameraType

                CurrentCamera.CameraSubject = originalCameraSubject

            end

        end

    })

    local function GetTargetPosition()

        if not lockedRole then

            return nil

        end

        local targetName = ((lockedRole == "Sheriff") and Sheriff) or Murder

        if not targetName then

            return nil

        end

        local player = Players:FindFirstChild(targetName)

        if (not player or not IsAlive(player)) then

            return nil

        end

        local character = player.Character

        if not character then

            return nil

        end

        local head = character:FindFirstChild("Head")

        return (head and head.Position) or nil

    end

    local function UpdateSpectate()

        if (not isSpectating or not lockedRole) then

            return

        end

        local targetPos = GetTargetPosition()

        if not targetPos then

            return

        end

        local offset = CFrame.new(0, 2, 8)

        local targetChar = Players:FindFirstChild(((lockedRole == "Sheriff") and Sheriff) or Murder).Character

        if targetChar then

            local root = targetChar:FindFirstChild("HumanoidRootPart")

            if root then

                CurrentCamera.CFrame = root.CFrame * offset

            end

        end

    end

    local function UpdateLockCamera()

        if (not isCameraLocked or not lockedRole) then

            return

        end

        local targetPos = GetTargetPosition()

        if not targetPos then

            return

        end

        local currentPos = CurrentCamera.CFrame.Position

        CurrentCamera.CFrame = CFrame.new(currentPos, targetPos)

    end

    local function Update()

        if isSpectating then

            UpdateSpectate()

        elseif isCameraLocked then

            UpdateLockCamera()

        end

    end

    local function AutoUpdate()

        while true do

            UpdateRoles()

            task.wait(3)

        end

    end

    coroutine.wrap(AutoUpdate)()

    cameraConnection = RunService.RenderStepped:Connect(Update)

    LocalPlayer.AncestryChanged:Connect(

        function()

            if (not LocalPlayer.Parent and cameraConnection) then

                cameraConnection:Disconnect()

                CurrentCamera.CameraType = originalCameraType

                CurrentCamera.CameraSubject = originalCameraSubject

            end

        end

    )

    UpdateRoles()

    CombatTab:CreateLabel("Silent Aimbot (On rework)")

    local AutoFarm = {

        Enabled = false,

        Mode = "Teleport",

        TeleportDelay = 0,

        MoveSpeed = 50,

        WalkSpeed = 32,

        Connection = nil,

        CoinCheckInterval = 0.5,

        CoinContainers = {

            "Factory",

            "Hospital3",

            "MilBase",

            "House2",

            "Workplace",

            "Mansion2",

            "BioLab",

            "Hotel",

            "Bank2",

            "PoliceStation",

            "ResearchFacility",

            "Lobby"

        }

    }

    local function findNearestCoin()

        local closestCoin = nil

        local shortestDistance = math.huge

        local character = LocalPlayer.Character

        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then

            return nil

        end

        for _, containerName in ipairs(AutoFarm.CoinContainers) do

            local container = workspace:FindFirstChild(containerName)

            if container then

                local coinContainer =

                    ((containerName == "Lobby") and container) or container:FindFirstChild("CoinContainer")

                if coinContainer then

                    for _, coin in ipairs(coinContainer:GetChildren()) do

                        if coin:IsA("BasePart") then

                            local distance = (humanoidRootPart.Position - coin.Position).Magnitude

                            if (distance < shortestDistance) then

                                shortestDistance = distance

                                closestCoin = coin

                            end

                        end

                    end

                end

            end

        end

        return closestCoin

    end

    local function teleportToCoin(coin)

        if (not coin or not LocalPlayer.Character) then

            return

        end

        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then

            return

        end

        humanoidRootPart.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))

        task.wait(AutoFarm.TeleportDelay)

    end

    local function smoothMoveToCoin(coin)

        if (not coin or not LocalPlayer.Character) then

            return

        end

        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then

            return

        end

        local startTime = tick()

        local startPos = humanoidRootPart.Position

        local endPos = coin.Position + Vector3.new(0, 3, 0)

        local distance = (startPos - endPos).Magnitude

        local duration = distance / AutoFarm.MoveSpeed

        while ((tick() - startTime) < duration) and AutoFarm.Enabled do

            if (not coin or not coin.Parent) then

                break

            end

            local progress = math.min((tick() - startTime) / duration, 1)

            humanoidRootPart.CFrame = CFrame.new(startPos:Lerp(endPos, progress))

            task.wait()

        end

    end

    local function walkToCoin(coin)

        if (not coin or not LocalPlayer.Character) then

            return

        end

        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if not humanoid then

            return

        end

        humanoid.WalkSpeed = AutoFarm.WalkSpeed

        humanoid:MoveTo(coin.Position + Vector3.new(0, 0, 3))

        local startTime = tick()

        while AutoFarm.Enabled and (humanoid.MoveDirection.Magnitude > 0) and ((tick() - startTime) < 10) do

            task.wait(0.5)

        end

    end

    local function collectCoin(coin)

        if (not coin or not LocalPlayer.Character) then

            return

        end

        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then

            return

        end

        firetouchinterest(humanoidRootPart, coin, 0)

        firetouchinterest(humanoidRootPart, coin, 1)

    end

    local function farmLoop()

        while AutoFarm.Enabled do

            local coin = findNearestCoin()

            if coin then

                if (AutoFarm.Mode == "Teleport") then

                    teleportToCoin(coin)

                elseif (AutoFarm.Mode == "Smooth") then

                    smoothMoveToCoin(coin)

                else

                    walkToCoin(coin)

                end

                collectCoin(coin)

            end

            task.wait(AutoFarm.CoinCheckInterval)

        end

    end

    FarmTab:CreateLabel("Coin Farming")

    FarmTab:CreateDropdown({

        Name = "Movement Mode",

        Options = {"Teleport", "Smooth", "Walk"},

        CurrentOption = "Teleport",

        Callback = function(mode)

            AutoFarm.Mode = mode

        end

    })

    FarmTab:CreateSlider({

        Name = "Teleport Delay (sec)",

        Range = {0, 1},

        Increment = 0.1,

        CurrentValue = 0,

        Callback = function(value)

            AutoFarm.TeleportDelay = value

        end

    })

    FarmTab:CreateSlider({

        Name = "Smooth Move Speed",

        Range = {20, 200},

        Increment = 1,

        CurrentValue = 50,

        Callback = function(value)

            AutoFarm.MoveSpeed = value

        end

    })

    FarmTab:CreateSlider({

        Name = "Walk Speed",

        Range = {16, 100},

        Increment = 1,

        CurrentValue = 32,

        Callback = function(value)

            AutoFarm.WalkSpeed = value

        end

    })

    FarmTab:CreateSlider({

        Name = "Check Interval (sec)",

        Range = {0.1, 2},

        Increment = 0.1,

        CurrentValue = 0.5,

        Callback = function(value)

            AutoFarm.CoinCheckInterval = value

        end

    })

    FarmTab:CreateToggle({

        Name = "Enable AutoFarm",

        CurrentValue = false,

        Callback = function(state)

            AutoFarm.Enabled = state

            if state then

                AutoFarm.Connection = task.spawn(farmLoop)

            else

                if AutoFarm.Connection then

                    task.cancel(AutoFarm.Connection)

                end

            end

        end

    })

    local GunSystem = {

        AutoGrabEnabled = false,

        NotifyGunDrop = true,

        GunDropCheckInterval = 1,

        ActiveGunDrops = {},

        GunDropHighlights = {}

    }

    local mapPaths = {

        "ResearchFacility",

        "Hospital3",

        "MilBase",

        "House2",

        "Workplace",

        "Mansion2",

        "BioLab",

        "Hotel",

        "Factory",

        "Bank2",

        "PoliceStation"

    }

    local function TeleportToMurderer(murderer)

        local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")

        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if (targetRoot and localRoot) then

            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -5)

            task.wait(0.3)

            return true

        end

        return false

    end

    local function ScanForGunDrops()

        GunSystem.ActiveGunDrops = {}

        for _, mapName in ipairs(mapPaths) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                local gunDrop = map:FindFirstChild("GunDrop")

                if gunDrop then

                    table.insert(GunSystem.ActiveGunDrops, gunDrop)

                end

            end

        end

        local rootGunDrop = workspace:FindFirstChild("GunDrop")

        if rootGunDrop then

            table.insert(GunSystem.ActiveGunDrops, rootGunDrop)

        end

    end

    local function EquipGun()

        if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then

            return true

        end

        local gun = LocalPlayer.Backpack:FindFirstChild("Gun")

        if gun then

            gun.Parent = LocalPlayer.Character

            task.wait(0.1)

            return LocalPlayer.Character:FindFirstChild("Gun") ~= nil

        end

        return false

    end

    local function GrabGun(gunDrop)

        if not gunDrop then

            ScanForGunDrops()

            if (#GunSystem.ActiveGunDrops == 0) then

                return false

            end

            local nearestGun = nil

            local minDistance = math.huge

            local character = LocalPlayer.Character

            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then

                for _, drop in ipairs(GunSystem.ActiveGunDrops) do

                    local distance = (humanoidRootPart.Position - drop.Position).Magnitude

                    if (distance < minDistance) then

                        nearestGun = drop

                        minDistance = distance

                    end

                end

            end

            gunDrop = nearestGun

        end

        if (gunDrop and LocalPlayer.Character) then

            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then

                humanoidRootPart.CFrame = gunDrop.CFrame

                task.wait(0.3)

                local prompt = gunDrop:FindFirstChildOfClass("ProximityPrompt")

                if prompt then

                    fireproximityprompt(prompt)

                    return true

                end

            end

        end

        return false

    end

    local function AutoGrabGun()

        while GunSystem.AutoGrabEnabled do

            ScanForGunDrops()

            if ((#GunSystem.ActiveGunDrops > 0) and LocalPlayer.Character) then

                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then

                    local nearestGun = nil

                    local minDistance = math.huge

                    for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do

                        local distance = (humanoidRootPart.Position - gunDrop.Position).Magnitude

                        if (distance < minDistance) then

                            nearestGun = gunDrop

                            minDistance = distance

                        end

                    end

                    if nearestGun then

                        humanoidRootPart.CFrame = nearestGun.CFrame

                        task.wait(0.3)

                        local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")

                        if prompt then

                            fireproximityprompt(prompt)

                            task.wait(1)

                        end

                    end

                end

            end

            task.wait(GunSystem.GunDropCheckInterval)

        end

    end

    local function GetMurderer()

        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData"):InvokeServer()

        for playerName, data in pairs(roles) do

            if (data.Role == "Murderer") then

                return Players:FindFirstChild(playerName)

            end

        end

    end

    local Players = game:GetService("Players")

    local LocalPlayer = Players.LocalPlayer

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local function GrabAndShootMurderer()

        if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then

            if not GrabGun() then

                return

            end

            task.wait(0.1)

        end

        if not EquipGun() then

            return

        end

        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

        local murderer = nil

        for name, data in pairs(roles) do

            if (data.Role == "Murderer") then

                murderer = Players:FindFirstChild(name)

                break

            end

        end

        if (not murderer or not murderer.Character) then

            return

        end

        local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")

        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if (targetRoot and localRoot) then

            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)

            task.wait(0.1)

        end

        local gun = LocalPlayer.Character:FindFirstChild("Gun")

        if not gun then

            return

        end

        local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")

        if not targetPart then

            return

        end

        local args = {[1] = 1, [2] = targetPart.Position, [3] = "AH2"}

        if (gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")) then

            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))

        end

    end

    local Players = game:GetService("Players")

    local LocalPlayer = Players.LocalPlayer

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local gunDropESPEnabled = true

    local notifiedGunDrops = {}

    local mapGunDrops = {

        "ResearchFacility",

        "Hospital3",

        "MilBase",

        "House2",

        "Workplace",

        "Mansion2",

        "BioLab",

        "Hotel",

        "Factory",

        "Bank2",

        "PoliceStation"

    }

    local function checkForGunDrops()

        for _, mapName in ipairs(mapGunDrops) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                local gunDrop = map:FindFirstChild("GunDrop")

                if (gunDrop and not notifiedGunDrops[gunDrop]) then

                    if gunDropESPEnabled then

                    end

                    notifiedGunDrops[gunDrop] = true

                end

            end

        end

    end

    local function setupGunDropMonitoring()

        for _, mapName in ipairs(mapGunDrops) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                if map:FindFirstChild("GunDrop") then

                    checkForGunDrops()

                end

                map.ChildAdded:Connect(

                    function(child)

                        if (child.Name == "GunDrop") then

                            task.wait(0.5)

                            checkForGunDrops()

                        end

                    end

                )

            end

        end

    end

    local function setupGunDropRemovalTracking()

        for _, mapName in ipairs(mapGunDrops) do

            local map = workspace:FindFirstChild(mapName)

            if map then

                map.ChildRemoved:Connect(

                    function(child)

                        if ((child.Name == "GunDrop") and notifiedGunDrops[child]) then

                            notifiedGunDrops[child] = nil

                        end

                    end

                )

            end

        end

    end

    setupGunDropMonitoring()

    setupGunDropRemovalTracking()

    workspace.ChildAdded:Connect(

        function(child)

            if table.find(mapGunDrops, child.Name) then

                task.wait(2)

                checkForGunDrops()

            end

        end

    )

    CombatTab:CreateToggle({

        Name = "Notify GunDrop",

        CurrentValue = true,

        Callback = function(state)

            gunDropESPEnabled = state

            if state then

                task.spawn(

                    function()

                        task.wait(1)

                        checkForGunDrops()

                    end

                )

            end

        end

    })

    CombatTab:CreateButton({

        Name = "Grab Gun",

        Callback = function()

            GrabGun()

        end

    })

    CombatTab:CreateToggle({

        Name = "Auto Grab Gun",

        CurrentValue = false,

        Callback = function(state)

            GunSystem.AutoGrabEnabled = state

            if state then

                coroutine.wrap(AutoGrabGun)()

            end

        end

    })

    CombatTab:CreateButton({

        Name = "Grab Gun & Shoot Murderer",

        Callback = function()

            GrabAndShootMurderer()

        end

    })

    task.spawn(

        function()

            if not LocalPlayer.Character then

                LocalPlayer.CharacterAdded:Wait()

            end

            ScanForGunDrops()

            if GunSystem.AutoGrabEnabled then

                coroutine.wrap(AutoGrabGun)()

            end

        end

    )

    local killActive = false

    local attackDelay = 0.5

    local targetRoles = {"Sheriff", "Hero", "Innocent"}

    local function getPlayerRole(player)

        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

        if (roles and roles[player.Name]) then

            return roles[player.Name].Role

        end

        return nil

    end

    local function equipKnife()

        local character = LocalPlayer.Character

        if not character then

            return false

        end

        if character:FindFirstChild("Knife") then

            return true

        end

        local knife = LocalPlayer.Backpack:FindFirstChild("Knife")

        if knife then

            knife.Parent = character

            return true

        end

        return false

    end

    local function getNearestTarget()

        local targets = {}

        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not localRoot then

            return nil

        end

        for _, player in ipairs(Players:GetPlayers()) do

            if ((player ~= LocalPlayer) and player.Character) then

                local role = getPlayerRole(player)

                local humanoid = player.Character:FindFirstChild("Humanoid")

                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")

                if (role and humanoid and (humanoid.Health > 0) and targetRoot and table.find(targetRoles, role)) then

                    table.insert(

                        targets,

                        {Player = player, Distance = (localRoot.Position - targetRoot.Position).Magnitude}

                    )

                end

            end

        end

        table.sort(

            targets,

            function(a, b)

                return a.Distance < b.Distance

            end

        )

        return (targets[1] and targets[1].Player) or nil

    end

    local function attackTarget(target)

        if (not target or not target.Character) then

            return false

        end

        local humanoid = target.Character:FindFirstChild("Humanoid")

        if (not humanoid or (humanoid.Health <= 0)) then

            return false

        end

        if not equipKnife() then

            return false

        end

        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")

        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if (targetRoot and localRoot) then

            localRoot.CFrame =

                CFrame.new(

                targetRoot.Position + ((localRoot.Position - targetRoot.Position).Unit * 2),

                targetRoot.Position

            )

        end

        local knife = LocalPlayer.Character:FindFirstChild("Knife")

        if (knife and knife:FindFirstChild("Stab")) then

            for i = 1, 3 do

                knife.Stab:FireServer("Down")

            end

            return true

        end

        return false

    end

    local function killTargets()

        if killActive then

            return

        end

        killActive = true

        local function attackSequence()

            while killActive do

                local target = getNearestTarget()

                if not target then

                    killActive = false

                    break

                end

                if attackTarget(target) then

                end

                task.wait(attackDelay)

            end

        end

        task.spawn(attackSequence)

    end

    local function stopKilling()

        killActive = false

    end

    CombatTab:CreateLabel("Kill Functions")

    CombatTab:CreateToggle({

        Name = "Kill All",

        CurrentValue = false,

        Callback = function(state)

            if state then

                killTargets()

            else

                stopKilling()

            end

        end

    })

    CombatTab:CreateSlider({

        Name = "Attack Delay",

        Range = {0.1, 2},

        Increment = 0.1,

        CurrentValue = 0.5,

        Callback = function(value)

            attackDelay = value

        end

    })

    CombatTab:CreateButton({

        Name = "Equip Knife",

        Callback = function()

            equipKnife()

        end

    })

    local shotButton = nil

    local shotButtonFrame = nil

    local shotButtonActive = false

    local shotType = "Default"

    local buttonSize = 50

    local isDragging = false

    local function CreateShotButton()

        if shotButton then

            return

        end

        local screenGui = game:GetService("CoreGui"):FindFirstChild("WindUI_SheriffGui") or Instance.new("ScreenGui")

        screenGui.Name = "WindUI_SheriffGui"

        screenGui.Parent = game:GetService("CoreGui")

        screenGui.ResetOnSpawn = false

        screenGui.DisplayOrder = 999

        screenGui.IgnoreGuiInset = true

        shotButtonFrame = Instance.new("Frame")

        shotButtonFrame.Name = "ShotButtonFrame"

        shotButtonFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)

        shotButtonFrame.Position = UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize / 2)

        shotButtonFrame.AnchorPoint = Vector2.new(1, 0.5)

        shotButtonFrame.BackgroundTransparency = 1

        shotButtonFrame.ZIndex = 100

        shotButton = Instance.new("TextButton")

        shotButton.Name = "SheriffShotButton"

        shotButton.Size = UDim2.new(1, 0, 1, 0)

        shotButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

        shotButton.BackgroundTransparency = 0.5

        shotButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        shotButton.Text = "SHOT"

        shotButton.TextSize = 14

        shotButton.Font = Enum.Font.GothamBold

        shotButton.BorderSizePixel = 0

        shotButton.ZIndex = 101

        shotButton.AutoButtonColor = false

        shotButton.TextScaled = true

        local stroke = Instance.new("UIStroke")

        stroke.Color = Color3.fromRGB(0, 40, 150)

        stroke.Thickness = 2

        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        stroke.Transparency = 0.3

        stroke.Parent = shotButton

        local corner = Instance.new("UICorner")

        corner.CornerRadius = UDim.new(0.3, 0)

        corner.Parent = shotButton

        local shadow = Instance.new("ImageLabel")

        shadow.Name = "Shadow"

        shadow.Size = UDim2.new(1, 10, 1, 10)

        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)

        shadow.AnchorPoint = Vector2.new(0.5, 0.5)

        shadow.BackgroundTransparency = 1

        shadow.Image = "rbxassetid://1316045217"

        shadow.ImageColor3 = Color3.new(0, 0, 0)

        shadow.ImageTransparency = 0.85

        shadow.ScaleType = Enum.ScaleType.Slice

        shadow.SliceCenter = Rect.new(10, 10, 118, 118)

        shadow.ZIndex = 100

        shadow.Parent = shotButton

        local function animatePress()

            local tweenService = game:GetService("TweenService")

            local pressDown =

                tweenService:Create(

                shotButton,

                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

                {

                    Size = UDim2.new(0.9, 0, 0.9, 0),

                    BackgroundColor3 = Color3.fromRGB(70, 70, 70),

                    TextColor3 = Color3.fromRGB(200, 200, 255)

                }

            )

            local pressUp =

                tweenService:Create(

                shotButton,

                TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),

                {

                    Size = UDim2.new(1, 0, 1, 0),

                    BackgroundColor3 = Color3.fromRGB(100, 100, 100),

                    TextColor3 = Color3.fromRGB(255, 255, 255)

                }

            )

            pressDown:Play()

            pressDown.Completed:Wait()

            pressUp:Play()

        end

        shotButton.MouseButton1Click:Connect(

            function()

                animatePress()

                if

                    (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or

                        (LocalPlayer.Character.Humanoid.Health <= 0))

                 then

                    return

                end

                local success, roles =

                    pcall(

                    function()

                        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

                    end

                )

                if (not success or not roles) then

                    return

                end

                local murderer = nil

                for name, data in pairs(roles) do

                    if (data.Role == "Murderer") then

                        murderer = Players:FindFirstChild(name)

                        break

                    end

                end

                if

                    (not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or

                        (murderer.Character.Humanoid.Health <= 0))

                 then

                    return

                end

                local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")

                if ((shotType == "Default") and not gun) then

                    return

                end

                if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then

                    gun.Parent = LocalPlayer.Character

                end

                if (shotType == "Teleport") then

                    local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")

                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if (targetRoot and localRoot) then

                        localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)

                    end

                end

                if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then

                    gun.Parent = LocalPlayer.Character

                end

                gun = LocalPlayer.Character:FindFirstChild("Gun")

                if (gun and gun:FindFirstChild("KnifeLocal")) then

                    local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")

                    if targetPart then

                        local args = {[1] = 10, [2] = targetPart.Position, [3] = "AH2"}

                        gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))

                    end

                end

            end

        )

        local dragInput

        local dragStart

        local startPos

        local function updateInput(input)

            local delta = input.Position - dragStart

            local newPos =

                UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

            local guiSize = game:GetService("CoreGui").AbsoluteSize

            newPos =

                UDim2.new(

                math.clamp(newPos.X.Scale, 0, 1),

                math.clamp(newPos.X.Offset, 0, guiSize.X - buttonSize),

                math.clamp(newPos.Y.Scale, 0, 1),

                math.clamp(newPos.Y.Offset, 0, guiSize.Y - buttonSize)

            )

            shotButtonFrame.Position = newPos

        end

        shotButton.InputBegan:Connect(

            function(input)

                if (input.UserInputType == Enum.UserInputType.MouseButton1) then

                    isDragging = true

                    dragStart = input.Position

                    startPos = shotButtonFrame.Position

                    animatePress()

                    input.Changed:Connect(

                        function()

                            if (input.UserInputState == Enum.UserInputState.End) then

                                isDragging = false

                            end

                        end

                    )

                end

            end

        )

        shotButton.InputChanged:Connect(

            function(input)

                if ((input.UserInputType == Enum.UserInputType.MouseMovement) and isDragging) then

                    updateInput(input)

                end

            end

        )

        shotButton.Parent = shotButtonFrame

        shotButtonFrame.Parent = screenGui

        shotButtonActive = true

    end

    local function RemoveShotButton()

        if not shotButton then

            return

        end

        if shotButton then

            shotButton:Destroy()

            shotButton = nil

        end

        if shotButtonFrame then

            shotButtonFrame:Destroy()

            shotButtonFrame = nil

        end

        local screenGui = game:GetService("CoreGui"):FindFirstChild("WindUI_SheriffGui")

        if screenGui then

            screenGui:Destroy()

        end

        shotButtonActive = false

    end

    CombatTab:CreateLabel("Shot functions")

    CombatTab:CreateDropdown({

        Name = "Shot Type",

        Options = {"Default", "Teleport"},

        CurrentOption = "Default",

        Callback = function(selectedType)

            shotType = selectedType

        end

    })

    CombatTab:CreateButton({

        Name = "Shoot murderer",

        Callback = function()

            ShootMurderer()

        end

    })

    CombatTab:CreateLabel("Shot Button")

    CombatTab:CreateButton({

        Name = "Toggle Shot Button",

        Callback = function()

            if shotButtonActive then

                RemoveShotButton()

            else

                CreateShotButton()

            end

        end

    })

    CombatTab:CreateSlider({

        Name = "Button Size",

        Range = {10, 100},

        Increment = 1,

        CurrentValue = 50,

        Callback = function(size)

            buttonSize = size

            if shotButtonActive then

                local currentPos =

                    (shotButtonFrame and shotButtonFrame.Position) or

                    UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize / 2)

                RemoveShotButton()

                CreateShotButton()

                if shotButtonFrame then

                    shotButtonFrame.Position = currentPos

                end

            end

        end

    })

    local function ShootMurderer()

        if

            (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or

                (LocalPlayer.Character.Humanoid.Health <= 0))

         then

            return

        end

        local success, roles =

            pcall(

            function()

                return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

            end

        )

        if (not success or not roles) then

            return

        end

        local murderer = nil

        for name, data in pairs(roles) do

            if (data.Role == "Murderer") then

                murderer = Players:FindFirstChild(name)

                break

            end

        end

        if

            (not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or

                (murderer.Character.Humanoid.Health <= 0))

         then

            return

        end

        local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")

        if ((shotType == "Default") and not gun) then

            return

        end

        if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then

            gun.Parent = LocalPlayer.Character

        end

        if (shotType == "Teleport") then

            local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")

            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if (targetRoot and localRoot) then

                localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)

            end

        end

        if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then

            gun.Parent = LocalPlayer.Character

        end

        gun = LocalPlayer.Character:FindFirstChild("Gun")

        if (gun and gun:FindFirstChild("KnifeLocal")) then

            local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")

            if targetPart then

                local args = {[1] = 1, [2] = targetPart.Position, [3] = "AH2"}

                gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))

            end

        end

    end

    local Settings = {

        Hitbox = {Enabled = false, Size = 5, Color = Color3.new(1, 0, 0), Adornments = {}, Connections = {}},

        Noclip = {Enabled = false, Connection = nil},

        AntiAFK = {Enabled = false, Connection = nil}

    }

    local function ToggleNoclip(state)

        if state then

            Settings.Noclip.Connection =

                RunService.Stepped:Connect(

                function()

                    local chr = LocalPlayer.Character

                    if chr then

                        for _, part in pairs(chr:GetDescendants()) do

                            if part:IsA("BasePart") then

                                part.CanCollide = false

                            end

                        end

                    end

                end

            )

        elseif Settings.Noclip.Connection then

            Settings.Noclip.Connection:Disconnect()

        end

    end

    local function UpdateHitboxes()

        for _, plr in pairs(Players:GetPlayers()) do

            if (plr ~= LocalPlayer) then

                local chr = plr.Character

                local box = Settings.Hitbox.Adornments[plr]

                if (chr and Settings.Hitbox.Enabled) then

                    local root = chr:FindFirstChild("HumanoidRootPart")

                    if root then

                        if not box then

                            box = Instance.new("BoxHandleAdornment")

                            box.Adornee = root

                            box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)

                            box.Color3 = Settings.Hitbox.Color

                            box.Transparency = 0.4

                            box.ZIndex = 10

                            box.Parent = root

                            Settings.Hitbox.Adornments[plr] = box

                        else

                            box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)

                            box.Color3 = Settings.Hitbox.Color

                        end

                    end

                elseif box then

                    box:Destroy()

                    Settings.Hitbox.Adornments[plr] = nil

                end

            end

        end

    end

    local function ToggleAntiAFK(state)

        if state then

            Settings.AntiAFK.Connection =

                RunService.Heartbeat:Connect(

                function()

                    pcall(

                        function()

                            local vu = game:GetService("VirtualUser")

                            vu:CaptureController()

                            vu:ClickButton2(Vector2.new())

                        end

                    )

                end

            )

        elseif Settings.AntiAFK.Connection then

            Settings.AntiAFK.Connection:Disconnect()

        end

    end

    MiscTab:CreateLabel("Hitboxes")

    MiscTab:CreateToggle({

        Name = "Hitboxes",

        Callback = function(state)

            Settings.Hitbox.Enabled = state

            if state then

                RunService.Heartbeat:Connect(UpdateHitboxes)

            else

                for _, box in pairs(Settings.Hitbox.Adornments) do

                    if box then

                        box:Destroy()

                    end

                end

                Settings.Hitbox.Adornments = {}

            end

        end

    })

    MiscTab:CreateSlider({

        Name = "Hitbox size",

        Range = {1, 10},

        Increment = 1,

        CurrentValue = 5,

        Callback = function(val)

            Settings.Hitbox.Size = val

            UpdateHitboxes()

        end

    })

    MiscTab:CreateLabel("Character Functions")

    MiscTab:CreateToggle({

        Name = "Anti-AFK",

        Callback = function(state)

            Settings.AntiAFK.Enabled = state

            ToggleAntiAFK(state)

        end

    })

    MiscTab:CreateToggle({

        Name = "NoClip",

        Callback = function(state)

            Settings.Noclip.Enabled = state

            ToggleNoclip(state)

        end

    })

   

    MiscTab:CreateLabel("owner")

    MiscTab:CreateButton({

        Name = "Copy owner discord user",

        Callback = function()

            setclipboard("@blond_w")

        end

    })

    MiscTab:CreateLabel("Socials")

    MiscTab:CreateButton({

        Name = "Copy Discord",

        Callback = function()

            setclipboard("https://discord.gg/5EJmv76J")

        end

    })

    MiscTab:CreateLabel("Changelogs:")

    MiscTab:CreateLabel("• Best")

    MiscTab:CreateLabel("• All Sheriff Functions")

    MiscTab:CreateLabel("• Better shot")

    MiscTab:CreateLabel("• Fixed errors")

    MiscTab:CreateLabel("• Shot variants [default; teleport]")

    MiscTab:CreateLabel("• Faster shots")

    MiscTab:CreateLabel("• New shot button")

    MiscTab:CreateLabel("• Shot button settings")

    MiscTab:CreateLabel("•All Murder Functions")

    MiscTab:CreateLabel("• Fixed kill player")

    MiscTab:CreateLabel("• Kill all function")

    MiscTab:CreateLabel("• All Innocent Functions")

    MiscTab:CreateLabel("• Grab GunDrop")

    MiscTab:CreateLabel("• Auto Grab Gun Drop")

    MiscTab:CreateLabel("• Grab gun and shoot murder function")

    MiscTab:CreateLabel("• Fixed Notifications")

    MiscTab:CreateLabel("• Fixed Check GunDrop Function")

    MiscTab:CreateLabel("• Autofarm Money")

    MiscTab:CreateLabel("• Autofarm variables [Tp; smooth; walk]")

    MiscTab:CreateLabel("• Coin checker function")

    MiscTab:CreateLabel("• Autofarm settings")

    MiscTab:CreateLabel("• Tp to lobby function")

    MiscTab:CreateLabel("Next: The next update ???")

    MiscTab:CreateLabel("enjoy")

    MiscTab:CreateLabel("•new")

    MiscTab:CreateLabel("• Fix bugs")

    MiscTab:CreateLabel("• New esp functions [tracers; names; highlights and more!]")

    MiscTab:CreateLabel("• Grab Gun Variables [Tp to gun; Gun tp to you]")

    local TeleportService = game:GetService("TeleportService")

    local HttpService = game:GetService("HttpService")

    local Players = game:GetService("Players")

    MiscTab:CreateButton({

        Name = "Rejoin",

        Callback = function()

            local success, error =

                pcall(

                function()

                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)

                end

            )

            if not success then

                warn("Rejoin error:", error)

            end

        end

    })

    MiscTab:CreateButton({

        Name = "Server Hop",

        Callback = function()

            local placeId = game.PlaceId

            local currentJobId = game.JobId

            local function serverHop()

                local servers = {}

                local success, result =

                    pcall(

                    function()

                        return HttpService:JSONDecode(

                            HttpService:GetAsync(

                                "https://games.roblox.com/v1/games/" ..

                                    placeId .. "/servers/Public?sortOrder=Asc&limit=100"

                            )

                        )

                    end

                )

                if (success and result and result.data) then

                    for _, server in ipairs(result.data) do

                        if (server.id ~= currentJobId) then

                            table.insert(servers, server)

                        end

                    end

                    if (#servers > 0) then

                        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(#servers)].id)

                    else

                        TeleportService:Teleport(placeId)

                    end

                else

                    TeleportService:Teleport(placeId)

                end

            end

            pcall(serverHop)

        end

    })

    MiscTab:CreateButton({

        Name = "Join to Lower Server",

        Callback = function()

            local placeId = game.PlaceId

            local currentJobId = game.JobId

            local function joinLowerServer()

                local servers = {}

                local success, result =

                    pcall(

                    function()

                        return HttpService:JSONDecode(

                            HttpService:GetAsync(

                                "https://games.roblox.com/v1/games/" ..

                                    placeId .. "/servers/Public?sortOrder=Asc&limit=100"

                            )

                        )

                    end

                )

                if (success and result and result.data) then

                    for _, server in ipairs(result.data) do

                        if ((server.id ~= currentJobId) and (server.playing < (server.maxPlayers or 30))) then

                            table.insert(servers, server)

                        end

                    end

                    table.sort(

                        servers,

                        function(a, b)

                            return a.playing < b.playing

                        end

                    )

                    if (#servers > 0) then

                        TeleportService:TeleportToPlaceInstance(placeId, servers[1].id)

                    else

                        TeleportService:Teleport(placeId)

                    end

                else

                    TeleportService:Teleport(placeId)

                end

            end

            pcall(joinLowerServer)

        end

    })

    local HttpService = game:GetService("HttpService")

    local folderPath = "soulshubUi"

    makefolder(folderPath)

    local function SaveFile(fileName, data)

        local filePath = folderPath .. "/" .. fileName .. ".json"

        local jsonData = HttpService:JSONEncode(data)

        writefile(filePath, jsonData)

    end

    local function LoadFile(fileName)

        local filePath = folderPath .. "/" .. fileName .. ".json"

        if isfile(filePath) then

            local jsonData = readfile(filePath)

            return HttpService:JSONDecode(jsonData)

        end

    end

    local function ListFiles()

        local files = {}

        for _, file in ipairs(listfiles(folderPath)) do

            local fileName = file:match("([^/]+)%.json$")

            if fileName then

                table.insert(files, fileName)

            end

        end

        return files

    end

    MiscTab:CreateLabel("Window")

    MiscTab:CreateInput({

        Name = "Write File Name",

        PlaceholderText = "Enter file name",

        Callback = function(text)

            fileNameInput = text

        end

    })

    MiscTab:CreateButton({

        Name = "Save File",

        Callback = function()

            if (fileNameInput ~= "") then

                SaveFile(fileNameInput, {Transparent = false, Theme = "Dark"})

            end

        end

    })

    MiscTab:CreateDropdown({

        Name = "Select File",

        Options = ListFiles(),

        Callback = function(selectedFile)

            fileNameInput = selectedFile

        end

    })

    MiscTab:CreateButton({

        Name = "Load File",

        Callback = function()

            if (fileNameInput ~= "") then

                local data = LoadFile(fileNameInput)

                if data then

                end

            end

        end

    })

    MiscTab:CreateButton({

        Name = "Overwrite File",

        Callback = function()

            if (fileNameInput ~= "") then

                SaveFile(fileNameInput, {Transparent = false, Theme = "Dark"})

            end

        end

    })

    MiscTab:CreateButton({

        Name = "Refresh List",

        Callback = function()

        end

    })

    local currentThemeName = "Dark"

    local ThemeAccent = Color3.new(1,1,1)

    local ThemeOutline = Color3.new(0,0,0)

    local ThemeText = Color3.new(1,1,1)

    local ThemePlaceholderText = Color3.new(0.5,0.5,0.5)

    MiscTab:CreateLabel("Themes (Limited Support)")


end
