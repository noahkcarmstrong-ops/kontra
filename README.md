# Kontra menu

`kontra-menu.client.luau` is a standalone Roblox client interface with a charcoal and orange design.

1. In Roblox Studio, add a **LocalScript** under **StarterPlayer → StarterPlayerScripts**.
2. Paste the contents of `kontra-menu.client.luau` into it and press **Play**.
3. Press **Right Shift** to show or hide the menu. Drag its title bar to move it.

Overview, Visuals, and Settings tabs are included. Settings has a working **Hide on respawn** option, held for the current session. Visuals is an empty placeholder. This version contains only the interface.

## Minimal diagnostic

`kontra-diagnostic.client.luau` prints numbered stages to the client console, waits eight seconds, then adds a basic text panel for fifteen seconds. It does not load the main menu or change gameplay. Run it once in a fresh session. Record the last numbered message, whether the panel appeared, and whether the session disconnected. A final message confirms only that the panel test completed, not that the full menu works or that a later kick cannot occur. A disconnect before the panel appears does not establish that the menu's interface caused it.
