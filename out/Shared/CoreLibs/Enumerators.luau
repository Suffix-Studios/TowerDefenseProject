-- Compiled with roblox-ts v3.0.0
local Enumerators = {
	EnemyType = {
		Normal = 0,
		Speedy = 1,
		Tanky = 2,
		Boss = 3,
	},
	TowerPriority = {
		First = 0,
		Last = 1,
		Closest = 2,
		Furthest = 3,
		Strongest = 4,
		Weakest = 5,
	},
	Slot = {
		["Slot 1"] = "Slot 1",
		["Slot 2"] = "Slot 2",
		["Slot 3"] = "Slot 3",
		["Slot 4"] = "Slot 4",
		["Slot 5"] = "Slot 5",
		["Slot 6"] = "Slot 6",
	},
	SystemPriorty = {
		Critical = -2,
		High = -1,
		Default = 0,
		Low = 1,
		Background = 2,
	},
}
return Enumerators
