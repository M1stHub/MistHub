-- THIS SCRIPT WAS MADE FOR PERSONAL USE MEANING IT HAS VERY LITTLE OPTIMIZATION.

repeat
    wait()
until game:IsLoaded()
wait()

-- Not my adonis bypass - Everything else made by me (OneFool)
local getinfo = getinfo or debug.getinfo
local DEBUG = false
local Hooked = {}

local Detected, Kill

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local DetectFunc = rawget(v, "Detected")
        local KillFunc = rawget(v, "Kill")

        if typeof(DetectFunc) == "function" and not Detected then
            Detected = DetectFunc

            local Old; Old = hookfunction(Detected, function(Action, Info, NoCrash)
                if Action ~= "_" then
                    if DEBUG then
                        warn("Adonis AntiCheat flagged\nMethod: {Action}\nInfo: {Info}")
                    end
                end

                return true
            end)

            table.insert(Hooked, Detected)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
            Kill = KillFunc
            local Old; Old = hookfunction(Kill, function(Info)
                if DEBUG then
                    warn("Adonis AntiCheat tried to kill (fallback): {Info}")
                end
            end)

            table.insert(Hooked, Kill)
        end
    end
end

local Old; Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local LevelOrFunc, Info = ...

    if Detected and LevelOrFunc == Detected then
        if DEBUG then
            warn("Adonis AntiCheat sanity check detected and broken")
        end

        return coroutine.yield(coroutine.running())
    end

    return Old(...)
end))
-- setthreadidentity(9)
setthreadidentity(7)
-- End Adonis Bypass

-- Client AntiKick
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    if not checkcaller() and string.lower(getnamecallmethod()) == "kick" then
        return nil
    end

    return OldNamecall(...)
end))

------------------------Anti_AFK----------------------------------
if getconnections then
    for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
        v:Disable()
    end
end

if not getconnections then
    game:GetService("Players").LocalPlayer.Idled:connect(
        function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end
    )
end
------------------------End_Anti_AFK------------------------------

local potionRecipes = {
    ["Heartbreaking Elixir"] = { { "Everthistle", 3 }, { "Carnastool", 1 } },
    ["Heartsoothing Remedy"] = { { "Everthistle", 3 }, { "Cryastem", 1 } },
    ["Abhorrent Elixir"] = { { "Everthistle", 2 }, { "Cryastem", 1 } },
    ["Alluring Elixir"] = { { "Everthistle", 2 }, { "Carnastool", 1 } },
    ["Small Healing Potion"] = { { "Everthistle", 1 }, { "Slime Chunk", 1 } },
    ["Medium Healing Potion"] = { { "Everthistle", 1 }, { "Slime Chunk", 1 }, { "Carnastool", 1 }, { "Hightail", 1 } },
    ["Minor Energy Elixir"] = { { "Everthistle", 1 }, { "Carnastool", 1 } },
    ["Average Energy Elixir"] = { { "Everthistle", 1 }, { "Cryastem", 1 }, { "Restless Fragment", 1 } },
    ["Minor Empowering Elixir"] = { { "Cryastem", 1 }, { "Carnastool", 1 }, { "Sand Core", 1 } },
    ["Minor Absorbing Potion"] = { { "Hightail", 1 }, { "Mushroom Cap", 1 } },
    ["Ferrus Skin Potion"] = { { "Carnastool", 1 }, { "Mushroom Cap", 1 }, { "Sand Core", 1 } },
    ["Invisibility Potion"] = { { "Driproot", 1 }, { "Hightail", 1 }, { "Haze Chunk", 1 } },
    ["Light of Grace"] = { { "Phoenix Tear", 1 }, { "Crylight", 1 }, { "Haze Chunk", 1 }, { "Sand Core", 1 }, { "Driproot", 1 } }
}
local basetrainers = { "Ysa (Warrior Base)", "Boots (Thief Base)", "Tivek (Spear Base)", "Arandor (Wizard Base)",
    "Doran (Fist Base)" }
local orderlysupertrainers = { "Monk Trainer", "Paladin Trainer", "Saint Trainer", "Ranger Trainer",
    "Elementalist Trainer" }
