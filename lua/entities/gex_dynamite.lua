AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")

ENT.Spawnable = true
ENT.Model = "models/props_junk/flare.mdl"
ENT.MaxHealth = 15
ENT.PrintName = "Dynamite"
ENT.Volatile = true -- makes it detonate if it is broken

if CLIENT then return end

function ENT:Initialize()
	BaseClass.Initialize(self)
	self:SetMaterial("models/props_debris/plasterwall039c")
	self:SetColor(Color(255, 90, 90))
end

function ENT:Arm()
	BaseClass.Arm(self)
	self.fuseSound = self:StartLoopingSound("weapons/flaregun/burn.wav")
	self.detonateTime = self.detonateTime or (CurTime() + 6) -- you can pinch out the flame but you CANNOT renew the fuse time
	self:NextThink(self.detonateTime)
end

function ENT:Disarm()
	BaseClass.Disarm(self)
	if self.fuseSound then 
		self:StopLoopingSound(self.fuseSound)
		self.fuseSound = nil
	end
end

function ENT:Think()
	if self.armed and self.detonateTime <= CurTime() then
		self:StopLoopingSound(self.fuseSound)
		self:StartDetonate()
	end
end
