import { component } from "@rbxts/matter";

export type DebugPart = ReturnType<typeof DebugPart>;
export const DebugPart = component<{
	Part?: BasePart;
}>("DebugPart");
