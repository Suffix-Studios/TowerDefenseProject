import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface TypographyProps {
	size?: can<UDim2>,
	position?: can<UDim2>,
	anchorpoint?: can<Vector2>,
	automaticsize?: can<Enum.AutomaticSize>,

	accent?: can<boolean>,

	xalignment?: can<Enum.TextXAlignment>,
	yalignment?: can<Enum.TextYAlignment>,
	truncate?: can<Enum.TextTruncate>,
	wrapped?: can<boolean>,
	
	header?: can<boolean>,
	code?: can<boolean>,
	disabled?: can<boolean>,
	
	text: can<string>,
	textsize?: can<number>,

	visible?: can<boolean>,
}

declare function typography(props: TypographyProps): Vide.Node

export = typography
