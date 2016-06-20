/*
a simple chat system with an adjustable prefix. default`.chat`.
with adjustable color layout and adjustable channel name.
made by slp13at420 of EmuDevs.com
*/

#include "AchievementMgr.h"
#include "Player.h"
#include "ScriptMgr.h"

struct QuestElements
{
	uint32 quest_id;
	uint32 achievement_id;
};

struct PlayerQuestElements
{
	Quest* quest;
	uint32 quest_id;
	uint32 achievement_id;
};

std::unordered_map<uint32, QuestElements>QuestList;

uint32 PLAYER_ACHIEVEMENT_CHECK_TIMER = 1000;

class LoadAcheviementsRequired : public WorldScript
{
	public: LoadAcheviementsRequired() : WorldScript("LoadAcheviementsRequired"){ };

		void OnConfigLoad(bool /*reload*/)
		{
			QueryResult QuestQery = WorldDatabase.Query("SELECT ID, achievement_id FROM quest_template WHERE achievement_required > '0';");

			if (QuestQery)
			{
				do
				{
					Field* fields = QuestQery->Fetch();
					uint32 quest_id = fields[0].GetUInt32();
					uint32 achievement_id = fields[1].GetUInt32();

					QuestElements& data = QuestList[quest_id];
					// Save the DB values to the MyData object
					data.quest_id = quest_id;
					data.achievement_id = achievement_id;

					TC_LOG_INFO("server.loading", "LOAD QUEST:%u", quest_id);

				} while (QuestQery->NextRow());
			}
		}
};

void AchievementCheck(Player* player)
{
	for (std::unordered_map<uint32, QuestElements>::iterator itr = QuestList.begin(); itr != QuestList.end(); itr++)
	{
		uint32 quest_id = itr->first;
		uint32 achievement_id = QuestList[quest_id].achievement_id;

			if(player->HasAchieved(achievement_id))
			{
				// Quest Status 0 = QUEST_STATUS_NONE : 1 = QUEST_STATUS_COMPLETE : 2 = QUEST_STATUS_UNAVAILABLE : 3 = QUEST_STATUS_INCOMPLETE : 4 = QUEST_STATUS_AVAILABLE : 5 = QUEST_STATUS_FAILED : 

					if ((player->GetQuestStatus(quest_id) == 1) || (player->GetQuestStatus(quest_id) == 3) || (player->GetQuestStatus(quest_id) == 4))
					{
						player->CompleteQuest(quest_id);
					}
			}
	}
};

class AchievementCheckTimer : public BasicEvent
{
public:
	AchievementCheckTimer(Player* _player) : player(_player)
	{
		_player->m_Events.AddEvent(this, _player->m_Events.CalculateTime(PLAYER_ACHIEVEMENT_CHECK_TIMER)); // 1000 = 1 second  // 60000 = 1 minute
	}

	bool Execute(uint64, uint32) override
	{
		AchievementCheck(player);

		new AchievementCheckTimer(player);

		return true;
	}
	Player* player;
};

class Player_Check_Criteria : public PlayerScript
{
public: Player_Check_Criteria() : PlayerScript("Player_Check_Criteria"){ }

		void OnLogin(Player* player, bool /*firstLogin*/)
		{
			new AchievementCheckTimer(player);
		}

		virtual void OnQuestStatusChange(Player* player, uint32 questId, QuestStatus status) 
		{
		}

};

class Check_Criteria : public AchievementCriteriaScript
{
public: Check_Criteria() : AchievementCriteriaScript("Check_Criteria"){ }

		bool OnCheck(Player* source, Unit* target) override
		{
			TC_LOG_INFO("server.loading", "ACHIEVEMENT_CRITERIA-ON_CHECK");
			return true;
		}
};

void AddSC_Player_Check_Criteria()
{
	new LoadAcheviementsRequired;
	new Player_Check_Criteria;
	new Check_Criteria;
}
