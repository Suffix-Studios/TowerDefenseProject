-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local Start = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "start").Start
local _result = ReplicatedStorage:FindFirstChild("Modules")
if _result ~= nil then
	_result = _result:FindFirstChild("Systems")
end
local _result_1 = ReplicatedStorage:FindFirstChild("Client")
if _result_1 ~= nil then
	_result_1 = _result_1:FindFirstChild("Entities")
	if _result_1 ~= nil then
		_result_1 = _result_1:FindFirstChild("Systems")
	end
end
local _exp = { _result, _result_1 }
local _result_2 = ReplicatedStorage:FindFirstChild("Client")
if _result_2 ~= nil then
	_result_2 = _result_2:FindFirstChild("Entities")
	if _result_2 ~= nil then
		_result_2 = _result_2:FindFirstChild("Plugins")
	end
end
Start(_exp, _result_2)
