import { Workspace } from "@rbxts/services";
import BezierPath from "./BezierPath";

const CurveSize = 2;

while (!(Workspace.GetAttribute("IsReady") as boolean)) {
	task.wait(0.1);
}

const MapName = Workspace.GetAttribute("MapName") as string;
const MapFolder = Workspace.WaitForChild(`${MapName}_Map`) as Folder;
const Waypoints = MapFolder.WaitForChild("Waypoints") as Folder;

const Positions = new Array<Vector3>();

while (Waypoints.GetChildren().size() !== (MapFolder.GetAttribute("WaypointsNumber") as number)) {
	task.wait();
}

for (let i = 0; i < Waypoints.GetChildren().size(); i++) {
	Positions[i] =
		i === 0
			? (Waypoints.FindFirstChild("Spawn") as BasePart).GetPivot().Position
			: (Waypoints.FindFirstChild(`Waypoint${i}`) as BasePart).GetPivot().Position;
}

const MapPath = new BezierPath(Positions, CurveSize);
// if (RunService.IsStudio()) MapPath.VisualizePath();
print("Created Bezier Path!");

export = MapPath;
