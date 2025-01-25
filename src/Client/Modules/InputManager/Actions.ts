const Actions = {
	Slots: {
		"Slot 1": [Enum.KeyCode.One],
		"Slot 2": [Enum.KeyCode.Two],
		"Slot 3": [Enum.KeyCode.Three],
		"Slot 4": [Enum.KeyCode.Four],
		"Slot 5": [Enum.KeyCode.Five],
		"Slot 6": [Enum.KeyCode.Six],
	},

	Interactions: {
		Click: [Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch],
	},
};

const ActionsMap = new Map<string, Array<Enum.KeyCode | Enum.UserInputType>>();

for (const [_, ActionsObject] of pairs(Actions)) {
	for (const [ActionName, ActionBindings] of pairs(ActionsObject)) {
		ActionsMap.set(ActionName as string, ActionBindings as Array<Enum.KeyCode | Enum.UserInputType>);
	}
}

export = ActionsMap;