local neutralsupertrainers = { "Brawler Trainer", "Blade Dancer Trainer", "Lancer Trainer", "Rogue Trainer",
    "Hexer Trainer" }
local chaoticsupertrainers = { "Dark Wraith Trainer", "Berserker Trainer", "Impaler Trainer", "Assassin Trainer",
    "Necromancer Trainer" }
local NPCList = {}
local QuestNPCList = {}
local Moves = {}
local Items = {}
local DuplicateItems = {}
local AntiDupeItems = { "Sneak", "Bestiary", "Pickaxe" }
local lp = game:GetService("Players").LocalPlayer
local BlacklistedNPC = { "Quest", "Filler", "Aretim", "PurgNPC", "ExampleNPC", "Pup 1", "Pup 2", "Pup 3", "SlimeStatue3",
    "Ysa", "Boots", "Tivek", "Arandor", "Doran" }
Boolerean = nil
local orgwalk = lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed
local orgjump = lp.Character:FindFirstChildWhichIsA("Humanoid").JumpPower
local Walkspeeder = false
local JumpPowerr = false
local CurrentWalkspeed = 16
local CurrentJumpPower = 50
local runbuff = workspace.Living[lp.Name].Effects.RunBuff.Value
local maxTime = 1.5
local debounce = 0.2

function checkforfight()
    if game:GetService("Workspace").Living[lp.Name]:FindFirstChild("FightInProgress") then
        Boolerean = true
    else
        Boolerean = false
    end
end

function getproximity()
    for _, Cauldrons in next, game:GetService("Workspace").Cauldrons:GetDescendants() do
        if Cauldrons:IsA("ProximityPrompt") then
            fireproximityprompt(Cauldrons)
        end
    end
end

function getclicker()
    for _, CauldronsClick in next, game:GetService("Workspace").Cauldrons:GetDescendants() do
        if CauldronsClick:IsA("ClickDetector") then
            fireclickdetector(CauldronsClick)
        end
    end
end

local function equipItem(itemName)
    local ohString1 = "Equip"
    local ohString2 = itemName
    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
    task.wait(0.23)
    getproximity()
end

local function brewPotion(recipe)
    for _, ingredient in ipairs(recipe) do
        local itemName, quantity = unpack(ingredient)
        for i = 1, quantity do
            equipItem(itemName)
            repeat
                task.wait()
            until lp.Character:FindFirstChild(itemName) or tick() - maxTime >= debounce
            if not lp.Character:FindFirstChild(itemName) then
                return
            end
        end
    end
    task.wait(0.1)
    getclicker()
end

for _, Movess in next, lp.PlayerGui.StatMenu.SkillMenu.Actives:GetChildren() do
    if Movess:IsA("TextButton") then
        table.insert(Moves, Movess.Name)
    end
end

for _, Itemss in next, lp.Backpack.Tools:GetChildren() do
    if Itemss:IsA("StringValue") and not table.find(AntiDupeItems, Itemss.Name) then
        local itemName = Itemss.Name
        if not DuplicateItems[itemName] then
            table.insert(Items, itemName)
            DuplicateItems[itemName] = true
        end
    end
end


for _, NPC in next, game:GetService("Workspace").NPCs:GetChildren() do
    if NPC:IsA("Model") and not table.find(BlacklistedNPC, NPC.Name) then
        table.insert(NPCList, NPC.Name)
    end
end

for _, QuestNPC in next, game:GetService("Workspace").NPCs.Quest:GetChildren() do
    if QuestNPC:IsA("Model") then
        table.insert(QuestNPCList, QuestNPC.Name)
    end
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/OneFool/intro/main/custom%20intro%20orion')))()
local Window = OrionLib:MakeWindow({
    Name = "Fool Hub | Arcane Lineage",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FoolArcLin"
})

-- Character

local PlayerSec = Window:MakeTab({
    Name = "Character",
    Icon = "rbxassetid://5009915795",
    PremiumOnly = false
})

PlayerSec:AddToggle({
    Name = "No Fall-DMG",
    Default = false,
    Save = true,
    Flag = "NoFall",
    Callback = function(Value)
        getgenv().NoFall = (Value)

        local OldNameCall = nil
        OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
            local Arg = { ... }
            if self.Name == "EnviroEffects" and NoFall then
                return
            end
            return OldNameCall(self, ...)
        end)
    end
})

