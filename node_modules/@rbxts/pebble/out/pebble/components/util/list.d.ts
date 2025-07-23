import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface ListProps {
	justifycontent?: can<Enum.UIFlexAlignment>,
	alignitems?: can<Enum.ItemLineAlignment>,
	spacing?: can<number | UDim>,
	wraps?: can<boolean>,
}

declare function list(props: ListProps): Vide.Node

export = list
