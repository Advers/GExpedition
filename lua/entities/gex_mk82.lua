AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")

ENT.Spawnable = true
ENT.Model = "models/props_phx/mk-82.mdl"
ENT.MaxHealth = 30
ENT.PrintName = "Mark 82"
ENT.FuseType = "Impact"
ENT.ValidFuses = {"Impact", "Timed"}
ENT.FuseDirection = Vector(1, 0, 0)
ENT.CarryAngles = angle_zero
ENT.Aerodynamic = true
