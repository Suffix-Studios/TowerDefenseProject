-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Networking = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking
-- eslint-disable-next-line @typescript-eslint/no-empty-object-type
local GlobalEvents = Networking.createEvent("Shared/CoreLibs/Networking/init.ts@GlobalEvents")
local GlobalFunctions = Networking.createFunction("Shared/CoreLibs/Networking/init.ts@GlobalFunctions")
return {
	GlobalEvents = GlobalEvents,
	GlobalFunctions = GlobalFunctions,
}
