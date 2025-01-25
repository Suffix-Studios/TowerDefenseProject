import { Workspace } from "@rbxts/services";

const GetYConst = (IncludePaths: boolean): number => {
	const Map = Workspace.FindFirstChild(`${Workspace.GetAttribute("MapName")}_Map` as string) as Folder;
	const Waypoints = Map?.FindFirstChild("Waypoints") as Folder;
	const SpawnWaypoint = Waypoints.FindFirstChild("Spawn") as BasePart;
	const Paths = Map.FindFirstChild("Paths") as Instance;

	const RayOrigin = SpawnWaypoint.GetPivot().Position.add(new Vector3(0, 0, 10));
	const RayDirection = new Vector3(0, -100, 0);

	const Params = new RaycastParams();
	Params.FilterType = Enum.RaycastFilterType.Include;
	Params.FilterDescendantsInstances = [Map.FindFirstChild("Ground") as Instance];
	if (IncludePaths) Params.FilterDescendantsInstances.push(Paths);

	const RayResult = Workspace.Raycast(RayOrigin, RayDirection, Params);

	return RayResult === undefined ? 0 : RayResult.Position.Y;
};

const ConstYPaths = GetYConst(true);
const ConstY = GetYConst(false);

namespace Utils {
	export const GetConstantYPosition = (IncludePaths: boolean) => {
		return IncludePaths ? ConstYPaths : ConstY;
	};
}

export = Utils;
