import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface CheckboxProps {
    position?: can<UDim2>,
    size?: can<UDim2>,
    anchorpoint?: can<UDim2>,
    automaticsize?: can<Enum.AutomaticSize>,

    layoutorder?: can<number>,
    zindex?: can<number>,

    checked: can<boolean>,
}

declare function checkbox(props: CheckboxProps): Vide.Node

export = checkbox
