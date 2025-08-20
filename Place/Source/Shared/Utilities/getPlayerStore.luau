--[[
	Responsible for returning the Store that holds the player data
]]

local ServerScriptService = game:GetService("ServerScriptService")

local DataKeep = require(ServerScriptService.Packages.DataKeep)

local playerData = {
	SavedState = {},
	StateVersion = 0,

	Pin = "-1",
	Email = ""
}

export type PlayerData = typeof(playerData)

return DataKeep.GetStore("App_Persistence", playerData, {})
