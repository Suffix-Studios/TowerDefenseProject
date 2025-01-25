/// Services
import { HttpService, Players, RunService } from "@rbxts/services";

/// Packages
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import { PlayerDataTemplate } from "Shared/Constants";
import PublicTypes, { InventoryTower } from "Shared/CoreLibs/PublicTypes";
import TowersInfo from "Shared/TowersInfo";
import { ServerEvents, ServerFunctions } from "../ServerNetworking";

const StartingTowers = [
	///! DONT FUCKING MAKE IT MORE THAN `DataTemplate.Loadout.size()`
	"TestTower_Single",
	"TestTower_Cone",
	"TestTower_Circle",
	"TestTower_Full",
];

const ProfileStore = RunService.IsStudio()
	? ProfileService.GetProfileStore("Players_Data_xxx0", PlayerDataTemplate).Mock
	: ProfileService.GetProfileStore("Players_Data_xxx0", PlayerDataTemplate);

const Profiles = new Map<Player, Profile<PublicTypes.PlayerData, unknown>>();

const GetUniqueTowerId = (Player: Player, TowerName: string): string => {
	return `${TowerName}-${Player.UserId}_${HttpService.GenerateGUID(false)}`;
};

const ReplicateData = (Player: Player, Data: PublicTypes.PlayerData): void => {
	ServerEvents.ReplicateData.fire(Player, Data);
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
ServerFunctions.RequestData.setCallback((Player): any => {
	if (!Profiles.has(Player)) {
		for (let i = 1; i < 10; i++) {
			task.wait(1);
			if (Profiles.has(Player)) break;
		}

		if (!Profiles.has(Player)) {
			Player.Kick("Player Data Couldn't Be Loaded.");
		}

		return Profiles.get(Player)?.Data;
	}
});

namespace DataService {
	export const LoadProfile = (Player: Player): void => {
		const PlayerProfile = ProfileStore.LoadProfileAsync(`Player_${Player.UserId}`);

		if (PlayerProfile) {
			PlayerProfile.AddUserId(Player.UserId);
			PlayerProfile.Reconcile();

			PlayerProfile.ListenToRelease(() => {
				Profiles.delete(Player);
				Player.Kick("Player Profile Released! Rejoin If This Is An Error.");
			});

			if (Player.IsDescendantOf(Players)) {
				Profiles.set(Player, PlayerProfile);

				if (PlayerProfile.Data.TowersInventory.size() === 0) {
					for (let i = 0; i < StartingTowers.size(); i++) {
						const newTower = DataService.GiveTower(Player, StartingTowers[i]);

						if (newTower !== undefined) PlayerProfile.Data.Loadout.set(`Slot ${i + 1}`, newTower);
					}
				}
			} else {
				Player.Kick("Data Wasn't Loaded Successfully! Try Again Later.");
			}
		}
	};

	export const UnloadProfile = (Player: Player): void => {
		const PlayerProfile = Profiles.get(Player);

		if (PlayerProfile) {
			PlayerProfile.Release();
		}
	};

	export const GiveTower = (Player: Player, TowerName: string): string | undefined => {
		const PlayerProfile = Profiles.get(Player);
		const Info = TowersInfo.get(TowerName);

		if (Info && PlayerProfile) {
			const newTower: InventoryTower = {
				Exp: 0,
				Name: TowerName,
				Level: 1,
			};

			const TowerId = GetUniqueTowerId(Player, TowerName);
			PlayerProfile.Data.TowersInventory.set(TowerId, newTower);
			return TowerId;
		}

		return undefined;
	};

	export const GetData = (Player: Player): PublicTypes.PlayerData | undefined => {
		const PlayerProfile = Profiles.get(Player);

		if (PlayerProfile) {
			return PlayerProfile.Data;
		} else {
			return undefined;
		}
	};

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	export const SetData = (Player: Player, DataName: string, newValue: any): void => {
		const PlayerProfile = Profiles.get(Player);

		if (PlayerProfile) {
			print(PlayerProfile.Data);
			assert(
				PlayerProfile.Data[DataName as keyof PublicTypes.PlayerData] !== undefined,
				`Invalid Argument #2, Player Has No Data With Name ${DataName}!`,
			);
			assert(
				typeIs(PlayerProfile.Data[DataName as keyof PublicTypes.PlayerData], typeOf(newValue)),
				"Invalid Argument #3",
			);

			PlayerProfile.Data[DataName as keyof PublicTypes.PlayerData] = newValue;
			ReplicateData(Player, PlayerProfile.Data);
		}
	};
}

export = DataService;
