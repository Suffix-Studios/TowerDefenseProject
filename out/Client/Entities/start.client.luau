-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local loadDirectories = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Scheduler").loadDirectories
local _result = script.Parent
if _result ~= nil then
	_result = _result:FindFirstChild("Systems")
end
local clientSystems = _result
loadDirectories({ clientSystems })
