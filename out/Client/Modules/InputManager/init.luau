-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lemon-signal", "src").default
local UserInputService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local Actions = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "Modules", "InputManager", "Actions")
local InputManager = {}
do
	local _container = InputManager
	local ActionBegan = Signal.new()
	_container.ActionBegan = ActionBegan
	local ActionEnded = Signal.new()
	_container.ActionEnded = ActionEnded
	local _actionsSignals = {}
	local InvokeAction = function(ActionName, State, Key)
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
			ActionBegan:Fire(ActionInfo)
		else
			ActionEnded:Fire(ActionInfo)
		end
		local _actionName_1 = ActionName
		if _actionsSignals[_actionName_1] ~= nil then
			local _actionName_2 = ActionName
			local _result = _actionsSignals[_actionName_2]
			if _result ~= nil then
				_result:Fire(ActionInfo)
			end
		end
	end
	_container.InvokeAction = InvokeAction
	local BindActionToButton = function(Button, ActionName)
		if not Button then
			return nil
		end
		Button.Activated:Connect(function()
			InvokeAction(ActionName, Enum.UserInputState.Begin, nil)
		end)
	end
	_container.BindActionToButton = BindActionToButton
	local ListenToAction = function(ActionName)
		local _actionName = ActionName
		local _arg0 = Actions[_actionName] ~= nil
		local _arg1 = `Invalid Action Name, Not Valid Action With Name {ActionName}`
		assert(_arg0, _arg1)
		local ActionSignal
		local _actionName_1 = ActionName
		if _actionsSignals[_actionName_1] ~= nil then
			local _actionName_2 = ActionName
			ActionSignal = _actionsSignals[_actionName_2]
		else
			ActionSignal = Signal.new()
			local _actionName_2 = ActionName
			local _actionSignal = ActionSignal
			_actionsSignals[_actionName_2] = _actionSignal
		end
		return ActionSignal
	end
	_container.ListenToAction = ListenToAction
	local IsActionHeld = function(ActionName)
		local _actionName = ActionName
		local _arg0 = Actions[_actionName] ~= nil
		assert(_arg0, "Invalid Action Name!")
		local _actionName_1 = ActionName
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
	_container.IsActionHeld = IsActionHeld
end
return InputManager
