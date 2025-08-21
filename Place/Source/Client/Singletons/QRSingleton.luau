local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local stateNamespace = ReplicatedStorage.Network.QR

local QRSingleton = {}

function QRSingleton.RequestQRCode(self: QRSingleton)
	local thread = coroutine.running()

	local connection = stateNamespace.ServerSendQRCode.OnClientEvent:Once(function(...)
		coroutine.resume(thread, ...)
	end)

	stateNamespace.ClientRequestQRCode:FireServer()

	return coroutine.yield()
end

export type QRSingleton = typeof(QRSingleton)

return QRSingleton
