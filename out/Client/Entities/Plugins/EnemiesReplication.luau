-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage = _services.ReplicatedStorage
local Workspace = _services.Workspace
local ClientEvents = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "ClientNetworking").ClientEvents
local _EnemiesUIRoot = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "EnemiesUIRoot")
local CreateEnemyUI = _EnemiesUIRoot.CreateEnemyUI
local DestroyEnemyUI = _EnemiesUIRoot.DestroyEnemyUI
local MapPath = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "BezierPath")
local Character = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "Character").Character
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local _BinarySerializers = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "BinarySerializers")
local EnemyPacketSerializer = _BinarySerializers.EnemyPacketSerializer
local newEnemyPacketSerializer = _BinarySerializers.newEnemyPacketSerializer
local EnemiesModels = ReplicatedStorage:WaitForChild("EnemiesModels")
local AnimationsFolder = ReplicatedStorage:FindFirstChild("Animations")
local EnemiesReplication = function(World)
	ClientEvents.EnemyAdded:connect(function(EnemyPacket)
		local newEnemyInfo = newEnemyPacketSerializer.deserialize(EnemyPacket)
		local WalkAnimation = AnimationsFolder:FindFirstChild("EnemyWalk")
		local EnemyModel = EnemiesModels:FindFirstChild(newEnemyInfo.ModelName)
		if EnemyModel == nil then
			return nil
		end
		EnemyModel = EnemyModel:Clone()
		EnemyModel.Parent = Workspace:FindFirstChild("Enemies")
		EnemyModel:PivotTo(MapPath:CalculateUniformCFrame(0))
		local AnimationController = EnemyModel:FindFirstChildWhichIsA("AnimationController")
		local _result = AnimationController
		if _result ~= nil then
			_result = _result:FindFirstChildWhichIsA("Animator")
		end
		local Animator = _result
		local AnimationTrack = Animator:LoadAnimation(WalkAnimation)
		local HealthAtom = atom(newEnemyInfo.MaxHealth)
		local EnemyId = World:spawn(EnemyInfo({
			ModelName = newEnemyInfo.ModelName,
			Speed = newEnemyInfo.Speed,
			MaxHealth = newEnemyInfo.MaxHealth,
			AtomicHealth = HealthAtom,
			IsAir = newEnemyInfo.IsAir,
			Type = newEnemyInfo.Type,
			PathProgress = 0,
			TargetPathProgress = 0,
		}), Character({
			Model = EnemyModel,
			Animation = Animator:LoadAnimation(WalkAnimation),
		}))
		CreateEnemyUI({
			EnemyId = EnemyId,
			EnemyHealth = HealthAtom,
			Adornee = EnemyModel:FindFirstChild("Head"),
		})
	end)
	ClientEvents.ReplicateEnemies:connect(function(EnemiesPackets)
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(SerializedEnemyPacket)
			local EnemyPacket = EnemyPacketSerializer.deserialize(SerializedEnemyPacket)
			if not World:contains(EnemyPacket.Id) then
				return nil
			end
			local EntityEnemyInfo = (World:get(EnemyPacket.Id, EnemyInfo))
			local _result = EntityEnemyInfo
			if _result ~= nil then
				_result = _result.AtomicHealth
			end
			local AtomicHealth = _result
			AtomicHealth(EnemyPacket.Health)
			World:insert(EnemyPacket.Id, EntityEnemyInfo:patch({
				TargetPathProgress = EnemyPacket.T,
			}))
		end
		for _k, _v in EnemiesPackets do
			_callback(_v, _k - 1, EnemiesPackets)
		end
		-- ▲ ReadonlyArray.forEach ▲
	end)
	ClientEvents.EntityRemoved:connect(function(EnemyId)
		local EntityCharacter = (World:get(EnemyId, Character))
		if EntityCharacter then
			EntityCharacter.Model:Destroy()
		end
		World:despawn(EnemyId)
		DestroyEnemyUI(EnemyId)
	end)
end
return EnemiesReplication
