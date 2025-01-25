import { World } from "@rbxts/matter";
import { Workspace } from "@rbxts/services";
import DataService from "Server/Modules/DataService";
import { ServerEvents } from "Server/Modules/ServerNetworking";
import { InventoryTower } from "Server/Modules/ServerTypes";
import { TowerInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";
import { newTowerPacketSerializer } from "Shared/CoreLibs/Networking/BinarySerializers";
import TowersInfo from "Shared/TowersInfo";

const IsCloseToOtherTowers = (World: World, Position: Vector3): boolean => {
	for (const [id, EntityTowerInfo] of World.query(TowerInfo)) {
		if (EntityTowerInfo.Position.sub(Position).Magnitude <= 2.5) return true;
	}

	return false;
};

const IsValidPlacement = (
	Player: Player,
	PlacementType: string,
	RayOrigin: Vector3,
	RayDirection: Vector3,
): LuaTuple<[boolean, Vector3]> => {
	const Params = new RaycastParams();
	Params.FilterType = Enum.RaycastFilterType.Exclude;
	Params.FilterDescendantsInstances = [Player.Character as Model];

	const Raycast = Workspace.Raycast(RayOrigin, RayDirection.mul(100), Params);

	return $tuple(Raycast?.Instance.HasTag(PlacementType) || false, Raycast?.Position as Vector3);
};

const TowerPlacement = (World: World) => {
	ServerEvents.PlaceTower.connect((Player, RayOrigin, RayDirection, Slot) => {
		const PlayerData = DataService.GetData(Player);
		const PlayerLoadout = PlayerData?.Loadout;
		const PlayerTowersInventory = PlayerData?.TowersInventory;

		if (PlayerLoadout && PlayerTowersInventory) {
			const TowerId = PlayerLoadout.get(Slot) as string;
			const TowerInInventory = PlayerTowersInventory.get(TowerId) as InventoryTower;

			const TowerName = TowerInInventory.Name;
			const TargetTowerInfo = TowersInfo.get(TowerName);
			const RaycastResult = IsValidPlacement(Player, TargetTowerInfo?.Type as string, RayOrigin, RayDirection);
			const IsValid = RaycastResult[0];

			if (!IsValid || IsCloseToOtherTowers(World, RaycastResult[1])) return;

			World.spawn(
				TowerInfo({
					TowerName: TowerName,
					Owner: Player.UserId,
					Upgrade: 0,

					Position: RaycastResult[1],
					Priority: Enumerators.TowerPriority.First,
				}),
			);

			const TowerPacket = newTowerPacketSerializer.serialize({
				Position: {
					X: RaycastResult[1].X,
					Y: RaycastResult[1].Y,
					Z: RaycastResult[1].Z,
				},

				Owner: tostring(Player.UserId),
				TowerName: TowerName,
			});

			ServerEvents.TowerAdded.broadcast(TowerPacket.buffer);
		}
	});
};

export = TowerPlacement;
