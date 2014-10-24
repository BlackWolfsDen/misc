-- tnx to lightning blade for the use of method example that kicked off the idea :D.
-- this is supposed to hook the script to creature event 8 on receive emote
-- when a pre-determined creature recieves an emote then it will return a random emote
-- ooorrrrr... the creature may get offended and just attack you.... its a work in progress
-- slp13at420 emudevs.com

print("+-+-+-+-+-+")

local Emotemax = 475
local percent = 0.25
local NPCEMOTEIDS = {}
local NPCEMOTEIDS = {3100,3116,3127,10685};-- creature entry id's
				
local function NPC_EMOTE(event, creature, player, emoteid)

local chance = math.random(1, Emotemax)
local Reaction = math.random(1, Emotemax)

	if(chance < (Emotemax-(Emotemax*percent)))then
		creature:Emote(Reaction)
	else
		creature:SendUnitYell("!!How Dare You!!",0)
		creature:AttackStart(player)
	end
end

for a = 1,#NPCEMOTEIDS do
	RegisterCreatureEvent(NPCEMOTEIDS[a], 8, NPC_EMOTE)
end

math.randomseed(os.time());

print("+ Emoting +")
print("+-+-+-+-+-+")
