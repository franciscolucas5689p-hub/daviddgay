-- DAVI GAYZIN HUB
-- Voo automático somente nas abóboras
-- Para usar no seu próprio jogo no Roblox Studio

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local running = false
local speed = 80

local gui = Instance.new("ScreenGui")
gui.Name = "DAVI GAYZIN HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local start = Instance.new("TextButton")
start.Size = UDim2.fromOffset(200, 45)
start.Position = UDim2.fromOffset(20, 100)
start.Text = "VOAR NAS ABÓBORAS"
start.Parent = gui

local stop = Instance.new("TextButton")
stop.Size = UDim2.fromOffset(200, 45)
stop.Position = UDim2.fromOffset(20, 150)
stop.Text = "PARAR"
stop.Parent = gui

local function findPumpkins()
    local pumpkins = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = string.lower(obj.Name)

        if string.find(name, "pumpkin")
            or string.find(name, "abobora")
            or string.find(name, "abóbora") then

            if obj:IsA("BasePart") then
                table.insert(pumpkins, obj)
            elseif obj:IsA("Model") and obj.PrimaryPart then
                table.insert(pumpkins, obj.PrimaryPart)
            end
        end
    end

    return pumpkins
end

start.MouseButton1Click:Connect(function()
    if running then
        return
    end

    running = true

    task.spawn(function()
        while running do
            local character = player.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")

            if root then
                for _, pumpkin in ipairs(findPumpkins()) do
                    if not running then
                        break
                    end

                    if pumpkin.Parent then
                        local destination =
                            pumpkin.Position + Vector3.new(0, 8, 0)

                        local duration = math.max(
                            (root.Position - destination).Magnitude / speed,
                            0.2
                        )

                        local tween = TweenService:Create(
                            root,
                            TweenInfo.new(
                                duration,
                                Enum.EasingStyle.Linear
                            ),
                            {
                                CFrame = CFrame.new(destination)
                            }
                        )

                        tween:Play()
                        tween.Completed:Wait()
                    end
                end
            end

            task.wait(1)
        end
    end)
end)

stop.MouseButton1Click:Connect(function()
    running = false
end)
