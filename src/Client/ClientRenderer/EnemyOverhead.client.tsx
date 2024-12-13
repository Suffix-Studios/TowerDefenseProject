import { Players } from "@rbxts/services";
import Vide, { For, root } from "@rbxts/vide";
import { EnemyHealthUI } from "Client/UI/EnemyHealth";
import ClientEntitiesContainer from "./Container";
import { useAtom } from "@rbxts/vide-charm";
import ClientTypes from "Client/Modules/ClientTypes";

const Player = Players.LocalPlayer as Player & {PlayerGui: PlayerGui};
const PlayerGui = Player.PlayerGui;

const App = () => {
    let Enemies = () => {
        return useAtom(ClientEntitiesContainer.Enemies)();
    }

    return <folder
        Parent={PlayerGui}
        Name={"EnemyOverheads"}
    >
        <For each={Enemies}>
            {(Enemy, _) => {

                return <EnemyHealthUI
                    Health={Enemy.Health}
                    MaxHealth={Enemy.MaxHealth}
                    Adornee={Enemy.Character.PrimaryPart as BasePart}
                    TextType="Number Only"
                />
            }}
        </For>
    </folder>
}

root(() => {
    <App />
})
