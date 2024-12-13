-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local HttpService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local ClientEvents = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "ClientNetworking").ClientEvents
local ClientEntitiesContainer = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "ClientRenderer", "Container")
local Deflate = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "zlib", "out").Deflate
local Utils = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Utils")
local ClientEnemy = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Entities", "ClientEnemy")
local Remap = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remap", "src")
ClientEvents.ReplicateEnemies:connect(function(CompressedEnemiesTable)
	local DecompressedTable = Deflate.Decompress(CompressedEnemiesTable)
	local ReplicatedEnemiesTable = HttpService:JSONDecode(DecompressedTable)
	local Enemies = ClientEntitiesContainer.Enemies()
	-- ▼ ReadonlyMap.forEach ▼
	local _callback = function(ReplicatedEnemy, EnemyId)
		local _enemyId = EnemyId
		if not (Enemies[_enemyId] ~= nil) then
			return nil
		end
		task.spawn(function()
			local _enemyId_1 = EnemyId
			local ClientEnemy = Enemies[_enemyId_1]
			ClientEnemy:CheckAnimation()
			if ClientEnemy.Health() <= 0 then
				return nil
			end
			local YPos = Utils.GetConstantYPosition(false) + (ClientEnemy.Character:GetExtentsSize().Y / 2) + 0.5
			ClientEnemy.Health(ReplicatedEnemy.Health)
			ClientEnemy.Speed = ReplicatedEnemy.Speed
			local EnemyPosition = Vector3.new(ReplicatedEnemy.Position2D.X, YPos, ReplicatedEnemy.Position2D.Z)
			local TargetPosition = Vector3.new(ReplicatedEnemy.TargetPosition2D.X, YPos, ReplicatedEnemy.TargetPosition2D.Z)
			local TargetCFrame = CFrame.lookAt(EnemyPosition, TargetPosition)
			ClientEnemy:Move(TargetCFrame)
		end)
	end
	for _k, _v in ReplicatedEnemiesTable do
		_callback(_v, _k, ReplicatedEnemiesTable)
	end
	-- ▲ ReadonlyMap.forEach ▲
end)
ClientEvents.EntityAdded:connect(function(EntityType, EntityProps)
	if EntityType == "Enemy" then
		local Props = EntityProps
		local newEnemy = ClientEnemy.new(EntityProps)
		local Enemies = ClientEntitiesContainer.Enemies()
		Enemies = Remap.set(Enemies, Props.Id, newEnemy)
		ClientEntitiesContainer.Enemies(Enemies)
	end
end)
ClientEvents.EntityRemoved:connect(function(EntityType, EntityId)
	if EntityType == "Enemy" then
		local Enemies = ClientEntitiesContainer.Enemies()
		local _enemies = Enemies
		local _entityId = EntityId
		local Enemy = _enemies[_entityId]
		if Enemy ~= nil then
			Enemies = Remap.delete(Enemies, EntityId)
			ClientEntitiesContainer.Enemies(Enemies)
			Enemy:Remove()
		end
	end
end)
