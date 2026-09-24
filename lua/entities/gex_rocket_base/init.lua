AddCSLuaFile("shared.lua")

include("shared.lua")

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
