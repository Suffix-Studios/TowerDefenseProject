import { AnySystem, useDeltaTime, World } from "@rbxts/matter";
import { ServerEvents } from "Server/Modules/ServerNetworking";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";
import { EnemyPacketSerializer } from "Shared/CoreLibs/Networking/BinarySerializers";

const ReplicationFrequency = 1 / 5; /// 5 Times A Second
let Elapsed = 0;

const EntitiesReplication = (World: World): void => {
	Elapsed += useDeltaTime();
	if (Elapsed < ReplicationFrequency) return;
	Elapsed = 0;

	const EnemiesPackets = new Array<buffer>();

	for (const [id, EntityEnemyInfo] of World.query(EnemyInfo)) {
		const EnemyPacket = EnemyPacketSerializer.serialize({
			Id: id,
			T: EntityEnemyInfo.PathProgress,
			Health: EntityEnemyInfo.Health as number,
		});

		EnemiesPackets.push(EnemyPacket.buffer);
	}

	if (EnemiesPackets.size() === 0) return;
	ServerEvents.ReplicateEnemies.broadcast(EnemiesPackets);
};

export = {
	system: EntitiesReplication,
	priority: Enumerators.SystemPriorty.High,
	event: "default",
} as AnySystem;
