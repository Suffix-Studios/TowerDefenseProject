-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _matter = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "matter", "lib")
local Debugger = _matter.Debugger
local Loop = _matter.Loop
local World = _matter.World
local Plasma = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "plasma", "src")
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService = _services.RunService
local TextChatService = _services.TextChatService
local UserInputService = _services.UserInputService
local IsStudio = RunService:IsStudio()
local IsClient = RunService:IsClient()
local Start = function(SystemsContainers, PluginsContainer)
	local world = World.new()
	local TheDebugger = Debugger.new(Plasma)
	TheDebugger.authorize = function(Player)
		return Player.UserId == 706235721 or Player.UserId == 3933265311
	end
	local TheLoop = Loop.new(world, TheDebugger:getWidgets())
	local LoadedSystems = {}
	local LoadContainerSystems
	LoadContainerSystems = function(Container)
		-- eslint-disable-next-line roblox-ts/no-array-pairs
		for _, Module in ipairs(Container:GetChildren()) do
			if not Module:IsA("ModuleScript") then
				continue
			end
			if Module:IsA("Folder") then
				LoadContainerSystems(Module)
				continue
			end
			local _, system = pcall(require, Module)
			table.insert(LoadedSystems, system)
		end
	end
	for _, Container in SystemsContainers do
		LoadContainerSystems(Container)
	end
	TheLoop:scheduleSystems(LoadedSystems)
	local _exp = PluginsContainer:GetChildren()
	-- ▼ ReadonlyArray.forEach ▼
	local _callback = function(Module)
		local _, Plugin = pcall(require, Module)
		Plugin(world)
	end
	for _k, _v in _exp do
		_callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
	if TheDebugger ~= nil then
		TheDebugger:autoInitialize(TheLoop)
	end
	local events = if IsClient then {
		default = RunService.RenderStepped,
		fixed = RunService.Heartbeat,
	} else {
		default = RunService.Heartbeat,
	}
	TheLoop:begin(events)
	if IsClient then
		UserInputService.InputBegan:Connect(function(Input)
			if Input.KeyCode == Enum.KeyCode.F4 then
				local _result = TheDebugger
				if _result ~= nil then
					_result:toggle()
				end
			end
		end)
		local _result = TextChatService
		if _result ~= nil then
			_result = _result:FindFirstChild("TextChatCommands")
			if _result ~= nil then
				_result = _result:FindFirstChild("MatterOpenCmd")
			end
		end
		local matterOpenCmd = _result
		if matterOpenCmd == nil then
			matterOpenCmd = Instance.new("TextChatCommand")
			matterOpenCmd.Name = "MatterOpenCmd"
			matterOpenCmd.PrimaryAlias = "/matter"
			matterOpenCmd.SecondaryAlias = "/matterdebug"
			matterOpenCmd.Triggered:Connect(function()
				local _result_1 = TheDebugger
				if _result_1 ~= nil then
					_result_1:toggle()
				end
			end)
			local _result_1 = TextChatService
			if _result_1 ~= nil then
				_result_1 = _result_1:FindFirstChild("TextChatCommands")
			end
			matterOpenCmd.Parent = _result_1
		end
	end
	return world
end
return {
	Start = Start,
}
