-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Networking = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking
local GlobalEvents = Networking.createEvent("Shared/CoreLibs/Networking@GlobalEvents")
local GlobalFunctions = Networking.createFunction("Shared/CoreLibs/Networking@GlobalFunctions")
return {
	GlobalEvents = GlobalEvents,
	GlobalFunctions = GlobalFunctions,
}
