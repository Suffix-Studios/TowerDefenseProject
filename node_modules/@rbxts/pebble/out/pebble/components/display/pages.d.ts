import Vide from "@rbxts/vide"

interface PagesProps {
    labels: () => {
        title: string,
        ui: () => Instance | Instance[]
    }[]
}

declare function pages(props: PagesProps): Vide.Node

export = pages
