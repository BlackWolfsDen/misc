local MapDenyList = { 1, 123, 475, 875, 180 }; -- here you can deny whole maps
local MapAreaDenyList = { { 1, 1637 }, { 123, 200 }, { 475, 252 }, { 875, 865 }, { 180, 400 } }; -- here you can deny map+area combination
local MapAreaZoneDenyList = { { 1, 2, 658 }, { 123, 200, 4325 }, { 475, 252, 785 }, { 875, 865, 136 }, { 180, 400, 5 } }; -- here you can deny map+area+zone combination

function CheckItemIsAllowed(key, player, data1, data2, data3, item)

	return_type = true;
	
		if ((key - 64) >= 0)then -- Dying/Dead

			key = key - 64;
				
			print("Check if is Dying/Dead.");

			if (player:isDead())then

				player:SendBroadcastMessage("ermm .. your dead...");

				return_type = false;
			end

			if (player:isDying())then
			
				player:SendBroadcastMessage("ermm .. your dying...");

				return_type = false;
			end
		end

		if ((key - 32) >= 0)then -- in Combat

			key = key - 32;
				
			print("Check if in Combat.");

			if (player:IsInCombat())then

				player:SendBroadcastMessage("You are in combat.");

				return_type = false;
			end
		end

		if ((key - 16) >= 0)then -- in Arena
			
			key = key - 16;
			
			print("Check if in an Arena.");

			if (player:InArena())then

				player:SendBroadcastMessage("You are in an arena.");

				return_type = false;
			end
		end
		
		if ((key - 8) >= 0)then -- in BG
			
			key = key - 8;
			
			print("Check if in a battleground.");

			if (player:InBattleground())then

				player:SendBroadcastMessage("You are in a battleground.");

				return_type = false;
			end
		end

		if ((key - 4) >= 0)then

			key = key - 4;
			
			for i = 1, #MapAreaZoneDenyList do

				print("ZONE CHECK:"..MapAreaZoneDenyList[i][3]);

				if (data3 == MapAreaZoneDenyList[i][3])then

					return_type = false; 
				end
			end
		end
		
		if ((key - 2) >= 0)then
		
			key = key - 2;
		
			for i = 1, #MapAreaDenyList do
			
				print("AREA CHECK:"..MapAreaDenyList[i][2]);
				
				if (data2 == MapAreaDenyList[i][2])then
				
					return_type = false; 
					break;
				end
			end
		end
			
		if ((key - 1) >= 0)then
		
			key = key - 1;
			
			for i = 1, #MapDenyList do
				print("MAP CHECK:", MapDenyList[i]);
				
				if (data1 == MapDenyList[i])then
				
					return_type = false; 
					break;
				end;
			end;
		end;
	return return_type;
end;

local function OnLogin(event, player)

	if not(CheckItemIsAllowed(51, player, player:GetMapId(), player:GetAreaId(), NULL))then

		player:SendBroadcastMessage("You are NOT allowed do stuff.");
	end
end

RegisterPlayerEvent(3, OnLogin)