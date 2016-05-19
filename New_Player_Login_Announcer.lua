-- © by slp13at420 of EmuDevs.com ©
function New_Char(event, player)
	SendWorldMessage("Everyone Welcome "..player:GetName().." to our Den.", 2)
	player:SendBroadcastMessage("Greetings, every one welcome "..player:GetName().." to the server.")
end

RegisterPlayerEvent(30, New_Char)
