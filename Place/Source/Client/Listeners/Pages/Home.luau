local ReplicatedFirst = game:GetService("ReplicatedFirst")

local InterfaceSingleton = require(ReplicatedFirst.Client.Singletons.InterfaceSingleton)
local StateSingleton = require(ReplicatedFirst.Client.Singletons.StateSingleton)
local ActivitiesSingleton = require(ReplicatedFirst.Client.Singletons.ActivitiesSingleton)
local GymSingleton = require(ReplicatedFirst.Client.Singletons.GymSingleton)
local LoginSingleton = require(ReplicatedFirst.Client.Singletons.LoginSingleton)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local TARGET_PAGE = "Home"

local function onPageEnabled()
	State.Page:set("Home")
	State.ExitButtonVisible:set(false)

	local latestActivities = ActivitiesSingleton:RequestActivities()
	local latestLiveInfo = GymSingleton:RequestLiveCount(`{latestActivities.Visits[1].Gym.Id}`)
	local pin = LoginSingleton:RequestPin()

	State.Pin:set(pin)

	State.GymVisits:set(latestActivities.Summary.Total.Visits)
	State.WorkoutTime:set(latestActivities.Summary.Total.Duration)
	State.GymActivities:set(latestActivities.Summary.Total.Activities)
	State.TotalPeopleInClasses:set(latestLiveInfo.TotalPeopleInClasses)
	State.TotalPeopleInGym:set(latestLiveInfo.TotalPeopleInGym)
	State.MaximumCapacity:set(latestLiveInfo.MaximumCapacity ~= 0 and latestLiveInfo.MaximumCapacity or "Unknown")
end

local function onPageDisabled() end

return function()
	InterfaceSingleton.PageRequested:Connect(function(newPage, oldPage)
		if oldPage == TARGET_PAGE then
			onPageDisabled()
		end

		if newPage == TARGET_PAGE then
			onPageEnabled()
		end
	end)

	task.defer(function()
		StateSingleton.SyncedState:Wait()

		if InterfaceSingleton:IsCurrentPage(TARGET_PAGE) then
			onPageEnabled()
		end
	end)
end
