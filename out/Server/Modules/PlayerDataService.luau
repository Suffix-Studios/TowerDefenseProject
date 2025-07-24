-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--/ Services
local Lyra = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lyra")
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local RunService = _services.RunService
local Sift = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "sift", "out")
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local PlayerDataTemplate = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "Constants").PlayerDataTemplate
local PlayerData = TS.import(script, game:GetService("ServerScriptService"), "Modules", "Network").PlayerData
local isMock = RunService:IsStudio()
local function createLogger()
	if RunService:IsStudio() then
		return function(message)
			print(`[Lyra][{message.level}] {message.message}`)
			if message.context ~= nil then
				print("Context:", message.context)
			end
		end
	else
		return function(message)
			if message.level == "error" or message.level == "fatal" then
				warn(`[Lyra] {message.message}`)
			end
		end
	end
end
local replicationCallback = function(userId, newData, oldData)
	local player = Players:GetPlayerByUserId(tonumber(userId))
	if not player then
		return nil
	end
	if oldData == nil then
		PlayerData.replicateData.fire(player, newData)
		return nil
	end
	local changedDataFields = {}
	for key, value in pairs(newData) do
		if typeof(value) == "table" then
			if not Sift.List.equalsDeep(value, oldData[key]) then
				changedDataFields[key] = value
			end
		elseif value ~= oldData[key] then
			changedDataFields[key] = value
		end
	end
	PlayerData.replicateData.fire(player, changedDataFields)
end
local store = Lyra.createPlayerStore({
	name = `PlayerData{if isMock then "_Mock" else ""}x0`,
	template = PlayerDataTemplate,
	schema = t.strictInterface({
		Gold = t.number,
		Silver = t.number,
		Level = t.number,
		Exp = t.number,
		MaxTowers = t.number,
		TowersInventory = t.map(t.string, t.strictInterface({
			Name = t.string,
			Level = t.number,
			Exp = t.number,
		})),
		Loadout = t.array(t.string),
	}),
	changedCallbacks = { replicationCallback },
	logCallback = createLogger(),
})
Players.PlayerAdded:Connect(function(player)
	return store:loadAsync(player)
end)
Players.PlayerRemoving:Connect(function(player)
	return store:unloadAsync(player)
end)
game:BindToClose(function()
	store:closeAsync()
end)
return {
	store = store,
}
