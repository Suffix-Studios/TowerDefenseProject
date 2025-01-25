import { createBinarySerializer } from "@rbxts/flamework-binary-serializer";
import { EnemyPacket, newEnemyPacket, newTowerPacket } from "./ReplicationPackets";

export const newEnemyPacketSerializer = createBinarySerializer<newEnemyPacket>();
export const EnemyPacketSerializer = createBinarySerializer<EnemyPacket>();

export const newTowerPacketSerializer = createBinarySerializer<newTowerPacket>();
