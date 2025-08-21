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
local UIPadding = require(ReplicatedFirst.Client.Interfaces.Components.UIPadding)
local UIListLayout = require(ReplicatedFirst.Client.Interfaces.Components.UIListLayout)
local PinButton = require(ReplicatedFirst.Client.Interfaces.Components.PinButton)

return function(scope: FusionTypes.Scope, props: {})
	return Frame(scope, {
		BackgroundColor3 = Theme.DarkColor,
		Size = UDim2.fromScale(1, 0.15),

		[Fusion.Children] = {
			UICorner(scope, {
				CornerRadius = UDim.new(0.1),
			}),
			UIListLayout(scope, {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.05),
			}),

			UIPadding(scope, { Padding = UDim.new(0.2) }),

			PinButton(scope, {
				Icon = Theme.QRIcon,

				OnActivated = function()
					State.Callbacks.SetActivePage("QR")
				end,
			}),
		},
	})
end
