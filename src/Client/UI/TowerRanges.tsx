import { atom, Atom } from "@rbxts/charm";
import Remap from "@rbxts/remap";
import { Players, TweenService } from "@rbxts/services";
import Vide, { cleanup, Index, root } from "@rbxts/vide";
import { useAtom } from "@rbxts/vide-charm";
import { TowerRangeUI } from "./Components/TowerRange";

interface TowerRangeProps {
	TowerId: number;
	RangeColor: Color3;
	RangeSize: number;
	Parent: PVInstance;
}

const Player = Players.LocalPlayer;
const PlayerGui = Player.FindFirstChild("PlayerGui") as PlayerGui;

const Towers = atom(new ReadonlyMap<number, { RangeColor: Atom<Color3>; Part: Part }>());

const CreateRangePart = (Parent: PVInstance) => {
	const RangePart = new Instance("Part");
	RangePart.Anchored = true;
	RangePart.CanCollide = false;
	RangePart.CanQuery = false;
	RangePart.CanTouch = false;

	RangePart.Transparency = 1;
	RangePart.Size = new Vector3(0, 0.3, 0);
	RangePart.PivotTo(Parent.GetPivot());

	RangePart.Parent = Parent;

	return RangePart;
};

class TowerRange {
	private TowerId: number;
	public Color: Atom<Color3>;

	constructor(RangeProps: TowerRangeProps) {
		const newPart = CreateRangePart(RangeProps.Parent);

		task.spawn(() => {
			task.wait(0.1);
			const Tween = TweenService.Create(newPart, new TweenInfo(0.25, Enum.EasingStyle.Sine), {
				Size: new Vector3(RangeProps.RangeSize * 2, 0.3, RangeProps.RangeSize * 2),
			});

			Tween.Play();
			Tween.Completed.Wait();

			Tween.Destroy();
		});

		this.TowerId = RangeProps.TowerId;
		this.Color = atom<Color3>(RangeProps.RangeColor);

		const newTowers = Remap.set(Towers(), RangeProps.TowerId, {
			Part: newPart,
			RangeColor: this.Color,
		});

		Towers(newTowers);
	}

	public Destroy() {
		if (Towers().has(this.TowerId)) {
			Towers().get(this.TowerId)?.Part.Destroy();

			const newEnemies = Remap.delete(Towers(), this.TowerId);
			Towers(newEnemies);
		}

		setmetatable(this, undefined);
		table.clear(this);
		table.freeze(this);
	}
}

root(() => {
	const TowersMap = useAtom(Towers);

	<Index each={TowersMap}>
		{(RangeProps) => {
			return (
				<surfacegui
					action={cleanup}
					Parent={PlayerGui.FindFirstChild("TowersRanges")}
					Adornee={RangeProps().Part}
					Face={Enum.NormalId.Top}
				>
					<TowerRangeUI Color={RangeProps().RangeColor} />
				</surfacegui>
			);
		}}
	</Index>;
});

export = TowerRange;
