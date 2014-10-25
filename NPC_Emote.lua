-- tnx to lightning blade for the use of method example that kicked off the idea :D.
-- this is supposed to hook the script to creature event 8 on receive emote
-- when a pre-determined creature recieves an emote then it will return a random emote
-- ooorrrrr... the creature may get offended and just attack you.... its a work in progress
-- slp13at420 emudevs.com

print("+-+-+-+-+-+")

local Emotemax = 475
local percent = 0.25
local NPCEMOTEIDS = {}
local NPCEMOTEIDS = {3100,3116,3127,10685};-- creature entry id's,, add whatever creature id's you want
				
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

--[[
-- if you want to apply this to a shit-ton of npc's then just add a column to you creature.tremplate called `emoter` witha value of 1 or 0
-- 0 no 1 yes
-- then un-rem this block and rem #NPCEMOTEIDS loop block plus the table (lines 40,41,42,11,12)

local query = WorldDBQuery("SELECT `entry` FROM creature_template WHERE `emoter` = 1;")
	if(query)then
		repeat
			RegisterCreatureEvent(query:GetUInt32(0), 8, NPC_EMOTE)
		until not query:NextRow()
	end
]]--

for a = 1,#NPCEMOTEIDS do -- loop
	RegisterCreatureEvent(NPCEMOTEIDS[a], 8, NPC_EMOTE)
end

math.randomseed(os.time());

print("+ Emoting +")
print("+-+-+-+-+-+")
