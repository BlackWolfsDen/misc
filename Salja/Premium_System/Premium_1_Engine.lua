-- a simple little system with a lot of potential
-- Premium System by Salja of emudevs.com
-- updated by slp13at420 of emudevs.com
-- NOTE: need to insert character_premium.sql in your auth.account database.table
-- just add 1 column to your auth.account table:
-- name `premium` : Datatype = TINYINT : Length/Set = 1 : Unsigned = checked : Default = 0
-- then just add the npc vendor to your world.creature_template table.
-- for TrintyCore2 3.3.5 Eluna
local npcid = 101

BUFFS = {};
PREM = {};

local BUFFS = {48074,43223,36880,467,48469,48162,23948,24752,16877,10220,13033,11735,10952};

PREM["SERVER"] = {
    vendor_id = npcid
};

print ("Salja's Premium System Table: initialized and allocated.")

local function PremiumOnLogin(event, player)  -- Send a welcome massage to player and tell him is premium or not

local Q = WorldDBQuery("SELECT username, premium FROM auth.account WHERE `id` = '"..player:GetAccountId().."';"); -- this would need to be changed for your Premium value location.

PREM[player:GetAccountId()] = {
	Name = Q:GetString(0),
	Premium = Q:GetUInt32(1)
};
			
	if(PREM[player:GetAccountId()].Premium==1)then
		player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Welcome "..player:GetName().." you are Premium.|r")
	else
		player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Welcome "..player:GetName()..".|r")
		player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E You can donate to earn the Premium Rank.|r")
    end
    print(PREM[player:GetAccountId()].Name.." :Premium table loaded.")
end

RegisterPlayerEvent(3, PremiumOnLogin) 

local function UnSummonPremiumVendor(eventid, timer, player, creature)
	creature:DespawnOrUnsummon(0)
	WorldDBQuery("DELETE FROM world.creature WHERE `guid` = '"..creature:GetGUIDLow().."';") 
end

local function SummonPremiumVendor(player)
	if(PREM[player:GetAccountId()].Premium==1)then
		PerformIngameSpawn(1, PREM["SERVER"].vendor_id, player:GetMapId(), 0, player:GetX(), player:GetY(), player:GetZ(), player:GetO(), 0, 90000, 1)
	end
end

local function PremiumOnChat(event, player, msg, _, lang)
	if (msg == "#premium") then  -- Use #premium for sending the gossip menu
		if(PREM[player:GetAccountId()].Premium==1)then
            OnPremiumHello(event, player)
        else
            player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Sorry "..player:GetName().." you dont have the Premium rank. |r")
            player:SendBroadcastMessage("|CFFE55BB0[Premium]|r|CFFFE8A0E Please consider donating for the rank. |r")
        end
    end
end

function OnPremiumHello(event, player)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0, "Show Bank.", 0, 2)
	player:GossipMenuAddItem(0, "Show AuctionsHouse.", 0, 3)
	player:GossipMenuAddItem(0, "Summon the Premium Vendor.", 0, 4)
	player:GossipMenuAddItem(0, "Buff me.", 0, 5)
	player:GossipMenuAddItem(0, "Repair my items.", 0, 6)
	player:GossipMenuAddItem(0, "Reset my Talents.", 0, 7)
	player:GossipMenuAddItem(0, "Nevermind..", 0, 1)
	player:GossipSendMenu(1, player, 100)
end

function OnPremiumSelect(event, player, unit, sender, intid, code)
	
	if(intid==1) then -- Close the Gossip
        end
 	if(intid==2) then -- Send Bank Window
        	player:SendShowBank(player)
        end
	if(intid==3) then -- Send Auctions Window
        	player:SendAuctionMenu(player)
        end
	if(intid==4)then -- summon the Premium Vendor
		SummonPremiumVendor(player)
	end
	if(intid==5)then -- buff  me
		for _, v in ipairs(BUFFS)do
			player:AddAura(v, player)
		end
	end
	if (intid==6) then -- Repair all items 100%
		player:DurabilityRepairAll(100,100)
	end
	if (intid==7) then -- Reset talent points. Salja's idea.
		player:ResetTalents()
		player:SendBroadcastMessage("|cff00cc00All your talents are reset!|r")
	end
	if(intid > 7) then -- Go back to main menu
		player:GossipComplete()
		OnPremiumHello(event, player)
	end
player:GossipComplete()
end

RegisterPlayerEvent(18, PremiumOnChat)              -- Register Evenet on Chat Command use
RegisterPlayerGossipEvent(100, 2, OnPremiumSelect)  -- Register Event for Gossip Select

local function PremiumVendorHello(eventid, player, creature)
	if(PREM[player:GetAccountId()].Premium==1)then
		player:GossipClearMenu()
		player:GossipMenuAddItem(1, "Armor.", 0, 1012)
		player:GossipMenuAddItem(1, "Weapons.", 0, 1013)
		player:GossipMenuAddItem(1, "Misc Premium items.", 0, 1014)
		player:GossipMenuAddItem(2, "Nevermind..", 0, 1011)
		player:GossipSendMenu(1, creature)
		creature:RegisterEvent(UnSummonPremiumVendor, 90000, 1, player, creature)
	else
		creature:RegisterEvent(UnSummonPremiumVendor, 1, 1, player, creature)
	end
end

local function PremiumVendorSelect(event, player, creature, sender, intid, code)	
VendorRemoveAllItems(101)
	if(intid==1011) then
		creature:RegisterEvent(UnSummonPremiumVendor, 1, 1, player, creature)
	end
    if(intid==1012)then
    	AddVendorItem(PREM["SERVER"].vendor_id, 17,1,1,0)
    	player:SendVendorWindow(creature)
	end
    if(intid==1013)then
    	AddVendorItem(PREM["SERVER"].vendor_id, 25,1,1,0)
    	player:SendVendorWindow(creature)
	end
    if(intid==1014)then
    	AddVendorItem(PREM["SERVER"].vendor_id, 38,1,1,0)
    	player:SendVendorWindow(creature)
    end
player:GossipComplete()
end

RegisterCreatureGossipEvent(PREM["SERVER"].vendor_id, 1, PremiumVendorHello)
RegisterCreatureGossipEvent(PREM["SERVER"].vendor_id, 2, PremiumVendorSelect)
