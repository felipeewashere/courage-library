-- Demo / test script. Run it in the executor after `node LibraryV2/build.mjs --install`.
local Library = loadstring(readfile("CourageUI/CourageUI.lua"))()
local ThemeManager, SaveManager = Library.ThemeManager, Library.SaveManager
local Toggles, Options = Library.Toggles, Library.Options

local Window = Library:CreateWindow({ Title = "Courage Hub", Footer = "Demo game", AutoShow = true })

local Home = Window:AddTab("Home", "house")
local Farm = Window:AddTab("Farming", "leaf")
local Combat = Window:AddTab("Combat", "swords")
local Misc = Window:AddTab("Misc", "layout-grid")
local Settings = Window:AddTab({ Name = "UI Settings", Icon = "settings", Footer = true })
local Profile = Window:AddTab({ Name = "Profile", Icon = "user", Footer = true })

---------------------------------------------------------------- Home (matches the prototype)
local Farming = Home:AddLeftGroupbox("Farming", "zap")
Farming:AddToggle("AutoFarm", { Text = "Auto Farm", Default = true, Tooltip = "Farms the nearest mob." })
    :AddKeyPicker("AutoFarmKey", { Default = "F", SyncToggleState = true, Text = "Auto Farm" })
Farming:AddDropdown("FarmMode", { Text = "Farm Mode", Values = { "Nearest", "Strongest", "Weakest", "Random" }, Default = 1 })
Farming:AddSlider("FarmDelay", { Text = "Farm Delay", Default = 0.5, Min = 0, Max = 2, Rounding = 1, Suffix = "s" })
local FarmExtra = Farming:AddDependencyBox()
FarmExtra:AddToggle("FarmBosses", { Text = "Include Bosses", Default = false })
FarmExtra:AddDropdown("FarmTargets", { Text = "Targets", Values = { "Bandit", "Wolf", "Golem", "Dragon" }, Multi = true, Default = { "Bandit" } })
FarmExtra:SetupDependencies({ { Toggles.AutoFarm, true } })

local Tp = Home:AddLeftGroupbox("Teleport", "map-pin")
Tp:AddDropdown("Zone", { Text = "Select Zone", Values = { "Starter Village", "Dark Forest", "Frozen Peak", "Lava Cave", "Sky Temple",
    "Sunken City", "Crystal Mine", "Dragon Nest", "Royal Castle", "Ancient Ruins", "Shadow Realm", "Coral Reef", "Thunder Plains" }, Default = 1 })
Tp:AddButton({ Text = "Teleport", Func = function() Library:Notify({ Title = "Teleport", Description = "Going to " .. tostring(Options.Zone.Value) }) end })
Tp:AddToggle("BringMob", { Text = "Bring Mob (Loop)", Default = false })

local Fight = Home:AddRightGroupbox("Combat", "swords")
Fight:AddToggle("AutoAttack", { Text = "Auto Attack", Default = true })
Fight:AddToggle("SkillManager", { Text = "Skill Manager", Default = false })
Fight:AddSlider("AttackDistance", { Text = "Attack Distance", Default = 12, Min = 1, Max = 30, Rounding = 1 })

local Utilities = Home:AddRightGroupbox("Utilities", "sparkles")
Utilities:AddToggle("NoCooldown", { Text = "No Cooldown", Default = true })
Utilities:AddToggle("InfStamina", { Text = "Infinite Stamina", Default = true, Risky = true })
Utilities:AddSlider("WalkSpeed", { Text = "Walk Speed", Default = 32, Min = 16, Max = 200 })
Utilities:AddSlider("JumpPower", { Text = "Jump Power", Default = 100, Min = 50, Max = 300 })

---------------------------------------------------------------- Farming: sub tabs + tabbox
local Mobs = Farm:AddSubTab("Mobs")
local Quests = Farm:AddSubTab("Quests")
local MobBox = Mobs:AddLeftGroupbox("Mob Farm", "skull")
MobBox:AddToggle("MobFarm", { Text = "Farm Mobs" })
MobBox:AddInput("MobName", { Text = "Mob Name", Placeholder = "Bandit" })
MobBox:AddInput("MobCount", { Text = "Kill Count", Numeric = true, Default = "10" })
local Tabbed = Mobs:AddRightTabbox("Loot")
local Drops = Tabbed:AddTab("Drops")
Drops:AddToggle("AutoLoot", { Text = "Auto Loot", Default = true })
Drops:AddSlider("LootRange", { Text = "Range", Default = 40, Min = 10, Max = 100 })
local Sell = Tabbed:AddTab("Sell")
Sell:AddToggle("AutoSell", { Text = "Auto Sell" })
Sell:AddDropdown("SellRarity", { Text = "Rarity", Values = { "Common", "Rare", "Epic", "Legendary" }, Multi = true })
local QuestBox = Quests:AddLeftGroupbox("Quests", "scroll")
QuestBox:AddToggle("AutoQuest", { Text = "Auto Quest" })
QuestBox:AddLabel("Quests are picked by level. This label wraps over several lines when the text is long.", true)

