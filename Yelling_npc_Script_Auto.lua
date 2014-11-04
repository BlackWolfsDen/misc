-- <A_Work_in_Progress>
-- request by Vitrex
-- Script by Rochet2 of EmuDevs
-- Updated by slp13at420 of EmuDevs -- Stricktly for learning purposes only --
-- drunken slurred outbursts by `Bender the drunken annoying robot`

-- The npc will start once a player is moving close enough to trigger event 27
-- then it will babble non-stop while players are moving or idle near it.
-- then the npc will automaticaly go idle when no players around.

-- I DONT Recommend you use this on Mobs. that could cause lag and freezing of the core.

math.randomseed(os.time());

local npcid = {3100, 3101, 3102}; -- you can apply this to one or multiple npc's here.
local range = 15; -- the distance an idle player can be from the npc to trigger a continuous outburst.
local delay = 1*30*1000; -- 30 seconds time between announcements
local sub_timer = 1*2*1000; -- 2 seconds time between linked announcements
local spawn_duration = 1*10*1000; -- 10 seconds gob/npc despawn timer
local  cGuid = nil;
local ctimer = nil;

local  ANN = {};

-- {Statement, stated, linked, emote, spellid,{spawn type, spawn id},},
-- statement :: in quotes "blah blah" 
-- stated :: say = 0 // yell = 1 
-- linked :: table key id if your using multiple statements  for one announcement i.e.(yell THEN say)
-- emote :: talk = 1 // yell = 5// Question = 6 // Dance = 10 // Rude = 14 // shout = 22 // 
-- spellid :: spell id
-- http://collab.kpsn.org/display/tc/Emote
-- spawn type :: 0 none, 1 npc // 2 gob
-- spawn id :: id of what to spawn

ANN = {-- {"Statement", stated, linked, emote, spellid, {spawn type, spawn id},},
	["Bender"] = {
		[1] = {"Well,, that was dumb.", 0, 0, 1, 58837, {1, 3100}}, -- say, Emote 1, cast spell 58837 on self, spawn npc 3100
		[2] = {"!Bite my shiney metal ass!", 1, 0, 14, 0, {2, 31}}, -- yell, Emote 14, spawn object 31,
		[3] = {"Well,, were boned.", 0, 0, 1, 0, {0, 0}}, -- say, Emote 1
		[4] = {"Hey sexy momma .. Wanna kill all humans..??.", 0, 0, 1, 58837, {0, 0}}, -- say, Emote 1, spell 58837
		[5] = {"Goodbye losers whom I allways hated", 1, 0, 22, 0, {0, 0}}, -- yell, emote 22
		[6] = {"!Shut the hell up!", 1, 0, 5, 0, {0, 0}}, -- yell, emote 5
		[7] = {"Would you kindly shut your noise hole?", 0, 0, 1, 0, {0, 0}}, -- say, emote 1
		[8] = {"I'm gonna go build my own theme park.. with blackjack and hookerz.", 0, 101, 1, 0, {0, 0}}, -- say, emote 1, links to 101
		[9] = {"Who are you and why should i care?", 0, 0, 25, 0, {0, 0}}, -- say, emote 25
		[10] = {"!Shut up and Pay attention To Me !!.. !!BENDER!!", 1, 102, 5, 0, {0, 0}}, -- yell , emote 5
		[11] = {"Hasta La Vista , Meat bag.", 0, 0, 1, 0, {0, 0}},
		[12] = {"Awww, heres a little song i wrote to cheer you up. Its called ", 0, 100, 1, 0, {0, 0}}, -- links to 100
		[13] = {"Do the Bender ,, Do the Bender ,, its your birthday ,, do the bender", 0, 0, 10, 0, {0, 0}},
		[14] = {"Shut up baby , you love it", 0, 0, 1, 58837, {0, 0}}, -- uses spell
		[15] = {"!! REEEEE-MEMM-BERRRR MEEEEEE !!..", 1, 104, 1, 0, {0, 0}}, -- Yell, link to 104
		[16] = {"I'm Back Baby!.", 0, 0, 1, 0, {0, 0}}, -- 
		[17] = {"!Shutup!. I know it.", 0, 0, 1, 0, {0, 0}}, -- 
		[18] = {"!I'm 40 percent Titanium!.", 0, 106, 1, 0, {0, 0}}, -- 
		[19] = {"!I'm 40 percent Zinc!.", 0, 106, 1, 0, {0, 0}}, -- 
		[20] = {"!I'm 40 percent Dolemite!.", 0, 106, 1, 0, {0, 0}}, -- 
		[21] = {"!I'm 30 percent iron!.", 0, 106, 1, 0, {0, 0}}, -- 
		[22] = {"!I'm 40 percent luck!.", 0, 107, 1, 0, {0, 0}}, -- 
		[23] = {"!Neat!.", 0, 0, 1, 0, {0, 0}}, -- 
		[24] = {"Enough of this crap! I'm catching the next pimpmobile outta here! But before I go I have one thing to say ....", 0, 2, 1, 0, {0, 0}}, -- 
		[25] = {"I am Bender ,, Please .. insert .. gerder ..", 0, 0, 1, 0, {0, 0}}, -- 
		[26] = {"No crap, my grandmother was a bulldozer.", 0, 0, 1, 0, {0, 0}}, -- 
		[27] = {"I'll go go build my own lunar lander, with blackjack and hookerz.", 0, 101, 1, 0, {0, 0}}, -- say, emote 1, links to 101
		[28] = {"Bender Bender Bender.", 0, 0, 1, 0, {0, 0}}, -- 
		[29] = {"Hi yawl buddy, it's me, Bender.", 0, 0, 1, 0, {0, 0}}, -- 
		[30] = {"!HEY! ", 1, 109, 1, 0, {0, 0}}, -- 
		[31] = {"!HEY!", 1, 111, 1, 0, {0, 0}}, -- 
		[100] = {"!!Let's go allready!!", 1, 0, 5, 0, {0, 0}}, -- linked from 8
		[101] = {"In fact ,, forget the park.", 0, 0, 1, 0, {0, 0}}, -- linked from 12
		[102] = {".cha .. cha . cha .. cha...", 0, 103, 10, 0, {0, 0}}, -- linked from 10
		[103] = {"..Ok Im bored now...", 0, 0, 1, 0, {0, 0}}, -- linked from 102
		[104] = {"!! REEEEE-MEMM-BERRRR MEEEEEE !!..", 1, 105, 1, 0, {0, 0}}, -- yell, linked from 15, link to 105
		[105] = {"!! REEEEE-MEMM-BERRRR MEEEEEE !!..", 1, 0, 1, 0, {0, 0}}, -- yell, linked from 104
		[106] = {"With a 0.04 percent Nickel impurity.", 0, 0, 1, 0, {0, 0}}, -- yell, linked from 104
		[107] = {"It's because I'm made from recycled horseshoes.", 0, 0, 1, 0, {0, 0}}, -- 
		[108] = {"In fact ,, forget the lunar lander.", 0, 0, 1, 0, {0, 0}}, -- 
		[109] = {"What kind of party is this.?", 0, 110, 1, 0, {0, 0}}, -- 
		[110] = {"!! There's NO booze and only one hooker !!", 1, 0, 1, 0, {0, 0}}, -- 
		[111] = {"Do I preach to you when you're lying in the gutter.?", 0, 112, 1, 0, {0, 0}}, -- 
		[112] = {"!! NO !!", 1, 0, 1, 0, {0, 0}}, -- 
			}};
		
