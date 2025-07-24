import ClientData from ".";
import { PlayerData } from "../Network";

PlayerData.replicateData.on((newData) => {
	ClientData.SetData(newData);
});
