import { ReplicatedStorage, RunService, Workspace } from "@rbxts/services";
import Enemy from "Server/Modules/Entities/Enemy";
import EntitiesHandler from "./Modules/EntitiesHandler";

const WavesFolder = ReplicatedStorage.FindFirstChild("Modules")?.FindFirstChild("Waves") as Folder;

///! REWORK
Workspace.SetAttribute("MapName", `DesertMap`);

const SpawnPart = Workspace.FindFirstChild("DesertMap")
	?.FindFirstChild("Waypoints")
	?.FindFirstChild("Spawn") as BasePart;

Workspace.SetAttribute("MapName", "DesertMap");

if (!RunService.IsStudio) {
	Workspace.FindFirstChild("DesertMap")
		?.FindFirstChild("Waypoints")
		?.GetChildren()
		.forEach((Child, _) => {
			const C = Child as BasePart;
			C.Transparency = 1;
		});
}

task.wait(10);

for (let i = 0; i < 1001; i++) {
	const newEnemy = new Enemy({
		Id: undefined,
		ModelName: "TestEnemy",
		Health: new Random().NextInteger(10, 1000),
		IsAir: false,
		EnemyType: "Normal",
		Speed: 1,
		SpawnCFrame: SpawnPart.GetPivot(),
	});

	EntitiesHandler.AddEnemy(newEnemy);

	task.wait(0.5);
}
