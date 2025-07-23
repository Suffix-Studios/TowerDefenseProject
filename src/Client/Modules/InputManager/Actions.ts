const Actions = {
	Slots: {
		"1": [Enum.KeyCode.One],
		"2": [Enum.KeyCode.Two],
		"3": [Enum.KeyCode.Three],
		"4": [Enum.KeyCode.Four],
		"5": [Enum.KeyCode.Five],
		"6": [Enum.KeyCode.Six],
	},

	Interactions: {
		Click: [Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch],
	},
};

const actionsMap = new Map<string, Array<Enum.KeyCode | Enum.UserInputType>>();

for (const [_, actionsObject] of pairs(Actions)) {
	for (const [actionName, actionBindings] of pairs(actionsObject)) {
		actionsMap.set(actionName as string, actionBindings as Array<Enum.KeyCode | Enum.UserInputType>);
	}
}

export = actionsMap;
