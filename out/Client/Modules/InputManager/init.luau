-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lemon-signal", "src").default
local UserInputService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local Actions = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager", "Actions")
local InputManager = {}
do
	local _container = InputManager
	local actionBegan = Signal.new()
	_container.actionBegan = actionBegan
	local actionEnded = Signal.new()
	_container.actionEnded = actionEnded
	local _actionsSignals = {}
	local invokeAction = function(ActionName, State, Key)
		local _actionName = ActionName
		local _arg0 = Actions[_actionName] ~= nil
		local _arg1 = `Invalid Action Name, Not Valid Action With Name {ActionName}`
		assert(_arg0, _arg1)
		local actionInfo = {
			Action = ActionName,
			State = State,
			Key = if Key == nil then Key else Enum.KeyCode.Unknown,
		}
		if State == Enum.UserInputState.Begin then
			actionBegan:Fire(actionInfo)
		else
			actionEnded:Fire(actionInfo)
		end
		local _actionName_1 = ActionName
		if _actionsSignals[_actionName_1] ~= nil then
			local _actionName_2 = ActionName
			local _result = _actionsSignals[_actionName_2]
			if _result ~= nil then
				_result:Fire(actionInfo)
			end
		end
	end
	_container.invokeAction = invokeAction
	local listenToAction = function(actionName)
		local _actionName = actionName
		local _arg0 = Actions[_actionName] ~= nil
		local _arg1 = `Invalid Action Name, Not Valid Action With Name {actionName}`
		assert(_arg0, _arg1)
		local actionSignal
		local _actionName_1 = actionName
		if _actionsSignals[_actionName_1] ~= nil then
			local _actionName_2 = actionName
			actionSignal = _actionsSignals[_actionName_2]
		else
			actionSignal = Signal.new()
			local _actionName_2 = actionName
			local _actionSignal = actionSignal
			_actionsSignals[_actionName_2] = _actionSignal
		end
		return actionSignal
	end
	_container.listenToAction = listenToAction
	local isActionHeld = function(actionName)
		local _actionName = actionName
		local _arg0 = Actions[_actionName] ~= nil
		assert(_arg0, "Invalid Action Name!")
		local _actionName_1 = actionName
		local _result = Actions[_actionName_1]
		if _result ~= nil then
			-- ▼ ReadonlyArray.forEach ▼
			local _callback = function(Key)
				if UserInputService:IsKeyDown(Key) then
					return true
				end
			end
			for _k, _v in _result do
				_callback(_v, _k - 1, _result)
			end
			-- ▲ ReadonlyArray.forEach ▲
		end
		return false
	end
	_container.isActionHeld = isActionHeld
end
return InputManager
