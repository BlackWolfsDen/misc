-- request by Vitrex
-- Script by Rochet2 of EmuDevs
-- Updated by slp13at420 of EmuDevs
-- drunken slurred outbursts by Bender

-- with `allways` set to 1 The npc will start once a player is moving 
-- close enough to trigger event 27 then it will babble non-stop.
-- to make it fire only when activly moving players are 
-- close enough to trigger event 27 set `allways` to 0
-- then the npc will go idle when no players around.

-- I DONT Recommend you use this on Mobs. that could cause lag and freezing of the core.

local npcid = {3100, 3101, 3102}; -- you can apply this to one or multiple npc's here.
local delay = 1*30*1000 -- 30 seconds
local cycles = 1 -- must be value 1 . any value other than 1 MAY cause events to stack and freeze the core.
local allways = 1 -- constant fire after triggered = 1 // neutral after triggered fires once = 0

local  ANN = {};

-- {Statement, stated, linked, emote, spellid} 
-- statement // in quotes "blah blah" 
-- stated // say = 0 // yell = 1 
-- linked // table key id if your using multiple statements  for one announcement i.e.(yell THEN say)
-- emote // talk = 1 // yell = 5// Question = 6 // Dance = 10 // Rude = 14 // shout = 22 // 
-- spellid // spell id
-- http://collab.kpsn.org/display/tc/Emote

ANN[npcid] = {-- {"Statement", stated, linked, emote, spellid} 
	[1] = {"Well,, that was dumb.", 0, 0, 1, 58837}, -- say, Emote 1, spell 58837
	[2] = {"!Bite my shiney metal ass!", 1, 0, 14, 0}, -- yell, Emote 14
	[3] = {"Well,, were boned.", 0, 0, 1, 0}, -- say, Emote 1
	[4] = {"Hey sexy momma .. Wanna kill all humans..??.", 0, 0, 1, 58837}, -- say, Emote 1, spell 58837
	[5] = {"Goodbye losers whom I allways hated", 1, 0, 22, 0}, -- yell, emote 22
	[6] = {"!Shut the hell up!", 1, 0, 5, 0}, -- yell, emote 5
	[7] = {"Would you kindly shut your noise hole?", 0, 0, 1, 0}, -- say, emote 1
	[8] = {"I'm gonna go build my own theme park.. with blackjack and hookerz.", 0, 101, 1, 0}, -- say, emote 1, links to 101
	[9] = {"Who are you and why should i care?", 0, 0, 25, 0}, -- say, emote 25
	[10] = {"!Shut up and Pay attention To Me !!.. !!BENDER!!", 1, 0, 5, 0}, -- yell , emote 5
	[11] = {"Hasta La Vista , Meat bag.", 0, 0, 1, 0},
	[12] = {"Awww, heres a little song i wrote to cheer you up. Its called ", 0, 100, 1, 0}, -- links to 100
	[13] = {"Do the Bender ,, Do the Bender ,, its your birthday ,, do the bender", 0, 0, 10, 0},
	[14] = {"Shut up baby , you love it", 0, 0, 1, 58837}, -- uses spell
	[100] = {"!!Let's go allready!!", 1, 0, 5, 0}, -- linked from 8
	[101] = {"In fact ,, forget the park.", 0, 0, 1, 0}, -- linked from 12
		};
		
local function Drop_Event_On_Death(eventid, creature, killer) -- removes ALL events upon death of npc.
	creature:RemoveEvents()
end

local function Announce(id, creature)

	if(ANN[npcid][id][4] ~= (nil or 0))then -- check emote column for emote.
		creature:Emote(ANN[npcid][id][4])
	end

	if(ANN[npcid][id][2] == 0)then -- check stated column if say.
		creature:SendUnitSay(ANN[npcid][id][1], 0)
	end

	if(ANN[npcid][id][2] == 1)then -- check stated column if yell.
		creature:SendUnitYell(ANN[npcid][id][1], 0)
	end

	if(ANN[npcid][id][3]~=(nil or 0))then -- check the linked column for key id.
		Announce(ANN[npcid][id][3], creature)
	end

	if(ANN[npcid][id][5] ~= (nil or 0))then -- check the spellid column for spell id.
		creature:CastSpell(creature, ANN[npcid][id][5], true)
	end
end

local function TimedSay(eventId, delay, repeats, creature)

	local Ann = math.random(1, #ANN[npcid])

	Announce(Ann, creature) -- sends the data to Announce function
	creature:RemoveEvents()
	ANN[creature:GetGUIDLow()] = nil;
		
	if(allways == 1)then -- checks switch for continuous 1
		creature:RegisterEvent(TimedSay, delay, cycles)
		ANN[creature:GetGUIDLow()] = {reset = 1,};
	end
end

local function OnMotion(event, creature, unit)

	if(unit:GetObjectType()=="Player")then

		if(ANN[creature:GetGUIDLow()]==nil)then  
			ANN[creature:GetGUIDLow()] = {reset = 1,};
		    creature:RegisterEvent(TimedSay, delay, cycles)
		else
		end
	else
	end
end

for npc=1, #npcid do

	RegisterCreatureEvent(npcid[npc], 27, OnMotion) 
	RegisterCreatureEvent(npcid[npc], 4, Drop_Event_On_Death)
end

math.randomseed(os.time());
