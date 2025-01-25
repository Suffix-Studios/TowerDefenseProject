-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ClientData = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "Data")
local InputManager = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager")
local Placement = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Placement", "Placement")
local HandleAction = function(InputAction)
	local SplittedActionName = string.split(InputAction.Action, " ")
	if SplittedActionName[1] == "Slot" then
		local PlayerLoadout = ClientData.Data.Loadout
		local PlayerTowersInventory = ClientData.Data.TowersInventory
		local _action = InputAction.Action
		if PlayerLoadout[_action] ~= "" then
			local _action_1 = InputAction.Action
			local _arg0 = PlayerLoadout[_action_1]
			local Tower = PlayerTowersInventory[_arg0]
			if Placement.CurrentSlot == nil then
				Placement.Start(Tower.Name)
				Placement.CurrentSlot = InputAction.Action
			elseif Placement.CurrentSlot == InputAction.Action then
				Placement.Stop()
			else
				Placement.Stop()
				Placement.Start(Tower.Name)
				Placement.CurrentSlot = InputAction.Action
			end
		end
	end
end
local OnClick = function(InputAction)
	if not Placement.isPlacing then
		return nil
	end
	Placement.Place()
end
InputManager.ListenToAction("Click"):Connect(function(InputAction)
	return OnClick(InputAction)
end)
InputManager.ActionBegan:Connect(function(InputAction)
	return HandleAction(InputAction)
end)
