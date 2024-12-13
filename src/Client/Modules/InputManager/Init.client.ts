import { UserInputService } from "@rbxts/services";
import InputManager from ".";
import Actions from "./Actions";

const HandleInput = (Input: InputObject, gameProcessedEvent: boolean): void => {
    if(gameProcessedEvent) return;

    Actions.forEach((ActionBindings, ActionName) => {
        if(ActionBindings.find((Binding) => Binding === Input.KeyCode || Binding === Input.UserInputType)) {
            const Key = Input.KeyCode !== Enum.KeyCode.Unknown ? Input.KeyCode : Input.UserInputType;

            InputManager.InvokeAction(ActionName, Input.UserInputState, Key);
        }
    })
};

UserInputService.InputBegan.Connect((Input, gameProcessedEvent) => HandleInput(Input, gameProcessedEvent));
UserInputService.InputEnded.Connect((Input, gameProcessedEvent) => HandleInput(Input, gameProcessedEvent));
