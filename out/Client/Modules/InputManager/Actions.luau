-- Compiled with roblox-ts v3.0.0
local Actions = {
	Slots = {
		["1"] = { Enum.KeyCode.One },
		["2"] = { Enum.KeyCode.Two },
		["3"] = { Enum.KeyCode.Three },
		["4"] = { Enum.KeyCode.Four },
		["5"] = { Enum.KeyCode.Five },
		["6"] = { Enum.KeyCode.Six },
	},
	Interactions = {
		Click = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch },
	},
}
local actionsMap = {}
for _, actionsObject in pairs(Actions) do
	for actionName, actionBindings in pairs(actionsObject) do
		actionsMap[actionName] = actionBindings
	end
end
return actionsMap
