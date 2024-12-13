import { Workspace } from "@rbxts/services";

namespace Utils {
    export const GetConstantYPosition = (IncludePaths: boolean): number | undefined => {
        const Map = Workspace.FindFirstChild(Workspace.GetAttribute("MapName") as string) as Folder;
        const Waypoints = Map?.FindFirstChild("Waypoints") as Folder;
        const SpawnWaypoint = Waypoints.FindFirstChild("Spawn") as BasePart;
        const Paths = Map.FindFirstChild("Paths") as Instance

        const RayOrigin = SpawnWaypoint.GetPivot().Position.add(new Vector3(0, 0, 10));
        const RayDirection = new Vector3(0, -100, 0);

        let Params = new RaycastParams();
        Params.FilterType = Enum.RaycastFilterType.Include
        Params.FilterDescendantsInstances = [Map.FindFirstChild("Ground") as Instance]
        if (IncludePaths) Params.FilterDescendantsInstances.push(Paths);

        const RayResult = Workspace.Raycast(RayOrigin, RayDirection, Params);

        return RayResult === undefined ? undefined : RayResult.Position.Y;
    }
}

export = Utils;
