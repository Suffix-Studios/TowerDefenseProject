import { Atom } from "@rbxts/charm";
import Vide from "@rbxts/vide"
import { useAtom } from "@rbxts/vide-charm";

interface UIProps {
    Health: Atom<number>,
    Adornee: BasePart,
    MaxHealth: number,
    TextType: "Number Only" | "Number Over Max" | "Percentage"
}

export const EnemyHealthUI = (Props: UIProps) => {
    let Health = () => {
        return useAtom(Props.Health)();
    }

    return (
        <billboardgui
            Adornee={Props.Adornee}
            Size={UDim2.fromScale(4, 0.7)}
            MaxDistance={100}
            StudsOffset={new Vector3(0, 3, 0)}
            Enabled={true}
        >
            <frame
            Name={"BarBackground"}
            AnchorPoint={new Vector2(0.5, 0.5)}
            Size={UDim2.fromScale(1, 1)}
            Position={UDim2.fromScale(0.5, 0.5)}
            BackgroundColor3={Color3.fromRGB(75, 75, 75)}
        >
            <uicorner CornerRadius={new UDim(0.15)}/>
            <frame
                AnchorPoint={new Vector2(0, 0.5)}
                Position={UDim2.fromScale(0, 0.5)}
                Size={(): UDim2 => {
                    return UDim2.fromScale(Health() / Props.MaxHealth, 1);
                }}
                BackgroundColor3={Color3.fromRGB(255, 0, 0)}
            >
                <uicorner CornerRadius={new UDim(.15, 0)}/>
            </frame>

            <textlabel
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={UDim2.fromScale(0.5, 0.5)}
                Size={UDim2.fromScale(1, 1)}
                TextColor3={Color3.fromRGB(255, 255, 255)}
                TextScaled={true}
                BackgroundTransparency={1}
                Font={Enum.Font.FredokaOne}

                Text={(): string => {
                    switch(Props.TextType) {
                        case "Number Only":
                            return `${Health()}`;
                        case "Number Over Max":
                            return `${Health()}/${Props.MaxHealth}`;
                        case "Percentage":
                            return `%${math.floor((Health() / Props.MaxHealth) * 100)}`
                        default:
                            return ""
                    }
                }}
            />
        </frame>
        </billboardgui>
    )
}
