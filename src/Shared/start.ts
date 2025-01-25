import { AnySystem, Debugger, Loop, World } from "@rbxts/matter";
import Plasma from "@rbxts/plasma";
import { RunService, TextChatService, UserInputService } from "@rbxts/services";

const IsStudio = RunService.IsStudio();
const IsClient = RunService.IsClient();

export const Start = (SystemsContainers: Array<Folder>, PluginsContainer: Folder) => {
	const world = new World();

	const TheDebugger = new Debugger(Plasma);

	TheDebugger.authorize = (Player) => {
		return Player.UserId === 706235721 || Player.UserId === 3933265311;
	};

	const TheLoop = new Loop(world, TheDebugger.getWidgets());
	const LoadedSystems = new Array<AnySystem>();

	const LoadContainerSystems = (Container: Folder): void => {
		// eslint-disable-next-line roblox-ts/no-array-pairs
		for (const [_, Module] of ipairs(Container.GetChildren() as Array<ModuleScript>)) {
			if (!Module.IsA("ModuleScript")) continue;

			if (Module.IsA("Folder")) {
				LoadContainerSystems(Module);
				continue;
			}

			const [_, system] = pcall(require, Module) as LuaTuple<[boolean, AnySystem]>;
			LoadedSystems.push(system);
		}
	};

	for (const Container of SystemsContainers) {
		LoadContainerSystems(Container);
	}

	TheLoop.scheduleSystems(LoadedSystems);

	PluginsContainer.GetChildren().forEach((Module) => {
		const [_, Plugin] = pcall(require, Module as ModuleScript) as LuaTuple<[boolean, (world: World) => void]>;
		Plugin(world);
	});

	if (TheDebugger !== undefined) TheDebugger.autoInitialize(TheLoop);

	const events: {
		default: RBXScriptSignal;
		fixed?: RBXScriptSignal;
	} = IsClient
		? { default: RunService.RenderStepped, fixed: RunService.Heartbeat }
		: { default: RunService.Heartbeat };

	TheLoop.begin(events);

	if (IsClient) {
		UserInputService.InputBegan.Connect((Input) => {
			if (Input.KeyCode === Enum.KeyCode.F4) {
				TheDebugger?.toggle();
			}
		});

		let matterOpenCmd = TextChatService?.FindFirstChild("TextChatCommands")?.FindFirstChild("MatterOpenCmd") as
			| TextChatCommand
			| undefined;
		if (matterOpenCmd === undefined) {
			matterOpenCmd = new Instance("TextChatCommand");
			matterOpenCmd.Name = "MatterOpenCmd";
			matterOpenCmd.PrimaryAlias = "/matter";
			matterOpenCmd.SecondaryAlias = "/matterdebug";
			matterOpenCmd.Triggered.Connect(() => {
				TheDebugger?.toggle();
			});
			matterOpenCmd.Parent = TextChatService?.FindFirstChild("TextChatCommands");
		}
	}

	return world;
};
