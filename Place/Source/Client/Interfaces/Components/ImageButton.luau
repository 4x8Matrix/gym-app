local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

return function(scope: FusionTypes.Scope, props: {
	[any]: any
})
	return scope:New("ImageButton")(Sift.Dictionary.merge({
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		ScaleType = Enum.ScaleType.Fit,
	}, props))
end
