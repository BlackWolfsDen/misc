// By slp13at420 of EmuDevs.com

std::string DB_COLUMN = "reward_count"; // this is the name of the element in auth.account you added to store this value.

void StoreCredit(uint32 id, uint32 count);
{
	LoginDatabase.PExecute("UPDATE account SET `%s` = '%u' WHERE `id` = '%u';", DB_COLUMN.c_str(), count, id);
};

class KillCreatureCredit : public CreatureScript
{
public: KillCreatureCredit() : CreatureScript("KillCreatureCredit"){ }

	struct KillCreatureCredit_AI : public ScriptedAI
	{
		void JustDied(Unit* unit)
		{
			if (unit->ToPlayer())
			{
				StoreCredit(player->GetSession()->GetAccountId(), 2);
			}
		}
	}
	CreatureAI* GetAI(Creature* creature)const override
	{
		return new KillCreatureCredit_AI(creature);
	}
};

void AddSC_KillCreatureRewarder()
{
	new KillCreatureCredit;
}
