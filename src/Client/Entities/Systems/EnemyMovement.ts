import { AnySystem, useDeltaTime, World } from "@rbxts/matter";
import MapPath from "Shared/BezierPath";
import { Character } from "Shared/CoreLibs/Components/Character";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import { SystemPriorty } from "Shared/CoreLibs/Enumerators";
import { GetConstantYPosition } from "Shared/CoreLibs/Utils";

const PathLength = MapPath.PathLength;
const EnemyBaseSpeed = 4;
const DelaySecondsForTeleport = 2; /// Amount of time the enemy is behind his target position before he teleports to it

const EnemyMovement = (World: World) => {
	for (const [id, EntityEnemyInfo, EntityCharacter] of World.query(EnemyInfo, Character)) {
		if (EntityEnemyInfo.PathProgress === EntityEnemyInfo.TargetPathProgress) continue;

		const StepDistance = ((EntityEnemyInfo.Speed * EnemyBaseSpeed) / PathLength) * useDeltaTime();
		let newT = math.min(EntityEnemyInfo.PathProgress + StepDistance, EntityEnemyInfo.TargetPathProgress as number);

		if (
			(EntityEnemyInfo.TargetPathProgress as number) - EntityEnemyInfo.PathProgress >
			(StepDistance / useDeltaTime()) * DelaySecondsForTeleport
		) {
			newT = EntityEnemyInfo.TargetPathProgress as number;
		}

		const newCFrame = MapPath.CalculateUniformCFrame(newT);
		const FixedCFrame = new CFrame(
			newCFrame.X,
			GetConstantYPosition(true) + EntityCharacter.Model.GetExtentsSize().Y / 2,
			newCFrame.Z,
		).mul(newCFrame.Rotation);

		EntityCharacter.Model.PivotTo(FixedCFrame);
		World.insert(id, EntityEnemyInfo.patch({ PathProgress: newT }));
	}
};

export = {
	system: EnemyMovement,
	priority: SystemPriorty.High,
	event: "fixed",
} as AnySystem;
