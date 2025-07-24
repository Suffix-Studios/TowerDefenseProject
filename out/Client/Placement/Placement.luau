-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable roblox-ts/no-array-pairs 
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local Workspace = _services.Workspace
local Entities = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Network").Entities
local TowersInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "TowersInfo")
local _PlacementUtils = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Placement", "PlacementUtils")
local GetScreenPointRay = _PlacementUtils.GetScreenPointRay
local raycastFromMouse = _PlacementUtils.raycastFromMouse
local togglePlacedTowersHitbox = _PlacementUtils.togglePlacedTowersHitbox
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
	local getMouseRayParams = function(ignoreModel)
		local mouseRayParams = RaycastParams.new()
		mouseRayParams.FilterType = Enum.RaycastFilterType.Exclude
		mouseRayParams.FilterDescendantsInstances = { Workspace:FindFirstChild("Enemies"), Player.Character, ignoreModel }
		return mouseRayParams
	end
	local getPlacementModel = function(modelName)
		local towerModel = TowersModels:FindFirstChild(modelName)
		if towerModel then
			towerModel = towerModel:Clone()
			for _, descendant in pairs(towerModel:GetDescendants()) do
				if descendant:IsA("BasePart") and not descendant:HasTag("RedArea") then
					descendant.Material = Enum.Material.ForceField
					descendant.Transparency = 0.4
				end
			end
			towerModel.Parent = Workspace
			local rayResult = raycastFromMouse(getMouseRayParams(towerModel))
			local _towerModel = towerModel
			local _result = rayResult
			if _result ~= nil then
				_result = _result.Position
			end
			_towerModel:PivotTo(CFrame.new(_result))
			return towerModel
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
		_hollow = getPlacementModel(TowerName)
		--/ Create Tower Range
		_container.isPlacing = true
		togglePlacedTowersHitbox(true)
		_placementConnection = RunService.RenderStepped:Connect(function()
			local RayResult = raycastFromMouse(getMouseRayParams(_hollow))
			if RayResult then
				local rayCFrame = CFrame.new(RayResult.Position)
				local _result = _hollow
				if _result ~= nil then
					_result = _result:GetPivot():Lerp(rayCFrame, 0.15)
				end
				local newCFrame = _result
				local _result_1 = _hollow
				if _result_1 ~= nil then
					_result_1:PivotTo(newCFrame)
				end
				--/ Adjust Tower Range Color
			end
		end)
	end
	_container.Start = Start
	local Stop = function()
		if not Placement.isPlacing then
			return nil
		end
		print("Stopped Placing")
		togglePlacedTowersHitbox(false)
		_placementConnection:Disconnect()
		Placement.isPlacing = false
		Placement.currentSlot = nil
		local _result = _hollow
		if _result ~= nil then
			_result:Destroy()
		end
		_hollow = nil
		--/ Destroy Tower Range
	end
	_container.Stop = Stop
	local Place = function()
		if Placement.currentSlot ~= nil then
			local Ray = GetScreenPointRay()
			Entities.Tower.placeTower.fire({
				Origin = Ray.Origin,
				Direction = Ray.Direction,
				Slot = Placement.currentSlot,
			})
			Placement.Stop()
		end
	end
	_container.Place = Place
end
return Placement
