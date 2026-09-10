AddCSLuaFile()
DEFINE_BASECLASS("gex_rocket_base")

ENT.Spawnable = true
ENT.Model = "models/props_phx/amraam.mdl"
ENT.MaxHealth = 50
ENT.PrintName = "AIM-120 AMRAAM"

if not SERVER then return end

--[[function ENT:InitializeWire()
	self.Inputs = WireLib.CreateInputs(self, {"Arm", "Detonate", "Launch"}, {"Controls whether the rocket is armed", "Immediately detonates the rocket", "LAUNCH THE MISSILE NOW!!!"})
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
	end,
	["Launch"] = function(self, value)
		if value > 0 then
			self:StartDetonate()
		end
	end}]]