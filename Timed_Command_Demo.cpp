/*
By Grumbo aKa slp13at420	of EmuDevs.com
*/
#include "Chat.h"
#include "Language.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Unit.h"

struct TimerElements
{
	uint64 kick_time;
};

std::unordered_map<uint32, TimerElements>VIPCommandTimers;

// global variables
uint32 VIPKickCommandcooldown = 30; // in seconds // i would make an entry in the world conf file for ease of change

std::string Convert_seconds_To_String(uint64 value)
{
	std::string TimeString = secsToTimeString(uint64(value), true);

	return TimeString;
}

void UpdateTimer(std::string timer_name, uint64 new_time, uint32 accountid)
{
	LoginDatabase.PExecute("UPDATE `account_access` SET `%s` = '%d' WHERE `id` = '%d';", timer_name.c_str(), new_time, accountid);
}

class timed_VIP_command_Player_Login : public PlayerScript
{
public:
	timed_VIP_command_Player_Login() : PlayerScript("timed_VIP_command_Player_Login") { }

	virtual void OnLogout(Player* player)
	{
		uint32 accountId = player->GetSession()->GetAccountId();

		VIPCommandTimers.erase(accountId); // erase the players table to free up ram.
	} // On Logout

	virtual void OnLogin(Player* player, bool /*firstLogin*/) // load the value once at login to avoid crashes of stacked queries
	{
		uint32 accountId = player->GetSession()->GetAccountId();

		QueryResult timer_result = LoginDatabase.PQuery("SELECT `KickCooldown` FROM `auth`.`account_access` where `id` = %u;", accountId);

		if (timer_result)
		{
			Field* fields = timer_result->Fetch();
			uint64 kick_time = fields[0].GetUInt64();

			TimerElements& kicktimerdata = VIPCommandTimers[accountId];
			// Save the values to the Data object. Build the players unordered_map table.
			kicktimerdata.kick_time = kick_time;
		}
	} // On Login
};


class timed_VIP_commands : public CommandScript
{
public:
	timed_VIP_commands() : CommandScript("timed_VIP_commands") { }

	std::vector<ChatCommand> GetCommands() const
	{
		static std::vector<ChatCommand> VIPNpcCommandTable =
		{
			{ "info", rbac::RBAC_IN_GRANTED_LIST, true, &HandleVIPNpcInfoCommand, "" },
		};

		static std::vector<ChatCommand> VIPcommandTable =
		{
			{ "kick", rbac::RBAC_IN_GRANTED_LIST, true, &HandleVIPKickPlayerCommand, "" },
			{ "npc", rbac::RBAC_IN_GRANTED_LIST, false, nullptr, "", VIPNpcCommandTable },
		};

		static std::vector<ChatCommand> commandTable =
		{
			{ "vip", rbac::RBAC_IN_GRANTED_LIST, false, nullptr, "", VIPcommandTable },
		};
		return commandTable;
	}

	static bool HandleVIPKickPlayerCommand(ChatHandler* handler, char const* args)
	{
		uint32 accountId = handler->GetSession()->GetAccountId();
		uint64 current_time = sWorld->GetGameTime();
		uint64 Timer_Expire_Time = (VIPCommandTimers[accountId].kick_time + VIPKickCommandcooldown);

		if (Timer_Expire_Time > current_time)
		{
			// This result means he has a cooldown

			std::string Time_In_String = Convert_seconds_To_String(Timer_Expire_Time - current_time);

			handler->PSendSysMessage("Remaining Cooldown:%s", Time_In_String.c_str());
		}
		else
		{
			// This result means no cooldown left so return true

			Player* target = NULL;
			std::string playerName;
			if (!handler->extractPlayerTarget((char*)args, &target, NULL, &playerName))
				return false;

			if (handler->GetSession() && target == handler->GetSession()->GetPlayer())
			{
				handler->SendSysMessage(LANG_COMMAND_KICKSELF);
				handler->SetSentErrorMessage(true);
				return false;
			}

			// check online security
			if (handler->HasLowerSecurity(target, ObjectGuid::Empty))
				return false;

			std::string kickReasonStr = handler->GetTrinityString(LANG_NO_REASON);
	
			if (*args != '\0')
			{
				char const* kickReason = strtok(NULL, "\r");
				if (kickReason != NULL)
					kickReasonStr = kickReason;
			}

			if (sWorld->getBoolConfig(CONFIG_SHOW_KICK_IN_WORLD))
				sWorld->SendWorldText(LANG_COMMAND_KICKMESSAGE_WORLD, (handler->GetSession() ? handler->GetSession()->GetPlayerName().c_str() : "Server"), playerName.c_str(), kickReasonStr.c_str());
			else
			{
				handler->PSendSysMessage(LANG_COMMAND_KICKMESSAGE, playerName.c_str());

				target->GetSession()->KickPlayer();

				handler->PSendSysMessage("VIP Kick command Cooldown initated.");

				VIPCommandTimers[accountId].kick_time = current_time;

				UpdateTimer("KickCooldown", current_time, accountId);
			}
		}
		return true;
	}

	static bool HandleVIPNpcInfoCommand(ChatHandler* handler, const char* args)
	{
		Player* player = handler->GetSession()->GetPlayer();
		Creature* target = handler->getSelectedCreature();

			if (target)
			{
				uint64 TtlRespawnDelay = target->GetRespawnDelay();
				int64 curRespawnDelay = target->GetRespawnTimeEx() - time(NULL);

				if (curRespawnDelay < 0)
					curRespawnDelay = 0;

				std::string defRespawnDelayStr = secsToTimeString(TtlRespawnDelay, false);
				std::string curRespawnDelayStr = secsToTimeString(uint64(curRespawnDelay), false);

				handler->PSendSysMessage("Creature info:");
				handler->PSendSysMessage("____________");
				handler->PSendSysMessage(LANG_COMMAND_RAWPAWNTIMES, defRespawnDelayStr.c_str(), curRespawnDelayStr.c_str());
			}
		
		return true;
	}
};

void AddSC_timed_command_Demo()
{
	new timed_VIP_command_Player_Login;
	new timed_VIP_commands;
}
