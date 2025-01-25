-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local LoadoutUI = function(Props)
	return Vide.jsx("frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.8),
		BackgroundColor3 = Color3.fromHex("#000000"),
	}, Vide.jsx("uicorner", {
		CornerRadius = UDim.new(0.2, 0),
	}))
end
return nil
