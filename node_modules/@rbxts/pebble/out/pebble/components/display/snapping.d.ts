import Vide from "@rbxts/vide"

interface SnapArea {
	zindex: number | (() => number),
	snapped: (state: boolean) => void
}

interface Snappable {
	/**
	 * tells the object that you are dragging it
	*/
	dragging: () => boolean,

	/**
	 * allows making the widget float by itself without being anchored to anything
	*/
	allow_floating: boolean | (() => boolean),

	/**
	 * callbacks that update the position and size
	*/
	snapped: (state: boolean) => void,
	/**
	 * callbacks that update the position and size
	*/
	position: (position: UDim2) => void,
	/**
	 * callbacks that update the position and size
	*/
	size: (size: UDim2) => void
}

interface Snapping {
	snap_area: (props: SnapArea) => Vide.Node,
	snappable: (props: Snappable) => Vide.Node,
}

declare function snapping(): Snapping

export = snapping
