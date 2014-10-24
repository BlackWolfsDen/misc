-- <A_Work_in_Progress>
-- request by Vitrex
-- Script by Rochet2 of EmuDevs
-- Updated by slp13at420 of EmuDevs
-- drunken slurred outbursts by `Bender the drunken annoying robot`

-- The npc will start once a player is moving close enough to trigger event 27
-- then it will babble non-stop while players are moving or idle near it.
-- then the npc will automaticaly go idle when no players around.

-- I DONT Recommend you use this on Mobs. that could cause lag and freezing of the core.

local npcid = {3100, 3101, 3102}; -- you can apply this to one or multiple npc's here.
local delay = 1*30*1000 -- 30 seconds
local spawn_duration = 1*30*1000 -- 30 seconds
local range = 15 -- the distance an idle player can be from the npc to trigger a continuous outburst.

local  ANN = {};

-- {Statement, stated, linked, emote, spellid,{spawn type, spawn id},},
-- statement :: in quotes "blah blah" 
-- stated :: say = 0 // yell = 1 
-- linked :: table key id if your using multiple statements  for one announcement i.e.(yell THEN say)
-- emote :: talk = 1 // yell = 5// Question = 6 // Dance = 10 // Rude = 14 // shout = 22 // 
-- spellid :: spell id
-- http://collab.kpsn.org/display/tc/Emote
-- spawn type :: 0 none, 1 npc // 2 gob
-- spawn id :: id of what to spawn

ANN["Bender"] = {-- {"Statement", stated, linked, emote, spellid, {spawn type, spawn id},},
	[1] = {"Well,, that was dumb.", 0, 0, 1, 58837, 1, 10000}}, -- say, Emote 1, spell 58837
	[2] = {"!Bite my shiney metal ass!", 1, 0, 14, 0, {0, 0}}, -- yell, Emote 14
	[3] = {"Well,, were boned.", 0, 0, 1, 0, {0, 0}}, -- say, Emote 1
	[4] = {"Hey sexy momma .. Wanna kill all humans..??.", 0, 0, 1, 58837, {0, 0}}, -- say, Emote 1, spell 58837
	[5] = {"Goodbye losers whom I allways hated", 1, 0, 22, 0, {0, 0}}, -- yell, emote 22
	[6] = {"!Shut the hell up!", 1, 0, 5, 0, {0, 0}}, -- yell, emote 5
	[7] = {"Would you kindly shut your noise hole?", 0, 0, 1, 0, {0, 0}}, -- say, emote 1
	[8] = {"I'm gonna go build my own theme park.. with blackjack and hookerz.", 0, 101, 1, 0, {0, 0}}, -- say, emote 1, links to 101
	[9] = {"Who are you and why should i care?", 0, 0, 25, 0, {0, 0}}, -- say, emote 25
	[10] = {"!Shut up and Pay attention To Me !!.. !!BENDER!!", 1, 0, 5, 0, {0, 0}}, -- yell , emote 5
	[11] = {"Hasta La Vista , Meat bag.", 0, 0, 1, 0, {0, 0}},
	[12] = {"Awww, heres a little song i wrote to cheer you up. Its called ", 0, 100, 1, 0, {0, 0}}, -- links to 100
	[13] = {"Do the Bender ,, Do the Bender ,, its your birthday ,, do the bender", 0, 0, 10, 0, {0, 0}},
	[14] = {"Shut up baby , you love it", 0, 0, 1, 58837, {0, 0}}, -- uses spell
	[100] = {"!!Let's go allready!!", 1, 0, 5, 0, {0, 0}}, -- linked from 8
	[101] = {"In fact ,, forget the park.", 0, 0, 1, 0, {0, 0}}, -- linked from 12
		};
		
local function Drop_Event_On_Death(eventid, creature, killer) -- removes ALL events upon death of npc. this is here if the npc is attackable.
	ANN[creature:GetGUIDLow()] = {reset = 0,};
	creature:RemoveEvents()
end

local function Announce(id, creature)
	
local statement, stated, linked, emote, spellid, spawn_type, spawn_id = table.unpack(ANN["Bender"][id])

	if(emote ~= (nil or 0))then creature:Emote(emote)end -- check emote column for emote.

	if(stated == 0)then creature:SendUnitSay(statement, 0) else creature:SendUnitYell(statement, 0); end -- check stated column if say else yell.

	if(linked ~= (nil or 0))then Announce(linked, creature) end -- check the linked column for key id.

	if(spellid ~= (nil or 0))then creature:CastSpell(creature, spellid); end-- check the spellid column for spell id.

	if(spawn_type > 0)then 	PerformIngameSpawn(spawn_type, spawn_id, creature:GetMapId(), creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 1, spawn_duration); end

end

local function TimedSay(eventId, duration, repeats, creature)

local cGuid = creature:GetGUIDLow();

Announce(math.random(#ANN["Bender"]), creature) -- sends the data to Announce function

	if(#creature:GetPlayersInRange(range) >= 1)then -- check for continue if idle players are still in range.
		creature:RegisterEvent(TimedSay, delay, 1) -- time to annoy those idle players
		ANN[cGuid] = {reset = 1,}; -- set to 1 (Yes players are within preset range.)
	else
		ANN[cGuid] = {reset = 2,}; -- set to 2  (No players are within preset range.)
	end
end

local function OnMotion(event, creature, unit)

	if(unit:GetObjectType()=="Player")then
	
		local cGuid = creature:GetGUIDLow();
		
		if((ANN[cGuid] == nil)or(ANN[cGuid].reset == (nil or 0)))then -- j/k flip flip fresh trigger 
			ANN[cGuid] = {reset = 1,}; -- set j/k to 1
			TimedSay(1, delay, 1, creature)
		end
		
		if(ANN[cGuid].reset == 2)then -- (NO players are within preset range.) but motion was triggered.
 			ANN[cGuid] = {reset = 1,}; -- set j/k back to position 1
			creature:RemoveEvents()
			creature:RegisterEvent(TimedSay, delay, 1)
 		end

	end
end

for npc=1, #npcid do

	RegisterCreatureEvent(npcid[npc], 27, OnMotion) 
	RegisterCreatureEvent(npcid[npc], 4, Drop_Event_On_Death)
end

math.randomseed(os.time());
