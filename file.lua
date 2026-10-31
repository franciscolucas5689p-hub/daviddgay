-- DAVI GAYZIN HUB
-- Voo automático somente nas abóboras
-- Botão PARAR cancela o voo atual

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local running = false
local speed = 350
local currentTween = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DAVI GAYZIN HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão VOAR
local start = Instance.new("TextButton")
start.Name = "VoarButton"
start.Size = UDim2.new(0, 220, 0, 50)
start.Position = UDim2.new(0, 20, 0, 100)
start.BackgroundColor3 = Color3.fromRGB(35, 170, 70)
start.TextColor3 = Color3.fromRGB(255, 255, 255)
start.TextScaled = true
start.Text = "VOAR NAS ABÓBORAS"
start.Parent = gui

-- Botão PARAR
local stop = Instance.new("TextButton")
stop.Name = "PararButton"
stop.Size = UDim2.new(0, 220, 0, 50)
stop.Position = UDim2.new(0, 20, 0, 160)
stop.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
stop.TextColor3 = Color3.fromRGB(255, 255, 255)
stop.TextScaled = true
stop.Text = "PARAR"
stop.Parent = gui

-- Procurar somente abóboras
local function findPumpkins()
    local pumpkins = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = string.lower(obj.Name)

        if string.find(name, "pumpkin")
        or string.find(name, "abobora")
        or string.find(name, "abóbora") then

            if obj:IsA("BasePart") then
                table.insert(pumpkins, obj)

            elseif obj:IsA("Model") then
                local part = obj.PrimaryPart
                    or obj:FindFirstChildWhichIsA("BasePart", true)

                if part then
                    table.insert(pumpkins, part)
                end
            end
        end
    end

    return pumpkins
end

-- Iniciar voo
start.MouseButton1Click:Connect(function()
    if running then return end

    running = true

    task.spawn(function()
        while running do
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                local pumpkins = findPumpkins()

                for _, pumpkin in ipairs(pumpkins) do
                    if not running then break end

                    if pumpkin.Parent then
                        local destination =
                            pumpkin.Position + Vector3.new(0, 8, 0)

                        local distance =
                            (root.Position - destination).Magnitude

                        local duration = math.max(distance / speed, 0.2)

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

                        currentTween = tween
                        tween:Play()

                        tween.Completed:Wait()

                        if currentTween == tween then
                            currentTween = nil
                        end
                    end
                end
            end

            task.wait(1)
        end
    end)
end)

-- Parar imediatamente
stop.MouseButton1Click:Connect(function()
    running = false

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end)
