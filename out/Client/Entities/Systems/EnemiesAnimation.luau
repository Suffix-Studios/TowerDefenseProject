-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local Character = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "Character").Character
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local SystemPriorty = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators").SystemPriorty
local Camera = Workspace.CurrentCamera
local AnimationStartTime = os.clock()
local CharactersAnimation = function(World)
	for id, EntityCharacter in World:query(Character, EnemyInfo) do
		local OnScreen = (select(2, Camera:WorldToScreenPoint(EntityCharacter.Model:GetPivot().Position)))
		local IsPlaying = EntityCharacter.Animation.IsPlaying
		if OnScreen and not IsPlaying then
			EntityCharacter.Animation:Play()
			EntityCharacter.Animation.TimePosition = (os.clock() - AnimationStartTime) % EntityCharacter.Animation.Length
		elseif not OnScreen and IsPlaying then
			EntityCharacter.Animation:Stop()
		end
	end
end
return {
	system = CharactersAnimation,
	priority = SystemPriorty.Background,
	event = "default",
}
