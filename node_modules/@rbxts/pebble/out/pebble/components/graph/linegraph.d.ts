import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface LinegraphProps {
	position?: can<UDim2>,
	size?: can<UDim2>,
	anchorpoint?: can<UDim2>,

	values: () => number[],
	max?: can<number>,
	min?: can<number>,
}

declare function linegraph(props: LinegraphProps): Vide.Node

export = linegraph
