-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lemon-signal", "src").default
local Actions = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager", "Actions")
local InputManager
do
	InputManager = {}
	function InputManager:constructor()
	end
	function InputManager.InvokeAction(ActionName, State, Key)
		local _actionName = ActionName
		local _arg0 = Actions[_actionName] ~= nil
		local _arg1 = `Invalid Action Name, Not Valid Action With Name {ActionName}`
		assert(_arg0, _arg1)
		local ActionInfo = {
			Action = ActionName,
			State = State,
			Key = if Key == nil then Key else Enum.KeyCode.Unknown,
		}
		if State == Enum.UserInputState.Begin then
			InputManager.ActionBegan:Fire(ActionInfo)
		else
			InputManager.ActionEnded:Fire(ActionInfo)
		end
		local __actionsSignals = InputManager._actionsSignals
		local _actionName_1 = ActionName
		if __actionsSignals[_actionName_1] ~= nil then
			local __actionsSignals_1 = InputManager._actionsSignals
			local _actionName_2 = ActionName
			local _result = __actionsSignals_1[_actionName_2]
			if _result ~= nil then
				_result:Fire(ActionInfo)
			end
		end
	end
	function InputManager.BindActionToButton(Button, ActionName)
		if not Button then
			return nil
		end
		Button.Activated:Connect(function()
			InputManager.InvokeAction(ActionName, Enum.UserInputState.Begin, nil)
		end)
	end
	function InputManager.ListenToAction(ActionName)
		local _actionName = ActionName
		local _arg0 = Actions[_actionName] ~= nil
		local _arg1 = `Invalid Action Name, Not Valid Action With Name {ActionName}`
		assert(_arg0, _arg1)
		local ActionSignal
		local __actionsSignals = InputManager._actionsSignals
		local _actionName_1 = ActionName
		if __actionsSignals[_actionName_1] ~= nil then
			local __actionsSignals_1 = InputManager._actionsSignals
			local _actionName_2 = ActionName
			ActionSignal = __actionsSignals_1[_actionName_2]
		else
			ActionSignal = Signal.new()
			local __actionsSignals_1 = InputManager._actionsSignals
			local _actionName_2 = ActionName
			local _actionSignal = ActionSignal
			__actionsSignals_1[_actionName_2] = _actionSignal
		end
		return ActionSignal
	end
	InputManager.ActionBegan = Signal.new()
	InputManager.ActionEnded = Signal.new()
	InputManager._actionsSignals = {}
end
return InputManager