PlayerSec:AddToggle({
    Name = "Mastery Point Notifier",
    Default = false,
    Save = true,
    Flag = "MasteryNotifier",
    Callback = function(Value)
        getgenv().MasteryNoti = Value

        lp.PlayerGui.ClassMastery.Main.Points:GetPropertyChangedSignal("Text"):Connect(function()
            if MasteryNoti then
                OrionLib:MakeNotification({
                    Name = "Mastery Point(s) Gained!",
                    Content = "If you just put a point into your mastery tree ignore this!",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })
            end
        end)
    end
})

PlayerSec:AddButton({
    Name = "Heal At Doctor",
    Callback = function()
        local oldcframe = lp.Character.HumanoidRootPart.CFrame

        lp.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").NPCs.Doctor.Head
            .CFrame
        task.wait(0.6)
        fireproximityprompt(game:GetService("Workspace").NPCs.Doctor.Head.ProximityPrompt)
        lp.PlayerGui:WaitForChild("NPCDialogue")
        lp.PlayerGui.NPCDialogue.RemoteEvent:FireServer(lp.PlayerGui.NPCDialogue.BG.Options.Option)
        task.wait(0.4)
        lp.Character.HumanoidRootPart.CFrame = oldcframe
    end
})

PlayerSec:AddToggle({
    Name = "Enable Walkspeed",
    Default = false,
    Callback = function(Value)
        Walkspeeder = Value
        while Walkspeeder do
            task.wait()
            if Walkspeeder then
                lp.Character.Humanoid.WalkSpeed = CurrentWalkspeed
            elseif not Walkspeeder then
                lp.Character.Humanoid.WalkSpeed = orgwalk
                task.wait()
            end
        end
    end
})

PlayerSec:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Walkspeed",
    Callback = function(Value)
        CurrentWalkspeed = Value
        if Walkspeeder then
            lp.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerSec:AddToggle({
    Name = "Enable Run Speed Modifier",
    Default = false,
    Callback = function(Value)
        RunBuffer = Value
        while RunBuffer do
            task.wait()
            if RunBuffer then
                workspace.Living[lp.Name].Effects.RunBuff.Value = CurrentRunBuff
            elseif not RunBuffer then
                workspace.Living[lp.Name].Effects.RunBuff.Value = runbuff
                task.wait()
            end
        end
    end
})

PlayerSec:AddSlider({
    Name = "Run Speed Modifier",
    Min = tonumber(runbuff),
    Max = 100,
    Default = tonumber(runbuff),
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Run Speed",
    Callback = function(Value)
        CurrentRunBuff = Value
        if RunBuffer then
            workspace.Living[lp.Name].Effects.RunBuff = Value
        end
    end
})

PlayerSec:AddToggle({
    Name = "Enable JumpPower",
    Default = false,
    Callback = function(Value)
        JumpPowerr = Value
        if Value then
            lp.Character.Humanoid.JumpPower = CurrentJumpPower
        elseif not Value then
            lp.Character.Humanoid.JumpPower = orgjump
        end
    end
})

PlayerSec:AddSlider({
    Name = "JumpPower",
    Min = tonumber(lp.Character.Humanoid.JumpPower),
    Max = 250,
    Default = tonumber(lp.Character.Humanoid.JumpPower),
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "JumpPower",
    Callback = function(Value)
        CurrentJumpPower = Value
        if JumpPowerr then
            lp.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Combat

local Combat = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://5009915795",
    PremiumOnly = false
})

Combat:AddToggle({
    Name = "Auto-Dodge",
    Default = false,
    Save = true,
    Flag = "AutoDodge",
    Callback = function(Value)
        if not AutoBlock then
            getgenv().AutoDodge = (Value)

            while AutoDodge and game:GetService("Workspace").Living[lp.Name]:WaitForChild("FightInProgress") do
                task.wait()
                local ohTable1 = {
                    [1] = true,
                    [2] = true
                }
                local ohString2 = "DodgeMinigame"

                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohTable1, ohString2)
                task.wait()
            end
        else
            OrionLib:MakeNotification({
                Name = "Warning:",
                Content = "Disable Auto-Block and Re-Enable this to use it",
                Image = "rbxassetid://12614663538",
                Time = 5
            })
        end
    end
})

