local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local Base = require(ReplicatedFirst.Client.Interfaces.Interfaces.Base)

return function(parent)
	local windowObject = Base(State.Scope, {
		overrideSizeConstraints = UDim2.fromOffset(432, 969.6),
	})

	windowObject.Parent = parent

	return function()
		windowObject:Destroy()

		Fusion.doCleanup(State.Scope)
	end
end
