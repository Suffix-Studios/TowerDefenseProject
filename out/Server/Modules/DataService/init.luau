-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--/ Services
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService = _services.HttpService
local Players = _services.Players
local RunService = _services.RunService
--/ Packages
local ProfileService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "profileservice", "src")
local TowersInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "TowersInfo")
local _ServerNetworking = TS.import(script, game:GetService("ServerScriptService"), "Modules", "ServerNetworking")
local ServerEvents = _ServerNetworking.ServerEvents
local ServerFunctions = _ServerNetworking.ServerFunctions
local DataTemplate = {
	Gold = 0,
	Silver = 100,
	Level = 1,
	Exp = 0,
	MaxTowers = 60,
	TowersInventory = {},
	Loadout = {
		["Slot 1"] = "",
		["Slot 2"] = "",
		["Slot 3"] = "",
		["Slot 4"] = "",
		["Slot 5"] = "",
		["Slot 6"] = "",
	},
}
local StartingTowers = { "TestTower_Single", "TestTower_Cone", "TestTower_Circle", "TestTower_Full" }
local ProfileStore = if RunService:IsStudio() then ProfileService.GetProfileStore("Players_Data_xxx0", DataTemplate).Mock else ProfileService.GetProfileStore("Players_Data_xxx0", DataTemplate)
local Profiles = {}
local GetUniqueTowerId = function(Player, TowerName)
	return `{TowerName}-{Player.UserId}_{HttpService:GenerateGUID(false)}`
end
local ReplicateData = function(Player, Data)
	ServerEvents.ReplicateData:fire(Player, Data)
end
-- eslint-disable-next-line @typescript-eslint/no-explicit-any
ServerFunctions.RequestData:setCallback(function(Player)
	local _player = Player
	if not (Profiles[_player] ~= nil) then
		for i = 1, 9 do
			task.wait(1)
			local _player_1 = Player
			if Profiles[_player_1] ~= nil then
				break
			end
		end
		local _player_1 = Player
		if not (Profiles[_player_1] ~= nil) then
			Player:Kick("Player Data Couldn't Be Loaded.")
		end
		local _player_2 = Player
		local _result = Profiles[_player_2]
		if _result ~= nil then
			_result = _result.Data
		end
		return _result
	end
end)
local DataService
local DataService = {}
do
	local _container = DataService
	local LoadProfile = function(Player)
		local PlayerProfile = ProfileStore:LoadProfileAsync(`Player_{Player.UserId}`)
		if PlayerProfile then
			PlayerProfile:AddUserId(Player.UserId)
			PlayerProfile:Reconcile()
			PlayerProfile:ListenToRelease(function()
				local _player = Player
				Profiles[_player] = nil
				Player:Kick("Player Profile Released! Rejoin If This Is An Error.")
			end)
			if Player:IsDescendantOf(Players) then
				local _player = Player
				Profiles[_player] = PlayerProfile
				-- ▼ ReadonlyMap.size ▼
				local _size = 0
				for _ in PlayerProfile.Data.TowersInventory do
					_size += 1
				end
				-- ▲ ReadonlyMap.size ▲
				if _size == 0 then
					for i = 0, #StartingTowers - 1 do
						local newTower = DataService.GiveTower(Player, StartingTowers[i + 1])
						if newTower ~= nil then
							local _loadout = PlayerProfile.Data.Loadout
							local _arg0 = `Slot {i + 1}`
							_loadout[_arg0] = newTower
						end
					end
				end
			else
				Player:Kick("Data Wasn't Loaded Successfully! Try Again Later.")
			end
		end
	end
	_container.LoadProfile = LoadProfile
	local UnloadProfile = function(Player)
		local _player = Player
		local PlayerProfile = Profiles[_player]
		if PlayerProfile then
			PlayerProfile:Release()
		end
	end
	_container.UnloadProfile = UnloadProfile
	local GiveTower = function(Player, TowerName)
		local _player = Player
		local PlayerProfile = Profiles[_player]
		local _towerName = TowerName
		local Info = TowersInfo[_towerName]
		if Info and PlayerProfile then
			local newTower = {
				Exp = 0,
				Name = TowerName,
				Level = 1,
			}
			local TowerId = GetUniqueTowerId(Player, TowerName)
			PlayerProfile.Data.TowersInventory[TowerId] = newTower
			return TowerId
		end
		return nil
	end
	_container.GiveTower = GiveTower
	local GetData = function(Player)
		local _player = Player
		local PlayerProfile = Profiles[_player]
		if PlayerProfile then
			return PlayerProfile.Data
		else
			return nil
		end
	end
	_container.GetData = GetData
	-- eslint-disable-next-line @typescript-eslint/no-explicit-any
	local SetData = function(Player, DataName, newValue)
		local _player = Player
		local PlayerProfile = Profiles[_player]
		if PlayerProfile then
			print(PlayerProfile.Data)
			local _arg0 = PlayerProfile.Data[DataName] ~= nil
			local _arg1 = `Invalid Argument #2, Player Has No Data With Name {DataName}!`
			assert(_arg0, _arg1)
			local _exp = PlayerProfile.Data[DataName]
			local _newValue = newValue
			local _arg1_1 = typeof(_newValue)
			local _arg0_1 = typeof(_exp) == _arg1_1
			assert(_arg0_1, "Invalid Argument #3")
			PlayerProfile.Data[DataName] = newValue
			ReplicateData(Player, PlayerProfile.Data)
		end
	end
	_container.SetData = SetData
end
return DataService
