-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(character)
		local _exp = character:GetDescendants()
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(Descendant)
			if Descendant:IsA("BasePart") then
				Descendant.CollisionGroup = "Players"
			end
		end
		for _k, _v in _exp do
			_callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
	end)
end)
local _result = script.Parent
if _result ~= nil then
	_result = _result:FindFirstChild("Modules")
end
local s, e = pcall(require, _result:FindFirstChild("PlayerDataService"))
if not s then
	error(`Failed to load PlayerDataService: {e}`)
end
