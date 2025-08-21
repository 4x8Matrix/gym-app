local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Console = require(ReplicatedStorage.Packages.Console)

local LoginSingleton = require(ServerScriptService.Server.Singletons.LoginSingleton)

local gymNamespace = ReplicatedStorage.Network.Gym

local GymSingleton = {}

local reporter = Console.new(script.Name)

function GymSingleton.QueryGymLiveCount(self: GymSingleton, player: Player, gymId: string): { [any]: any }?
	local accessToken = LoginSingleton:GetAccessToken(player)
	local response = HttpService:RequestAsync({
		Url = `https://capi.puregym.com/api/v2/gymSessions/gym?gymId={gymId}`,
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

function GymSingleton.OnStart(self: GymSingleton)
	gymNamespace.ClientRequestGymLiveCount.OnServerEvent:Connect(function(player: Player, gymId: string)
		local liveCount = self:QueryGymLiveCount(player, gymId)

		if not liveCount then
			reporter:Error(`Failed to poll for gym live count!`)
		end

		gymNamespace.ServerSendGymLiveCount:FireClient(player, liveCount)
	end)
end

export type GymSingleton = typeof(GymSingleton)

return GymSingleton
