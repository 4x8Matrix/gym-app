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

local History = require(ReplicatedFirst.Client.Interfaces.Interfaces.Pages.Home.History)
local Navigation = require(ReplicatedFirst.Client.Interfaces.Interfaces.Pages.Home.Navigation)
local Activity = require(ReplicatedFirst.Client.Interfaces.Interfaces.Pages.Home.Activity)

return function(
	scope: FusionTypes.Scope,
	props: {
		overrideSizeConstraints: UDim2?,
	}
): ScreenGui
	return Frame(scope, {
		BackgroundTransparency = 1,

		Scrolling = true,

		[Fusion.Children] = {
			UIListLayout(scope, {
				Padding = UDim.new(0.02),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			UIPadding(scope, {
				Padding = UDim.new(0.02),
			}),

			Navigation(scope, {}),
			Activity(scope, {}),
			History(scope, {}),
		},
	})
end
