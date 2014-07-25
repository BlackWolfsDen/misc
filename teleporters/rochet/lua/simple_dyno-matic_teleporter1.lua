--[==[
    = How to add new locations =

    Example:

    The first line will be the main menu ID (Here [1], 
    increment this for each main menu option!),
    the main menu gossip title (Here "Horde Cities"),
    as well as which faction can use the said menu (Here 1 (Horde)). 
    0 = Alliance, 1 = Horde, 2 = Both

    The second line is the name of the main menu's sub menus, 
    separated by name (Here "Orgrimmar") and teleport coordinates
    using Map, X, Y, Z, O (Here 1, 1503, -4415.5, 22, 0)

    [1] = { "Horde Cities", 1,	--  This will be the main menu title, as well as which faction can use the said menu. 0 = Alliance, 1 = Horde, 2 = Both
        {"Orgrimmar", 1, 1503, -4415.5, 22, 0},
    },

    You can copy paste the above into the script and change the values as informed.
]==]

local UnitEntry = 390000

local T = {
    [1] = { "Horde Mall And Locations", 1,
        {"Thunderbluff", 1, -1278, 122, 132, 0},
    },
    [2] = { "Alliance Mall And Locations", 0,
        {"Thunderbluff", 1, -1278, 122, 132, 0},
    },
    [3] = { "OldCruel Zones", 2,
        {"Duel Zone", 1, 1503, -4415.5, 22, 0},
    },
    [4] = { "PvP Locations (FFA)", 2,
        {"Gurubashi Arena", 0, -13229, 226, 33, 1},
        {"Dire Maul Arena", 1, -3669, 1094, 160, 3},
        {"Nagrand Arena", 530, -1983, 6562, 12, 2},
        {"Blade's Edge Arena", 530, 2910, 5976, 2, 4},
    },
    [5] = { "War Zone", 2,
        { "War Zone Entry 1", 1, -6932, -4931.6, 0.7, 1},
        { "War Zone Entry 2", 1, -7076, -4867.4, 0.6, 0},
        { "War Zone Entry 3", 1, -6932, -4931.6, 0.7, 1},
        { "War Zone Entry 4", 1, -6932, -4931.6, 0.7, 1},
    },
}

-- CODE STUFFS! DO NOT EDIT BELOW
-- UNLESS YOU KNOW WHAT YOU'RE DOING!

local function OnGossipHello(event, player, unit)

	if (player:IsInCombat()~=true)then	-- Show main menu
	    
	    for i, v in ipairs(T) do
	        
	        if (v[2] == 2 or v[2] == player:GetTeam()) then
	            player:GossipMenuAddItem(0, v[1], i, 0)
	        end
	    end
	    	player:GossipSendMenu(1, unit)
    else
		player:SendNotification("You are in combat.")
	end
end

local function OnGossipSelect(event, player, unit, sender, intid, code)
    if (sender == 0) then
        -- return to main menu
        OnGossipHello(event, player, unit)
        return
    end

    if (intid == 0) then
        -- Show teleport menu
        for i, v in ipairs(T[sender]) do
            if (i > 2) then
                player:GossipMenuAddItem(0, v[1], sender, i)
            end
		end
	        player:GossipMenuAddItem(7, "Back..", 0, 0)
	        player:GossipSendMenu(1, unit)
        return
    else
        -- teleport
        local name, map, x, y, z, o = table.unpack(T[sender][intid])
        player:Teleport(map, x, y, z, o)
    end
	player:GossipComplete()
end

RegisterCreatureGossipEvent(UnitEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(UnitEntry, 2, OnGossipSelect)
