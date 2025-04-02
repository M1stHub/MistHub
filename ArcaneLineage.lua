repeat wait() until game:IsLoaded()
wait()
--Function

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

    local NPCList = {}
    local QuestNPCList = {}
    local Moves = {}
    local lp = game:GetService("Players").LocalPlayer
    local BlacklistedNPC = { "Quest", "Filler", "Aretim", "PurgNPC", "ExampleNPC", "Pup 1", "Pup 2", "Pup 3" }
    local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

    function checkforfight()
        if game:GetService("Workspace").Living[lp.Name]:FindFirstChild("FightInProgress") then
            return true
        else
            return false
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

    for _, Movess do
       print('e')
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
--Functions

--Lib
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/xAentix/MistHub/main/Lib.lua')))()
    local Window = OrionLib:MakeWindow({
        Name = "Mist Hub | Arcane Lineage",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "Mist Hub"
    })
--Lib

--Combat
    local Combat = Window:MakeTab({
        Name = "Combat",
        Icon = "rbxassetid://15365907739",
        PremiumOnly = false
    })

    Combat:AddToggle({
        Name = "Auto-Dodge",
        Default = false,
        Save = true,
        Flag = "AutoDodge",
        Callback = function(Value)
            getgenv().AutoDodge = (Value)

            while AutoDodge do
                task.wait()
                local ohTable1 = {
                    [1] = true,
                    [2] = true
                }
                local ohString2 = "DodgeMinigame"

                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(ohTable1, ohString2)
                task.wait()
            end
        end
    })

    local function performAttack(target)
        local ohString1 = "Attack"
        local ohString2 = tostring(MoveToUse)
        local ohTable3 = {
            ["Attacking"] = target
        }

        lp.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(
            ohString1, ohString2, ohTable3)
    end

    local function autoAttackLoop()
        while true do
            if AutoAttack and checkforfight() then
                local enemiesToAttack = {}
                for _, Enemies in next, game:GetService("Workspace").Living:GetDescendants() do
                    if Enemies:IsA("IntValue") and Enemies.Value == game:GetService("Workspace").Living[lp.Name].FightInProgress.Value and Enemies.Parent.Name ~= lp.Name then
                        table.insert(enemiesToAttack, Enemies.Parent.Name)
                    end
                end

                for _, enemyName in ipairs(enemiesToAttack) do
                    local enemy = game:GetService("Workspace").Living[enemyName]
                    if enemy then
                        performAttack(enemy)
                    end
                    task.wait(1)
                end
            end
            task.wait(0.1)
        end
    end

    Combat:AddToggle({
        Name = "Auto-Attack",
        Default = false,
        Callback = function(Value)
            getgenv().AutoAttack = Value
            if AutoAttack then
                spawn(autoAttackLoop)
            end
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
--Combat

--Automation

    local Automation = Window:MakeTab({
        Name = "Automation",
        Icon = "rbxassetid://15365908471",
        PremiumOnly = false
    })

    local Plants = Automation:AddSection({
        Name = "Use an Abhorrent Elixir Before Using The Plant Farm To Avoid Fights"
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

    local Brew = Automation:AddSection({
        Name = "Auto Brew"
    })

    Brew:AddDropdown({
        Name = "Potion To Auto Brew",
        Default = "",
        Options = { "Heartbreaking Elixir", "Heartsoothing Remedy", "Abhorrent Elixir", "Alluring Elixir" },
        Callback = function(Value)
            Potion = Value
        end
    })

    Brew:AddToggle({
        Name = "Auto Brew Potion",
        Default = false,
        Callback = function(Value)
            local originalCameraSubject = game.Workspace.CurrentCamera.CameraSubject
            local originalCameraCF = game.Workspace.CurrentCamera.CFrame
            local originalCameraType = game.Workspace.CurrentCamera.CameraType

            getgenv().AutoBrew = (Value)

            while AutoBrew do
                lp.Character.HumanoidRootPart.CFrame = CFrame.new(2659.95288, 389.135986, -3946.76294, 0.993850768,
                    4.01330915e-08, 0.110727936, -4.54039046e-08, 1, 4.50799895e-08, -0.110727936, -4.98302626e-08,
                    0.993850768)
                for _, CauldronPos in next, game:GetService("Workspace").Cauldrons:GetDescendants() do
                    if CauldronPos:IsA("BasePart") and CauldronPos.CFrame == CFrame.new(2660.21313, 385.237915, -3945.37964, -0.990265131, 0.139194876, 6.78002834e-07, -6.78002834e-07, -9.77516174e-06, 1.00000012, 0.139194876, 0.990265071, 9.7155571e-06) then
                        CauldronPos.Name = "AutoCaul"
                        CauldronPos.Parent.Name = "AutoCauldron"
                    end
                end

                local Workspace = game.Workspace
                local Part = game:GetService("Workspace").Cauldrons.AutoCauldron["AutoCaul"]

                Workspace.CurrentCamera.CameraSubject = Part
                Workspace.CurrentCamera.CoordinateFrame = Part.CFrame
                Workspace.CurrentCamera.CameraType = "Scriptable"
                task.wait(0.1)

                if Potion == "Heartbreaking Elixir" and AutoBrew and lp.Backpack.Tools:FindFirstChild("Everthistle") and lp.Backpack.Tools:FindFirstChild("Carnastool") then
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Carnastool"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    task.wait(0.1)
                    getclicker()
                elseif Potion == "Heartsoothing Remedy" and AutoBrew and lp.Backpack.Tools:FindFirstChild("Everthistle") and lp.Backpack.Tools:FindFirstChild("Cryastem") then
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Cryastem"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    task.wait(0.1)
                    getclicker()
                elseif Potion == "Heartsoothing Remedy" and AutoBrew and lp.Backpack.Tools:FindFirstChild("Everthistle") and lp.Backpack.Tools:FindFirstChild("Cryastem") then
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Cryastem"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    task.wait(0.1)
                    getclicker()
                elseif Potion == "Abhorrent Elixir" and AutoBrew and lp.Backpack.Tools:FindFirstChild("Everthistle") and lp.Backpack.Tools:FindFirstChild("Cryastem") then
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Cryastem"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    task.wait(0.1)
                    getclicker()
                elseif Potion == "Alluring Elixir" and AutoBrew and lp.Backpack.Tools:FindFirstChild("Everthistle") and lp.Backpack.Tools:FindFirstChild("Carnastool") then
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Everthistle"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    local ohString1 = "Equip"
                    local ohString2 = "Carnastool"
                    game:GetService("ReplicatedStorage").Remotes.Information.InventoryManage:FireServer(ohString1, ohString2)
                    getproximity()
                    task.wait(0.1)
                    getclicker()
                else
                    OrionLib:MakeNotification({
                        Name = "Missing Required Ingredient For:",
                        Content = tostring(Potion),
                        Image = "rbxassetid://14974323109",
                        Time = 5
                    })
                end

                if not AutoBrew then
                    Workspace.CurrentCamera.CameraSubject = originalCameraSubject
                    Workspace.CurrentCamera.CFrame = originalCameraCF
                    Workspace.CurrentCamera.CameraType = originalCameraType
                    break
                end
            end
        end
    })

    local Merchant = Window:MakeTab({
        Name = "Merchant",
        Icon = "rbxassetid://15365909345",
        PremiumOnly = false
    })

    Merchant:AddToggle({
        Name = "Merchant Notifier",
        Default = false,
        Save = true,
        Flag = "MerchantNoti",
        Callback = function(Value)
            getgenv().MerchNoti = (Value)

            while MerchNoti do
                task.wait()
                if game:GetService("Workspace").NPCs:FindFirstChild("Mysterious Merchant") then
                    OrionLib:MakeNotification({
                        Name = "Merchant Detected!",
                        Content = "The Mysterious Merchant Is Spawned!",
                        Image = "rbxassetid://14974323109",
                        Time = 5
                    })
                    task.wait(5)
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
                    Image = "rbxassetid://14974323109",
                    Time = 5
                })
            end
        end
    })
--Automation

--Teleports

    local Teleports = Window:MakeTab({
        Name = "Teleports",
        Icon = "rbxassetid://15365909874",
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
        Options = { "Caldera Spawn", "Ruins Spawn (Sand Town)", "Westwood Spawn", "Blades Spawn", "Yar'thul Gate", "Thorian Gate","Inferno"},
        Callback = function(Value)
            if Value == "Caldera Spawn" then
                local CFrameEnd = CFrame.new(-221.396332, 46.5463257, -3328.51367, -1, 0, 0, 0, 1, 0, 0, 0, -1)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrameEnd })
                tween:Play()
            elseif Value == "Yar'thul Gate" then
                local CFrameEnd = CFrame.new(-4944.75781, 48.6970673, -3083.07324, -0.0124968914, -5.6133743e-08, 0.999921918, -6.00345373e-08, 1, 5.53878223e-08, -0.999921918, -5.93376726e-08, -0.0124968914)
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
                local CFrameEnd = CFrame.new(2415.21777, 24.3336258, -429.789001, -0.720241308, -1.32400935e-08, 0.693723619, -3.0820011e-09, 1, 1.58857336e-08, -0.693723619, 9.30350552e-09, -0.720241308)
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
            elseif Value == "Inferno" then
                local CFrameEnd = CFrame.new(-4338, 67, -1588)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrameEnd })
                tween:Play()
            end
        end
    })
