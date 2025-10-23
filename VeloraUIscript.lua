-- Load Velora UI Library
local Velora = loadstring(game:HttpGet("https://pastebin.com/raw/irW3ga5a"))()
-- Create the main window
local Window = Velora:CreateWindow("Velora")
-- =========================
-- Create Tabs
-- =========================
local reanimTab = Window:CreateTab("Reanimation", "http://www.roblox.com/asset/?id=6022668887") -- Reanim icon
local movementTab = Window:CreateTab("Movement", "http://www.roblox.com/asset/?id=6022668906") -- Movement icon
local tpTab = Window:CreateTab("Teleport", "http://www.roblox.com/asset/?id=6031154875")     -- Teleport icon
local VisualsTab = Window:CreateTab("Visuals", "http://www.roblox.com/asset/?id=6031075931")     -- Visuals icon
local WorldTab = Window:CreateTab("World", "http://www.roblox.com/asset/?id=6034287522")     -- World icon

-- =============================
-- Settings Tab (icon only, centered, integrated)
-- =============================

local sidebar = Window.Sidebar
local TweenService = game:GetService("TweenService")
local clickSound = Window.ClickSound -- reuse main window click sound

-- Create the Settings button
local settingsBtn = Instance.new("ImageButton")
settingsBtn.Name = "SettingsTab"
settingsBtn.Size = UDim2.new(0, 47, 0, 47)
settingsBtn.Position = UDim2.new(0, 6, 1, -53) -- bottom-center slot
settingsBtn.AnchorPoint = Vector2.new(0, 0)
settingsBtn.BackgroundTransparency = 1 -- no background
settingsBtn.AutoButtonColor = false
settingsBtn.Parent = sidebar

-- Icon
local iconLabel = Instance.new("ImageLabel")
iconLabel.Parent = settingsBtn
iconLabel.Size = UDim2.new(0, 28, 0, 28)
iconLabel.Position = UDim2.fromScale(0.5, 0.5)
iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
iconLabel.BackgroundTransparency = 1
iconLabel.Image = "http://www.roblox.com/asset/?id=6031280882"
iconLabel.ImageColor3 = Color3.fromRGB(180,180,180)
iconLabel.ScaleType = Enum.ScaleType.Fit

-- Hover text
local function createHoverText(text)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.AnchorPoint = Vector2.new(0,0.5)
    frame.Visible = false
    frame.ZIndex = 999
    frame.Parent = Window.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(225,225,225)
    label.Size = UDim2.new(1,-6,1,-6)
    label.Position = UDim2.new(0,3,0,3)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    local textSize = label.TextBounds
    frame.Size = UDim2.new(0,textSize.X+6,0,textSize.Y+6)
    return frame
end

local hover = createHoverText("Settings")
settingsBtn.MouseEnter:Connect(function()
    local absPos = settingsBtn.AbsolutePosition
    local absSize = settingsBtn.AbsoluteSize
    hover.Position = UDim2.new(0, absPos.X + absSize.X + 5, 0, absPos.Y + absSize.Y/2)
    hover.Visible = true
end)
settingsBtn.MouseLeave:Connect(function()
    hover.Visible = false
end)

-- Create the Settings page
local settingsPage = Window:CreatePage("Settings")

