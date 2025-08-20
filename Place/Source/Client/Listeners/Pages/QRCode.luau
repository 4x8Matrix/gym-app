local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AssetService = game:GetService("AssetService")

local PngLuau = require(ReplicatedStorage.Packages.PngLuau)
local Trove = require(ReplicatedStorage.Packages.Trove)

local InterfaceSingleton = require(ReplicatedFirst.Client.Singletons.InterfaceSingleton)
local StateSingleton = require(ReplicatedFirst.Client.Singletons.StateSingleton)
local QRSingleton = require(ReplicatedFirst.Client.Singletons.QRSingleton)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local TARGET_PAGE = "QR"

local currentTrove

local function startQRCodeSync()
	currentTrove = Trove.new()

	local qrCode = QRSingleton:RequestQRCode() :: any
	local imageFormat = PngLuau.decode(qrCode.qrCodePNG)

	local editableImage = AssetService:CreateEditableImage({
		Size = Vector2.new(imageFormat.width, imageFormat.height)
	})

	editableImage:WritePixelsBuffer(Vector2.zero, Vector2.new(imageFormat.width, imageFormat.height), imageFormat.pixels)

	State.QRCode:set(Content.fromObject(editableImage))

	local deltaTime = (qrCode.refreshAt - DateTime.now().UnixTimestamp) - 1

	currentTrove:Add(RunService.Heartbeat:Connect(function()
		local currentDeltaTime = qrCode.refreshAt - DateTime.now().UnixTimestamp

		State.QRCodeRefreshScale:set(currentDeltaTime / deltaTime)
	end))

	currentTrove:Add(task.delay(deltaTime, function()
		task.defer(function()
			startQRCodeSync()
		
			currentTrove:Destroy()
		end)
	end))
end

local function stopQRCodeSync()
	currentTrove:Destroy()
end

local function onPageEnabled()
	State.Page:set("QR")
	State.ExitButtonVisible:set(true)

	startQRCodeSync()
end

local function onPageDisabled()
	stopQRCodeSync()

	State.QRCode:set(Content.none)
	State.QRCodeRefreshScale:set(0)
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