-- Compiled with roblox-ts v3.0.0
local PlayerDataTemplate = {
	Gold = 0,
	Silver = 100,
	Level = 1,
	Exp = 0,
	MaxTowers = 60,
	TowersInventory = {
		T1 = {
			Name = "TestTower_Single",
			Level = 1,
			Exp = 0,
		},
		T2 = {
			Name = "TestTower_Full",
			Level = 1,
			Exp = 0,
		},
	},
	Loadout = { "T1", "T2", "", "", "", "" },
}
return {
	PlayerDataTemplate = PlayerDataTemplate,
}
