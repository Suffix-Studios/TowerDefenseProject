import { Atom } from "@rbxts/charm";
import { Node } from "@rbxts/vide";
import Enumerators from "Shared/CoreLibs/Enumerators";

namespace ClientTypes {
    export type InputAction = {
        Action: string
        State: Enum.UserInputState
        Key: Enum.UserInputType | Enum.KeyCode
    }

    export type Enemy = {
        Id: string
        MaxHealth: number, Health: Atom<number>
        ModelName: string
        Speed: number
        Type: keyof typeof Enumerators.EnemyType
        IsAir: boolean
        Character: Model
        Animation: AnimationTrack

        CheckAnimation: (this:Enemy) => void
        Remove: (this: Enemy) => void
        Move: (this: Enemy, TargetCFrame: CFrame) => void
    }
}

export = ClientTypes;
