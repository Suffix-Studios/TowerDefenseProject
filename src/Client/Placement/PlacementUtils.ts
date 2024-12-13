import { GuiService, UserInputService, Workspace } from "@rbxts/services"

const PlacedTowersFolder = Workspace.WaitForChild("PlacedTowers") as Folder;

const Camera = Workspace.CurrentCamera;

export const RaycastFromMouse = (Params: RaycastParams): RaycastResult | undefined => {
    const MouseScreenPosition = UserInputService.GetMouseLocation();
    const Ray = Camera?.ScreenPointToRay(
        MouseScreenPosition.X,
        MouseScreenPosition.Y - GuiService.GetGuiInset()[0].Y
    ) as Ray;

    const Raycast = Workspace.Raycast(Ray?.Origin, Ray.Direction.mul(100), Params)
    if (Raycast && Raycast.Instance) return Raycast;
        else return undefined;
}

export const TogglePlacedTowersHitbox = (Toggle: boolean): void => {
    for (const [_, TowerModel] of pairs(PlacedTowersFolder.GetChildren())) {
        const Hitbox = TowerModel.FindFirstChild("RedArea") as BasePart | undefined;

        if (Hitbox !== undefined) Hitbox.Transparency = Toggle ? 0.5 : 1;
    }
}