-- Example content
Window:CreateTextLabel(settingsPage, "UI Settings", 1)
Window:CreateToggle(settingsPage, "StatusBar", function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Check if GUI already exists
    local ScreenGui = playerGui:FindFirstChild("EliteInfoBar")

    -- If toggle is turned ON
    if state then
        -- Create GUI only if it doesn’t exist
        if not ScreenGui then
            ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "EliteInfoBar"
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.Parent = playerGui

            -- Create Main Frame
            local Frame = Instance.new("Frame")
            Frame.Name = "InfoBar"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.new(0.5, 0, 0.965, 0)
            Frame.Size = UDim2.new(0, 540, 0, 60)
            Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundTransparency = 1
            Frame.Parent = ScreenGui

            -- Rounded Corners + Stroke
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = Frame

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Thickness = 1.5
            UIStroke.Transparency = 1
            UIStroke.Parent = Frame

            -- Helper: Create text labels
            local function createLabel(name, text, anchor, position, size, textSize, align)
                local label = Instance.new("TextLabel")
                label.Name = name
                label.Text = text
                label.Font = Enum.Font.GothamBold
                label.TextColor3 = Color3.fromRGB(180, 180, 180)
                label.TextTransparency = 1
                label.BackgroundTransparency = 1
                label.BorderSizePixel = 0
                label.AnchorPoint = anchor
                label.Position = position
                label.Size = size
                label.TextSize = textSize
                label.TextXAlignment = align or Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center
                label.Parent = Frame
                return label
            end

            -- Left Side
            local Username = createLabel("Username", "Username", Vector2.new(0, 0.5), UDim2.new(0.04, 0, 0.35, 0), UDim2.new(0, 180, 0, 25), 14)
            local PlayerCount = createLabel("PlayerCount", "Player Count", Vector2.new(0, 0.5), UDim2.new(0.04, 0, 0.7, 0), UDim2.new(0, 180, 0, 25), 12)

            -- Middle
            local MadeBy = createLabel("MadeBy", "Made by Elite", Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 200, 0, 30), 20, Enum.TextXAlignment.Center)

            -- Right Side
            local TimeLabel = createLabel("Time", "Time", Vector2.new(1, 0.5), UDim2.new(0.96, 0, 0.35, 0), UDim2.new(0, 180, 0, 25), 14, Enum.TextXAlignment.Right)
            local DayAndDate = createLabel("DayAndDate", "Day, Date", Vector2.new(1, 0.5), UDim2.new(0.96, 0, 0.7, 0), UDim2.new(0, 180, 0, 25), 12, Enum.TextXAlignment.Right)

            -- Logic Section
            Username.Text = player.Name

            local function updatePlayerCount()
                local current = #Players:GetPlayers()
                local maxPlayers = Players.MaxPlayers
                PlayerCount.Text = string.format("%d/%d Players", current, maxPlayers)
            end
            updatePlayerCount()
            Players.PlayerAdded:Connect(updatePlayerCount)
            Players.PlayerRemoving:Connect(updatePlayerCount)

            local function updateTime()
                local now = os.date("*t")
                local hour = now.hour
                local ampm = "AM"
                if hour >= 12 then
                    ampm = "PM"
                    if hour > 12 then
                        hour = hour - 12
                    end
                elseif hour == 0 then
                    hour = 12
                end
                local minute = string.format("%02d", now.min)
                local timeText = string.format("%d:%s %s", hour, minute, ampm)
                local dayName = os.date("%A")
                local dateText = os.date("%B %d")

                TimeLabel.Text = timeText
                DayAndDate.Text = string.format("%s, %s", dayName, dateText)
            end

            updateTime()
            RunService.Heartbeat:Connect(updateTime)

            -- Fade In Animation
            local TweenInfoFade = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(Frame, TweenInfoFade, {BackgroundTransparency = 0}):Play()
            TweenService:Create(UIStroke, TweenInfoFade, {Transparency = 0.5}):Play()
            for _, obj in ipairs(Frame:GetChildren()) do
                if obj:IsA("TextLabel") then
                    TweenService:Create(obj, TweenInfoFade, {TextTransparency = 0}):Play()
                end
            end
        else
            -- If already exists, just fade it back in
            local Frame = ScreenGui:FindFirstChild("InfoBar")
            local UIStroke = Frame:FindFirstChildOfClass("UIStroke")
            local TweenInfoFade = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            TweenService:Create(Frame, TweenInfoFade, {BackgroundTransparency = 0}):Play()
            TweenService:Create(UIStroke, TweenInfoFade, {Transparency = 0.5}):Play()
            for _, obj in ipairs(Frame:GetChildren()) do
                if obj:IsA("TextLabel") then
                    TweenService:Create(obj, TweenInfoFade, {TextTransparency = 0}):Play()
                end
            end
        end

    else
        -- If toggle is turned OFF, fade out then destroy GUI
        if ScreenGui then
            local Frame = ScreenGui:FindFirstChild("InfoBar")
            local UIStroke = Frame and Frame:FindFirstChildOfClass("UIStroke")
            local TweenInfoFade = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            -- Fade out
            TweenService:Create(Frame, TweenInfoFade, {BackgroundTransparency = 1}):Play()
            if UIStroke then TweenService:Create(UIStroke, TweenInfoFade, {Transparency = 1}):Play() end
            for _, obj in ipairs(Frame:GetChildren()) do
                if obj:IsA("TextLabel") then
                    TweenService:Create(obj, TweenInfoFade, {TextTransparency = 1}):Play()
                end
            end

            -- Wait for animation, then remove GUI
            task.delay(1, function()
                if ScreenGui then
                    ScreenGui:Destroy()
                end
            end)
        end
    end
end, 2)

