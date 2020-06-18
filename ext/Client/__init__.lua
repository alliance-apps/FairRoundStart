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
	Events:Subscribe('Extension:Loaded', function(levelName, gameMode)
	    WebUI:Init()
	    WebUI:ExecuteJS("updateText(['Error', 'Something is wrong lol'])")
	end)
	self.movementBlocker = Events:Subscribe('Player:Respawn', self, self.onPlayerRespawn)
	Events:Subscribe('Level:Loaded', function(player)
		WebUI:ExecuteJS("WebUI.Call('Show')")
	end)
	NetEvents:Subscribe('FairRoundStart:Start', function()
		self.movementBlocker:Unsubscribe()
		self:DisableInput(PlayerManager:GetLocalPlayer(), true)
		WebUI:ExecuteJS("WebUI.Call('Hide')")
	end)
	Events:Subscribe('Level:Destroy', function()
	    WebUI:ExecuteJS("WebUI.Call('Hide')")
	end)
	NetEvents:Subscribe('FairRoundStart:UpdateUI', function(team1current, team2current, team1min, team2min)
		WebUI:ExecuteJS("updateText(['US: Waiting for ".. (team1min - team1current) .." more... (".. team1current .."/".. team1min ..")', 'RU: Waiting for ".. (team2min - team2current) .." more... (".. team2current .."/".. team2min ..")'])")
	end)
	NetEvents:Subscribe('FairRoundStart:Reset', function(team1current, team2current, team1min, team2min)
		self.roundStarted = false
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
	if not self.roundStarted then
		self:DisableInput(player, false)
	end
end



g_FairRoundStart = FairRoundStart()
