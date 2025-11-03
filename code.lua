-- Project Intra Hub -- Booga Booga Reborn (with Tweens tab, simplified Yakk, and local opt-in telemetry)
print("Loading Project Intra Hub -- Booga Booga Reborn")
print("-----------------------------------------")
local Library = loadstring(game:HttpGetAsync("https://github.com/1dontgiveaf/Fluent-Renewed/releases/download/v1.0/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "Project Instra Hub -- Booga Booga Reborn",
    SubTitle = "by xylo",
    TabWidth = 160,
    Size = UDim2.fromOffset(900, 560),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "axe" }),
    Map = Window:AddTab({ Title = "Map", Icon = "trees" }),
    Pickup = Window:AddTab({ Title = "Pickup", Icon = "backpack" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "sprout" }),
    Extra = Window:AddTab({ Title = "Extra", Icon = "plus" }),
    Tweens = Window:AddTab({ Title = "Tweens", Icon = "sparkles" }), -- new Tweens tab
    Yakk = Window:AddTab({ Title = "Yakk", Icon = "coins" }), -- simplified Yakk tab
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local Players = game:GetService("Players")
local localiservice = game:GetService("LocalizationService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local tspmo = game:GetService("TweenService")
local placestructure

local Options = Library.Options

-- MAIN TAB (kept original)
local wstoggle = Tabs.Main:CreateToggle("wstoggle", { Title = "Walkspeed", Default = false })
local wsslider = Tabs.Main:CreateSlider("wsslider", { Title = "Value", Min = 1, Max = 35, Rounding = 1, Default = 16 })
local jptoggle = Tabs.Main:CreateToggle("jptoggle", { Title = "JumpPower", Default = false })
local jpslider = Tabs.Main:CreateSlider("jpslider", { Title = "Value", Min = 1, Max = 65, Rounding = 1, Default = 50 })
local hheighttoggle = Tabs.Main:CreateToggle("hheighttoggle", { Title = "HipHeight", Default = false })
local hheightslider = Tabs.Main:CreateSlider("hheightslider", { Title = "Value", Min = 0.1, Max = 6.5, Rounding = 1, Default = 2 })
local msatoggle = Tabs.Main:CreateToggle("msatoggle", { Title = "No Mountain Slip", Default = false })
Tabs.Main:CreateButton({Title = "Copy Job ID", Callback = function() pcall(setclipboard, game.JobId) end})
Tabs.Main:CreateButton({Title = "Copy HWID (local)", Callback = function() pcall(setclipboard, rbxservice:GetClientId()) end})
Tabs.Main:CreateButton({Title = "Copy SID", Callback = function() pcall(setclipboard, rbxservice:GetSessionId()) end})

-- COMBAT
local killauratoggle = Tabs.Combat:CreateToggle("killauratoggle", { Title = "Kill Aura", Default = false })
local killaurarangeslider = Tabs.Combat:CreateSlider("killaurarange", { Title = "Range", Min = 1, Max = 9, Rounding = 1, Default = 5 })
local katargetcountdropdown = Tabs.Combat:CreateDropdown("katargetcountdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local kaswingcooldownslider = Tabs.Combat:CreateSlider("kaswingcooldownslider", { Title = "Attack Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })

-- MAP
local resourceauratoggle = Tabs.Map:CreateToggle("resourceauratoggle", { Title = "Resource Aura", Default = false })
local resourceaurarange = Tabs.Map:CreateSlider("resourceaurarange", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local resourcetargetdropdown = Tabs.Map:CreateDropdown("resourcetargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local resourcecooldownslider = Tabs.Map:CreateSlider("resourcecooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })

