-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local _Networking = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking")
local GlobalEvents = _Networking.GlobalEvents
local GlobalFunctions = _Networking.GlobalFunctions
local ServerEvents = GlobalEvents:createServer({}, {
	incomingIds = { "PlaceTower" },
	incoming = {
		PlaceTower = { { t.CFrame, t.CFrame, t.literal("Slot1", "Slot2", "Slot3", "Slot4", "Slot5", "Slot6") }, nil },
	},
	incomingUnreliable = {},
	outgoingIds = { "ReplicateData", "ReplicateEnemies", "EntityAdded", "EntityRemoved" },
	outgoingUnreliable = {},
	namespaceIds = {},
	namespaces = {},
})
local ServerFunctions = GlobalFunctions:createServer({}, {
	incomingIds = { "RequestData" },
	incoming = {
		RequestData = { {}, nil },
	},
	outgoingIds = { "RequestData" },
	outgoing = {
		RequestData = t.any,
	},
	namespaceIds = {},
	namespaces = {},
})
return {
	ServerEvents = ServerEvents,
	ServerFunctions = ServerFunctions,
}
