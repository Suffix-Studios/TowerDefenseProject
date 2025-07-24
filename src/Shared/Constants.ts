import { Shared } from "./Types";

export const PlayerDataTemplate = {
	Gold: 0,
	Silver: 100,

	Level: 1,
	Exp: 0,

	MaxTowers: 60,

	TowersInventory: new Map<string, Shared.InventoryTower>([
		["T1", { Name: "TestTower_Single", Level: 1, Exp: 0 }],
		["T2", { Name: "TestTower_Full", Level: 1, Exp: 0 }],
	]),
	Loadout: ["T1", "T2", "", "", "", ""],
};
