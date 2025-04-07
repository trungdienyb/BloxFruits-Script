local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -100, 0, 10)
ToggleButton.Text = "AUTO FARM: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Parent = ScreenGui

-- Configuration
local Settings = {
    AutoFarm = false,
    FlySpeed = 100,
    RefreshRate = 5,
    NPCRadius = 2000,
    EnemyRefresh = 2
}

-- State Management
local Character
local Humanoid
local RootPart
local CurrentQuest
local NPCList = {}
local EnemyList = {}

-- Toggle Handler
ToggleButton.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    ToggleButton.Text = "AUTO FARM: " .. (Settings.AutoFarm and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = Settings.AutoFarm and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Character Handling
local function SetupCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    Humanoid.Died:Connect(function()
        repeat wait() until Player.Character:FindFirstChild("Humanoid")
        SetupCharacter()
    end)
end

SetupCharacter()

-- NPC/Enemy Updating
local function UpdateNPCList()
    NPCList = {}
    for _, npc in ipairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Quest") then
            table.insert(NPCList, npc)
        end
    end
end

local function UpdateEnemyList()
    EnemyList = {}
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            table.insert(EnemyList, enemy)
        end
    end
end

-- Movement System
local function FlyTo(targetCFrame)
    if not RootPart or not targetCFrame then return end
    local tweenInfo = TweenInfo.new(
        (RootPart.Position - targetCFrame.Position).Magnitude / Settings.FlySpeed,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Quest Logic
local function GetClosestNPC()
    UpdateNPCList()
    local closestNPC, minDistance = nil, math.huge
    
    for _, npc in ipairs(NPCList) do
        if npc.Quest.Level.Value <= Player.Level.Value then
            local distance = (RootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                closestNPC = npc
                minDistance = distance
            end
        end
    end
    return closestNPC
end

local function AcceptQuest(npc)
    game:GetService("ReplicatedStorage").Events.QuestEvent:FireServer(npc)
    CurrentQuest = npc.Quest
end

local function GetQuestEnemy()
    UpdateEnemyList()
    for _, enemy in ipairs(EnemyList) do
        if enemy.Name == CurrentQuest.Target.Value then
            return enemy
        end
    end
end

local function AttackEnemy(enemy)
    repeat
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(), enemy.HumanoidRootPart.CFrame)
        end
        task.wait()
    until not enemy or enemy.Humanoid.Health <= 0
end

-- Main Loop
local function MainProcess()
    while Settings.AutoFarm do
        if not Humanoid or Humanoid.Health <= 0 then
            repeat task.wait() until Humanoid.Health > 0
        end
        
        -- Accept Quest
        local npc = GetClosestNPC()
        if npc then
            FlyTo(npc.HumanoidRootPart.CFrame)
            AcceptQuest(npc)
        end
        
        -- Hunt Enemies
        if CurrentQuest then
            repeat
                local enemy = GetQuestEnemy()
                if enemy then
                    FlyTo(enemy.HumanoidRootPart.CFrame)
                    AttackEnemy(enemy)
                end
                task.wait(Settings.EnemyRefresh)
            until CurrentQuest.Progress.Value >= CurrentQuest.Required.Value
        end
        
        -- Complete Quest
        if npc then
            FlyTo(npc.HumanoidRootPart.CFrame)
            game:GetService("ReplicatedStorage").Events.CompleteQuest:FireServer(npc)
        end
        
        task.wait(Settings.RefreshRate)
    end
end

-- Auto-Start
RunService.Heartbeat:Connect(function()
    if Settings.AutoFarm then
        pcall(MainProcess)
    end
end)
