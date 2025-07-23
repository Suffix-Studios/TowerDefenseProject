import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface GapProps {
	gap: can<number>,
	direction?: can<"x" | "y">,
}

declare function gap(props: GapProps): Vide.Node

export = gap
