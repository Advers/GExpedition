AddCSLuaFile("shared.lua")

include("shared.lua")

DEFINE_BASECLASS("gex_bomb_base")

local newInputs = table.copy(BaseClass.InputNames)

newInputs.Launch = "LAUNCH THE MISSILE NOW!!!"

ENT.InputNames = newInputs