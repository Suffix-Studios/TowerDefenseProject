import Vide from "@rbxts/vide"

interface ResizeableBarProps {
	meaning: () => string[],
	min_sizes?: () => Vide.Source<number>[],
	sizes: Vide.Source<Array<Vide.Source<number>>>,
	suggested_sizes?: number[]

	splits?: Vide.Source<Array<Vide.Source<number>>>,
	base_splits: number[]
}

declare function resizeable_bar(props: ResizeableBarProps): Vide.Node

export = resizeable_bar
