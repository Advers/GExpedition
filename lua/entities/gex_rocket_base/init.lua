AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.UnSittable = true
ENT.Aerodynamic = true
ENT.Acceleration = 1000
ENT.LaunchVelocity = 1000
ENT.BurnDuration = 4

DEFINE_BASECLASS("gex_bomb_base")

function ENT:InitializeWire()
	local names, descs = {"Launch", "Detonate"}, {"LAUNCH THE MISSILE NOW!!!", "Immediately detonates the explosive"}

	local ValidFuses = self.ValidFuses
	if ValidFuses then
		table.insert(names, "Fuse Type")
		local desc = "Sets the type of fuse for the explosive. Valid fuse types are:"
		for i, typ in ipairs(ValidFuses) do
			desc = desc.."\n"..i.." - "..typ
		end
		table.insert(descs, desc)
		
		table.insert(names, "Fuse Setting")
		table.insert(descs, "Adjust the behavior of the currrent fuse.")
	end

	self.Inputs = WireLib.CreateInputs(self, names, descs)
end

ENT.WireInputAction = {
	["Launch"] = function(self, value)
		if value > 0 then -- Can't un-launch a rocket, so setting a value lower than 0 simply doesn't do anything
			if not self.launched then
				self:Launch()
			end
		end
	end,
	["Detonate"] = function(self, value)
		if value > 0 then
			self:StartDetonate()
		end
	end,
	["Fuse Type"] = function(self, value)
		local newType = self.ValidFuses[value]
		if newType and newType ~= self.FuseType then
			self:ChangeFuseType(newType)
		end
	end,
	["Fuse Setting"] = function(self, value)
		self.FuseSetting = value
	end}

function ENT:Launch()
	self.launched = true
	self.BurnTime = CurTime() + self.BurnDuration
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(true)
	phys:Wake()
	phys:AddVelocity(phys:LocalToWorldVector(self.Forward)*self.LaunchVelocity)
end

function ENT:Use(activator, proxy)
	if activator:IsWalking() then
		if not self.launched then
			self:Launch()
		end
	else -- don't want the player to pick up rockets when they're trying to launch them
		if self:GetPhysicsObject():GetMass()<=35 then -- This is how it works in the base game, but I wish it were possible to just. use the base game.
			if self:IsPlayerHolding() then 
				self:ForcePlayerDrop()
			else
				activator:PickupObject( self )
			end
		end
	end
end

function ENT:PhysicsSimulate(phys, deltaTime)
	print(deltaTime)
	local vel = phys:GetVelocity()
	if self.launched and self.BurnTime >= CurTime() then
		local localVel = phys:WorldToLocalVector(phys:GetVelocity())
		return self.Forward:Cross(localVel)*0.5 - phys:GetAngleVelocity(), self.Forward*self.Acceleration, SIM_LOCAL_ACCELERATION
	elseif vel:IsZero() then
		return nil, nil, SIM_NOTHING
	else
		local localVel = phys:WorldToLocalVector(phys:GetVelocity())
		return self.Forward:Cross(localVel)*0.5 - phys:GetAngleVelocity(), vector_origin, SIM_LOCAL_ACCELERATION
	end
end
