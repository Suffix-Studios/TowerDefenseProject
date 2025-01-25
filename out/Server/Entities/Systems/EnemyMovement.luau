-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useDeltaTime = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "matter", "lib").useDeltaTime
local ServerEvents = TS.import(script, game:GetService("ServerScriptService"), "Modules", "ServerNetworking").ServerEvents
local MapPath = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "BezierPath")
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local Enumerators = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators")
local PathLength = MapPath.PathLength
local EnemyBaseSpeed = 4
local EnemyMovement = function(World)
	for id, EntityEnemyInfo in World:query(EnemyInfo) do
		local StepDistance = (EntityEnemyInfo.Speed * EnemyBaseSpeed) / PathLength
		local newT = EntityEnemyInfo.PathProgress + StepDistance * useDeltaTime()
		--/! DEBUG
		if newT >= 1 then
			World:despawn(id)
			ServerEvents.EntityRemoved:broadcast(id)
			continue
		end
		World:insert(id, EntityEnemyInfo:patch({
			PathProgress = newT,
		}))
	end
end
return {
	system = EnemyMovement,
	priority = Enumerators.SystemPriorty.Critical,
	event = "default",
}
