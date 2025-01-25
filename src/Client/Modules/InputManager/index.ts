import Signal from "@rbxts/lemon-signal";
import { UserInputService } from "@rbxts/services";
import { InputAction } from "../ClientTypes";
import Actions from "./Actions";

namespace InputManager {
	export const ActionBegan = new Signal<InputAction>();
	export const ActionEnded = new Signal<InputAction>();
	const _actionsSignals = new Map<string, Signal<InputAction>>();

	export const InvokeAction = (
		ActionName: string,
		State: Enum.UserInputState,
		Key: Enum.KeyCode | Enum.UserInputType | undefined,
	): void => {
		assert(Actions.has(ActionName), `Invalid Action Name, Not Valid Action With Name ${ActionName}`);

		const ActionInfo: InputAction = {
			Action: ActionName,
			State: State,
			Key: Key === undefined ? (Key as unknown as Enum.KeyCode) : Enum.KeyCode.Unknown,
		};

		if (State === Enum.UserInputState.Begin) ActionBegan.Fire(ActionInfo);
		else ActionEnded.Fire(ActionInfo);

		if (_actionsSignals.has(ActionName)) {
			_actionsSignals.get(ActionName)?.Fire(ActionInfo);
		}
	};

	export const BindActionToButton = (Button: GuiButton, ActionName: string): void => {
		if (!Button) return;

		Button.Activated.Connect(() => {
			InvokeAction(ActionName, Enum.UserInputState.Begin, undefined);
		});
	};

	export const ListenToAction = (ActionName: string): Signal<InputAction> => {
		assert(Actions.has(ActionName), `Invalid Action Name, Not Valid Action With Name ${ActionName}`);

		let ActionSignal: Signal<InputAction>;

		if (_actionsSignals.has(ActionName)) {
			ActionSignal = _actionsSignals.get(ActionName) as Signal<InputAction>;
		} else {
			ActionSignal = new Signal<InputAction>();
			_actionsSignals.set(ActionName, ActionSignal);
		}

		return ActionSignal;
	};

	export const IsActionHeld = (ActionName: string & keyof typeof Actions): boolean => {
		assert(Actions.has(ActionName), "Invalid Action Name!");

		Actions.get(ActionName)?.forEach((Key) => {
			if (UserInputService.IsKeyDown(Key as Enum.KeyCode)) return true;
		});

		return false;
	};
}

export = InputManager;
