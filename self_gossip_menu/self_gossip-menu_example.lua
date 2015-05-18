local NPC_ID = 90004;
local command = "#menu";

local T = {
  ["Main"] = {
  {0, "Hello There", 0, 1},
  {0, "[Exit Menu]", 0, 2}  
 },
};


local function Hello(event, player)
  player:GossipClearMenu()
  for k, v in ipairs(T["Main"]) do
 print(k,v,":",v[2]);
    player:GossipMenuAddItem(0, v[2], 0, k)
  end
  player:GossipSendMenu(1, player, 100)
end

local function OnSelect(event, player, _, sernder, intid, code)
 if(intid == 1) then
   player:SendAreaTriggerMessage("Main & Sub Menu is working!")
 else
   player:SendAreaTriggerMessage("Main & Sub Menu is still working!")
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


print("TEST PROFFESSION TRAINER LOADED.")
