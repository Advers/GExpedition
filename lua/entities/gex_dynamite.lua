AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")
ENT.Class = "gex_dynamite"

ENT.Spawnable = true
ENT.Model = "models/props_junk/flare.mdl"
ENT.MaxHealth = 15
ENT.Name = "Dynamite"
ENT.PrintName = "Dynamite"
ENT.Volatile = true --makes it detonate even if it isn't armed.

if not SERVER then return end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SetMaterial("models/props_debris/plasterwall039c")
	self:SetColor(Color(255, 90, 90))
end

function ENT:Arm()
	self.BaseClass.Arm(self)
	self.fuseSound = self:StartLoopingSound("weapons/flaregun/burn.wav")
	self.detonateTime = CurTime() + 6
end

function ENT:Think()
	if self.armed and self.detonateTime < CurTime() then
		self:StopLoopingSound(self.fuseSound)
		self:StartDetonate()
	end
end