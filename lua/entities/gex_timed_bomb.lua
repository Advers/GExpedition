AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")
ENT.Class = "gex_timed_bomb"

ENT.Spawnable = true
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
ENT.MaxHealth = 30
ENT.Name = "Time Bomb"

if not SERVER then return end
function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:GetPhysicsObject():SetMass(50)
	self:SetColor(Color(255,50,50,255))
	self:SetSkin(1)
end
function ENT:Arm(...)
	self.BaseClass.Arm(self,...)
	self.detonateTime = CurTime() + 15
	self.alarm = self:StartLoopingSound("ambient/alarms/combine_bank_alarm_loop4.wav")
	self:SetSkin(0)
end
function ENT:Disarm()
	self.BaseClass.Disarm(self)
	if self.alarm then 
		self:StopLoopingSound(self.alarm)
		self.alarm = nil
	end
	self:SetSkin(1)
end
function ENT:Think()
	if self.armed and self.detonateTime < CurTime() then
		self:StopLoopingSound(self.alarm)
		self:StartDetonate()
	end
end