/* eslint-disable roblox-ts/no-array-pairs */
import { Players, ReplicatedStorage, RunService, Workspace } from "@rbxts/services";
import { Tower } from "Client/Modules/Network/Entities";
import TowersInfo from "Shared/TowersInfo";
import { GetScreenPointRay, raycastFromMouse, togglePlacedTowersHitbox } from "./PlacementUtils";

const Player = Players.LocalPlayer;
const Camera = Workspace.CurrentCamera as Camera;

const ValidPlacementRangeColor = "6acbff";
const InvalidPlacementRangeColor = "ff0000";

const TowersModels = ReplicatedStorage.FindFirstChild("TowersModels") as Folder;

namespace Placement {
	let _hollow: Model | undefined;
	let _placementConnection: RBXScriptConnection;

	export let currentSlot: number | undefined;
	export let isPlacing: boolean;

	const getMouseRayParams = (ignoreModel: Model): RaycastParams => {
		const mouseRayParams = new RaycastParams();
		mouseRayParams.FilterType = Enum.RaycastFilterType.Exclude;
		mouseRayParams.FilterDescendantsInstances = [
			Workspace.FindFirstChild("Enemies") as Folder,
			Player.Character as Model,
			ignoreModel,
		];

		return mouseRayParams;
	};

	const getPlacementModel = (modelName: string): Model | undefined => {
		let towerModel = TowersModels.FindFirstChild(modelName) as Model;

		if (towerModel) {
			towerModel = towerModel.Clone();

			for (const [_, descendant] of pairs(towerModel.GetDescendants())) {
				if (descendant.IsA("BasePart") && !descendant.HasTag("RedArea")) {
					descendant.Material = Enum.Material.ForceField;
					descendant.Transparency = 0.4;
				}
			}

			towerModel.Parent = Workspace;
			const rayResult = raycastFromMouse(getMouseRayParams(towerModel));

			towerModel.PivotTo(new CFrame(rayResult?.Position as Vector3));

			return towerModel;
		}

		return undefined;
	};

	export const Start = (TowerName: string): void => {
		const TowerInfo = TowersInfo.get(TowerName);
		if (!TowerInfo) return;

		print("Started Placing");

		_hollow = getPlacementModel(TowerName);
		/// Create Tower Range

		isPlacing = true;
		togglePlacedTowersHitbox(true);

		_placementConnection = RunService.RenderStepped.Connect(() => {
			const RayResult = raycastFromMouse(getMouseRayParams(_hollow as Model));

			if (RayResult) {
				const rayCFrame = new CFrame(RayResult.Position);
				const newCFrame = _hollow?.GetPivot().Lerp(rayCFrame, 0.15) as CFrame;

				_hollow?.PivotTo(newCFrame);
				/// Adjust Tower Range Color
			}
		});
	};

	export const Stop = (): void => {
		if (!Placement.isPlacing) return;

		print("Stopped Placing");

		togglePlacedTowersHitbox(false);

		_placementConnection.Disconnect();
		Placement.isPlacing = false;
		Placement.currentSlot = undefined;

		_hollow?.Destroy();
		_hollow = undefined;

		/// Destroy Tower Range
	};

	export const Place = (): void => {
		if (Placement.currentSlot !== undefined) {
			const Ray = GetScreenPointRay();
			Tower.placeTower.fire({ Origin: Ray.Origin, Direction: Ray.Direction, Slot: Placement.currentSlot });
			Placement.Stop();
		}
	};
}

export = Placement;
