repeat wait() until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local webhookUrl1 = "https://discord.com/api/webhooks/1265048695737552978/3br5-1JpwiXb9kmdKk1ku1kd7lUORbnONWCDCNtYAvXYhkjZX9oCbphz1dz6c4IShtdi"

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
        Body = game:GetService("HttpService"):JSONEncode({ content = content, embeds = { embed } })
    }
end

local function sendBuyTicketWebhook(username, entryPassCount)
    local embed = {
        color = 16777215,
        fields = {
            { name = "Username", value = "||" .. username .. "||" },
            { name = "Content", value = "```\nBought Boss Rush Ticket (" .. entryPassCount .. ")\n```" }
        }
    }

    (http_request) {
        Url = webhookUrl1,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ content = "", embeds = { embed } })
    }
end

local function BuyTicket()
    if getgenv().buyBossTicket then
        spawn(function()
            while true do
                local gemAmountText = Players.LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Shop.Frame.ShopGemCounter.ShopGemAmount.Text
                local gemAmount = tonumber(gemAmountText)
                local ticketPrice = 200
                local ticketsToBuy = math.floor(gemAmount / ticketPrice)
                local player = Players.LocalPlayer

                if ticketsToBuy > 0 and player.UserId == 2860462252 then
                    for i = 1, ticketsToBuy do
                        local args = {
                            [1] = "BuyBossRushShopItem",
                            [2] = "Boss Rush Ticket (Gem)"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("MainRemoteFunction"):InvokeServer(unpack(args))
                    end
                    sendBuyTicketWebhook(player.Name, ticketsToBuy)
                end
                wait()
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
