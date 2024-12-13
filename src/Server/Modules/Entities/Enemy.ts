/// Services
import { ReplicatedStorage, Workspace } from "@rbxts/services";
import Enumerators from "Shared/CoreLibs/Enumerators";
import ServerTypes from "../ServerTypes";
import PublicTypes from "Shared/CoreLibs/PublicTypes";

/// Instances
const EnemyModels = ReplicatedStorage.WaitForChild("EnemiesModels") as Folder;
const EnemiesFolder = Workspace.WaitForChild("Enemies") as Folder;
const Animations = ReplicatedStorage.WaitForChild("Animations") as Folder;

/// Values
const EnemyBaseSpeed = 4;

/// Instances
let GameMap = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string);
let Waypoints = GameMap?.FindFirstChild("Waypoints") as Folder;

let CurrentEUID = -1 /// Enemy Unique Id

const DebugHitbox = (targetCFrame: CFrame): Part => {
	const Hitbox: Part = new Instance("Part");
	Hitbox.Anchored = true;
	Hitbox.CanCollide = false;
	Hitbox.CanQuery = false;
	Hitbox.Color = Color3.fromHex("#FF0000");
	Hitbox.Transparency = 0.5;
	Hitbox.Size = new Vector3(2.5, 2.5, 2.5);

	Hitbox.PivotTo(targetCFrame);
    const Camera = Workspace.FindFirstChild("Camera") as Camera;

    if (!Camera.FindFirstChild("Hitboxes")) {
        const Folder = new Instance("Folder");
        Folder.Parent = Camera;
        Folder.Name = "Hitboxes";
    }

	Hitbox.Parent = Camera.FindFirstChild("Hitboxes");

	return Hitbox;
}


class Enemy implements ServerTypes.Enemy {
    readonly Id: string;
    readonly ModelName: string;
    MaxHealth: number; Health: number;
    IsAir: boolean;
    Type: keyof typeof Enumerators.EnemyType;
    Speed: number;
    CFrame: CFrame;
    Hitbox: Part | undefined;

    TargetWaypoint: number = 1;
    DistanceTravelled: number = 0;


    constructor(Props: PublicTypes.EnemyProps) {
        if(!Waypoints) {
            do {
                GameMap = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string)
                Waypoints = GameMap?.FindFirstChild("Waypoints") as Folder
            } while (!GameMap);
        }

        CurrentEUID += 1;

        this.ModelName = Props.ModelName;
        this.Id = `${Props.ModelName}_${tostring(CurrentEUID)}`;
        [this.MaxHealth, this.Health] = [Props.Health, Props.Health];
        this.IsAir = Props.IsAir;
        this.Speed = EnemyBaseSpeed * Props.Speed;
        this.Type = Props.EnemyType;

        const TargetWaypoint = Waypoints.FindFirstChild(`Waypoint${this.TargetWaypoint}`) as BasePart;

        this.CFrame = CFrame.lookAt(Props.SpawnCFrame.Position, TargetWaypoint.GetPivot().Position);

        this.Hitbox = DebugHitbox(this.CFrame);
        this.DistanceTravelled = 0;
    };

    Move(this: ServerTypes.Enemy, TargetCFrame: CFrame): void {
        if (this.Hitbox) {
            this.Hitbox.PivotTo(TargetCFrame)
        }

        this.CFrame = TargetCFrame;
    };

    Remove(this: ServerTypes.Enemy): void {
        if(this.Hitbox) {
            this.Hitbox.Destroy();
        }

        setmetatable(this, undefined);
        table.clear(this);
        table.freeze(this);
    }
}

export = Enemy;
