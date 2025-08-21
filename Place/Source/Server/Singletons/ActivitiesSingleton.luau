local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Console = require(ReplicatedStorage.Packages.Console)

local LoginSingleton = require(ServerScriptService.Server.Singletons.LoginSingleton)

local activitiesNamespace = ReplicatedStorage.Network.Activities

local ActivitiesSingleton = {}

local reporter = Console.new(script.Name)

function ActivitiesSingleton.GenerateStartOfWeekISO(self: ActivitiesSingleton)
	local now = DateTime.now()
	local date = os.date("!*t", now.UnixTimestamp)

	local weekday = (date.wday + 5) % 7

	date.hour = 0
	date.min = 0
	date.sec = 0

	local secondsToSubtract = weekday * 24 * 60 * 60
	local weekStartUnix = os.time(date) - secondsToSubtract - 50 * 24 * 60 * 60

	local weekStart = DateTime.fromUnixTimestamp(weekStartUnix)
	local isoWeekStart = weekStart:ToIsoDate()

	return isoWeekStart
end

function ActivitiesSingleton.GenerateCurrentDayISO(self: ActivitiesSingleton)
	local now = DateTime.now()
	local date = os.date("!*t", now.UnixTimestamp)

	local weekday = (date.wday + 5) % 7

	date.hour = 24
	date.min = 0
	date.sec = 0

	local weekStartUnix = os.time(date)

	local weekStart = DateTime.fromUnixTimestamp(weekStartUnix)
	local isoWeekCurrent = weekStart:ToIsoDate()

	return isoWeekCurrent
end

function ActivitiesSingleton.GenerateActivities(self: ActivitiesSingleton, player: Player): { [any]: any }?
	local startOfWeekISO = self:GenerateStartOfWeekISO()
	local currentTimeISO = self:GenerateCurrentDayISO()
	local accessToken = LoginSingleton:GetAccessToken(player)
	local response = HttpService:RequestAsync({
		Url = `https://capi.puregym.com/api/v2/gymSessions/member?fromDate={HttpService:UrlEncode(startOfWeekISO)}&toDate={HttpService:UrlEncode(
			currentTimeISO
		)}`,
		Headers = {
			["Accept"] = "application/json",
			["Authorization"] = `Bearer {accessToken}`,
		},
	})

	if not response.Success then
		reporter:Warn(`pure Gym QR failed request: {response.StatusMessage}`)

		return
	end

	local data = HttpService:JSONDecode(response.Body)

	return data
end

function ActivitiesSingleton.OnStart(self: ActivitiesSingleton)
	activitiesNamespace.ClientRequestActivities.OnServerEvent:Connect(function(player: Player)
		local activities = self:GenerateActivities(player)

		if not activities then
			reporter:Error(`Failed to poll for activities!`)
		end

		activitiesNamespace.ServerSendActivities:FireClient(player, activities)
	end)
end

export type ActivitiesSingleton = typeof(ActivitiesSingleton)

return ActivitiesSingleton
