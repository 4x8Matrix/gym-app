local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local getPlayerKeep = require(ReplicatedStorage.Shared.Utilities.getPlayerKeep)

local stateNamespace = ReplicatedStorage.Network.State

local StateSingleton = {}

function StateSingleton.FetchPlayerState(self: StateSingleton, player: Player)
	local playerKeep = getPlayerKeep(player):expect()
	
	return playerKeep.Data.SavedState
end

function StateSingleton.UpdatePlayerState(self: StateSingleton, player: Player, state: { [any]: any })
	local playerKeep = getPlayerKeep(player):expect()

	playerKeep.Data.SavedState = state
end

function StateSingleton.OnStart(self: StateSingleton)
	stateNamespace.ClientRequestStoredState.OnServerEvent:Connect(function(player: Player)
		stateNamespace.ServerSendStoredState:FireClient(player, self:FetchPlayerState(player))
	end)

	stateNamespace.ClientRequestSaveState.OnServerEvent:Connect(function(player: Player, state: { [any]: any })
		self:UpdatePlayerState(player, state)
	end)
end

export type StateSingleton = typeof(StateSingleton)

return StateSingleton