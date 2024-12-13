-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local EnemyHealthUI = function(Props)
	local Health = function()
		return useAtom(Props.Health)()
	end
	return Vide.jsx("billboardgui", {
		Adornee = Props.Adornee,
		Size = UDim2.fromScale(4, 0.7),
		MaxDistance = 100,
		StudsOffset = Vector3.new(0, 3, 0),
		Enabled = true,
	}, Vide.jsx("frame", {
		Name = "BarBackground",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(75, 75, 75),
	}, Vide.jsx("uicorner", {
		CornerRadius = UDim.new(0.15),
	}), Vide.jsx("frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = function()
			return UDim2.fromScale(Health() / Props.MaxHealth, 1)
		end,
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
	}, Vide.jsx("uicorner", {
		CornerRadius = UDim.new(.15, 0),
	})), Vide.jsx("textlabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BackgroundTransparency = 1,
		Font = Enum.Font.FredokaOne,
		Text = function()
			local _exp = Props.TextType
			repeat
				if _exp == "Number Only" then
					return `{Health()}`
				end
				if _exp == "Number Over Max" then
					return `{Health()}/{Props.MaxHealth}`
				end
				if _exp == "Percentage" then
					return `%{math.floor((Health() / Props.MaxHealth) * 100)}`
				end
				return ""
			until true
		end,
	})))
end
return {
	EnemyHealthUI = EnemyHealthUI,
}
