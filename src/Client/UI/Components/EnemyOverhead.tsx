import { Atom } from "@rbxts/charm";
import Vide from "@rbxts/vide";
import { useAtom } from "@rbxts/vide-charm";

type TextTypes = "Number Only" | "Number Over Max" | "Percentage";

interface UIProps {
	Health: Atom<number>;
	TextType: TextTypes | Atom<TextTypes>;
	Parent?: Instance;
}

export const EnemyHealthUI = (Props: UIProps) => {
	const MaxHealth = Props.Health();

	const Health = useAtom(Props.Health);
	const TextType = typeIs(Props.TextType, "string") ? () => Props.TextType : useAtom(Props.TextType);

	return (
		<frame
			Name={"BarBackground"}
			Parent={() => {
				if (Props.Parent) return Props.Parent;
				else return undefined;
			}}
			AnchorPoint={new Vector2(0.5, 0.5)}
			Size={UDim2.fromScale(1, 1)}
			Position={UDim2.fromScale(0.5, 0.5)}
			BackgroundColor3={Color3.fromRGB(75, 75, 75)}
		>
			<uicorner CornerRadius={new UDim(0.15)} />
			<frame
				AnchorPoint={new Vector2(0, 0.5)}
				Position={UDim2.fromScale(0, 0.5)}
				Size={(): UDim2 => {
					return UDim2.fromScale(Health() / MaxHealth, 1);
				}}
				BackgroundColor3={Color3.fromRGB(255, 0, 0)}
			>
				<uicorner CornerRadius={new UDim(0.15, 0)} />
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
					switch (TextType()) {
						case "Number Only":
							return `${math.floor(Health())}`;
						case "Number Over Max":
							return `${math.floor(Health())}/${MaxHealth}`;
						case "Percentage":
							return `%${math.floor((Health() / MaxHealth) * 100)}`;
						default:
							return "";
					}
				}}
			/>
		</frame>
	);
};
