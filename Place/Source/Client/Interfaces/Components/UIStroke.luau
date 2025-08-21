local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

return function(
	scope: FusionTypes.Scope,
	props: {
		[any]: any,
	}
)
	return scope:New("UIStroke")(Sift.Dictionary.merge({
		Thickness = 4,
		Color = Theme.DarkColor,
	}, props))
end
