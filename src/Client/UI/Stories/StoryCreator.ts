import Charm, { Atom } from "@rbxts/charm";
import { CreateControlStates, HKT, InferCreatedControls, InferGenericProps, UpdateControlStates } from "@rbxts/ui-labs";
import { ReturnControls } from "@rbxts/ui-labs/src/ControlTypings/Typing";
import Vide from "@rbxts/vide";

interface CharmAtomCreator extends HKT {
	new: (x: this["T"]) => Charm.Atom<typeof x>;
}

export function CreateVideWithAtomsStory<T extends ReturnControls>(
	controls: T,
	story: (controls: InferCreatedControls<T, CharmAtomCreator>, Parent: Instance) => void,
) {
	return {
		controls: controls,
		render: (props: InferGenericProps<defined>) => {
			const atoms = CreateControlStates(props.converted, props.controls, (val) => {
				return Charm.atom(val);
			}) as InferCreatedControls<T, CharmAtomCreator>;

			const unmount = Vide.mount(() => {
				story(atoms, props.target);
			});

			props.subscribe((values) => {
				UpdateControlStates(atoms, props.converted, values, (atom: Atom<unknown>, val) => {
					atom(val);
				});
			});

			return unmount;
		},
	};
}
