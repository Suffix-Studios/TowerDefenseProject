import Vide from "@rbxts/vide"

interface AccordionProps {
    text: string | (() => string)
    expanded: () => boolean,
	set_expanded: (state: boolean) => void,
}

declare function accordion(props: AccordionProps): Vide.Node

export = accordion
