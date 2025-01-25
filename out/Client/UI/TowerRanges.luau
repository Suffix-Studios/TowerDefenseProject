-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm").atom
local Remap = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remap", "src")
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local TweenService = _services.TweenService
local _vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local Vide = _vide
local cleanup = _vide.cleanup
local Index = _vide.Index
local root = _vide.root
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local TowerRangeUI = TS.import(script, game:GetService("ReplicatedStorage"), "Client", "UI", "Components", "TowerRange").TowerRangeUI
local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")
local Towers = atom({})
local CreateRangePart = function(Parent)
	local RangePart = Instance.new("Part")
	RangePart.Anchored = true
	RangePart.CanCollide = false
	RangePart.CanQuery = false
	RangePart.CanTouch = false
	RangePart.Transparency = 1
	RangePart.Size = Vector3.new(0, 0.3, 0)
	RangePart:PivotTo(Parent:GetPivot())
	RangePart.Parent = Parent
	return RangePart
end
local TowerRange
do
	TowerRange = setmetatable({}, {
		__tostring = function()
			return "TowerRange"
		end,
	})
	TowerRange.__index = TowerRange
	function TowerRange.new(...)
		local self = setmetatable({}, TowerRange)
		return self:constructor(...) or self
	end
	function TowerRange:constructor(RangeProps)
		local newPart = CreateRangePart(RangeProps.Parent)
		task.spawn(function()
			task.wait(0.1)
			local Tween = TweenService:Create(newPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
				Size = Vector3.new(RangeProps.RangeSize * 2, 0.3, RangeProps.RangeSize * 2),
			})
			Tween:Play()
			Tween.Completed:Wait()
			Tween:Destroy()
		end)
		self.TowerId = RangeProps.TowerId
		self.Color = atom(RangeProps.RangeColor)
		local newTowers = Remap.set(Towers(), RangeProps.TowerId, {
			Part = newPart,
			RangeColor = self.Color,
		})
		Towers(newTowers)
	end
	function TowerRange:Destroy()
		local _exp = Towers()
		local _towerId = self.TowerId
		if _exp[_towerId] ~= nil then
			local _exp_1 = Towers()
			local _towerId_1 = self.TowerId
			local _result = _exp_1[_towerId_1]
			if _result ~= nil then
				_result = _result.Part:Destroy()
			end
			local newEnemies = Remap.delete(Towers(), self.TowerId)
			Towers(newEnemies)
		end
		setmetatable(self, nil)
		table.clear(self)
		table.freeze(self)
	end
end
root(function()
	local TowersMap = useAtom(Towers)
	Vide.jsx(Index, {
		each = TowersMap,
	}, function(RangeProps)
		return Vide.jsx("surfacegui", {
			action = cleanup,
			Parent = PlayerGui:FindFirstChild("TowersRanges"),
			Adornee = RangeProps().Part,
			Face = Enum.NormalId.Top,
		}, Vide.jsx(TowerRangeUI, {
			Color = RangeProps().RangeColor,
		}))
	end)
end)
return TowerRange
