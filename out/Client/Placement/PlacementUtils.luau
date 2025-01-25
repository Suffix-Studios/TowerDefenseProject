-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService = _services.GuiService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local PlacedTowersFolder = Workspace:WaitForChild("PlacedTowers")
local Camera = Workspace.CurrentCamera
local GetScreenPointRay = function()
	local MouseScreenPosition = UserInputService:GetMouseLocation()
	local _result = Camera
	if _result ~= nil then
		_result = _result:ScreenPointToRay(MouseScreenPosition.X, MouseScreenPosition.Y - (GuiService:GetGuiInset()).Y)
	end
	local Ray = _result
	return Ray
end
local RaycastFromMouse = function(Params)
	local Ray = GetScreenPointRay()
	local _result = Ray
	if _result ~= nil then
		_result = _result.Origin
	end
	local Raycast = Workspace:Raycast(_result, Ray.Direction * 100, Params)
	if Raycast and Raycast.Instance then
		return Raycast
	else
		return nil
	end
end
local TogglePlacedTowersHitbox = function(Toggle)
	local _exp = PlacedTowersFolder:GetChildren()
	-- ▼ ReadonlyArray.forEach ▼
	local _callback = function(TowerModel)
		local Hitbox = TowerModel:FindFirstChild("RedArea")
		if Hitbox ~= nil then
			Hitbox.Transparency = if Toggle then 0.5 else 1
		end
	end
	for _k, _v in _exp do
		_callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
end
return {
	GetScreenPointRay = GetScreenPointRay,
	RaycastFromMouse = RaycastFromMouse,
	TogglePlacedTowersHitbox = TogglePlacedTowersHitbox,
}
