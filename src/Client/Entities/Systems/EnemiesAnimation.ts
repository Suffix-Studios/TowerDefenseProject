import { AnySystem, World } from "@rbxts/matter";
import { Workspace } from "@rbxts/services";
import { Character } from "Shared/CoreLibs/Components/Character";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import { SystemPriorty } from "Shared/CoreLibs/Enumerators";

const Camera = Workspace.CurrentCamera as Camera;
const AnimationStartTime = os.clock();

const CharactersAnimation = (World: World) => {
	for (const [id, EntityCharacter] of World.query(Character, EnemyInfo)) {
		const OnScreen = Camera.WorldToScreenPoint(EntityCharacter.Model.GetPivot().Position)[1];
		const IsPlaying = EntityCharacter.Animation.IsPlaying;

		if (OnScreen && !IsPlaying) {
			EntityCharacter.Animation.Play();
			EntityCharacter.Animation.TimePosition =
				(os.clock() - AnimationStartTime) % EntityCharacter.Animation.Length;
		} else if (!OnScreen && IsPlaying) EntityCharacter.Animation.Stop();
	}
};

export = {
	system: CharactersAnimation,
	priority: SystemPriorty.Background,
	event: "default",
} as AnySystem;
