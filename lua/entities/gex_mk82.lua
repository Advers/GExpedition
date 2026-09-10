AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")

ENT.Spawnable = true
ENT.Model = "models/props_phx/mk-82.mdl"
ENT.MaxHealth = 30
ENT.PrintName = "Mark 82"
ENT.Aerodynamic = true

if not SERVER then return end

function ENT:Arm(...)
	self.BaseClass.Arm(self,...)
	self.detonateTime = CurTime() + 15
	self.alarm = self:StartLoopingSound("ambient/alarms/combine_bank_alarm_loop4.wav")
end

function ENT:Disarm()
	self.BaseClass.Disarm(self)
	if self.alarm then 
		self:StopLoopingSound(self.alarm)
		self.alarm = nil
	end
end

function ENT:Think()
	if self.armed and self.detonateTime < CurTime() then
		self:StopLoopingSound(self.alarm)
		self:StartDetonate()
	end
end