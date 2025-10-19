--!strict
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG
local CONFIG = {
    TAG_SIZE = UDim2.new(0, 180, 0, 32),
    TAG_OFFSET = Vector3.new(0, 3, 0),
    MAX_DISTANCE = 100,
    MIN_DISTANCE = 30,
    SHRINK_DELAY = 0.2,
    CORNER_RADIUS = UDim.new(0, 10),
    SHRINK_SIZE = UDim2.new(0, 40, 0, 40),
    TELEPORT_DISTANCE = 5,
    TELEPORT_HEIGHT = 2,
    PARTICLE_COUNT = 20,
    PARTICLE_SPEED = 1,
}

-- Owner special account
local SPECIAL_ACCOUNTS = {
    ["YourOwnerUsername"] = true,
}

-- Rank definitions
local DefaultRank = {
    primary = Color3.fromRGB(20, 20, 20),
    accent = Color3.fromRGB(80, 62, 255),
    emoji = "⭐",
}

local OwnerRank = {
    primary = Color3.fromRGB(20, 20, 20),
    accent = Color3.fromRGB(255, 200, 0),
    emoji = "👑",
}

-- RemoteEvent for auto-detection
local tagEvent = ReplicatedStorage:FindFirstChild("TagScriptEvent")
if not tagEvent then
    tagEvent = Instance.new("RemoteEvent")
    tagEvent.Name = "TagScriptEvent"
    tagEvent.Parent = ReplicatedStorage
end

-- Local list of peers running the script
local PeersWithScript = {} -- [player] = true

-- Teleport function
local function teleportToPlayer(targetPlayer)
    local character = LocalPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (character and targetCharacter) then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not (hrp and targetHRP) then return end
    local targetPos = targetHRP.Position - (targetHRP.CFrame.LookVector * CONFIG.TELEPORT_DISTANCE)
    targetPos = targetPos + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)
    hrp.CFrame = CFrame.new(targetPos, targetHRP.Position)
end

-- Particle generator
local function createParticles(container, accentColor)
    for i = 1, CONFIG.PARTICLE_COUNT do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2,6), 0, math.random(2,6))
        particle.Position = UDim2.new(math.random(), math.random(-10,10), 1 + math.random()*0.5, 0)
        particle.BackgroundColor3 = accentColor
        particle.BackgroundTransparency = math.random()*0.5
        particle.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1,0)
        corner.Parent = particle
        particle.Parent = container

        spawn(function()
            while container and container.Parent do
                local startX = math.random()
                local tweenInfo = TweenInfo.new(1 + math.random(), Enum.EasingStyle.Linear)
                local endX = startX + (math.random()-0.5)*0.3
                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(endX, math.random(-5,5), -0.5, math.random(-10,10)),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0,0,0,0)
                })
                tween:Play()
                task.wait(tweenInfo.Time)
                particle.Position = UDim2.new(math.random(), math.random(-10,10), 1 + math.random()*0.5,0)
                particle.Size = UDim2.new(0, math.random(2,6),0, math.random(2,6))
                particle.BackgroundTransparency = math.random()*0.5
            end
        end)
    end
end

-- Create tag for a player (local only)
local function createTag(player)
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    if head:FindFirstChild("RankTag") then
        head.RankTag:Destroy()
    end

    -- Determine rank
    local rankData = SPECIAL_ACCOUNTS[player.Name] and OwnerRank or DefaultRank
    local rankText = SPECIAL_ACCOUNTS[player.Name] and "Owner" or "Velora User"

    -- BillboardGui
    local tag = Instance.new("BillboardGui")
    tag.Name = "RankTag"
    tag.Adornee = head
    tag.Size = CONFIG.TAG_SIZE
    tag.StudsOffset = CONFIG.TAG_OFFSET
    tag.AlwaysOnTop = true
    tag.MaxDistance = math.huge
    tag.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,1,0)
    container.BackgroundColor3 = rankData.primary
    container.BackgroundTransparency = 0.15
    container.ClipsDescendants = true
    container.BorderSizePixel = 0
    container.Parent = tag
    local corner = Instance.new("UICorner")
    corner.CornerRadius = CONFIG.CORNER_RADIUS
    corner.Parent = container
    local border = Instance.new("UIStroke")
    border.Color = rankData.accent
    border.Thickness = 2
    border.Transparency = 0.2
    border.Parent = container

    -- Clickable
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1,0,1,0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.AutoButtonColor = false
    clickButton.Parent = container
    clickButton.MouseButton1Click:Connect(function()
        teleportToPlayer(player)
    end)

    -- Text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -40, 1, 0)
    textLabel.Position = UDim2.new(0,32,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 16
    textLabel.TextColor3 = rankData.accent
    textLabel.Text = rankText
    textLabel.Parent = container

    -- Emoji label
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Text = rankData.emoji
    emojiLabel.TextColor3 = Color3.new(1,1,1)
    emojiLabel.TextSize = 20
    emojiLabel.Font = Enum.Font.GothamBold
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.Size = UDim2.new(0,30,0,30)
    emojiLabel.Position = UDim2.new(0, 8, 0.5, -15)
    emojiLabel.Parent = container

    -- Particles
    local particlesContainer = Instance.new("Frame")
    particlesContainer.Size = UDim2.new(1,0,1,0)
    particlesContainer.BackgroundTransparency = 1
    particlesContainer.ClipsDescendants = true
    particlesContainer.Parent = container
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(1,0)
    pCorner.Parent = particlesContainer
    createParticles(particlesContainer, rankData.accent)

    -- Shrink logic
    RunService.RenderStepped:Connect(function()
        if not (player.Character and player.Character:FindFirstChild("Head")) then return end
        local distance = (Camera.CFrame.Position - head.Position).Magnitude
        if distance > CONFIG.MIN_DISTANCE then
            TweenService:Create(container, TweenInfo.new(CONFIG.SHRINK_DELAY), {Size = CONFIG.SHRINK_SIZE}):Play()
            textLabel.Visible = false
            emojiLabel.Position = UDim2.new(0.5, -15, 0.5, -15)
        else
            TweenService:Create(container, TweenInfo.new(CONFIG.SHRINK_DELAY), {Size = CONFIG.TAG_SIZE}):Play()
            textLabel.Visible = true
            emojiLabel.Position = UDim2.new(0, 8, 0.5, -15)
        end
    end)
end

-- Notify other clients that we are running the script
tagEvent:FireServer()

-- Listen for peers firing the event
tagEvent.OnClientEvent:Connect(function(playerWhoHasScript)
    if playerWhoHasScript ~= LocalPlayer then
        PeersWithScript[playerWhoHasScript] = true
        createTag(playerWhoHasScript)
    end
end)

-- Add self
PeersWithScript[LocalPlayer] = true
createTag(LocalPlayer)

-- Setup players locally
local function setupPlayer(player)
    if PeersWithScript[player] then
        createTag(player)
    end
    player.CharacterAdded:Connect(function()
        if PeersWithScript[player] then
            createTag(player)
        end
    end)
end

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
Players.PlayerAdded:Connect(setupPlayer)
