AddCSLuaFile()
DEFINE_BASECLASS("base_anim")
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Class = "ent_gex_bomb"

ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/watermelon01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMaterial("models/debug/debugwhite",true)
		local Red = Color(255,50,50,255)
		self:SetColor(Red)
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

	end
else
	function ENT:Draw()
		self:DrawModel()
		if ( LocalPlayer():GetEyeTrace().Entity == self ) then
			AddWorldTip(self:EntIndex(), "BOMB", 2, self:GetPos(), self)
		end
	end
end