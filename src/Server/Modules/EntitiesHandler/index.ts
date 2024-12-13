import { HttpService, RunService, Workspace } from "@rbxts/services";
import { ServerEvents } from "../ServerNetworking";
import { Deflate } from "@rbxts/zlib";
import ServerTypes from "../ServerTypes";
import PublicTypes from "Shared/CoreLibs/PublicTypes";

let GameMap: Folder
let Waypoints: Folder

namespace EntitiesHandler {
    export const Entities = {
        Enemies: new Map<string, ServerTypes.Enemy>(),
        // Towers: new Map<string, PublicTypes.Tower>()
    };

    export const AddEnemy = (Enemy: ServerTypes.Enemy): void => {
        if(!Waypoints) {
            while (GameMap === undefined) {
                task.wait(0.1)
                GameMap = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string) as Folder;
                Waypoints = GameMap?.FindFirstChild("Waypoints") as Folder;
            };
        }

        Entities.Enemies.set(Enemy.Id, Enemy);
        ServerEvents.EntityAdded.broadcast("Enemy", {
            Id: Enemy.Id,
            ModelName: Enemy.ModelName,
            Health: Enemy.MaxHealth,
            IsAir: Enemy.IsAir,
            EnemyType: Enemy.Type,
            Speed: Enemy.Speed,
            SpawnCFrame: Enemy.CFrame
        })
    };

    export const RemoveEntity = (Entity: ServerTypes.Enemy): void => {
        if (Entities.Enemies.has(Entity.Id)) {
            Entities.Enemies.delete(Entity.Id);
            ServerEvents.EntityRemoved.broadcast("Enemy", Entity.Id);

            Entity.Remove();
        }
    }

    interface MovementValues {
        TargetWaypointCFrame: CFrame,
        TargetDistance: number
    }

    const GetEnemyMovementValues = (Enemy: ServerTypes.Enemy): MovementValues => {
        const TargetWaypointInstance = Waypoints.FindFirstChild(`Waypoint${Enemy.TargetWaypoint}`) as BasePart;
        const TargetWaypointCFrame = TargetWaypointInstance.GetPivot();
        const EnemyCFrame = Enemy.CFrame

        const TargetDistance = (EnemyCFrame.Position.sub(new Vector3(
                TargetWaypointCFrame.X,
                EnemyCFrame.Y,
                TargetWaypointCFrame.Z
            ))
        ).Magnitude

        return {
            ["TargetWaypointCFrame"]: TargetWaypointCFrame,
            ["TargetDistance"]: TargetDistance
        }
    }

    const Frequency = 1/5 // 0.2 Seconds
    let Elapsed = 0

    RunService.Heartbeat.Connect((DeltaTime) => {
        Elapsed += DeltaTime;
        if (!(Elapsed >= Frequency)) return;

        const ReplicaEnemiesTable = new Map<string, PublicTypes.ReplicatedEnemyProps>();

        Entities.Enemies.forEach((Enemy, EnemyId) => {
            if (Enemy.Health <= 0) {
                RemoveEntity(Enemy);

                return;
            };

            task.spawn(() => {
                let EnemyMovementValues = GetEnemyMovementValues(Enemy);

                if (EnemyMovementValues.TargetDistance <= 1) {
                    Enemy.CFrame = EnemyMovementValues.TargetWaypointCFrame;

                    if (Enemy.TargetWaypoint === (Waypoints.GetChildren().size() - 1)) {
                        RemoveEntity(Enemy);

                        return;
                    }

                    Enemy.TargetWaypoint += 1;
                    EnemyMovementValues = GetEnemyMovementValues(Enemy);
                    Enemy.Move(CFrame.lookAt(Enemy.CFrame.Position, EnemyMovementValues.TargetWaypointCFrame.Position));
                }

                const EnemyCFrame = Enemy.CFrame;
                const Direction = EnemyMovementValues.TargetWaypointCFrame.Position.sub(EnemyCFrame.Position).Unit;
                const IsTooClose = EnemyMovementValues.TargetDistance < (Enemy.Speed * Frequency);

                const newCFrame = new CFrame(EnemyCFrame.Position.add(Direction.mul((IsTooClose ? EnemyMovementValues.TargetDistance : Enemy.Speed) * Frequency))).mul(Enemy.CFrame.Rotation);
                const DistanceTravelledThisStep = EnemyCFrame.Position.sub(newCFrame.Position).Magnitude;

                if (Enemy.DistanceTravelled) Enemy.DistanceTravelled += DistanceTravelledThisStep;

                if (Enemy.Hitbox !== undefined) {
                    Enemy.Hitbox.PivotTo(newCFrame);
                }

                Enemy.Move(newCFrame);
                ReplicaEnemiesTable.set(EnemyId, {
                    Position2D: {X: newCFrame.X, Z: newCFrame.Z},
                    TargetPosition2D: {X: EnemyMovementValues.TargetWaypointCFrame.X,
                            Z: EnemyMovementValues.TargetWaypointCFrame.Z},
                    Health: Enemy.Health,
                    Speed: Enemy.Speed,
                })
            })
        })

        Elapsed = 0;
        const EncodedTable = HttpService.JSONEncode(ReplicaEnemiesTable);
        // const startTime = os.clock();
        const CompressedTable = Deflate.Compress(EncodedTable, {level: 9});

        // print(`Time Taken To Compress: ${math.floor((os.clock() - startTime) * 1000) / 1000} ms`);

        // print(`Before: ${EncodedTable.size() / 1024} Kb \n After: ${CompressedTable.size() / 1024} Kb`);

        ServerEvents.ReplicateEnemies.broadcast(CompressedTable);
    })
}

export = EntitiesHandler;
