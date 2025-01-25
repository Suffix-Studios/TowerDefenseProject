-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local RangeCircleImageId = "rbxassetid://127392364653406"
local TowerRangeUI = function(Props)
	local Color = useAtom(Props.Color)
	return Vide.jsx("frame", {
		Name = "Container",
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = function()
			if Props.Parent then
				return Props.Parent
			else
				return nil
			end
		end,
		BackgroundTransparency = 1,
	}, Vide.jsx("uiaspectratioconstraint"), Vide.jsx("imagelabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = RangeCircleImageId,
		ImageColor3 = Color,
	}))
end
return {
	TowerRangeUI = TowerRangeUI,
}
