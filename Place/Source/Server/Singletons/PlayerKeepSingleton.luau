local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Signal = require(ReplicatedStorage.Packages.Signal)

local getPlayerKeep = require(ReplicatedStorage.Shared.Utilities.getPlayerKeep)

local PlayerKeepSingleton = {}

PlayerKeepSingleton.Priority = 10

function PlayerKeepSingleton.OnPlayerAdded(self: PlayerKeepSingleton, player: Player)
	getPlayerKeep(player)
end

export type PlayerKeepSingleton = typeof(PlayerKeepSingleton)

return PlayerKeepSingleton