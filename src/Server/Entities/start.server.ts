import { loadDirectories } from "Shared/CoreLibs/Scheduler";

const serverSystems = script.Parent?.FindFirstChild("Systems") as Folder;

loadDirectories([serverSystems]);
