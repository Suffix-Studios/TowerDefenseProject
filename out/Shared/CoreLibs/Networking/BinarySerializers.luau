-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createBinarySerializer = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "flamework-binary-serializer", "out").createBinarySerializer
local newEnemyPacketSerializer = createBinarySerializer({ "object_raw", { { "ModelName", { "string" } }, { "Speed", { "u8" } }, { "MaxHealth", { "u32" } }, { "IsAir", { "boolean" } }, { "Type", { "u8" } } } })
local EnemyPacketSerializer = createBinarySerializer({ "object_raw", { { "Health", { "u32" } }, { "Id", { "u16" } }, { "T", { "f32" } } } })
local newTowerPacketSerializer = createBinarySerializer({ "object_raw", { { "TowerName", { "string" } }, { "Position", { "object_raw", { { "X", { "f32" } }, { "Y", { "f32" } }, { "Z", { "f32" } } } } }, { "Owner", { "string" } } } })
return {
	newEnemyPacketSerializer = newEnemyPacketSerializer,
	EnemyPacketSerializer = EnemyPacketSerializer,
	newTowerPacketSerializer = newTowerPacketSerializer,
}
