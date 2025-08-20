local ReplicatedFirst = game:GetService("ReplicatedFirst")

local InterfaceSingleton = require(ReplicatedFirst.Client.Singletons.InterfaceSingleton)
local StateSingleton = require(ReplicatedFirst.Client.Singletons.StateSingleton)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local TARGET_PAGE = "Home"

local function onPageEnabled()
	State.Page:set("Home")
	State.ExitButtonVisible:set(false)
end

local function onPageDisabled()

end

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