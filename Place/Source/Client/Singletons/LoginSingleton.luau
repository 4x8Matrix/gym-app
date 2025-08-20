local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Base64 = require(ReplicatedStorage.Packages.Base64)

local createWatchdog = require(ReplicatedStorage.Shared.Utilities.createWatchdog)

local loginNamespace = ReplicatedStorage.Network.Login

local isLoggedIn = false
local isLoggedInSynced = false

local LoginSingleton = {}

LoginSingleton.Priority = 150

LoginSingleton.LoginFailed = Signal.new()
LoginSingleton.LoginSuccess = Signal.new()

function LoginSingleton.IsLoggedIn(self: LoginSingleton)
	while not isLoggedInSynced do
		task.wait()
	end

	return isLoggedIn
end

function LoginSingleton.RequestLogin(self: LoginSingleton, email: string, pin: string)
	local thread = coroutine.running()
	local trove = Trove.new()
	
	trove:Add(self.LoginFailed:Connect(function()
		coroutine.resume(thread, false)
	end))

	trove:Add(self.LoginSuccess:Connect(function()
		coroutine.resume(thread, true)
	end))

	loginNamespace.ClientRequestLogin:FireServer(
		Base64.encode(buffer.fromstring(email)),
		Base64.encode(buffer.fromstring(pin))
	)

	local result = coroutine.yield()

	trove:Destroy()

	return result
end

function LoginSingleton.OnStart(self: LoginSingleton)
	loginNamespace.ServerSendLoginState.OnClientEvent:Connect(function(state)
		isLoggedIn = state
		isLoggedInSynced = true

		if state then
			self.LoginSuccess:Fire()
		else
			self.LoginFailed:Fire()
		end
	end)

	loginNamespace.ClientRequestLoginState:FireServer()
end

export type LoginSingleton = typeof(LoginSingleton)

return LoginSingleton