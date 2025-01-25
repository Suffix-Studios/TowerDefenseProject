import PublicTypes from "./CoreLibs/PublicTypes";

export const PlayerDataTemplate = {
	Gold: 0,
	Silver: 100,

	Level: 1,
	Exp: 0,

	MaxTowers: 60,

	TowersInventory: new Map<string, PublicTypes.InventoryTower>(),
	Loadout: new Map<string, string>([
		["Slot 1", ""],
		["Slot 2", ""],
		["Slot 3", ""],
		["Slot 4", ""],
		["Slot 5", ""],
		["Slot 6", ""],
	]),
};
