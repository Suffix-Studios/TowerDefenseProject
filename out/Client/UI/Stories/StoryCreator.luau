-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Charm = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "Charm")
local _ui_labs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "ui-labs", "src")
local CreateControlStates = _ui_labs.CreateControlStates
local UpdateControlStates = _ui_labs.UpdateControlStates
local Vide = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "vide", "src")
local function CreateVideWithAtomsStory(controls, story)
	return {
		controls = controls,
		render = function(props)
			local atoms = CreateControlStates(props.converted, props.controls, function(val)
				return Charm.atom(val)
			end)
			local unmount = Vide.mount(function()
				story(atoms, props.target)
			end)
			props.subscribe(function(values)
				UpdateControlStates(atoms, props.converted, values, function(atom, val)
					atom(val)
				end)
			end)
			return unmount
		end,
	}
end
return {
	CreateVideWithAtomsStory = CreateVideWithAtomsStory,
}
