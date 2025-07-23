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
		local _exp = _container.data
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(DataAtom, DataName)
			DataAtom(newData[DataName])
		end
		for _k, _v in _exp do
			_callback(_v, _k, _exp)
		end
		-- ▲ ReadonlyMap.forEach ▲
	end
	_container.SetData = SetData
end
return ClientData
