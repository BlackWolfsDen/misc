-- this is a player gossip menu script that allows a player to have a second custom Home_Bind
-- that allows them to update ANYWHERE ....
-- by Grumbo aKa slp13at420 of EmuDevs.com
-- for Unknown96 of EmuDevs.com

local ChatMsg1 = "#Menu";
local ChatMsg2 = "#menu";

local HearthStone = {};
local KEY = "REPLACE INTO `hearthstone` (`guid`,`map`,`x`,`y`,`z`,`o`)VALUES (%s,%s,%s,%s,%s,%s);"; 

local function LoadPlayerLocation(pGuid)

local Q = WorldDBQuery("SELECT * FROM `hearthstone` WHERE `guid`='"..pGuid.."';") -- gathers the data from each row of the sql table

	if(Q)then
		
		HearthStone[Q:GetUInt32(0)] = {
					map = Q:GetUInt32(1),
					x = Q:GetFloat(2),
					y = Q:GetFloat(3),
					z = Q:GetFloat(4),
					o = Q:GetFloat(5),
		};
		return Q:GetUInt32(0),Q:GetUInt32(1),Q:GetFloat(2),Q:GetFloat(3),Q:GetFloat(4),Q:GetFloat(5);	
	end
end

local function UpdateLoc(key,...)

	if(key == 1)then

		local guid,a,b,c,d,e = ...;
		local qs = string.format(KEY,guid,a,b,c,d,e);
		WorldDBQuery(qs);
		HearthStone[guid] = {map = a, x = b, y = c, z = d, o = e,};
	end
end

local function Login(event, player) -- both login types

local guid = player:GetGUIDLow();
local loc = LoadPlayerLocation(guid);
local map,x,y,z,o = player:GetMapId(),player:GetLocation();

 	if not(loc)or(HearthStone[guid].guid)or(HearthStone[guid].map)or(HearthStone[guid].x)or(HearthStone[guid].y)or(HearthStone[guid].z)or(HearthStone[guid].o)then -- to catch null's
 
		UpdateLoc(1,guid,map,x,y,z,o); -- key 1 pushes new entry data to UpdateLoc function
	end
end

local function Logout(event, player) -- normal login

	HearthStone[player:GetGUIDLow()] = {}; -- to drop the players table
end

local function Hello(event, player)
	player:GossipClearMenu();
	player:GossipMenuAddItem(0, "Hearhstone", 0, 1);
	player:GossipSendMenu(1, player, 100);
end

local function OnSelect(event, player, unit, sender, intid, code)

local guid = player:GetGUIDLow();
local map,x,y,z,o = player:GetMapId(),player:GetLocation();


 if(intid == 1)then -- HearthStone sub-menu
 	player:GossipClearMenu();
	player:GossipMenuAddItem(0, "Save my location", 0, 9)  
	player:GossipMenuAddItem(0, "Teleport me", 0, 10)
	player:GossipSendMenu(1, player, 100);
 end
 
	if(intid == 9) then -- stores current coordinates
	
		UpdateLoc(1,guid,map,x,y,z,o); -- key 1 pushes new entry data to UpdateLoc function
		player:GossipComplete();
		player:SendAreaTriggerMessage("Your location has been stored.")
		player:SendBroadcastMessage("Home Bind location updated.")
	end

	if(intid == 10) then -- teleports to stored coordinates
		player:Teleport(HearthStone[guid].map, HearthStone[guid].x, HearthStone[guid].y, HearthStone[guid].z, HearthStone[guid].o)
		player:GossipComplete();
	end
end

local function Chat(event, player, msg, lang, type)

	if(msg == ChatMsg1)or(msg == ChatMsg2)then
	
		Hello(event, player)
	end
end

RegisterPlayerEvent(30, Login) 
RegisterPlayerEvent(3, Login) 
RegisterPlayerEvent(4, Logout) 
RegisterPlayerEvent(18, Chat)
RegisterPlayerGossipEvent(100, 2, OnSelect)
