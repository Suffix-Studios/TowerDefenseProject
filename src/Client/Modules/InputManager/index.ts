import Signal from "@rbxts/lemon-signal";
import { UserInputService } from "@rbxts/services";
import { Client } from "Shared/Types";
import Actions from "./Actions";

namespace InputManager {
	export const actionBegan = new Signal<Client.InputAction>();
	export const actionEnded = new Signal<Client.InputAction>();
	const _actionsSignals = new Map<string, Signal<Client.InputAction>>();

	export const invokeAction = (
		ActionName: string,
		State: Enum.UserInputState,
		Key: Enum.KeyCode | Enum.UserInputType | undefined,
	): void => {
		assert(Actions.has(ActionName), `Invalid Action Name, Not Valid Action With Name ${ActionName}`);

		const actionInfo: Client.InputAction = {
			Action: ActionName,
			State: State,
			Key: Key === undefined ? (Key as unknown as Enum.KeyCode) : Enum.KeyCode.Unknown,
		};

		if (State === Enum.UserInputState.Begin) actionBegan.Fire(actionInfo);
		else actionEnded.Fire(actionInfo);

		if (_actionsSignals.has(ActionName)) {
			_actionsSignals.get(ActionName)?.Fire(actionInfo);
		}
	};

	export const listenToAction = (actionName: string): Signal<Client.InputAction> => {
		assert(Actions.has(actionName), `Invalid Action Name, Not Valid Action With Name ${actionName}`);

		let actionSignal: Signal<Client.InputAction>;

		if (_actionsSignals.has(actionName)) {
			actionSignal = _actionsSignals.get(actionName) as Signal<Client.InputAction>;
		} else {
			actionSignal = new Signal<Client.InputAction>();
			_actionsSignals.set(actionName, actionSignal);
		}

		return actionSignal;
	};

	export const isActionHeld = (actionName: string & keyof typeof Actions): boolean => {
		assert(Actions.has(actionName), "Invalid Action Name!");

		Actions.get(actionName)?.forEach((Key) => {
			if (UserInputService.IsKeyDown(Key as Enum.KeyCode)) return true;
		});

		return false;
	};
}

export = InputManager;
