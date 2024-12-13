-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local Workspace = _services.Workspace
local Enemy = TS.import(script, game:GetService("ServerScriptService"), "Modules", "Entities", "Enemy")
local EntitiesHandler = TS.import(script, game:GetService("ServerScriptService"), "Modules", "EntitiesHandler")
local _result = ReplicatedStorage:FindFirstChild("Modules")
if _result ~= nil then
	_result = _result:FindFirstChild("Waves")
end
local WavesFolder = _result
--/! REWORK
Workspace:SetAttribute("MapName", `DesertMap`)
local _result_1 = Workspace:FindFirstChild("DesertMap")
if _result_1 ~= nil then
	_result_1 = _result_1:FindFirstChild("Waypoints")
	if _result_1 ~= nil then
		_result_1 = _result_1:FindFirstChild("Spawn")
	end
end
local SpawnPart = _result_1
Workspace:SetAttribute("MapName", "DesertMap")
if not RunService.IsStudio then
	local _result_2 = Workspace:FindFirstChild("DesertMap")
	if _result_2 ~= nil then
		_result_2 = _result_2:FindFirstChild("Waypoints")
		if _result_2 ~= nil then
			local _exp = _result_2:GetChildren()
			-- ▼ ReadonlyArray.forEach ▼
			local _callback = function(Child, _)
				local C = Child
				C.Transparency = 1
			end
			for _k, _v in _exp do
				_callback(_v, _k - 1, _exp)
			end
			-- ▲ ReadonlyArray.forEach ▲
		end
	end
end
task.wait(10)
for i = 0, 1000 do
	local newEnemy = Enemy.new({
		Id = nil,
		ModelName = "TestEnemy",
		Health = Random.new():NextInteger(10, 1000),
		IsAir = false,
		EnemyType = "Normal",
		Speed = 1,
		SpawnCFrame = SpawnPart:GetPivot(),
	})
	EntitiesHandler.AddEnemy(newEnemy)
	task.wait(0.5)
end
