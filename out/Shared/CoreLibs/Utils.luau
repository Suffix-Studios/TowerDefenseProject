-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local GetYConst = function(IncludePaths)
	local Map = Workspace:FindFirstChild(`{Workspace:GetAttribute("MapName")}_Map`)
	local _result = Map
	if _result ~= nil then
		_result = _result:FindFirstChild("Waypoints")
	end
	local Waypoints = _result
	local SpawnWaypoint = Waypoints:FindFirstChild("Spawn")
	local Paths = Map:FindFirstChild("Paths")
	local _position = SpawnWaypoint:GetPivot().Position
	local _vector3 = Vector3.new(0, 0, 10)
	local RayOrigin = _position + _vector3
	local RayDirection = Vector3.new(0, -100, 0)
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Include
	Params.FilterDescendantsInstances = { Map:FindFirstChild("Ground") }
	if IncludePaths then
		local _exp = Params.FilterDescendantsInstances
		table.insert(_exp, Paths)
	end
	local RayResult = Workspace:Raycast(RayOrigin, RayDirection, Params)
	return if RayResult == nil then 0 else RayResult.Position.Y
end
local ConstYPaths = GetYConst(true)
local ConstY = GetYConst(false)
local Utils = {}
do
	local _container = Utils
	local GetConstantYPosition = function(IncludePaths)
		return if IncludePaths then ConstYPaths else ConstY
	end
	_container.GetConstantYPosition = GetConstantYPosition
end
return Utils
