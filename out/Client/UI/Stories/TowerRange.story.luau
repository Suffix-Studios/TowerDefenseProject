-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local TowerRangeUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Components", "TowerRange").TowerRangeUI
local CreateVideWithAtomsStory = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Stories", "StoryCreator").CreateVideWithAtomsStory
local controls = {
	Color = Color3.fromHex("FFFFFF"),
}
local story = CreateVideWithAtomsStory(controls, function(Controls, Parent)
	Vide.jsx(TowerRangeUI, {
		Color = Controls.Color,
		Parent = Parent,
	})
end)
return story
