print("+-+-+-+-+-+-+-+-+-+-+-+")
print("+CheaterStone Loading +")
local itemid = nil -- 400582 -- nil
local npcid = nil -- change to your npc id 

local page_per_window = 25 -- how many pages to list per gossip window -- max 30 rows of `blah blah` --
local loc_per_page = 25 -- how many tele points to list per page -- max 30 rows of `blah blah` --
local offset = 10000 -- must be higher than the highest entry in world.game_tele table --

-- DONT EDIT ANYTHING BELOW THIS LINE UNLESS YOU REALLY KNOW WHAT YOU ARE DOING --

local CHEATER = {};
local CHEATSTONE = {};

local Q = WorldDBQuery("SELECT * FROM world.game_tele;");

	if(Q)then
		repeat
			CHEATER[Q:GetUInt32(0)] = {Q:GetString(1),Q:GetString(2),Q:GetString(3),Q:GetString(4),Q:GetUInt32(5),Q:GetString(6)};-- [entry] {x, y, z, o, map, name}
		until not Q:NextRow()
	end

local pages = math.ceil(#CHEATER / loc_per_page)

local function CheaterStoneOnHello(event, player, unit, sender, intid, code)

CHEATSTONE[player:GetGUIDLow()] = {page = 1,};

	if(pages > page_per_window)then
			
		for page=1, page_per_window do
			
			player:GossipMenuAddItem(2, "Page "..page, (offset+page), 0)
				
		end
	
		player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)

	else
		for page=1, pages do
			player:GossipMenuAddItem(2, "Page "..page, (offset+page), 0)
		end
			

	end
player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
player:GossipSendMenu(1, unit)
end

local function back(player, unit)

CHEATSTONE[player:GetGUIDLow()].page = (CHEATSTONE[player:GetGUIDLow()].page - page_per_window)

	for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page+page_per_window do

		if(page <= pages)then
			player:GossipMenuAddItem(2, "Page "..page, (offset+page), 0)

		else
		end
	end

	if(CHEATSTONE[player:GetGUIDLow()].page > page_per_window)then
		player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
	end
	
	player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
	player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
	player:GossipSendMenu(1, unit)
end

local function next(player, unit)

	if(CHEATSTONE[player:GetGUIDLow()].page < pages)then
		CHEATSTONE[player:GetGUIDLow()].page = (CHEATSTONE[player:GetGUIDLow()].page + page_per_window)

		for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page + page_per_window do
			
			if(page <= pages)then
				player:GossipMenuAddItem(2, "Page "..page, (offset+page), 0)
			else
				player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
				player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
				player:GossipSendMenu(1, unit)
				return false;
			end
		end

		player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
		player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
		player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
		player:GossipSendMenu(1, unit)
	end
end

local function returnz(player, unit)

	for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page+page_per_window do

		if(page <= pages)then
			player:GossipMenuAddItem(2, "Page "..page, (offset+page), 0)

		else
		end
	end

	if(CHEATSTONE[player:GetGUIDLow()].page > page_per_window)then
		player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
	end
	
	player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
	player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
	player:GossipSendMenu(1, unit)
end

local function CheaterStoneOnSelect(event, player, unit, sender, intid, code)

	if(sender == (offset+offset+0))then
		back(player, unit)
		return false;
	end
	
	if(sender == (offset+offset+1))then
		next(player, unit)
		return false;
	end
	
	if(sender == (offset+offset+2))then
		player:GossipComplete()
		CHEATSTONE[player:GetGUIDLow()] = {page = nil,};
		return false;
	end
	
	if(sender == (offset+offset+3))then -- return
		returnz(player, unit)
		return false;
	end
	
	if(intid == 0)then
		
		for loc=(((sender-offset)*loc_per_page)-(loc_per_page-1)), ((sender-offset)*loc_per_page) do
	
			if(loc <= #CHEATER)then
				player:GossipMenuAddItem(2, CHEATER[loc][6], loc, loc)
			else
				player:GossipMenuAddItem(1, "<- back", (offset+offset+3), 0)
				player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
				player:GossipSendMenu(1, unit)
				return false;
			end
		end
		
		player:GossipMenuAddItem(1, "<- back", (offset+offset+3), 0)
		player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
		player:GossipSendMenu(1, unit)
	else
	        local x, y, z, o, map,name = table.unpack(CHEATER[intid])
	        player:Teleport(map, x, y, z, o)
		player:GossipComplete()
		CHEATSTONE[player:GetGUIDLow()] = {	page = nil,};
	end			
end

print("+-+-+-+-+-+-+-+-+-+-+-+")

if(itemid ~= nil)then
	RegisterItemGossipEvent(itemid, 1, CheaterStoneOnHello)
	RegisterItemGossipEvent(itemid, 2, CheaterStoneOnSelect)
	print("+    Item active.     +")
else
	print("+      Item nil.      +")
end

if(npcid ~= nil)then
	RegisterCreatureGossipEvent(npcid, 1, TeleportStoneOnHello)
	RegisterCreatureGossipEvent(npcid, 2, TeleporterOnGossipSelect)
	print("+   Creature active.  +")
else
	print("+   Creature nil.     +")
end

print("+-+-+-+-+-+-+-+-+-+-+-+")
print("+ CheaterStone Loaded +")
print("+-+-+-+-+-+-+-+-+-+-+-+")
