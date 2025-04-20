local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local startTime = tick()

local webhookUrl = getgenv().webhookUrl

local itemTargets = {
    ["Mythical Scroll"] = "mscroll",
    ["Leviathan Heart"] = "lheart",
    ["Leviathan Scale"] = "lscale",
    ["Terror Eyes"] = "teye",
    ["Fool's Gold"] = "fgold"
}

local itemCounts = {}

local function clearCounts()
    for item in pairs(itemTargets) do
        itemCounts[item] = 0
    end
end

local function collectItems()
    local frame = player.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame
    local itemFrame = frame.Frame

    for _, child in pairs(itemFrame:GetChildren()) do
        if not (child:IsA("UIPadding") or child:IsA("UIGridLayout")) and child:FindFirstChild("ItemName") then
            local itemName = child.ItemName.Text
            local itemLine1 = child:FindFirstChild("ItemLine1") and child.ItemLine1.Text or ""
            local fullItemName = itemName .. (itemLine1 ~= "" and (" " .. itemLine1) or "")

            for targetName in pairs(itemTargets) do
                if fullItemName:match("^" .. targetName) then
                    local count = tonumber(fullItemName:match("(%d+)$")) or 1
                    itemCounts[targetName] = itemCounts[targetName] + count
                end
            end
        end
    end
end

local function scrollAndCollect()
    local frame = player.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame
    local totalSize = frame.AbsoluteCanvasSize.Y
    local stepSize = 100
    local currentPos = 0

    while currentPos < totalSize do
        frame.CanvasPosition = Vector2.new(0, currentPos)
        wait(2)
        collectItems()
        currentPos = currentPos + stepSize
        if currentPos > totalSize then
            currentPos = totalSize
        end
    end
end

local function sendWebhookMessage()
    local description = ""

    for itemName, emoji in pairs(itemTargets) do
        local count = itemCounts[itemName] or 0
        description = description .. string.format("<:%s:1363597500000000000> : **%s**\n", emoji, count)
    end

    local embed = {
        title = "Scroll Tracker",
        color = 14291712,
        description = description,
        footer = {
            text = "Username: " .. player.Name
        }
    }

    local data = {
        embeds = { embed },
        attachments = {}
    }

    local success, response = pcall(function()
        (http_request or request)({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)

    if not success then
        warn("Failed to send webhook:", response)
    end
end

local function loopAndSendWebhook()
    while getgenv().Loop == true do
        clearCounts()
        scrollAndCollect()
        sendWebhookMessage()
        wait(300)
    end
end

if getgenv().Loop == true then
    loopAndSendWebhook()
else
    clearCounts()
    scrollAndCollect()
    sendWebhookMessage()
end
