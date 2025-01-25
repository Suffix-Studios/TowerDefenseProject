-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
local Remap = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remap", "src")
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local _vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local Vide = _vide
local cleanup = _vide.cleanup
local Index = _vide.Index
local root = _vide.root
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local EnemyHealthUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Components", "EnemyOverhead").EnemyHealthUI
local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")
local Enemies = atom({})
local CreateEnemyUI = function(OverheadProps)
	local newEnemies = Remap.set(Enemies(), OverheadProps.EnemyId, {
		HealthAtom = OverheadProps.EnemyHealth,
		Adornee = OverheadProps.Adornee,
	})
	Enemies(newEnemies)
end
local DestroyEnemyUI = function(EnemyId)
	local _exp = Enemies()
	local _enemyId = EnemyId
	if _exp[_enemyId] ~= nil then
		local newEnemies = Remap.delete(Enemies(), EnemyId)
		Enemies(newEnemies)
	end
end
root(function()
	local EnemiesMap = useAtom(Enemies)
	Vide.jsx(Index, {
		each = EnemiesMap,
	}, function(OverheadProps)
		return Vide.jsx("billboardgui", {
			action = cleanup,
			Parent = PlayerGui:FindFirstChild("EnemiesOverheads"),
			Adornee = OverheadProps().Adornee,
			Size = UDim2.fromScale(3, 0.65),
			StudsOffset = Vector3.new(0, 1.5, 0),
		}, Vide.jsx(EnemyHealthUI, {
			Health = OverheadProps().HealthAtom,
			TextType = "Number Only",
		}))
	end)
end)
return {
	CreateEnemyUI = CreateEnemyUI,
	DestroyEnemyUI = DestroyEnemyUI,
}
