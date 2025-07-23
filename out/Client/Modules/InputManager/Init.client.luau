-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local InputManager = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager")
local Actions = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager", "Actions")
local handleInput = function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return nil
	end
	-- ▼ ReadonlyMap.forEach ▼
	local _callback = function(actionBindings, actionName)
		-- ▼ ReadonlyArray.find ▼
		local _callback_1 = function(Binding)
			return Binding == input.KeyCode or Binding == input.UserInputType
		end
		local _result
		for _i, _v in actionBindings do
			if _callback_1(_v, _i - 1, actionBindings) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		if _result then
			local Key = if input.KeyCode ~= Enum.KeyCode.Unknown then input.KeyCode else input.UserInputType
			InputManager.invokeAction(actionName, input.UserInputState, Key)
		end
	end
	for _k, _v in Actions do
		_callback(_v, _k, Actions)
	end
	-- ▲ ReadonlyMap.forEach ▲
end
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	return handleInput(input, gameProcessedEvent)
end)
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	return handleInput(input, gameProcessedEvent)
end)
