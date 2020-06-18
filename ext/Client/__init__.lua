class 'FairRoundStart'

function FairRoundStart:__init()
	print("Initializing FairRoundStart by cat24max/AllianceApps V1")
	self:RegisterVars()
	self:RegisterEvents()
end


function FairRoundStart:RegisterVars()
	self.roundStarted = false
	self.movementBlocker = nil
end

function FairRoundStart:RegisterEvents()
	Events:Subscribe('Level:Loaded', function(levelName, gameMode)
	    WebUI:Init()
	end)
	self.movementBlocker = Events:Subscribe('Player:Respawn', self, self.onPlayerRespawn)
	NetEvents:Subscribe('FairRoundStart:Start', function()
		self.movementBlocker:Unsubscribe()
		self:DisableInput(PlayerManager:GetLocalPlayer(), true)
	end)
end

function FairRoundStart:DisableInput(player, newbool)
	if player == nil then return end
	player:EnableInput(7, newbool) -- EIAFire
	player:EnableInput(1, newbool) -- EIAStrafe
	player:EnableInput(0, newbool) -- EIAThrottle
	player:EnableInput(35, newbool) -- EIAInteract
	player:EnableInput(31, newbool) -- EIAThrowGrenade
end


function FairRoundStart:onPlayerRespawn(player)
	self:DisableInput(player, false)
	WebUI:ExecuteJS("WebUI.Call('Show')")
	WebUI:ExecuteJS('app.$data.message = "<strong>FairRoundStart</strong><br>Waiting for 50% of players to spawn...<br>RU: 8/16<br>US: 13/15";')
end



g_FairRoundStart = FairRoundStart()
