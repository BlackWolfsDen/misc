-- tnx to lightning blade for the use of method example that kicked off the idea :D.
-- this is supposed to hook the script to creature event 8 on receive emote
-- if the emote matches a random pre-determined emote value then a random pre-determined return emote
-- will happen. ooorrrrr... the creature may just attack you.... its a work in progress
-- slp13at420 emudevs.com

local Emotemax = 470
local percent = 0.25
local NPCEMOTEIDS = {}
local NPCEMOTEIDS = {{3100},{3116},{3127},{10685}};
				
local function NPC_EMOTE(event, creature, player, emoteid)

local Reaction = math.random(1, Emotemax)

	if(Reaction < (Emotemax-(Emotemax*percent)))then
		creature:Emote(Reaction)
	else
		creature:SendUnitYell("!!How Dare You!!",0)
		creature:AttackStart(player)
	end
end

for a = 1,#NPCEMOTEIDS do
	for _, v in ipairs(NPCEMOTEIDS[a]) do
		RegisterCreatureEvent(v, 8, NPC_EMOTE)
	end
end
