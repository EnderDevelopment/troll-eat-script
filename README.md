# Eat Player System (Roblox)

A Roblox Lua system that lets players eat other players by walking close to them and pressing the E key. When a player approaches another player within range, a "Press E" prompt appears on screen. Pressing E kills the target player and broadcasts the action to everyone in the game, making it visible to all players.

## Install

1. Open your Roblox Studio project.
2. In the Explorer window, right-click on `StarterPlayer` and select `StarterPlayerScripts`.
3. Insert a `LocalScript` into `StarterPlayerScripts`.
4. Copy the contents of `ClientEatPlayer.client.lua` into this LocalScript.
5. In the Explorer window, find `ServerScriptService` (under the game hierarchy).
6. Insert a `Script` into `ServerScriptService`.
7. Copy the contents of `ServerEatPlayer.server.lua` into this Script.
8. Save and play-test your game.

## Use

1. Run your Roblox game.
2. Move your character close to another player (within 12 studs).
3. A prompt will appear showing "Press E" above the target player.
4. Press the E key (or B/Y on gamepad) to eat the target player.
5. The target player will die and the eat action will be broadcast to all players in the game.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/5569062b-5568-4781-b21d-4982bac3ec50?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=5569062b-5568-4781-b21d-4982bac3ec50
