-- Simple script that resets both players cooldowns and hp
-- when a duel ends.

local event_id == 11;

local function ResetOnDuelEnd(event, winner, loser, _)

	if(event == event_id)then
		winner:ResetAllCooldowns();
		winner:SetHealth(pWinner:GetMaxHealth());
		
		loser:ResetAllCooldowns();
		loser:SetHealth(pLoser:GetMaxHealth());
	end
end

RegisterPlayerEvent(event_id, ResetOnDuelEnd)
