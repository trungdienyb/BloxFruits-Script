-- Blox Fruits Script độc lập
-- UI tự tạo, không dùng thư viện ngoài

-- Cấu hình
local Settings = {
    JoinTeam = "Pirates", -- Pirates/Marines
    Translator = true, -- true/false
    MobileOptimized = true -- Tối ưu cho điện thoại
}

-- Tạo UI từ đầu
local function CreateUI()
    -- CoreGui
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Xóa UI cũ nếu có
    if CoreGui:FindFirstChild("BloxFruitsUI") then
        CoreGui.BloxFruitsUI:Destroy()
    end
    
    -- Tạo main UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloxFruitsUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Settings.MobileOptimized and UDim2.new(0.9, 0, 0.7, 0) or UDim2.new(0.4, 0, 0.6, 0)
    MainFrame.Position = Settings.MobileOptimized and UDim2.new(0.05, 0, 0.15, 0) or UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.AnchorPoint = Vector2.new(0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0.08, 0)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Position = UDim2.new(0.1, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Blox Fruits Mobile"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = Settings.MobileOptimized and 18 or 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.1, 0, 1, 0)
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = Settings.MobileOptimized and 18 or 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0.1, 0)
    TabBar.Position = UDim2.new(0, 0, 0.08, 0)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame
    
    -- Tab Buttons sẽ được thêm động
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 0.82, 0)
    ContentFrame.Position = UDim2.new(0, 0, 0.18, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainFrame
    
    -- Scroll Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollFrame
    
    -- Trả về các thành phần UI chính
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabBar = TabBar,
        ContentFrame = ContentFrame,
        ScrollFrame = ScrollFrame
    }
end

-- Tạo các control UI cơ bản
local function CreateSection(parent, title)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "SectionFrame"
    SectionFrame.Size = UDim2.new(1, -10, 0, 0) -- Chiều cao tự động
    SectionFrame.Position = UDim2.new(0, 5, 0, 0)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    SectionFrame.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(1, -10, 0, 25)
    SectionTitle.Position = UDim2.new(0, 5, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title or ""
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = Settings.MobileOptimized and 16 or 14
    SectionTitle.Font = Enum.Font.Gotham
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Name = "ContentLayout"
    ContentLayout.Padding = UDim.new(0, 5)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = SectionFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Name = "ContentPadding"
    ContentPadding.PaddingTop = UDim.new(0, 30)
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 5)
    ContentPadding.PaddingBottom = UDim.new(0, 5)
    ContentPadding.Parent = SectionFrame
    
    return SectionFrame
end

local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, Settings.MobileOptimized and 40 or 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame
    
    local ToggleText = Instance.new("TextLabel")
    ToggleText.Name = "ToggleText"
    ToggleText.Size = UDim2.new(0.8, 0, 1, 0)
    ToggleText.Position = UDim2.new(0.1, 0, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = text or "Toggle"
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.TextSize = Settings.MobileOptimized and 16 or 14
    ToggleText.Font = Enum.Font.Gotham
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "ToggleIndicator"
    ToggleIndicator.Size = UDim2.new(0.05, 0, 0.6, 0)
    ToggleIndicator.Position = UDim2.new(0.03, 0, 0.2, 0)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local isToggled = false
    
    local function UpdateToggle()
        if isToggled then
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        UpdateToggle()
        if callback then
            callback(isToggled)
        end
    end)
    
    UpdateToggle()
    
    return {
        SetState = function(state)
            isToggled = state
            UpdateToggle()
        end
    }
end

-- Khởi tạo UI
local UI = CreateUI()

-- Tạo các tab chính
local Tabs = {}
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."TabButton"
    TabButton.Size = UDim2.new(0.2, 0, 1, 0)
    TabButton.Position = UDim2.new(#Tabs * 0.2, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = Settings.MobileOptimized and 14 or 12
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = UI.TabBar
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name.."TabContent"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Position = UDim2.new(0, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = UI.ScrollFrame
    
    table.insert(Tabs, {
        Name = name,
        Button = TabButton,
        Content = TabContent
    })
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    return TabContent
end

-- Tạo các tab và nội dung
local MainTab = CreateTab("Trang Chính")
local MainSection = CreateSection(MainTab, "Tính Năng Chính")

-- Auto Farm
CreateToggle(MainSection, "Tự Động Farm", function(state)
    getgenv().AutoFarm = state
    if state then
        spawn(function()
            while getgenv().AutoFarm do
                task.wait()
                pcall(function()
                    local Enemies = game:GetService("Workspace").Enemies:GetChildren()
                    local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    
                    for _, v in pairs(Enemies) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                            break
                        end
                    end
                end)
            end
        end)
    end
end)

-- Auto Quest
CreateToggle(MainSection, "Tự Động Nhiệm Vụ", function(state)
    getgenv().AutoQuest = state
    if state then
        spawn(function()
            while getgenv().AutoQuest do
                task.wait()
                pcall(function()
                    local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
                    if QuestTitle.Text == "" then
                        local args = {
                            [1] = "StartQuest",
                            [2] = tostring(game:GetService("Players").LocalPlayer.Data.Level.Value),
                            [3] = "BanditQuest1"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end)
            end
        end)
    end
end)

-- Nhiệm vụ ẩn
CreateToggle(MainSection, "Nhiệm Vụ Ẩn", function(state)
    getgenv().HiddenQuest = state
    if state then
        spawn(function()
            while getgenv().HiddenQuest do
                task.wait(1)
                pcall(function()
                    -- Nhiệm vụ Saber
                    if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
                        fireclickdetector(game:GetService("Workspace").Map.Desert.Burn.Fire.ClickDetector)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1094.14587, 47.5923653, 4842.79443)
                    end
                    
                    -- Nhiệm vụ Rengoku
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map["Boat Castle"].Summoner.Button, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map["Boat Castle"].Summoner.Button, 1)
                    end
                end)
            end
        end)
    end
end)

-- Chọn team
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

-- Kích hoạt tab đầu tiên
if #Tabs > 0 then
    Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Tabs[1].Content.Visible = true
end

-- Thông báo khi load xong
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blox Fruits Script",
    Text = "Script đã tải xong! Nhấn nút X để ẩn/hiện UI",
    Duration = 5
})
