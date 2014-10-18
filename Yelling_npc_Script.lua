-- by Rochet2 of EmuDevs
-- tweeked by slp13at420 of EmuDevs

local npcid = 3100 -- 10000
local delay = 1*10*1000 -- 10 seconds
local cycles = 1

local function Drop_Event_On_Death(eventid, creature, killer)
	creature:RemoveEvents()
end

local function TimedSay(eventId, delay, repeats, creature)
	creature:SendUnitYell("Hey !! Pay attention to me !! BENDER !!", 0)
	creature:RemoveEvents()
	creature:RegisterEvent(TimedSay, delay, cycles)
end

local function OnReset(event, creature)
    creature:RegisterEvent(TimedSay, delay, cycles)
end

RegisterCreatureEvent(npcid, 23, OnReset)

function ReloadTalker(event, player, msg) -- select creature and type `load talker`

local message = "load talker"

	 if(msg)then 
	 
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
