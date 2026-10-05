AddCSLuaFile()
DEFINE_BASECLASS("base_anim")
ENT.Type = "anim"
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	return
end
function ENT:Initialize()
	self:SetModel("models/gexpedition/explosives/spikerprojectile.mdl")
	if (self:PhysicsInit( SOLID_BBOX )) then
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetVelocity( self:GetForward()*600 )
		self:SetGravity(0.5)
	end
	self.bounces = 2
	self.dieTime = CurTime()+15
end
function ENT:Think()
	if CurTime()>(self.dieTime or 0) then
		self:Remove()
	end
end
function ENT:Touch( ent )
	if ent:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		return
	end
	if IsValid(ent) then
		local dmg = DamageInfo()
		dmg:SetDamage( self:GetVelocity():Length()>30 and 55 or 5 )
		dmg:SetInflictor( self )
		dmg:SetDamageType( DMG_BULLET )
		dmg:SetDamagePosition( self:GetPos() )
		ent:TakeDamageInfo( dmg )
		self:EmitSound("weapons/crowbar/crowbar_impact"..math.random(2)..".wav",80,150)
		self:Remove()
	else
		self.bounces = self.bounces - 1
		if self.bounces < 0 then
			self:EmitSound("weapons/crowbar/crowbar_impact"..math.random(2)..".wav",80,150)
			self:Remove()
		else
			self:EmitSound("weapons/crowbar/crowbar_impact"..math.random(2)..".wav",80,math.random(80,120),0.5)
		end
	end
end