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
local PinButton = require(ReplicatedFirst.Client.Interfaces.Components.PinButton)

local STATE_PAGE_DICT = table.freeze({
	Login = require(script.Parent.Pages.Login),
	Home = require(script.Parent.Pages.Home),
	Error = require(script.Parent.Pages.Error),
	QR = require(script.Parent.Pages.QR),
})

local ICON_PAGE_DICT = table.freeze({
	Login = Theme.PersonIcon,
	Home = Theme.DumbellIcon,
	Error = Theme.ErrorIcon,
	QR = Theme.QRIcon,
})

return function(
	scope: FusionTypes.Scope,
	props: {
		overrideSizeConstraints: UDim2?,
	}
): ScreenGui
	return scope:New("CanvasGroup")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Theme.LightColor,

		Size = props.overrideSizeConstraints and props.overrideSizeConstraints or UDim2.fromScale(1, 1),

		[Fusion.Children] = {
			Header(scope, {
				ImageId = scope:Computed(function(use)
					local targetPage = use(State.Page)
					local imageId = ICON_PAGE_DICT[targetPage]

					if not imageId then
						imageId = ICON_PAGE_DICT.Error
					end

					return imageId
				end),
			}),

			Border(scope, {}),

			PinButton(scope, {
				Size = UDim2.fromScale(0.125, 0.125),
				Position = UDim2.fromScale(0.15, 0.225),
				InvertedColors = true,
				Icon = Theme.ArrowIcon,
				Rotation = 180,
				Visible = scope:Computed(function(use)
					return use(State.ExitButtonVisible)
				end),

				OnActivated = function()
					State.Callbacks.ExitButtonActivated()
				end,
			}),

			Frame(scope, {
				Size = UDim2.fromScale(0.9, 0.7),
				Position = UDim2.fromScale(0.5, 0.627),

				BackgroundTransparency = 1,

				Canvas = true,

				[Fusion.Children] = scope:Computed(function(use)
					local targetPage = use(State.Page)
					local pageToRender = STATE_PAGE_DICT[targetPage]

					if not pageToRender then
						pageToRender = STATE_PAGE_DICT.Error
					end

					return {
						pageToRender(scope, {}),

						UICorner(scope, {
							CornerRadius = UDim.new(0.1, 0),
						}),
					}
				end),
			}),
		},
	})
end
