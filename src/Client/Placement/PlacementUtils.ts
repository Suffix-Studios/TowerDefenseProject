import { UserInputService, Workspace } from "@rbxts/services";

const placedTowersFolder = Workspace.WaitForChild("PlacedTowers") as Folder;

const camera = Workspace.CurrentCamera;

export const GetScreenPointRay = (): Ray => {
	const mouseScreenPosition = UserInputService.GetMouseLocation();
	const ray = camera?.ViewportPointToRay(
		mouseScreenPosition.X,
		mouseScreenPosition.Y,
	) as Ray;

	return ray;
};

export const raycastFromMouse = (params: RaycastParams): RaycastResult | undefined => {
	const ray = GetScreenPointRay();

	const raycast = Workspace.Raycast(ray?.Origin, ray.Direction.mul(100), params);
	if (raycast && raycast.Instance) return raycast;
	else return undefined;
};

export const togglePlacedTowersHitbox = (Toggle: boolean): void => {
	placedTowersFolder.GetChildren().forEach((TowerModel) => {
		const Hitbox = TowerModel.FindFirstChild("RedArea") as BasePart | undefined;

		if (Hitbox !== undefined) Hitbox.Transparency = Toggle ? 0.5 : 1;
	});
};
