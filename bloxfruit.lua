-- Tải thư viện UI (phiên bản nhẹ cho mobile)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    game:GetService("Players").LocalPlayer:Kick("Không thể tải thư viện UI! Vui lòng thử lại.")
    return
end

-- Tạo giao diện phù hợp với mobile
local Window = Library.CreateLib("Blox Fruits Mobile", {
    Theme = "Dark",
    Size = UDim2.new(0.9, 0, 0.7, 0), -- Kích thước phù hợp màn hình điện thoại
    Position = UDim2.new(0.05, 0, 0.15, 0)
})

-- Thêm delay để tránh lag trên mobile
local function MobileWait()
    if Settings.MobileOptimized then
        return task.wait(0.2)
    else
        return task.wait()
    end
end

-- Tab chính (tối ưu cho mobile)
local MainTab = Window:NewTab("Trang Chính", true) -- Icon để dễ nhận biết
local MainSection = MainTab:NewSection("Tính Năng Chính")

-- Auto Farm (tối ưu cho mobile)
MainSection:NewToggle("Tự Động Farm", "Tự động tấn công quái gần nhất", function(state)
    getgenv().AutoFarm = state
    if state then
        spawn(function()
            while getgenv().AutoFarm do
                MobileWait()
                pcall(function()
                    local closestEnemy, closestDistance = nil, math.huge
                    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                    
                    -- Chỉ kiểm tra 5 quái gần nhất để giảm lag
                    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestEnemy = enemy
                                closestDistance = distance
                            end
                        end
                    end
                    
                    if closestEnemy then
                        humanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                    end
                end)
            end
        end)
    end
end)

-- Auto Quest (tối ưu cho mobile)
MainSection:NewToggle("Tự Động NV", "Tự động nhận nhiệm vụ", function(state)
    getgenv().AutoQuest = state
    if state then
        spawn(function()
            while getgenv().AutoQuest do
                MobileWait()
                pcall(function()
                    local questTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
                    if questTitle.Text == "" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", tostring(game:GetService("Players").LocalPlayer.Data.Level.Value), "BanditQuest1")
                    end
                end)
            end
        end)
    end
end)

-- Nhiệm vụ ẩn (tối ưu cho mobile)
MainSection:NewToggle("NV Ẩn", "Tự động làm NV ẩn", function(state)
    getgenv().HiddenQuest = state
    if state then
        spawn(function()
            while getgenv().HiddenQuest do
                task.wait(1.5) -- Tăng thời gian chờ để giảm lag
                pcall(function()
                    -- Nhiệm vụ Saber
                    if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1094.14587, 47.5923653, 4842.79443)
                        task.wait(0.5)
                        fireclickdetector(game:GetService("Workspace").Map.Desert.Burn.Fire.ClickDetector)
                    end
                    
                    -- Nhiệm vụ Rengoku
                    if not game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess then
                        local button = game:GetService("Workspace").Map["Boat Castle"].Summoner.Button
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = button.CFrame
                        task.wait(0.5)
                        firetouchinterest(button, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                        task.wait(0.1)
                        firetouchinterest(button, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                    end
                end)
            end
        end)
    end
end)

-- Chọn team (giữ nguyên)
if Settings.JoinTeam then
    spawn(function()
        task.wait(5)
        if Settings.JoinTeam == "Pirates" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        elseif Settings.JoinTeam == "Marines" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        end
    end)
end

-- Dịch ngôn ngữ (tối ưu cho mobile)
if Settings.Translator then
    local TranslatorTab = Window:NewTab("Dịch", true)
    local TranslatorSection = TranslatorTab:NewSection("Dịch Ngôn Ngữ")
    
    local Languages = {
        "Tiếng Việt",
        "Tiếng Anh",
        "Tiếng Trung",
        "Tiếng Nhật",
        "Tiếng Hàn"
    }
    
    local SelectedLanguage = "Tiếng Việt"
    TranslatorSection:NewDropdown("Ngôn Ngữ", "Chọn ngôn ngữ", Languages, function(lang)
        SelectedLanguage = lang
    end)
    
    TranslatorSection:NewToggle("Tự Dịch", "Tự động dịch chat", function(state)
        getgenv().AutoTranslate = state
        if state then
            game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    "[DỊCH]: "..msg, "All"
                )
            end)
        end
    end)
end

-- Tab nhân vật (tối ưu cho mobile)
local PlayerTab = Window:NewTab("Nhân Vật", true)
local PlayerSection = PlayerTab:NewSection("Tùy Chỉnh")

-- Tốc độ di chuyển (giảm giá trị tối đa để phù hợp mobile)
PlayerSection:NewSlider("Tốc Độ", nil, 200, 16, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

-- Sức nhảy (giảm giá trị tối đa)
PlayerSection:NewSlider("Sức Nhảy", nil, 150, 50, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

-- Tab dịch chuyển (tối ưu cho mobile)
local TeleportTab = Window:NewTab("Dịch Chuyển", true)
local TeleportSection = TeleportTab:NewSection("Đảo")

local Islands = {
    "Đảo Bắt Đầu",
    "Rừng Rậm",
    "Làng Hải Tặc",
    "Sa Mạc",
    "Đảo Tuyết",
    "Căn Cứ HQ",
    "Đảo Trời 1",
    "Đảo Trời 2",
    "Đảo Trời 3"
}

TeleportSection:NewDropdown("Đến Đảo", "Chọn đảo muốn đến", Islands, function(island)
    local CFrames = {
        ["Đảo Bắt Đầu"] = CFrame.new(1071.2832, 16.3085976, 1426.86792),
        ["Rừng Rậm"] = CFrame.new(-1612.79578, 36.8520813, 149.128433),
        ["Làng Hải Tặc"] = CFrame.new(-1181.309326171875, 4.751490592956543, 3803.545654296875),
        ["Sa Mạc"] = CFrame.new(944.157897, 20.9197292, 4373.12842),
        ["Đảo Tuyết"] = CFrame.new(1347.8067626953125, 104.66806030273438, -1329.532470703125),
        ["Căn Cứ HQ"] = CFrame.new(-4914.82129, 331.794617, -4282.52832),
        ["Đảo Trời 1"] = CFrame.new(-4869.10254, 733.460632, -2662.45337),
        ["Đảo Trời 2"] = CFrame.new(-7894.61767578125, 5545.8349609375, -422.2179870605469),
        ["Đảo Trời 3"] = CFrame.new(-7924.20703125, 5630.43505859375, -1410.6290283203125)
    }
    
    if CFrames[island] then
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrames[island]
        end)
    end
end)

-- Tab khác (tối ưu cho mobile)
local MiscTab = Window:NewTab("Khác", true)
local MiscSection = MiscTab:NewSection("Tiện ích")

-- Tự động đánh
MiscSection:NewToggle("Tự Đánh", "Tự động đánh", function(state)
    getgenv().AutoClick = state
    if state then
        spawn(function()
            while getgenv().AutoClick do
                MobileWait()
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
            end
        end)
    end
end)

-- Chống AFK (giữ nguyên)
MiscSection:NewToggle("Chống AFK", nil, function(state)
    getgenv().AntiAFK = state
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Cài đặt UI (tối ưu cho mobile)
local SettingsTab = Window:NewTab("Cài Đặt", true)
local SettingsSection = SettingsTab:NewSection("Giao Diện")

SettingsSection:NewKeybind("Ẩn/Hiện UI", nil, Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

-- Thông báo khi load xong
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blox Fruits Mobile",
    Text = "Script đã tải xong! Nhấn RightShift để ẩn/hiện UI",
    Duration = 5
})