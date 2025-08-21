local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

return function(
	scope: FusionTypes.Scope,
	props: {
		Padding: UDim?,

		[any]: any,
	}
)
	local updatedProps = Sift.Dictionary.copy(props)
	local useCanvas = props.Canvas

	updatedProps.Padding = nil

	return scope:New("UIPadding")(Sift.Dictionary.merge({
		PaddingBottom = props.Padding or UDim.new(),
		PaddingTop = props.Padding or UDim.new(),
		PaddingRight = props.Padding or UDim.new(),
		PaddingLeft = props.Padding or UDim.new(),
	}, updatedProps))
end
