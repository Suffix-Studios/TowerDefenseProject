import ClientData from ".";
import { replicateData } from "../Network/PlayerData";
replicateData.on((newData) => {
	ClientData.SetData(newData);
});

/// Init
// requestData.invoke().andThen((newData) => ClientData.SetData(newData));
