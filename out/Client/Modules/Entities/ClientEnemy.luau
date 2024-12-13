-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--/ Services
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage = _services.ReplicatedStorage
local TweenService = _services.TweenService
local Workspace = _services.Workspace
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
--/ Instances
local EnemyModels = ReplicatedStorage:WaitForChild("EnemiesModels")
local EnemiesFolder = Workspace:WaitForChild("Enemies")
local Animations = ReplicatedStorage:WaitForChild("Animations")
local GameMap = Workspace:FindFirstChild(Workspace:GetAttribute("MapName"))
local _result = GameMap
if _result ~= nil then
	_result = _result:FindFirstChild("Waypoints")
end
local Waypoints = _result
local Camera = Workspace.CurrentCamera
local ClientEnemy
do
	ClientEnemy = setmetatable({}, {
		__tostring = function()
			return "ClientEnemy"
		end,
	})
	ClientEnemy.__index = ClientEnemy
	function ClientEnemy.new(...)
		local self = setmetatable({}, ClientEnemy)
		return self:constructor(...) or self
	end
	function ClientEnemy:constructor(Props)
		if not Waypoints then
			repeat
				do
					GameMap = Workspace:FindFirstChild(Workspace:GetAttribute("MapName"))
					local _result_1 = GameMap
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild("Waypoints")
					end
					Waypoints = _result_1
				end
			until GameMap
		end
		self.ModelName = Props.ModelName
		self.Id = Props.Id
		self.MaxHealth = Props.Health
		self.Health = atom(self.MaxHealth)
		self.IsAir = Props.IsAir
		self.Speed = Props.Speed
		self.Type = Props.EnemyType
		local _result_1 = EnemyModels:FindFirstChild(Props.ModelName)
		if _result_1 ~= nil then
			_result_1 = _result_1:Clone()
		end
		self.Character = _result_1
		self.Character.Parent = EnemiesFolder
		self.Character:PivotTo(Props.SpawnCFrame)
		self.Character.Name = Props.Id
		local AnimationController = self.Character:FindFirstChildWhichIsA("AnimationController")
		local Animator = AnimationController:FindFirstChild("Animator")
		self.Animation = Animator:LoadAnimation(Animations:FindFirstChild("EnemyWalk"))
		self.Animation:AdjustSpeed(self.Speed / 4)
	end
	function ClientEnemy:Move(TargetCFrame)
		local _result_1 = self.Character
		if _result_1 ~= nil then
			_result_1 = _result_1.PrimaryPart
		end
		local MovementTween = TweenService:Create(_result_1, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			CFrame = TargetCFrame,
		})
		MovementTween:Play()
		MovementTween.Completed:Wait()
		MovementTween:Destroy()
	end
	function ClientEnemy:Remove()
		local _result_1 = self.Character
		if _result_1 ~= nil then
			_result_1:Destroy()
		end
		setmetatable(self, nil)
		table.clear(self)
		table.freeze(self)
	end
	function ClientEnemy:CheckAnimation()
		local OnScreen = (select(2, Camera:WorldToScreenPoint(self.Character:GetPivot().Position)))
		local _condition = OnScreen
		if _condition then
			local _result_1 = self.Animation
			if _result_1 ~= nil then
				_result_1 = _result_1.IsPlaying
			end
			_condition = not _result_1
		end
		if _condition then
			local _result_1 = self.Animation
			if _result_1 ~= nil then
				_result_1:Play()
			end
		elseif not OnScreen and self.Animation.IsPlaying then
			self.Animation:Stop()
		end
	end
end
return ClientEnemy
