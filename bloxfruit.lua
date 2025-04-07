local Settings = {
    JoinTeam = "Pirates",     -- "Pirates" or "Marines"
    AutoQuest = true,         -- Tự động nhận và làm nhiệm vụ
    FarmRadius = 500,         -- Bán kính tìm quái nhiệm vụ
    AutoBoss = false,         -- Tự động đánh boss
    SafeMode = true,          -- Tránh khu vực nguy hiểm
    Webhook = ""              -- Discord webhook thông báo
}

-- Kích hoạt script
if not _G.BloxFruitsLoaded then
    _G.BloxFruitsLoaded = true
    
    -- Kết nối dịch vụ game
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    -- Danh sách NPC theo level
    local QuestNPCs = {
        {Name = "Bandit", Level = 1, Position = Vector3.new(-1145.68, 4.75, 3825.47), QuestName = "BanditQuest1"},
        {Name = "Monkey", Level = 15, Position = Vector3.new(-1498.07, 13.02, 377.38), QuestName = "MonkeyQuest1"},
        {Name = "Gorilla", Level = 30, Position = Vector3.new(-1243.24, 6.02, -2990.42), QuestName = "GorillaQuest1"},
        {Name = "Pirate", Level = 50, Position = Vector3.new(-1163.48, 4.75, 3932.1), QuestName = "PirateQuest1"},
        {Name = "Snow Bandit", Level = 70, Position = Vector3.new(1287.13, 106.57, -1340.19), QuestName = "SnowQuest1"},
        {Name = "Vampire", Level = 100, Position = Vector3.new(-6033.23, 6.48, -1317.46), QuestName = "VampireQuest1"},
        {Name = "Desert Bandit", Level = 120, Position = Vector3.new(1117.52, 4.75, 4350.18), QuestName = "DesertQuest1"}
    }
    
    -- Lấy NPC phù hợp với level
    function GetAppropriateNPC()
        local playerLevel = LocalPlayer.Data.Level.Value
        local bestNPC = nil
        local closestLevelDiff = math.huge
        
        for _, npc in pairs(QuestNPCs) do
            if npc.Level <= playerLevel then
                local levelDiff = playerLevel - npc.Level
                if levelDiff < closestLevelDiff then
                    closestLevelDiff = levelDiff
                    bestNPC = npc
                end
            end
        end
        
        return bestNPC or QuestNPCs[1] -- Mặc định trả về NPC đầu tiên nếu không tìm thấy
    end
    
    -- Chọn đội
    function JoinTeam(team)
        if team and (team:lower() == "pirates" or team:lower() == "marines") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", team:lower())
        end
    end
    
    -- Kiểm tra nhiệm vụ hiện tại
    function GetCurrentQuest()
        local playerGui = LocalPlayer.PlayerGui
        if playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest") then
            return playerGui.Main.Quest.Container.QuestTitle.Title.Text
        end
        return nil
    end
    
    -- Nhận nhiệm vụ từ NPC
    function AcceptQuest()
        local npcInfo = GetAppropriateNPC()
        if not npcInfo then return false end
        
        -- Di chuyển đến NPC
        Character:MoveTo(npcInfo.Position)
        wait(1)
        
        -- Nhận nhiệm vụ
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", npcInfo.QuestName, 1)
        wait(0.5)
        
        -- Kiểm tra đã nhận nhiệm vụ thành công chưa
        return GetCurrentQuest() ~= nil
    end
    
    -- Tìm quái nhiệm vụ
    function FindQuestEnemy()
        local currentQuest = GetCurrentQuest()
        if not currentQuest then return nil end
        
        -- Xác định tên quái từ nhiệm vụ
        local enemyName = currentQuest:match("Defeat (.-)%(") or currentQuest:match("defeat (.-)%(")
        if not enemyName then return nil end
        
        enemyName = enemyName:gsub("^%s*(.-)%s*$", "%1") -- Xóa khoảng trắng thừa
        
        -- Tìm quái trong phạm vi
        local closest = nil
        local dist = math.huge
        local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not humanoidRootPart then return nil end
        
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name:find(enemyName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < Settings.FarmRadius and distance < dist then
                    closest = enemy
                    dist = distance
                end
            end
        end
        
        return closest
    end
    
    -- Tấn công quái
    function AttackEnemy(target)
        if not target or not target:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Di chuyển đến quái
        Character:MoveTo(target.HumanoidRootPart.Position)
        
        -- Sử dụng skill tấn công
        local args = {
            [1] = "Z",
            [2] = target.HumanoidRootPart.Position
        }
        ReplicatedStorage.Remotes.CommF_:InvokeServer("activate", unpack(args))
        
        -- Tấn công cơ bản
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", 1)
    end
    
    -- Hoàn thành nhiệm vụ
    function CompleteQuest()
        local npcInfo = GetAppropriateNPC()
        if not npcInfo then return false end
        
        -- Di chuyển đến NPC
        Character:MoveTo(npcInfo.Position)
        wait(1)
        
        -- Nộp nhiệm vụ
        ReplicatedStorage.Remotes.CommF_:InvokeServer("FinishQuest", npcInfo.QuestName, 1)
        wait(0.5)
        
        -- Kiểm tra đã hoàn thành chưa
        return GetCurrentQuest() == nil
    end
    
    -- Main loop
    spawn(function()
        -- Chọn đội
        JoinTeam(Settings.JoinTeam)
        
        while wait() and Settings.AutoQuest do
            -- Kiểm tra nhiệm vụ hiện tại
            local currentQuest = GetCurrentQuest()
            
            if not currentQuest then
                -- Nhận nhiệm vụ mới nếu chưa có
                AcceptQuest()
                wait(1)
            else
                -- Tìm và farm quái nhiệm vụ
                local target = FindQuestEnemy()
                if target then
                    AttackEnemy(target)
                else
                    -- Di chuyển lại gần NPC nếu không tìm thấy quái
                    local npcInfo = GetAppropriateNPC()
                    if npcInfo then
                        Character:MoveTo(npcInfo.Position)
                    end
                end
                
                -- Kiểm tra hoàn thành nhiệm vụ
                if currentQuest:find("Completed") then
                    CompleteQuest()
                    wait(1)
                end
            end
            
            -- Đợi một chút trước khi lặp lại
            wait(0.5)
        end
    end)
    
    -- Thông báo khi script chạy
    print("Blox Fruits Auto-Level Quest Script đã được kích hoạt!")
    if Settings.Webhook ~= "" then
        -- Gửi thông báo đến Discord webhook
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = "Blox Fruits Auto-Level Quest Script đã được kích hoạt bởi "..LocalPlayer.Name,
            ["embeds"] = {
                {
                    ["title"] = "Thông tin script",
                    ["description"] = "Đang tự động chọn NPC theo level: "..LocalPlayer.Data.Level.Value,
                    ["color"] = 65280
                }
            }
        }
        
        local body = http:JSONEncode(data)
        pcall(function()
            http:PostAsync(Settings.Webhook, body, Enum.HttpContentType.ApplicationJson, false, headers)
        end)
    end
end
