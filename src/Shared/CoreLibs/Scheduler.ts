import Jabby from "@rbxts/jabby";
import jecs from "@rbxts/jecs";
import planck from "@rbxts/planck";
import PlankJabbyPlugin from "@rbxts/planck-jabby";
import { System } from "@rbxts/planck/out/types";
import { ContextActionService, RunService } from "@rbxts/services";
import { Plugin } from "./Phases";
import world from "./World";

const jabbyPlugin = new PlankJabbyPlugin();
const phasesPlugin = new Plugin();
const scheduler = new planck.Scheduler(world).addPlugin(jabbyPlugin).addPlugin(phasesPlugin);

const systems = new Array<System<[jecs.World]>>();

const loadSystems = (directory: Folder): void => {
	directory.GetChildren().forEach((child) => {
		if (child.IsA("Folder")) {
			loadSystems(child);
		} else if (child.IsA("ModuleScript")) {
			const [success, system] = pcall(require, child);

			if (success) systems.push(system as System<[jecs.World]>);
		}
	});
};

export const loadDirectories = (directories: Folder[]): void => {
	directories.forEach((child: Instance, _) => {
		if (child.IsA("Folder")) {
			loadSystems(child);
		} else {
			warn(`Invalid Directory, Folder Expected Got ${child.ClassName}`);
		}
	});

	if (RunService.IsClient()) {
		const client = Jabby.obtain_client();

		// eslint-disable-next-line no-inner-declarations
		function createWidget(_: string, state: Enum.UserInputState): void {
			print("UWU");
			if (state !== Enum.UserInputState.Begin) {
				return;
			}
			client.spawn_app(client.apps.home);
		}

		ContextActionService.BindAction("Open Jabby", createWidget, false, Enum.KeyCode.F4);
	}

	Jabby.register({
		applet: Jabby.applets.world,
		name: "Jecs World",
		configuration: {
			world: world,
		},
	});

	if (systems.size() < 1) return;
	scheduler.addSystems(systems);
};
