import Signal from "@rbxts/lemon-signal";
import { InputAction } from "../ClientTypes";
import Actions from "./Actions";
import { UserInputService } from "@rbxts/services";

abstract class InputManager {
    public static readonly ActionBegan = new Signal<InputAction>();
    public static readonly ActionEnded = new Signal<InputAction>();
    private static _actionsSignals = new Map<string, Signal<InputAction>>();

    public static InvokeAction(this: void, ActionName: string, State: Enum.UserInputState, Key: Enum.KeyCode | Enum.UserInputType | undefined): void {
        assert(Actions.has(ActionName), `Invalid Action Name, Not Valid Action With Name ${ActionName}`);

        const ActionInfo: InputAction = {
            Action: ActionName,
            State: State,
            Key: Key === undefined ? Key as unknown as Enum.KeyCode : Enum.KeyCode.Unknown
        }

        if(State === Enum.UserInputState.Begin) InputManager.ActionBegan.Fire(ActionInfo)
            else InputManager.ActionEnded.Fire(ActionInfo);

        if(InputManager._actionsSignals.has(ActionName)) {
            InputManager._actionsSignals.get(ActionName)?.Fire(ActionInfo);
        }
    };

    public static BindActionToButton(this: void, Button: GuiButton, ActionName: string): void {
        if(!Button) return;

        Button.Activated.Connect(() => {
            InputManager.InvokeAction(ActionName, Enum.UserInputState.Begin, undefined);
        })
    };

    public static ListenToAction(this: void, ActionName: string): Signal<InputAction> {
        assert(Actions.has(ActionName), `Invalid Action Name, Not Valid Action With Name ${ActionName}`);

        let ActionSignal: Signal<InputAction>;

        if(InputManager._actionsSignals.has(ActionName)) {
            ActionSignal = InputManager._actionsSignals.get(ActionName) as Signal<InputAction>;
        } else {
            ActionSignal = new Signal<InputAction>();
            InputManager._actionsSignals.set(ActionName, ActionSignal);
        }

        return ActionSignal;
    }
}

export = InputManager;
