-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local placedTowersFolder = Workspace:WaitForChild("PlacedTowers")
local camera = Workspace.CurrentCamera
local GetScreenPointRay = function()
	local mouseScreenPosition = UserInputService:GetMouseLocation()
	local _result = camera
	if _result ~= nil then
		_result = _result:ViewportPointToRay(mouseScreenPosition.X, mouseScreenPosition.Y)
	end
	local ray = _result
	return ray
end
local raycastFromMouse = function(params)
	local ray = GetScreenPointRay()
	local _result = ray
	if _result ~= nil then
		_result = _result.Origin
	end
	local raycast = Workspace:Raycast(_result, ray.Direction * 100, params)
	if raycast and raycast.Instance then
		return raycast
	else
		return nil
	end
end
local togglePlacedTowersHitbox = function(Toggle)
	local _exp = placedTowersFolder:GetChildren()
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
	raycastFromMouse = raycastFromMouse,
	togglePlacedTowersHitbox = togglePlacedTowersHitbox,
}
