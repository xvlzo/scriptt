-- Full Logic Code

-- Check if Triggerbot is already loaded
if getgenv().triggerbotLoaded then
    print("Triggerbot is already loaded.")
    return
end

-- Mark the script as loaded
getgenv().triggerbotLoaded = true

-- Define the Triggerbot table
getgenv().triggerbot = {
    Settings = {
        isEnabled = false,  -- Determines if clicking is enabled
        clickDelay = 0,     -- Time in seconds to wait before clicking
        toggleKey = Enum.KeyCode.T,  -- Key to toggle triggerbot
        activationKey = Enum.UserInputType.MouseButton2, -- X1 Mouse Button by default
        mode = "Hold",      -- Default mode: "Hold" or "Press"
        lastClickTime = 0   -- Tracks the last click time
    },
    load = function()
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local StarterGui = game:GetService("StarterGui")
        local LocalPlayer = Players.LocalPlayer
        local mouse = LocalPlayer:GetMouse()
        local active = false -- Tracks active state for Hold mode

        -- Function to simulate mouse click
        local function simulateClick()
            mouse1click()
        end

        -- Function to check if the hovered part belongs to another player
        local function isHoveringPlayer()
            local target = mouse.Target

            if target then
                local character = target:FindFirstAncestorOfClass("Model")
                if character and Players:GetPlayerFromCharacter(character) then
                    return true
                end
            end
            return false
        end

        -- Function to create a notification in the bottom right
        local function createNotification(message)
            StarterGui:SetCore("SendNotification", {
                Title = "Triggerbot",
                Text = message,
                Duration = 2,  -- Duration in seconds
            })
        end

        -- Listen for the toggle key press
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == getgenv().triggerbot.Settings.toggleKey and not gameProcessed then
                getgenv().triggerbot.Settings.isEnabled = not getgenv().triggerbot.Settings.isEnabled
                local statusMessage = getgenv().triggerbot.Settings.isEnabled and "enabled - stratxgy on github" or "disabled - stratxgy on github"
                print("Triggerbot is now " .. statusMessage)
                
                -- Show notification
                createNotification("Triggerbot is now " .. statusMessage)
            end
        end)

        -- Handle activation for Hold and Press modes
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == getgenv().triggerbot.Settings.activationKey and not gameProcessed then
                if getgenv().triggerbot.Settings.mode == "Press" then
                    active = not active
                elseif getgenv().triggerbot.Settings.mode == "Hold" then
                    active = true
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if getgenv().triggerbot.Settings.mode == "Hold" and input.UserInputType == getgenv().triggerbot.Settings.activationKey then
                active = false
            end
        end)

        -- Listen to mouse movement
        mouse.Move:Connect(function()
            if getgenv().triggerbot.Settings.isEnabled and active and isHoveringPlayer() then
                local currentTime = tick()
                if currentTime - getgenv().triggerbot.Settings.lastClickTime >= getgenv().triggerbot.Settings.clickDelay then
                    simulateClick()
                    getgenv().triggerbot.Settings.lastClickTime = currentTime
                end
            end
        end)
    end
}

-- Load the Triggerbot
getgenv().triggerbot.load()

-- Silent Aim Module
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Examples/AimLock.lua"))()
local AimingChecks = Aiming.Checks
local AimingSelected = Aiming.Selected

local SilentAimSettings = {
    Prediction = 0.165, -- Adjust prediction to match server latency
    SilentAim = true,
}
getgenv().SilentAimSettings = SilentAimSettings

function SilentAimSettings.ApplyPredictionFormula(SelectedPart, Velocity)
    return SelectedPart.CFrame + (Velocity * SilentAimSettings.Prediction)
end

local __index
__index = hookmetamethod(game, "__index", function(t, k)
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and AimingChecks.IsAvailable() and SilentAimSettings.SilentAim) then
        local SelectedPart = AimingSelected.Part
        local Velocity = AimingSelected.Velocity * Vector3.new(1, 0.1, 1)
        local Hit = SilentAimSettings.ApplyPredictionFormula(SelectedPart, Velocity)
        return (k == "Hit" and Hit or SelectedPart)
    end
    return __index(t, k)
end)

function SilentAimSettings.Enable()
    SilentAimSettings.SilentAim = true
    print("Silent Aim enabled")
end

function SilentAimSettings.Disable()
    SilentAimSettings.SilentAim = false
    print("Silent Aim disabled")
end

-- Aim Assist Module
local AimAssist = {}

function AimAssist.Init(settings)
    local Player = game.Players.LocalPlayer
    local Mouse = Player:GetMouse()
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local active = settings.Enabled

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[settings.ToggleKey] then
            active = not active
            print("Aim Assist is now", active and "Enabled" or "Disabled")
        end
    end)

    local function smoothAim(current, target, distance)
        local speedFactor = math.clamp(distance / 10, 0.05, 0.2)
        return current:Lerp(target, speedFactor)
    end

    RunService.RenderStepped:Connect(function()
        if active then
            local closestPlayer = nil
            local closestDistance = math.huge
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local targetPart = player.Character:FindFirstChild(settings.BodyPartPriority[1]) or player.Character:FindFirstChild("Head")
                    if targetPart then
                        local distance = (Mouse.Hit.p - targetPart.Position).Magnitude
                        if distance < settings.FOV and distance < closestDistance then
                            closestPlayer = targetPart
                            closestDistance = distance
                        end
                    end
                end
            end
            if closestPlayer then
                local currentAim = Mouse.Hit.p
                local targetAim = closestPlayer.Position
                local smoothedAim = smoothAim(currentAim, targetAim, closestDistance)
                Mouse.Hit = CFrame.new(smoothedAim)
            end
        end
    end)
end

return AimAssist
