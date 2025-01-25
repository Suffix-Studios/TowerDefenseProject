-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _ui_labs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "ui-labs", "src")
local Choose = _ui_labs.Choose
local Slider = _ui_labs.Slider
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local EnemyHealthUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Components", "EnemyOverhead").EnemyHealthUI
local CreateVideWithAtomsStory = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Stories", "StoryCreator").CreateVideWithAtomsStory
local controls = {
	Health = Slider(100, 0, 100, 1),
	HealthAmountType = Choose({ "Number Only", "Number Over Max", "Percentage" }),
}
local story = CreateVideWithAtomsStory(controls, function(Controls, Parent)
	Vide.jsx(EnemyHealthUI, {
		Health = Controls.Health,
		TextType = Controls.HealthAmountType,
		Parent = Parent,
	})
end)
return story