Window:CreateTextLabel(settingsPage, "Exrtra's", 3)
Window:CreateButton(settingsPage, "infiniteyield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end, 4)
Window:CreateButton(settingsPage, "all emotes", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
end, 5)


-- Click behavior
settingsBtn.MouseButton1Click:Connect(function()
    -- Deselect all other tabs visually
    for _, t in pairs(Window.Tabs) do
        TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
        TweenService:Create(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180,180,180)}):Play()
    end

    -- Highlight settings icon
    TweenService:Create(iconLabel, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255,255,255)}):Play()

    -- Play click sound
    clickSound:Play()

    -- Show settings page
    Window:SelectTab("Settings")
end)

-- =========================
-- Create Pages
-- =========================
local reanimPage = Window:CreatePage("Reanimation")
local movementPage = Window:CreatePage("Movement")
local tpPage = Window:CreatePage("Teleport")
local VisualsPage = Window:CreatePage("Visuals")
local WorldPage = Window:CreatePage("World")

-- Auto-select the first tab
Window:AutoSelectFirst()

-- =========================
-- Populate reanim Page
-- =========================
Window:CreateTextLabel("Reanimation", "Reanimation")

Window:CreateToggle("Reanimation", "Reanimation", function(state)
end)

Window:CreateLabel("Reanimation", "does not work yet..")
Window:CreateDropdown("Reanimation", "Choose Option", {"Option 1", "Option 2", "Option 3"}, function(selected)
    print("Selected option:", selected)
end)
Window:CreateTextLabel("Reanimation", "Animations")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Store original animations
local function getDefaultAnimations()
    local char = player.Character or player.CharacterAdded:Wait()
    local animate = char:WaitForChild("Animate")
    
    return {
        idle1 = animate.idle.Animation1.AnimationId,
        idle2 = animate.idle.Animation2.AnimationId,
        walk = animate.walk.WalkAnim.AnimationId,
        run = animate.run.RunAnim.AnimationId,
        jump = animate.jump.JumpAnim.AnimationId,
        climb = animate.climb.ClimbAnim.AnimationId,
        fall = animate.fall.FallAnim.AnimationId
    }
end

local defaultAnimations = getDefaultAnimations()

-- Helper to apply animation pack glitch-free
local function applyAnimations(char, anims)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    -- Destroy and clone Animate script to force refresh
    local clonedAnimate = animate:Clone()
    animate:Destroy()
    clonedAnimate.Parent = char

    -- Set animation IDs
    local function setAnim(folder, name, id)
        local anim = folder:FindFirstChild(name)
        if anim then
            anim.AnimationId = id
        end
    end

    setAnim(clonedAnimate.idle, "Animation1", anims.idle1)
    setAnim(clonedAnimate.idle, "Animation2", anims.idle2)
    setAnim(clonedAnimate.walk, "WalkAnim", anims.walk)
    setAnim(clonedAnimate.run, "RunAnim", anims.run)
    setAnim(clonedAnimate.jump, "JumpAnim", anims.jump)
    setAnim(clonedAnimate.climb, "ClimbAnim", anims.climb)
    setAnim(clonedAnimate.fall, "FallAnim", anims.fall)

    -- Force humanoid to jump to fully rebind
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Jump = true
    end
end

-- Animation packs
local animationPacks = {
    ["Default"] = defaultAnimations,
    ["Elder"] = {
        idle1 = "rbxassetid://845397899",
        idle2 = "rbxassetid://845400520",
        walk = "rbxassetid://845403856",
        run = "rbxassetid://845386501",
        jump = "rbxassetid://845398858",
        climb = "rbxassetid://845392038",
        fall = "rbxassetid://845396048"
    },
    ["Werewolf"] = {
        idle1 = "rbxassetid://1083195517",
        idle2 = "rbxassetid://1083214717",
        walk = "rbxassetid://1083178339",
        run = "rbxassetid://1083216690",
        jump = "rbxassetid://1083218792",
        climb = "rbxassetid://1083182000",
        fall = "rbxassetid://1083189019"
    },
    ["Zombie"] = {
        idle1 = "rbxassetid://10921344533",
        idle2 = "rbxassetid://10921345304",
        walk = "rbxassetid://10921355261",
        run = "rbxassetid://616163682",
        jump = "rbxassetid://10921351278",
        climb = "rbxassetid://10921343576",
        fall = "rbxassetid://10921350320"
    },
    ["Adidas Sports"] = {
        idle1 = "rbxassetid://1083195517",
        idle2 = "rbxassetid://1083214717",
        walk = "rbxassetid://1083178339",
        run = "rbxassetid://1083216690",
        jump = "rbxassetid://1083218792",
        climb = "rbxassetid://1083182000",
        fall = "rbxassetid://1083189019"
    },
    ["Vampire"] = {
        idle1 = "rbxassetid://10921315373",
        idle2 = "rbxassetid://10921316709",
        walk = "rbxassetid://10921326949",
        run = "rbxassetid://10921320299",
        jump = "rbxassetid://10921322186",
        climb = "rbxassetid://10921314188",
        fall = "rbxassetid://10921321317"
    },
    ["Udzal"] = {
        idle1 = "rbxassetid://3303162274",
        idle2 = "rbxassetid://3303162549",
        walk = "rbxassetid://3303162967",
        run = "rbxassetid://3236836670",
        jump = "rbxassetid://10921263860",
        climb = "rbxassetid://10921257536",
        fall = "rbxassetid://10921262864"
    }
}

