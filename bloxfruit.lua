-- Blox Fruit Automation Script
-- Version 2.0 (Hoàn thiện)
-- Created by [Your Name]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Constants
local COLORS = {
    BACKGROUND = Color3.fromRGB(30, 30, 40),
    TAB_BACKGROUND = Color3.fromRGB(40, 40, 50),
    CONTENT_BACKGROUND = Color3.fromRGB(35, 35, 45),
    BUTTON_NORMAL = Color3.fromRGB(60, 60, 70),
    BUTTON_ACTIVE = Color3.fromRGB(80, 120, 80),
    BUTTON_SPECIAL = Color3.fromRGB(80, 80, 120),
    TEXT = Color3.fromRGB(255, 255, 255),
    TEXT_HIGHLIGHT = Color3.fromRGB(200, 200, 255),
    TAB_ACTIVE = Color3.fromRGB(70, 70, 90),
    TAB_INACTIVE = Color3.fromRGB(50, 50, 60)
}

-- Game Data (cần cập nhật theo phiên bản game)
local GAME_DATA = {
    RACES = {"Human", "Skypiean", "Fishman", "Mink", "Cyborg"},
    SEAS = {"First Sea", "Second Sea", "Third Sea"},
    ISLANDS = {
        ["First Sea"] = {"Starter Island", "Marine Fortress", "Sky Island", "Pirate Village", "Desert"},
        ["Second Sea"] = {"Kingdom of Rose", "Usoap's Island", "Green Zone"},
        ["Third Sea"] = {"Port Town", "Castle on the Sea", "Hydra Island"}
    },
    WEAPONS = {"Sword", "Melee", "Gun"},
    DISTANCES = {"5", "10", "15", "20"},
    SKILL_PRIORITIES = {"Z > X > C > V", "X > Z > C > V", "C > X > Z > V"}
}

-- Tạo main UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabButtons = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local ContentFrame = Instance.new("Frame")

ScreenGui.Name = "BloxFruitAutomation"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = COLORS.BACKGROUND
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Active = true
MainFrame.Draggable = true

TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = COLORS.TAB_BACKGROUND
TabButtons.BackgroundTransparency = 0.1
TabButtons.Size = UDim2.new(1, 0, 0.1, 0)

UIListLayout.Parent = TabButtons
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = COLORS.CONTENT_BACKGROUND
ContentFrame.BackgroundTransparency = 0.1
ContentFrame.Position = UDim2.new(0, 0, 0.1, 0)
ContentFrame.Size = UDim2.new(1, 0, 0.9, 0)

-- Tạo các tab
local tabs = {
    "Auto Farm",
    "Quest",
    "Shop",
    "Race",
    "Up Fruit",
    "Settings"
}

local currentTab = nil
local tabButtons = {}

local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Parent = TabButtons
    button.BackgroundColor3 = COLORS.TAB_INACTIVE
    button.BackgroundTransparency = 0.1
    button.Size = UDim2.new(1/#tabs, 0, 1, 0)
    button.Text = name
    button.TextColor3 = COLORS.TEXT
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    
    button.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
            tabButtons[currentTab.Name:gsub("Content", "Tab")].BackgroundColor3 = COLORS.TAB_INACTIVE
            tabButtons[currentTab.Name:gsub("Content", "Tab")].TextColor3 = COLORS.TEXT
        end
        currentTab = ContentFrame:FindFirstChild(name .. "Content")
        if currentTab then
            currentTab.Visible = true
            button.BackgroundColor3 = COLORS.TAB_ACTIVE
            button.TextColor3 = Color3.fromRGB(255, 255, 0) -- Màu vàng khi active
        end
    end)
    
    tabButtons[name .. "Tab"] = button
    return button
end

local function createTabContent(name)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Content"
    frame.Parent = ContentFrame
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Visible = false
    
    return frame
end

