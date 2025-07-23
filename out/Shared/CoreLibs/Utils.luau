-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local getYConst = function(includePaths)
	local map = Workspace:FindFirstChild(`{Workspace:GetAttribute("MapName")}_Map`)
	local _result = map
	if _result ~= nil then
		_result = _result:FindFirstChild("Waypoints")
	end
	local waypoints = _result
	local spawnWaypoint = waypoints:FindFirstChild("Spawn")
	local paths = map:FindFirstChild("Paths")
	local _position = spawnWaypoint:GetPivot().Position
	local _vector3 = Vector3.new(0, 0, 10)
	local rayOrigin = _position + _vector3
	local rayDirection = Vector3.new(0, -100, 0)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { map:FindFirstChild("Ground") }
	if includePaths then
		local _exp = params.FilterDescendantsInstances
		table.insert(_exp, paths)
	end
	local rayResult = Workspace:Raycast(rayOrigin, rayDirection, params)
	return if rayResult == nil then 0 else rayResult.Position.Y
end
local constYPaths = getYConst(true)
local constY = getYConst(false)
local Utils = {}
do
	local _container = Utils
	local GetConstantYPosition = function(IncludePaths)
		return if IncludePaths then constYPaths else constY
	end
	_container.GetConstantYPosition = GetConstantYPosition
end
return Utils