-- Animation packs
local CustomAnimations = {
    ["Zombie FE"] = {
        idle1 = "rbxassetid://18537376492",
        idle2 = "rbxassetid://18537371272",
        walk = "rbxassetid://18537392113",
        run = "rbxassetid://18537384940",
        jump = "rbxassetid://18537380791",
        climb = "rbxassetid://18537363391",
        fall = "rbxassetid://18537367238"
    }
}
-- Dropdown to choose animation pack
Window:CreateDropdown("Reanimation", "Choose Animation Pack", {"Elder", "Werewolf", "Zombie", "Adidas Sports", "Vampire", "Udzal"}, function(selected)
    local char = player.Character or player.CharacterAdded:Wait()
    if animationPacks[selected] then
        applyAnimations(char, animationPacks[selected])
        print("[Elite] Applied animation pack:", selected)
    end
end)

-- Dropdown to choose special animation pack
Window:CreateDropdown("Reanimation", "Choose Custom Animations", {"Zombie FE"}, function(selected)
    local char = player.Character or player.CharacterAdded:Wait()
    if CustomAnimations[selected] then
        applyAnimations(char, CustomAnimations[selected])
        print("[Elite] Applied Custom Animations:", selected)
    end
end)

-- Reset animations button
Window:CreateButton("Reanimation", "Reset Animations", function()
    local char = player.Character or player.CharacterAdded:Wait()
    applyAnimations(char, defaultAnimations)
    print("[Elite] Animations have been reset to default.")
end)

Window:CreateTextLabel("Reanimation", "Customize Character")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 8-Bit Royal Crown Accessory ID
local accessoryId = 10159600649

