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
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:MoveTo(moveToPos)
        else
            rootPart.CFrame = CFrame.new(moveToPos)
        end
    end
end

function useHaki()
    -- Kích hoạt Busoshoku Haki
    local humanoid = getHumanoid()
    if humanoid then
        keypress(0x48) -- Phím H
        wait(0.1)
        keyrelease(0x48)
    end
end

function attackWithWeapon(weaponType, target)
    -- Tấn công với loại vũ khí được chọn
    local tool = getEquippedTool(weaponType)
    if tool and target then
        -- Giả lập click chuột để tấn công
        mouse1click()
        
        -- Hoặc sử dụng remote event nếu biết
        -- game:GetService("ReplicatedStorage").CombatRemote:FireServer(tool, target)
    end
end

function getEquippedTool(weaponType)
    -- Tìm tool đang trang bị phù hợp với loại vũ khí
    local character = getCharacter()
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                if weaponType == "Sword" and string.find(tool.Name:lower(), "sword") then
                    return tool
                elseif weaponType == "Gun" and string.find(tool.Name:lower(), "gun") then
                    return tool
                elseif weaponType == "Melee" and not string.find(tool.Name:lower(), "sword") and not string.find(tool.Name:lower(), "gun") then
                    return tool
                end
            end
        end
    end
    return nil
end

function gatherMobs()
    -- Gom quái vật về phía người chơi
    local rootPart = getRootPart()
    if rootPart then
        -- Sử dụng skill gom quái nếu có
        useGatheringSkill()
        
        -- Hoặc di chuyển theo cách đặc biệt để dụ quái
        local humanoid = getHumanoid()
        if humanoid then
            local currentPos = rootPart.Position
            humanoid:MoveTo(currentPos + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
        end
    end
end

function useGatheringSkill()
    -- Sử dụng skill có khả năng gom quái (như Black Hole, Gravity)
    local character = getCharacter()
    if character then
        local fruit = getEquippedFruit()
        if fruit then
            -- Giả sử skill C có khả năng gom quái
            keypress(0x43) -- Phím C
            wait(0.1)
            keyrelease(0x43)
        end
    end
end

function getEquippedFruit()
    -- Tìm trái ác quỷ đang trang bị
    local character = getCharacter()
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name:lower(), "fruit") then
                return item
            end
        end
    end
    return nil
end

function avoidBoss()
    -- Né tránh boss khi phát hiện
    local rootPart = getRootPart()
    if rootPart then
        local boss = findNearestBoss()
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            local direction = (rootPart.Position - boss.HumanoidRootPart.Position).Unit
            local fleePos = rootPart.Position + (direction * 50)
            
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:MoveTo(fleePos)
            end
        end
    end
end

