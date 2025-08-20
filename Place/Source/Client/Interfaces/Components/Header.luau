local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local ImageLabel = require(ReplicatedFirst.Client.Interfaces.Components.ImageLabel)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIAspectRatioConstraint = require(ReplicatedFirst.Client.Interfaces.Components.UIAspectRatioConstraint)

return function(scope: FusionTypes.Scope, props: {
	ImageId: string?,

	[any]: any
})
	return {
		Frame(scope, {
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(0.5, -0.25),

			BackgroundColor3 = Theme.DarkColor,

			[Fusion.Children] = {
				UICorner(scope, { }),
				UIAspectRatioConstraint(scope, { }),
			}
		}),

		Frame(scope, {
			Size = UDim2.fromScale(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.15),

			BackgroundColor3 = Theme.DarkColor,

			[Fusion.Children] = {
				UICorner(scope, { }),
				UIAspectRatioConstraint(scope, { }),

				Frame(scope, {
					Size = UDim2.fromScale(0.8, 0.8),
					Position = UDim2.fromScale(0.5, 0.5),

					BackgroundColor3 = Theme.LightColor,

					[Fusion.Children] = {
						UICorner(scope, { }),
						UIAspectRatioConstraint(scope, { }),

						ImageLabel(scope, {
							Image = props.ImageId,
							ImageColor3 = Theme.DarkColor,
							Size = UDim2.fromScale(0.7, 0.7),

							[Fusion.Children] = {
								UICorner(scope, { }),
							}
						})
					}
				})
			}
		})
	}
end
