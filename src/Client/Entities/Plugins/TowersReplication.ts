import { World } from "@rbxts/matter";
import { ReplicatedStorage, Workspace } from "@rbxts/services";
import { ClientEvents } from "Client/Modules/ClientNetworking";
import { Character } from "Shared/CoreLibs/Components/Character";
import { TowerInfo } from "Shared/CoreLibs/Components/EntityInfo";
import Enumerators from "Shared/CoreLibs/Enumerators";
import { newTowerPacketSerializer } from "Shared/CoreLibs/Networking/BinarySerializers";

const TowersModels = ReplicatedStorage.FindFirstChild("TowersModels") as Folder;
const Animations = ReplicatedStorage.FindFirstChild("Animations") as Folder;

const TowersReplication = (World: World): void => {
	ClientEvents.TowerAdded.connect((SerializedTowerPacket) => {
		const TowerPacket = newTowerPacketSerializer.deserialize(SerializedTowerPacket);
		const TowerModel = TowersModels.FindFirstChild(TowerPacket.TowerName)?.Clone() as Model;
		const Position = new Vector3(TowerPacket.Position.X, TowerPacket.Position.Y, TowerPacket.Position.Z);

		TowerModel.PivotTo(new CFrame(Position));
		TowerModel.Parent = Workspace.FindFirstChild("PlacedTowers");

		const AnimationController = TowerModel.FindFirstChild("AnimationController") as AnimationController;
		const Animator = AnimationController.FindFirstChild("Animator") as Animator;
		const AnimationTrack = Animator.LoadAnimation(Animations.FindFirstChild("TowerIdle") as Animation);

		AnimationTrack.Play();

		World.spawn(
			TowerInfo({
				TowerName: TowerPacket.TowerName,
				Owner: tonumber(TowerPacket.TowerName) as number,
				Position: Position,

				Priority: Enumerators.TowerPriority.First,
				Upgrade: 0,
			}),
			Character({
				Model: TowerModel,
				Animation: AnimationTrack,
			}),
		);
	});
};

export = TowersReplication;
