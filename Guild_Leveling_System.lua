-- Guild Level new/missed guild Work-around . requires Eluna since TC cant get its head outta its ass
-- And Eluna events seem to fire consistantly
-- hey you wanted a fix so either wait, or use Eluna.  --?GOT ELUNA?--
-- just add to your scripts folder and restart . any newly created guild created will get added to the sql table.
-- or a if a player logs in belonging to a guild not yet added. then this will add it.
GuildLevel = {};

local function LoadGL()
local Gld = WorldDBQuery("SELECT guildname, guildid, leaderguid, level, xp FROM characters1.guild_level;")
	if(Gld)then
		repeat
			GuildLevel[Gld:GetUInt32(1)] = {
					guildid = Gld:GetUInt32(1),
					guildname = Gld:GetString(0),
					leaderguid = Gld:GetUInt32(2),
					level = Gld:GetUInt32(3),
					xp = Gld:GetUInt32(4)					
							};
		until not Gld:NextRow()
	end
end
LoadGL()

function GLupdate(key, ...)
	local Query = {
		[1] = "UPDATE characters.guild_level SET `%s` = '%s' WHERE `guildid` = '%s';"
				};
	if(key == 1) then
		local subtable, value, id = ...
		local qs = string.format(Query[key], ...)
		WorldDBQuery(qs)
		GuildLevel[id] = {
				[subtable] = value
						};
--		print(GuildLevel[id][subtable])
	end
end

function Newguild(_, guildid, leader, guildname)
	WorldDBQuery("INSERT INTO characters1.guild_level SET `guildid` = '"..player:GetGuildId().."';");
	GLupdate(1, "guildname", player:GetGuildName(), player:GetGuildId())
	GLupdate(1, "leaderguid", player:GetGuild():GetLeaderGUID(), player:GetGuildId())
	GLupdate(1, "level", 1, player:GetGuildId())
	GLupdate(1, "xp", 0, player:GetGuildId())
end

RegisterGuildEvent(5, Newguild)

function GuildLevel_Add(eventid, player)
	if(player:GetGuildId()~=nil)then
		if(GuildLevel[player:GetGuildId()]==nil)then
			WorldDBQuery("INSERT INTO characters1.guild_level SET `guildid` = '"..player:GetGuildId().."';");
			GLupdate(1, "guildname", player:GetGuildName(), player:GetGuildId())
			GLupdate(1, "leaderguid", player:GetGuild():GetLeaderGUID(), player:GetGuildId())
			GLupdate(1, "level", 1, player:GetGuildId())
			GLupdate(1, "xp", 0, player:GetGuildId())
		end
	end
end

RegisterPlayerEvent(3, GuildLevel_Add)
