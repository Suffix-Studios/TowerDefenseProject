-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useDeltaTime = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "matter", "lib").useDeltaTime
local MapPath = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "BezierPath")
local Character = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "Character").Character
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local SystemPriorty = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators").SystemPriorty
local GetConstantYPosition = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Utils").GetConstantYPosition
local PathLength = MapPath.PathLength
local EnemyBaseSpeed = 4
local DelaySecondsForTeleport = 2
local EnemyMovement = function(World)
	for id, EntityEnemyInfo, EntityCharacter in World:query(EnemyInfo, Character) do
		if EntityEnemyInfo.PathProgress == EntityEnemyInfo.TargetPathProgress then
			continue
		end
		local StepDistance = ((EntityEnemyInfo.Speed * EnemyBaseSpeed) / PathLength) * useDeltaTime()
		local newT = math.min(EntityEnemyInfo.PathProgress + StepDistance, EntityEnemyInfo.TargetPathProgress)
		if (EntityEnemyInfo.TargetPathProgress) - EntityEnemyInfo.PathProgress > (StepDistance / useDeltaTime()) * DelaySecondsForTeleport then
			newT = EntityEnemyInfo.TargetPathProgress
		end
		local newCFrame = MapPath:CalculateUniformCFrame(newT)
		local _cFrame = CFrame.new(newCFrame.X, GetConstantYPosition(true) + EntityCharacter.Model:GetExtentsSize().Y / 2, newCFrame.Z)
		local _rotation = newCFrame.Rotation
		local FixedCFrame = _cFrame * _rotation
		EntityCharacter.Model:PivotTo(FixedCFrame)
		World:insert(id, EntityEnemyInfo:patch({
			PathProgress = newT,
		}))
	end
end
return {
	system = EnemyMovement,
	priority = SystemPriorty.High,
	event = "fixed",
}
