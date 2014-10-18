-- by Rochet2 of EmuDevs
-- tweeked by slp13at420 of EmuDevs

local npcid = 3100 -- 10000
local delay = 1*60*1000 -- 60 seconds
local cycles = 1
local restart_msg = "load talker"

local  ANN = {};

ANN[npcid] = {
	[1] = "!Hey!! Pay attention To Me !!.. !!BENDER!!",
	[2] = "Hey sexy momma .. Wanna kill all humans..??.",
	[3] = "Would you kindly shut your pie hole?",
		};

local function Drop_Event_On_Death(eventid, creature, killer)
	creature:RemoveEvents()
end

RegisterCreatureEvent(npcid, 4, Drop_Event_On_Death)

local function TimedSay(eventId, delay, repeats, creature)
	yell = math.random(1, #ANN[npcid])
	creature:SendUnitYell(ANN[npcid][yell], 0)
	creature:RemoveEvents()
	creature:RegisterEvent(TimedSay, delay, cycles)
end

local function OnReset(event, creature)
    creature:RegisterEvent(TimedSay, delay, cycles)
end

RegisterCreatureEvent(npcid, 23, OnReset)

function ReloadTalker(event, player, msg) -- select creature and type `load talker`

	 if(restart_msg)then 
	 
		if((msg:lower() == message)and(player:GetGMRank() >= 3))then 

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
