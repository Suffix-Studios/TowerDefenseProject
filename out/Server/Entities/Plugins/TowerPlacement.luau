-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local DataService = TS.import(script, game:GetService("ServerScriptService"), "Modules", "DataService")
local ServerEvents = TS.import(script, game:GetService("ServerScriptService"), "Modules", "ServerNetworking").ServerEvents
local TowerInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").TowerInfo
local Enumerators = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators")
local newTowerPacketSerializer = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "BinarySerializers").newTowerPacketSerializer
local TowersInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "TowersInfo")
local IsCloseToOtherTowers = function(World, Position)
	for id, EntityTowerInfo in World:query(TowerInfo) do
		local _position = EntityTowerInfo.Position
		local _position_1 = Position
		if (_position - _position_1).Magnitude <= 2.5 then
			return true
		end
	end
	return false
end
local IsValidPlacement = function(Player, PlacementType, RayOrigin, RayDirection)
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = { Player.Character }
	local Raycast = Workspace:Raycast(RayOrigin, RayDirection * 100, Params)
	local _result = Raycast
	if _result ~= nil then
		_result = _result.Instance:HasTag(PlacementType)
	end
	local _condition = _result
	if not _condition then
		_condition = false
	end
	local _result_1 = Raycast
	if _result_1 ~= nil then
		_result_1 = _result_1.Position
	end
	return _condition, _result_1
end
local TowerPlacement = function(World)
	ServerEvents.PlaceTower:connect(function(Player, RayOrigin, RayDirection, Slot)
		local PlayerData = DataService.GetData(Player)
		local _PlayerLoadout = PlayerData
		if _PlayerLoadout ~= nil then
			_PlayerLoadout = _PlayerLoadout.Loadout
		end
		local PlayerLoadout = _PlayerLoadout
		local _PlayerTowersInventory = PlayerData
		if _PlayerTowersInventory ~= nil then
			_PlayerTowersInventory = _PlayerTowersInventory.TowersInventory
		end
		local PlayerTowersInventory = _PlayerTowersInventory
		if PlayerLoadout and PlayerTowersInventory then
			local _slot = Slot
			local TowerId = PlayerLoadout[_slot]
			local TowerInInventory = PlayerTowersInventory[TowerId]
			local TowerName = TowerInInventory.Name
			local TargetTowerInfo = TowersInfo[TowerName]
			local _exp = Player
			local _result = TargetTowerInfo
			if _result ~= nil then
				_result = _result.Type
			end
			local RaycastResult = { IsValidPlacement(_exp, _result, RayOrigin, RayDirection) }
			local IsValid = RaycastResult[1]
			if not IsValid or IsCloseToOtherTowers(World, RaycastResult[2]) then
				return nil
			end
			World:spawn(TowerInfo({
				TowerName = TowerName,
				Owner = Player.UserId,
				Upgrade = 0,
				Position = RaycastResult[2],
				Priority = Enumerators.TowerPriority.First,
			}))
			local TowerPacket = newTowerPacketSerializer.serialize({
				Position = {
					X = RaycastResult[2].X,
					Y = RaycastResult[2].Y,
					Z = RaycastResult[2].Z,
				},
				Owner = tostring(Player.UserId),
				TowerName = TowerName,
			})
			ServerEvents.TowerAdded:broadcast(TowerPacket.buffer)
		end
	end)
end
return TowerPlacement
