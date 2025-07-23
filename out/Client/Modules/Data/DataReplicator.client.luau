-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ClientData = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Data")
local replicateData = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Network", "PlayerData").replicateData
replicateData.on(function(newData)
	ClientData.SetData(newData)
end)
--/ Init
-- requestData.invoke().andThen((newData) => ClientData.SetData(newData));