Window:CreateToggle("Reanimation", "8-Bit Royal Crown", function(state)
    local char = player.Character or player.CharacterAdded:Wait()

    -- Load the accessory
    local newAccessory = game:GetObjects("rbxassetid://" .. accessoryId)[1]
    if not newAccessory or not newAccessory:IsA("Accessory") then
        warn("Invalid accessory ID or not an Accessory")
        return
    end

    if state then
        -- 🟢 Toggle ON → Equip client-only
        -- Remove duplicate if already equipped
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
        end

        newAccessory.Parent = char

        -- Rebuild attachments so it positions correctly
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:BuildRigFromAttachments()
        end

        print("[Elite] Equipped accessory:", newAccessory.Name)
    else
        -- 🔴 Toggle OFF → Remove accessory
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
            print("[Elite] Removed accessory:", newAccessory.Name)
        end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🧩 Addon Accessory IDs
local addons = {
    ["Black 8-Bit Addon"] = 109726297889290,
    ["Pink 8-Bit Addon"] = 15134480105
}

-- store name of currently equipped addon
local equippedAddon = nil

-- Helper function: equip addon
local function equipAddon(addonName)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    -- remove any existing addon first
    if equippedAddon and char:FindFirstChild(equippedAddon) then
        char[equippedAddon]:Destroy()
        equippedAddon = nil
    end

    local accessoryId = addons[addonName]
    if not accessoryId then
        warn("No accessory ID found for:", addonName)
        return
    end

    -- load the new accessory
    local accessory = game:GetObjects("rbxassetid://" .. accessoryId)[1]
    if accessory and accessory:IsA("Accessory") then
        accessory.Parent = char
        equippedAddon = accessory.Name

        -- rebuild attachments to fix positioning
        if humanoid then
            humanoid:BuildRigFromAttachments()
        end

        print("[Elite] Equipped addon:", addonName)
    else
        warn("Failed to load accessory:", addonName)
    end
end

-- Helper function: remove all 8-Bit addons
local function removeAddon()
    local char = player.Character or player.CharacterAdded:Wait()

    for name, id in pairs(addons) do
        local accessory = char:FindFirstChild(name)
        if accessory and accessory:IsA("Accessory") then
            accessory:Destroy()
            print("[Elite] Removed 8-Bit addon:", name)
            -- if it was the tracked one, clear equippedAddon
            if equippedAddon == name then
                equippedAddon = nil
            end
        end
    end
end

-- 🌈 Dropdown: choose addon
Window:CreateDropdown("Reanimation", "Choose Addon", {"Black 8-Bit Addon", "Pink 8-Bit Addon"}, function(selected)
    equipAddon(selected)
end)

-- ❌ Button: remove addon
Window:CreateButton("Reanimation", "Remove Addon", function()
    removeAddon()
end)

Window:CreateTextLabel("Reanimation", "Scale")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for character
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Store default scales
local defaultScales = {
    Height = humanoid:FindFirstChild("BodyHeightScale") and humanoid.BodyHeightScale.Value or 1,
    Width = humanoid:FindFirstChild("BodyWidthScale") and humanoid.BodyWidthScale.Value or 1,
    Depth = humanoid:FindFirstChild("BodyDepthScale") and humanoid.BodyDepthScale.Value or 1
}

-- Ensure body scales exist
local function ensureBodyScales()
    local scales = {
        {"BodyHeightScale", defaultScales.Height},
        {"BodyWidthScale", defaultScales.Width},
        {"BodyDepthScale", defaultScales.Depth}
    }
    for _, data in ipairs(scales) do
        local name, default = unpack(data)
        if not humanoid:FindFirstChild(name) then
            local scale = Instance.new("NumberValue")
            scale.Name = name
            scale.Value = default
            scale.Parent = humanoid
        end
    end
end

ensureBodyScales()

-- Height slider
Window:CreateSlider("Reanimation", "Height", 0.5, 2, defaultScales.Height, function(value)
    humanoid.BodyHeightScale.Value = value
end)

-- Limb distance slider
Window:CreateSlider("Reanimation", "Limb Distance", 0.5, 2, defaultScales.Width, function(value)
    humanoid.BodyWidthScale.Value = value
    humanoid.BodyDepthScale.Value = value
end)

-- Reset button
Window:CreateButton("Reanimation", "Reset Scale", function()
    humanoid.BodyHeightScale.Value = defaultScales.Height
    humanoid.BodyWidthScale.Value = defaultScales.Width
    humanoid.BodyDepthScale.Value = defaultScales.Depth
end)

Window:CreateTextLabel("Reanimation", "Extra hats")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Fiery Horns of the Netherworld Accessory ID
local fieryHornsID = 215718515

Window:CreateToggle("Reanimation", "Fiery Horns of the Netherworld", function(state)
    local char = player.Character or player.CharacterAdded:Wait()

    -- Load the accessory
    local newAccessory = game:GetObjects("rbxassetid://" .. fieryHornsID)[1]
    if not newAccessory or not newAccessory:IsA("Accessory") then
        warn("Invalid accessory ID or not an Accessory")
        return
    end

    if state then
        -- 🟢 Toggle ON → Equip client-only
        -- Remove duplicate if already equipped
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
        end

        newAccessory.Parent = char

        -- Rebuild attachments so it positions correctly
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:BuildRigFromAttachments()
        end

        print("[Elite] Equipped Fiery Horns:", newAccessory.Name)
    else
        -- 🔴 Toggle OFF → Remove accessory
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
            print("[Elite] Removed Fiery Horns:", newAccessory.Name)
        end
    end
end)

local frozenHornsID = 74891470

Window:CreateToggle("Reanimation", "Frozen Horns of the Frigid Planes", function(state)
    local char = player.Character or player.CharacterAdded:Wait()

    -- Load the accessory
    local newAccessory = game:GetObjects("rbxassetid://" .. frozenHornsID)[1]
    if not newAccessory or not newAccessory:IsA("Accessory") then
        warn("Invalid accessory ID or not an Accessory")
        return
    end

    if state then
        -- Equip
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
        end

        newAccessory.Parent = char

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:BuildRigFromAttachments()
        end

        print("[Elite] Equipped Frozen Horns:", newAccessory.Name)
    else
        -- Remove
        local existing = char:FindFirstChild(newAccessory.Name)
        if existing then
            existing:Destroy()
            print("[Elite] Removed Frozen Horns:", newAccessory.Name)
        end
    end
end)

-- =========================
-- Populate Settings Page
-- =========================

Window:CreateTextLabel("Movement", "Character")
-- WalkSpeed slider
Window:CreateSlider("Movement", "WalkSpeed", 4, 100, 16, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)
-- JumpPower slider
Window:CreateSlider("Movement", "JumpPower", 10, 200, 50, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)
-- Gravity slider
Window:CreateSlider("Movement", "Gravity", 0, 500, 196, function(value)
    workspace.Gravity = value
end)

Window:CreateTextLabel("Movement", "Abilities")

-- Anti-AFK Toggle
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local antiAfkEnabled = false
local connection

Window:CreateToggle("Movement", "Anti AFK", function(state)
	antiAfkEnabled = state

	if antiAfkEnabled then
		print("✅ Anti-AFK Enabled")

		-- Listen for idle event
		connection = LocalPlayer.Idled:Connect(function()
			if antiAfkEnabled then
				-- Simulate right click to reset AFK timer
				VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				print("🕹️ Sent anti-AFK input")
			end
		end)
	else
		print("❌ Anti-AFK Disabled")
		-- Disconnect listener to stop simulating input
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end)

-- Infinite Jump Toggle
local infiniteJumpEnabled = false

Window:CreateToggle("Movement", "Infinite Jump", function(state)
    infiniteJumpEnabled = state
end)

-- Use UserInputService to detect jump input
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        if infiniteJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip Toggle
local noclipConnection = nil
local player = game.Players.LocalPlayer

local function setCharacterCollision(enable)
    local char = player.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if enable then
                -- restore only main body parts
                if part.Name == "HumanoidRootPart"
                    or part.Name == "Head"
                    or part.Name:find("Torso")
                    or part.Name:find("Arm")
                    or part.Name:find("Leg") then
                    part.CanCollide = true
                else
                    part.CanCollide = false
                end
            else
                part.CanCollide = false
            end
        end
    end
end

-- Handle character respawn
player.CharacterAdded:Connect(function()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    setCharacterCollision(true)
end)

Window:CreateToggle("Movement", "Noclip", function(state)
    if state then
        -- Enable Noclip
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            setCharacterCollision(false)
        end)
    else
        -- Disable Noclip
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        setCharacterCollision(true)
    end
end)

