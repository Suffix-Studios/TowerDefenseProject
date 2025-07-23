import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface ButtonProps {
	size?: can<UDim2>,
    position?: can<UDim2>,
    anchorpoint?: can<Vector2>,
    automaticsize?: can<Enum.AutomaticSize>,

    text?: can<string>,
    disabled?: can<boolean>,

    activated?: () => void,
    mouse2?: () => void,
    down?: () => void,
    up?: () => void,

    /**
	 * enables the stroke (enabled by default)
    */
	stroke?: can<boolean>,
    /**
	 * enables the corner (enabled by default)
    */
	corner?: can<boolean>,
    accent?: can<boolean>,

    xalignment?: can<Enum.TextXAlignment>,

    code?: can<boolean>,
}

declare function button(props: ButtonProps): Vide.Node

export = button
