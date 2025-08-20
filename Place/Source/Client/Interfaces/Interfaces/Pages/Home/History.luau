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
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)

return function(scope: FusionTypes.Scope, props: { })
	return Frame(scope, {
		BackgroundColor3 = Theme.LightColor,
		Size = UDim2.fromScale(1, 1),

		[Fusion.Children] = {
			UICorner(scope, {
				CornerRadius = UDim.new(0.1)
			})
		}
	})
end
