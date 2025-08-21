local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local State = require(ReplicatedFirst.Client.Interfaces.State)

local createWatchdog = require(ReplicatedStorage.Shared.Utilities.createWatchdog)

local stateNamespace = ReplicatedStorage.Network.State

local STATE_VALUES_TO_SAVE = table.freeze({
	"ExitButtonVisible",
	"Page",
})

local StateSingleton = {}

StateSingleton.Priority = 100

StateSingleton.SavedState = Signal.new()
StateSingleton.SyncedState = Signal.new()

function StateSingleton.RestoreState(self: StateSingleton, state: { [any]: any })
	for key, value in state do
		State[key]:set(value)
	end
end

function StateSingleton.SaveState(self: StateSingleton)
	local state = {}

	for _, valueName in STATE_VALUES_TO_SAVE do
		state[valueName] = Fusion.peek(State[valueName])
	end

	stateNamespace.ClientRequestSaveState:FireServer(state)

	self.SavedState:FireDeferred()
end

function StateSingleton.StartSaveStateSync(self: StateSingleton)
	local thread = task.defer(function()
		while true do
			task.wait(0.5)

			self:SaveState()
		end
	end)

	createWatchdog(thread, function()
		self:StartSaveStateSync()
	end)
end

function StateSingleton.OnStart(self: StateSingleton)
	stateNamespace.ServerSendStoredState.OnClientEvent:Connect(function(...)
		self:RestoreState(...)

		self:StartSaveStateSync()

		self.SyncedState:FireDeferred()
	end)

	stateNamespace.ClientRequestStoredState:FireServer()
end

export type StateSingleton = typeof(StateSingleton)

return StateSingleton
