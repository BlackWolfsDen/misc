-- by Rochet2 of EmuDevs
-- tweeked by slp13at420 of EmuDevs
-- drunken slurred outbursts by Bender

local npcid = 3100 -- 10000
local delay = 1*60*1000 -- 60 seconds
local cycles = 1 -- do not change our you may cause your core to freeze up. MUST onyl be value 1 or events will stack exponentially .
local restart_msg = "load talker"

local  ANN = {};

ANN[npcid] = { -- {Statement, stated} :: Statement in quotes "blah blah", stated // say = 0 // yell = 1
	[1] = {"!Hey!! Pay attention To Me !!.. !!BENDER!!", 1},
	[2] = {"Hey sexy momma .. Wanna kill all humans..??.", 0},
	[3] = {"Would you kindly shut your pie hole?", 0},
		};

local function Drop_Event_On_Death(eventid, creature, killer)
	creature:RemoveEvents()
end

RegisterCreatureEvent(npcid, 4, Drop_Event_On_Death)

local function TimedSay(eventId, delay, repeats, creature)

yell = math.random(1, #ANN[npcid])

	if(ANN[npcid][yell][2] == 0)then
		creature:SendUnitSay(ANN[npcid][yell][1], 0)
	else
		creature:SendUnitYell(ANN[npcid][yell][1], 0)
	end
	
	creature:RemoveEvents()
	creature:RegisterEvent(TimedSay, delay, cycles)
end

local function OnReset(event, creature)
    creature:RegisterEvent(TimedSay, delay, cycles)
end

RegisterCreatureEvent(npcid, 23, OnReset)

function ReloadTalker(event, player, msg) -- select creature and type `load talker`

	 if(msg)then 
	 
		if((msg:lower() == restart_msg)and(player:GetGMRank() >= 3))then 

			if(player:GetSelection():GetEntry() == npcid)then

				player:GetSelection():RegisterEvent(TimedSay, delay, cycles)
			else
			end
		else
		end 
	else
	end 
end

RegisterPlayerEvent(18, ReloadTalker)
