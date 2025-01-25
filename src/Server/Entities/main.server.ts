import { ReplicatedStorage, ServerScriptService, Workspace } from "@rbxts/services";
import { ServerEvents } from "Server/Modules/ServerNetworking";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";
import { newEnemyPacketSerializer } from "Shared/CoreLibs/Networking/BinarySerializers";
Workspace.SetAttribute("MapName", "Desert");
Workspace.SetAttribute("IsReady", true);

import { Start } from "Shared/start";

const World = Start(
	[
		ReplicatedStorage.FindFirstChild("Modules")?.FindFirstChild("Systems") as Folder,
		ServerScriptService.FindFirstChild("Entities")?.FindFirstChild("Systems") as Folder,
	],
	ServerScriptService.FindFirstChild("Entities")?.FindFirstChild("Plugins") as Folder,
);

///! DEBUG
task.wait(10);

for (let _ = 0; _ < 100; _++) {
	const EnemyPacket = newEnemyPacketSerializer.serialize({
		ModelName: "TestEnemy",
		Type: Enumerators.EnemyType.Normal,
		IsAir: false,
		Speed: 2,
		MaxHealth: 100,
	});

	ServerEvents.EnemyAdded.broadcast(EnemyPacket.buffer);

	World.spawn(
		EnemyInfo({
			ModelName: "TestEnemy",
			Type: Enumerators.EnemyType.Normal,
			IsAir: false,
			PathProgress: 0,
			MaxHealth: 100,
			Health: 100,
			Speed: 2,
		}),
		// DebugPart(),
	);

	task.wait(0.3);
}
