local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local FusionTypes = require(ReplicatedStorage.Shared.Types.Fusion)
local SignalTypes = require(ReplicatedStorage.Shared.Types.Signal)

local Theme = require(ReplicatedFirst.Client.Interfaces.Theme)
local State = require(ReplicatedFirst.Client.Interfaces.State)

local Frame = require(ReplicatedFirst.Client.Interfaces.Components.Frame)
local Header = require(ReplicatedFirst.Client.Interfaces.Components.Header)
local TextLabel = require(ReplicatedFirst.Client.Interfaces.Components.TextLabel)
local Border = require(ReplicatedFirst.Client.Interfaces.Components.Border)
local UICorner = require(ReplicatedFirst.Client.Interfaces.Components.UICorner)
local UIPadding = require(ReplicatedFirst.Client.Interfaces.Components.UIPadding)
local UIGridLayout = require(ReplicatedFirst.Client.Interfaces.Components.UIGridLayout)

local function pin(
	scope: FusionTypes.Scope,
	props: {
		name: string,
		value: string,
		color: Color3,
	}
)
	return Frame(scope, {
		BackgroundColor3 = Theme.LightColor,

		[Fusion.Children] = {
			UICorner(scope, {
				CornerRadius = UDim.new(0.1),
			}),

			TextLabel(scope, {
				FontFace = Theme.Font.Base,
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(1, 0.15),
				Text = props.name,
				TextColor3 = Theme.DarkColor,
				TextScaled = true,
			}),

			TextLabel(scope, {
				FontFace = Theme.Font.Title,
				Position = UDim2.fromScale(0.5, 0.35),
				Size = UDim2.fromScale(1, 0.4),
				Text = props.value,
				TextColor3 = props.color,
				TextScaled = true,
			}),
		},
	})
end

return function(scope: FusionTypes.Scope, props: {})
	return Frame(scope, {
		BackgroundColor3 = Theme.DarkColor,
		Size = UDim2.fromScale(1, 0.5),

		[Fusion.Children] = {
			UICorner(scope, {
				CornerRadius = UDim.new(0.04),
			}),

			UIPadding(scope, {
				PaddingTop = UDim.new(0.04, 0),
				PaddingBottom = UDim.new(0.04, 0),
				PaddingLeft = UDim.new(0, 0),
				PaddingLeft = UDim.new(0, 0),
			}),

			UIGridLayout(scope, {
				CellSize = UDim2.fromScale(0.45, 0.31),
				CellPadding = UDim2.fromScale(0.025, 0.03),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			pin(scope, {
				name = "Gym visits",
				color = Theme.Orange,
				value = scope:Computed(function(use)
					local result = use(State.GymVisits)

					return tostring(result)
				end),
			}),

			pin(scope, {
				name = "Workout time",
				color = Theme.Cyan,
				value = scope:Computed(function(use)
					local result = use(State.WorkoutTime) :: number

					local hours = math.floor(result / 60)
					local minutes = result % 60

					return string.format("%dh %dm", hours, minutes)
				end),
			}),

			pin(scope, {
				name = "Gym activities",
				color = Theme.Grey,
				value = scope:Computed(function(use)
					local result = use(State.GymActivities)

					return tostring(result)
				end),
			}),

			pin(scope, {
				name = "People In Gym",
				color = Theme.Pink,
				value = scope:Computed(function(use)
					local result = use(State.TotalPeopleInGym)

					return tostring(result)
				end),
			}),

			pin(scope, {
				name = "People In Classes",
				color = Theme.Lavender,
				value = scope:Computed(function(use)
					local result = use(State.TotalPeopleInClasses)

					return tostring(result)
				end),
			}),

			pin(scope, {
				name = "Max People",
				color = Theme.Green,
				value = scope:Computed(function(use)
					local result = use(State.MaximumCapacity)

					return tostring(result)
				end),
			}),
		},
	})
end
