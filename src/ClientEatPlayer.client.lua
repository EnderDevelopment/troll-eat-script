--!nonstrict
-- ClientEatPlayer.client.lua
-- Script (LocalScript) placed inside: StarterPlayer > StarterPlayerScripts
--
-- Shows a "Press E" proximity prompt when the local player comes close to
-- another player's character, and fires a remote event when E is pressed.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local eatRemote = ReplicatedStorage:WaitForChild("EatPlayerRemote")

-- Small helper to build a ProximityPrompt for a target model.
local function createPrompt(targetModel)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "EatPlayerPrompt"
	prompt.ActionText = "Press E"
	prompt.ObjectText = "to eat player"
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonY
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false

	local attachment = Instance.new("Attachment")
	attachment.Name = "EatPromptAttachment"
	attachment.Position = Vector3.new(0, 2, 0)
	attachment.Parent = targetModel.PrimaryPart or targetModel:FindFirstChild("HumanoidRootPart")
	prompt.Parent = attachment

	return prompt
end

-- Clean up existing prompts so we only ever show one at a time.
local function clearPrompts()
	for _, prompt in ipairs(localPlayer.PlayerGui:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			prompt:Destroy()
		end
	end
end

-- Show the prompt on the nearest other player within range.
local function refreshPrompt()
	clearPrompts()

	local nearestPlayer = nil
	local nearestDistance = 12 -- MaxActivationDistance

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer == localPlayer then
			continue
		end
		local character = otherPlayer.Character
		if not character then
			continue
		end
		local root = character:FindFirstChild("HumanoidRootPart")
		local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not root or not localRoot then
			continue
		end

		local distance = (root.Position - localRoot.Position).Magnitude
		if distance <= nearestDistance then
			nearestDistance = distance
			nearestPlayer = otherPlayer
		end
	end

	if nearestPlayer and nearestPlayer.Character then
		local prompt = createPrompt(nearestPlayer.Character)
		prompt.Triggered:Connect(function()
			eatRemote:FireServer(nearestPlayer.UserId)
		end)
	end
end

-- Continuously refresh the prompt as the player moves around.
local lastPosition = Vector3.new()
while true do
	local character = localPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and (root.Position - lastPosition).Magnitude > 1 then
		lastPosition = root.Position
		refreshPrompt()
	end
	-- Only check every 0.2 seconds to avoid excessive work.
	task.wait(0.2)
end
