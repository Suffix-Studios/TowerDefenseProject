/// Services
import Lyra from "@rbxts/lyra";
import { Players, RunService } from "@rbxts/services";
import Sift from "@rbxts/sift";
import { t } from "@rbxts/t";
import { PlayerDataTemplate } from "Shared/Constants";
import { Shared } from "Shared/Types";
import { PlayerData } from "./Network";

const isMock = RunService.IsStudio();

function createLogger() {
	if (RunService.IsStudio()) {
		return (message: { level: string; message: string; context?: unknown }) => {
			print(`[Lyra][${message.level}] ${message.message}`);
			if (message.context !== undefined) {
				print("Context:", message.context);
			}
		};
	} else {
		return (message: { level: string; message: string; context?: unknown }) => {
			if (message.level === "error" || message.level === "fatal") {
				warn(`[Lyra] ${message.message}`);
			}
		};
	}
}

const replicationCallback = (userId: string, newData: Shared.PlayerData, oldData?: Shared.PlayerData) => {
	const player = Players.GetPlayerByUserId(tonumber(userId) as number);
	if (!player) return;
	if (oldData === undefined) {
		PlayerData.replicateData.fire(player, newData);
		return;
	}

	const changedDataFields: { [key: string]: unknown } = {};
	for (const [key, value] of pairs(newData)) {
		if (typeOf(value) === "table") {
			if (!Sift.List.equalsDeep(value, (oldData as Shared.PlayerData)[key] as unknown)) {
				changedDataFields[key] = value;
			}
		} else if (value !== (oldData as Shared.PlayerData)[key]) {
			changedDataFields[key] = value;
		}
	}

	PlayerData.replicateData.fire(player, changedDataFields);
};

export const store = Lyra.createPlayerStore({
	name: `PlayerData${isMock ? "_Mock" : ""}x0`,
	template: PlayerDataTemplate,
	schema: t.strictInterface({
		Gold: t.number,
		Silver: t.number,

		Level: t.number,
		Exp: t.number,

		MaxTowers: t.number,

		TowersInventory: t.map(
			t.string,
			t.strictInterface({
				Name: t.string,
				Level: t.number,
				Exp: t.number,
			}),
		),
		Loadout: t.array(t.string),
	}),
	changedCallbacks: [replicationCallback],
	logCallback: createLogger(),
});

Players.PlayerAdded.Connect((player) => store.loadAsync(player));
Players.PlayerRemoving.Connect((player) => store.unloadAsync(player));

game.BindToClose(() => {
	store.closeAsync();
});
