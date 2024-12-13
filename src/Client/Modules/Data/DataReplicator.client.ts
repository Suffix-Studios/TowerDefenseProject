import { ClientEvents, ClientFunctions } from "Client/Modules/ClientNetworking";
import ClientData from ".";

ClientEvents.ReplicateData.connect((newData) => {
    ClientData.SetData(newData);
})

/// Init
ClientFunctions.RequestData.invoke().then((newData) => ClientData.SetData(newData));
