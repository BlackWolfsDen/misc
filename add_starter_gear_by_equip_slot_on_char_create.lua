startGear = {}
startGear.EquipItems = true
--[[
Head: 0				Finger_1: 10
Neck: 1				Finger_2: 11
Shoulders: 2			Trinket_1: 12
Back: 14			Trinker_2: 13
Chest: 4			Main_Hand: 15
Shirt: 3			Off_Hand: 16
Tabard: 18			Ranged: 17
Wrists: 8			Bags:19-22
Hands: 9
Belt: 5			
Legs: 6				
Feet: 7				
]]
startGear.EquipmentSlots = {0, 1, 2, 14, 4, 3, 18, 8, 9, 5, 6, 7, 10, 11, 12, 13, 15, 16, 17, 19, 20, 21, 22}
	startGear.Class = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
	c = 1
	while (c <= 12) do
		startGear.Class[c] = {}
		c = c + 1
	end
--[[
	Arranged as:
	Head, Neck, Shoulder, Back, Chest, Shirt, Tabard, Wrist, Hands, Belt, Leggins, Feet, 
	Ring1, Ring2, Trinket1, Trinket2, Main_Hand, Off_Hand, Ranged, Bag1, Bag2, Bag3, Bag4
]]
--Warrior
	startGear.Class[1].Items = {}
--Paladin
	startGear.Class[2].Items = {}
--Hunter
	startGear.Class[3].Items = {}
--Rogue
	startGear.Class[4].Items = {}
--Priest
	startGear.Class[5].Items = {}
--Deathknight
	startGear.Class[6].Items = {}
--Shaman
	startGear.Class[7].Items = {}
--Mage
	startGear.Class[8].Items = {}
--Warlock
	startGear.Class[9].Items = {}
--Druid
	startGear.Class[11].Items = {}
--[[
We store items in the Items table, as you might want to have other tables for the specific class, if not
the items could simply be stored in startGear.Class[1] = {} we use the Class[1] as a table.
]]
startGear.HuntersMail = true
startGear.ShamanMail = true
startGear.WarriorsPlate = false
startGear.PaladinPlate = false
--First is mail, second is plate mail.
startGear.ArmorProfiencies = {8737, 750}
function startGear.newstartGear(event, player)
	local i = 1
	local p = 1
	local plrClass = player:GetClass()
	if startGear.EquipItems then
		while (i <=23) do
			local item = player:GetEquippedItemBySlot(i)
			if item then
				player:RemoveItem(item, 1)
			end
			i = i + 1
		end	
	end
	while (p <= 23) do
		if (startGear.Class[plrClass].Items[p] ~= 0 and startGear.Class[plrClass].Items[p] ~= nil) then
			if((plrClass == 3 and startGear.HuntersMail == true) or (plrClass == 7 and startGear.ShamanMail == true)) then
				player:LearnSpell(startGear.ArmorProfiencies[1])
			elseif((plrClass == 1 and startGear.WarriorsPlate == true) or (plrClass == 2 and startGear.PaladinPlate == true)) then
				player:LearnSpell(startGear.ArmorProfiencies[2])
			end
			if startGear.EquipItems then
				player:EquipItem(startGear.Class[plrClass].Items[p], startGear.EquipmentSlots[p])
			else
				player:AddItem(startGear.Class[plrClass].Items[p], 1)
			end
		end
		p = p + 1
	end
end
RegisterPlayerEvent(30, startGear.newstartGear)