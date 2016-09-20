/*
© Easy Condidtion Checker © 
A simple function you can use to replace the repetative blocks of code to check if InBG/InArena/InMap/InArea/InZone/IsDead/Dying
now you can just call this function and pick what conditions to check for by using a simple bitmask value :)
Project started : 09/19/2016 © 
Project completion : 09/19/2016 ©

Use example :
bool check = CheckPlayerCriteria(3, player); // bitmask value '3' will check for Dead & Dying.

	if(check)
	{
		do stuff;
	}
*/

#include "Chat.h"
#include "Language.h"
#include "Player.h"
#include "Unit.h"

// map groups
int MapDenyList1[5] = {1 ,123,475 ,875 ,180 };
int MapDenyList2[5] = {2 ,335 ,5433 ,9 ,875 };

// area groups
int AreaDenyList1[5] = { 1 ,123,475 ,875 ,180 };
int AreaDenyList2[5] = { 2 ,335 ,5433 ,9 ,875 };

// zone groups
int ZoneDenyList1[5] = { 1 ,123,475 ,875 ,180 };
int ZoneDenyList2[5] = { 2 ,335 ,5433 ,9 ,875 };

bool CheckPlayerCriteria(uint64 bitmask, Player* player)
{
	// checks if player meets any checks selected via bitmask code.
	// if any conditions are met then the player fails and it returns a false;
	// if none are met then the player passes and a true is returned.
	// un-remark the setting of return_value variable for each check you populate.

	bool return_type = true;

	if ((bitmask - 1024) >= 0) //
	{
		bitmask = bitmask - 1024;

		//	return_type = false;
	}

	if ((bitmask - 512) >= 0) //
	{
		bitmask = bitmask - 512;

		//		return_type = false;
	}

	if ((bitmask - 256) >= 0) //
	{
		bitmask = bitmask - 256;

		//		return_type = false;
	}

	if ((bitmask - 128) >= 0) // Is Game Master
	{
		if (player->IsGameMaster())
		{
			bitmask = bitmask - 128;

			return_type = false;
		}
	}

	if ((bitmask - 64) >= 0) // Is In LFG Dungeon
	{
		if (player->inRandomLfgDungeon())
		{
			bitmask = bitmask - 64;

			return_type = false;
		}
	}

	if ((bitmask - 32) >= 0) // In Instance
	{
		if (player->GetInstanceId() != 0)
		{
			bitmask = bitmask - 32;

			return_type = false;
		}
	}

	if ((bitmask - 16) >= 0) // In Arena
	{
		if (player->InArena())
		{
			bitmask = bitmask - 16;

			return_type = false;
		}
	}

	if ((bitmask - 8) >= 0) // In BattleGround
	{
		if (player->InBattleground())
		{
			bitmask = bitmask - 8;

			return_type = false;
		}
	}

	if ((bitmask - 4) >= 0) // In Combat
	{
		if(player->IsInCombat())
		{
			bitmask = bitmask - 4;

			return_type = false;
		}
	}

	if ((bitmask - 2) >= 0) // Dead
	{
		if (player->isDying())
		{
			bitmask = bitmask - 2;

			return_type = false;
		}
	}

	if ((bitmask - 1) >= 0) // Dying
	{
		if (player->isDead())
		{
			bitmask = bitmask - 1;

			return_type = false;
		}
	}

	return return_type;
}