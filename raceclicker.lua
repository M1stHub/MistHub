repeat wait() until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local webhookUrl1 = "https://discord.com/api/webhooks/1264818558148542476/R871Gvdj7e7xsqVwppRiIlsvJg23KQqLyGMv9jS5GX0n9A8BiTXjtijOY_EQHKtW1zQh"

local function sendDiscordWebhook()
    local player = Players.LocalPlayer
    local username = player.Name
    local gemAmount = player.PlayerGui.MainGui.CenterUIFrame.Shop.Frame.ShopGemCounter.ShopGemAmount.Text
    local raidTokenAmount = player.PlayerGui.MainGui.CenterUIFrame.Shop.Frame.ShopRaidTokenCounter.ShopRaidTokenAmount.Text
    local bossRushTokenAmount = player.PlayerGui.MainGui.CenterUIFrame.BossRushShop.BossRushShopCurrencyCounter.BossRushShopCurrencyAmount.Text
    local level = player.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame.CharacterTriIcon.Level.LevelShow.Text
    local xp = player.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame.Exp.Text

    local levelWithXp = level .. " (" .. xp .. ")"
    local hiddenUsername = "||" .. username .. "||"
    local content = ""

    local embed = {
        color = 16777215,
        fields = {
            { name = "Username", value = hiddenUsername },
            { name = "Level", value = "```\n" .. levelWithXp .. "\n```" },
            { name = "Gems", value = "```\n" .. gemAmount .. "\n```" },
            { name = "Raid Tokens", value = "```\n" .. raidTokenAmount .. "\n```" },
            { name = "Boss Rush Tokens", value = "```\n" .. bossRushTokenAmount .. "\n```" }
        }
    }

    (http_request) {
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ content = content, embeds = { embed } })
    }
end

local function sendBuyTicketWebhook(username)
    local embed = {
        color = 16777215,
        fields = {
            { name = "Username", value = "||" .. username .. "||" },
            { name = "Content", value = "```\nBought Boss Rush Ticket\n```" }
        }
    }

    (http_request) {
        Url = webhookUrl1,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ content = "", embeds = { embed } })
    }
end

local lastTicketPurchase = 0
local debounceTime = 7

local function BuyTicket()
    local player = Players.LocalPlayer
    local userId = player.UserId

    if getgenv().buyBossTicket then
        spawn(function()
            while true do
                local currentTime = tick()
                if currentTime - lastTicketPurchase >= debounceTime then
                    local args = {
                        [1] = "BuyBossRushShopItem",
                        [2] = "Boss Rush Ticket (Gem)"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("MainRemoteFunction"):InvokeServer(unpack(args))

                    if userId == 2860462252 then
                        sendBuyTicketWebhook(player.Name)
                    end

                    lastTicketPurchase = currentTime
                end

                wait(1)
            end
        end)
    end 
end

if game.PlaceId == 6938803436 or game.PlaceId == 7274690025 then
    sendDiscordWebhook()
    BuyTicket()
elseif getgenv().Reset and game.PlaceId == 6990129309 then
    Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
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
            print('not found')
            loadExternalScript()
        else
            print('found')
        end
    end
end)
