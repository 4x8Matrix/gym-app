local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local Base = require(ReplicatedFirst.Client.Interfaces.Interfaces.Base)

local InterfaceSingleton = {}

InterfaceSingleton.PageRequested = Signal.new()
InterfaceSingleton.LoginRequested = Signal.new()

function InterfaceSingleton.IsCurrentPage(self: InterfaceSingleton, page: string)
	return page == Fusion.peek(State.Page)
end

function InterfaceSingleton.CreateInterface(self: InterfaceSingleton)
	local screenGui = State.Scope:New("ScreenGui")({
		ScreenInsets = Enum.ScreenInsets.None,
		Enabled = true,
		ResetOnSpawn = false,

		[Fusion.Children] = {
			Base(State.Scope, {}),
		},
	})

	screenGui.Parent = Players.LocalPlayer.PlayerGui
end

function InterfaceSingleton.CreateCallbacks(self: InterfaceSingleton)
	State.Callbacks.ExitButtonActivated = function()
		State.Callbacks.SetActivePage("Home")
	end

	State.Callbacks.SetActivePage = function(targetPage)
		local currentPage = Fusion.peek(State.Page)

		if currentPage == targetPage then
			return
		end

		self.PageRequested:FireDeferred(targetPage, currentPage)

		currentPage = targetPage
	end

	State.Callbacks.LoginRequest = function(email: string, pin: string)
		self.LoginRequested:Fire(email, pin)
	end
end

function InterfaceSingleton.OnStart(self: InterfaceSingleton)
	self:CreateCallbacks()
	self:CreateInterface()
end

export type InterfaceSingleton = typeof(InterfaceSingleton)

return InterfaceSingleton
