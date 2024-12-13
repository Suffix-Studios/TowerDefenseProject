import Enumerators from "Shared/CoreLibs/Enumerators";

namespace ServerTypes {
    export type InventoryTower = {
        Exp: number,
        Name: string,
        Level: number,
    }

    export type Enemy = {
        ModelName: string,
        Id: string,
        CFrame: CFrame,
        MaxHealth: number,
        Health: number,
        TargetWaypoint: number,
        Speed: number,
        Type: keyof typeof Enumerators.EnemyType,
        DistanceTravelled: number,
        IsAir: boolean,

        Hitbox: Part | undefined, ///! DEBUGGING

        Remove: (this: Enemy) => void,
        Move: (this: Enemy, TargetCFrame: CFrame) => void
    }
}

export = ServerTypes;
