import Signal from "@rbxts/lemon-signal";

type data = {
    Data: object;
    Changed: Signal<object>, /// Returns New Data

    isReady: boolean,

    SetData: (newData: object) => void,
    GetDataValueChangedSignal: (DataName: string) => Signal<any> | undefined, /// Signal Returns New Data Value
}

let _signals = new Map<string, Signal<any>>();

const DeepEquals = (t1: object, t2: object): boolean => {
    for (const [index, value] of pairs(t1)) {
        /// Checking if the value of the same index is nil on the second table
        if (t2[index as keyof typeof t2] === undefined) {
            return false;
        } else {/// if the value isn't nil
            /// Checking if they are the same type (same values must be same type duh)
            if (typeOf(value) !== typeOf(t2[index as keyof typeof t2])) {
                return false;
            } else { /// if the two values are the same type
                /// compare normally if the value isn't nil
                if (typeOf(value) !== "table") {
                    if (t2[index as keyof typeof t2] !== value) {
                        return false;
                    }
                } else { /// if the value is a table, compare it again using this function (both values are tables at this point, so they are valid args for this function)
                    if (DeepEquals(t2[index as keyof typeof t2], value)) {
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

abstract class ClientData {
    public static isReady = false
    public static Data: {}

    public static Changed = new Signal<typeof ClientData.Data>()

    public static SetData(this: void, newData: object): void {
        if(!newData) {
            return
        }

        print("Data Set!");
        const oldData = ClientData.Data
        ClientData.Data = newData;
        ClientData.Changed.Fire(newData);

        if (!ClientData.isReady) {
            ClientData.isReady = true;
        }

        _signals.forEach((signal, DataName) => {
            if (typeOf(newData) === "table") {
                if (DeepEquals(newData[DataName as keyof typeof newData], oldData[DataName as keyof typeof oldData])) {
                    signal.Fire(newData[DataName as keyof typeof newData]);
                }
            } else {
                signal.Fire(newData[DataName as keyof typeof newData]);
            }
        })
    }

    public static GetDataValueChangedSignal(this: void, DataName: string): Signal<any> | undefined {
        while(!ClientData.isReady) {
            task.wait();
        }

        assert(ClientData.Data[DataName as keyof typeof ClientData.Data], `Invalid Argument #1, Player Has No Data With Name {DataName}`);

        if (ClientData.Data[DataName as keyof typeof ClientData.Data] !== undefined) {
            if (_signals.has(DataName)) {
                return _signals.get(DataName);
            } else {
                let dataSignal = new Signal<any>();
                _signals.set(DataName, dataSignal);

                return dataSignal;
            }
        }

    }
}

export = ClientData as data;
