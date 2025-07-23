import Vide from "@rbxts/vide"

interface Color {
    l: number
    c: number
    h: number
    color: Color3
}

interface Theme {
    bg: { [index: number]: number },
    accent: Color3,

    fg_on_bg_high: { [index: number]: Color3 },
    fg_on_bg_low: { [index: number]: Color3 },
    fg_on_accent_high: { [index: number]: Color3 },
    fg_on_accent_low: { [index: number]: Color3 },
    
    body: number,
    header: number,
    font: Font,
    font_code: Font,

    settings: {
        background: Vide.Source<Color>,
        accent: Vide.Source<Color>
    },
}

declare const theme: Theme
export = theme