Window:CreateTextLabel("Movement", "Reverse")

-- Variables for GUI
local flashbackEnabled = false
local flashbackTime = 60
local flashbackKey = Enum.KeyCode.C

-- GUI Elements
Window:CreateToggle("Movement", "Enable Reverse", function(state)
    flashbackEnabled = state
end)

-- Key selector in the middle
Window:CreateKeyButton("Movement", "Reverse Key", "C", function(key)
    flashbackKey = key
    print("Flashback key updated to:", key.Name)
end)

Window:CreateSlider("Movement", "Reverse Time", 1, 120, flashbackTime, function(value)
    flashbackTime = value
end)

-- Flashback Functionality
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local flashbackRecords = {}
local isRewinding = false

local function getCharacter()
    while not Player.Character or not Player.Character.Parent do
        Player.CharacterAdded:Wait()
    end
    return Player.Character
end

local function recordCurrentState(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    table.insert(flashbackRecords, {
        timestamp = tick(),
        cf = (character.PrimaryPart or hrp).CFrame,
        velocity = hrp.Velocity,
        state = humanoid:GetState()
    })

    local currentTime = tick()
    while #flashbackRecords > 0 and (currentTime - flashbackRecords[1].timestamp) > flashbackTime do
        table.remove(flashbackRecords, 1)
    end
end

local function applyRecord(character, record)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local primary = character.PrimaryPart or hrp
    primary.CFrame = record.cf
    hrp.Velocity = record.velocity

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and record.state then
        pcall(function()
            humanoid:ChangeState(record.state)
        end)
    end
end

-- Core loop
RunService:BindToRenderStep("FlashbackStep", 80, function()
    if not flashbackEnabled then return end
    local character = Player.Character or getCharacter()
    if not character then return end

    if isRewinding then
        if #flashbackRecords > 0 then
            local record = table.remove(flashbackRecords)
            if record then
                applyRecord(character, record)
            end
        end
    else
        recordCurrentState(character)
    end
end)

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flashbackEnabled then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == flashbackKey then
        isRewinding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == flashbackKey then
        isRewinding = false
    end
end)

-- Movement Page Orbit System
Window:CreateTextLabel("Movement", "Orbit")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Orbit variables
local orbiting = false
local angle = 0
local orbitSpeed = 1
local orbitRadius = 7
local target = nil

-- Orbit sliders
Window:CreateSlider("Movement", "Orbit Speed", 0.1, 5, 1, function(value)
    orbitSpeed = value
end)

Window:CreateSlider("Movement", "Orbit Radius", 3, 14, 7, function(value)
    orbitRadius = value
end)

