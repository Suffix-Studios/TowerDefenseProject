import ClientTypes from "Client/Modules/ClientTypes";
import ClientData from "Client/Modules/Data";
import InputManager from "Client/Modules/InputManager";
import Enumerators from "Shared/CoreLibs/Enumerators";
import Placement from "./Placement";

const HandleAction = (InputAction: ClientTypes.InputAction): void => {
	const SplittedActionName = InputAction.Action.split(" ");
	if (SplittedActionName[0] === "Slot") {
		const PlayerLoadout = ClientData.Data["Loadout" as keyof typeof ClientData.Data] as Map<string, string>;
		const PlayerTowersInventory = ClientData.Data["TowersInventory" as keyof typeof ClientData.Data] as Map<
			string,
			object
		>;

		if (PlayerLoadout.get(InputAction.Action) !== "") {
			const Tower = PlayerTowersInventory.get(PlayerLoadout.get(InputAction.Action) as string) as {
				Name: string;
			};

			if (Placement.CurrentSlot === undefined) {
				Placement.Start(Tower.Name);
				Placement.CurrentSlot = InputAction.Action as keyof typeof Enumerators.Slot;
			} else if (Placement.CurrentSlot === InputAction.Action) {
				Placement.Stop();
			} else {
				Placement.Stop();
				Placement.Start(Tower.Name);

				Placement.CurrentSlot = InputAction.Action as keyof typeof Enumerators.Slot;
			}
		}
	}
};

const OnClick = (InputAction: ClientTypes.InputAction): void => {
	if (!Placement.isPlacing) return;

	Placement.Place();
};

InputManager.ListenToAction("Click").Connect((InputAction) => OnClick(InputAction));
InputManager.ActionBegan.Connect((InputAction) => HandleAction(InputAction));
