local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local scope = Fusion.scoped(Fusion)

local function noop(operationName: string): any
	return function(...)
		warn(`Operation {operationName} fired with '{table.concat({...}, ", ")}' - no callback set though!`)
	end
end

return {
	Scope = scope,

	Page = scope:Value("Login"),
	ExitButtonVisible = scope:Value(false),

	QRCode = scope:Value(Content.none),
	QRCodeRefreshScale = scope:Value(0),
	MobileRotation = scope:Value(0),

	Callbacks = {
		ExitButtonActivated = noop("ExitButtonActivated"),
		SetActivePage = noop("SetActivePage"),
		LoginRequest = noop("LoginRequest"),
	}
}