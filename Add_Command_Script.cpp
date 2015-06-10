/*
 * Grumbo`z Guild Warz
 * C++ version for Trinity Core 3.3.5a
 * Created by slp13at420 of EmuDevs.com
 * NOT for Public release...!
 * By Private request of the creator only.
 */

#include "ScriptPCH.h"
#include "Chat.h"
#include <cstring>
#include "GuildMgr.h"
#include "ObjectMgr.h"

class GGW_Commands : public CommandScript
{
public:
	GGW_Commands() : CommandScript("GGW_Commands"){ }

	ChatCommand* GetCommands() const
	{
		static ChatCommand GuildWarzSubCommandTable[] =
		{
			{ "buy", 2, false, GuildWarzBuy, "", NULL },
			{ "sell", 2, false, GuildWarzSell, "", NULL },
			{ "commands", 2, false, GuildWarzCommands, "", NULL },
			{ "info", 2, false, GuildWarzInfo, "", NULL },
			{ NULL, 0, false, NULL, "", NULL }
		};
		static ChatCommand GuildWarzCommandTable[] =
		{
			{ "GGW", 0, true, NULL, "", GuildWarzSubCommandTable },
			{ NULL, 0, false, NULL, "", NULL }
		};
		return GuildWarzCommandTable;

		TC_LOG_INFO("GUILD_WARZ.TEST", ">> LINE %u >>", 36);
		TC_LOG_INFO("GUILD_WARZ.TEST", ">> MEMBER RANK  >>");
	};

	static bool GuildWarzBuy(ChatHandler* handler, const char* args) // Give player 100 gold
	{
		Player* pPlayer = handler->GetSession()->GetPlayer();
		Player* plTarget = pPlayer->GetSelectedPlayer();
		handler->PSendSysMessage("|cffB400B4 BUY");
		return true;
	}

	static bool GuildWarzSell(ChatHandler* handler, const char* args) // Give player 100 gold
	{
		Player* pPlayer = handler->GetSession()->GetPlayer();
		Player* plTarget = pPlayer->GetSelectedPlayer();
		handler->PSendSysMessage("|cffB400B4 SELL");
		return true;
	}

	static bool GuildWarzCommands(ChatHandler* handler, const char* args) // Give player 100 gold
	{
		Player* pPlayer = handler->GetSession()->GetPlayer();
		Player* plTarget = pPlayer->GetSelectedPlayer();
		handler->PSendSysMessage("|cffB400B4 COMMANDS!");
		return true;
	}

	static bool GuildWarzInfo(ChatHandler* handler, const char* args) // Give player 100 gold
	{
		Player* pPlayer = handler->GetSession()->GetPlayer();
		Player* plTarget = pPlayer->GetSelectedPlayer();
		handler->PSendSysMessage("|cffB400B4 INFO");
		return true;
	}
};
void AddSC_GGW_Commands()
{
	new GGW_Commands;
}
