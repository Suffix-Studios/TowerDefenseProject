import { Choose, Slider } from "@rbxts/ui-labs";
import Vide from "@rbxts/vide";
import { EnemyHealthUI } from "../Components/EnemyOverhead";
import { CreateVideWithAtomsStory } from "./StoryCreator";

const controls = {
	Health: Slider(100, 0, 100, 1),
	HealthAmountType: Choose(["Number Only", "Number Over Max", "Percentage"]),
};

const story = CreateVideWithAtomsStory(controls, (Controls, Parent) => {
	<EnemyHealthUI Health={Controls.Health} TextType={Controls.HealthAmountType} Parent={Parent} />;
});

export = story;
