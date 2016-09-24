﻿/*
By @Wise
Tnx Wise :)
This is old at first look but 
TrinityCore Stopped support for there Cataclysm Branch
So it may work fine for what they do have available.
*/

#include "ScriptPCH.h"
#include "Language.h"

#define ICON_ALCHEMY "|TInterface\\icons\\trade_alchemy:30|t"
#define ICON_BLACKSMITHING "|TInterface\\icons\\INV_Ingot_05:30|t"
#define ICON_LEATHERWORKING "|TInterface\\icons\\INV_Misc_LeatherScrap_02:30|t"
#define ICON_TAILORING "|TInterface\\icons\\INV_Fabric_Felcloth_Ebon:30|t"
#define ICON_ENGINEERING "|TInterface\\icons\\inv_misc_wrench_01:30|t"
#define ICON_ENCHANTING "|TInterface\\icons\\trade_engraving:30|t"
#define ICON_JEWELCRAFTING "|TInterface\\icons\\inv_misc_gem_01:30|t"
#define ICON_INSCRIPTION "|TInterface\\icons\\INV_Scroll_08:30|t"
#define ICON_FIRST_AID "|TInterface\\icons\\Spell_Holy_SealOfSacrifice|t"

// not used atm
enum ProfMenus
{
	MAIN_MENU = 0,
	ALCHEMY = 1,
	BLACKSMITHING = 2,
	LEATHERWROKING = 3,
	TAILORING = 4,
	ENGINEERING = 5,
	ENCHANTING = 6,
	JEWELCRAFTING = 7,
	INSCRIPTION = 8,
	FIRST_AID = 9
};

bool PlayerAlreadyHasTwoProfessions(const Player *player) /*const*/
{
	uint32 skillCount = 0;

	if (player->HasSkill(SKILL_MINING))
		skillCount++;
	if (player->HasSkill(SKILL_SKINNING))
		skillCount++;
	if (player->HasSkill(SKILL_HERBALISM))
		skillCount++;

	if (skillCount >= 2)
		return true;

	for (uint32 i = 1; i < sSkillLineStore.GetNumRows(); ++i)
	{
		SkillLineEntry const *SkillInfo = sSkillLineStore.LookupEntry(i);
		if (!SkillInfo)
			continue;

		if (SkillInfo->categoryId == SKILL_CATEGORY_SECONDARY)
			continue;

		if ((SkillInfo->categoryId != SKILL_CATEGORY_PROFESSION) || !SkillInfo->canLink)
			continue;

		const uint32 skillID = SkillInfo->id;
		if (player->HasSkill(skillID))
			skillCount++;

		if (skillCount >= 2)
			return true;
	}
	return false;
}


void LearnSkillRecipesHelper(Player *player, uint32 skill_id)
{
	uint32 classmask = player->getClassMask();

	for (uint32 j = 0; j < sSkillLineAbilityStore.GetNumRows(); ++j)
	{
		SkillLineAbilityEntry const *skillLine = sSkillLineAbilityStore.LookupEntry(j);
		if (!skillLine)
			continue;

		// wrong skill
		if (skillLine->skillId != skill_id)
			continue;

		// not high rank
		if (skillLine->forward_spellid)
			continue;

		// skip racial skills
		if (skillLine->racemask != 0)
			continue;

		// skip wrong class skills
		if (skillLine->classmask && (skillLine->classmask & classmask) == 0)
			continue;

		player->learnSpell(skillLine->spellId, false);
	}
}

bool LearnAllRecipesInProfession(Player *player, SkillType skill)
{
	ChatHandler handler(player->GetSession());
	std::string skill_name;

	SkillLineEntry const *SkillInfo = sSkillLineStore.LookupEntry(skill);
	skill_name, SkillInfo->name[handler.GetSessionDbcLocale()];

	if (!SkillInfo)
	{
		sLog->outError(LOG_FILTER_GENERAL, "Profession NPC: received non-valid skill ID (LearnAllRecipesInProfession)");
		return false;
	}

	LearnSkillRecipesHelper(player, SkillInfo->id);

	uint16 maxLevel = player->GetPureMaxSkillValue(SkillInfo->id);
	player->SetSkill(SkillInfo->id, player->GetSkillStep(SkillInfo->id), maxLevel, maxLevel);
	handler.PSendSysMessage(LANG_COMMAND_LEARN_ALL_RECIPES, skill_name.c_str());
	return true;
}

