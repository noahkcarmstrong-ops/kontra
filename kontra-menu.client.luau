-- Run as a LocalScript. Right Shift toggles the menu.
local Players = game:GetService("Players")
local Input = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local accent = Color3.fromRGB(255, 126, 66)
local muted = Color3.fromRGB(148, 152, 163)
local function make(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties) do object[key] = value end
    object.Parent = parent
    return object
end
local function label(parent, text, position, size, color, fontSize)
    return make("TextLabel", {
        BackgroundTransparency = 1, Text = text, Position = position, Size = size,
        TextColor3 = color, TextSize = fontSize or 14, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
    }, parent)
end
local function button(parent, text, position, size)
    local b = make("TextButton", {
        Text = text, Position = position, Size = size, BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 38, 46), TextColor3 = Color3.fromRGB(235, 237, 241),
        Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = true,
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    return b
end

local gui = make("ScreenGui", {Name = "KontraMenu", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 20}, nil)
local window = make("Frame", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(640, 390), BackgroundColor3 = Color3.fromRGB(21, 23, 29), BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, window)
make("UIStroke", {Color = Color3.fromRGB(58, 61, 71), Thickness = 1}, window)
local scale = make("UIScale", {}, window)
local function fit()
    local camera = workspace.CurrentCamera
    if camera then scale.Scale = math.min(1, (camera.ViewportSize.X - 24) / 640, (camera.ViewportSize.Y - 24) / 390) end
end
fit()
local cameraConnection
local function watchCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    local camera = workspace.CurrentCamera
    if camera then cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end
    fit()
end
watchCamera()
local cameraChanged = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)

local header = make("Frame", {Name = "DragHandle", BackgroundTransparency = 1,
    Active = true, Size = UDim2.new(1, -58, 0, 72)}, window)
label(header, "K /", UDim2.fromOffset(24, 18), UDim2.fromOffset(48, 30), accent, 24)
label(header, "KONTRA", UDim2.fromOffset(78, 15), UDim2.fromOffset(200, 30), Color3.new(1, 1, 1), 22)
label(header, "CONTROL PANEL  /  01", UDim2.fromOffset(79, 43), UDim2.fromOffset(260, 18), muted, 10)
local close = button(window, "×", UDim2.new(1, -46, 0, 20), UDim2.fromOffset(28, 28))
close.Activated:Connect(function() window.Visible = false end)
make("Frame", {BackgroundColor3 = accent, BorderSizePixel = 0,
    Position = UDim2.fromOffset(24, 74), Size = UDim2.new(1, -48, 0, 2)}, window)

local title = label(window, "Overview", UDim2.fromOffset(192, 102), UDim2.fromOffset(390, 30), Color3.new(1, 1, 1), 22)
local description = label(window, "Your Kontra control panel.\nChoose a tab to get started.",
    UDim2.fromOffset(192, 142), UDim2.fromOffset(390, 65), muted, 14)
local card = make("Frame", {BackgroundColor3 = Color3.fromRGB(28, 31, 38), BorderSizePixel = 0,
    Position = UDim2.fromOffset(192, 228), Size = UDim2.fromOffset(420, 90)}, window)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
local cardTitle = label(card, "READY", UDim2.fromOffset(18, 13), UDim2.fromOffset(380, 22), accent, 11)
local cardText = label(card, "Press Right Shift to hide or show this panel.",
    UDim2.fromOffset(18, 39), UDim2.fromOffset(380, 38), muted, 13)
local hideOnStart = false
local setting = button(card, "", UDim2.fromOffset(16, 44), UDim2.fromOffset(388, 30))
setting.Visible = false
setting.Activated:Connect(function()
    hideOnStart = not hideOnStart
    setting.Text = "Hide on respawn: " .. (hideOnStart and "ON" or "OFF")
end)
local pages = {
    {"Overview", "Your Kontra control panel.\nChoose a tab to get started.", "READY", "Press Right Shift to hide or show this panel."},
    {"Visuals", "A dedicated space for your visual preferences.", "NO FEATURES ADDED", "Visual controls will appear here when added."},
    {"Settings", "Make the panel work the way you like.", "PANEL BEHAVIOR", ""},
}
local tabs = {}
local function selectPage(index)
    local page = pages[index]
    title.Text, description.Text, cardTitle.Text, cardText.Text = page[1], page[2], page[3], page[4]
    setting.Visible = index == 3
    setting.Text = "Hide on respawn: " .. (hideOnStart and "ON" or "OFF")
    for i, tab in ipairs(tabs) do
        tab.BackgroundColor3 = i == index and Color3.fromRGB(72, 43, 34) or Color3.fromRGB(28, 31, 38)
        tab.TextColor3 = i == index and accent or muted
    end
end
for i, page in ipairs(pages) do
    local tab = button(window, page[1], UDim2.fromOffset(24, 106 + (i - 1) * 47), UDim2.fromOffset(140, 37))
    tabs[i] = tab
    tab.Activated:Connect(function() selectPage(i) end)
end
selectPage(1)
label(window, "KONTRA  /  UI v0.1", UDim2.fromOffset(24, 350), UDim2.fromOffset(230, 18), muted, 10)
label(window, "RIGHT SHIFT  ·  TOGGLE", UDim2.fromOffset(437, 350), UDim2.fromOffset(180, 18), muted, 10)

local dragging, dragOrigin, startPosition, dragTouch
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragOrigin, startPosition = true, input.Position, window.Position
        dragTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
    end
end)
local changed = Input.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragTouch) then
        local delta = input.Position - dragOrigin
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
local ended = Input.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input == dragTouch then dragging = false end
end)
local began = Input.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift and not Input:GetFocusedTextBox() then
        window.Visible = not window.Visible
    end
end)
local respawned = Players.LocalPlayer.CharacterAdded:Connect(function()
    window.Visible = not hideOnStart
end)
gui.Destroying:Connect(function()
    began:Disconnect()
    changed:Disconnect()
    ended:Disconnect()
    respawned:Disconnect()
    cameraChanged:Disconnect()
    if cameraConnection then cameraConnection:Disconnect() end
end)

-- Build the entire panel before mounting it; keep the previous panel if setup fails.
local old = playerGui:FindFirstChild("KontraMenu")
if old then old:Destroy() end
gui.Parent = playerGui
