-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local _index_ts = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking", "init.ts")
local GlobalEvents = _index_ts.GlobalEvents
local GlobalFunctions = _index_ts.GlobalFunctions
local ClientEvents = GlobalEvents:createClient({}, {
	incomingIds = { "ReplicateData", "ReplicateEnemies", "EnemyAdded", "TowerAdded", "EntityRemoved" },
	incoming = {
		ReplicateData = { { t.union(t.any, t.none) }, nil },
		ReplicateEnemies = { { t.array(t.typeof("buffer")) }, nil },
		EnemyAdded = { { t.typeof("buffer") }, nil },
		TowerAdded = { { t.typeof("buffer") }, nil },
		EntityRemoved = { { t.number }, nil },
	},
	incomingUnreliable = {},
	outgoingIds = { "PlaceTower" },
	outgoingUnreliable = {},
	namespaceIds = {},
	namespaces = {},
})
local ClientFunctions = GlobalFunctions:createClient({}, {
	incomingIds = {},
	incoming = {},
	outgoingIds = { "RequestData" },
	outgoing = {
		RequestData = t.union(t.any, t.none),
	},
	namespaceIds = {},
	namespaces = {},
})
return {
	ClientEvents = ClientEvents,
	ClientFunctions = ClientFunctions,
}
