-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _ClientNetworking = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "ClientNetworking")
local ClientEvents = _ClientNetworking.ClientEvents
local ClientFunctions = _ClientNetworking.ClientFunctions
local ClientData = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Data")
ClientEvents.ReplicateData:connect(function(newData)
	ClientData.SetData(newData)
end)
--/ Init
ClientFunctions.RequestData:invoke():andThen(function(newData)
	return ClientData.SetData(newData)
end)
