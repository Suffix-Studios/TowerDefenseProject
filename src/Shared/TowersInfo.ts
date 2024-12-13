type TowerInfo = {
    Damage: number,
    Range: number,
    SPA: number,

    Limit: number,
    Type: string,
    Cost: number

    AttackInfo: object

    Upgrades: {Damage: number, SPA: number, Range: number, Cost: number}[]
}

const TowersInfo = new ReadonlyMap<string, TowerInfo>([
	["TestTower_Single", {
		Damage: 25,
		SPA: 1,
		Range: 20,

		Limit: 6,
		Type: "Ground",
		Cost: 500,

		AttackInfo: {
			Type: "Single",
		},

		Upgrades: [
			{
				Damage: 20,
				SPA: 6,
				Range: 32,

				Cost: 650,
            },
			{
				Damage: 31,
				SPA: 4.5,
				Range: 37,

				Cost: 900,
			},
			{
				Damage: 43,
				SPA: 2,
				Range: 45,

				Cost: 1500,
			},
        ],
	}],

	["TestTower_Cone", {
		Damage: 25,
		SPA: 1,
		Range: 20,

		Limit: 6,
		Type: "Ground",
		Cost: 500,

		AttackInfo: {
			Type: "Cone",
			Angle: 45,
		},

		Upgrades: [
			{
				Damage: 20,
				SPA: 6,
				Range: 32,

				Cost: 650,
            },
			{
				Damage: 31,
				SPA: 4.5,
				Range: 37,

				Cost: 900,
			},
			{
				Damage: 43,
				SPA: 2,
				Range: 45,

				Cost: 1500,
			},
        ],
	}],

	["TestTower_Circle", {
		Damage: 25,
		SPA: 1,
		Range: 20,

		Limit: 6,
		Type: "Ground",
		Cost: 500,

		AttackInfo: {
			Type: "Circle",
			Size: 5,
		},

		Upgrades: [
			{
				Damage: 20,
				SPA: 6,
				Range: 32,

				Cost: 650,
            },
			{
				Damage: 31,
				SPA: 4.5,
				Range: 37,

				Cost: 900,
			},
			{
				Damage: 43,
				SPA: 2,
				Range: 45,

				Cost: 1500,
			},
        ],
	}],

	["TestTower_Full", {
		Damage: 25,
		SPA: 1,
		Range: 20,

		Limit: 6,
		Type: "Ground",
		Cost: 500,

		AttackInfo: {
			Type: "Full",
		},

		Upgrades: [
			{
				Damage: 20,
				SPA: 6,
				Range: 32,

				Cost: 650,
            },
			{
				Damage: 31,
				SPA: 4.5,
				Range: 37,

				Cost: 900,
			},
			{
				Damage: 43,
				SPA: 2,
				Range: 45,

				Cost: 1500,
			},
        ],
	}],
])

export = TowersInfo;