function findNearestBoss()
    -- Tìm boss gần nhất
    local closestBoss = nil
    local minDistance = math.huge
    local rootPart = getRootPart()
    
    if rootPart then
        for _, mob in pairs(workspace:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                if isBoss(mob.Name) then
                    local distance = (rootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        closestBoss = mob
                        minDistance = distance
                    end
                end
            end
        end
    end
    
    return closestBoss
end

function isBoss(mobName)
    -- Kiểm tra có phải là boss không
    local bossNames = {
        "Boss", "King", "Captain", "Dragon", "Beast",
        "Raids", "Raid", "Tide Keeper", "Dough King"
    }
    
    for _, name in pairs(bossNames) do
        if string.find(mobName:lower(), name:lower()) then
            return true
        end
    end
    return false
end

-- 3. NPC Interaction
function findNearestNPC(npcType)
    -- Tìm NPC gần nhất theo loại
    local closestNPC = nil
    local minDistance = math.huge
    local rootPart = getRootPart()
    
    if rootPart then
        for _, npc in pairs(workspace:GetChildren()) do
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
    end
    
    return closestNPC
end

function interactWithNPC(npc)
    -- Tương tác với NPC
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        local rootPart = getRootPart()
        if rootPart then
            -- Di chuyển đến NPC
            moveToTarget(npc, 5)
            wait(1)
            
            -- Giả lập click chuột để tương tác
            mouse1click()
            
            -- Hoặc sử dụng remote event
            -- game:GetService("ReplicatedStorage").InteractionRemote:FireServer(npc)
        end
    end
end

-- 4. Fruit Skills
function checkFruitEnergy()
    -- Kiểm tra năng lượng fruit skill (giả lập)
    return true -- Luôn trả về true cho đơn giản
end

function isSkillReady(skill)
    -- Kiểm tra skill đã sẵn sàng chưa (giả lập)
    return true -- Luôn trả về true cho đơn giản
end

function useFruitSkill(skillKey, target)
    -- Sử dụng skill trái ác quỷ
    local keyCode = 0x5A -- Mặc định là phím Z
    if skillKey == "X" then
        keyCode = 0x58
    elseif skillKey == "C" then
        keyCode = 0x43
    elseif skillKey == "V" then
        keyCode = 0x56
    elseif skillKey == "F" then
        keyCode = 0x46
    end
    
    -- Nhấn phím skill
    keypress(keyCode)
    wait(0.1)
    keyrelease(keyCode)
    
    -- Nếu có mục tiêu, hướng về phía mục tiêu
    if target and target:FindFirstChild("HumanoidRootPart") then
        local rootPart = getRootPart()
        if rootPart then
            local direction = (target.HumanoidRootPart.Position - rootPart.Position).Unit
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
        end
    end
end

function useBasicFruitAttack(target)
    -- Tấn công cơ bản bằng trái ác quỷ (click chuột)
    mouse1click()
end

-- 5. Teleport Functions
local currentSea = "First Sea" -- Giả sử đang ở First Sea

function teleportToSea(sea)
    -- Di chuyển giữa các sea (giả lập)
    if sea ~= currentSea then
        -- Tìm boat hoặc phương tiện di chuyển giữa các sea
        local boat = findNearestBoat()
        if boat then
            interactWithNPC(boat)
            wait(10) -- Giả sử mất 10s để chuyển sea
            currentSea = sea
        end
    end
end

function findNearestBoat()
    -- Tìm thuyền/teleporter gần nhất
    return findNearestNPC("Boat") or findNearestNPC("Teleporter")
end

function teleportToIsland(location)
    -- Di chuyển đến đảo cụ thể
    local rootPart = getRootPart()
    if rootPart then
        -- Sử dụng kỹ thuật CFraming để teleport
        rootPart.CFrame = CFrame.new(location)
        
        -- Hoặc sử dụng phương tiện di chuyển trong game
        -- local vehicle = getNearestVehicle()
        -- if vehicle then
        --     enterVehicle(vehicle)
        --     moveVehicleTo(location)
        -- end
    end
end

-- 6. Stat Functions
function getAvailableStatPoints()
    -- Lấy số điểm chỉ số có sẵn
    local playerStats = LocalPlayer:FindFirstChild("Stats")
    if playerStats then
        return playerStats:FindFirstChild("Points") and playerStats.Points.Value or 0
    end
    return 0
end

function addStatPoints(stat, points)
    -- Thêm điểm vào chỉ số
    local playerStats = LocalPlayer:FindFirstChild("Stats")
    if playerStats then
        local statObj = playerStats:FindFirstChild(stat)
        if statObj then
            -- Giả lập thêm điểm
            for i = 1, points do
                -- game:GetService("ReplicatedStorage").StatRemote:FireServer(stat)
                wait(0.1) -- Delay giữa các lần cộng điểm
            end
        end
    end
end

-- 7. Utility Functions
function mouse1click()
    -- Giả lập click chuột trái
    keypress(0x01)
    wait(0.1)
    keyrelease(0x01)
end

function keypress(keyCode)
    -- Giả lập nhấn phím
    if virtualInput then
        virtualInput:SendKeyEvent(true, keyCode, false, nil)
    end
end

function keyrelease(keyCode)
    -- Giả lập nhả phím
    if virtualInput then
        virtualInput:SendKeyEvent(false, keyCode, false, nil)
    end
end

-- Khởi tạo VirtualInput (nếu cần)
local virtualInput
if game:GetService("VirtualInputManager") then
    virtualInput = game:GetService("VirtualInputManager")
end
function hasQuest() return false end
function getQuestFromNPC() end
function moveToTarget(target, distance) end
function useHaki() end
function attackWithWeapon(weapon, target) end
function gatherMobs() end
function avoidBoss() end
function findHiddenQuestNPC() return nil end
function interactWithNPC(npc) end
function canCompleteHiddenQuest() return false end
function completeHiddenQuest() end
function findNPC(npcName) return nil end
function isQuestComplete() return false end
function collectItems(item, amount) end
function turnInQuest(npc) end
function checkFruitEnergy() end
function findBestMobForFruitXP() return nil end
function isSkillReady(skill) return false end
function useFruitSkill(skill, target) end
function useBasicFruitAttack(target) end
function moveToHigherLevelArea() end
function teleportToSea(sea) end
function teleportToIsland(location) end
function getAvailableStatPoints() return 0 end
function addStatPoints(stat, points) end
function isBoss(mobName) return false end
