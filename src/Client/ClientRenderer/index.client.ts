import Remap from "@rbxts/remap";
import { HttpService } from "@rbxts/services";
import { Deflate } from "@rbxts/zlib";
import { ClientEvents } from "Client/Modules/ClientNetworking";
import ClientTypes from "Client/Modules/ClientTypes";
import ClientEnemy from "Client/Modules/Entities/ClientEnemy";
import PublicTypes from "Shared/CoreLibs/PublicTypes";
import Utils from "Shared/CoreLibs/Utils";
import ClientEntitiesContainer from "./Container";

ClientEvents.ReplicateEnemies.connect((CompressedEnemiesTable) => {
	const DecompressedTable = Deflate.Decompress(CompressedEnemiesTable);
	const ReplicatedEnemiesTable = HttpService.JSONDecode(DecompressedTable) as Map<
		string,
		PublicTypes.ReplicatedEnemyProps
	>;

	const Enemies = ClientEntitiesContainer.Enemies();

	ReplicatedEnemiesTable.forEach((ReplicatedEnemy, EnemyId) => {
		if (!Enemies.has(EnemyId)) return;

		task.spawn(() => {
			const ClientEnemy = Enemies.get(EnemyId) as ClientTypes.Enemy;
			ClientEnemy.CheckAnimation();

			if (ClientEnemy.Health() <= 0) return;

			const YPos =
				(Utils.GetConstantYPosition(false) as number) +
				(ClientEnemy.Character.GetExtentsSize().Y as number) / 2 +
				0.5;

			ClientEnemy.Health(ReplicatedEnemy.Health);
			ClientEnemy.Speed = ReplicatedEnemy.Speed;

			const EnemyPosition = new Vector3(ReplicatedEnemy.Position2D.X, YPos, ReplicatedEnemy.Position2D.Z);

			const TargetPosition = new Vector3(
				ReplicatedEnemy.TargetPosition2D.X,
				YPos,
				ReplicatedEnemy.TargetPosition2D.Z,
			);

			const TargetCFrame = CFrame.lookAt(EnemyPosition, TargetPosition);

			ClientEnemy.Move(TargetCFrame);
		});
	});
});

ClientEvents.EntityAdded.connect((EntityType, EntityProps) => {
	if (EntityType === "Enemy") {
		const Props = EntityProps as PublicTypes.EnemyProps;
		const newEnemy = new ClientEnemy(EntityProps as PublicTypes.EnemyProps);
		let Enemies = ClientEntitiesContainer.Enemies();

		Enemies = Remap.set(Enemies, Props.Id as string, newEnemy);

		ClientEntitiesContainer.Enemies(Enemies);
	}
});

ClientEvents.EntityRemoved.connect((EntityType, EntityId) => {
	if (EntityType === "Enemy") {
		let Enemies = ClientEntitiesContainer.Enemies();
		const Enemy = Enemies.get(EntityId);

		if (Enemy !== undefined) {
			Enemies = Remap.delete(Enemies, EntityId);
			ClientEntitiesContainer.Enemies(Enemies);

			Enemy.Remove();
		}
	}
});
