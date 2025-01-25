-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local _index_ts = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "init.ts")
local GlobalEvents = _index_ts.GlobalEvents
local GlobalFunctions = _index_ts.GlobalFunctions
local ServerEvents = GlobalEvents:createServer({}, {
	incomingIds = { "PlaceTower" },
	incoming = {
		PlaceTower = { { t.Vector3, t.Vector3, t.literal("Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6") }, nil },
	},
	incomingUnreliable = {},
	outgoingIds = { "ReplicateData", "ReplicateEnemies", "EnemyAdded", "TowerAdded", "EntityRemoved" },
	outgoingUnreliable = {},
	namespaceIds = {},
	namespaces = {},
})
local ServerFunctions = GlobalFunctions:createServer({}, {
	incomingIds = { "RequestData" },
	incoming = {
		RequestData = { {}, nil },
	},
	outgoingIds = {},
	outgoing = {},
	namespaceIds = {},
	namespaces = {},
})
return {
	ServerEvents = ServerEvents,
	ServerFunctions = ServerFunctions,
}
