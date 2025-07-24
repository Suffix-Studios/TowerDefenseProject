import { Players } from "@rbxts/services";

Players.PlayerAdded.Connect((Player) => {
	Player.CharacterAdded.Connect((character) => {
		character.GetDescendants().forEach((Descendant) => {
			if (Descendant.IsA("BasePart")) {
				Descendant.CollisionGroup = "Players";
			}
		});
	});
});

const [s, e] = pcall(
	require,
	(script.Parent?.FindFirstChild("Modules") as Folder).FindFirstChild("PlayerDataService") as ModuleScript,
);

if (!s) {
	error(`Failed to load PlayerDataService: ${e}`);
}
