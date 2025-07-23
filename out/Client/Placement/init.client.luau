-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ClientData = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Data")
local InputManager = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager")
local Placement = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Placement", "Placement")
local handleAction = function(InputAction)
	local slotNum = tonumber(InputAction.Action)
	if slotNum ~= nil then
		local playerLoadout = ClientData.data.Loadout
		local playerTowersInventory = ClientData.data.TowersInventory
		if (playerLoadout())[slotNum + 1] ~= "" then
			local _result = (playerTowersInventory())
			if _result ~= nil then
				local _arg0 = (playerLoadout())[slotNum + 1]
				_result = _result[_arg0]
			end
			local tower = _result
			if Placement.currentSlot == nil then
				Placement.Start(tower.Name)
				Placement.currentSlot = slotNum
			elseif Placement.currentSlot == slotNum then
				Placement.Stop()
			else
				Placement.Stop()
				Placement.Start(tower.Name)
				Placement.currentSlot = slotNum
			end
		end
	end
end
local onClick = function()
	if not Placement.isPlacing then
		return nil
	end
	Placement.Place()
end
InputManager.listenToAction("Click"):Connect(function()
	return onClick()
end)
InputManager.actionBegan:Connect(function(InputAction)
	return handleAction(InputAction)
end)
