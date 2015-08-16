local npcid = 1000001;

local function Hello(event, player, creature)

	player:GossipClearMenu();
	player:GossipMenuAddItem(5,"ME! Who am I.", 0, 102);
	player:GossipMenuAddItem(5,"Player! Who are you.", 0, 103);
	player:GossipMenuAddItem(5,"?! Who are WE!.", 0, 107);
	player:GossipMenuAddItem(5,"GoodBye!", 0, 137);
 	player:GossipSendMenu(10, creature);

end

local function Responce(event, player, creature, sender, intid, code)

	if(intid == 101)then -- used to return to the main screen.. catch-22
		
		Hello(1, player, creature)
	end
	
	if(intid==102)then

		player:GossipClearMenu();
		player:GossipMenuAddItem(5,"I am "..creature:GetName(), 0, 101);
		player:GossipMenuAddItem(5, "<- Back", 0, 101);
		player:GossipMenuAddItem(5,"GoodBye!", 0, 137);
	 	player:GossipSendMenu(10, creature);
	end
	
	if(intid==103)then

		player:GossipClearMenu();
		player:GossipMenuAddItem(5,"You are "..player:GetName(), 0, 101);
		player:GossipMenuAddItem(5, "<- Back", 0, 101);
		player:GossipMenuAddItem(5,"GoodBye!", 0, 137);
	 	player:GossipSendMenu(10, creature);
	end
	
	if(intid==107)then

		player:GossipClearMenu();
		player:GossipMenuAddItem(5,"I am "..creature:GetName(), 0, 101);
		player:GossipMenuAddItem(5,"You are "..player:GetName(), 0, 101);
		player:GossipMenuAddItem(5, "<- Back", 0, 101);
		player:GossipMenuAddItem(5,"GoodBye!", 0, 137);
	 	player:GossipSendMenu(10, creature);
	end
	
	if(intid==137)then
	
		player:GossipComplete();
	end
end

RegisterCreatureGossipEvent(npcid, 1, Hello) 
RegisterCreatureGossipEvent(npcid, 2, Responce) 
 
