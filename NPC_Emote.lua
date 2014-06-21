-- this is supposed to hook the script to creature event 8 on receive emote
-- if the emote matches a random pre-determined emote value then a random pre-determined return emote
-- will happen. ooorrrrr... the creature may just attack you.... its a work in progress
-- slp13at420 emudevs.com

local Emotemax = 20
local percent = 0.25
				
local function NPC_EMOTE(event, creature, player, emoteid)

local Reactor = math.random(1, Emotemax)
local Reaction = math.random(1, Emotemax)

	if(emoteid==Reactor)then
		if(Reaction < (Emotemax-(Emotemax*percent)))then
			creature:Emote(Reaction)
		else
			creature:AttackStart(player)
		end
	end
end

RegisterCreatureEvent(100, 8, NPC_EMOTE)
RegisterCreatureEvent(3100, 8, NPC_EMOTE)
