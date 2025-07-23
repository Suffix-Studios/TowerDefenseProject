import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface VirtualScrollerProps {
	size?: can<UDim2>,
	position?: can<UDim2>,
	anchorpoint?: can<UDim2>,

	/**
	 * streams in items. when index is -1, should expect to be unused
	*/
	item: (index: () => number) => Instance,
	/**
	 * streams in separators. when index is -1, should expect to be unused
	*/
	separator?: (index: () => number) => Instance,

	item_size: number,
	separator_size?: number,

	max_items?: () => number,
}

declare function virtualscroller(props: VirtualScrollerProps): Vide.Node

export = virtualscroller
