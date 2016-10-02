local vip = {};
	vip = {
	 ["Buffs"] = {48074,43223,36880,467,48469,48162,23948,24752,16877,10220,13033,11735,10952},
	 ["Etc1"] = {"Etc",},
	 ["Etc2"] = {"Etc",};
	};
	
function retarded(event, player, message, Type, lang)

local k = 0;
local ChatCache = {};

	for word in string.gmatch(msg, "[%w_]+") do
	        k = k+1
	        ChatCache[k] = word;
	end

	if(ChatCache[1] == "vip")then
	
		if(ChatCache[2] == "buff")then
		
			for k, v in ipairs(vip["Buffs"])do
				player:AddAura(v, player);
	
	print("vip[Buffs]["..k.."] = "..vip["Buffs"][k].." = "..v); -- demo of how to use the 'print' command to help test and trouble-shoot
	
			end
			player:SendBroadcastMessage("You've been buffed!");
		end

		if(ChatCache[2] == "repair")then
		-- do stuff;
		end
 	end
 
	local etc1variablestring = "Etc1";
 
print(vip["Etc1"][0]); -- demo calling the stored value @ address '0' of vip["Etc1"].
print(vip["Etc1"][1]); -- demo calling the stored value @ address '1' of vip["Etc1"].
print(vip["Etc1"][2]); -- demo calling the stored value @ address '1' of vip["Etc1"].

	return false;
end
 
 RegisterPlayerEvent(42, retarded)
