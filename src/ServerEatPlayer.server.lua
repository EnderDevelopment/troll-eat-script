--!strict
-- ServerEatPlayer.server.lua
-- Script (ServerScript) placed inside: ServerScriptService
--
-- Listens for eat attempts from clients, kills the target player, and
-- broadcasts the action to everyone so all players can see it happen.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create the RemoteEvent inside ReplicatedStorage (once).
local eatRemote = Instance.new("RemoteEvent")
eatRemote.Name = "EatPlayerRemote"
eatRemote.Parent = ReplicatedStorage

local function getUserId(nameOrUserId)
	if type(nameOrUserId) == "number" then
		return nameOrUserId
	end
	local player = Players:FindFirstChild(nameOrUserId)
	if player then
		return player.UserId
	end
	return nil
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.5) -- Give the character time to fully spawn.
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

eatRemote.OnServerEvent:Connect(function(eaterPlayer, targetUserId)
	if not targetUserId or type(targetUserId) ~= "number" then
		return
	end

	-- The eater must be a valid, alive player.
	if not eaterPlayer or not eaterPlayer.Character then
		return
	end

	-- The target must exist and not be the eater themselves.
	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer or targetPlayer == eaterPlayer then
		return
	end

	local targetCharacter = targetPlayer.Character
	local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
	local eaterHumanoid = eaterPlayer.Character:FindFirstChildOfClass("Humanoid")

	-- Both must be alive to proceed.
	if not targetHumanoid or not eaterHumanoid then
		return
	end
	if targetHumanoid.Health <= 0 or eaterHumanoid.Health <= 0 then
		return
	end

	local targetName = targetPlayer.Name
	local eaterName = eaterPlayer.Name

	-- Kill the target player.
	targetHumanoid.Health = 0

	-- Broadcast the eat event to everyone so all players see the action.
	-- Every client receives the same message with the names involved.
	eatRemote:FireAllClients(eaterName, targetName)
end)
