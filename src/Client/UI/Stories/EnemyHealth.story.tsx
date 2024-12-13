// import { Workspace } from "@rbxts/services";
// import { Choose, CreateVideStory, InferVideProps, Slider } from "@rbxts/ui-labs";
// import Vide from "@rbxts/vide";
// import { EnemyHealthUI } from "Gui/EnemyHealth";

// const controls = {
//     MaxHealth: 100,
//     Health: Slider(100, 0, 100, 1),
//     BarColor: Color3.fromRGB(255, 0, 0),
//     HealthAmoutType: Choose(["Number Only", "Number Over Max", "Percentage"])
// }

// const story = {
//     vide: Vide,
//     controls: controls,

//     story: (props: InferVideProps<typeof controls>) => {
//         Vide.cleanup(()=> {
//             print("cleanup");
//         })

//         print(props.target)

//         return <EnemyHealthUI
//             Health={props.controls.Health}
//             MaxHealth={props.controls.MaxHealth}
//             BarColor={props.controls.BarColor}
//             TextType={props.controls.HealthAmoutType as Vide.Source<string>}
//         />;
//    }
// }

// export = story;
