AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")
ENT.Class = "gex_dynamite"

ENT.Spawnable = true
ENT.Model = "models/props_junk/flare.mdl"
ENT.MaxHealth = 15
ENT.Name = "Dynamite"
ENT.PrintName = "Dynamite"

if not SERVER then return end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SetMaterial("models/props_debris/plasterwall039c")
	self:SetColor(Color(255, 90, 90))
end

function ENT:Use()
	BaseClass.Use(self)
	if not self.detonateTime then
		self:Arm()
	end
end

function ENT:Arm()
	BaseClass.Arm(self)
	self.fuseSound = self:StartLoopingSound("weapons/flaregun/burn.wav")
	self.detonateTime = CurTime() + 6
end

function ENT:Think()
	if self.armed and self.detonateTime < CurTime() then
		self:StopLoopingSound(self.fuseSound)
		self:StartDetonate()
	end
end