---------------------------------------------------------------- Combat: colours, keys, player list, a long list to scroll
local Esp = Combat:AddLeftGroupbox("ESP", "eye")
Esp:AddToggle("Esp", { Text = "Player ESP" }):AddColorPicker("EspColor", { Default = Color3.fromRGB(150, 84, 255), Transparency = 0 })
local Tracers = Esp:AddToggle("Tracers", { Text = "Tracers" })
Tracers:AddColorPicker("TracerColor", { Default = Color3.fromRGB(255, 92, 150) })
Tracers:AddKeyPicker("TracerKey", { Default = "T", Mode = "Hold", Text = "Tracers" })
Esp:AddDropdown("Target", { Text = "Target", SpecialType = "Player", AllowNull = true })
Esp:AddLabel("Aim key"):AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold", Text = "Aim" })
local Many = Combat:AddRightGroupbox("Scrolling test", "list")
for index = 1, 22 do Many:AddToggle("Scroll" .. index, { Text = "Option " .. index }) end

---------------------------------------------------------------- Misc
local Actions = Misc:AddLeftGroupbox("Actions", "mouse-pointer-click")
Actions:AddButton("Notify", function() Library:Notify("A plain notification.", 4) end)
    :AddButton("Long notify", function()
        Library:Notify({ Title = "Boss spawned", Description = "The Dragon King spawned in Lava Cave. This text wraps onto more lines.", Time = 6 })
    end)
Actions:AddButton("Warning", function()
    Library:Notify({ Type = "Warning", Title = "Moderator joined", Description = "A staff member is in this server.", Time = 6 })
end):AddButton("Danger", function()
    Library:Notify({ Type = "Danger", Title = "Risky feature", Description = "This one can get the account flagged.", Time = 6 })
end)
Actions:AddButton("Success", function()
    Library:Notify({ Type = "Success", Title = "Config saved", Description = "Saved as default.", Time = 6 })
end):AddButton("Info", function()
    Library:Notify({ Type = "Info", Title = "Update", Description = "A new version is out.", Time = 6 })
end)
Actions:AddButton({ Text = "Dialog", Style = "Secondary", Func = function()
    Window:AddDialog("Test", { Title = "Rejoin the server?", Description = "You will lose unsaved progress.", FooterButtons = {
        No = { Title = "Cancel", Order = 1 },
        Yes = { Title = "Rejoin", Variant = "Primary", Order = 2, Callback = function(dialog)
            dialog.Dismiss()
            Library:Notify("Rejoining (not really).")
        end },
    } })
end })
Actions:AddButton({ Text = "Dangerous", Risky = true, DoubleClick = true, Func = function() Library:Notify("Done.") end })

---------------------------------------------------------------- Settings + Profile (the two icons under the divider)
ThemeManager:SetFolder("CourageUI")
SaveManager:SetFolder("CourageUI/Demo")
SaveManager:IgnoreThemeSettings()
ThemeManager:ApplyToTab(Settings)
ThemeManager:CreateMenuSettings(Settings:AddRightGroupbox("Menu", "sliders-horizontal"))
SaveManager:BuildConfigSection(Settings)

local Account = Profile:AddLeftGroupbox("Discord", "message-circle")
Account:AddLabel("Join the server for updates and support.", true)
Account:AddButton("Copy invite", function()
    if setclipboard then setclipboard("https://discord.gg/48gGrFK3YE") end
    Library:Notify({ Title = "Discord", Description = "Invite copied." })
end)
local Me = Profile:AddRightGroupbox("Roblox", "user")
Me:AddLabel("Name: " .. game:GetService("Players").LocalPlayer.Name)
Me:AddLabel("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))

Library:SetWatermark("Courage Hub")
Toggles.Menu_Watermark:SetValue(true)
SaveManager:LoadAutoloadConfig()
Library:Notify({ Title = "Courage Hub", Description = "Loaded. Right Shift hides the menu.", Time = 5 })
return Library