Combat:AddToggle({
    Name = "Auto-Block",
    Default = false,
    Save = true,
    Flag = "AutoBlock",
    Callback = function(Value)
        if not AutoDodge then
            getgenv().AutoBlock = (Value)

            while AutoBlock and game:GetService("Workspace").Living[lp.Name]:WaitForChild("FightInProgress") do
                task.wait()
                local ohTable1 = {
                    [1] = true,
                    [2] = false
                }
                local ohString2 = "DodgeMinigame"

                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohTable1, ohString2)
                task.wait()
            end
        else
            OrionLib:MakeNotification({
                Name = "Warning:",
                Content = "Disable Auto-Dodge and Re-Enable this to use it",
                Image = "rbxassetid://12614663538",
                Time = 5
            })
        end
    end
})

Combat:AddToggle({
    Name = "Auto-QTE",
    Default = false,
    Save = true,
    Flag = "AutoQTE",
    Callback = function(Value)
        getgenv().AutoQTE = (Value)
        local BaseClass = lp.PlayerGui.StatMenu.Holder.ContentFrame.Stats.Body.RightColumn.Content.BaseClass.Type.Text

        while AutoQTE and game:GetService("Workspace").Living[lp.Name]:WaitForChild("FightInProgress") do
            task.wait()

            -- Wizard
            if BaseClass == "Wizard" then
                local ohBoolean1 = true
                local ohString2 = "MagicQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohBoolean1, ohString2)
                lp.PlayerGui.Combat.MagicQTE.Visible = false

                -- Thief
            elseif BaseClass == "Thief" then
                local ohBoolean1 = true
                local ohString2 = "DaggerQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohBoolean1, ohString2)
                lp.PlayerGui.Combat.DaggerQTE.Visible = false

                -- Slayer
            elseif BaseClass == "Slayer" then
                local ohBoolean1 = true
                local ohString2 = "SpearQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohBoolean1, ohString2)
                lp.PlayerGui.Combat.SpearQTE.Visible = false
                -- Fist
            elseif BaseClass == "Martial Artist" then
                local ohBoolean1 = true
                local ohString2 = "FistQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohBoolean1, ohString2)
                lp.PlayerGui.Combat.FistQTE.Visible = false
                -- Sword
            elseif BaseClass == "Warrior" then
                local ohBoolean1 = true
                local ohString2 = "SwordQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohBoolean1, ohString2)
                lp.PlayerGui.Combat.SwordQTE.Visible = false
                task.wait()
            end
        end
    end
})

