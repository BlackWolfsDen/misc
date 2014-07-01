-- By Rochet2 
-- lightly touched up by slp13at420
-- a dynamic tabled loopy thingy vendor what'sa mah-hooy.!! ITS Another THing-a-mah-jigger !!
-- a simple, easy to edit starter gear vendor with class icons. just change or add item ids to each class table key.
-- See class id values here:
-- http://collab.kpsn.org/display/tc/ChrClasses.dbc+tc2
local npcid = 100029
local T = {
--  [classId] = {item1, item2, item3m, ...},
    [1] = {4080, 13955, 23087, 1154, 10740, 14621, 23577, 10835, 19031}, -- Warrior
    [2] = {14806, 2575, 8312, 23663, 8318, 8316, 4072, 3198}, -- Paladin
    [3] = {21157, 14289, 20654}, -- Hunter
    [4] = {10261, 10056, 6526, 6594, 5963, 10257, 12522, 21697, 15289}, -- Rogue
    [5] = {10261}, -- Priest
    [6] = {10261}, -- Death Knight
    [7] = {10261}, -- Shaman
    [8] = {10261}, -- Mage
    [9] = {10261}, -- Warlock
    [11] = {10261}, -- Druid
};

local function OnGossipHello(event, player, creature)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_Sword_27.png:20|t Gear PVE - Warrior", 0, 1)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/Spell_Holy_DivineIntervention.png:20|t Gear PVE - Paladin", 0, 2)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_Weapon_Bow_07.png:20|t Gear PVE - Hunter", 0, 3)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_ThrowingKnife_04.png:20|t Gear PVE - Rogue", 0, 4)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_Staff_30.png:20|t Gear PVE - Priest", 0, 5)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/Spell_Deathknight_ClassIcon.png:20|t Gear PVE - Death Knight", 0, 6)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/Spell_Nature_BloodLust.png:20|t Gear PVE - Shaman", 0, 7)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_Staff_13.png:20|t Gear PVE - Mage", 0, 8)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/Spell_Nature_Drowsy.png:20|t Gear PVE - Warlock", 0, 9)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/INV_Misc_MonsterClaw_04.png:20|t Gear PVE - Druid", 0, 11)
	player:GossipSendMenu(1, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code)
local class = player:GetClass()
    if (intid == class) then
        -- Selected the option for his own class, add items
        for _,v in ipairs(T[class]) do
            player:AddItem(v, 1)
        end
    else
        player:SendNotification("That is not for your class.")
        OnGossipHello(event, player, creature)
    end
player:GossipComplete()
end

RegisterCreatureGossipEvent(npcid, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcid, 2, OnGossipSelect)
