local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)
local SignalTypes = require(ReplicatedStorage.Shared.Types.Signal)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)
local State = require(ReplicatedFirst.Client.Interfaces.State)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local InputBox = require(ReplicatedFirst.Client.Interfaces.Components.InputBox)
local TextButton = require(ReplicatedFirst.Client.Interfaces.Components.TextButton)
local TextLabel = require(ReplicatedFirst.Client.Interfaces.Components.TextLabel)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIPadding = require(ReplicatedFirst.Client.Interfaces.Components.UIPadding)

return function(
	scope: FusionTypes.Scope,
	props: {
		overrideSizeConstraints: UDim2?,
	}
): ScreenGui
	local inputBox0 = InputBox(scope, {
		Size = UDim2.fromScale(0.8, 0.05),
		Position = UDim2.fromScale(0.5, 0.3),
		Text = "Someone@gmail.com",
	})

	local inputBox1 = InputBox(scope, {
		Size = UDim2.fromScale(0.8, 0.05),
		Position = UDim2.fromScale(0.5, 0.45),
		Text = "00000000",
	})

	return Frame(scope, {
		BackgroundTransparency = 1,

		[Fusion.Children] = {
			TextLabel(scope, {
				Size = UDim2.fromScale(0.7, 0.03),
				Position = UDim2.fromScale(0.5, 0.25),
				Text = "EMAIL",
				FontFace = Theme.Font.Title,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			inputBox0,

			TextLabel(scope, {
				Size = UDim2.fromScale(0.7, 0.03),
				Position = UDim2.fromScale(0.5, 0.4),
				Text = "PIN",
				FontFace = Theme.Font.Title,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			inputBox1,

			TextButton(scope, {
				Size = UDim2.fromScale(0.6, 0.075),
				Position = UDim2.fromScale(0.5, 0.65),
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.DarkColor,

				Text = "SIGN IN",
				TextColor3 = Theme.LightColor,

				FontFace = Theme.Font.Bold,

				[Fusion.OnEvent("Activated")] = function()
					State.Callbacks.LoginRequest(inputBox0.TextBox.Text, inputBox1.TextBox.Text)
				end :: any,

				[Fusion.Children] = {
					UICorner(scope, {}),
					UIPadding(scope, {
						Padding = UDim.new(0.2, 0),
					}),
				},
			}),

			TextLabel(scope, {
				Size = UDim2.fromScale(0.7, 0.078),
				Position = UDim2.fromScale(0.5, 0.9),
				Text = "We respect your privacy. We do not collect, store, or use your personal data without your consent. Any information shared during this Roblox experience is used solely for gameplay functionality and will be deleted once you leave the experience. No data will be retained, saved, or used beyond your active session.",
				FontFace = Theme.Font.Title,
			}),
		},
	})
end
