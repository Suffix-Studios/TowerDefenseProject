import { loadDirectories } from "Shared/CoreLibs/Scheduler";

const clientSystems = script.Parent?.FindFirstChild("Systems") as Folder;

loadDirectories([clientSystems]);
