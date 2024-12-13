-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local DataService = TS.import(script, game:GetService("ServerScriptService"), "Modules", "DataService")
Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		for _, Descendant in pairs(Character:GetDescendants()) do
			if Descendant:IsA("BasePart") then
				Descendant.CollisionGroup = "Players"
			end
		end
	end)
	DataService.LoadProfile(Player)
end)
Players.PlayerRemoving:Connect(function(Player)
	return DataService.UnloadProfile(Player)
end)
