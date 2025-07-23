import { Players } from "@rbxts/services";
import DataService from "./Modules/DataService";

Players.PlayerAdded.Connect((Player) => {
	Player.CharacterAdded.Connect((character) => {
		for (const [_, Descendant] of pairs(character.GetDescendants())) {
			if (Descendant.IsA("BasePart")) {
				Descendant.CollisionGroup = "Players";
			}
		}
	});

	DataService.LoadProfile(Player);
});

Players.PlayerRemoving.Connect((Player) => DataService.UnloadProfile(Player));
