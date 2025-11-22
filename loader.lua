if getgenv().ProjectInfra then
    return error("ProjectInfra is already loaded")
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().ProjectInfra = {
    Premium = true,
    Dev = true,
    Connections = {},
    Pages = {},
    Tabs = {Tabs = {}},
    Corners = {},
    Load = os.clock(),
    Notifications = {Objects = {}, Active = {}},
    ArrayList = {Objects = {}, Loaded = false},
    ControlsVisible = true,
    Mobile = false,
    CurrentOpenTab = nil,
    GameSave = game.PlaceId,
    CheckOtherConfig = true,
    Assets = {},
    Teleporting = false,
    InitSave = nil,
    Config = {
        UI = {
            Position = {X = 0.5, Y = 0.5},
            Size = {X = 0.37294304370880129, Y = 0.683131217956543},
            FullScreen = false,
            ToggleKeyCode = "LeftAlt",
            Scale = 1,
            Notifications = true,
            Anim = true,
            ArrayList = false,
            TabColor = {value1 = 25, value2 = 25, value3 = 25},
            TabTransparency = 0.03,
            KeybindTransparency = 0.7,
            KeybindColor = {value1 = 0, value2 = 0, value3 = 0},
        },
        Game = {
            Modules = {},
            Keybinds = {},
            Sliders = {},
            TextBoxes = {},
            MiniToggles = {},
            Dropdowns = {},
            ModuleKeybinds = {},
            Other = {}
        },
    }
} 
if getgenv().ProjectInfraInit then
    if getgenv().ProjectInfraInit.GameSave then
        getgenv().ProjectInfra.GameSave = getgenv().ProjectInfraInit.GameSave
    end
    if getgenv().ProjectInfraInit.CheckOtherConfig then
        getgenv().ProjectInfra.CheckOtherConfig = getgenv().ProjectInfraInit.CheckOtherConfig
    end
    if getgenv().ProjectInfraInit.Dev then
        getgenv().ProjectInfra.Dev = true
    end
    if getgenv().ProjectInfraInit.ShowAuthTime then
        getgenv().ProjectInfra.ShowAuthTime = true
    end
    getgenv().ProjectInfra.InitSave = getgenv().ProjectInfraInit
    getgenv().ProjectInfraInit = nil
end



local Assets = nil
if getgenv().ProjectInfra.Dev and isfile("ProjectInfra/Init.lua") then
    loadstring(readfile("ProjectInfra/Init.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tydetoysf/ProjectInfra/main/init.lua"))()
end
Assets = getgenv().ProjectInfra.Assets

if not Assets or typeof(Assets) ~= "table" or (Assets and not Assets.Functions) then
    getgenv().ProjectInfra = nil
    return warn("Failed to load Functions, ProjectInfra uninjected")
end

local uis = Assets.Functions.cloneref(game:GetService("UserInputService")) :: UserInputService
local ws = Assets.Functions.cloneref(game:GetService("Workspace")) :: Workspace
local plrs = Assets.Functions.cloneref(game:GetService("Players")) :: Players

local currentCamera = ws:FindFirstChildWhichIsA("Camera") :: Camera

if not uis.KeyboardEnabled and uis.TouchEnabled then
    getgenv().ProjectInfra.Mobile = true
    getgenv().ProjectInfra.Config.UI.Size = {X = 0.7, Y = 0.9}
end


if not isfolder("ProjectInfra") then
    makefolder("ProjectInfra")
end
if not isfolder("ProjectInfra/Config") then
    makefolder("ProjectInfra/Config")
end 
if not isfolder("ProjectInfra/Assets") then
    makefolder("ProjectInfra/Assets")
end
if not isfolder("ProjectInfra/Assets/Fonts") then
    makefolder("ProjectInfra/Assets/Fonts")
end

local gameinfo = Assets.Functions.GetGameInfo()
if typeof(gameinfo) == "table" then
    getgenv().ProjectInfra.GameRootId = gameinfo.rootPlaceId 
    if getgenv().ProjectInfra.GameSave == "root" then
        getgenv().ProjectInfra.GameSave = tostring(getgenv().ProjectInfra.GameRootId)
    end
