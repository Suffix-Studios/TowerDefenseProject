import { UserInputService } from "@rbxts/services";
import InputManager from ".";
import Actions from "./Actions";

const handleInput = (input: InputObject, gameProcessedEvent: boolean): void => {
	if (gameProcessedEvent) return;

	Actions.forEach((actionBindings, actionName) => {
		if (actionBindings.find((Binding) => Binding === input.KeyCode || Binding === input.UserInputType)) {
			const Key = input.KeyCode !== Enum.KeyCode.Unknown ? input.KeyCode : input.UserInputType;

			InputManager.invokeAction(actionName, input.UserInputState, Key);
		}
	});
};

UserInputService.InputBegan.Connect((input, gameProcessedEvent) => handleInput(input, gameProcessedEvent));
UserInputService.InputEnded.Connect((input, gameProcessedEvent) => handleInput(input, gameProcessedEvent));
