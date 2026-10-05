AddCSLuaFile()
DEFINE_BASECLASS("gex_bomb_base")

ENT.Spawnable = true
ENT.Model = "models/gexpedition/explosives/spikergrenade.mdl"
ENT.MaxHealth = 30
ENT.PrintName = "Spiker Grenade"
ENT.FuseType = "Timed"

if CLIENT then return end

function ENT:Initialize()
	BaseClass.Initialize(self)
	self:GetPhysicsObject():SetMass(50)
end

function ENT:Arm(...)
	BaseClass.Arm(self,...)
	self.alarm = self:StartLoopingSound("physics/metal/metal_grenade_scrape_rough_loop1.wav")
end

function ENT:StartDetonate()
	if self.alarm then 
		self:StopLoopingSound(self.alarm)
		self.alarm = nil
	end
	BaseClass.StartDetonate(self)
end

function ENT:Detonate()
	local effx = EffectData()
	effx:SetOrigin(self:GetPos())
	effx:SetMagnitude(1)
	effx:SetScale(1)
	effx:SetFlags(0)
	util.Effect("gex_gasburst",effx,true,true)
	for _=1,8 do
		local newSummon = ents.Create("gex_spiker_grenade_flak")
		newSummon:SetAngles(VectorRand( ):Angle())
		newSummon:SetPos(self:GetPos()+newSummon:GetForward()*6)
		newSummon:Spawn()
		newSummon:Activate()
	end
	self:Remove()
end

function ENT:Disarm()
	BaseClass.Disarm(self)
	if self.alarm then 
		self:StopLoopingSound(self.alarm)
		self.alarm = nil
	end
end
