-- by slp13at420 of EmuDevs.com

local Crespawntimer = {};
local message = "#respawn" -- trigger message
local GMrank = 2 -- minimum required rank to access this command
local timer = 300000 -- cooldown timer in ms 1000 = 1 second :: 60000 = 1 minute :: 300000 = 5 minutes

local function Crespawn(event, player, msg, Type, lang)

local Ltime = GetGameTime()

	if(msg == message)then
	
		if(player:GetGMRank() >= GMrank)then
		
			if(Crespawntimer[player:GetGUIDLow()] == nil)then
				Crespawntimer[player:GetGUIDLow()] = {
													time = 0
														};
			end
	
			if((Ltime - Crespawntimer[player:GetGUIDLow()].time) >= timer)then
	
				if(player:GetSelection() == nil)then
					player:SendBroadcastMessage("You must select a creature")
				else

					if(player:GetSelection():GetObjectType()=="Creature")then
						player:GetSelection():Respawn()
						Crespawntimer[player:GetGUIDLow()] = {time = GetGameTime()};
					else
						player:SendBroadcastMessage("For respawning creatures ONLY.")
					end
				end
			else
				player:SendBroadcastMessage("cooling down.")
			end
		else
			player:SendBroadcastMessage("You dont have access to that command.")
		end
	return false;
	end
end

RegisterPlayerEvent(18, Crespawn)
