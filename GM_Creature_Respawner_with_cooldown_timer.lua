-- request by 125125 of EmuDevs.com
-- created by slp13at420 of EmuDevs.com 

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
					player:SendBroadcastMessage("|cffFF3333You must select a creature|r")
				else

					if(player:GetSelection():GetObjectType()=="Creature")then
						player:GetSelection():Respawn()
						Crespawntimer[player:GetGUIDLow()] = {time = GetGameTime()};
					else
						player:SendBroadcastMessage("|cffFF0000For respawning creatures ONLY.|r")
					end
				end
			else
				player:SendBroadcastMessage("|cff0000FFcooling down.")
			end
		else
			player:SendBroadcastMessage("|cffFF0000You dont have access to that command.|r")
		end
	return false;
	end
end

RegisterPlayerEvent(18, Crespawn)
