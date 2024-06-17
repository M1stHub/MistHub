repeat
    wait()
until game:IsLoaded()
wait()

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
local lp = game:GetService("Players").LocalPlayer
Boolerean = nil

function checkforfight()
    if game:GetService("Workspace").Living[lp.Name]:FindFirstChild("FightInProgress") then
        Boolerean = true
    else
        Boolerean = false
    end
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/OneFool/intro/main/custom%20intro%20orion')))()
local Window = OrionLib:MakeWindow({
    Name = "Fool Hub | Arcane Lineage",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FoolArcLin"
})

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
            print("Auto-Dodge set to:", Value)

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
    Name = "Auto-Attack",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAttack = (Value)
        print("Auto-Attack set to:", Value)

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
                spawn(function()
                    while AutoAttack do
                    getgenv().AutoAttackEnabled = true
                    print("Auto-Attack Enabled")
                    task.wait(3)
                    getgenv().AutoAttackEnabled = false
                    print("Auto-Attack Disabled")
                    task.wait(0.1) -- Small delay before re-enabling
                    end
                end)

                OrionLib:MakeNotification({
                    Name = "Warning:",
                    Content =
                    "If the auto attack doesn't work in the first fight after you enable it simply re-enable it and it should work from then on! 11",
                    Image = "rbxassetid://12614663538",
                    Time = 10
                })

                while AutoAttack do
                    task.wait()
                    checkforfight()
                    task.wait(1.1)
                    if Boolerean == true and getgenv().AutoAttackEnabled then
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
        print("MoveToUse set to:", Value)
    end
})

OrionLib:Init()
