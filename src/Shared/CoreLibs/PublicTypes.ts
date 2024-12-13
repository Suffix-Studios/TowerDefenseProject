import Enumerators from "./Enumerators"

namespace PublicTypes {
    // export type Tower = {
    //     Id: string,
    //     CFrame: {Position: {}, Rotation: {}},
    //     Type: string,
    //     Priority: string,
    //     AttackInfo: { Type: string, Stats: any },

    //     TotalSpent: number,
    //     CurrentUpgrade: number,

    //     Stats: {
    //         SPA: number,
    //         Damage: number,
    //         Range: number,
    //     },

    //     Owner: string,
    //     Cooldown: number,

    //     GetEnemiesInRange: (self: Tower) => [Enemy],
    //     Attack: (self: Tower) => void,
    //     Upgrade: (self: Tower) => void,
    //     Remove: (self: Tower) => void,
    // }

    export interface EnemyProps {
        Id: string | undefined,
        ModelName: string,
        Health: number,
        IsAir: boolean,
        EnemyType: keyof typeof Enumerators.EnemyType,
        Speed: number,
        SpawnCFrame: CFrame
    }

    export interface ReplicatedEnemyProps {
        Position2D: {X: number, Z: number},
        TargetPosition2D: {X: number, Z: number},
        Speed: number,
        Health: number
    }

    export interface TowerProps {}
}

export = PublicTypes;
