import { AnySystem, useDeltaTime, World } from "@rbxts/matter";
import { ServerEvents } from "Server/Modules/ServerNetworking";
import MapPath from "Shared/BezierPath";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";

const PathLength = MapPath.PathLength;
const EnemyBaseSpeed = 4;

const EnemyMovement = (World: World) => {
	for (const [id, EntityEnemyInfo] of World.query(EnemyInfo)) {
		const StepDistance = (EntityEnemyInfo.Speed * EnemyBaseSpeed) / PathLength;
		const newT = EntityEnemyInfo.PathProgress + StepDistance * useDeltaTime();

		///! DEBUG
		if (newT >= 1) {
			World.despawn(id);
			ServerEvents.EntityRemoved.broadcast(id);
			continue;
		}

		World.insert(id, EntityEnemyInfo.patch({ PathProgress: newT }));
	}
};

export = {
	system: EnemyMovement,
	priority: Enumerators.SystemPriorty.Critical,
	event: "default",
} as AnySystem;
