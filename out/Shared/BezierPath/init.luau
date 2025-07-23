-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local BezierPath = TS.import(script, game:GetService("ReplicatedStorage"), "Modules", "BezierPath", "BezierPath")
local CurveSize = 2
while not (Workspace:GetAttribute("IsReady")) do
	task.wait(0.1)
end
local MapName = Workspace:GetAttribute("MapName")
local MapFolder = Workspace:WaitForChild(`{MapName}_Map`)
local Waypoints = MapFolder:WaitForChild("Waypoints")
local Positions = {}
while #Waypoints:GetChildren() ~= (MapFolder:GetAttribute("WaypointsNumber")) do
	task.wait()
end
for i = 0, #Waypoints:GetChildren() - 1 do
	Positions[i + 1] = if i == 0 then (Waypoints:FindFirstChild("Spawn")):GetPivot().Position else (Waypoints:FindFirstChild(`Waypoint{i}`)):GetPivot().Position
end
local MapPath = BezierPath.new(Positions, CurveSize)
-- if (RunService.IsStudio()) MapPath.VisualizePath();
print("Created Bezier Path!")
return MapPath
