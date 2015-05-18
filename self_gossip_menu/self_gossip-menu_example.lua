-- script by Unknown96
-- updated to a working Vendor menu
-- this doesnt use World Objects like npc's or objects
-- it uses chat commands.

local command = "#menu";

local T = {
	["Main"] = {
		{0, "Hello There", 0, 1},
		{0, "[Exit Menu]", 0, 2}  
	},
};


local function Hello(event, player)

player:GossipClearMenu();

	for k, v in ipairs(T["Main"]) do

    		player:GossipMenuAddItem(0, v[2], 0, k)
	end
	
player:GossipSendMenu(1, player, 100)
end

local function OnSelect(event, player, _, sernder, intid, code)

	if(intid == 1) then
		player:SendAreaTriggerMessage("Hello there Main & Sub Menu is working!")
	else
		player:SendAreaTriggerMessage("Good Bye Main & Sub Menu is still working!")
	end
player:GossipComplete()
end

local function PlrMenu(event, player, msg, lang, type)

	if(msg == command) then
		Hello(event, player)
	end
end

RegisterPlayerEvent(18, PlrMenu)
RegisterPlayerGossipEvent(100, 2, OnSelect)
