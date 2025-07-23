import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface RoundedFrameProps {
	name?: can<string>,
	size?: can<UDim2>,
	position?: can<UDim2>,
	anchor_point?: can<Vector2>,

	topleft?: can<UDim>,
	topright?: can<UDim>,
	bottomleft?: can<UDim>,
	bottomright?: can<UDim>,

	color?: can<Color3>,

	layout: Vide.LegacyInstanceProps<Frame>,
}

declare function rounded_frame(props: RoundedFrameProps): Vide.Node

export = rounded_frame
