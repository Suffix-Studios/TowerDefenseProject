-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Jabby = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "jabby", "out")
local planck = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "planck", "out")
local PlankJabbyPlugin = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "planck-jabby", "out")
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContextActionService = _services.ContextActionService
local RunService = _services.RunService
local Plugin = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "Phases").Plugin
local world = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "CoreLibs", "World")
local jabbyPlugin = PlankJabbyPlugin.new()
local phasesPlugin = Plugin.new()
local scheduler = planck.Scheduler.new(world):addPlugin(jabbyPlugin):addPlugin(phasesPlugin)
local systems = {}
local loadSystems
loadSystems = function(directory)
	local _exp = directory:GetChildren()
	-- ▼ ReadonlyArray.forEach ▼
	local _callback = function(child)
		if child:IsA("Folder") then
			loadSystems(child)
		elseif child:IsA("ModuleScript") then
			local success, system = pcall(require, child)
			if success then
				table.insert(systems, system)
			end
		end
	end
	for _k, _v in _exp do
		_callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
end
local loadDirectories = function(directories)
	-- ▼ ReadonlyArray.forEach ▼
	local _callback = function(child, _)
		if child:IsA("Folder") then
			loadSystems(child)
		else
			warn(`Invalid Directory, Folder Expected Got {child.ClassName}`)
		end
	end
	for _k, _v in directories do
		_callback(_v, _k - 1, directories)
	end
	-- ▲ ReadonlyArray.forEach ▲
	if RunService:IsClient() then
		local client = Jabby.obtain_client()
		-- eslint-disable-next-line no-inner-declarations
		local function createWidget(_, state)
			print("UWU")
			if state ~= Enum.UserInputState.Begin then
				return nil
			end
			client.spawn_app(client.apps.home)
		end
		ContextActionService:BindAction("Open Jabby", createWidget, false, Enum.KeyCode.F4)
	end
	Jabby.register({
		applet = Jabby.applets.world,
		name = "Jecs World",
		configuration = {
			world = world,
		},
	})
	if #systems < 1 then
		return nil
	end
	scheduler:addSystems(systems)
end
return {
	loadDirectories = loadDirectories,
}
