import Vide from "@rbxts/vide"

type can<T> = T | (() => T)

interface TextfieldProps {
    size?: can<UDim2>,
    position?: can<UDim2>,
    anchorpoint?: can<UDim2>,
    
    text?: can<string>,
    placeholder?: can<string>,

    multiline?: can<boolean>,
    code?: can<boolean>,

    disabled?: can<boolean>,

    stroke?: can<boolean>,
    corner?: can<boolean>,

    /**
     * called whenever a character is added / removed
    */
    oninput?: (new_value: string) => void,
    /**
     * called whenever focus is lost
    */
    focuslost?: (text: string, enter?: boolean) => void,
    /**
     * called whenever focus is lost by pressing enter
    */
    enter?: (text: string) => void,
}

declare function textfield(props: TextfieldProps): Vide.Node

export = textfield
