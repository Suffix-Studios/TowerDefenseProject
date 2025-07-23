import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface BackgroundProps {
    position?: can<UDim2>,
    size?: can<UDim2>,
    anchorpoint?: can<UDim2>,
    automaticsize?: can<Enum.AutomaticSize>,

    layoutorder?: can<number>,
    zindex?: can<number>,

    depth?: can<number>,
    accent?: can<boolean>,
}

declare function background(props: BackgroundProps): Vide.Node

export = background
