-- by Rochet2 of EmuDevs
-- tweeked by slp13at420 of EmuDevs
-- drunken slurred outbursts by Bender

local npcid = 3100 -- 10000
local delay = 1*60*1000 -- 60 seconds
local cycles = 1

local  ANN = {};
-- {Statement, stated} statement in quotes "blah blah", stated // say = 0 // yell = 1
ANN[npcid] = {
	[1] = {"Well,, that was dumb.", 0},
	[2] = {"!Bite my shiney metal ass!", 1},
	[3] = {"Well,, were boned.", 0},
	[4] = {"!Shut the hell up!", 1},
		};

local function Drop_Event_On_Death(eventid, creature, killer)
	ANN[creature:GetGUIDLow()] = {reset = nil,};
	creature:RemoveEvents()
end

RegisterCreatureEvent(npcid, 4, Drop_Event_On_Death)

local function TimedSay(eventId, delay, repeats, creature)

ANN[creature:GetGUIDLow()] = {reset = nil,};

yell = math.random(1, #ANN[npcid])

	if(ANN[npcid][yell][2] == 0)then
		creature:SendUnitSay(ANN[npcid][yell][1], 0)
	else
		creature:SendUnitYell(ANN[npcid][yell][1], 0)
	end
	
	creature:RemoveEvents()
	creature:RegisterEvent(TimedSay, delay, cycles)
	ANN[creature:GetGUIDLow()] = {reset = 1,};
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

RegisterCreatureEvent(npcid, 27, OnMotion)
