import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface RowProps {
	justifycontent?: can<Enum.UIFlexAlignment>,
	alignitems?: can<Enum.ItemLineAlignment>,
	spacing?: can<number | UDim>,
	wraps?: can<boolean>,
}

declare function row(props: RowProps): Vide.Node

export = row
