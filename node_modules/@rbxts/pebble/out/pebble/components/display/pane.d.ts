import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface PaneProps {
    size?: can<UDim2>,
	position?: can<UDim2>,
	anchorpoint?: can<UDim2>,
	layoutorder?: can<number>,
	automaticsize?: can<Enum.AutomaticSize>,

	name?: can<string>,
}

declare function pane(props: PaneProps): Vide.Node

export = pane
