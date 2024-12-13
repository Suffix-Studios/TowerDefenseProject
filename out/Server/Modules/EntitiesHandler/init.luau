-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService = _services.HttpService
local RunService = _services.RunService
local Workspace = _services.Workspace
local ServerEvents = TS.import(script, game:GetService("ServerScriptService"), "Modules", "ServerNetworking").ServerEvents
local Deflate = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "zlib", "out").Deflate
local GameMap
local Waypoints
local EntitiesHandler = {}
do
	local _container = EntitiesHandler
	local Entities = {
		Enemies = {},
	}
	_container.Entities = Entities
	local AddEnemy = function(Enemy)
		if not Waypoints then
			while GameMap == nil do
				task.wait(0.1)
				GameMap = Workspace:FindFirstChild(Workspace:GetAttribute("MapName"))
				local _result = GameMap
				if _result ~= nil then
					_result = _result:FindFirstChild("Waypoints")
				end
				Waypoints = _result
			end
		end
		local _enemies = Entities.Enemies
		local _id = Enemy.Id
		local _enemy = Enemy
		_enemies[_id] = _enemy
		ServerEvents.EntityAdded:broadcast("Enemy", {
			Id = Enemy.Id,
			ModelName = Enemy.ModelName,
			Health = Enemy.MaxHealth,
			IsAir = Enemy.IsAir,
			EnemyType = Enemy.Type,
			Speed = Enemy.Speed,
			SpawnCFrame = Enemy.CFrame,
		})
	end
	_container.AddEnemy = AddEnemy
	local RemoveEntity = function(Entity)
		local _enemies = Entities.Enemies
		local _id = Entity.Id
		if _enemies[_id] ~= nil then
			local _enemies_1 = Entities.Enemies
			local _id_1 = Entity.Id
			_enemies_1[_id_1] = nil
			ServerEvents.EntityRemoved:broadcast("Enemy", Entity.Id)
			Entity:Remove()
		end
	end
	_container.RemoveEntity = RemoveEntity
	local GetEnemyMovementValues = function(Enemy)
		local TargetWaypointInstance = Waypoints:FindFirstChild(`Waypoint{Enemy.TargetWaypoint}`)
		local TargetWaypointCFrame = TargetWaypointInstance:GetPivot()
		local EnemyCFrame = Enemy.CFrame
		local _position = EnemyCFrame.Position
		local _vector3 = Vector3.new(TargetWaypointCFrame.X, EnemyCFrame.Y, TargetWaypointCFrame.Z)
		local TargetDistance = (_position - _vector3).Magnitude
		return {
			TargetWaypointCFrame = TargetWaypointCFrame,
			TargetDistance = TargetDistance,
		}
	end
	local Frequency = 1 / 5
	local Elapsed = 0
	RunService.Heartbeat:Connect(function(DeltaTime)
		Elapsed += DeltaTime
		if not (Elapsed >= Frequency) then
			return nil
		end
		local ReplicaEnemiesTable = {}
		local _exp = Entities.Enemies
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(Enemy, EnemyId)
			if Enemy.Health <= 0 then
				RemoveEntity(Enemy)
				return nil
			end
			task.spawn(function()
				local EnemyMovementValues = GetEnemyMovementValues(Enemy)
				if EnemyMovementValues.TargetDistance <= 1 then
					Enemy.CFrame = EnemyMovementValues.TargetWaypointCFrame
					if Enemy.TargetWaypoint == (#Waypoints:GetChildren() - 1) then
						RemoveEntity(Enemy)
						return nil
					end
					Enemy.TargetWaypoint += 1
					EnemyMovementValues = GetEnemyMovementValues(Enemy)
					Enemy:Move(CFrame.lookAt(Enemy.CFrame.Position, EnemyMovementValues.TargetWaypointCFrame.Position))
				end
				local EnemyCFrame = Enemy.CFrame
				local _position = EnemyMovementValues.TargetWaypointCFrame.Position
				local _position_1 = EnemyCFrame.Position
				local Direction = (_position - _position_1).Unit
				local IsTooClose = EnemyMovementValues.TargetDistance < (Enemy.Speed * Frequency)
				local _position_2 = EnemyCFrame.Position
				local _arg0 = (if IsTooClose then EnemyMovementValues.TargetDistance else Enemy.Speed) * Frequency
				local _arg0_1 = Direction * _arg0
				local _cFrame = CFrame.new(_position_2 + _arg0_1)
				local _rotation = Enemy.CFrame.Rotation
				local newCFrame = _cFrame * _rotation
				local _position_3 = EnemyCFrame.Position
				local _position_4 = newCFrame.Position
				local DistanceTravelledThisStep = (_position_3 - _position_4).Magnitude
				local _value = Enemy.DistanceTravelled
				if _value ~= 0 and _value == _value and _value then
					Enemy.DistanceTravelled += DistanceTravelledThisStep
				end
				if Enemy.Hitbox ~= nil then
					Enemy.Hitbox:PivotTo(newCFrame)
				end
				Enemy:Move(newCFrame)
				local _enemyId = EnemyId
				local _arg1 = {
					Position2D = {
						X = newCFrame.X,
						Z = newCFrame.Z,
					},
					TargetPosition2D = {
						X = EnemyMovementValues.TargetWaypointCFrame.X,
						Z = EnemyMovementValues.TargetWaypointCFrame.Z,
					},
					Health = Enemy.Health,
					Speed = Enemy.Speed,
				}
				ReplicaEnemiesTable[_enemyId] = _arg1
			end)
		end
		for _k, _v in _exp do
			_callback(_v, _k, _exp)
		end
		-- ▲ ReadonlyMap.forEach ▲
		Elapsed = 0
		local EncodedTable = HttpService:JSONEncode(ReplicaEnemiesTable)
		-- const startTime = os.clock();
		local CompressedTable = Deflate.Compress(EncodedTable, {
			level = 9,
		})
		-- print(`Time Taken To Compress: ${math.floor((os.clock() - startTime) * 1000) / 1000} ms`);
		-- print(`Before: ${EncodedTable.size() / 1024} Kb \n After: ${CompressedTable.size() / 1024} Kb`);
		ServerEvents.ReplicateEnemies:broadcast(CompressedTable)
	end)
end
return EntitiesHandler
