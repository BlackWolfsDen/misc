-- this is supposed to hook the script to creature event 8 on recieve emote
-- if the emote matches a pre-determined emote value then a pre-determined return emote
-- will happen. orrr... the creature may just attack you.... its a work in progress

local Emotemax = 20
local percent = 0.25
				
local function NPC_EMOTE(event, creature, player, emoteid)

local Reactor = math.random(1, Emotemax)
local Reaction = math.random(1, Emotemax+1)

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
