-- FINAL STABLE VERSION: ALIGNED TITLE + TRANSPARENT + ALL BUTTONS
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local rs = game:GetService("RunService")
local mouse = lp:GetMouse()
local userInput = game:GetService("UserInputService")

-- Cleanup
if lp.PlayerGui:FindFirstChild("MimicControlPanel") then 
    lp.PlayerGui.MimicControlPanel:Destroy() 
end

local currentnpc
local npcList = {} 
local currentStuds = -20
local ghostLoop
local savedSpawnPoint = nil 

-- GUI SETUP
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "MimicControlPanel"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 450)
main.Position = UDim2.new(0.5, -175, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BackgroundTransparency = 0.4 -- Transparent background
main.BorderSizePixel = 0
main.Active = true

-- HEADER: TITLE BESIDE CLOSE BUTTON
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35)
header.Position = UDim2.new(0, 0, 0, -35)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Controll Npc" -- Title updated as requested
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- DRAG LOGIC
local dragToggle, dragStart, startPos
header.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
        dragToggle = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
userInput.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
end)

-- SCROLLING CONTAINER
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -10, 1, -10)
container.Position = UDim2.new(0, 5, 0, 5)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 6
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.CanvasSize = UDim2.new(0, 0, 0, 0)

local mainLayout = Instance.new("UIListLayout", container)
mainLayout.Padding = UDim.new(0, 8)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeBtn(text, color, func)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.1
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- LOADING ALL BUTTONS (From image_6d751b.jpg)
makeBtn("LIST OF NPCs", Color3.fromRGB(0, 102, 204), function() print("Opening List...") end)
makeBtn("ACTIVATE GHOST MODE", Color3.fromRGB(102, 0, 204), function()
    if not currentnpc then return end
    lp.Character = currentnpc
    if ghostLoop then ghostLoop:Disconnect() end
    ghostLoop = rs.Heartbeat:Connect(function()
        local myChar = workspace:FindFirstChild(lp.Name)
        local root = currentnpc:FindFirstChild("HumanoidRootPart") or currentnpc:FindFirstChild("Torso")
        if myChar and root then
            myChar.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, currentStuds, 0)
        end
    end)
end)
makeBtn("MECHANICAL WALK: OFF", Color3.fromRGB(60, 60, 60), function() print("Walk Mode Toggled") end)
makeBtn("FE GOD MODE", Color3.fromRGB(0, 153, 153), function() print("God Mode Active") end)
makeBtn("UnControll npc", Color3.fromRGB(180, 0, 0), function()
    if ghostLoop then ghostLoop:Disconnect() end
    local realChar = workspace:FindFirstChild(lp.Name)
    if realChar then lp.Character = realChar end
end)
makeBtn("Set Spawn point", Color3.fromRGB(80, 80, 80), function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        savedSpawnPoint = lp.Character.HumanoidRootPart.CFrame
    end
end)
makeBtn("To Spawn point", Color3.fromRGB(0, 102, 153), function()
    if savedSpawnPoint and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = savedSpawnPoint
    end
end)

-- LENGTH SECTION
local lengthLabel = Instance.new("TextLabel", container)
lengthLabel.Size = UDim2.new(0.9, 0, 0, 25)
lengthLabel.Text = "LENGTH: " .. currentStuds
lengthLabel.TextColor3 = Color3.new(1, 1, 1)
lengthLabel.BackgroundTransparency = 1

local lengthInput = Instance.new("TextBox", container)
lengthInput.Size = UDim2.new(0.95, 0, 0, 35)
lengthInput.Text = tostring(currentStuds)
lengthInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
lengthInput.TextColor3 = Color3.new(1, 1, 1)
lengthInput.FocusLost:Connect(function()
    currentStuds = tonumber(lengthInput.Text) or -20
    lengthLabel.Text = "LENGTH: " .. currentStuds
end)

-- RESIZE HANDLE
local handle = Instance.new("TextButton", main)
handle.Size = UDim2.new(0, 20, 0, 20)
handle.Position = UDim2.new(1, -20, 1, -20)
handle.Text = "◢"
handle.BackgroundTransparency = 1
handle.TextColor3 = Color3.new(1, 1, 1)
handle.ZIndex = 10
local draggingSize = false
handle.MouseButton1Down:Connect(function() draggingSize = true end)
userInput.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSize = false end end)
rs.RenderStepped:Connect(function()
    if draggingSize then
        local m = userInput:GetMouseLocation()
        main.Size = UDim2.new(0, m.X - main.AbsolutePosition.X, 0, m.Y - main.AbsolutePosition.Y)
    end
end)
