import { Atom } from "@rbxts/charm";
import ClientData from "Client/Modules/Data";
import InputManager from "Client/Modules/InputManager";
import { Client, Shared } from "Shared/Types";
import Placement from "./Placement";

const handleAction = (InputAction: Client.InputAction): void => {
	const slotNum = tonumber(InputAction.Action);

	if (slotNum !== undefined) {
		const playerLoadout = ClientData.data.get("Loadout") as Atom<Shared.PlayerData["Loadout"]>;
		const playerTowersInventory = ClientData.data.get("TowersInventory") as Atom<
			Shared.PlayerData["TowersInventory"]
		>;

		if ((playerLoadout() as string[])[slotNum] !== "") {
			const tower = (playerTowersInventory() as Shared.PlayerData["TowersInventory"])?.get(
				(playerLoadout() as string[])[slotNum] as string,
			) as {
				Name: string;
			};

			if (Placement.currentSlot === undefined) {
				Placement.Start(tower.Name);
				Placement.currentSlot = slotNum;
			} else if (Placement.currentSlot === slotNum) {
				Placement.Stop();
			} else {
				Placement.Stop();
				Placement.Start(tower.Name);

				Placement.currentSlot = slotNum;
			}
		}
	}
};

const onClick = (): void => {
	if (!Placement.isPlacing) return;

	Placement.Place();
};

InputManager.listenToAction("Click").Connect(() => onClick());
InputManager.actionBegan.Connect((InputAction) => handleAction(InputAction));
