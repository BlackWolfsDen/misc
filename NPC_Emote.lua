-- this is supposed to hook the script to creature event 8 on receive emote
-- if the emote matches a random pre-determined emote value then a random pre-determined return emote
-- will happen. ooorrrrr... the creature may just attack you.... its a work in progress
-- slp13at420 emudevs.com

local Emotemax = 20
local percent = 0.25
local NPCEMOTEIDS = {}
local NPCEMOTEIDS = {{3100},{3116},{3127},{10685}};
				
local function NPC_EMOTE(event, creature, player, emoteid)

local Reactor = math.random(1, Emotemax)
local Reaction = math.random(1, Emotemax+1)

	if(emoteid==Reactor)then
		if(Reaction < (Emotemax-(Emotemax*percent)))then
			creature:Emote(Reaction)
			print("emote")
		else
			creature:AttackStart(player)
			print("attack")
		end
	end
end

for a = 1,#NPCEMOTEIDS do
	for _, v in ipairs(NPCEMOTEIDS[a]) do
		RegisterCreatureEvent(v, 8, NPC_EMOTE)
	end
end