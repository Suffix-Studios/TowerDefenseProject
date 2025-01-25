/* eslint-disable roblox-ts/no-array-pairs */
import { Players, ReplicatedStorage, RunService, Workspace } from "@rbxts/services";
import { ClientEvents } from "Client/Modules/ClientNetworking";
import TowerRange from "Client/UI/TowerRanges";
import Enumerators from "Shared/CoreLibs/Enumerators";
import TowersInfo from "Shared/TowersInfo";
import { GetScreenPointRay, RaycastFromMouse, TogglePlacedTowersHitbox } from "./PlacementUtils";

const Player = Players.LocalPlayer;
const Camera = Workspace.CurrentCamera as Camera;

const ValidPlacementRangeColor = "6acbff";
const InvalidPlacementRangeColor = "ff0000";

const TowersModels = ReplicatedStorage.FindFirstChild("TowersModels") as Folder;

namespace Placement {
	let _hollow: Model | undefined;
	let _placementConnection: RBXScriptConnection;
	let _rangeDisplay: TowerRange | undefined;

	export let CurrentSlot: keyof typeof Enumerators.Slot | undefined;
	export let isPlacing: boolean;

	const GetMouseRayParams = (ignoreModel: Model): RaycastParams => {
		const MouseRayParams = new RaycastParams();
		MouseRayParams.FilterType = Enum.RaycastFilterType.Exclude;
		MouseRayParams.FilterDescendantsInstances = [
			Workspace.FindFirstChild("Enemies") as Folder,
			Player.Character as Model,
			ignoreModel,
		];

		return MouseRayParams;
	};

	const GetPlacementModel = (ModelName: string): Model | undefined => {
		let TowerModel = TowersModels.FindFirstChild(ModelName) as Model;

		if (TowerModel) {
			TowerModel = TowerModel.Clone();

			for (const [_, Descendant] of pairs(TowerModel.GetDescendants())) {
				if (Descendant.IsA("BasePart") && !Descendant.HasTag("RedArea")) {
					Descendant.Material = Enum.Material.ForceField;
					Descendant.Transparency = 0.4;
				}
			}

			TowerModel.Parent = Workspace;
			const RayResult = RaycastFromMouse(GetMouseRayParams(TowerModel));

			TowerModel.PivotTo(new CFrame(RayResult?.Position as Vector3));

			return TowerModel;
		}

		return undefined;
	};

	export const Start = (TowerName: string): void => {
		const TowerInfo = TowersInfo.get(TowerName);
		if (!TowerInfo) return;

		print("Started Placing");

		_hollow = GetPlacementModel(TowerName);
		_rangeDisplay = new TowerRange({
			Parent: _hollow as Model,
			RangeColor: Color3.fromHex(ValidPlacementRangeColor),
			RangeSize: TowerInfo.Range,
			TowerId: -100,
		});

		isPlacing = true;
		TogglePlacedTowersHitbox(true);

		_placementConnection = RunService.RenderStepped.Connect(() => {
			const RayResult = RaycastFromMouse(GetMouseRayParams(_hollow as Model));

			if (RayResult) {
				const RayCFrame = new CFrame(RayResult.Position);
				const newCFrame = _hollow?.GetPivot().Lerp(RayCFrame, 0.15) as CFrame;

				_hollow?.PivotTo(newCFrame);
				if (RayResult.Instance.HasTag(TowerInfo.Type)) {
					_rangeDisplay?.Color(Color3.fromHex(ValidPlacementRangeColor));
				} else {
					_rangeDisplay?.Color(Color3.fromHex(InvalidPlacementRangeColor));
				}
			}
		});
	};

	export const Stop = (): void => {
		if (!Placement.isPlacing) return;

		print("Stopped Placing");

		TogglePlacedTowersHitbox(false);

		_placementConnection.Disconnect();
		Placement.isPlacing = false;
		Placement.CurrentSlot = undefined;

		_hollow?.Destroy();
		_hollow = undefined;

		_rangeDisplay?.Destroy();
		_rangeDisplay = undefined;
	};

	export const Place = (): void => {
		const TargetCFrame = _hollow?.GetPivot();

		if (Placement.CurrentSlot !== undefined) {
			const Ray = GetScreenPointRay();
			ClientEvents.PlaceTower.fire(Ray.Origin, Ray.Direction, Placement.CurrentSlot);
			Placement.Stop();
		}
	};
}

export = Placement;
