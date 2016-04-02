// By slp13at420 of EmuDevs.com

#include "AccountMgr.h"
#include "chat.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "WorldSession.h"

uint32 reward_value = 2;

std::string DB_COLUMN = "reward_count"; // this is the name of the element in auth.account you added to store this value. use default '0' so it wont need another block for OnAccountCreation.

std::unordered_map<uint32, uint32>CKR;

class KillCreatureCredit : public PlayerScript
{
public: KillCreatureCredit() : PlayerScript("KillCreatureCredit"){ }

		virtual void OnLogout(Player* player)
		{
			uint32 accountId = player->GetSession()->GetAccountId();

			LoginDatabase.PExecute("UPDATE `account` SET `%s` = '%u' WHERE `id` = '%u';", DB_COLUMN.c_str(), CKR[accountId], accountId);

			CKR.erase(accountId);
		};

		virtual void OnLogin(Player* player, bool /*firstLogin*/)
		{
			uint32 accountId = player->GetSession()->GetAccountId();
			
			QueryResult CKRPlayerQery = LoginDatabase.PQuery("SELECT `%s` FROM `account` WHERE `id` = '%u';", DB_COLUMN.c_str(), accountId);

			if (CKRPlayerQery)
			{
				do
				{
					Field* fields = CKRPlayerQery->Fetch();
					uint32 Reward_Count = fields[0].GetUInt32();

					CKR[accountId] = Reward_Count;

				} while (CKRPlayerQery->NextRow());
			}
		};
		
		void OnCreatureKill(Player* player, Creature* killed) override
		{
			uint32 accountId = player->GetSession()->GetAccountId();

			CKR[accountId] = CKR[accountId] + reward_value;

			ChatHandler(player->GetSession()).PSendSysMessage("You earned %u rewards for a total of %u points.", reward_value, CKR[accountId]);
		};
};

void AddSC_KillCreatureRewarder()
{
	new KillCreatureCredit;
}
