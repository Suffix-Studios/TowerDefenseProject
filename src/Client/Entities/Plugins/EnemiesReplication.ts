import { Atom, atom } from "@rbxts/charm";
import { AnyEntity, World } from "@rbxts/matter";
import { ReplicatedStorage, Workspace } from "@rbxts/services";
import { ClientEvents } from "Client/Modules/ClientNetworking";
import { CreateEnemyUI, DestroyEnemyUI } from "Client/UI/EnemiesUIRoot";
import MapPath from "Shared/BezierPath";
import { Character } from "Shared/CoreLibs/Components/Character";
import { EnemyInfo } from "Shared/CoreLibs/Components/EntityInfo";
import { EnemyPacketSerializer, newEnemyPacketSerializer } from "Shared/CoreLibs/Networking/BinarySerializers";

const EnemiesModels = ReplicatedStorage.WaitForChild("EnemiesModels") as Folder;
const AnimationsFolder = ReplicatedStorage.FindFirstChild("Animations") as Folder;

const EnemiesReplication = (World: World): void => {
	ClientEvents.EnemyAdded.connect((EnemyPacket) => {
		const newEnemyInfo = newEnemyPacketSerializer.deserialize(EnemyPacket);
		const WalkAnimation = AnimationsFolder.FindFirstChild("EnemyWalk") as Animation;

		let EnemyModel = EnemiesModels.FindFirstChild(newEnemyInfo.ModelName) as Model;

		if (EnemyModel === undefined) return;

		EnemyModel = EnemyModel.Clone();
		EnemyModel.Parent = Workspace.FindFirstChild("Enemies");
		EnemyModel.PivotTo(MapPath.CalculateUniformCFrame(0));

		const AnimationController = EnemyModel.FindFirstChildWhichIsA("AnimationController");
		const Animator = AnimationController?.FindFirstChildWhichIsA("Animator") as Animator;
		const AnimationTrack = Animator.LoadAnimation(WalkAnimation);

		const HealthAtom = atom(newEnemyInfo.MaxHealth);

		const EnemyId = World.spawn(
			EnemyInfo({
				ModelName: newEnemyInfo.ModelName,
				Speed: newEnemyInfo.Speed,
				MaxHealth: newEnemyInfo.MaxHealth,
				AtomicHealth: HealthAtom,
				IsAir: newEnemyInfo.IsAir,
				Type: newEnemyInfo.Type,
				PathProgress: 0,
				TargetPathProgress: 0,
			}),
			Character({ Model: EnemyModel, Animation: Animator.LoadAnimation(WalkAnimation) }),
		);

		CreateEnemyUI({
			EnemyId: EnemyId,
			EnemyHealth: HealthAtom,
			Adornee: EnemyModel.FindFirstChild("Head") as PVInstance,
		});
	});

	ClientEvents.ReplicateEnemies.connect((EnemiesPackets) => {
		EnemiesPackets.forEach((SerializedEnemyPacket) => {
			const EnemyPacket = EnemyPacketSerializer.deserialize(SerializedEnemyPacket);

			if (!World.contains(EnemyPacket.Id as AnyEntity)) return;

			const EntityEnemyInfo = World.get(EnemyPacket.Id, EnemyInfo)[0];
			const AtomicHealth = EntityEnemyInfo?.AtomicHealth as Atom<number>;
			AtomicHealth(EnemyPacket.Health);

			World.insert(
				EnemyPacket.Id as AnyEntity,
				(EntityEnemyInfo as EnemyInfo).patch({ TargetPathProgress: EnemyPacket.T }),
			);
		});
	});

	ClientEvents.EntityRemoved.connect((EnemyId) => {
		const EntityCharacter = World.get(EnemyId, Character)[0];
		if (EntityCharacter) EntityCharacter.Model.Destroy();

		World.despawn(EnemyId as AnyEntity);
		DestroyEnemyUI(EnemyId);
	});
};

export = EnemiesReplication;
