local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)
local SignalTypes = require(ReplicatedStorage.Shared.Types.Signal)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)
local State = require(ReplicatedFirst.Client.Interfaces.State)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local ImageLabel = require(ReplicatedFirst.Client.Interfaces.Components.ImageLabel)
local TextLabel = require(ReplicatedFirst.Client.Interfaces.Components.TextLabel)

return function(scope: FusionTypes.Scope, props: {}): ScreenGui
	return Frame(scope, {
		BackgroundTransparency = 1,

		[Fusion.Children] = {
			TextLabel(scope, {
				Position = UDim2.fromScale(0.5, 0.25),
				Size = UDim2.fromScale(1, 0.05),
				FontFace = Theme.Font.Bold,
				Text = `404`,
			}),

			TextLabel(scope, {
				Position = UDim2.fromScale(0.5, 0.3),
				Size = UDim2.fromScale(1, 0.03),
				Text = `You're not supposed\nto be here!`,
			}),
		},
	})
end
