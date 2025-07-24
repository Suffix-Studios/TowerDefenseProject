import { atom, Atom } from "@rbxts/charm";
import { Shared } from "Shared/Types";

namespace ClientData {
	export let isReady = false;
	export let data: Map<keyof Shared.PlayerData, Atom<Shared.PlayerData[keyof Shared.PlayerData]>>;

	export const SetData = (newData: Shared.PlayerData): void => {
		if (!newData) {
			return;
		}

		if (!isReady) {
			/// Init
			data = {} as typeof data;

			for (const [DataName, DataValue] of pairs(newData)) {
				data.set(DataName, atom(DataValue as Shared.PlayerData[keyof Shared.PlayerData]));
			}

			isReady = true;
			return;
		}

		for (const [dataKey, dataValue] of pairs(newData)) {
			data.get(dataKey as keyof Shared.PlayerData)?.(dataValue);
		}
	};
}

export = ClientData;
