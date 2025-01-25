import { ReplicatedStorage } from "@rbxts/services";
import { Start } from "Shared/start";

Start(
	[
		ReplicatedStorage.FindFirstChild("Modules")?.FindFirstChild("Systems") as Folder,
		ReplicatedStorage.FindFirstChild("Client")?.FindFirstChild("Entities")?.FindFirstChild("Systems") as Folder,
	],
	ReplicatedStorage.FindFirstChild("Client")?.FindFirstChild("Entities")?.FindFirstChild("Plugins") as Folder,
);
