-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local _vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local Vide = _vide
local For = _vide.For
local root = _vide.root
local EnemyHealthUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "EnemyHealth").EnemyHealthUI
local ClientEntitiesContainer = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "ClientRenderer", "Container")
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local App = function()
	local Enemies = function()
		return useAtom(ClientEntitiesContainer.Enemies)()
	end
	return Vide.jsx("folder", {
		Parent = PlayerGui,
		Name = "EnemyOverheads",
	}, Vide.jsx(For, {
		each = Enemies,
	}, function(Enemy, _)
		return Vide.jsx(EnemyHealthUI, {
			Health = Enemy.Health,
			MaxHealth = Enemy.MaxHealth,
			Adornee = Enemy.Character.PrimaryPart,
			TextType = "Number Only",
		})
	end))
end
root(function()
	Vide.jsx(App)
end)
