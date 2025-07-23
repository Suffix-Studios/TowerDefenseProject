import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface WidgetProps {
    title: can<string>,
	subtitle?: can<string>,
	min_size?: Vector2,
	position?: Vector2,
	size?: Vector2,

	bind_to_close?: () => void,
}

declare function widget(props: WidgetProps): Vide.Node

export = widget
