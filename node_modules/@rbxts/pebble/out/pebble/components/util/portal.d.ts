import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface PortalProps {
	inherit_layout?: can<boolean>,
}

declare function portal(props: PortalProps): Vide.Node

export = portal
