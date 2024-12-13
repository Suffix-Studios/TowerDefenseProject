import { Atom, atom } from "@rbxts/charm";
import Remap from "@rbxts/remap";
import { Players, TweenService, Workspace } from "@rbxts/services";
import Vide, { For, root } from "@rbxts/vide";
import { useAtom } from "@rbxts/vide-charm";
import { TowerRangeUI } from "Client/UI/TowerRange";

const Player = Players.LocalPlayer;
const PlayerGui = Player.FindFirstChild("PlayerGui") as PlayerGui;

const TowerRangesContainer = atom<ReadonlyMap<BasePart, TowerRangeDisplay>>(new ReadonlyMap());

class TowerRangeDisplay {
    private Part: BasePart;

    public Color: Atom<Color3>

    constructor(Position: Vector3, Color: Color3, Size: number) {
        this.Part = this.CreateRangePart();
        this.Part.PivotTo(new CFrame(Position));
        this.Color = atom(Color);

        let newContainer = Remap.set(TowerRangesContainer(), this.Part, this);
        TowerRangesContainer(newContainer);

        task.spawn(() => {
            const Tween = TweenService.Create(this.Part, new TweenInfo(0.2, Enum.EasingStyle.Sine), {Size: new Vector3(Size * 2, 0.3, Size * 2)});

            Tween.Play();
            Tween.Completed.Wait();

            Tween.Destroy();
        })
    }


    private CreateRangePart(): BasePart {
        const Part = new Instance("Part");
        Part.Anchored = true;
        Part.Transparency = 1;
        Part.Size = new Vector3(0, 0.3, 0)
        Part.Parent = Workspace;
        [Part.CanCollide, Part.CanTouch, Part.CanQuery] = [false, false, false];

        return Part;
    }

    public SetPosition(newPosition: Vector3): void {
        this.Part.PivotTo(new CFrame(newPosition));
    }

    public Destroy(): void {
        const Part = this.Part

        setmetatable(this, undefined);
        table.clear(this);
        table.freeze(this);

        task.spawn(() => {
            const Tween = TweenService.Create(Part, new TweenInfo(0.2, Enum.EasingStyle.Sine), {Size: new Vector3(0, 0.3, 0)});

            Tween.Play();
            Tween.Completed.Wait();

            Tween.Destroy();
            Part.Destroy();
        })
    }
}

root(() => {
    let Container = () => {
        return useAtom(TowerRangesContainer)();
    }

    <folder
        Parent={PlayerGui}
        Name={"Range Display"}
    >
        <For each={Container}>
            {(TowerRange, Part) => {
                return <surfacegui
                    Face={Enum.NormalId.Top}
                    Adornee={Part()}
                    AlwaysOnTop={true}
                >
                    <TowerRangeUI
                        Color={TowerRange.Color}
                    />
                </surfacegui>
            }}

        </For>
    </folder>
})

export = TowerRangeDisplay;
