local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local activitiesNamespace = ReplicatedStorage.Network.Activities

local ActivitiesSingleton = {}

function ActivitiesSingleton.RequestActivities(self: ActivitiesSingleton)
	local thread = coroutine.running()

	local connection = activitiesNamespace.ServerSendActivities.OnClientEvent:Once(function(...)
		coroutine.resume(thread, ...)
	end)

	activitiesNamespace.ClientRequestActivities:FireServer()

	return coroutine.yield()
end

export type ActivitiesSingleton = typeof(ActivitiesSingleton)

return ActivitiesSingleton
