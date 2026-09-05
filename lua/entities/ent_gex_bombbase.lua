AddCSLuaFile()
DEFINE_BASECLASS("base_anim")
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Class = "ent_gex_bombbase"
ENT.PhysicsSounds = true
ENT.Model = "models/Gibs/HGIBS.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetMaxHealth(self.MaxHealth)
		self:SetHealth(self.MaxHealth)
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		self.armed = false
	end
	function ENT:Arm()
		self.armed = true
	end
	function ENT:Detonate()
		GExSplodeBasic(self,self:GetPos(),100,500)
		self:Remove()
	end
	function ENT:StartDetonate()
		if not self.detonating then
			self.detonating = true
			self:Detonate()
		end
	end
	function ENT:Break()
		self:GibBreakServer(Vector())
		self:Remove()
	end
	function ENT:OnTakeDamage(dmg)
		self:SetHealth(self:Health()-dmg:GetDamage())
		if self:GetMaxHealth() ~= 0 and self:Health()<=0 then
			if self.armed then
				self:StartDetonate()
			else
				self:Break()
			end
		end
		return dmg:GetDamage()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end