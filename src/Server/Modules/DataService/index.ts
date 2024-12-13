/// Services
import { RunService, Players, HttpService } from "@rbxts/services";

/// Packages
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import TowersInfo from "Shared/TowersInfo";
import ServerTypes from "../ServerTypes";
import { ServerEvents, ServerFunctions } from "../ServerNetworking";

const DataTemplate = {
    Gold: 0,
	Silver: 100,

	Level: 1,
	Exp: 0,

	MaxTowers: 60,

	TowersInventory: new Map<string, ServerTypes.InventoryTower>, ///! Change To Tower Type
	Loadout: new Map<string, string>([
		["Slot 1", ""],
		["Slot 2", ""],
		["Slot 3", ""],
		["Slot 4", ""],
		["Slot 5", ""],
	    ["Slot 6", ""],
    ])
}

const StartingTowers = [ ///! DONT FUCKING MAKE IT MORE THAN 6
    "TestTower_Single",
    "TestTower_Cone",
    "TestTower_Circle",
    "TestTower_Full"
];

const ProfileStore = RunService.IsStudio() ?
    ProfileService.GetProfileStore("Players_Data_xxx0", DataTemplate).Mock :
    ProfileService.GetProfileStore("Players_Data_xxx0", DataTemplate);

let Profiles = new Map<Player, Profile<typeof DataTemplate, unknown>>;

const GetUniqueTowerId = (Player: Player, TowerName: string): string => {
	return `${TowerName}-${Player.UserId}_${HttpService.GenerateGUID(false)}`
}

const ReplicateData = (Player: Player, Data: typeof DataTemplate): void => {
    ServerEvents.ReplicateData.fire(Player, Data);
}

ServerFunctions.RequestData.setCallback((Player): any => {
    if (!Profiles.has(Player)) {
        for (let i = 1; i < 10; i++) {
            task.wait(1);
            if (Profiles.has(Player)) break;
        }

        if (!Profiles.has(Player)) {
            Player.Kick("Player Data Couldn't Be Loaded.");
        }

        return Profiles.get(Player)?.Data
    }
})

namespace DataService {
    export const LoadProfile = (Player: Player): void => {
        const PlayerProfile = ProfileStore.LoadProfileAsync(`Player_${Player.UserId}`);

        if (PlayerProfile) {
            PlayerProfile.AddUserId(Player.UserId);
            PlayerProfile.Reconcile();

            PlayerProfile.ListenToRelease(() => {
                Profiles.delete(Player);
                Player.Kick("Player Profile Released! Rejoin If This Is An Error.");
            })

            if (Player.IsDescendantOf(Players)) {
                Profiles.set(Player, PlayerProfile)

                if (PlayerProfile.Data.TowersInventory.size() === 0) {
                    for (let i = 0; i < StartingTowers.size(); i++) {
                        const newTower = DataService.GiveTower(Player, StartingTowers[i]);

                        if (newTower) PlayerProfile.Data.Loadout.set(`Slot ${i + 1}`, newTower );
                    }
                }
            } else {
                Player.Kick("Data Wasn't Loaded Successfully! Try Again Later.");
            }
        }
    };

    export const UnloadProfile = (Player: Player): void => {
        const PlayerProfile = Profiles.get(Player);

        if(PlayerProfile) {
            PlayerProfile.Release();
        }
    };

    export const GiveTower = (Player: Player, TowerName: string): string | undefined => {
        let PlayerProfile = Profiles.get(Player);
        const Info = TowersInfo.get(TowerName);

        if (Info && PlayerProfile) {
            let newTower: ServerTypes.InventoryTower = {
                Exp: 0,
                Name: TowerName,
                Level: 1
            };

            const TowerId = GetUniqueTowerId(Player, TowerName)
            PlayerProfile.Data.TowersInventory.set(TowerId, newTower);
            return TowerId;
        }

        return undefined;
    }

    export const GetData = (Player: Player): typeof DataTemplate | undefined => {
        const PlayerProfile = Profiles.get(Player);

        if (PlayerProfile) {
            return PlayerProfile.Data;
        } else {
            return undefined;
        }
    }

    export const SetData = (Player: Player, DataName: string, newValue: any): void => {
        let PlayerProfile = Profiles.get(Player);

        if (PlayerProfile) {
            print(PlayerProfile.Data);
            assert(PlayerProfile.Data[DataName as keyof typeof DataTemplate] !== undefined, `Invalid Argument #2, Player Has No Data With Name ${DataName}!`);
		    assert(typeIs(PlayerProfile.Data[DataName as keyof typeof DataTemplate], typeOf(newValue)), "Invalid Argument #3");

            PlayerProfile.Data[DataName as keyof typeof DataTemplate] = newValue;
            ReplicateData(Player, PlayerProfile.Data)
        }
    }
}

export = DataService;
