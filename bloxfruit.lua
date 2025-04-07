-- Blox Fruit Automation Script
-- Version 1.0
-- Created by [Your Name]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)

TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TabButtons.Size = UDim2.new(1, 0, 0.1, 0)

UIListLayout.Parent = TabButtons
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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

local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Parent = TabButtons
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Size = UDim2.new(1/#tabs, 0, 1, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    button.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        currentTab = ContentFrame:FindFirstChild(name .. "Content")
        if currentTab then
            currentTab.Visible = true
        end
    end)
    
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
        
        -- Toggle Auto Farm
        local toggleFarm = Instance.new("TextButton")
        toggleFarm.Parent = scroll
        toggleFarm.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleFarm.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleFarm.Text = "Enable Auto Farm"
        toggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleFarm.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local farmEnabled = false
        toggleFarm.MouseButton1Click:Connect(function()
            farmEnabled = not farmEnabled
            toggleFarm.Text = farmEnabled and "Disable Auto Farm" or "Enable Auto Farm"
            toggleFarm.BackgroundColor3 = farmEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
            
            if farmEnabled then
                -- Bắt đầu auto farm
                spawn(function()
                    while farmEnabled do
                        -- Logic auto farm ở đây
                        wait(0.1)
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
        weaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local weaponDropdown = Instance.new("TextButton")
        weaponDropdown.Parent = scroll
        weaponDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        weaponDropdown.Position = UDim2.new(0.05, 0, 0.2, 0)
        weaponDropdown.Text = "Sword ▼"
        weaponDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        weaponDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local weaponOptions = {"Sword", "Melee", "Gun"}
        local selectedWeapon = 1
        
        weaponDropdown.MouseButton1Click:Connect(function()
            selectedWeapon = (selectedWeapon % #weaponOptions) + 1
            weaponDropdown.Text = weaponOptions[selectedWeapon] .. " ▼"
        end)
        
        -- Distance Setting
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Parent = scroll
        distanceLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        distanceLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
        distanceLabel.Text = "Farm Distance:"
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local distanceSlider = Instance.new("TextButton")
        distanceSlider.Parent = scroll
        distanceSlider.Size = UDim2.new(0.9, 0, 0.08, 0)
        distanceSlider.Position = UDim2.new(0.05, 0, 0.38, 0)
        distanceSlider.Text = "10 ▼"
        distanceSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local distanceOptions = {"5", "10", "15", "20"}
        local selectedDistance = 2
        
        distanceSlider.MouseButton1Click:Connect(function()
            selectedDistance = (selectedDistance % #distanceOptions) + 1
            distanceSlider.Text = distanceOptions[selectedDistance] .. " ▼"
        end)
        
        -- Mob Aura Toggle
        local toggleAura = Instance.new("TextButton")
        toggleAura.Parent = scroll
        toggleAura.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleAura.Position = UDim2.new(0.05, 0, 0.5, 0)
        toggleAura.Text = "Enable Mob Aura"
        toggleAura.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleAura.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local auraEnabled = false
        toggleAura.MouseButton1Click:Connect(function()
            auraEnabled = not auraEnabled
            toggleAura.Text = auraEnabled and "Disable Mob Aura" or "Enable Mob Aura"
            toggleAura.BackgroundColor3 = auraEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
        end)
        
        -- Auto Haki Toggle
        local toggleHaki = Instance.new("TextButton")
        toggleHaki.Parent = scroll
        toggleHaki.Size = UDim2.new(0.9, 0, 0.08, 0)
        toggleHaki.Position = UDim2.new(0.05, 0, 0.6, 0)
        toggleHaki.Text = "Enable Auto Haki"
        toggleHaki.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleHaki.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local hakiEnabled = false
        toggleHaki.MouseButton1Click:Connect(function()
            hakiEnabled = not hakiEnabled
            toggleHaki.Text = hakiEnabled and "Disable Auto Haki" or "Enable Auto Haki"
            toggleHaki.BackgroundColor3 = hakiEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
        end)
    
    -- Quest Tab
    elseif tabName == "Quest" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        
        -- Hidden Quest Toggle
        local toggleHiddenQuest = Instance.new("TextButton")
        toggleHiddenQuest.Parent = scroll
        toggleHiddenQuest.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleHiddenQuest.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleHiddenQuest.Text = "Enable Hidden Quest"
        toggleHiddenQuest.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleHiddenQuest.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local hiddenQuestEnabled = false
        toggleHiddenQuest.MouseButton1Click:Connect(function()
            hiddenQuestEnabled = not hiddenQuestEnabled
            toggleHiddenQuest.Text = hiddenQuestEnabled and "Disable Hidden Quest" or "Enable Hidden Quest"
            toggleHiddenQuest.BackgroundColor3 = hiddenQuestEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
            
            if hiddenQuestEnabled then
                spawn(function()
                    while hiddenQuestEnabled do
                        -- Logic tìm và hoàn thành nhiệm vụ ẩn
                        wait(1)
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
        
        -- Weapon Shop
        local weaponShopLabel = Instance.new("TextLabel")
        weaponShopLabel.Parent = scroll
        weaponShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        weaponShopLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        weaponShopLabel.Text = "Weapon Shop:"
        weaponShopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        weaponShopLabel.BackgroundTransparency = 1
        weaponShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        weaponShopLabel.TextSize = 16
        
        -- Giả lập dữ liệu shop
        local weaponShopItems = {
            {"Katana", "50,000"},
            {"Cutlass", "75,000"},
            {"Dual Katana", "120,000"}
        }
        
        for i, item in ipairs(weaponShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 0.1 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = Color3.fromRGB(200, 200, 255)
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Fighting Style Shop
        local styleShopLabel = Instance.new("TextLabel")
        styleShopLabel.Parent = scroll
        styleShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        styleShopLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
        styleShopLabel.Text = "Fighting Style Shop:"
        styleShopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        styleShopLabel.BackgroundTransparency = 1
        styleShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        styleShopLabel.TextSize = 16
        
        local styleShopItems = {
            {"Black Leg", "150,000"},
            {"Electro", "250,000"},
            {"Fishman Karate", "500,000"}
        }
        
        for i, item in ipairs(styleShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 0.48 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = Color3.fromRGB(200, 200, 255)
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Devil Fruit Shop
        local fruitShopLabel = Instance.new("TextLabel")
        fruitShopLabel.Parent = scroll
        fruitShopLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        fruitShopLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
        fruitShopLabel.Text = "Devil Fruit Shop:"
        fruitShopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        fruitShopLabel.BackgroundTransparency = 1
        fruitShopLabel.TextXAlignment = Enum.TextXAlignment.Left
        fruitShopLabel.TextSize = 16
        
        local fruitShopItems = {
            {"Bomb-Bomb Fruit", "1,200,000"},
            {"Spike-Spike Fruit", "1,500,000"},
            {"Flame-Flame Fruit", "2,500,000"}
        }
        
        for i, item in ipairs(fruitShopItems) do
            local itemFrame = Instance.new("TextLabel")
            itemFrame.Parent = scroll
            itemFrame.Size = UDim2.new(0.9, 0, 0.06, 0)
            itemFrame.Position = UDim2.new(0.05, 0, 0.88 + i*0.07, 0)
            itemFrame.Text = item[1] .. " - " .. item[2] .. " Beli"
            itemFrame.TextColor3 = Color3.fromRGB(200, 200, 255)
            itemFrame.BackgroundTransparency = 1
            itemFrame.TextXAlignment = Enum.TextXAlignment.Left
        end
    
    -- Race Tab
    elseif tabName == "Race" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        
        local raceLabel = Instance.new("TextLabel")
        raceLabel.Parent = scroll
        raceLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
        raceLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        raceLabel.Text = "Select Race to Upgrade:"
        raceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        raceLabel.BackgroundTransparency = 1
        raceLabel.TextSize = 16
        
        local races = {"Human", "Skypiean", "Fishman", "Mink", "Cyborg"}
        
        for i, race in ipairs(races) do
            local raceButton = Instance.new("TextButton")
            raceButton.Parent = scroll
            raceButton.Size = UDim2.new(0.9, 0, 0.12, 0)
            raceButton.Position = UDim2.new(0.05, 0, 0.15 + (i-1)*0.15, 0)
            raceButton.Text = race
            raceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            raceButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            
            raceButton.MouseButton1Click:Connect(function()
                -- Logic up race
                spawn(function()
                    -- Tự động làm nhiệm vụ để up race
                end)
            end)
        end
    
    -- Up Fruit Tab
    elseif tabName == "Up Fruit" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
        
        -- Toggle Fruit Farm
        local toggleFruitFarm = Instance.new("TextButton")
        toggleFruitFarm.Parent = scroll
        toggleFruitFarm.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggleFruitFarm.Position = UDim2.new(0.05, 0, 0.02, 0)
        toggleFruitFarm.Text = "Enable Fruit Farm"
        toggleFruitFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleFruitFarm.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local fruitFarmEnabled = false
        toggleFruitFarm.MouseButton1Click:Connect(function()
            fruitFarmEnabled = not fruitFarmEnabled
            toggleFruitFarm.Text = fruitFarmEnabled and "Disable Fruit Farm" or "Enable Fruit Farm"
            toggleFruitFarm.BackgroundColor3 = fruitFarmEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
            
            if fruitFarmEnabled then
                spawn(function()
                    while fruitFarmEnabled do
                        -- Logic auto farm fruit
                        wait(0.1)
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
        toggleAutoSkill.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleAutoSkill.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local autoSkillEnabled = false
        toggleAutoSkill.MouseButton1Click:Connect(function()
            autoSkillEnabled = not autoSkillEnabled
            toggleAutoSkill.Text = autoSkillEnabled and "Disable Auto Skills" or "Enable Auto Skills"
            toggleAutoSkill.BackgroundColor3 = autoSkillEnabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 70)
        end)
        
        -- Skill Priority
        local skillPriorityLabel = Instance.new("TextLabel")
        skillPriorityLabel.Parent = scroll
        skillPriorityLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        skillPriorityLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
        skillPriorityLabel.Text = "Skill Priority:"
        skillPriorityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        skillPriorityLabel.BackgroundTransparency = 1
        skillPriorityLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local skillPriorityDropdown = Instance.new("TextButton")
        skillPriorityDropdown.Parent = scroll
        skillPriorityDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        skillPriorityDropdown.Position = UDim2.new(0.05, 0, 0.38, 0)
        skillPriorityDropdown.Text = "Z > X > C > V ▼"
        skillPriorityDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        skillPriorityDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local skillPriorityOptions = {"Z > X > C > V", "X > Z > C > V", "C > X > Z > V"}
        local selectedPriority = 1
        
        skillPriorityDropdown.MouseButton1Click:Connect(function()
            selectedPriority = (selectedPriority % #skillPriorityOptions) + 1
            skillPriorityDropdown.Text = skillPriorityOptions[selectedPriority] .. " ▼"
        end)
    
    -- Settings Tab
    elseif tabName == "Settings" then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = content
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
        
        -- UI Settings
        local uiSettingsLabel = Instance.new("TextLabel")
        uiSettingsLabel.Parent = scroll
        uiSettingsLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        uiSettingsLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
        uiSettingsLabel.Text = "UI Settings:"
        uiSettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        uiSettingsLabel.BackgroundTransparency = 1
        uiSettingsLabel.TextSize = 16
        
        -- UI Theme
        local themeLabel = Instance.new("TextLabel")
        themeLabel.Parent = scroll
        themeLabel.Size = UDim2.new(0.9, 0, 0.05, 0)
        themeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        themeLabel.Text = "UI Theme:"
        themeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeLabel.BackgroundTransparency = 1
        themeLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local themeDropdown = Instance.new("TextButton")
        themeDropdown.Parent = scroll
        themeDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        themeDropdown.Position = UDim2.new(0.05, 0, 0.17, 0)
        themeDropdown.Text = "Dark ▼"
        themeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local themeOptions = {"Dark", "Light", "Blue", "Red"}
        local selectedTheme = 1
        
        themeDropdown.MouseButton1Click:Connect(function()
            selectedTheme = (selectedTheme % #themeOptions) + 1
            themeDropdown.Text = themeOptions[selectedTheme] .. " ▼"
            
            -- Thay đổi theme UI
            local themes = {
                Dark = Color3.fromRGB(30, 30, 40),
                Light = Color3.fromRGB(240, 240, 240),
                Blue = Color3.fromRGB(30, 60, 90),
                Red = Color3.fromRGB(90, 30, 30)
            }
            
            MainFrame.BackgroundColor3 = themes[themeOptions[selectedTheme]]
        end)
        
        -- Save Settings
        local saveButton = Instance.new("TextButton")
        saveButton.Parent = scroll
        saveButton.Size = UDim2.new(0.9, 0, 0.1, 0)
        saveButton.Position = UDim2.new(0.05, 0, 0.3, 0)
        saveButton.Text = "Save Settings"
        saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        
        saveButton.MouseButton1Click:Connect(function()
            -- Lưu cài đặt
        end)
        
        -- Teleport Settings
        local teleportLabel = Instance.new("TextLabel")
        teleportLabel.Parent = scroll
        teleportLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        teleportLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
        teleportLabel.Text = "Teleport:"
        teleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportLabel.BackgroundTransparency = 1
        teleportLabel.TextSize = 16
        
        -- Sea Selection
        local seaDropdown = Instance.new("TextButton")
        seaDropdown.Parent = scroll
        seaDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        seaDropdown.Position = UDim2.new(0.05, 0, 0.53, 0)
        seaDropdown.Text = "First Sea ▼"
        seaDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        seaDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local seaOptions = {"First Sea", "Second Sea", "Third Sea"}
        local selectedSea = 1
        
        seaDropdown.MouseButton1Click:Connect(function()
            selectedSea = (selectedSea % #seaOptions) + 1
            seaDropdown.Text = seaOptions[selectedSea] .. " ▼"
        end)
        
        -- Island Selection
        local islandDropdown = Instance.new("TextButton")
        islandDropdown.Parent = scroll
        islandDropdown.Size = UDim2.new(0.9, 0, 0.08, 0)
        islandDropdown.Position = UDim2.new(0.05, 0, 0.65, 0)
        islandDropdown.Text = "Select Island ▼"
        islandDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        islandDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        local islandOptions = {"Starter Island", "Marine Fortress", "Sky Island"}
        local selectedIsland = 1
        
        islandDropdown.MouseButton1Click:Connect(function()
            selectedIsland = (selectedIsland % #islandOptions) + 1
            islandDropdown.Text = islandOptions[selectedIsland] .. " ▼"
        end)
        
        -- Teleport Button
        local teleportButton = Instance.new("TextButton")
        teleportButton.Parent = scroll
        teleportButton.Size = UDim2.new(0.9, 0, 0.1, 0)
        teleportButton.Position = UDim2.new(0.05, 0, 0.77, 0)
        teleportButton.Text = "Teleport"
        teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        
        teleportButton.MouseButton1Click:Connect(function()
            -- Logic teleport
        end)
        
        -- Stat Allocation
        local statLabel = Instance.new("TextLabel")
        statLabel.Parent = scroll
        statLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
        statLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
        statLabel.Text = "Auto Stat Allocation:"
        statLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        statLabel.BackgroundTransparency = 1
        statLabel.TextSize = 16
        
        local meleeStat = Instance.new("TextBox")
        meleeStat.Parent = scroll
        meleeStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        meleeStat.Position = UDim2.new(0.05, 0, 0.98, 0)
        meleeStat.Text = "Melee"
        meleeStat.PlaceholderText = "Melee %"
        meleeStat.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        meleeStat.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local defenseStat = Instance.new("TextBox")
        defenseStat.Parent = scroll
        defenseStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        defenseStat.Position = UDim2.new(0.36, 0, 0.98, 0)
        defenseStat.Text = "Defense"
        defenseStat.PlaceholderText = "Defense %"
        defenseStat.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        defenseStat.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local swordStat = Instance.new("TextBox")
        swordStat.Parent = scroll
        swordStat.Size = UDim2.new(0.28, 0, 0.08, 0)
        swordStat.Position = UDim2.new(0.67, 0, 0.98, 0)
        swordStat.Text = "Sword"
        swordStat.PlaceholderText = "Sword %"
        swordStat.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        swordStat.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Mở tab đầu tiên khi khởi động
currentTab = ContentFrame:FindFirstChild("Auto FarmContent")
if currentTab then
    currentTab.Visible = true
end

-- Tạo nút đóng/mở UI
local toggleUI = Instance.new("TextButton")
toggleUI.Name = "ToggleUI"
toggleUI.Parent = ScreenGui
toggleUI.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggleUI.Position = UDim2.new(0, 0, 0.5, 0)
toggleUI.Size = UDim2.new(0.05, 0, 0.1, 0)
toggleUI.Text = "Open"
toggleUI.TextColor3 = Color3.fromRGB(255, 255, 255)

local uiVisible = true
toggleUI.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
    toggleUI.Text = uiVisible and "Close" or "Open"
end)
