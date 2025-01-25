import { atom, Atom } from "@rbxts/charm";
import Remap from "@rbxts/remap";
import { Players } from "@rbxts/services";
import Vide, { cleanup, Index, root } from "@rbxts/vide";
import { useAtom } from "@rbxts/vide-charm";
import { EnemyHealthUI } from "./Components/EnemyOverhead";

interface EnemyUIProps {
	EnemyId: number;
	EnemyHealth: Atom<number>;
	Adornee: PVInstance;
}

const Player = Players.LocalPlayer;
const PlayerGui = Player.FindFirstChild("PlayerGui") as PlayerGui;

const Enemies = atom(new ReadonlyMap<number, { HealthAtom: Atom<number>; Adornee: Instance }>());

export const CreateEnemyUI = (OverheadProps: EnemyUIProps): void => {
	const newEnemies = Remap.set(Enemies(), OverheadProps.EnemyId, {
		HealthAtom: OverheadProps.EnemyHealth,
		Adornee: OverheadProps.Adornee,
	});

	Enemies(newEnemies);
};

export const DestroyEnemyUI = (EnemyId: number): void => {
	if (Enemies().has(EnemyId)) {
		const newEnemies = Remap.delete(Enemies(), EnemyId);

		Enemies(newEnemies);
	}
};

root(() => {
	const EnemiesMap = useAtom(Enemies);

	<Index each={EnemiesMap}>
		{(OverheadProps) => {
			return (
				<billboardgui
					action={cleanup}
					Parent={PlayerGui.FindFirstChild("EnemiesOverheads")}
					Adornee={OverheadProps().Adornee as PVInstance}
					Size={UDim2.fromScale(3, 0.65)}
					StudsOffset={new Vector3(0, 1.5, 0)}
				>
					<EnemyHealthUI Health={OverheadProps().HealthAtom} TextType={"Number Only"} />
				</billboardgui>
			);
		}}
	</Index>;
});