local function Drop_Event_On_Death(eventid, creature, killer) -- removes ALL events upon death of npc. this is here if the npc is attackable.
	cGuid = creatureZ:GetGUIDLow();
	creature:RemoveEvents() -- even in death this will continue to make them say/yell. so force removal of events.
	ANN[cGuid] = {reset = 0, gstime = GetGameTime()}; 
end

local function despawner(eventId, duration, repeats, gob)
	gob:RemoveFromWorld() -- needed since go's dont work right for me with PerformInGameSpawn() `wont despawn by the set time`
end

local function Announce(idX, creatureX, repeats, creatureY)

local creatureZ = nil; -- they gives errors if i dont define them as a local first
local id = nil; -- they wont keep the value stored to them and become nil .... wierd .. but i got it to work smooth this way :D

	if(creatureX)then creatureZ = creatureX; id = idX; end

	if(creatureY)then creatureZ = creatureY; id = ANN["BENDER"][cGuid].link; end	

cGuid = creatureZ:GetGUIDLow();
local bundle = ANN["Bender"][id]

local statement, stated, linked, emote, spellid, spawn_type, spawn_id = table.unpack(bundle)
local spawn_type, spawn_id = table.unpack(bundle[6])

	if(emote ~= (nil or 0))then creatureZ:Emote(emote)end -- check emote column for emote.

	if(stated == 0)then creatureZ:SendUnitSay(statement, 0) else creatureZ:SendUnitYell(statement, 0); end -- check stated column if say else yell.

	if(linked ==(nil or 0))then
		ANN["BENDER"][cGuid] = {link = nil,};
	end

	if(linked > 0)then
		ctimer = creatureZ:RegisterEvent(Announce, sub_timer, 1) -- time to start linking
		ANN["BENDER"][cGuid] = {link = linked,};
	end

	if(spellid ~= (nil or 0))then creatureZ:CastSpell(creature, spellid); end-- check the spellid column for spell id.

	if(spawn_type ~= (nil or 0))then 

		if(spawn_type == 1)then 
			PerformIngameSpawn(spawn_type, spawn_id, creatureZ:GetMapId(), 0, creatureZ:GetX()+2, creatureZ:GetY(), creatureZ:GetZ(), creatureZ:GetO(), 0, spawn_duration, -1) -- perfect
		else
			local gob = PerformIngameSpawn(spawn_type, spawn_id, creatureZ:GetMapId(), 0, creatureZ:GetX()+2, creatureZ:GetY(), creatureZ:GetZ(), creatureZ:GetO(), 0)
			gob:RegisterEvent(despawner, spawn_duration, 1)
		end
	else
	end
ANN[cGuid] = {reset = 1, gstime = GetGameTime()}; 
end

local function TimedSay(eventId, duration, repeats, creature)

ctimer = nil

Announce(math.random(#ANN["Bender"]), creature) -- sends the data to Announce function

	if(#creature:GetPlayersInRange(range) >= 1)then -- (ANN[cGuid].reset == 1)and
		ctimer = creature:RegisterEvent(TimedSay, delay, 1) -- time to annoy those idle players
	end
end

local function OnMotion(event, creature, unit)

cGuid = creature:GetGUIDLow();

	if(unit:GetObjectType()=="Player")then
	
		if((ANN[cGuid] == nil)or(ANN[cGuid].reset == (nil or 0)))then -- j/k flip flip fresh trigger 
			ANN[cGuid] = {reset = 1, gstime = GetGameTime()}; 
			TimedSay(1, delay, 1, creature)
		else

			if(((GetGameTime() - ANN[cGuid].gstime)*1000) > (delay))then
				ANN[cGuid] = {reset = 1, gstime = GetGameTime()}; 
				TimedSay(1, delay, 1, creature)
			end
		end
	end
end

for npc=1, #npcid do

	RegisterCreatureEvent(npcid[npc], 27, OnMotion) 
	RegisterCreatureEvent(npcid[npc], 4, Drop_Event_On_Death)
end
