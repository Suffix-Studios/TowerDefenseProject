-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lemon-signal", "src").default
local _signals = {}
local DeepEquals
DeepEquals = function(t1, t2)
	for index, value in pairs(t1) do
		--/ Checking if the value of the same index is nil on the second table
		if t2[index] == nil then
			return false
		else
			--/ Checking if they are the same type (same values must be same type duh)
			local _exp = typeof(value)
			local _arg0 = t2[index]
			if _exp ~= typeof(_arg0) then
				return false
			else
				--/ compare normally if the value isn't nil
				if typeof(value) ~= "table" then
					if t2[index] ~= value then
						return false
					end
				else
					if DeepEquals(t2[index], value) then
						return false
					end
				end
			end
		end
	end
	return true
end
local ClientData
do
	ClientData = {}
	function ClientData:constructor()
	end
	function ClientData.SetData(newData)
		if not newData then
			return nil
		end
		print("Data Set!")
		local oldData = ClientData.Data
		ClientData.Data = newData
		ClientData.Changed:Fire(newData)
		if not ClientData.isReady then
			ClientData.isReady = true
		end
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(signal, DataName)
			local _newData = newData
			if typeof(_newData) == "table" then
				if DeepEquals(newData[DataName], oldData[DataName]) then
					signal:Fire(newData[DataName])
				end
			else
				signal:Fire(newData[DataName])
			end
		end
		for _k, _v in _signals do
			_callback(_v, _k, _signals)
		end
		-- ▲ ReadonlyMap.forEach ▲
	end
	function ClientData.GetDataValueChangedSignal(DataName)
		while not ClientData.isReady do
			task.wait()
		end
		local _arg0 = ClientData.Data[DataName]
		local _arg1 = `Invalid Argument #1, Player Has No Data With Name \{DataName\}`
		assert(_arg0, _arg1)
		if ClientData.Data[DataName] ~= nil then
			local __signals = _signals
			local _dataName = DataName
			if __signals[_dataName] ~= nil then
				local __signals_1 = _signals
				local _dataName_1 = DataName
				return __signals_1[_dataName_1]
			else
				local dataSignal = Signal.new()
				local __signals_1 = _signals
				local _dataName_1 = DataName
				local _dataSignal = dataSignal
				__signals_1[_dataName_1] = _dataSignal
				return dataSignal
			end
		end
	end
	ClientData.isReady = false
	ClientData.Changed = Signal.new()
end
return ClientData