end


local UI = Assets.Config.Load("UI", "UI")
local gamesave = Assets.Config.Load(tostring(getgenv().ProjectInfra.GameSave), "Game")
if UI == "no file" then
    Assets.Config.Save("UI", getgenv().ProjectInfra.Config.UI)
end

if gamesave == "no file" and getgenv().ProjectInfra.CheckOtherConfig then
    if getgenv().ProjectInfra.GameRootId == getgenv().ProjectInfra.GameSave then
        gamesave = Assets.Config.Load(tostring(game.PlaceId), "Game")
    else
        gamesave = Assets.Config.Load(tostring(getgenv().ProjectInfra.GameRootId), "Game")
    end
end

if gamesave == "no file" then
    Assets.Config.Save(tostring(getgenv().ProjectInfra.GameSave), getgenv().ProjectInfra.Config.Game)
end

if getgenv().ProjectInfra.Mobile then
    if currentCamera then
        if 0.4 >= (currentCamera.ViewportSize.X / 1000) - 0.1 then
            getgenv().ProjectInfra.Config.UI.Scale = 0.4
        else
            getgenv().ProjectInfra.Config.UI.Scale = (currentCamera.ViewportSize.X / 1000) - 0.1
        end
    end
end

if queue_on_teleport then
    table.insert(getgenv().ProjectInfra.Connections, plrs.LocalPlayer.OnTeleport:Connect(function(state)
        if not getgenv().ProjectInfra.Teleporting then
            getgenv().ProjectInfra.Teleporting = true

            local str = ""
            if getgenv().ProjectInfra.InitSave then
                str = "getgenv().ProjectInfraInit = {"
                for i, v in getgenv().ProjectInfra.InitSave do
                    if i ~= #getgenv().ProjectInfra.InitSave then
                        if typeof(v) == "string" then
                            str = str..tostring(i)..' = "'..tostring(v)..'" , '
                        else
                            str = str..tostring(i).." = "..tostring(v).." , "
                        end
                    end
                end
                str = string.sub(str, 0, #str-2).."}\n"
            end

            str = str..[[
                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end
                if getgenv().ProjectInfraInit and getgenv().ProjectInfraInit.Dev and isfile("ProjectInfra/Loader.lua") then
                    loadstring(readfile("ProjectInfra/Loader.lua"))()
                else
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tydetoysf/ProjectInfra/main/loader.lua"))()
                end
            ]]
            queue_on_teleport(str)
        end
    end))
end

Assets.Main.Load("Universal")
Assets.Main.Load(getgenv().ProjectInfra.GameSave)

Assets.Main.ToggleVisibility(true)

getgenv().ProjectInfra.Main = Assets.Main
getgenv().ProjectInfra.LoadTime = os.clock() - getgenv().ProjectInfra.Load
Assets.Notifications.Send({
    Description = "Loaded in " .. string.format("%.1f", getgenv().ProjectInfra.LoadTime) .. " seconds",
    Duration = 5
})
--[[if getgenv().ProjectInfra.Mobile or getgenv().ProjectInfra.Config.UI.ToggleKeyCode and getgenv().ProjectInfra.Config.UI.ToggleKeyCode ~= "" and getgenv().ProjectInfra.Config.UI.ToggleKeyCode ~= "Unknown" then
    task.wait(0.5)
    Assets.Notifications.Send({
        Description = "Current Keybind is: " .. getgenv().ProjectInfra.Config.UI.ToggleKeyCode,
        Duration = 5
    })
end]]
task.wait(0.15)

if not isfile("ProjectInfra/Version.txt") then
    writefile("ProjectInfra/Version.txt", "Current version: 2.1.5")
    Assets.Notifications.Send({
        Description = "ProjectInfra has been updated to V2.1.5",
        Duration = 15
    })
end

local text = readfile("ProjectInfra/Version.txt")
if text ~= "Current version: 2.1.5" then
    Assets.Notifications.Send({
        Description = "ProjectInfra has been updated to V2.1.5",
        Duration = 15
    })
    writefile("ProjectInfra/Version.txt", "Current version: 2.1.5")
end

ProjectInfra.Loaded = true
return Assets.Main
