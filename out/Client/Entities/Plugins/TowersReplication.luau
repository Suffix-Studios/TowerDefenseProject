-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage = _services.ReplicatedStorage
local Workspace = _services.Workspace
local ClientEvents = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "ClientNetworking").ClientEvents
local Character = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "Character").Character
local TowerInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").TowerInfo
local Enumerators = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators")
local newTowerPacketSerializer = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "BinarySerializers").newTowerPacketSerializer
local TowersModels = ReplicatedStorage:FindFirstChild("TowersModels")
local Animations = ReplicatedStorage:FindFirstChild("Animations")
local TowersReplication = function(World)
	ClientEvents.TowerAdded:connect(function(SerializedTowerPacket)
		local TowerPacket = newTowerPacketSerializer.deserialize(SerializedTowerPacket)
		local _result = TowersModels:FindFirstChild(TowerPacket.TowerName)
		if _result ~= nil then
			_result = _result:Clone()
		end
		local TowerModel = _result
		local Position = Vector3.new(TowerPacket.Position.X, TowerPacket.Position.Y, TowerPacket.Position.Z)
		TowerModel:PivotTo(CFrame.new(Position))
		TowerModel.Parent = Workspace:FindFirstChild("PlacedTowers")
		local AnimationController = TowerModel:FindFirstChild("AnimationController")
		local Animator = AnimationController:FindFirstChild("Animator")
		local AnimationTrack = Animator:LoadAnimation(Animations:FindFirstChild("TowerIdle"))
		AnimationTrack:Play()
		World:spawn(TowerInfo({
			TowerName = TowerPacket.TowerName,
			Owner = tonumber(TowerPacket.TowerName),
			Position = Position,
			Priority = Enumerators.TowerPriority.First,
			Upgrade = 0,
		}), Character({
			Model = TowerModel,
			Animation = AnimationTrack,
		}))
	end)
end
return TowersReplication
