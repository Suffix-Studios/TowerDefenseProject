import Vide from "@rbxts/vide";
import { TowerRangeUI } from "../Components/TowerRange";
import { CreateVideWithAtomsStory } from "./StoryCreator";

const controls = {
	Color: Color3.fromHex("FFFFFF"),
};

const story = CreateVideWithAtomsStory(controls, (Controls, Parent) => {
	<TowerRangeUI Color={Controls.Color} Parent={Parent} />;
});

export = story;
