--[[
	Responsible for returning the keep for the player data - keeps are cached so you can call this function
		multiple times without any issues.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataKeepTypes = require(ReplicatedStorage.Shared.Types.DataKeep)
local PromiseTypes = require(ReplicatedStorage.Shared.Types.Promise)

local DataKeep = require(ServerScriptService.Packages.DataKeep)

local getPlayerStore = require(ReplicatedStorage.Shared.Utilities.getPlayerStore)

return function(
	player: Player,
	loadMethod: string?
): PromiseTypes.TypedPromise<DataKeepTypes.keep<getPlayerStore.PlayerData, any>>
	local playerStore = getPlayerStore:expect()

	return playerStore
		:LoadKeep(`{player.UserId}`, function()
			return loadMethod or DataKeep.LoadMethods.Cancel
		end)
		:andThen(function(keep)
			keep:Reconcile()
			keep:AddUserId(player.UserId)

			return keep
		end)
end