-- Find nearest target function
local function getNearestTarget()
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nearest, dist = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if d < dist then
                dist = d
                nearest = plr.Character
            end
        end
    end

    -- Optional: check other models in workspace too
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(model) then
            local d = (model.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if d < dist then
                dist = d
                nearest = model
            end
        end
    end

    return nearest
end

-- Orbit toggle
Window:CreateToggle("Movement", "Orbit Nearest Player", function(state)
    orbiting = state
    if orbiting then
        target = getNearestTarget()
    else
        target = nil
    end
end)

-- Orbit loop
RunService.RenderStepped:Connect(function(dt)
    if orbiting and target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = player.Character.HumanoidRootPart
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            angle = angle + orbitSpeed * dt

            -- Only offset X and Z; keep Y at your current feet height
            local myY = myRoot.Position.Y
            local offset = Vector3.new(math.cos(angle) * orbitRadius, 0, math.sin(angle) * orbitRadius)
            local desiredPosition = Vector3.new(targetRoot.Position.X + offset.X, myY, targetRoot.Position.Z + offset.Z)

            -- Make the CFrame look at the target horizontally (same Y)
            local lookAt = Vector3.new(targetRoot.Position.X, myY, targetRoot.Position.Z)
            local desiredCFrame = CFrame.new(desiredPosition, lookAt)

            -- Smooth movement
            myRoot.CFrame = myRoot.CFrame:Lerp(desiredCFrame, 0.3)
        end
    end
end)
Window:CreateTextLabel("Movement", "Trip")
--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

--// Trip Settings
local tripEnabled = true
local tripKey = Enum.KeyCode.T
local tripPower = 35
local tripTime = 2 -- time before getting up

--// Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Trip Instructions",
        Text = "Press your set key or click the button to trip!",
        Duration = 5
    })
end)

--// Trip Function
local function trip()
    if not tripEnabled then return end

    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local animateScript = character:FindFirstChild("Animate")

    if not (humanoid and root) then return end

    -- Stop and disable animations
    if animateScript then
        animateScript.Disabled = true
    end

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    -- Force the humanoid into a ragdoll/fall state
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    humanoid.PlatformStand = true -- freezes animation control

    -- Apply forward velocity
    root.Velocity = root.CFrame.LookVector * tripPower + Vector3.new(0, 20, 0)

    -- Wait while down
    task.wait(tripTime)

    -- Restore control
    humanoid.PlatformStand = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    if animateScript then
        animateScript.Disabled = false
    end
end

--// Keybind Input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == tripKey and tripEnabled then
        trip()
    end
end)

--// UI Integration
Window:CreateToggle("Movement", "Trip Enabled", function(state)
    tripEnabled = state
end)

Window:CreateKeyButton("Movement", "Trip Key", "T", function(key)
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        tripKey = key
    elseif typeof(key) == "string" then
        local upper = string.upper(key)
        if Enum.KeyCode[upper] then
            tripKey = Enum.KeyCode[upper]
        end
    end
end)

Window:CreateButton("Movement", "Trip Now", function()
    trip()
end)

Window:CreateSlider("Movement", "Trip Power", 10, 100, tripPower, function(value)
    tripPower = value
end)

-- 🌟 Dynamic Player Dropdown + Teleport Button (with auto-update and save selection)
Window:CreateTextLabel("Movement", "Players")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local selectedPlayer = nil

-- Utility: safely get player names
local function GetPlayerNames()
	local names = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			table.insert(names, plr.Name)
		end
	end
	table.sort(names)
	return names
end

-- ✅ Create the player selection dropdown
local success, playerDropdown = pcall(function()
	return Window:CreateDropdown("Movement", "Select Player", GetPlayerNames(), function(selected)
		selectedPlayer = selected
	end)
end)

if not success then
	warn("⚠️ Failed to create dropdown:", playerDropdown)
	playerDropdown = nil
end

-- ✅ Safely add refresh logic only if dropdown exists
if playerDropdown then
	local function RefreshPlayerDropdown()
		task.wait(0.1)
		local names = GetPlayerNames()

		-- Different UI systems use different refresh methods, so we check all
		if playerDropdown.Refresh then
			playerDropdown:Refresh(names)
		elseif playerDropdown.UpdateOptions then
			playerDropdown:UpdateOptions(names)
		elseif playerDropdown.updateOptions then
			playerDropdown:updateOptions(names)
		else
			-- fallback: re-create dropdown visually (safe fallback)
			playerDropdown = Window:CreateDropdown("Movement", "Select Player", names, function(selected)
				selectedPlayer = selected
			end)
		end
	end

	Players.PlayerAdded:Connect(RefreshPlayerDropdown)
	Players.PlayerRemoving:Connect(RefreshPlayerDropdown)
end

