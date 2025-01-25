-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local MapPath = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "BezierPath")
local DebugPart = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "DebugPart").DebugPart
local EnemyInfo = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Components", "EntityInfo").EnemyInfo
local Enumerators = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Enumerators")
local DebugPartsFolder = Instance.new("Folder")
DebugPartsFolder.Parent = Workspace:FindFirstChild("Camera")
DebugPartsFolder.Name = "DebugParts"
local CreatePart = function(Position)
	local Part = Instance.new("Part")
	Part.Parent = DebugPartsFolder
	Part.Size = Vector3.new(1.5, 1.5, 1.5)
	Part.Material = Enum.Material.Neon
	Part.Anchored, Part.CanCollide, Part.CanQuery, Part.CanTouch = false, false, false, false
	Part.Position = Position
	return Part
end
local EnemyDebugParts = function(World)
	for id, EntityEnemyInfo, EntityDebugPart in World:query(EnemyInfo, DebugPart) do
		local EnemyCFrame = MapPath:CalculateUniformCFrame(EntityEnemyInfo.PathProgress)
		if EntityDebugPart.Part == nil then
			World:insert(id, EntityDebugPart:patch({
				Part = CreatePart(EnemyCFrame.Position),
			}))
			continue
		end
		local _result = EntityDebugPart.Part
		if _result ~= nil then
			_result:PivotTo(EnemyCFrame)
		end
	end
end
return {
	system = EnemyDebugParts,
	priority = Enumerators.SystemPriorty.Background,
	event = "default",
}
