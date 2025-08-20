local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

return function(scope: FusionTypes.Scope, props: {
	[any]: any
})
	return scope:New("ImageLabel")(Sift.Dictionary.merge({
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		ScaleType = Enum.ScaleType.Fit,
	}, props))
end
