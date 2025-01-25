-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useDeltaTime = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "matter", "lib").useDeltaTime
local ServerEvents = TS.import(script, game:GetService("ServerScriptService"), "Modules", "ServerNetworking").ServerEvents
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local Enumerators = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators")
local EnemyPacketSerializer = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "BinarySerializers").EnemyPacketSerializer
local ReplicationFrequency = 1 / 5
local Elapsed = 0
local EntitiesReplication = function(World)
	Elapsed += useDeltaTime()
	if Elapsed < ReplicationFrequency then
		return nil
	end
	Elapsed = 0
	local EnemiesPackets = {}
	for id, EntityEnemyInfo in World:query(EnemyInfo) do
		local EnemyPacket = EnemyPacketSerializer.serialize({
			Id = id,
			T = EntityEnemyInfo.PathProgress,
			Health = EntityEnemyInfo.Health,
		})
		local _buffer = EnemyPacket.buffer
		table.insert(EnemiesPackets, _buffer)
	end
	if #EnemiesPackets == 0 then
		return nil
	end
	ServerEvents.ReplicateEnemies:broadcast(EnemiesPackets)
end
return {
	system = EntitiesReplication,
	priority = Enumerators.SystemPriorty.High,
	event = "default",
}
