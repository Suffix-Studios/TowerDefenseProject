import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface GraphProps {
    position?: can<UDim2>,
	size?: can<UDim2>,
	anchorpoint?: can<UDim2>,

	values: () => Path2DControlPoint[],
}

declare function graph(props: GraphProps): Vide.Node

export = graph
