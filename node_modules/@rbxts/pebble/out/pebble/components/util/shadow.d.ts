import Vide from "@rbxts/vide"

interface ShadowProps {
	zindex?: number | (() => number),
	transparency?: number | (() => number),
}

declare function shadow(props: ShadowProps): Vide.Node

export = shadow
