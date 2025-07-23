import { Shared } from "./Types";

export const PlayerDataTemplate = {
	Gold: 0,
	Silver: 100,

	Level: 1,
	Exp: 0,

	MaxTowers: 60,

	TowersInventory: new Map<string, Shared.InventoryTower>(),
	Loadout: ["", "", "", "", "", ""],
};
