// This block belongs at the start of the script with the rest
// FROM HERE //
Struct VIPTimerElements
{
	uint64 test_time;
};

uint64 VIPTest_Cooldown = 30; // seconds // make this just a local variable for the function or make it a global variable that can be called from any script.
// TO HERE //

// This block belongs inside a PlayerScript OnLogin function
// FROM HERE //
QueryResult timer_result = LoginDatabase.PQuery("SELECT `KickCooldown` FROM `auth`.`account_access` where `id`=%u;", account_id);
if (timer_result)
{
	Field* field = timer_result->Fetch();
	uint32 test_time = field[0].GetUInt64(); // Value in the DB (Currently what they have)

	VIPTimerElements& timers_data = VipTimers[account_id];
	// Save the DB values to the MyData object
	timers_data.test_time = test_time;
}
// To HERE //

// A stand alone function to cutdown on lines dont need the same code over n over for timers. just make 1 and key it :)
bool CheckTimer(uint8 timer_id, ChatHandler* handler)
{
	uint32 account_id = handler->GetSession()->GetAccountId();

	uint64 current_test_time = sWorld->GetGameTime(); // seconds

	if (timer_id == 1)
	{
		if ((current_test_time < (VipTimers[account_id].test_time + VIPTest_Cooldown))) // (VipTimers[account_id].test_time == 0) || 
		{
			// This result means he has a cooldown so return false

			return false;
		}
		else
		{
			// This result means no cooldown left so return true

			LoginDatabase.PExecute("UPDATE `account_access` SET `KickCooldown` = '%d' WHERE `id` = '%d';", VipTimers[account_id].test_time, account_id);
			return true;
		}
	}
}

// using the standalone checker inside a command block
static bool HandleVIPTestCommand(ChatHandler* handler, const char* args)
{

	if (CheckTimer(1, handler))
	{
		// do stuff
	}
}

