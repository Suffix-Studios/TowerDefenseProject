-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local Workspace = _services.Workspace
local _PlacementUtils = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Placement", "PlacementUtils")
local RaycastFromMouse = _PlacementUtils.RaycastFromMouse
local TogglePlacedTowersHitbox = _PlacementUtils.TogglePlacedTowersHitbox
local TowersInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "TowersInfo")
local TowerRangeDisplay = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Entities", "ClientTower", "RangeDisplay")
local ClientEvents = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "ClientNetworking").ClientEvents
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ValidPlacementRangeColor = "6acbff"
local InvalidPlacementRangeColor = "ff0000"
local TowersModels = ReplicatedStorage:FindFirstChild("TowersModels")
local Placement
local Placement = {}
do
	local _container = Placement
	local _hollow
	local _placementConnection
	local _rangeDisplay
	local GetMouseRayParams = function(ignoreModel)
		local Character = Player.Character
		local MouseRayParams = RaycastParams.new()
		MouseRayParams.FilterType = Enum.RaycastFilterType.Exclude
		MouseRayParams.FilterDescendantsInstances = { Character, ignoreModel }
		return MouseRayParams
	end
	local GetPlacementModel = function(ModelName)
		local TowerModel = TowersModels:FindFirstChild(ModelName)
		if TowerModel then
			TowerModel = TowerModel:Clone()
			for _, Descendant in pairs(TowerModel:GetDescendants()) do
				if Descendant:IsA("BasePart") and not Descendant:HasTag("RedArea") then
					Descendant.Material = Enum.Material.ForceField
					Descendant.Transparency = 0.4
				end
			end
			TowerModel.Parent = Workspace
			local RayResult = RaycastFromMouse(GetMouseRayParams(TowerModel))
			local _towerModel = TowerModel
			local _result = RayResult
			if _result ~= nil then
				_result = _result.Position
			end
			_towerModel:PivotTo(CFrame.new(_result))
			return TowerModel
		end
		return nil
	end
	local Start = function(TowerName)
		local _towerName = TowerName
		local TowerInfo = TowersInfo[_towerName]
		if not TowerInfo then
			return nil
		end
		print("Started Placing")
		_hollow = GetPlacementModel(TowerName)
		local _result = _hollow
		if _result ~= nil then
			_result = _result:GetPivot().Position
		end
		_rangeDisplay = TowerRangeDisplay.new(_result, Color3.fromHex(ValidPlacementRangeColor), TowerInfo.Range)
		_container.isPlacing = true
		TogglePlacedTowersHitbox(true)
		_placementConnection = RunService.RenderStepped:Connect(function()
			local RayResult = RaycastFromMouse(GetMouseRayParams(_hollow))
			if RayResult then
				local RayCFrame = CFrame.new(RayResult.Position)
				local _result_1 = _hollow
				if _result_1 ~= nil then
					_result_1 = _result_1:GetPivot():Lerp(RayCFrame, 0.15)
				end
				local newCFrame = _result_1
				local _result_2 = _hollow
				if _result_2 ~= nil then
					_result_2:PivotTo(newCFrame)
				end
				local _result_3 = _rangeDisplay
				if _result_3 ~= nil then
					_result_3:SetPosition(newCFrame.Position)
				end
				if RayResult.Instance:HasTag(TowerInfo.Type) then
					local _result_4 = _rangeDisplay
					if _result_4 ~= nil then
						_result_4.Color(Color3.fromHex(ValidPlacementRangeColor))
					end
				else
					local _result_4 = _rangeDisplay
					if _result_4 ~= nil then
						_result_4.Color(Color3.fromHex(InvalidPlacementRangeColor))
					end
				end
			end
		end)
	end
	_container.Start = Start
	local Stop = function()
		if not Placement.isPlacing then
			return nil
		end
		print("Stopped Placing")
		TogglePlacedTowersHitbox(false)
		_placementConnection:Disconnect()
		Placement.isPlacing = false
		Placement.CurrentSlot = nil
		local _result = _hollow
		if _result ~= nil then
			_result:Destroy()
		end
		_hollow = nil
		local _result_1 = _rangeDisplay
		if _result_1 ~= nil then
			_result_1:Destroy()
		end
		_rangeDisplay = nil
	end
	_container.Stop = Stop
	local Place = function()
		local _TargetCFrame = _hollow
		if _TargetCFrame ~= nil then
			_TargetCFrame = _TargetCFrame:GetPivot()
		end
		local TargetCFrame = _TargetCFrame
		if Placement.CurrentSlot ~= nil then
			ClientEvents.PlaceTower:fire(Camera.CFrame, TargetCFrame, Placement.CurrentSlot)
			Placement.Stop()
		end
	end
	_container.Place = Place
end
return Placement
