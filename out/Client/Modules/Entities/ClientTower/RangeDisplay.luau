-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
local Remap = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remap", "src")
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local TweenService = _services.TweenService
local Workspace = _services.Workspace
local _vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local Vide = _vide
local For = _vide.For
local root = _vide.root
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local TowerRangeUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "TowerRange").TowerRangeUI
local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")
local TowerRangesContainer = atom({})
local TowerRangeDisplay
do
	TowerRangeDisplay = setmetatable({}, {
		__tostring = function()
			return "TowerRangeDisplay"
		end,
	})
	TowerRangeDisplay.__index = TowerRangeDisplay
	function TowerRangeDisplay.new(...)
		local self = setmetatable({}, TowerRangeDisplay)
		return self:constructor(...) or self
	end
	function TowerRangeDisplay:constructor(Position, Color, Size)
		self.Part = self:CreateRangePart()
		self.Part:PivotTo(CFrame.new(Position))
		self.Color = atom(Color)
		local newContainer = Remap.set(TowerRangesContainer(), self.Part, self)
		TowerRangesContainer(newContainer)
		task.spawn(function()
			local Tween = TweenService:Create(self.Part, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				Size = Vector3.new(Size * 2, 0.3, Size * 2),
			})
			Tween:Play()
			Tween.Completed:Wait()
			Tween:Destroy()
		end)
	end
	function TowerRangeDisplay:CreateRangePart()
		local Part = Instance.new("Part")
		Part.Anchored = true
		Part.Transparency = 1
		Part.Size = Vector3.new(0, 0.3, 0)
		Part.Parent = Workspace
		Part.CanCollide, Part.CanTouch, Part.CanQuery = false, false, false
		return Part
	end
	function TowerRangeDisplay:SetPosition(newPosition)
		self.Part:PivotTo(CFrame.new(newPosition))
	end
	function TowerRangeDisplay:Destroy()
		local Part = self.Part
		setmetatable(self, nil)
		table.clear(self)
		table.freeze(self)
		task.spawn(function()
			local Tween = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				Size = Vector3.new(0, 0.3, 0),
			})
			Tween:Play()
			Tween.Completed:Wait()
			Tween:Destroy()
			Part:Destroy()
		end)
	end
end
root(function()
	local Container = function()
		return useAtom(TowerRangesContainer)()
	end
	Vide.jsx("folder", {
		Parent = PlayerGui,
		Name = "Range Display",
	}, Vide.jsx(For, {
		each = Container,
	}, function(TowerRange, Part)
		return Vide.jsx("surfacegui", {
			Face = Enum.NormalId.Top,
			Adornee = Part(),
			AlwaysOnTop = true,
		}, Vide.jsx(TowerRangeUI, {
			Color = TowerRange.Color,
		}))
	end))
end)
return TowerRangeDisplay
