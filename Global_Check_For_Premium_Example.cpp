#include "chat.h"
#include "Config.h"
#include "math.h"
#include "player.h"
#include "RBAC.h"
#include "ScriptMgr.h"
#include "World.h"

/*
* Main command class.
*/
class PremCommand
{
public:
	PremCommand(const char* _info) : info(_info) { }

	void handleHelpCommand(ChatHandler* handler)
	{
		handler->PSendSysMessage(info);
	}

	virtual void handleCommand(ChatHandler* handler, Player* player) = 0;
private:
	const char* info;
};
/*
* Sub command class(es).
*/
class DrinkCommand : public PremCommand
{
public:
	DrinkCommand(const char* _info) : PremCommand(_info) { }

	void handleCommand(ChatHandler* handler, Player* player)
	{
		uint8 drink = player->GetDrunkValue();
		player->SetDrunkValue(drink + 5);
		handler->PSendSysMessage("!Down the hatch!");
	}
};

class DrunkCommand : public PremCommand
{
public:
	DrunkCommand(const char* _info) : PremCommand(_info) { }

	void handleCommand(ChatHandler* handler, Player* player)
	{
		player->SetDrunkValue(100);
		handler->PSendSysMessage("!You drunk!");
	}
};

class SoberCommand : public PremCommand
{
public:
	SoberCommand(const char* _info) : PremCommand(_info) { }

	void handleCommand(ChatHandler* handler, Player* player)
	{
		player->SetDrunkValue(1);
		handler->PSendSysMessage("You're now sober..");
	}
};

std::map<std::string, PremCommand*> command_map;

class Premium_Commands : public CommandScript
{
public:
	Premium_Commands() : CommandScript("Premium_Commands")
	{
		// Setting up the commands.
		if (command_map.empty())
		{
			command_map["drink"] = new DrinkCommand("Allows the player to increase +5 to drunk.");
			command_map["drunk"] = new DrunkCommand("Allows the player become 100 drunk.");
			command_map["sober"] = new SoberCommand("Allows the player to become sober.");
		}
	}

	std::vector<ChatCommand> GetCommands() const
	{
		static std::vector<ChatCommand> commandTable =
		{
			{ "premium", rbac::RBAC_IN_GRANTED_LIST, true, &handlePremiumCommand, "Premium custom commands." },
		};
		return commandTable;
	}
	/*
	* Main command handler. This will be executed, before any of the sub command handlers.
	* It uses polymorphism to map the commands.
	*/
	static bool handlePremiumCommand(ChatHandler* handler, const char* args)
	{
		Player* player = handler->GetSession()->GetPlayer();

			if (PREM::IsPlayerPremium(player))
				return_type = true;
			else
				return false;

		std::vector<char*> arguments = getArguments(args);
		if (arguments.size() == 0)
			return false;

		std::string command = arguments[0];
		arguments.erase(arguments.begin());

		PremCommand* commandHandler = command_map[command];
		if (commandHandler == NULL)
			return false;

		commandHandler->handleCommand(handler, player);

		return true;
	}

private:
	/*
	* Method to convert the argument string to a vector.
	*/
	static std::vector<char*> getArguments(const char* args)
	{
		std::vector<char*> arguments;
		// Extracting the arguments and push them to the vector.
		char* arg = strtok((char*)args, " ");
		while (arg != NULL)
		{
			arguments.push_back(arg);
			arg = strtok((char*)NULL, " ");
		}
		return arguments;
	}
};

void AddSC_Premium_System()
{
	new Premium_Commands;
}
