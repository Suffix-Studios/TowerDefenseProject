-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--/ Services
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage = _services.ReplicatedStorage
local Workspace = _services.Workspace
--/ Instances
local EnemyModels = ReplicatedStorage:WaitForChild("EnemiesModels")
local EnemiesFolder = Workspace:WaitForChild("Enemies")
local Animations = ReplicatedStorage:WaitForChild("Animations")
--/ Values
local EnemyBaseSpeed = 4
--/ Instances
local GameMap = Workspace:FindFirstChild(Workspace:GetAttribute("MapName"))
local _result = GameMap
if _result ~= nil then
	_result = _result:FindFirstChild("Waypoints")
end
local Waypoints = _result
local CurrentEUID = -1
local DebugHitbox = function(targetCFrame)
	local Hitbox = Instance.new("Part")
	Hitbox.Anchored = true
	Hitbox.CanCollide = false
	Hitbox.CanQuery = false
	Hitbox.Color = Color3.fromHex("#FF0000")
	Hitbox.Transparency = 0.5
	Hitbox.Size = Vector3.new(2.5, 2.5, 2.5)
	Hitbox:PivotTo(targetCFrame)
	local Camera = Workspace:FindFirstChild("Camera")
	if not Camera:FindFirstChild("Hitboxes") then
		local Folder = Instance.new("Folder")
		Folder.Parent = Camera
		Folder.Name = "Hitboxes"
	end
	Hitbox.Parent = Camera:FindFirstChild("Hitboxes")
	return Hitbox
end
local Enemy
do
	Enemy = setmetatable({}, {
		__tostring = function()
			return "Enemy"
		end,
	})
	Enemy.__index = Enemy
	function Enemy.new(...)
		local self = setmetatable({}, Enemy)
		return self:constructor(...) or self
	end
	function Enemy:constructor(Props)
		self.TargetWaypoint = 1
		self.DistanceTravelled = 0
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
		CurrentEUID += 1
		self.ModelName = Props.ModelName
		self.Id = `{Props.ModelName}_{tostring(CurrentEUID)}`
		self.MaxHealth, self.Health = Props.Health, Props.Health
		self.IsAir = Props.IsAir
		self.Speed = EnemyBaseSpeed * Props.Speed
		self.Type = Props.EnemyType
		local TargetWaypoint = Waypoints:FindFirstChild(`Waypoint{self.TargetWaypoint}`)
		self.CFrame = CFrame.lookAt(Props.SpawnCFrame.Position, TargetWaypoint:GetPivot().Position)
		self.Hitbox = DebugHitbox(self.CFrame)
		self.DistanceTravelled = 0
	end
	function Enemy:Move(TargetCFrame)
		if self.Hitbox then
			self.Hitbox:PivotTo(TargetCFrame)
		end
		self.CFrame = TargetCFrame
	end
	function Enemy:Remove()
		if self.Hitbox then
			self.Hitbox:Destroy()
		end
		setmetatable(self, nil)
		table.clear(self)
		table.freeze(self)
	end
end
return Enemy
