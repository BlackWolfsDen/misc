-- Script made by Zadax
-- adapted to Eluna by slp13at420

print "Loading WarGlaives Fun Script."

local function WarGlaives (event, player, item)
	if((item:GetEntry()==18583)or(item:GetEntry()==18584))then
		player:SendNotification("The WarGlaives are so manly you instantly grew a moustache.")
	end
end

RegisterPlayerEvent(29, WarGlaives)