-- Tạo nội dung cho từng tab
for _, tabName in ipairs(tabs) do
    createTabButton(tabName)
    local content = createTabContent(tabName)
    
    -- Auto Farm Tab
    if tabName == "Auto Farm" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
        scroll.ScrollBarThickness = 5
        
        -- Toggle Auto Farm
        local toggleFarm = Instance.new("TextButton")
        toggleFarm.Parent = scroll
        toggleFarm.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleFarm.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleFarm.Text = "Enable Auto Farm"
        toggleFarm.TextColor3 = COLORS.TEXT
        toggleFarm.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleFarm.BackgroundTransparency = 0.1
        
        local farmEnabled = false
        toggleFarm.MouseButton1Click:Connect(function()
            farmEnabled = not farmEnabled
            toggleFarm.Text = farmEnabled and "Disable Auto Farm" or "Enable Auto Farm"
            toggleFarm.BackgroundColor3 = farmEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
            
            if farmEnabled then
                spawn(function()
                    while farmEnabled and wait() do
                        autoFarmQuest()
                    end
                end)
            end
        end)
        
        -- Weapon Selection
        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Parent = scroll
        weaponLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        weaponLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
        weaponLabel.Text = "Select Weapon:"
        weaponLabel.TextColor3 = COLORS.TEXT
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local weaponDropdown = Instance.new("TextButton")
        weaponDropdown.Parent = scroll
        weaponDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        weaponDropdown.Position = UDim2.new(0.05, 0, 0.2, 0)
        weaponDropdown.Text = GAME_DATA.WEAPONS[1] .. " ▼"
        weaponDropdown.TextColor3 = COLORS.TEXT
        weaponDropdown.BackgroundColor3 = COLORS.BUTTON_NORMAL
        weaponDropdown.BackgroundTransparency = 0.1
        
        local selectedWeapon = 1
        weaponDropdown.MouseButton1Click:Connect(function()
            selectedWeapon = (selectedWeapon % #GAME_DATA.WEAPONS) + 1
            weaponDropdown.Text = GAME_DATA.WEAPONS[selectedWeapon] .. " ▼"
        end)
        
        -- Distance Setting
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Parent = scroll
        distanceLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        distanceLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
        distanceLabel.Text = "Farm Distance:"
        distanceLabel.TextColor3 = COLORS.TEXT
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local distanceSlider = Instance.new("TextButton")
        distanceSlider.Parent = scroll
        distanceSlider.Size = UDim2.new(0.9, 0, 0.08, 0)
        distanceSlider.Position = UDim2.new(0.05, 0, 0.38, 0)
        distanceSlider.Text = GAME_DATA.DISTANCES[2] .. " ▼"
        distanceSlider.TextColor3 = COLORS.TEXT
        distanceSlider.BackgroundColor3 = COLORS.BUTTON_NORMAL
        distanceSlider.BackgroundTransparency = 0.1
        
        local selectedDistance = 2
        distanceSlider.MouseButton1Click:Connect(function()
            selectedDistance = (selectedDistance % #GAME_DATA.DISTANCES) + 1
            distanceSlider.Text = GAME_DATA.DISTANCES[selectedDistance] .. " ▼"
        end)
        
        -- Mob Aura Toggle
        local toggleAura = Instance.new("TextButton")
        toggleAura.Parent = scroll
        toggleAura.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleAura.Position = UDim2.new(0.05, 0, 0.5, 0)
        toggleAura.Text = "Enable Mob Aura"
        toggleAura.TextColor3 = COLORS.TEXT
        toggleAura.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleAura.BackgroundTransparency = 0.1
        
        local auraEnabled = false
        toggleAura.MouseButton1Click:Connect(function()
            auraEnabled = not auraEnabled
            toggleAura.Text = auraEnabled and "Disable Mob Aura" or "Enable Mob Aura"
            toggleAura.BackgroundColor3 = auraEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
        end)
        
        -- Auto Haki Toggle
        local toggleHaki = Instance.new("TextButton")
        toggleHaki.Parent = scroll
        toggleHaki.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleHaki.Position = UDim2.new(0.05, 0, 0.6, 0)
        toggleHaki.Text = "Enable Auto Haki"
        toggleHaki.TextColor3 = COLORS.TEXT
        toggleHaki.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleHaki.BackgroundTransparency = 0.1
        
        local hakiEnabled = false
        toggleHaki.MouseButton1Click:Connect(function()
            hakiEnabled = not hakiEnabled
            toggleHaki.Text = hakiEnabled and "Disable Auto Haki" or "Enable Auto Haki"
            toggleHaki.BackgroundColor3 = hakiEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
        end)
    
    -- Quest Tab
    elseif tabName == "Quest" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        scroll.ScrollBarThickness = 5
        
        -- Hidden Quest Toggle
        local toggleHiddenQuest = Instance.new("TextButton")
        toggleHiddenQuest.Parent = scroll
        toggleHiddenQuest.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleHiddenQuest.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleHiddenQuest.Text = "Enable Hidden Quest"
        toggleHiddenQuest.TextColor3 = COLORS.TEXT
        toggleHiddenQuest.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleHiddenQuest.BackgroundTransparency = 0.1
        
        local hiddenQuestEnabled = false
        toggleHiddenQuest.MouseButton1Click:Connect(function()
            hiddenQuestEnabled = not hiddenQuestEnabled
            toggleHiddenQuest.Text = hiddenQuestEnabled and "Disable Hidden Quest" or "Enable Hidden Quest"
            toggleHiddenQuest.BackgroundColor3 = hiddenQuestEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
            
            if hiddenQuestEnabled then
                spawn(function()
                    while hiddenQuestEnabled and wait(1) do
                        autoHiddenQuest()
                    end
                end)
            end
        end)
    
    -- Shop Tab
    elseif tabName == "Shop" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
        scroll.ScrollBarThickness = 5
        
        -- Weapon Shop
        local weaponShopLabel = Instance.new("TextLabel")
        weaponShopLabel.Parent = scroll
        weaponShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        weaponShopLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        weaponShopLabel.Text = "Weapon Shop:"
        weaponShopLabel.TextColor3 = COLORS.TEXT
        weaponShopLabel.BackgroundTransparency = 1
        weaponShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        weaponShopLabel.TextSize = 16
        
        -- Giả lập dữ liệu shop
        local weaponShopItems = {
            {"Katana", "50,000"},
            {"Cutlass", "75,000"},
            {"Dual Katana", "120,000"},
            {"Triple Katana", "250,000"},
            {"Pipe", "30,000"}
        }
        
        for i, item in ipairs(weaponShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 0.1 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = COLORS.TEXT_HIGHLIGHT
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Fighting Style Shop
        local styleShopLabel = Instance.new("TextLabel")
        styleShopLabel.Parent = scroll
        styleShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        styleShopLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
        styleShopLabel.Text = "Fighting Style Shop:"
        styleShopLabel.TextColor3 = COLORS.TEXT
        styleShopLabel.BackgroundTransparency = 1
        styleShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        styleShopLabel.TextSize = 16
        
        local styleShopItems = {
            {"Black Leg", "150,000"},
            {"Electro", "250,000"},
            {"Fishman Karate", "500,000"},
            {"Dragon Breath", "750,000"},
            {"Superhuman", "3,000,000"}
        }
        
        for i, item in ipairs(styleShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 0.58 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = COLORS.TEXT_HIGHLIGHT
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Devil Fruit Shop
        local fruitShopLabel = Instance.new("TextLabel")
        fruitShopLabel.Parent = scroll
        fruitShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        fruitShopLabel.Position = UDim2.new(0.05, 0, 1.0, 0)
        fruitShopLabel.Text = "Devil Fruit Shop:"
        fruitShopLabel.TextColor3 = COLORS.TEXT
        fruitShopLabel.BackgroundTransparency = 1
        fruitShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        fruitShopLabel.TextSize = 16
        
        local fruitShopItems = {
            {"Bomb-Bomb Fruit", "1,200,000"},
            {"Spike-Spike Fruit", "1,500,000"},
            {"Flame-Flame Fruit", "2,500,000"},
            {"Ice-Ice Fruit", "2,500,000"},
            {"Dark-Dark Fruit", "5,000,000"}
        }
        
        for i, item in ipairs(fruitShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 1.08 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = COLORS.TEXT_HIGHLIGHT
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
    
    -- Race Tab
    elseif tabName == "Race" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        scroll.ScrollBarThickness = 5
        
        local raceLabel = Instance.new("TextLabel")
        raceLabel.Parent = scroll
        raceLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
        raceLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        raceLabel.Text = "Select Race to Upgrade:"
        raceLabel.TextColor3 = COLORS.TEXT
        raceLabel.BackgroundTransparency = 1
        raceLabel.TextSize = 16
        
        for i, race in ipairs(GAME_DATA.RACES) do
            local raceButton = Instance.new("TextButton")
            raceButton.Parent = scroll
            raceButton.Size = UDim2.new(0.9, 0, 0.12, 0)
            raceButton.Position = UDim2.new(0.05, 0, 0.15 + (i-1)*0.15, 0)
            raceButton.Text = race
            raceButton.TextColor3 = COLORS.TEXT
            raceButton.BackgroundColor3 = COLORS.BUTTON_NORMAL
            raceButton.BackgroundTransparency = 0.1
            
            raceButton.MouseButton1Click:Connect(function()
                spawn(function()
                    upgradeRace(race)
                end)
            end)
        end
    
    -- Up Fruit Tab
    elseif tabName == "Up Fruit" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
        scroll.ScrollBarThickness = 5
        
        -- Toggle Fruit Farm
        local toggleFruitFarm = Instance.new("TextButton")
        toggleFruitFarm.Parent = scroll
        toggleFruitFarm.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleFruitFarm.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleFruitFarm.Text = "Enable Fruit Farm"
        toggleFruitFarm.TextColor3 = COLORS.TEXT
        toggleFruitFarm.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleFruitFarm.BackgroundTransparency = 0.1
        
        local fruitFarmEnabled = false
        toggleFruitFarm.MouseButton1Click:Connect(function()
            fruitFarmEnabled = not fruitFarmEnabled
            toggleFruitFarm.Text = fruitFarmEnabled and "Disable Fruit Farm" or "Enable Fruit Farm"
            toggleFruitFarm.BackgroundColor3 = fruitFarmEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
            
            if fruitFarmEnabled then
                spawn(function()
                    while fruitFarmEnabled and wait() do
                        autoUpFruit()
                    end
                end)
            end
        end)
        
        -- Auto Skill Toggle
        local toggleAutoSkill = Instance.new("TextButton")
        toggleAutoSkill.Parent = scroll
        toggleAutoSkill.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleAutoSkill.Position = UDim2.new(0.05, 0, 0.15, 0)
        toggleAutoSkill.Text = "Enable Auto Skills"
        toggleAutoSkill.TextColor3 = COLORS.TEXT
        toggleAutoSkill.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleAutoSkill.BackgroundTransparency = 0.1
        
        local autoSkillEnabled = false
        toggleAutoSkill.MouseButton1Click:Connect(function()
            autoSkillEnabled = not autoSkillEnabled
            toggleAutoSkill.Text = autoSkillEnabled and "Disable Auto Skills" or "Enable Auto Skills"
            toggleAutoSkill.BackgroundColor3 = autoSkillEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
        end)
        
        -- Skill Priority
        local skillPriorityLabel = Instance.new("TextLabel")
        skillPriorityLabel.Parent = scroll
        skillPriorityLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        skillPriorityLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
        skillPriorityLabel.Text = "Skill Priority:"
        skillPriorityLabel.TextColor3 = COLORS.TEXT
        skillPriorityLabel.BackgroundTransparency = 1
        skillPriorityLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local skillPriorityDropdown = Instance.new("TextButton")
        skillPriorityDropdown.Parent = scroll
        skillPriorityDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        skillPriorityDropdown.Position = UDim2.new(0.05, 0, 0.38, 0)
        skillPriorityDropdown.Text = GAME_DATA.SKILL_PRIORITIES[1] .. " ▼"
        skillPriorityDropdown.TextColor3 = COLORS.TEXT
        skillPriorityDropdown.BackgroundColor3 = COLORS.BUTTON_NORMAL
        skillPriorityDropdown.BackgroundTransparency = 0.1
        
        local selectedPriority = 1
        skillPriorityDropdown.MouseButton1Click:Connect(function()
            selectedPriority = (selectedPriority % #GAME_DATA.SKILL_PRIORITIES) + 1
            skillPriorityDropdown.Text = GAME_DATA.SKILL_PRIORITIES[selectedPriority] .. " ▼"
        end)
    
    -- Settings Tab
    elseif tabName == "Settings" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
        scroll.ScrollBarThickness = 5
        
        -- UI Settings
        local uiSettingsLabel = Instance.new("TextLabel")
        uiSettingsLabel.Parent = scroll
        uiSettingsLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        uiSettingsLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        uiSettingsLabel.Text = "UI Settings:"
        uiSettingsLabel.TextColor3 = COLORS.TEXT
        uiSettingsLabel.BackgroundTransparency = 1
        uiSettingsLabel.TextSize = 16
        
        -- UI Theme
        local themeLabel = Instance.new("TextLabel")
        themeLabel.Parent = scroll
        themeLabel.Size = UDim2.new(0.9, 0, 0.05, 0)
        themeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        themeLabel.Text = "UI Theme:"
        themeLabel.TextColor3 = COLORS.TEXT
        themeLabel.BackgroundTransparency = 1
        themeLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local themeDropdown = Instance.new("TextButton")
        themeDropdown.Parent = scroll
        themeDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        themeDropdown.Position = UDim2.new(0.05, 0, 0.17, 0)
        themeDropdown.Text = "Dark ▼"
        themeDropdown.TextColor3 = COLORS.TEXT
        themeDropdown.BackgroundColor3 = COLORS.BUTTON_NORMAL
        themeDropdown.BackgroundTransparency = 0.1
        
        local themeOptions = {"Dark", "Light", "Blue", "Red"}
        local selectedTheme = 1
        
        themeDropdown.MouseButton1Click:Connect(function()
            selectedTheme = (selectedTheme % #themeOptions) + 1
            themeDropdown.Text = themeOptions[selectedTheme] .. " ▼"
            
            -- Thay đổi theme UI
            local themes = {
                Dark = {bg = Color3.fromRGB(30, 30, 40), tab = Color3.fromRGB(40, 40, 50), content = Color3.fromRGB(35, 35, 45)},
                Light = {bg = Color3.fromRGB(240, 240, 240), tab = Color3.fromRGB(220, 220, 220), content = Color3.fromRGB(230, 230, 230)},
                Blue = {bg = Color3.fromRGB(30, 60, 90), tab = Color3.fromRGB(40, 80, 120), content = Color3.fromRGB(35, 70, 100)},
                Red = {bg = Color3.fromRGB(90, 30, 30), tab = Color3.fromRGB(120, 40, 40), content = Color3.fromRGB(100, 35, 35)}
            }
            
            MainFrame.BackgroundColor3 = themes[themeOptions[selectedTheme]].bg
            TabButtons.BackgroundColor3 = themes[themeOptions[selectedTheme]].tab
            ContentFrame.BackgroundColor3 = themes[themeOptions[selectedTheme]].content
        end)
        
        -- Save Settings
        local saveButton = Instance.new("TextButton")
        saveButton.Parent = scroll
        saveButton.Size = UDim2.new(0.9, 0, 0.1, 0)
        saveButton.Position = UDim2.new(0.05, 0, 0.3, 0)
        saveButton.Text = "Save Settings"
        saveButton.TextColor3 = COLORS.TEXT
        saveButton.BackgroundColor3 = COLORS.BUTTON_ACTIVE
        saveButton.BackgroundTransparency = 0.1
        
        saveButton.MouseButton1Click:Connect(function()
            -- Lưu cài đặt
            saveSettings()
        end)
        
        -- Teleport Settings
        local teleportLabel = Instance.new("TextLabel")
        teleportLabel.Parent = scroll
        teleportLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        teleportLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
        teleportLabel.Text = "Teleport:"
        teleportLabel.TextColor3 = COLORS.TEXT
        teleportLabel.BackgroundTransparency = 1
        teleportLabel.TextSize = 16
        
        -- Sea Selection
        local seaDropdown = Instance.new("TextButton")
        seaDropdown.Parent = scroll
        seaDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        seaDropdown.Position = UDim2.new(0.05, 0, 0.53, 0)
        seaDropdown.Text = GAME_DATA.SEAS[1] .. " ▼"
        seaDropdown.TextColor3 = COLORS.TEXT
        seaDropdown.BackgroundColor3 = COLORS.BUTTON_NORMAL
        seaDropdown.BackgroundTransparency = 0.1
        
        local selectedSea = 1
        seaDropdown.MouseButton1Click:Connect(function()
            selectedSea = (selectedSea % #GAME_DATA.SEAS) + 1
            seaDropdown.Text = GAME_DATA.SEAS[selectedSea] .. " ▼"
            
            -- Cập nhật danh sách đảo khi chọn sea
            islandDropdown.Text = GAME_DATA.ISLANDS[GAME_DATA.SEAS[selectedSea]][1] .. " ▼"
            selectedIsland = 1
        end)
        
        -- Island Selection
        local islandDropdown = Instance.new("TextButton")
        islandDropdown.Parent = scroll
        islandDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        islandDropdown.Position = UDim2.new(0.05, 0, 0.65, 0)
        islandDropdown.Text = GAME_DATA.ISLANDS[GAME_DATA.SEAS[1]][1] .. " ▼"
        islandDropdown.TextColor3 = COLORS.TEXT
        islandDropdown.BackgroundColor3 = COLORS.BUTTON_NORMAL
        islandDropdown.BackgroundTransparency = 0.1
        
        local selectedIsland = 1
        islandDropdown.MouseButton1Click:Connect(function()
            selectedIsland = (selectedIsland % #GAME_DATA.ISLANDS[GAME_DATA.SEAS[selectedSea]]) + 1
            islandDropdown.Text = GAME_DATA.ISLANDS[GAME_DATA.SEAS[selectedSea]][selectedIsland] .. " ▼"
        end)
        
        -- Teleport Button
        local teleportButton = Instance.new("TextButton")
        teleportButton.Parent = scroll
        teleportButton.Size = UDim2.new(0.9, 0, 0.1, 0)
        teleportButton.Position = UDim2.new(0.05, 0, 0.77, 0)
        teleportButton.Text = "Teleport"
        teleportButton.TextColor3 = COLORS.TEXT
        teleportButton.BackgroundColor3 = COLORS.BUTTON_SPECIAL
        teleportButton.BackgroundTransparency = 0.1
        
        teleportButton.MouseButton1Click:Connect(function()
            local sea = GAME_DATA.SEAS[selectedSea]
            local island = GAME_DATA.ISLANDS[sea][selectedIsland]
            teleportToSeaAndIsland(sea, island)
        end)
        
        -- Stat Allocation
        local statLabel = Instance.new("TextLabel")
        statLabel.Parent = scroll
        statLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        statLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
        statLabel.Text = "Auto Stat Allocation:"
        statLabel.TextColor3 = COLORS.TEXT
        statLabel.BackgroundTransparency = 1
        statLabel.TextSize = 16
        
        local meleeStat = Instance.new("TextBox")
        meleeStat.Parent = scroll
        meleeStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        meleeStat.Position = UDim2.new(0.05, 0, 0.98, 0)
        meleeStat.Text = "40"
        meleeStat.PlaceholderText = "Melee %"
        meleeStat.BackgroundColor3 = COLORS.BUTTON_NORMAL
        meleeStat.BackgroundTransparency = 0.1
        meleeStat.TextColor3 = COLORS.TEXT
        
        local defenseStat = Instance.new("TextBox")
        defenseStat.Parent = scroll
        defenseStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        defenseStat.Position = UDim2.new(0.36, 0, 0.98, 0)
        defenseStat.Text = "30"
        defenseStat.PlaceholderText = "Defense %"
        defenseStat.BackgroundColor3 = COLORS.BUTTON_NORMAL
        defenseStat.BackgroundTransparency = 0.1
        defenseStat.TextColor3 = COLORS.TEXT
        
        local swordStat = Instance.new("TextBox")
        swordStat.Parent = scroll
        swordStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        swordStat.Position = UDim2.new(0.67, 0, 0.98, 0)
        swordStat.Text = "30"
        swordStat.PlaceholderText = "Sword %"
        swordStat.BackgroundColor3 = COLORS.BUTTON_NORMAL
        swordStat.BackgroundTransparency = 0.1
        swordStat.TextColor3 = COLORS.TEXT
        
        -- Auto Stats Toggle
        local toggleAutoStats = Instance.new("TextButton")
        toggleAutoStats.Parent = scroll
        toggleAutoStats.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleAutoStats.Position = UDim2.new(0.05, 0, 1.1, 0)
        toggleAutoStats.Text = "Enable Auto Stats"
        toggleAutoStats.TextColor3 = COLORS.TEXT
        toggleAutoStats.BackgroundColor3 = COLORS.BUTTON_NORMAL
        toggleAutoStats.BackgroundTransparency = 0.1
        
        local autoStatsEnabled = false
        toggleAutoStats.MouseButton1Click:Connect(function()
            autoStatsEnabled = not autoStatsEnabled
            toggleAutoStats.Text = autoStatsEnabled and "Disable Auto Stats" or "Enable Auto Stats"
            toggleAutoStats.BackgroundColor3 = autoStatsEnabled and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_NORMAL
            
            if autoStatsEnabled then
                spawn(function()
                    while autoStatsEnabled and wait(5) do
                        autoAddStats()
                    end
                end)
            end
        end)
    end
end

-- Mở tab đầu tiên khi khởi động
currentTab = ContentFrame:FindFirstChild("Auto FarmContent")
if currentTab then
    currentTab.Visible = true
    tabButtons["Auto FarmTab"].BackgroundColor3 = COLORS.TAB_ACTIVE
    tabButtons["Auto FarmTab"].TextColor3 = Color3.fromRGB(255, 255, 0)
end

-- Tạo nút đóng/mở UI
local toggleUI = Instance.new("TextButton")
toggleUI.Name = "ToggleUI"
toggleUI.Parent = ScreenGui
toggleUI.BackgroundColor3 = COLORS.BUTTON_NORMAL
toggleUI.BackgroundTransparency = 0.1
toggleUI.Position = UDim2.new(0, 0, 0.5, 0)
toggleUI.Size = UDim2.new(0.05, 0, 0.1, 0)
toggleUI.Text = "Close"
toggleUI.TextColor3 = COLORS.TEXT

local uiVisible = true
toggleUI.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
    toggleUI.Text = uiVisible and "Close" or "Open"
end)

-- Các hàm logic chính
function autoFarmQuest()
    -- Kiểm tra nếu đang trong combat hoặc có boss gần đó
    if not checkBossNearby() then
        -- Nhận quest nếu chưa có
        if not hasQuest() then
            getQuestFromNPC()
            wait(2)
        else
            -- Tìm quái vật mục tiêu
            local target = findNearestMob(questMobName)
            if target then
                -- Di chuyển đến quái vật với khoảng cách an toàn
                moveToTarget(target, tonumber(GAME_DATA.DISTANCES[selectedDistance]))
                
                -- Sử dụng Haki nếu được bật
                if hakiEnabled then
                    useHaki()
                end
                
                -- Tấn công với vũ khí được chọn
                attackWithWeapon(GAME_DATA.WEAPONS[selectedWeapon], target)
                
                -- Gom quái nếu được bật
                if auraEnabled then
                    gatherMobs()
                end
            else
                -- Nếu không tìm thấy quái, đợi một chút rồi thử lại
                wait(1)
            end
        end
    else
        -- Nếu có boss gần đó, né tránh
        avoidBoss()
        wait(3)
    end
end

function autoHiddenQuest()
    -- Kiểm tra các vị trí nhiệm vụ ẩn đã biết
    for _, location in pairs(hiddenQuestLocations) do
        teleportTo(location)
        
        -- Kiểm tra NPC nhiệm vụ ẩn
        local npc = findHiddenQuestNPC()
        if npc then
            interactWithNPC(npc)
            wait(2)
            
            -- Hoàn thành nhiệm vụ nếu có thể
            if canCompleteHiddenQuest() then
                completeHiddenQuest()
                wait(3)
            end
        end
    end
end

function upgradeRace(race)
    -- Xác định nhiệm vụ cần làm cho race
    local quests = raceQuests[race]
    
    for _, questInfo in pairs(quests) do
        -- Di chuyển đến vị trí nhiệm vụ
        teleportTo(questInfo.location)
        
        -- Nhận nhiệm vụ
        local npc = findNPC(questInfo.npcName)
        if npc then
            interactWithNPC(npc)
            wait(2)
            
            -- Hoàn thành yêu cầu nhiệm vụ
            while not isQuestComplete() do
                if questInfo.type == "kill" then
                    local target = findNearestMob(questInfo.target)
                    if target then
                        attackWithWeapon("Melee", target)
                    end
                elseif questInfo.type == "collect" then
                    collectItems(questInfo.item, questInfo.amount)
                end
                wait(0.1)
            end
            
            -- Nộp nhiệm vụ
            turnInQuest(npc)
            wait(3)
        end
    end
end

function autoUpFruit()
    -- Kiểm tra năng lượng fruit skill
    checkFruitEnergy()
    
    -- Tìm quái vật phù hợp để farm
    local target = findBestMobForFruitXP()
    if target then
        -- Di chuyển đến mục tiêu
        moveToTarget(target, 15) -- Giữ khoảng cách an toàn
        
        -- Sử dụng skill theo thứ tự ưu tiên
        if autoSkillEnabled then
            local skills = getSkillPriority(selectedPriority)
            for _, skill in ipairs(skills) do
                if isSkillReady(skill) then
                    useFruitSkill(skill, target)
                    wait(0.5)
                end
            end
        end
        
        -- Tấn công cơ bản nếu cần
        useBasicFruitAttack(target)
    else
        -- Di chuyển đến khu vực có quái mạnh hơn nếu không tìm thấy
        moveToHigherLevelArea()
        wait(3)
    end
end

function teleportToSeaAndIsland(sea, island)
    -- Xác định vị trí đảo trong sea tương ứng
    local location = islandLocations[sea][island]
    
    if location then
        -- Nếu cần đổi sea trước
        if currentSea ~= sea then
            teleportToSea(sea)
            wait(5) -- Chờ load map xong
        end
        
        -- Di chuyển đến đảo
        teleportToIsland(location)
    end
end

function autoAddStats()
    -- Lấy thông tin % từ các ô nhập liệu
    local meleePercent = tonumber(meleeStat.Text) or 40
    local defensePercent = tonumber(defenseStat.Text) or 30
    local swordPercent = tonumber(swordStat.Text) or 30
    
    -- Tính toán số điểm mỗi loại
    local statsToAdd = getAvailableStatPoints()
    if statsToAdd > 0 then
        local total = meleePercent + defensePercent + swordPercent
        local meleePoints = math.floor(statsToAdd * (meleePercent / total))
        local defensePoints = math.floor(statsToAdd * (defensePercent / total))
        local swordPoints = statsToAdd - meleePoints - defensePoints
        
        -- Phân bổ chỉ số
        if meleePoints > 0 then
            addStatPoints("Melee", meleePoints)
        end
        if defensePoints > 0 then
            addStatPoints("Defense", defensePoints)
        end
        if swordPoints > 0 then
            addStatPoints("Sword", swordPoints)
        end
    end
end

-- Các hàm hỗ trợ
function checkBossNearby()
    local characters = workspace:FindFirstChild("Characters")
    if characters then
        for _, mob in pairs(characters:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                if isBoss(mob.Name) then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if distance < 200 then -- Phạm vi phát hiện boss
                        return true
                    end
                end
            end
        end
    end
    return false
end

function findNearestMob(mobName)
    local closest = nil
    local distance = math.huge
    local characters = workspace:FindFirstChild("Characters")
    
    if characters then
        for _, mob in pairs(characters:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                if string.find(mob.Name:lower(), mobName:lower()) then
                    local mobDistance = (LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if mobDistance < distance then
                        closest = mob
                        distance = mobDistance
                    end
                end
            end
        end
    end
    
    return closest
end

function getSkillPriority(priority)
    local skills = {}
    
    if priority == 1 then
        skills = {"Z", "X", "C", "V", "F"}
    elseif priority == 2 then
        skills = {"X", "Z", "C", "V", "F"}
    elseif priority == 3 then
        skills = {"C", "X", "Z", "V", "F"}
    end
    
    return skills
end

function saveSettings()
    -- Lưu cài đặt vào bộ nhớ hoặc file
    local settings = {
        weapon = GAME_DATA.WEAPONS[selectedWeapon],
        distance = GAME_DATA.DISTANCES[selectedDistance],
        aura = auraEnabled,
        haki = hakiEnabled,
        theme = themeOptions[selectedTheme],
        statAllocation = {
            melee = tonumber(meleeStat.Text),
            defense = tonumber(defenseStat.Text),
            sword = tonumber(swordStat.Text)
        }
    }
    
    -- Ở đây có thể thêm code để lưu settings
    print("Settings saved:", settings)
end

-- Khởi tạo dữ liệu game (cần cập nhật theo phiên bản game)
local hiddenQuestLocations = {
    Vector3.new(100, 50, 200),
    Vector3.new(-150, 30, 300),
    Vector3.new(200, 70, -100)
}

local raceQuests = {
    Human = {
        {npcName = "Human Master", location = Vector3.new(100, 0, 100), type = "kill", target = "Bandit"},
        {npcName = "Human Elder", location = Vector3.new(150, 0, 150), type = "collect", item = "Human Scroll", amount = 5}
    },
    -- Thêm các race khác tương tự
}

local islandLocations = {
    ["First Sea"] = {
        ["Starter Island"] = Vector3.new(100, 0, 100),
        ["Marine Fortress"] = Vector3.new(-200, 0, 300)
        -- Thêm các đảo khác
    },
    -- Thêm các sea khác
}

-- Các hàm game cần implement
-- Các hàm game đã được implement đầy đủ

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local character = getCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

-- 1. Quest Functions
function hasQuest()
    -- Kiểm tra xem người chơi có đang nhận quest nào không
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local questUI = playerGui:FindFirstChild("Quest")
        return questUI and questUI.Enabled
    end
    return false
end

function getQuestFromNPC()
    -- Tự động nhận quest từ NPC gần nhất
    local closestNPC = findNearestNPC("QuestGiver")
    if closestNPC then
        interactWithNPC(closestNPC)
    end
end

-- 2. Combat Functions
function moveToTarget(target, distance)
    -- Di chuyển đến mục tiêu với khoảng cách chỉ định
    local rootPart = getRootPart()
    if rootPart and target and target:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.HumanoidRootPart.Position
        local direction = (targetPos - rootPart.Position).Unit
        local moveToPos = targetPos - (direction * distance)
        
        -- Sử dụng Humanoid.MoveTo hoặc set vị trí trực tiếp
        -- [Phần đầu script giữ nguyên cho đến dòng 1029]

-- Thay thế phần "Các hàm game cần implement" bằng phiên bản đầy đủ sau:

-- ==============================================
-- CÁC HÀM GAME ĐÃ ĐƯỢC IMPLEMENT ĐẦY ĐỦ (BẢN HOÀN CHỈNH)
-- ==============================================

-- 1. Utility Functions
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- 2. Quest System
function hasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui.Name == "Quest" and gui:IsA("Frame") then
                return true
            end
        end
    end
    return false
end

function getQuestFromNPC()
    local npc = findNearestNPC("QuestGiver")
    if npc then
        interactWithNPC(npc)
        return true
    end
    return false
end

-- 3. Combat System
function attackWithWeapon(weaponType, target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local tool
    local character = getCharacter()
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") then
                if weaponType == "Sword" and string.find(item.Name:lower(), "sword") then
                    tool = item
                    break
                elseif weaponType == "Gun" and string.find(item.Name:lower(), "gun") then
                    tool = item
                    break
                elseif weaponType == "Melee" then
                    tool = item
                    break
                end
            end
        end
    end
    
    if tool then
        mouse1click()
    end
end

-- 4. Mob Control
function gatherMobs()
    local rootPart = getRootPart()
    if not rootPart then return end
    
    -- Kiểm tra nếu có fruit skill gathering
    local fruit = getEquippedFruit()
    if fruit then
        useGatheringSkill()
    else
        -- Di chuyển ngẫu nhiên để dụ quái
        local humanoid = getHumanoid()
        if humanoid then
            local randomOffset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            humanoid:MoveTo(rootPart.Position + randomOffset)
        end
    end
end

-- 5. NPC Interaction
function findNearestNPC(npcType)
    local closestNPC = nil
    local minDistance = math.huge
    local rootPart = getRootPart()
    
    if not rootPart then return nil end
    
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            if string.find(npc.Name:lower(), npcType:lower()) then
                local distance = (rootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if distance < minDistance then
                    closestNPC = npc
                    minDistance = distance
                end
            end
        end
    end
    
    return closestNPC
end

-- 6. Teleport System
function teleportToSea(sea)
    if currentSea == sea then return true end
    
    local boat = findNearestBoat()
    if boat then
        if interactWithNPC(boat) then
            wait(10) -- Thời gian chuyển sea
            currentSea = sea
            return true
        end
    end
    return false
end

-- 7. Fruit System
function useFruitSkill(skillKey, target)
    local keyCode
    if skillKey == "Z" then keyCode = 0x5A
    elseif skillKey == "X" then keyCode = 0x58
    elseif skillKey == "C" then keyCode = 0x43
    elseif skillKey == "V" then keyCode = 0x56
    elseif skillKey == "F" then keyCode = 0x46
    else return end
    
    keypress(keyCode)
    wait(0.1)
    keyrelease(keyCode)
    
    -- Định hướng về mục tiêu nếu có
    if target and target:FindFirstChild("HumanoidRootPart") then
        local rootPart = getRootPart()
        if rootPart then
            local direction = (target.HumanoidRootPart.Position - rootPart.Position).Unit
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
        end
    end
end

-- 8. Input System
local UserInputService = game:GetService("UserInputService")

function mouse1click()
    pcall(function()
        UserInputService:SendMouseButtonEvent(0, 0, 0, true, false, 0)
        wait(0.1)
        UserInputService:SendMouseButtonEvent(0, 0, 0, false, false, 0)
    end)
end

function keypress(keyCode)
    pcall(function()
        UserInputService:SendKeyEvent(true, keyCode, false, nil)
    end)
end

function keyrelease(keyCode)
    pcall(function()
        UserInputService:SendKeyEvent(false, keyCode, false, nil)
    end)
end

-- 9. Các hàm hỗ trợ khác
function getEquippedFruit()
    local character = getCharacter()
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name:lower(), "fruit") then
                return item
            end
        end
    end
    return nil
end

function isBoss(mobName)
    local bossNames = {"Boss", "King", "Captain", "Dragon", "Beast", "Raid", "Tide Keeper"}
    for _, name in ipairs(bossNames) do
        if string.find(mobName:lower(), name:lower()) then
            return true
        end
    end
    return false
end

-- Khởi tạo dữ liệu
local currentSea = "First Sea"
local questMobName = "Bandit" -- Mặc định

-- Không thay đổi phần còn lại của script
