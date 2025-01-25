import { DataType } from "@rbxts/flamework-binary-serializer";

export interface EnemyPacket {
	Id: DataType.u16;
	T: DataType.f32;
	Health: DataType.u32;
}

export interface newEnemyPacket {
	ModelName: string;
	Type: DataType.u8;
	IsAir: boolean;
	Speed: DataType.u8;
	MaxHealth: DataType.u32;
}

export interface newTowerPacket {
	TowerName: string;
	Owner: string;
	Position: { X: DataType.f32; Y: DataType.f32; Z: DataType.f32 };
}
