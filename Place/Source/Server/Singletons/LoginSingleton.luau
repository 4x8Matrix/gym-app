local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Base64 = require(ReplicatedStorage.Packages.Base64)
local Console = require(ReplicatedStorage.Packages.Console)

local createWatchdog = require(ReplicatedStorage.Shared.Utilities.createWatchdog)
local getPlayerKeep = require(ReplicatedStorage.Shared.Utilities.getPlayerKeep)

local loginNamespace = ReplicatedStorage.Network.Login
local reporter = Console.new(script.Name)
local loginTokens = {}
local triedToLogin = {}

local LoginSingleton = {}

LoginSingleton.LoginSuccess = Signal.new()
LoginSingleton.LoginFailure = Signal.new()

function LoginSingleton.LogInAsync(self: LoginSingleton, player: Player)
	local keep = getPlayerKeep(player):expect()

	local email = keep.Data.Email
	local pin = keep.Data.Pin

	if email == "" or pin == "-1" then
		reporter:Warn(`Login credentials for '{player.Name}' are invalid - not logging in!`)

		return
	end

	local response = HttpService:RequestAsync({
		Url = "https://auth.puregym.com/connect/token",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
			["Accept"] = "application/json",
			["Authorization"] = "Basic cm8uY2xpZW50Og==",
		},
		Body = `grant_type=password&username={HttpService:UrlEncode(email)}&password={pin}&scope=pgcapi+offline_access`,
	})

	if response.Success then
		local jsonContent = HttpService:JSONDecode(response.Body)

		loginTokens[player] = jsonContent.access_token

		self.LoginSuccess:FireDeferred()
		loginNamespace.ServerSendLoginState:FireClient(player, true)
	else
		self.LoginFailure:FireDeferred()
		loginNamespace.ServerSendLoginState:FireClient(player, false)
	end
end

function LoginSingleton.GetAccessToken(self: LoginSingleton, player: Player)
	while not triedToLogin[player] do
		task.wait()
	end

	return loginTokens[player]
end

function LoginSingleton.OnPlayerAdded(self: LoginSingleton, player: Player)
	self:LogInAsync(player)

	triedToLogin[player] = true
end

function LoginSingleton.OnPlayerRemoving(self: LoginSingleton, player: Player)
	loginTokens[player] = nil
end

function LoginSingleton.OnStart(self: LoginSingleton)
	loginNamespace.ClientRequestLoginState.OnServerEvent:Connect(function(player: Player)
		loginNamespace.ServerSendLoginState:FireClient(player, self:GetAccessToken(player) ~= nil)
	end)

	loginNamespace.ClientRequestLogin.OnServerEvent:Connect(function(player: Player, email: buffer, pin: buffer)
		local keep = getPlayerKeep(player):expect()

		keep.Data.Email = buffer.tostring(Base64.decode(email))
		keep.Data.Pin = buffer.tostring(Base64.decode(pin))

		self:LogInAsync(player)
	end)

	loginNamespace.ClientRequestPin.OnServerEvent:Connect(function(player: Player)
		local keep = getPlayerKeep(player):expect()

		loginNamespace.ServerSendPin:FireClient(player, keep.Data.Pin)
	end)
end

export type LoginSingleton = typeof(LoginSingleton)

return LoginSingleton
