local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

local ImageLabel = require(ReplicatedFirst.Client.Interfaces.Components.ImageLabel)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIAspectRatioConstraint = require(ReplicatedFirst.Client.Interfaces.Components.UIAspectRatioConstraint)

return function(scope: FusionTypes.Scope, props: {
	Icon: string?,
	InvertedColors: boolean?,

	OnActivated: (() -> ())?,

	[any]: any
})
	local updatedProps = Sift.Dictionary.copy(props)

	updatedProps.Icon = nil
	updatedProps.InvertedColors = nil
	updatedProps.OnActivated = nil
	updatedProps[Fusion.Children] = nil

	return scope:New("TextButton")(Sift.Dictionary.merge({
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = props.InvertedColors and Theme.DarkColor or Theme.LightColor,

		[Fusion.OnEvent("Activated")] = function()
			if props.OnActivated then
				props.OnActivated()
			end
		end :: any,

		[Fusion.Children] = {
			UIAspectRatioConstraint(scope, {}),
			UICorner(scope, {
				CornerRadius = UDim.new(1)
			}),

			scope:New("Frame")({
				Size = UDim2.fromScale(0.8, 0.8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = props.InvertedColors and Theme.LightColor or Theme.DarkColor,

				[Fusion.Children] = {
					UIAspectRatioConstraint(scope, {}),
					UICorner(scope, {
						CornerRadius = UDim.new(1)
					}),

					ImageLabel(scope, {
						Image = props.Icon or Theme.DumbellIcon,
						ImageColor3 = props.InvertedColors and Theme.DarkColor or Theme.LightColor,
						Size = UDim2.fromScale(0.7, 0.7),

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
							UICorner(scope, {
								CornerRadius = UDim.new(1)
							}),
						}
					}),
				}
			})
		}
	}, updatedProps))
end
