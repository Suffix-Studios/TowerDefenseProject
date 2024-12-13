import { Atom, isAtom } from "@rbxts/charm";
import Vide from "@rbxts/vide";
import { useAtom } from "@rbxts/vide-charm";

const RangeCircleImageId = "rbxassetid://127392364653406";

interface UIProps {
    Color: Atom<Color3>,
};

export const TowerRangeUI = (Props: UIProps): Vide.Node => {
    const Color = () => {
        return useAtom(Props.Color as Atom<Color3>)();
    }

    return (
        <frame
            Name={"Container"}
            Size={UDim2.fromScale(1, 1)}
            Position={UDim2.fromScale(0.5, 0.5)}
            AnchorPoint={new Vector2(0.5, 0.5)}
            BackgroundTransparency={1}
        >
            <uiaspectratioconstraint />
            <imagelabel
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={UDim2.fromScale(0.5, 0.5)}
                Size={UDim2.fromScale(1, 1)}

                BackgroundTransparency={1}
                Image={RangeCircleImageId}
                ImageColor3={(): Color3 => {
                    return Color();
                }}
            />
        </frame>
    )
}
