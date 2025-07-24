-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
local ClientData = {}
do
	local _container = ClientData
	_container.isReady = false
	local SetData = function(newData)
		if not newData then
			return nil
		end
		if not _container.isReady then
			--/ Init
			_container.data = {}
			for DataName, DataValue in pairs(newData) do
				local _data = _container.data
				local _arg1 = atom(DataValue)
				_data[DataName] = _arg1
			end
			_container.isReady = true
			return nil
		end
		for dataKey, dataValue in pairs(newData) do
			local _result = _container.data[dataKey]
			if _result ~= nil then
				_result(dataValue)
			end
		end
	end
	_container.SetData = SetData
end
return ClientData
