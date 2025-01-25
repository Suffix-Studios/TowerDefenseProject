import { Networking } from "@flamework/networking";
import Enumerators from "../Enumerators";

interface ServerToClientEvents {
	ReplicateData(Data: unknown): void;

	ReplicateEnemies(EnemiesPackets: ReadonlyArray<buffer>): void;
	EnemyAdded(EnemyPacket: buffer): void;

	TowerAdded(TowerPacket: buffer): void;

	EntityRemoved(EntityId: number): void;
}

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ServerToClientFunctions {}

interface ClientToServerEvents {
	PlaceTower(RayOrigin: Vector3, RayDirection: Vector3, Slot: keyof typeof Enumerators.Slot): void;
}

interface ClientToServerFunctions {
	RequestData(): unknown;
}

export const GlobalEvents = Networking.createEvent<ClientToServerEvents, ServerToClientEvents>();
export const GlobalFunctions = Networking.createFunction<ClientToServerFunctions, ServerToClientFunctions>();
