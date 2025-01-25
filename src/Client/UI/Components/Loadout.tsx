import Vide, { Node } from "@rbxts/vide";

interface UIProps {}

const LoadoutUI = (Props: UIProps): Node => {
	return (
		<frame
			AnchorPoint={new Vector2(0.5, 0.5)}
			Position={UDim2.fromScale(0.5, 0.8)}
			BackgroundColor3={Color3.fromHex("#000000")}
		>
			<uicorner CornerRadius={new UDim(0.2, 0)} />
		</frame>
	);
};