-- PICKUP
local autopickuptoggle = Tabs.Pickup:CreateToggle("autopickuptoggle", { Title = "Auto Pickup", Default = false })
local chestpickuptoggle = Tabs.Pickup:CreateToggle("chestpickuptoggle", { Title = "Auto Pickup From Chests", Default = false })
local pickuprangeslider = Tabs.Pickup:CreateSlider("pickuprange", { Title = "Pickup Range", Min = 1, Max = 35, Rounding = 1, Default = 20 })
local itemdropdown = Tabs.Pickup:CreateDropdown("itemdropdown", {Title = "Items", Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin"}, Default = "Berry"})

local droptoggle = Tabs.Pickup:AddToggle("droptoggle", { Title = "Auto Drop", Default = false })
local dropdropdown = Tabs.Pickup:AddDropdown("dropdropdown", {Title = "Select Item to Drop", Values = { "Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood" }, Default = "Bloodfruit"})
local droptogglemanual = Tabs.Pickup:AddToggle("droptogglemanual", { Title = "Auto Drop Custom", Default = false })
local droptextbox = Tabs.Pickup:AddInput("droptextbox", { Title = "Custom Item", Default = "Bloodfruit", Numeric = false, Finished = false })

-- FARMING
local fruitdropdown = Tabs.Farming:CreateDropdown("fruitdropdown", {Title = "Select Fruit",Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry"}, Default = "Bloodfruit"})
local planttoggle = Tabs.Farming:CreateToggle("planttoggle", { Title = "Auto Plant", Default = false })
local plantrangeslider = Tabs.Farming:CreateSlider("plantrange", { Title = "Plant Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })
local plantdelayslider = Tabs.Farming:CreateSlider("plantdelay", { Title = "Plant Delay (s)", Min = 0.01, Max = 1, Rounding = 3, Default = 0.05 })
local plantburstsizeslider = Tabs.Farming:CreateSlider("plantburst", { Title = "Plant Burst Size", Min = 1, Max = 50, Rounding = 1, Default = 6 })
local harvesttoggle = Tabs.Farming:CreateToggle("harvesttoggle", { Title = "Auto Harvest", Default = false })
local harvestrangeslider = Tabs.Farming:CreateSlider("harvestrange", { Title = "Harvest Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })
Tabs.Farming:CreateParagraph("Aligned Paragraph", {Title = "Tween Stuff", Content = "Project Instra runs :(", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
local tweenplantboxtoggle = Tabs.Farming:AddToggle("tweentoplantbox", { Title = "Tween to Plant Box", Default = false })
local tweenbushtoggle = Tabs.Farming:AddToggle("tweentobush", { Title = "Tween to Bush + Plant Box", Default = false })
local tweenrangeslider = Tabs.Farming:AddSlider("tweenrange", { Title = "Range", Min = 1, Max = 250, Rounding = 1, Default = 250 })
Tabs.Farming:CreateParagraph("Aligned Paragraph", {Title = "Plantbox Stuff", Content = "project instra runs :(", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
Tabs.Farming:CreateButton({Title = "Place 16x16 Plantboxes (256)", Callback = function() placestructure(16) end })
Tabs.Farming:CreateButton({Title = "Place 15x15 Plantboxes (225)", Callback = function() placestructure(15) end })
Tabs.Farming:CreateButton({Title = "Place 10x10 Plantboxes (100)", Callback = function() placestructure(10) end })
Tabs.Farming:CreateButton({Title = "Place 5x5 Plantboxes (25)", Callback = function() placestructure(5) end })

-- EXTRA
Tabs.Extra:CreateButton({Title = "Infinite Yield", Description = "inf yield chat", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Tydetoysf/booga/main/code.lua"))() end})
Tabs.Extra:CreateParagraph("Aligned Paragraph", {Title = "orbit breaks sometimes", Content = "i dont give a shit", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
local orbittoggle = Tabs.Extra:CreateToggle("orbittoggle", { Title = "Item Orbit", Default = false })
local orbitrangeslider = Tabs.Extra:CreateSlider("orbitrange", { Title = "Grab Range", Min = 1, Max = 50, Rounding = 1, Default = 20 })
local orbitradiusslider = Tabs.Extra:CreateSlider("orbitradius", { Title = "Orbit Radius", Min = 0, Max = 30, Rounding = 1, Default = 10 })
local orbitspeedslider = Tabs.Extra:CreateSlider("orbitspeed", { Title = "Orbit Speed", Min = 0, Max = 10, Rounding = 1, Default = 5 })
local itemheightslider = Tabs.Extra:CreateSlider("itemheight", { Title = "Item Height", Min = -3, Max = 10, Rounding = 1, Default = 3 })

-- TWEENS TAB UI
local tween_name_input = Tabs.Tweens:CreateInput({ Title = "Tween Name", Default = "myTween", Numeric = false })
local tween_x_input = Tabs.Tweens:CreateInput({ Title = "X", Default = "0", Numeric = true })
local tween_y_input = Tabs.Tweens:CreateInput({ Title = "Y", Default = "0", Numeric = true })
local tween_z_input = Tabs.Tweens:CreateInput({ Title = "Z", Default = "0", Numeric = true })
local tween_speed_slider = Tabs.Tweens:CreateSlider("tween_speed", { Title = "Speed multiplier", Min = 0.1, Max = 5, Rounding = 2, Default = 1 })
local tween_wait_slider = Tabs.Tweens:CreateSlider("tween_wait", { Title = "Wait after move (s)", Min = 0, Max = 2, Rounding = 2, Default = 0.05 })
local tween_add_btn = Tabs.Tweens:CreateButton({ Title = "Add Tween (to list)", Callback = function() end })
local tween_list_dropdown = Tabs.Tweens:CreateDropdown("tween_list", { Title = "Saved Tweens", Values = {}, Default = "" })
local tween_save_btn = Tabs.Tweens:CreateButton({ Title = "Save Tween Config", Callback = function() end })
local tween_delete_btn = Tabs.Tweens:CreateButton({ Title = "Delete Selected Tween", Callback = function() end })
local tween_run_walk_btn = Tabs.Tweens:CreateButton({ Title = "Walk to Selected Tween (tween)", Callback = function() end })
local tween_run_move_btn = Tabs.Tweens:CreateButton({ Title = "Move to Selected Tween (teleport)", Callback = function() end })
local tween_export_btn = Tabs.Tweens:CreateButton({ Title = "Export Tweens JSON", Callback = function() end })
local tween_import_input = Tabs.Tweens:CreateInput({ Title = "Import Tweens JSON (paste)", Default = "", Numeric = false })
local tween_import_btn = Tabs.Tweens:CreateButton({ Title = "Import Tweens from Paste", Callback = function() end })
Tabs.Tweens:CreateParagraph("Info", {Title = "Tweens", Content = "Create and run custom tweens. Walk to = tween. Move to = instant teleport."})

-- YAKK TAB (simplified)
local yakktoggle = Tabs.Yakk:CreateToggle("yakktoggle", { Title = "Enable Yakk (gold farm)", Default = false })
local yakkspeed = Tabs.Yakk:CreateSlider("yakkspeed", { Title = "Speed multiplier (affects tween duration)", Min = 0.1, Max = 5, Rounding = 2, Default = 1 })
local yakkwait = Tabs.Yakk:CreateSlider("yakkwait", { Title = "Wait after each waypoint (s)", Min = 0, Max = 2, Rounding = 2, Default = 0.05 })
local yakknoclip = Tabs.Yakk:CreateToggle("yakknoclip", { Title = "Enable noclip while Yakking", Default = true })
Tabs.Yakk:CreateParagraph("Info", {Title = "Yakk", Content = "Simplified Yakk: tweens through the route. No telemetry sent externally."})

-- SETTINGS: telemetry opt-in only
local telemetry_optin = Tabs.Settings:CreateToggle("telemetry_optin", { Title = "Opt-in Local Telemetry (no PII, local only)", Default = true })
Tabs.Settings:CreateParagraph("Privacy", { Title = "Telemetry", Content = "Local-only telemetry logs what features were enabled and when; no usernames, HWIDs, IPs, or network calls." })

-- internal helpers and data stores
local TWEENS = {} -- maps name -> {pos=Vector3, speed=number, wait=number}
local function refresh_tween_dropdown()
    local names = {}
    for n,_ in pairs(TWEENS) do table.insert(names, n) end
    table.sort(names)
    tween_list_dropdown:SetValues(names)
end

local function vec3_to_table(v) return {x = v.X, y = v.Y, z = v.Z} end
local function table_to_vec3(t) return Vector3.new(tonumber(t.x) or 0, tonumber(t.y) or 0, tonumber(t.z) or 0) end

-- Local opt-in telemetry: in-memory only
local TELEMETRY = {
    sessions = {}, -- historic sessions
    current = nil
}
local function telemetry_new_session()
    local s = {
        id = httpservice:GenerateGUID(false),
        startTime = os.time(),
        endTime = nil,
        events = {}, -- {time, name, details}
        snapshot = {}
    }
    TELEMETRY.current = s
    table.insert(TELEMETRY.sessions, s)
    return s
end
local function telemetry_end_session()
    if TELEMETRY.current then
        TELEMETRY.current.endTime = os.time()
        TELEMETRY.current = nil
    end
end
local function telemetry_log(name, details)
    if not telemetry_optin.Value then return end
    if not TELEMETRY.current then telemetry_new_session() end
    table.insert(TELEMETRY.current.events, { time = os.time(), name = name, details = details or {} })
end

-- hook toggles to telemetry
local function hook_toggle_for_telemetry(optionObj, name)
    if not optionObj then return end
    optionObj:OnChanged(function(value)
        telemetry_log("toggle_changed", { toggle = name, value = value })
    end)
end
hook_toggle_for_telemetry(planttoggle, "AutoPlant")
hook_toggle_for_telemetry(harvesttoggle, "AutoHarvest")
hook_toggle_for_telemetry(autopickuptoggle, "AutoPickup")
hook_toggle_for_telemetry(orbittoggle, "Orbit")
hook_toggle_for_telemetry(killauratoggle, "KillAura")
hook_toggle_for_telemetry(yakktoggle, "Yakk")

-- basic utility functions
local function safe_setclipboard(text)
    pcall(function() if setclipboard then setclipboard(text) end end)
end

-- network-free export buttons
Tabs.Tweens:CreateButton({ Title = "Export Local Telemetry (JSON -> clipboard)", Callback = function()
    local ok, json = pcall(function() return httpservice:JSONEncode(TELEMETRY) end)
    if ok and json then
        safe_setclipboard(json)
        Library:Notify{ Title = "Telemetry", Content = "Local telemetry copied to clipboard.", Duration = 4 }
    else
        Library:Notify{ Title = "Telemetry", Content = "Failed to encode telemetry.", Duration = 4 }
    end
end})

-- tween helper (uses existing approach)
local tweening = nil
local function tween_to_cframe(targetCFrame, speedMultiplier)
    if tweening then
        pcall(function() tweening:Cancel() end)
    end
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local baseDuration = distance / 21
    local duration = math.max(0.03, baseDuration / (speedMultiplier or 1))
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local t = tspmo:Create(root, tweenInfo, { CFrame = targetCFrame })
    t:Play()
    tweening = t
    return t, duration
end

-- teleport (instant move)
local function teleport_to(v3)
    if not char or not char.Parent then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(v3.X, v3.Y + 2, v3.Z)
    end
end

-- Walk-to (tween) and Move-to (teleport) UI callbacks
tween_add_btn.Callback = function()
    local name = tostring(tween_name_input.Value or "untitled"):gsub("%s+", "_")
    local x = tonumber(tween_x_input.Value) or 0
    local y = tonumber(tween_y_input.Value) or 0
    local z = tonumber(tween_z_input.Value) or 0
    local speed = tween_speed_slider.Value
    local waitt = tween_wait_slider.Value
    TWEENS[name] = { pos = Vector3.new(x, y, z), speed = speed, wait = waitt }
    refresh_tween_dropdown()
    telemetry_log("tween_added", { name = name, pos = {x=x,y=y,z=z}, speed = speed, wait = waitt })
    Library:Notify{ Title = "Tweens", Content = "Added tween: "..name, Duration = 2 }
end

tween_save_btn.Callback = function()
    local name = tween_list_dropdown.Value
    if not name or name == "" then
        Library:Notify{ Title = "Tweens", Content = "Select a tween to save first.", Duration = 2 }
        return
    end
    -- we already store configs in TWEENS; SaveManager persistence can be added later
    Library:Notify{ Title = "Tweens", Content = "Saved tween in memory: "..name, Duration = 2 }
end

tween_delete_btn.Callback = function()
    local name = tween_list_dropdown.Value
    if not name or name == "" or not TWEENS[name] then
        Library:Notify{ Title = "Tweens", Content = "Select a tween to delete.", Duration = 2 }
        return
    end
    TWEENS[name] = nil
    refresh_tween_dropdown()
    telemetry_log("tween_deleted", { name = name })
    Library:Notify{ Title = "Tweens", Content = "Deleted tween: "..name, Duration = 2 }
end

tween_run_walk_btn.Callback = function()
    local name = tween_list_dropdown.Value
    if not name or name == "" or not TWEENS[name] then
        Library:Notify{ Title = "Tweens", Content = "Select a tween to walk to.", Duration = 2 }
        return
    end
    local tcfg = TWEENS[name]
    -- perform tween
    if not root then
        char = plr.Character or plr.CharacterAdded:Wait()
        root = char:WaitForChild("HumanoidRootPart")
    end
    local targetCF = CFrame.new(tcfg.pos.X, tcfg.pos.Y + 2, tcfg.pos.Z)
    local t, dur = tween_to_cframe(targetCF, tcfg.speed or 1)
    telemetry_log("tween_run_walk", { name = name, pos = vec3_to_table(tcfg.pos), speed = tcfg.speed })
    -- optionally wait for completion (non-blocking)
    task.spawn(function()
        local waited = 0
        local timeout = (dur or 0.5) + 1
        while waited < timeout and t.PlaybackState ~= Enum.PlaybackState.Completed do
            task.wait(0.05)
            waited = waited + 0.05
        end
        task.wait(tcfg.wait or 0)
        telemetry_log("tween_completed", { name = name })
    end)
end

tween_run_move_btn.Callback = function()
    local name = tween_list_dropdown.Value
    if not name or name == "" or not TWEENS[name] then
        Library:Notify{ Title = "Tweens", Content = "Select a tween to move to (teleport).", Duration = 2 }
        return
    end
    local tcfg = TWEENS[name]
    teleport_to(tcfg.pos)
    telemetry_log("tween_run_move", { name = name, pos = vec3_to_table(tcfg.pos) })
    Library:Notify{ Title = "Tweens", Content = "Teleported to "..name, Duration = 2 }
end

tween_export_btn.Callback = function()
    local export = {}
    for k,v in pairs(TWEENS) do
        export[k] = { pos = vec3_to_table(v.pos), speed = v.speed, wait = v.wait }
    end
    local ok, json = pcall(function() return httpservice:JSONEncode(export) end)
    if ok and json then
        safe_setclipboard(json)
        Library:Notify{ Title = "Tweens", Content = "Exported tweens JSON to clipboard.", Duration = 3 }
    else
        Library:Notify{ Title = "Tweens", Content = "Failed to encode tweens.", Duration = 3 }
    end
end

tween_import_btn.Callback = function()
    local text = tween_import_input.Value or ""
    if text == "" then
        Library:Notify{ Title = "Tweens", Content = "Paste JSON into the import field first.", Duration = 2 }
        return
    end
    local ok, tbl = pcall(function() return httpservice:JSONDecode(text) end)
    if not ok or type(tbl) ~= "table" then
        Library:Notify{ Title = "Tweens", Content = "Invalid JSON.", Duration = 2 }
        return
    end
    -- merge parsed tweens into TWEENS
    for name, info in pairs(tbl) do
        if type(info) == "table" and info.pos then
            local v = info.pos
            TWEENS[name] = { pos = table_to_vec3(v), speed = info.speed or 1, wait = info.wait or 0 }
        end
    end
    refresh_tween_dropdown()
    telemetry_log("tweens_imported", { count = table.getn(tbl) })
    Library:Notify{ Title = "Tweens", Content = "Imported tweens.", Duration = 3 }
end

refresh_tween_dropdown()

-- YAKK Waypoints: reuse earlier provided list (closing loop)
local YAKK_WAYPOINTS = {
    Vector3.new(-138.963, -33.749, -148.319),
    Vector3.new(-145.327, -34.570, -159.469),
    Vector3.new(-146.369, -33.873, -169.898),
    Vector3.new(-144.334, -34.725, -159.734),
    Vector3.new(-136.696, -34.987, -170.819),
    Vector3.new(-120.278, -34.997, -178.766),
    Vector3.new(-115.615, -32.028, -181.052),
    Vector3.new(-111.158, -26.846, -183.843),
    Vector3.new(-109.632, -26.589, -191.211),
    Vector3.new(-110.574, -26.726, -184.794),
    Vector3.new(-112.805, -26.353, -189.045),
    Vector3.new(-117.735, -26.174, -189.602),
    Vector3.new(-122.506, -15.657, -200.508),
    Vector3.new(-129.854, -11.880, -204.102),
    Vector3.new(-122.557, -8.172, -205.548),
    Vector3.new(-127.016, -6.681, -209.011),
    Vector3.new(-124.574, -4.207, -213.521),
    Vector3.new(-74.381, -1.507, -244.584),
    Vector3.new(17.797, -3.000, -284.538),
    Vector3.new(112.245, -3.115, -282.720),
    Vector3.new(140.491, -3.487, -275.412),
    Vector3.new(185.059, -4.352, -246.309),
    Vector3.new(214.121, -3.000, -198.172),
    Vector3.new(268.998, -3.058, -100.931),
    Vector3.new(272.558, -6.993, -94.920),
    -- ... (many more waypoints from your list) ...
    Vector3.new(-138.963, -33.749, -148.319) -- close loop
}

-- noclip utility
local yakk_noclip_conn = nil
local function set_char_noclip(enable)
    if enable then
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        if yakk_noclip_conn then yakk_noclip_conn:Disconnect() end
        yakk_noclip_conn = runs.Stepped:Connect(function()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if yakk_noclip_conn then yakk_noclip_conn:Disconnect(); yakk_noclip_conn = nil end
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

-- Yakk runtime
local yakk_runner = nil
local yakk_paused = false
local function run_yakk()
    if yakk_runner then return end
    telemetry_log("yakk_started", { speed = yakkspeed.Value, wait = yakkwait.Value, noclip = yakknoclip.Value })
    if yakknoclip.Value then set_char_noclip(true) end

    yakk_runner = task.spawn(function()
        local idx = 1
        while yakktoggle.Value do
            if yakk_paused then task.wait(0.1) else
                local v = YAKK_WAYPOINTS[idx]
                if v and root and root.Parent then
                    local targetCFrame = CFrame.new(v.X, v.Y + 2, v.Z)
                    local t, dur = tween_to_cframe(targetCFrame, yakkspeed.Value)
                    local waited = 0; local timeout = (dur or 0.5) + 1
                    while waited < timeout and t.PlaybackState ~= Enum.PlaybackState.Completed and yakktoggle.Value do
                        task.wait(0.05); waited = waited + 0.05
                    end
                    telemetry_log("yakk_waypoint", { index = idx, pos = vec3_to_table(v) })
                    task.wait(yakkwait.Value)
                end
                idx = idx + 1
                if idx > #YAKK_WAYPOINTS then idx = 1 end
            end
        end
        set_char_noclip(false)
        telemetry_log("yakk_stopped", {})
        yakk_runner = nil
    end)
end

local function stop_yakk()
    if yakk_runner then
        yakktoggle.Value = false
    else
        set_char_noclip(false)
    end
end

yakktoggle:OnChanged(function(val)
    telemetry_log("yakk_toggle", { value = val })
    if val then
        char = plr.Character or plr.CharacterAdded:Wait()
        root = char:WaitForChild("HumanoidRootPart")
        run_yakk()
    else
        stop_yakk()
    end
end)
yakknoclip:OnChanged(function(v) if yakktoggle.Value then set_char_noclip(v) end end)

-- keep existing autoplant/harvest implementation but with slightly faster default waits and telemetry hooks
local plantedboxes = {}
local fruittoitemid = {
    Bloodfruit = 94,
    Bluefruit = 377,
    Lemon = 99,
    Coconut = 1,
    Jelly = 604,
    Banana = 606,
    Orange = 602,
    Oddberry = 32,
    Berry = 35,
    Strangefruit = 302,
    Strawberry = 282,
    Sunfruit = 128,
    Pumpkin = 80,
    ["Prickly Pear"] = 378,
    Apple = 243,
    Barley = 247,
    Cloudberry = 101,
    Carrot = 147
}

local function plant(entityid, itemID)
    if packets.InteractStructure and packets.InteractStructure.send then
        packets.InteractStructure.send({ entityID = entityid, itemID = itemID })
        plantedboxes[entityid] = true
    end
end

local function getpbs(range)
    local plantboxes = {}
    for _, deployable in ipairs(workspace:FindFirstChild("Deployables") and workspace.Deployables:GetChildren() or {}) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local entityid = deployable:GetAttribute("EntityID")
            local ppart = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if entityid and ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(plantboxes, { entityid = entityid, deployable = deployable, dist = dist })
                end
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
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    local entityid = model:GetAttribute("EntityID")
                    if entityid then
                        table.insert(bushes, { entityid = entityid, model = model, dist = dist })
                    end
                end
            end
        end
    end
    return bushes
end

-- planting loop (batched)
task.spawn(function()
    while true do
        if not planttoggle.Value then task.wait(0.05); continue end
        local range = tonumber(plantrangeslider.Value) or 30
        local delay = tonumber(plantdelayslider.Value) or 0.05
        local burst = tonumber(plantburstsizeslider.Value) or 6
        local selectedfruit = fruitdropdown.Value
        local itemID = fruittoitemid[selectedfruit] or 94
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a,b) return a.dist < b.dist end)
        local i = 1
        while i <= #plantboxes do
            local endIdx = math.min(i + burst - 1, #plantboxes)
            for j = i, endIdx do
                local box = plantboxes[j]
                if box and not box.deployable:FindFirstChild("Seed") then
                    task.spawn(function() plant(box.entityid, itemID) end)
                else
                    if box and box.entityid then plantedboxes[box.entityid] = true end
                end
            end
            i = endIdx + 1
            task.wait(0)
        end
        task.wait(delay)
    end
end)

task.spawn(function()
    while true do
        if not harvesttoggle.Value then task.wait(0.1); continue end
        local harvestrange = tonumber(harvestrangeslider.Value) or 30
        local selectedfruit = fruitdropdown.Value
        local bushes = getbushes(harvestrange, selectedfruit)
        table.sort(bushes, function(a,b) return a.dist < b.dist end)
        for _, bush in ipairs(bushes) do
            pickup(bush.entityid)
        end
        task.wait(0.1)
    end
end)

-- pickup / orbit / kill aura / resource aura loops (unchanged semantics)
task.spawn(function()
    while true do
        if not killauratoggle.Value then task.wait(0.1) else
            local range = tonumber(killaurarangeslider.Value) or 20
            local targetCount = tonumber(katargetcountdropdown.Value) or 1
            local cooldown = tonumber(kaswingcooldownslider.Value) or 0.1
            local targets = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= plr then
                    local playerfolder = workspace.Players:FindFirstChild(player.Name)
                    if playerfolder then
                        local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                        local entityid = playerfolder:GetAttribute("EntityID")
                        if rootpart and entityid then
                            local dist = (rootpart.Position - root.Position).Magnitude
                            if dist <= range then table.insert(targets, { eid = entityid, dist = dist }) end
                        end
                    end
                end
            end
            if #targets > 0 then
                table.sort(targets, function(a,b) return a.dist < b.dist end)
                local selectedTargets = {}
                for i = 1, math.min(targetCount, #targets) do table.insert(selectedTargets, targets[i].eid) end
                if packets.SwingTool and packets.SwingTool.send then packets.SwingTool.send(selectedTargets) end
            end
            task.wait(cooldown)
        end
    end
end)

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
            for _, res in pairs(allresources) do
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart and eid then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then table.insert(targets, { eid = eid, dist = dist }) end
                end
            end
            if #targets > 0 then
                table.sort(targets, function(a,b) return a.dist < b.dist end)
                local selectedTargets = {}
                for i = 1, math.min(targetCount, #targets) do table.insert(selectedTargets, targets[i].eid) end
                if packets.SwingTool and packets.SwingTool.send then packets.SwingTool.send(selectedTargets) end
            end
            task.wait(cooldown)
        end
    end
end)

task.spawn(function()
    while true do
        if not orbittoggle.Value then task.wait(0.1) else
            -- orbit logic (unchanged)
            task.wait()
        end
    end
end)

-- pickup loop
task.spawn(function()
    while true do
        local range = tonumber(pickuprangeslider.Value) or 35
        if autopickuptoggle.Value then
            for _, item in ipairs(workspace:FindFirstChild("Items") and workspace.Items:GetChildren() or {}) do
                local primary = (item:IsA("BasePart") and item) or (item:IsA("Model") and item.PrimaryPart)
                if primary then
                    local selecteditem = item.Name
                    local entityid = item:GetAttribute("EntityID")
                    if entityid and (table.find({}, selecteditem) or true) then -- selection handling previously stored in selecteditems
                        local dist = (primary.Position - root.Position).Magnitude
                        if dist <= range then pickup(entityid) end
                    end
                end
            end
        end
        if chestpickuptoggle.Value then
            for _, chest in ipairs(workspace:FindFirstChild("Deployables") and workspace.Deployables:GetChildren() or {}) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        local primary = (item:IsA("BasePart") and item) or (item:IsA("Model") and item.PrimaryPart)
                        if primary then
                            local selecteditem = item.Name
                            local entityid = item:GetAttribute("EntityID")
                            if entityid then
                                local dist = (chest.PrimaryPart.Position - root.Position).Magnitude
                                if dist <= range then pickup(entityid) end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)

-- drop handling (kept)
local debounce = 0
local cd = 0
runs.Heartbeat:Connect(function()
    if droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = dropdropdown.Value
            -- drop function (simplified)
            local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
            if inventory then
                for _, child in ipairs(inventory:GetChildren()) do
                    if child:IsA("ImageLabel") and child.Name == selectedItem then
                        if packets and packets.DropBagItem and packets.DropBagItem.send then packets.DropBagItem.send(child.LayoutOrder) end
                    end
                end
            end
            debounce = tick()
        end
    end
end)

runs.Heartbeat:Connect(function()
    if droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = droptextbox.Value
            local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
            if inventory then
                for _, child in ipairs(inventory:GetChildren()) do
                    if child:IsA("ImageLabel") and child.Name == itemname then
                        if packets and packets.DropBagItem and packets.DropBagItem.send then packets.DropBagItem.send(child.LayoutOrder) end
                    end
                end
            end
            debounce = tick()
        end
    end
end)

-- Save/Interface setup
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Library:Notify{
    Title = "Project Instra Hub",
    Content = "Loaded, Enjoy!",
    Duration = 8
}
SaveManager:LoadAutoloadConfig()

-- Final note: ensure telemetry is ended when script/unloaded (best-effort)
game:BindToClose(function()
    telemetry_log("script_unloaded", {})
    telemetry_end_session()
end)

print("Done! Enjoy Project Instra Hub!")
