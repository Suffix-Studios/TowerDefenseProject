import { AnySystem, World } from "@rbxts/matter";
import { Workspace } from "@rbxts/services";
import MapPath from "Shared/BezierPath";
import { DebugPart } from "Shared/CoreLibs/Components/DebugPart";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";

const DebugPartsFolder = new Instance("Folder");
DebugPartsFolder.Parent = Workspace.FindFirstChild("Camera");
DebugPartsFolder.Name = "DebugParts";

const CreatePart = (Position: Vector3) => {
	const Part = new Instance("Part");
	Part.Parent = DebugPartsFolder;
	Part.Size = new Vector3(1.5, 1.5, 1.5);
	Part.Material = Enum.Material.Neon;
	[Part.Anchored, Part.CanCollide, Part.CanQuery, Part.CanTouch] = [false, false, false, false];
	Part.Position = Position;

	return Part;
};

const EnemyDebugParts = (World: World) => {
	for (const [id, EntityEnemyInfo, EntityDebugPart] of World.query(EnemyInfo, DebugPart)) {
		const EnemyCFrame = MapPath.CalculateUniformCFrame(EntityEnemyInfo.PathProgress);
		if (EntityDebugPart.Part === undefined) {
			World.insert(id, EntityDebugPart.patch({ Part: CreatePart(EnemyCFrame.Position) }));
			continue;
		}

		EntityDebugPart.Part?.PivotTo(EnemyCFrame);
	}
};

export = {
	system: EnemyDebugParts,
	priority: Enumerators.SystemPriorty.Background,
	event: "default",
} as AnySystem;
