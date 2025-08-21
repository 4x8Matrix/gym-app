local ReplicatedFirst = game:GetService("ReplicatedFirst")

local InterfaceSingleton = require(ReplicatedFirst.Client.Singletons.InterfaceSingleton)
local StateSingleton = require(ReplicatedFirst.Client.Singletons.StateSingleton)
local LoginSingleton = require(ReplicatedFirst.Client.Singletons.LoginSingleton)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local TARGET_PAGE = "Login"

local function onLoginCompleted()
	State.Callbacks.SetActivePage("Home")
end

local function onPageEnabled()
	warn("Login page activated?", LoginSingleton:IsLoggedIn())
	if LoginSingleton:IsLoggedIn() then
		onLoginCompleted()
	end
end

return function()
	InterfaceSingleton.PageRequested:Connect(function(newPage, oldPage)
		if newPage == TARGET_PAGE then
			onPageEnabled()
		end
	end)

	InterfaceSingleton.LoginRequested:Connect(function(email, pin)
		local status = LoginSingleton:RequestLogin(email, pin)

		if status then
			onLoginCompleted()
		end
	end)

	task.defer(function()
		StateSingleton.SyncedState:Wait()

		if InterfaceSingleton:IsCurrentPage(TARGET_PAGE) then
			onPageEnabled()
		end
	end)
end
