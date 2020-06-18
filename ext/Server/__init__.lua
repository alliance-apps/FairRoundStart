class 'FairRoundStart'

function FairRoundStart:__init()
	print("Initializing FairRoundStart by cat24max/AllianceApps V1")
	self:RegisterVars()
	self:RegisterEvents()

	
	


	Events:Subscribe('Player:Chat', function(player, recipientMask, message)
	    if message == "GO" then
	    	self:StartRound()
	    end
	end)

end

function FairRoundStart:RegisterVars()
	self.roundStarted = false
	self.movementBlocker = nil
end

function FairRoundStart:RegisterEvents()
	-- Events:Subscribe('Player:Respawn', self, self.onPlayerRespawn)
	self.movementBlocker = Events:Subscribe('Player:UpdateInput', function(player, dt)
	  	player.input:SetLevel(EntryInputActionEnum.EIAThrottle, 0)
	  	player.input:SetLevel(EntryInputActionEnum.EIAStrafe, 0)
	  	if not self.roundStarted then
			self:DisableInput(player, false)
		end
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

function FairRoundStart:StartRound()
	self.roundStarted = true
	self.movementBlocker:Unsubscribe()
	NetEvents:Broadcast("FairRoundStart:Start")
	ChatManager:SendMessage("------- LIVE -------")
	ChatManager:SendMessage("------- LIVE -------")
	ChatManager:SendMessage("------- LIVE -------")
	for _,player in pairs(PlayerManager:GetPlayers()) do
		self:DisableInput(player, true)
	end
end

function FairRoundStart:onPlayerRespawn(player)
	if not self.roundStarted then
		ChatManager:SendMessage("Round has not started yet, not enough players have joined")
		self:DisableInput(player, false)
	end
end


g_FairRoundStart = FairRoundStart()
