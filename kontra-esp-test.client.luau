-- Minimal highlight test. Run again to remove the highlights and stop the test.
local Players = game:GetService("Players")
local name = "KontraESPTest"
local previous = workspace:FindFirstChild(name)
if previous then
    previous:Destroy()
    print("[Kontra ESP] Test stopped.")
    return
end

local container = Instance.new("Folder")
container.Name = name
local connections = {}
local highlights = {}
local characterConnections = {}

local function report()
    local others, models, parts, visibleParts = 0, 0, 0, 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            others += 1
            local character = player.Character
            if character then
                models += 1
                for _, object in ipairs(character:GetDescendants()) do
                    if object:IsA("BasePart") then
                        parts += 1
                        if object.Transparency < 1 and object.LocalTransparencyModifier < 1 then
                            visibleParts += 1
                        end
                    end
                end
                print("[Kontra ESP] Character: " .. character:GetFullName()
                    .. "; in workspace: " .. tostring(character:IsDescendantOf(workspace)))
            end
        end
    end
    print(string.format("[Kontra ESP] Targets: %d other players, %d character models, %d parts, %d visible parts.",
        others, models, parts, visibleParts))
end

local function clear(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function watch(player)
    if player == Players.LocalPlayer or characterConnections[player] then return end
    local function attach(character)
        clear(player)
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerOutline"
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(255, 126, 66)
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = container
        highlights[player] = highlight
    end
    characterConnections[player] = player.CharacterAdded:Connect(attach)
    if player.Character then attach(player.Character) end
end

container.Destroying:Connect(function()
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, connection in pairs(characterConnections) do connection:Disconnect() end
    table.clear(highlights)
    table.clear(characterConnections)
end)
container.Parent = workspace
table.insert(connections, Players.PlayerAdded:Connect(watch))
table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    clear(player)
    if characterConnections[player] then
        characterConnections[player]:Disconnect()
        characterConnections[player] = nil
    end
end))
for _, player in ipairs(Players:GetPlayers()) do watch(player) end
print("[Kontra ESP] Diagnostic v2 started. Run again to stop.")
task.delay(3, function()
    if container.Parent then report() end
end)
