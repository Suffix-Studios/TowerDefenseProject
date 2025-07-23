import { Workspace } from "@rbxts/services";

const getYConst = (includePaths: boolean): number => {
	const map = Workspace.FindFirstChild(`${Workspace.GetAttribute("MapName")}_Map` as string) as Folder;
	const waypoints = map?.FindFirstChild("Waypoints") as Folder;
	const spawnWaypoint = waypoints.FindFirstChild("Spawn") as BasePart;
	const paths = map.FindFirstChild("Paths") as Instance;

	const rayOrigin = spawnWaypoint.GetPivot().Position.add(new Vector3(0, 0, 10));
	const rayDirection = new Vector3(0, -100, 0);

	const params = new RaycastParams();
	params.FilterType = Enum.RaycastFilterType.Include;
	params.FilterDescendantsInstances = [map.FindFirstChild("Ground") as Instance];
	if (includePaths) params.FilterDescendantsInstances.push(paths);

	const rayResult = Workspace.Raycast(rayOrigin, rayDirection, params);

	return rayResult === undefined ? 0 : rayResult.Position.Y;
};

const constYPaths = getYConst(true);
const constY = getYConst(false);

namespace Utils {
	export const GetConstantYPosition = (IncludePaths: boolean) => {
		return IncludePaths ? constYPaths : constY;
	};
}

export = Utils;
