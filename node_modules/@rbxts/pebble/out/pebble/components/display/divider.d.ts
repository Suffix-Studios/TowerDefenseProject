import Vide from "@rbxts/vide"

interface DividerProps {
    thickness?: number | (() => number),
	position?: UDim2 | (() => UDim2),
}

declare function divider(props: DividerProps): Vide.Node

export = divider
