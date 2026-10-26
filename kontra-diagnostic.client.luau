-- Diagnostic only: does not load the full menu or modify gameplay.
print("[Kontra test] 1: Downloaded script is running. Basic panel test in 8 seconds.")

task.delay(8, function()
    local ok, problem = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        assert(player, "No local player available")
        local playerGui = player:WaitForChild("PlayerGui", 10)
        assert(playerGui, "PlayerGui did not become available")

        local gui = Instance.new("ScreenGui")
        gui.Name = "KontraDiagnostic"
        local text = Instance.new("TextLabel")
        text.Size = UDim2.fromOffset(320, 60)
        text.Position = UDim2.fromScale(0.3, 0.3)
        text.Text = "Kontra basic panel test"
        text.Parent = gui
        print("[Kontra test] 2: Adding a basic panel now.")
        gui.Parent = playerGui
        print("[Kontra test] 3: Panel added. Automatic removal in 15 seconds.")
        task.delay(15, function()
            gui:Destroy()
            print("[Kontra test] 4: Panel removed; test complete.")
        end)
    end)
    if not ok then warn("[Kontra test] Script error: " .. tostring(problem)) end
end)
