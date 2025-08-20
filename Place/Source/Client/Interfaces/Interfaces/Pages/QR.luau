local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)
local SignalTypes = require(ReplicatedStorage.Shared.Types.Signal)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)
local State = require(ReplicatedFirst.Client.Interfaces.State)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local Header = require(ReplicatedFirst.Client.Interfaces.Components.Header)
local Border = require(ReplicatedFirst.Client.Interfaces.Components.Border)
local ImageLabel = require(ReplicatedFirst.Client.Interfaces.Components.ImageLabel)
local TextLabel = require(ReplicatedFirst.Client.Interfaces.Components.TextLabel)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIPadding = require(ReplicatedFirst.Client.Interfaces.Components.UIPadding)
local UIAspectRatioConstraint = require(ReplicatedFirst.Client.Interfaces.Components.UIAspectRatioConstraint)

return function(scope: FusionTypes.Scope, props: {
	overrideSizeConstraints: UDim2?
}): ScreenGui
	return Frame(scope, {
		BackgroundTransparency = 1,

		[Fusion.Children] = {
			Frame(scope, {
				Size = UDim2.fromScale(0.8, 0.3),
				Position = UDim2.fromScale(0.5, 0.2),
				BackgroundTransparency = 1,

				Rotation = scope:Computed(function(use)
					local mobileRotation = use(State.MobileRotation)

					return mobileRotation
				end),

				[Fusion.Children] = {
					Frame(scope, {
						Size = UDim2.fromScale(0.3, 0.3),
						Position = UDim2.fromScale(0.15, 0.2),
						BackgroundColor3 = Theme.DarkColor,

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
							UICorner(scope, {}),

							ImageLabel(scope, {
								Image = Theme.SpinIcon,
								ImageColor3 = Theme.LightColor,
								Size = UDim2.fromScale(0.7, 0.7)
							})
						}
					}),

					ImageLabel(scope, {
						Position = UDim2.fromScale(0.325, 0.2),

						Image = Theme.ArrowIcon,
						ImageColor3 = Theme.DarkColor,
						Size = UDim2.fromScale(0.15, 0.15),

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
						}
					}),

					Frame(scope, {
						Size = UDim2.fromScale(0.3, 0.3),
						Position = UDim2.fromScale(0.5, 0.2),
						BackgroundColor3 = Theme.DarkColor,

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
							UICorner(scope, {}),

							ImageLabel(scope, {
								Image = Theme.ExpandIcon,
								ImageColor3 = Theme.LightColor,
								Size = UDim2.fromScale(0.7, 0.7)
							})
						}
					}),

					ImageLabel(scope, {
						Position = UDim2.fromScale(0.675, 0.2),

						Image = Theme.ArrowIcon,
						ImageColor3 = Theme.DarkColor,
						Size = UDim2.fromScale(0.15, 0.15),

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
						}
					}),

					Frame(scope, {
						Size = UDim2.fromScale(0.3, 0.3),
						Position = UDim2.fromScale(0.85, 0.2),
						BackgroundColor3 = Theme.DarkColor,

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
							UICorner(scope, {}),

							ImageLabel(scope, {
								Image = Theme.ThumbsUpIcon,
								ImageColor3 = Theme.LightColor,
								Size = UDim2.fromScale(0.7, 0.7)
							})
						}
					}),

					Frame(scope, {
						Size = UDim2.fromScale(0.8, 0.15),
						Position = UDim2.fromScale(0.5, 0.75),
						BackgroundColor3 = Theme.DarkColor,

						[Fusion.Children] = {
							UICorner(scope, {}),
							UIPadding(scope, {
								PaddingTop = UDim.new(0.15, 0),
								PaddingBottom = UDim.new(0.15, 0),
								PaddingLeft = UDim.new(0.025, 0),
								PaddingRight = UDim.new(0.025, 0),
							}),

							Frame(scope, {
								Size = scope:Computed(function(use)
									local value = use(State.QRCodeRefreshScale)

									return UDim2.fromScale(1 - value, 1)
								end),
								AnchorPoint = Vector2.zero,
								Position = UDim2.fromScale(0, 0),
								BackgroundColor3 = Theme.LightColor,

								[Fusion.Children] = {
									UICorner(scope, {})
								}
							})
						}
					})
				}
			}),

			Frame(scope, {
				Size = UDim2.fromScale(0.9, 0.9),
				Position = UDim2.fromScale(0.5, 0.71),

				BackgroundColor3 = Theme.White,

				[Fusion.Children] = {
					UIAspectRatioConstraint(scope, {}),
					UICorner(scope, {
						CornerRadius = UDim.new(0.05, 0)
					}),

					ImageLabel(scope, {
						Size = UDim2.fromScale(0.9, 0.9),
						Rotation = 180,

						ImageContent = scope:Computed(function(use)
							local content = use(State.QRCode)

							return content
						end),

						[Fusion.Children] = {
							UIAspectRatioConstraint(scope, {}),
							UICorner(scope, {
								CornerRadius = UDim.new(0.05, 0)
							}),
						}
					}),
				}
			})
		}
	})
end