-- ✅ Create the teleport button BELOW the dropdown
local success2, teleportButton = pcall(function()
	return Window:CreateButton("Movement", "Teleport to Player", function()
		if not selectedPlayer then
			warn("⚠️ No player selected.")
			return
		end

		local target = Players:FindFirstChild(selectedPlayer)
		if not target then
			warn("⚠️ Player not found.")
			return
		end

		local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local targetChar = target.Character or target.CharacterAdded:Wait()

		local hrp = localChar:FindFirstChild("HumanoidRootPart")
		local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHrp then
			hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
			print("✅ Teleported to", selectedPlayer)
		else
			warn("⚠️ Missing HumanoidRootPart.")
		end
	end)
end)

if not success2 then
	warn("⚠️ Failed to create button:", teleportButton)
end

-- =========================
-- Populate Teleport Page
-- =========================

Window:CreateTextLabel("Teleport", "Main Areas")

Window:CreateButton("Teleport", "Lounge", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(444, 21.3365822, -115, 1, -6.24358449e-08, 1.23946399e-14, 6.24358449e-08, 1, -9.12126197e-09, -1.18251466e-14, 9.12126197e-09, 1)
end)

Window:CreateButton("Teleport", "Lounge 2", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(636, 21.9176216, -16, 1, -8.36909493e-08, 3.55822998e-15, 8.36909493e-08, 1, -1.22197923e-08, -2.53554421e-15, 1.22197923e-08, 1)
end)

Window:CreateButton("Teleport", "Donut Shop", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(744, 20.9741421, 66, 1, 1.13152872e-07, 1.38250083e-14, -1.13152872e-07, 1, 1.65141056e-08, -1.19563893e-14, -1.65141056e-08, 1)
end)

Window:CreateButton("Teleport", "Stage", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(414, 22.8783302, -38, 1, -4.43512072e-08, -2.66011009e-13, 4.43512072e-08, 1, 8.9231051e-08, 2.62053481e-13, -8.9231051e-08, 1)
end)

Window:CreateButton("Teleport", "Campfire", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(391, 22.3482952, -203, 1, 1.64209943e-08, -1.57504814e-13, -1.64209943e-08, 1, -3.29686003e-08, 1.56963432e-13, 3.29686003e-08, 1)
end)

Window:CreateButton("Teleport", "Sky Platform", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(718, 910.328308, -181, 1, -3.52447245e-08, -3.49143213e-13, 3.52447245e-08, 1, 7.0649989e-08, 3.4665318e-13, -7.0649989e-08, 1)
end)

Window:CreateButton("Teleport", "Extra Baseplate Button", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(368, 19.7783298, 156, 1, 3.09549506e-08, -2.96739114e-13, -3.09549506e-08, 1, -6.19406606e-08, 2.9482173e-13, 6.19406606e-08, 1)
end)

Window:CreateTextLabel("Teleport", "Secret")
Window:CreateButton("Teleport", "Secret Place", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(602, 8151.87793, 3484, 1, -3.88445933e-08, 9.70068278e-14, 3.88445933e-08, 1, -5.6748175e-09, -9.67863891e-14, 5.6748175e-09, 1)
end)
-- =========================
-- Populate Visuals Page
-- =========================
Window:CreateTextLabel("Visuals", "Fov")
local Camera = workspace.CurrentCamera

-- Default FOV value
local DefaultFOV = Camera.FieldOfView

-- Create FOV slider in the UI
Window:CreateSlider("Visuals", "Camera FOV", 30, 120, DefaultFOV, function(value)
    Camera.FieldOfView = value
end)

-- =========================
-- Populate World Page
-- =========================
Window:CreateTextLabel("World", "Baseplate")
-- Baseplate toggle function
local baseplates = {} -- store parts globally in this scope

Window:CreateToggle("World", "Expand Baseplate", function(state)
    -- Create baseplates only once
    if #baseplates == 0 then
        for X = -10000, 10000, 512 do
            for Z = -10000, 10000, 512 do
                local P = Instance.new("Part")
                P.Anchored = true
                P.Locked = true
                P.Size = Vector3.new(512, 16, 512)
                P.CFrame = CFrame.new(X, 8, Z)
                P.Color = Color3.fromRGB(21, 129, 39)
                P.Material = Enum.Material.Fabric
                P.Transparency = 1 -- start invisible
                P.CanCollide = false -- start non-collidable
                P.Parent = workspace

                table.insert(baseplates, P)
            end
        end
    end

    -- Toggle visibility and collisions
    for _, part in pairs(baseplates) do
        if state then
            part.Transparency = 0
            part.CanCollide = true
        else
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end)
