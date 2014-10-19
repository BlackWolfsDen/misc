-- request by Vitrex
-- Script by Rochet2 of EmuDevs
-- Updated by slp13at420 of EmuDevs
-- drunken slurred outbursts by Bender

-- to make it fire only when activly moving players are 
-- close enough to trigger event 27 set `allways` to 0
-- then the npc will go idle when no players around.

local npcid = {10000, 10001, 10002}; -- you can apply this to multiple npc's here.
local delay = 1*30*1000 -- 30 seconds
local cycles = 1 -- must be value 1 . any value other than 1 MAY cause events to stack and freeze the core.
local allways = 1 -- constant fire after trigger = 1 // neutral after triggered fire = 0

local  ANN = {};
-- {Statement, stated, linked, emote, spellid} 
-- statement // in quotes "blah blah" 
-- stated // say = 0 // yell = 1 
-- linked // table key id if your using multiple statements  for one announcement i.e.(yell THEN say)
-- emote // talk = 1 // yell = 5// Question = 6 // Dance = 10 // Rude = 14 // shout = 22 // 
-- spellid // spell id
-- http://collab.kpsn.org/display/tc/Emote

ANN[npcid] = {-- {"Statement", stated, linked, emote, spellid} 
	[1] = {"Well,, that was dumb.", 0, 0, 1, 58837},
	[2] = {"!Bite my shiney metal ass!", 1, 0, 14, 0},
	[3] = {"Well,, were boned.", 0, 0, 1, 0},
	[4] = {"Hey sexy momma .. Wanna kill all humans..??.", 0, 0, 1, 58837},
	[5] = {"Goodbye losers whom I allways hated", 1, 0, 22, 0},
	[6] = {"!Shut the hell up!", 1, 0, 5, 0},
	[7] = {"Would you kindly shut your noise hole?", 0, 0, 1, 0},
	[8] = {"I'm gonna go build my own theme park.. with blackjack and hookerz.", 0, 101, 1, 0}, -- links to 101
	[9] = {"Who are you and why should i care?", 0, 0, 6, 0},
	[10] = {"!Shut up and Pay attention To Me !!.. !!BENDER!!", 1, 0, 5, 0},
	[11] = {"Hasta La Vista , Meat bag.", 0, 0, 1, 0},
	[12] = {"Awww, heres a little song i wrote to cheer you up. Its called ", 0, 100, 1, 0}, -- links to 100
	[13] = {"Do the Bender ,, Do the Bender ,, its your birthday ,, do the bender", 0, 0, 10, 0},
	[14] = {"Shut up baby , you love it", 0, 0, 1, 58837},
	[100] = {"!!Let's go allready!!", 1, 0, 5, 0}, -- linked from 8
	[101] = {"In fact ,, forget the park.", 0, 0, 1, 0}, -- linked from 12
		};
		
local function Drop_Event_On_Death(eventid, creature, killer)
	ANN[creature:GetGUIDLow()] = nil;
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

	local ostime = tonumber(GetGameTime())
	local seed = (ostime*ostime)
	math.randomseed(seed)
	
	local Ann = math.random(1, #ANN[npcid])

	Announce(Ann, creature)	
	creature:RemoveEvents()
	ANN[creature:GetGUIDLow()] = nil;
		
	if(allways == 1)then
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
