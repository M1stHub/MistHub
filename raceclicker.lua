repeat wait() until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local function sendDiscordWebhook()
    local player = Players.LocalPlayer
    local username = player.Name
    local gemAmount = player.PlayerGui.MainGui.CenterUIFrame.Shop.Frame.ShopGemCounter.ShopGemAmount.Text
    local raidTokenAmount = player.PlayerGui.MainGui.CenterUIFrame.Shop.Frame.ShopRaidTokenCounter.ShopRaidTokenAmount.Text
    local bossRushTokenAmount = player.PlayerGui.MainGui.CenterUIFrame.BossRushShop.BossRushShopCurrencyCounter.BossRushShopCurrencyAmount.Text
    local level = player.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame.CharacterTriIcon.Level.LevelShow.Text
    local xp = player.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame.Exp.Text
    local divine = player.PlayerGui.MainGui.CenterUIFrame.DivineCardUpgradeFrame.Frame.DivineCardUpgradeDivineCore.Text

    local levelWithXp = level .. " (" .. xp .. ")"
    local hiddenUsername = "||" .. username .. "||"
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")

    local embed = {
        color = 16777215,
        fields = {
            { name = "Username", value = hiddenUsername },
            { name = "Level", value = "```\n" .. levelWithXp .. "\n```" },
            { name = "Gems", value = "```\n" .. gemAmount .. "\n```" },
            { name = "Raid Tokens", value = "```\n" .. raidTokenAmount .. "\n```" },
            { name = "Boss Rush Tokens", value = "```\n" .. bossRushTokenAmount .. "\n```" },
            { name = "Divine Core", value = "```\n" .. divine .. "\n```" }
        },
        footer = { text = currentTime }
    }

    (http_request or request)({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode({ embeds = { embed } })
    })
end

local function BuyTicket()
    if getgenv().buyBossTicket then
        spawn(function()
            local args = {
                [1] = "BuyBossRushShopItem",
                [2] = "Boss Rush Ticket (Gem)"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("MainRemoteFunction"):InvokeServer(unpack(args))
            wait(1)
        end)
    end 
end

local function FastMode()
    spawn(function()
        for key, object in pairs(workspace:GetDescendants()) do
            if object:IsA("Part") or object:IsA("UnionOperation") then
                object.Material = Enum.Material.SmoothPlastic
            elseif object:IsA("MeshPart") then
                object.Material = Enum.Material.SmoothPlastic
                object.TextureId = nil
            elseif object:IsA("Texture") then
                object:Destroy()
            end
        end
    end)
end

if game.PlaceId == 6938803436 or game.PlaceId == 7274690025 then
    sendDiscordWebhook()
    BuyTicket()
    FastMode()
elseif getgenv().Reset and game.PlaceId == 6990129309 then
    Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    FastMode()
end

local function loadExternalScript()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
    end)
    if not success then
        warn("Failed to load external script: " .. tostring(err))
    end
end

spawn(function()
    while wait(3) do
        local hub = CoreGui:FindFirstChild("OMG Hub | Anime Dimension | BETA!")
        if not hub then
            loadExternalScript()
        end
    end
end)
