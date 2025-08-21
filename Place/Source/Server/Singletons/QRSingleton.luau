local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Console = require(ReplicatedStorage.Packages.Console)

local LoginSingleton = require(ServerScriptService.Server.Singletons.LoginSingleton)

local QRNamespace = ReplicatedStorage.Network.QR

local QRSingleton = {}

local reporter = Console.new(script.Name)

function QRSingleton.GenerateQRCode(self: QRSingleton, player: Player): { [any]: any }?
	local accessToken = LoginSingleton:GetAccessToken(player)
	local pureGymResponse = HttpService:RequestAsync({
		Url = "https://capi.puregym.com/api/v2/member/qrcode",
		Headers = {
			["Accept"] = "application/json",
			["Authorization"] = `Bearer {accessToken}`,
		},
	})

	if not pureGymResponse.Success then
		reporter:Warn(`pure Gym QR failed request: {pureGymResponse.StatusMessage}`)

		return
	end

	local body = HttpService:JSONDecode(pureGymResponse.Body)

	local qrCodeResponse = HttpService:RequestAsync({
		Url = `https://api.qrserver.com/v1/create-qr-code/?size=350x350&data={body.QrCode}`,
		Method = "GET",
	})

	if not qrCodeResponse.Success then
		reporter:Warn(`QR PNG failed to download: {qrCodeResponse.StatusMessage}`)

		return
	end

	return {
		qrCodeContent = body.QrCode,
		qrCodePNG = buffer.fromstring(qrCodeResponse.Body),
		refreshAt = DateTime.fromIsoDate(body.RefreshAt).UnixTimestamp,
	}
end

function QRSingleton.OnStart(self: QRSingleton)
	QRNamespace.ClientRequestQRCode.OnServerEvent:Connect(function(player: Player)
		local qrCode = self:GenerateQRCode(player)

		if not qrCode then
			reporter:Error(`Failed to poll for QR code!`)
		end

		QRNamespace.ServerSendQRCode:FireClient(player, qrCode)
	end)
end

export type QRSingleton = typeof(QRSingleton)

return QRSingleton
