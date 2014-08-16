-- by slp13at420 of EmuDevs.com for Black Wolfs Den's pocket gnome

local npcid = 128
local timer = 90000

local function DespawnPocketGnome(event, delay, cycle, unit)
  unit:RemoveEvents()
  unit:DespawnOrUnsummon()
end

local function DespawnTimer(event, unit)
  local Ctimer = unit:RegisterEvent(DespawnPocketGnome, timer, 1)
end

RegisterCreatureEvent(npcid, 22, DespawnTimer)

print("Pocket Gnome Despawner.")
