import { component } from "@rbxts/matter";

export type Character = ReturnType<typeof Character>;
export const Character = component<{ Model: Model; Animation: AnimationTrack }>("Character");
