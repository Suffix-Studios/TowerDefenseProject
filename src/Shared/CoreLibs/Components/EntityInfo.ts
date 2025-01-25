import { Atom } from "@rbxts/charm";
import { component } from "@rbxts/matter";

export type EnemyInfo = ReturnType<typeof EnemyInfo>;
export const EnemyInfo = component<{
	ModelName: string;
	Type: number;
	IsAir: boolean;
	Speed: number;
	PathProgress: number;
	TargetPathProgress?: number;
	MaxHealth: number;

	Health?: number;
	AtomicHealth?: Atom<number>;
}>("EnemyInfo");

export type TowerInfo = ReturnType<typeof TowerInfo>;
export const TowerInfo = component<{
	TowerName: string;
	Owner: number;
	Upgrade: number;

	Position: Vector3;
	Priority: number;
}>("EnemyInfo");
