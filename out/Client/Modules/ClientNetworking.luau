-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local _Networking = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Networking")
local GlobalEvents = _Networking.GlobalEvents
local GlobalFunctions = _Networking.GlobalFunctions
local ClientEvents = GlobalEvents:createClient({}, {
	incomingIds = { "ReplicateData", "ReplicateEnemies", "EntityAdded", "EntityRemoved" },
	incoming = {
		ReplicateData = { { t.any }, nil },
		ReplicateEnemies = { { t.string }, nil },
		EntityAdded = { { t.string, t.union(t.interface({
			Id = t.optional(t.string),
			ModelName = t.string,
			Health = t.number,
			IsAir = t.boolean,
			EnemyType = t.literal("Normal", "Speedy", "Tanky", "Boss"),
			Speed = t.number,
			SpawnCFrame = t.CFrame,
		}), t.any) }, nil },
		EntityRemoved = { { t.string, t.string }, nil },
	},
	incomingUnreliable = {},
	outgoingIds = { "PlaceTower" },
	outgoingUnreliable = {},
	namespaceIds = {},
	namespaces = {},
})
local ClientFunctions = GlobalFunctions:createClient({}, {
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
	ClientEvents = ClientEvents,
	ClientFunctions = ClientFunctions,
}
