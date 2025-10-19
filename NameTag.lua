--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG
local CONFIG = {
    TAG_SIZE = UDim2.new(0,180,0,32),
    TAG_OFFSET = Vector3.new(0,3,0),
    MAX_DISTANCE = 100,
    MIN_DISTANCE = 30,
    SHRINK_DELAY = 0.2,
    CORNER_RADIUS = UDim.new(0,10),
    SHRINK_SIZE = UDim2.new(0,40,0,40),
    TELEPORT_DISTANCE = 5,
    TELEPORT_HEIGHT = 2,
    PARTICLE_COUNT = 20,
    PARTICLE_SPEED = 1,
}

-- Special owner account
local SPECIAL_ACCOUNTS = {["Elite_biggestfan6"]=true}

-- Rank definitions
local DefaultRank = {primary=Color3.fromRGB(20,20,20), accent=Color3.fromRGB(80,62,255), emoji="⭐"}
local OwnerRank = {primary=Color3.fromRGB(20,20,20), accent=Color3.fromRGB(255,200,0), emoji="👑"}

-- Marker to indicate this player runs the script
local function markLocalPlayer()
    local marker = Instance.new("BoolValue")
    marker.Name = "HasTagScript"
    marker.Value = true
    marker.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

markLocalPlayer()

-- Teleport
local function teleportToPlayer(targetPlayer)
    local char = LocalPlayer.Character
    local tChar = targetPlayer.Character
    if not (char and tChar) then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local tHrp = tChar:FindFirstChild("HumanoidRootPart")
    if not (hrp and tHrp) then return end
    local pos = tHrp.Position - (tHrp.CFrame.LookVector*CONFIG.TELEPORT_DISTANCE) + Vector3.new(0,CONFIG.TELEPORT_HEIGHT,0)
    hrp.CFrame = CFrame.new(pos, tHrp.Position)
end

-- Particle generator
local function createParticles(container, color)
    for i=1,CONFIG.PARTICLE_COUNT do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0,math.random(2,6),0,math.random(2,6))
        p.Position = UDim2.new(math.random(),math.random(-10,10),1+math.random()*0.5,0)
        p.BackgroundColor3 = color
        p.BackgroundTransparency = math.random()*0.5
        p.BorderSizePixel=0
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent=p
        p.Parent=container
        spawn(function()
            while container and container.Parent do
                local startX=math.random()
                local tweenInfo = TweenInfo.new(1+math.random(), Enum.EasingStyle.Linear)
                local endX = startX+(math.random()-0.5)*0.3
                local tween = TweenService:Create(p,tweenInfo,{Position=UDim2.new(endX,math.random(-5,5),-0.5,math.random(-10,10)),BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
                tween:Play()
                task.wait(tweenInfo.Time)
                p.Position=UDim2.new(math.random(),math.random(-10,10),1+math.random()*0.5,0)
                p.Size=UDim2.new(0,math.random(2,6),0,math.random(2,6))
                p.BackgroundTransparency=math.random()*0.5
            end
        end)
    end
end

-- Create tag
local function createTag(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild("RankTag") then head.RankTag:Destroy() end

    local rankData = SPECIAL_ACCOUNTS[player.Name] and OwnerRank or DefaultRank
    local rankText = SPECIAL_ACCOUNTS[player.Name] and "Owner" or "Velora User"

    local tag = Instance.new("BillboardGui")
    tag.Name="RankTag"
    tag.Adornee=head
    tag.Size=CONFIG.TAG_SIZE
    tag.StudsOffset=CONFIG.TAG_OFFSET
    tag.AlwaysOnTop=true
    tag.MaxDistance=math.huge
    tag.Parent=LocalPlayer:WaitForChild("PlayerGui")

    local container = Instance.new("Frame")
    container.Size=UDim2.new(1,0,1,0)
    container.BackgroundColor3=rankData.primary
    container.BackgroundTransparency=0.15
    container.BorderSizePixel=0
    container.ClipsDescendants=true
    container.Parent=tag
    local corner = Instance.new("UICorner")
    corner.CornerRadius=CONFIG.CORNER_RADIUS
    corner.Parent=container
    local border = Instance.new("UIStroke")
    border.Color=rankData.accent
    border.Thickness=2
    border.Transparency=0.2
    border.Parent=container

    -- Clickable
    local clickButton = Instance.new("TextButton")
    clickButton.Size=UDim2.new(1,0,1,0)
    clickButton.BackgroundTransparency=1
    clickButton.Text=""
    clickButton.AutoButtonColor=false
    clickButton.Parent=container
    clickButton.MouseButton1Click:Connect(function()
        teleportToPlayer(player)
    end)

    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size=UDim2.new(1,-40,1,0)
    textLabel.Position=UDim2.new(0,32,0,0)
    textLabel.BackgroundTransparency=1
    textLabel.TextXAlignment=Enum.TextXAlignment.Center
    textLabel.TextYAlignment=Enum.TextYAlignment.Center
    textLabel.Font=Enum.Font.GothamBold
    textLabel.TextSize=16
    textLabel.TextColor3=rankData.accent
    textLabel.Text=rankText
    textLabel.Parent=container

    -- Emoji
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Text=rankData.emoji
    emojiLabel.TextColor3=Color3.new(1,1,1)
    emojiLabel.TextSize=20
    emojiLabel.Font=Enum.Font.GothamBold
    emojiLabel.BackgroundTransparency=1
    emojiLabel.Size=UDim2.new(0,30,0,30)
    emojiLabel.Position=UDim2.new(0,8,0.5,-15)
    emojiLabel.Parent=container

    -- Particles
    local particlesContainer = Instance.new("Frame")
    particlesContainer.Size=UDim2.new(1,0,1,0)
    particlesContainer.BackgroundTransparency=1
    particlesContainer.ClipsDescendants=true
    particlesContainer.Parent=container
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius=UDim.new(1,0)
    pCorner.Parent=particlesContainer
    createParticles(particlesContainer, rankData.accent)

    -- Shrink logic
    RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("Head") then return end
        local distance = (Camera.CFrame.Position-head.Position).Magnitude
        if distance>CONFIG.MIN_DISTANCE then
            TweenService:Create(container,TweenInfo.new(CONFIG.SHRINK_DELAY),{Size=CONFIG.SHRINK_SIZE}):Play()
            textLabel.Visible=false
            emojiLabel.Position=UDim2.new(0.5,-15,0.5,-15)
        else
            TweenService:Create(container,TweenInfo.new(CONFIG.SHRINK_DELAY),{Size=CONFIG.TAG_SIZE}):Play()
            textLabel.Visible=true
            emojiLabel.Position=UDim2.new(0,8,0.5,-15)
        end
    end)
end

-- Add tags for all players who have marker
local function setupPlayer(player)
    local function tryCreateTag()
        if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("HasTagScript") then
            createTag(player)
        end
    end
    tryCreateTag()
    player.CharacterAdded:Connect(function()
        tryCreateTag()
    end)
end

for _,player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
Players.PlayerAdded:Connect(setupPlayer)
