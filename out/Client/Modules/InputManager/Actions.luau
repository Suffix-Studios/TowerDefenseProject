-- Compiled with roblox-ts v3.0.0
local Actions = {
	Slots = {
		["Slot 1"] = { Enum.KeyCode.One },
		["Slot 2"] = { Enum.KeyCode.Two },
		["Slot 3"] = { Enum.KeyCode.Three },
		["Slot 4"] = { Enum.KeyCode.Four },
		["Slot 5"] = { Enum.KeyCode.Five },
		["Slot 6"] = { Enum.KeyCode.Six },
	},
	Interactions = {
		Click = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch },
	},
}
local ActionsMap = {}
for ActionsCategory, ActionsObject in pairs(Actions) do
	for ActionName, ActionBindings in pairs(ActionsObject) do
		ActionsMap[ActionName] = ActionBindings
	end
end
return ActionsMap
