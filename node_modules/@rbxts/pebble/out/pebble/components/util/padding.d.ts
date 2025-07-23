import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface PaddingProps {
	padding?: can<UDim>,
	x?: can<UDim>,
	y?: can<UDim>,
	left?: can<UDim>,
	right?: can<UDim>,
	top?: can<UDim>,
	bottom?: can<UDim>,
}

declare function padding(props: PaddingProps): Vide.Node

export = padding
