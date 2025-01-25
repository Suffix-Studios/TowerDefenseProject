-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local useAtom = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "VideCharm").useAtom
local EnemyHealthUI = function(Props)
	local MaxHealth = Props.Health()
	local Health = useAtom(Props.Health)
	local _textType = Props.TextType
	local TextType = if type(_textType) == "string" then function()
		return Props.TextType
	end else useAtom(Props.TextType)
	return Vide.jsx("frame", {
		Name = "BarBackground",
		Parent = function()
			if Props.Parent then
				return Props.Parent
			else
				return nil
			end
		end,
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
			return UDim2.fromScale(Health() / MaxHealth, 1)
		end,
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
	}, Vide.jsx("uicorner", {
		CornerRadius = UDim.new(0.15, 0),
	})), Vide.jsx("textlabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BackgroundTransparency = 1,
		Font = Enum.Font.FredokaOne,
		Text = function()
			local _exp = TextType()
			repeat
				if _exp == "Number Only" then
					return `{math.floor(Health())}`
				end
				if _exp == "Number Over Max" then
					return `{math.floor(Health())}/{MaxHealth}`
				end
				if _exp == "Percentage" then
					return `%{math.floor((Health() / MaxHealth) * 100)}`
				end
				return ""
			until true
		end,
	}))
end
return {
	EnemyHealthUI = EnemyHealthUI,
}
