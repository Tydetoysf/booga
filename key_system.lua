-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- CloudFramework UI
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/7siyuzi/CloudFramework/refs/heads/main/addons/SaveManager.lua'))()

-- Discord invite
local InviteLink = "https://discord.gg/cG6VUgKnzU"

-- ✅ Hard-coded keys
local ValidKeys = {
    "A9X4B7C2D6E1","Z3M8N1P4Q7R2","L5K9J2H8G3F0","W7E2R6T9Y1U3","Q8A1S4D7F2G5",
    "P9O3I6U2Y7T1","M4N8B2V5C9X0","J1K7L3M9N2O6","H5G8F2D4S7A9","E3R9T6Y1U8I2",
    -- … continue until you have 100 keys …
}

-- Script to load if key is valid
local ScriptURL = "https://raw.githubusercontent.com/Tydetoysf/ProjectInfra/main/arsenal.lua"

-- Create Window
local Window = Library:CreateWindow({
    Title = "Project Infra | Key System",
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("Key System"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}

-- Unified Groupbox
local Group = Tabs.Main:AddLeftGroupbox("Access System")

-- Discord Info
Group:AddLabel("To get a key join:\n" .. InviteLink .. "\nKeys are FREE and listed there.")
Group:AddButton("Copy Discord Invite", function()
    setclipboard(InviteLink)
    Library:Notify("Discord invite copied to clipboard!", 5)
end)

-- Key Entry
Group:AddInput("KeyInput", {
    Default = "",
    Numeric = false,
    Finished = false,
    Text = "Enter Key",
    Tooltip = "Type your access key here",
})

Group:AddButton("Submit Key", function()
    local enteredKey = Options.KeyInput.Value
    for _, key in ipairs(ValidKeys) do
        if enteredKey == key then
            Library:Notify("Key Accepted! Loading script...", 5)
            task.wait(1)
            Library:Unload()
            loadstring(game:HttpGet(ScriptURL))()
            return
        end
    end
    Library:Notify("Invalid Key. Try again.", 5)
end)

-- Theme + Save Manager setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"KeyInput"})
ThemeManager:SetFolder("infra-keysystem")
SaveManager:SetFolder("infra-keysystem/configs")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