Combat:AddToggle({
    Name = "Auto-Attack",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAttack = (Value)

        pcall(function()
            local function performAttack(target)
                local ohString1 = "Attack"
                local ohString2 = tostring(MoveToUse)
                local ohTable3 = {
                    ["Attacking"] = target
                }

                local energyText = lp.PlayerGui.HUD.Holder.EnergyOutline.Count.Text
                local slashPos = string.find(energyText, "/")
                local energy = tonumber(string.sub(energyText, 1, slashPos - 1))

                if energy >= tonumber(lp.PlayerGui.StatMenu.SkillMenu.Actives[MoveToUse].Cost.Text) then
                    lp.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(ohString1, ohString2, ohTable3)

                    task.wait(1.5)
                    lp.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(ohString1, ohString2, ohTable3)
                    task.wait(0.5)
                    local ohString11 = "Attack"
                    local ohString22 = "Strike"
                    local ohTable33 = {
                        ["Attacking"] = target
                    }
                    lp.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(ohString11, ohString22, ohTable33)
                else
                    local ohString1 = "Attack"
                    local ohString2 = "Strike"
                    local ohTable3 = {
                        ["Attacking"] = target
                    }
                    lp.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(ohString1, ohString2, ohTable3)
                    task.wait()
                end
            end

            if AutoAttack then
                OrionLib:MakeNotification({
                    Name = "Warning:",
                    Content =
                    "If the auto attack doesn't work in the first fight after you enable it simply re-enable it and it should work from then on!",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })
                while AutoAttack do
                    task.wait()
                    checkforfight()
                    task.wait(1.1)
                    if Boolerean == true then
                        local enemiesToAttack = {}
                        for _, Enemies in next, game:GetService("Workspace").Living:GetDescendants() do
                            if Enemies:IsA("IntValue") and Enemies.Value == game:GetService("Workspace").Living[lp.Name]:WaitForChild("FightInProgress").Value and Enemies.Parent.Name ~= lp.Name then
                                table.insert(enemiesToAttack, Enemies.Parent.Name)

                                for _, enemyName in ipairs(enemiesToAttack) do
                                    local enemy = game:GetService("Workspace").Living[enemyName]
                                    if enemy then
                                        performAttack(enemy)
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

Combat:AddDropdown({
    Name = "Auto-Attack Move",
    Default = "",
    Options = Moves,
    Callback = function(Value)
        MoveToUse = Value
    end
})

-- Automation

local Automation = Window:MakeTab({
    Name = "Automation",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

local Plants = Automation:AddSection({
    Name = "Plant Farming"
})

Plants:AddButton({
    Name = "Pickup All Plants",
    Callback = function()
        local avoidCFrame = CFrame.new(1465.6145, 48.1683693, -3372.54272, -0.406715393, 0, -0.913554907, 0, 1, 0,
            0.913554907, 0, -0.406715393)
        local trinkets = {}
        local originalLocation = lp.Character.HumanoidRootPart.CFrame

        for _, Trinket in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
            if Trinket:IsA("Part") and Trinket.Name == "ClickPart" and Trinket.CFrame ~= avoidCFrame then
                table.insert(trinkets, Trinket)
            end
        end

        for _, Trinket in ipairs(trinkets) do
            lp.Character.HumanoidRootPart.CFrame = Trinket.CFrame
            task.wait(0.35)
            for _, v in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
                if v:IsA("ClickDetector") and lp:DistanceFromCharacter(v.Parent.Position) <= 10 then
                    fireclickdetector(v)
                end
            end
        end
        lp.Character.HumanoidRootPart.CFrame = originalLocation
    end
})

Plants:AddLabel("I recommend loading the map before using auto pickup.")

Plants:AddToggle({
    Name = "Auto Pickup Plants",
    Default = false,
    Callback = function(Value)
        getgenv().PlantFarm = Value

        -- Main Code
        while PlantFarm do
            task.wait()
            if lp.Backpack.Tools:FindFirstChild("Abhorrent Elixir") then
                local ohString1 = "Use"
                local ohString2 = "Abhorrent Elixir"
                local ohInstance3 = lp.Backpack.Tools:WaitForChild("Abhorrent Elixir")

                game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2,
                    ohInstance3)
                task.wait(2)
                local avoidCFrame = CFrame.new(1465.6145, 48.1683693, -3372.54272, -0.406715393, 0, -0.913554907, 0, 1, 0,
                    0.913554907, 0, -0.406715393)
                local trinkets = {}
                local originalLocation = lp.Character.HumanoidRootPart.CFrame

                for _, Trinket in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
                    if Trinket:IsA("Part") and Trinket.Name == "ClickPart" and Trinket.CFrame ~= avoidCFrame then
                        table.insert(trinkets, Trinket)
                    end
                end

                for _, Trinket in ipairs(trinkets) do
                    lp.Character.HumanoidRootPart.CFrame = Trinket.CFrame
                    task.wait(0.35)
                    for _, v in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
                        if v:IsA("ClickDetector") and lp:DistanceFromCharacter(v.Parent.Position) <= 10 then
                            fireclickdetector(v)
                        end
                    end
                end
                lp.Character.HumanoidRootPart.CFrame = originalLocation
                task.wait(tonumber(Time))
            else
                OrionLib:MakeNotification({
                    Name = "Warning:",
                    Content = "You must have an Abhorrent Elixir to use this.",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })
                break
            end
        end
    end
})

Plants:AddSlider({
    Name = "How Many Seconds To Wait Before Farming Again",
    Min = 30,
    Max = 640,
    Default = 120,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Seconds",
    Callback = function(Value)
        Time = Value
    end
})

local Brew = Automation:AddSection({
    Name = "Auto Brew"
})

Brew:AddDropdown({
    Name = "Potion To Auto Brew",
    Default = "",
    Options = { "Small Healing Potion", "Medium Healing Potion", "Minor Energy Elixir", "Average Energy Elixir", "Minor Empowering Elixir", "Minor Absorbing Potion", "Ferrus Skin Potion", "Invisibility Potion", "Light of Grace", "Heartbreaking Elixir", "Heartsoothing Remedy", "Abhorrent Elixir", "Alluring Elixir" },
    Callback = function(Value)
        Potion = Value
    end
})

Brew:AddToggle({
    Name = "Auto Brew Potion",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBrew = Value

        while AutoBrew do
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(2659.95288, 389.135986, -3946.76294, 0.993850768,
                4.01330915e-08, 0.110727936, -4.54039046e-08, 1, 4.50799895e-08, -0.110727936, -4.98302626e-08,
                0.993850768)
            task.wait(0.3)

            local recipe = potionRecipes[Potion]
            if recipe then
                local canBrew = true
                for _, ingredient in ipairs(recipe) do
                    local itemName = unpack(ingredient)
                    if not lp.Backpack.Tools:FindFirstChild(itemName) then
                        canBrew = false
                        OrionLib:MakeNotification({
                            Name = "Missing Required Ingredient For:",
                            Content = tostring(Potion),
                            Image = "rbxassetid://12614663538",
                            Time = 5
                        })
                        break
                    end
                end

                if canBrew then
                    brewPotion(recipe)
                end
            end

            if not AutoBrew then
                break
            end
        end
    end
})


local Merchant = Window:MakeTab({
    Name = "Merchant",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

Merchant:AddToggle({
    Name = "Merchant Notifier",
    Default = false,
    Save = true,
    Flag = "MerchantNoti",
    Callback = function(Value)
        getgenv().MerchNoti = (Value)
        getgenv().merchnotifier = false

        while MerchNoti do
            task.wait()
            if game:GetService("Workspace").NPCs:FindFirstChild("Mysterious Merchant") then
                OrionLib:MakeNotification({
                    Name = "Merchant Detected!",
                    Content = "The Mysterious Merchant Is Spawned!",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })
                merchnotifier = true
                task.wait(60)
                merchnotifier = false
            end
        end
    end
})

Merchant:AddButton({
    Name = "Teleport To Merchant",
    Callback = function()
        if game:GetService("Workspace").NPCs:FindFirstChild("Mysterious Merchant") then
            lp.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").NPCs:FindFirstChild(
                "Mysterious Merchant").HumanoidRootPart.CFrame
        else
            OrionLib:MakeNotification({
                Name = "No Merchant Detected!",
                Content = "Cannot Teleport To Merchant, Not Spawned!",
                Image = "rbxassetid://12614663538",
                Time = 5
            })
        end
    end
})

-- Teleports

local Teleports = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

Teleports:AddDropdown({
    Name = "NPC's",
    Default = "",
    Options = NPCList,
    Callback = function(Value)
        local CFrameEnd = CFrame.new(game:GetService("Workspace").NPCs[Value]:FindFirstChild("HumanoidRootPart")
            .Position)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrameEnd })
        tween:Play()
    end
})

Teleports:AddDropdown({
    Name = "Base Class Trainers",
    Default = "",
    Options = basetrainers,
    Callback = function(Value)
        if Value == "Ysa (Warrior Base)" then
            local CFrameEnd = CFrame.new(-472.791016, 42.894043, -3285.57422)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Boots (Thief Base)" then
            local CFrameEnd = CFrame.new(-422.817841, 42.894043, -3527)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Tivek (Spear Base)" then
            local CFrameEnd = CFrame.new(657.665283, 99.1655655, -3987.02319)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Arandor (Wizard Base)" then
            local CFrameEnd = CFrame.new(591.249634, 124.134979, -3608.24951)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Doran (Fist Base)" then
            local CFrameEnd = CFrame.new(486.700226, 116.525238, -2655.08179)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        end
    end
})

Teleports:AddDropdown({
    Name = "Orderly Super Trainers",
    Default = "",
    Options = orderlysupertrainers,
    Callback = function(Value)
        if Value == "Monk Trainer" then
            local CFrameEnd = CFrame.new(-1693.1698, 112.045654, -2943.5459)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Paladin Trainer" then
            local CFrameEnd = CFrame.new(-2515.79541, 42.6970634, -2959.91772)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Saint Trainer" then
            local CFrameEnd = CFrame.new(-3587.05225, 42.6970673, -3153.79883)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Ranger Trainer" then
            local CFrameEnd = CFrame.new(2590.25488, 386.349731, -3175.85303)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Elementalist Trainer" then
            local CFrameEnd = CFrame.new(-2572.16187, 42.6970711, -2486.91895)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        end
    end
})

Teleports:AddDropdown({
    Name = "Neutral Super Trainers",
    Default = "",
    Options = neutralsupertrainers,
    Callback = function(Value)
        if Value == "Brawler Trainer" then
            local CFrameEnd = CFrame.new(235.279037, 94.5629883, -4652.14355)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Blade Dancer Trainer" then
            local CFrameEnd = CFrame.new(61.2550659, 113.062515, -5365.60693)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Lancer Trainer" then
            local CFrameEnd = CFrame.new(-58.3252258, 159.062424, -5605.7793)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Rogue Trainer" then
            local CFrameEnd = CFrame.new(-2505.34204, 42.7966499, -2860.40381)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Hexer Trainer" then
            local CFrameEnd = CFrame.new(-660.072388, 42.6968689, -4195.70752)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        end
    end
})

Teleports:AddDropdown({
    Name = "Chaotic Super Trainers",
    Default = "",
    Options = chaoticsupertrainers,
    Callback = function(Value)
        if Value == "Dark Wraith Trainer" then
            local CFrameEnd = CFrame.new(1964.64673, 23.9373341, -1436.88989)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Berserker Trainer" then
            local CFrameEnd = CFrame.new(5350.03174, -91.6057739, -3256.1272)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Impaler Trainer" then
            local CFrameEnd = CFrame.new(2321.18872, 386.629517, -3622.46436)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Assassin Trainer" then
            local CFrameEnd = CFrame.new(1181.34607, -8.18032455, -2311.11279)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Necromancer Trainer" then
            local CFrameEnd = CFrame.new(5950.45703, 52.2517128, -2857.26343)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        end
    end
})

Teleports:AddDropdown({
    Name = "Quest NPC's",
    Default = "",
    Options = QuestNPCList,
    Callback = function(Value)
        local CFrameEnd = CFrame.new(game:GetService("Workspace").NPCs.Quest[Value]:FindFirstChild("HumanoidRootPart")
            .Position)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrameEnd })
        tween:Play()
    end
})

Teleports:AddDropdown({
    Name = "Specific Places",
    Default = "",
    Options = { "Farm Place", "Caldera Spawn", "Ruins Spawn (Sand Town)", "Westwood Spawn", "Blades Spawn", "Yar'thul Gate",
        "Thorian Gate", "The Forgotten Sanctum", "Thanasius", "Westwood Apothecarian", "Deeproot Depths" },
    Callback = function(Value)
        if Value == "Caldera Spawn" then
            local CFrameEnd = CFrame.new(-221.396332, 46.5463257, -3328.51367, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Yar'thul Gate" then
            local CFrameEnd = CFrame.new(-4944.75781, 48.6970673, -3083.07324, -0.0124968914, -5.6133743e-08, 0.999921918,
                -6.00345373e-08, 1, 5.53878223e-08, -0.999921918, -5.93376726e-08, -0.0124968914)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Ruins Spawn (Sand Town)" then
            local CFrameEnd = CFrame.new(-2507.97217, 45.1969986, -2928.76367, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Westwood Spawn" then
            local CFrameEnd = CFrame.new(2531.55249, 388.945129, -3641.91064, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Thorian Gate" then
            local CFrameEnd = CFrame.new(2415.21777, 24.3336258, -429.789001, -0.720241308, -1.32400935e-08, 0.693723619,
                -3.0820011e-09, 1, 1.58857336e-08, -0.693723619, 9.30350552e-09, -0.720241308)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Blades Spawn" then
            local CFrameEnd = CFrame.new(-2930.36865, -36.1856079, -2022.60095, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "The Forgotten Sanctum" then
            local CFrameEnd = CFrame.new(5987.44678, 53.3530579, -3465.15186, 0.995714128, 3.02554888e-08, -0.0924842209,
                -3.60760062e-08, 1, -6.12634139e-08, 0.0924842209, 6.43373141e-08, 0.995714128)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Westwood Apothecarian" then
            local CFrameEnd = CFrame.new(2606.7832, 386.319122, -4042.98633, 0.999831498, -6.83423522e-08, 0.0183564071,
                6.99661413e-08, 1, -8.78168009e-08, -0.0183564071, 8.90863348e-08, 0.999831498)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Thanasius" then
            local CFrameEnd = CFrame.new(1675.40479, 5.31999874, -1663.76953, -0.404080033, 1.18365541e-07, 0.914723635,
                3.73702065e-08, 1, -1.1289201e-07, -0.914723635, -1.1433996e-08, -0.404080033)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Deeproot Depths" then
            local CFrameEnd = CFrame.new(5366.65625, 83.0383987, -2891.76953, 1, 5.01325315e-10, -5.26991848e-14,
                -5.01325315e-10, 1, -1.37222793e-08, 5.26923069e-14, 1.37222793e-08, 1)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        elseif Value == "Farm Place" then
            local CFrameEnd = CFrame.new(-205, 43, -3674)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrameEnd })
            tween:Play()
        end
    end
})

Teleports:AddButton({
    Name = "Meditate",
    Callback = function()
        lp.Character.HumanoidRootPart.CFrame = workspace.Mats.MeditationMat:WaitForChild("Root").CFrame
        task.wait(1)
        workspace.Living[lp.Name].MeditateHandler.Meditate:FireServer()
    end
})

local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

Misc:AddToggle({
    Name = "Enable Data Rollback",
    Default = false,
    Save = false,
    Callback = function(Value)
        local rollbackChk = getgenv().Rollback or false
        getgenv().Rollback = Value

        if Rollback then
            OrionLib:MakeNotification({
                Name = "Rollback Enabled!",
                Content =
                "The data rollback is ready to use!",
                Image = "rbxassetid://12614663538",
                Time = 10
            })
            while Rollback do
                local ohNumber1 = 1
                local ohTable2 = {
                    ["1"] = "\237\190\140"
                }

                game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohNumber1, ohTable2)
                task.wait()
            end
        else
            if rollbackChk then
                local ohNumber1 = 1
                local ohTable2 = {
                    ["1"] = ""
                }

                game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohNumber1, ohTable2)
                OrionLib:MakeNotification({
                    Name = "Rollback Disabled!",
                    Content =
                    "Rollback has been canceled!",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })
            end
        end
    end
})

Misc:AddToggle({
    Name = "Auto-Drop Item",
    Default = false,
    Save = false,
    Callback = function(Value)
        getgenv().AutoDrop = Value

        if AutoDrop then
            while AutoDrop do
                local ohString1 = "Drop"
                local ohInstance3 = lp.Backpack.Tools:WaitForChild(Item)

                game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, Item,
                    ohInstance3)
                task.wait()
            end
        else
        end
    end
})

local id = Misc:AddDropdown({
    Name = "Item To Drop",
    Default = "",
    Options = Items,
    Callback = function(Value)
        Item = Value
    end
})

Misc:AddButton({
    Name = "Rejoin",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
    end
})

local AntiAFK = Misc:AddSection({
    Name = "Anti-AFK Built In"
})

local Info = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

Info:AddLabel("My ONLY 2 Discords: fo.l | onefool")
Info:AddLabel("REPORT ERRORS TO MY DISCORD @fo.l")
Info:AddLabel("I recommend only using this script in a private server!")
Info:AddParagraph("Only Real Loadstring",
    "loadstring(game:HttpGet('https://raw.githubusercontent.com/OneFool/Misc/main/Arcane%20Lineage.lua'))()")
Info:AddButton({
    Name = "Copy Real Loadstring",
    Callback = function()
        setclipboard(
            "loadstring(game:HttpGet('https://raw.githubusercontent.com/OneFool/Misc/main/Arcane%20Lineage.lua'))()")
    end
})

OrionLib:Init()