--Teleports

--Misc
    local Misc = Window:MakeTab({
        Name = "Misc",
        Icon = "rbxassetid://15365911123",
        PremiumOnly = false
    })

    Misc:AddToggle({
        Name = "Auto-Sprint",
        Default = false,
        Save = true,
        Flag = "AutoSprint",
        Callback = function(Value)
            getgenv().AutoSprint = (Value)
    
            while AutoSprint do
                local scriptPath = workspace.Living[lp.Name].MovementHandler
                local closureName = "Sprint"
                local upvalueIndex = 8
                local closureConstants = {
                    [1] = "Effects",
                    [2] = "Stunned",
                    [3] = "FindFirstChild",
                    [4] = "NoSprint",
                    [5] = "FightInProgress",
                    [6] = "HumanoidRootPart"
                }
    
                local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
                local value = 2
    
                debug.setupvalue(closure, upvalueIndex, value)
                task.wait(0.23)
            end
        end
    })

    local Rollback = Misc:AddSection({
        Name = "Enable then drop the item(s) to another account then rejoin/leave"
    })

    Rollback:AddButton({
        Name = "Enable Rollback",
        Callback = function()
            while task.wait() do
                local ohTable1 = {
                    ["1"] = "\255"
                }
                game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohTable1)
            end
        end
    })

    Rollback:AddButton({
        Name = "Rejoin",
        Callback = function()
            local ts = game:GetService("TeleportService")
            local p = lp
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
        end
    })

    local AntiAFK = Misc:AddSection({
        Name = "Anti-AFK Built In"
    })
--Misc

OrionLib:Init()
