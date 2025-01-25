import { PlayerDataTemplate } from "Shared/Constants";

namespace PublicTypes {
	export type InventoryTower = {
		Exp: number;
		Name: string;
		Level: number;
	};

	export type PlayerData = typeof PlayerDataTemplate;
}

export = PublicTypes;
