import { Networking } from "@flamework/networking";
import PublicTypes from "./PublicTypes";
import Enumerators from "./Enumerators";

interface ServerToClientEvents {
    ReplicateData(Data: {}): void,
    ReplicateEnemies(EnemiesTable: string): void,
    EntityAdded(EntityType: string, EntityProps: PublicTypes.EnemyProps | PublicTypes.TowerProps): void,
    EntityRemoved(EntityType: string, EntityId: string): void,
}

interface ServerToClientFunctions {
    RequestData(): any;
}

interface ClientToServerEvents {
    PlaceTower(CameraCFrame: CFrame, TargetCFrame: CFrame, Slot: keyof typeof Enumerators.Slot): void
}

interface ClientToServerFunctions {
    RequestData(): any;
}

export const GlobalEvents = Networking.createEvent<ClientToServerEvents, ServerToClientEvents>();
export const GlobalFunctions = Networking.createFunction<ClientToServerFunctions, ServerToClientFunctions>();
