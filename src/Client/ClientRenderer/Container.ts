import { atom } from "@rbxts/charm";
import ClientTypes from "Client/Modules/ClientTypes";

const ClientEntitiesContainer = {
	Enemies: atom<ReadonlyMap<string, ClientTypes.Enemy>>(new ReadonlyMap<string, ClientTypes.Enemy>()),
};

export = ClientEntitiesContainer;
