-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService = _services.GuiService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local PlacedTowersFolder = Workspace:WaitForChild("PlacedTowers")
local Camera = Workspace.CurrentCamera
local RaycastFromMouse = function(Params)
	local MouseScreenPosition = UserInputService:GetMouseLocation()
	local _result = Camera
	if _result ~= nil then
		_result = _result:ScreenPointToRay(MouseScreenPosition.X, MouseScreenPosition.Y - (GuiService:GetGuiInset()).Y)
	end
	local Ray = _result
	local _result_1 = Ray
	if _result_1 ~= nil then
		_result_1 = _result_1.Origin
	end
	local Raycast = Workspace:Raycast(_result_1, Ray.Direction * 100, Params)
	if Raycast and Raycast.Instance then
		return Raycast
	else
		return nil
	end
end
local TogglePlacedTowersHitbox = function(Toggle)
	for _, TowerModel in pairs(PlacedTowersFolder:GetChildren()) do
		local Hitbox = TowerModel:FindFirstChild("RedArea")
		if Hitbox ~= nil then
			Hitbox.Transparency = if Toggle then 0.5 else 1
		end
	end
end
return {
	RaycastFromMouse = RaycastFromMouse,
	TogglePlacedTowersHitbox = TogglePlacedTowersHitbox,
}
