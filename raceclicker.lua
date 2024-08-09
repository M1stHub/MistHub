local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local isActive = true
local targetPlayerName = "NoAimWasted"
local toggleKey = Enum.KeyCode.T

local function findTargetPlayer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name == targetPlayerName and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            return player
        end
    end
    return nil
end

local function teleportInFrontOfTargetPlayer()
    local targetPlayer = findTargetPlayer()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            local lookDirection = targetPlayer.Character.HumanoidRootPart.CFrame.LookVector
            targetPosition = targetPosition + lookDirection * 3
            targetPosition = Vector3.new(targetPosition.X, humanoidRootPart.Position.Y, targetPosition.Z)
            
            -- Set humanoidRootPart CFrame directly to teleport instantaneously
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end

local function toggleTeleportation()
    isActive = not isActive
end

local function onKeyPress(input)
    if input.KeyCode == toggleKey then
        toggleTeleportation()
    end
end

game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

while true do
    wait(0.1)
    if isActive then
        teleportInFrontOfTargetPlayer()
    end
end

print("Press 'T' to toggle teleportation on and off.")
