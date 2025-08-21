local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

return function(
	scope: FusionTypes.Scope,
	props: {
		Canvas: boolean?,
		Scrolling: boolean?,

		[any]: any,
	}
)
	local updatedProps = Sift.Dictionary.copy(props)
	local useCanvas = props.Canvas
	local useScrolling = props.Scrolling

	updatedProps.Scrolling = nil
	updatedProps.Canvas = nil

	if useScrolling then
		if not updatedProps.ScrollBarThickness then
			updatedProps.ScrollBarThickness = 0
		end

		if not updatedProps.CanvasSize then
			updatedProps.CanvasSize = UDim2.fromScale(0, 0)
		end

		if not updatedProps.AutomaticCanvasSize then
			updatedProps.AutomaticCanvasSize = Enum.AutomaticSize.Y
		end
	end

	return scope:New((useCanvas and "CanvasGroup") or (useScrolling and "ScrollingFrame") or "Frame")(
		Sift.Dictionary.mergeDeep({
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
		}, updatedProps)
	)
end
