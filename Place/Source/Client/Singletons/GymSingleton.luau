local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local gymNamespace = ReplicatedStorage.Network.Gym

local GymSingleton = {}

function GymSingleton.RequestLiveCount(self: GymSingleton, gymId: string)
	local thread = coroutine.running()

	local connection = gymNamespace.ServerSendGymLiveCount.OnClientEvent:Once(function(...)
		coroutine.resume(thread, ...)
	end)

	gymNamespace.ClientRequestGymLiveCount:FireServer(gymId)

	return coroutine.yield()
end

export type GymSingleton = typeof(GymSingleton)

return GymSingleton