bool IsSecondarySkill(SkillType skill) /* const */
{
	return skill == SKILL_COOKING || skill == SKILL_FIRST_AID || skill == SKILL_FISHING || skill == SKILL_ARCHAEOLOGY;
}

void CompleteLearnProfession(Player *player, Creature *creature, SkillType skill)
{
	if (PlayerAlreadyHasTwoProfessions(player) && !IsSecondarySkill(skill))
		creature->MonsterWhisper("Вы уже обучили 2 профессии!", player->GetGUID());
	else
		if (!LearnAllRecipesInProfession(player, skill))
			creature->MonsterWhisper("Произошла внутренняя ошибка!", player->GetGUID());
}

class skill_npc : public CreatureScript
{
public: skill_npc() : CreatureScript("skill_npc") {}

		bool OnGossipHello(Player* player, Creature* creature)
		{
			// Primary
			if (!player->HasSkill(SKILL_ALCHEMY))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Alchemy:30|t Алхимия.|r", GOSSIP_SENDER_MAIN, 1);
			if (!player->HasSkill(SKILL_BLACKSMITHING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_BlackSmithing:30|t Кузнечное дело.|r", GOSSIP_SENDER_MAIN, 2);
			if (!player->HasSkill(SKILL_LEATHERWORKING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Misc_ArmorKit_17:30|t Кожевничество.|r", GOSSIP_SENDER_MAIN, 3);
			if (!player->HasSkill(SKILL_TAILORING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Tailoring:30|t Портняжное дело.|r", GOSSIP_SENDER_MAIN, 4);
			if (!player->HasSkill(SKILL_ENGINEERING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Engineering:30|t Инженерное дело.|r", GOSSIP_SENDER_MAIN, 5);
			if (!player->HasSkill(SKILL_ENCHANTING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Engraving:30|t Наложение чар.|r", GOSSIP_SENDER_MAIN, 6);
			if (!player->HasSkill(SKILL_JEWELCRAFTING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Misc_Gem_01:30|t Ювелирное дело.|r", GOSSIP_SENDER_MAIN, 7);
			if (!player->HasSkill(SKILL_INSCRIPTION))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Inscription_Tradeskill01:30|t Начертание.|r", GOSSIP_SENDER_MAIN, 8);
			if (!player->HasSkill(SKILL_HERBALISM))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Spell_Nature_NatureTouchGrow:30|t Травничество.|r", GOSSIP_SENDER_MAIN, 19);
			if (!player->HasSkill(SKILL_MINING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Mining:30|t Горное дело.|r", GOSSIP_SENDER_MAIN, 20);
			if (!player->HasSkill(SKILL_SKINNING))
				player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Misc_Pelt_Wolf_01:30|t Снятие шкур.|r", GOSSIP_SENDER_MAIN, 21);
			// Secondary
			player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/icons/Spell_ChargeNegative:30|t Дополнительные профессии.|r", GOSSIP_SENDER_MAIN, 9);
			player->PlayerTalkClass->SendGossipMenu(907, creature->GetGUID());
			return true;
		}

		bool OnGossipSelect(Player* player, Creature* creature, uint32 uiSender, uint32 uiAction)
		{
			player->PlayerTalkClass->ClearMenus();

			if (uiSender == GOSSIP_SENDER_MAIN)
			{
				switch (uiAction)
				{
				case 0:
					OnGossipHello(player, creature);
					break;

				case 1:
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "|TInterface/icons/Spell_ChargeNegative:30|t Назад.|r", GOSSIP_SENDER_MAIN, 0);
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Alchemy:30|t Алхимия: Мастер трансмутации.|r", GOSSIP_SENDER_MAIN, 10);
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Alchemy:30|t Алхимия: Мастер эликсиров.|r", GOSSIP_SENDER_MAIN, 11);
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Alchemy:30|t Алхимия: Мастер Зелья.|r", GOSSIP_SENDER_MAIN, 12);
					player->PlayerTalkClass->SendGossipMenu(907, creature->GetGUID());
					break;
				case 10:
					CompleteLearnProfession(player, creature, SKILL_ALCHEMY);
					player->removeSpell(28677, false);
					player->removeSpell(28675, false);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 11:
					CompleteLearnProfession(player, creature, SKILL_ALCHEMY);
					player->removeSpell(28672, false);
					player->removeSpell(28675, false);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 12:
					CompleteLearnProfession(player, creature, SKILL_ALCHEMY);
					player->removeSpell(28677, false);
					player->removeSpell(28672, false);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 2:
					CompleteLearnProfession(player, creature, SKILL_BLACKSMITHING);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 3:
					CompleteLearnProfession(player, creature, SKILL_LEATHERWORKING);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 4:
					CompleteLearnProfession(player, creature, SKILL_TAILORING);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 5:
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "|TInterface/icons/Spell_ChargeNegative:30|t Назад!|r", GOSSIP_SENDER_MAIN, 0);
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Engineering:30|t Гномская инженерия.|r", GOSSIP_SENDER_MAIN, 13);
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Engineering:30|t Гоблинская инженерия.|r", GOSSIP_SENDER_MAIN, 14);
					player->PlayerTalkClass->SendGossipMenu(907, creature->GetGUID());
					break;
				case 13:
					CompleteLearnProfession(player, creature, SKILL_ENGINEERING);
					player->removeSpell(20222, false);
					player->removeSpell(82207, false);
					player->removeSpell(105518, false);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 14:
					CompleteLearnProfession(player, creature, SKILL_ENGINEERING);
					player->removeSpell(20219, false);
					player->removeSpell(82207, false);
					player->removeSpell(105518, false);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 6:
					CompleteLearnProfession(player, creature, SKILL_ENCHANTING);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 7:
					CompleteLearnProfession(player, creature, SKILL_JEWELCRAFTING);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 8:
					CompleteLearnProfession(player, creature, SKILL_INSCRIPTION);
					player->CLOSE_GOSSIP_MENU();
					break;

				case 9:
					player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, "|TInterface/icons/Spell_ChargeNegative:30|t Назад!|r", GOSSIP_SENDER_MAIN, 0);
					if (!player->HasSkill(SKILL_FIRST_AID)/* || player->GetClass() == CLASS_DEATH_KNIGHT*/)
						player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Spell_Holy_SealOfSacrifice:30|t Первая помощь.|r", GOSSIP_SENDER_MAIN, 15);
					if (!player->HasSkill(SKILL_FISHING))
						player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/Trade_Fishing:30|t Рыбная ловля.|r", GOSSIP_SENDER_MAIN, 16);
					if (!player->HasSkill(SKILL_COOKING))
						player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Misc_Food_15:30|t Кулинария.|r", GOSSIP_SENDER_MAIN, 17);
					if (!player->HasSkill(SKILL_ARCHAEOLOGY))
						player->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "|TInterface/ICONS/INV_Misc_Food_15:30|t Археология.|r", GOSSIP_SENDER_MAIN, 18);
					player->PlayerTalkClass->SendGossipMenu(907, creature->GetGUID());
					break;
				case 15:
					CompleteLearnProfession(player, creature, SKILL_FIRST_AID);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 16:
					CompleteLearnProfession(player, creature, SKILL_FISHING);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 17:
					CompleteLearnProfession(player, creature, SKILL_COOKING);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 18:
					CompleteLearnProfession(player, creature, SKILL_ARCHAEOLOGY);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 19:
					CompleteLearnProfession(player, creature, SKILL_HERBALISM);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 20:
					CompleteLearnProfession(player, creature, SKILL_MINING);
					player->CLOSE_GOSSIP_MENU();
					break;
				case 21:
					CompleteLearnProfession(player, creature, SKILL_SKINNING);
					player->CLOSE_GOSSIP_MENU();
					break;
				}
			}
			return true;
		}
};

void AddSC_skill_npc()
{
	new skill_npc();
}
