AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetMaxHealth(self.MaxHealth)
	self:SetHealth(self.MaxHealth)
	
	self:SetModel(self.Model)
	self:PrecacheGibs()
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.armed = false
	self:SetUseType( SIMPLE_USE )
	
	if WireLib then
		self:InitializeWire()
	end
end

function ENT:InitializeWire()
	self.Inputs = WireLib.CreateInputs(self, {"Arm", "Detonate"}, {"Controls whether the explosive is armed", "Immediately detonates the explosive"})
end

ENT.WireInputAction = {
	["Arm"] = function(self, value)
		if value > 0 then
			if not self.armed then
				self:Arm()
			end
		else
			if self.armed then
				self:Disarm()
			end
		end
	end,
	["Detonate"] = function(self, value)
		if value > 0 then
			self:StartDetonate()
		end
	end}

function ENT:TriggerInput(input, value)
	self.WireInputAction[input](self, value)
end

function ENT:Arm()
	self.armed = true
end

function ENT:Disarm()
	self.armed = false
end

function ENT:Use(activator,proxy)
	if not self.armed and activator:IsWalking() then
		self:Arm()
		self:EmitSound("weapons/tripwire/hook.wav",70,150)
	end
	if self:GetPhysicsObject():GetMass()<=35 and not activator:IsWalking() then--This is how it works in the base game, but I wish it were possible to just. use the base game.
		if self:IsPlayerHolding() then 
			self:ForcePlayerDrop()
		else
			activator:PickupObject( self )
		end
	end
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
		if self.armed or self.Volatile then
			self:StartDetonate()
		else
			self:Break()
		end
	end
	return dmg:GetDamage()
end