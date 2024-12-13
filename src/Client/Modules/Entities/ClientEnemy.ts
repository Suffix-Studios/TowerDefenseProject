/// Services
import { ReplicatedStorage, TweenService, Workspace } from "@rbxts/services";
import Enumerators from "Shared/CoreLibs/Enumerators";
import PublicTypes from "Shared/CoreLibs/PublicTypes";
import ClientTypes from "../ClientTypes";
import { Atom, atom } from "@rbxts/charm";

/// Instances
const EnemyModels = ReplicatedStorage.WaitForChild("EnemiesModels") as Folder;
const EnemiesFolder = Workspace.WaitForChild("Enemies") as Folder;
const Animations = ReplicatedStorage.WaitForChild("Animations") as Folder;

let GameMap = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string);
let Waypoints = GameMap?.FindFirstChild("Waypoints") as Folder;

const Camera = Workspace.CurrentCamera as Camera;

class ClientEnemy implements ClientTypes.Enemy {
    readonly Id;
    readonly ModelName;
    MaxHealth: number; Health: Atom<number>;
    Speed;
    IsAir;
    Type: keyof typeof Enumerators.EnemyType;
    Character;
    Animation;

    constructor(Props: PublicTypes.EnemyProps) {
        if(!Waypoints) {
            do {
                GameMap = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string)
                Waypoints = GameMap?.FindFirstChild("Waypoints") as Folder
            } while (!GameMap);
        }

        this.ModelName = Props.ModelName;
        this.Id = Props.Id as string;
        this.MaxHealth = Props.Health;
        this.Health = atom(this.MaxHealth)
        this.IsAir = Props.IsAir;
        this.Speed = Props.Speed;
        this.Type = Props.EnemyType;

        this.Character = EnemyModels.FindFirstChild(Props.ModelName)?.Clone() as Model;
        this.Character.Parent = EnemiesFolder;
        this.Character.PivotTo(Props.SpawnCFrame);

        this.Character.Name = Props.Id as string;

        const AnimationController = this.Character.FindFirstChildWhichIsA("AnimationController") as AnimationController;
        const Animator = AnimationController.FindFirstChild("Animator") as Animator;

        this.Animation = Animator.LoadAnimation(Animations.FindFirstChild("EnemyWalk") as Animation);
        this.Animation.AdjustSpeed(this.Speed / 4);
    };

    Move(this: ClientTypes.Enemy, TargetCFrame: CFrame): void {
        const MovementTween = TweenService.Create(this.Character?.PrimaryPart as BasePart,
            new TweenInfo(0.2, Enum.EasingStyle.Linear),
            {CFrame: TargetCFrame})

        MovementTween.Play();

        MovementTween.Completed.Wait();
        MovementTween.Destroy();
    };

    Remove(this: ClientTypes.Enemy): void {
        this.Character?.Destroy();

        setmetatable(this, undefined);
        table.clear(this);
        table.freeze(this);
    }

    CheckAnimation(this: ClientTypes.Enemy): void {
        const OnScreen = Camera.WorldToScreenPoint(this.Character.GetPivot().Position as Vector3)[1];

        if(OnScreen && !this.Animation?.IsPlaying) this.Animation?.Play();
            else if(!OnScreen && this.Animation.IsPlaying) this.Animation.Stop();
    };
}

export = ClientEnemy;
