import { atom, Atom } from "@rbxts/charm";
import { Shared } from "Shared/Types";

namespace ClientData {
	export let isReady = false;
	export let data: Map<keyof Shared.PlayerData, Atom<unknown>>;

	export const SetData = (newData: Shared.PlayerData): void => {
		if (!newData) {
			return;
		}

		if (!isReady) {
			/// Init
			data = {} as typeof data;

			for (const [DataName, DataValue] of pairs(newData)) {
				data.set(DataName, atom(DataValue as unknown));
			}

			isReady = true;
			return;
		}

		data.forEach((DataAtom, DataName) => {
			DataAtom(newData[DataName]);
		});
	};
}

export = ClientData;
