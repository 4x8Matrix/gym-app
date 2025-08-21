local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIStroke = require(ReplicatedFirst.Client.Interfaces.Components.UIStroke)

return function(
	scope: FusionTypes.Scope,
	props: {
		[any]: any,
	}
)
	return Frame(scope, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -30, 1, -30),

		[Fusion.Children] = {
			UICorner(scope, {
				CornerRadius = UDim.new(0.1, 0),
			}),

			UIStroke(scope, {
				Color = Theme.DarkColor,
				Thickness = 100,
			}),
		},
	})
end
