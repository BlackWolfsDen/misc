--[[
Rock, Paper, Scissor Game
Original script made by Billtheslug.
Updated and converted to eluna by ToxicDev.
Version 1.1
modified by slp13at420 to gamble gold.
Version 1.2
]]--

local NPC_ID = 190002
local price = 5 -- in gold. min 1 gold.

function On_Gossip(event, plr, unit)
	if(plr:GetCoinage()>=(price*10000))then
		plr:GossipMenuAddItem(0, "Costs "..price.." Gold.", 0, 0, 0)
		plr:GossipMenuAddItem(0, "I choose Rock.", 0, 1, 0)
		plr:GossipMenuAddItem(0, "I choose Paper.", 0, 2, 0)
		plr:GossipMenuAddItem(0, "I choose Scissors.", 0, 3, 0)
		plr:GossipMenuAddItem(0, "Nevermind, I would not like to take the risk!", 0, 4,0)
		plr:GossipSendMenu(1, unit)
	else
	    plr:SendBroadcastMessage("I require "..price.." gold!")
	end
end

function On_Select(event, plr, unit, arg2, intid)
	if(intid == 0)then
		On_Gossip(event, plr, unit)
		return
		
	elseif(intid == 4)then
		plr:GossipComplete()
		return
		
	else
		plr:ModifyMoney(-(price*10000))
		plr:SendBroadcastMessage("-"..price.."")

		if (intid == 1) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("We both chose rock, we tied!")
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("I chose paper, I win!")
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("I chose scissors, QQ.")
				plr:SendBroadcastMessage("+"..(price*2).."")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
		end
	
		if (intid == 2) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("I chose rock, you win.")
				plr:SendBroadcastMessage("+"..(price*2).."")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("We both chose paper, tie!")
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("I chose scissors and cut through your paper like butter.")
				plr:GossipComplete()
			end
		end
	
		if (intid == 3) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("I chose rock and crushed your puny scissors, I win!")
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("Aww... Your scissors cut through my paper.")
				plr:SendBroadcastMessage("+"..(price*2).."")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("Parry, we tied!!")
				plr:GossipComplete()
			end
		end
	end
end

RegisterCreatureGossipEvent(NPC_ID, 1, On_Gossip)
RegisterCreatureGossipEvent(NPC_ID, 2, On_Select)
