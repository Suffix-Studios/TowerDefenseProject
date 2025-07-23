import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface SelectProps {
	size?: can<UDim2>,
	position?: can<UDim2>,
	anchorpoint?: can<Vector2>,

	selected: can<number>,
	update_selected?: () => number,

	options: can<string[]>
}

declare function select(props: SelectProps): Vide.Node

export = select
