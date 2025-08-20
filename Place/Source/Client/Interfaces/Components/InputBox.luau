local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local TextBox = require(ReplicatedFirst.Client.Interfaces.Components.TextBox)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIStroke = require(ReplicatedFirst.Client.Interfaces.Components.UIStroke)
local UIPadding = require(ReplicatedFirst.Client.Interfaces.Components.UIPadding)

return function(scope: FusionTypes.Scope, props: {
	Text: string?,
	Size: UDim2,
	Position: UDim2,

	OnTextUpdated: ((content: string) -> ())?,
	OnFocusLost: (() -> ())?,

	[any]: any
})
	-- 0: not selected, 1: selected
	local inputState = scope:Value(0)
	local animated = scope:Tween(inputState, TweenInfo.new(0.1))

	return Frame(scope, {
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position,
		BackgroundTransparency = 1,

		[Fusion.Children] = {
			UIStroke(scope, {
				Thickness = 2,
				Color = scope:Computed(function(use)
					local state = use(animated)

					return Theme.DarkColor:Lerp(Theme.ActiveColor, state)
				end),
			}),

			UICorner(scope, {
				CornerRadius = UDim.new(0.2, 0)
			}),

			TextBox(scope, {
				Text = props.Text,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.LightColor,
				TextColor3 = Theme.DarkColor,
				FontFace = Theme.Font.Bold,

				[Fusion.OnEvent("Focused")] = function()
					inputState:set(1)
				end,

				[Fusion.OnEvent("FocusLost")] = function()
					inputState:set(0)

					if props.OnFocusLost then
						props.OnFocusLost()
					end
				end,

				[Fusion.OnChange("Text")] = function(text)
					if props.OnTextUpdated then
						props.OnTextUpdated(text)
					end
				end,

				[Fusion.Children] = {
					UICorner(scope, {
						CornerRadius = UDim.new(0.225, 0)
					}),

					UIPadding(scope, {
						PaddingTop = UDim.new(0.275, 0),
						PaddingBottom = UDim.new(0.275, 0),
						PaddingLeft = UDim.new(0.05, 0),
						PaddingRight = UDim.new(0.05, 0),
					})
				}
			})
		}
	})
end
