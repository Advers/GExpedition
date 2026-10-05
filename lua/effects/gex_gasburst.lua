
function EFFECT:Init( data )

	self.pos = data:GetOrigin()
	self.scale = data:GetScale()
	self.magnitude = data:GetMagnitude()
	local ent = data:GetEntity()

	sound.Play( "ambient/fire/gascan_ignite1.wav", self.pos, 80, math.Rand(120, 130) )

	local emitter = ParticleEmitter( self.pos )

	local particle = emitter:Add( "particle/warp1_warp", self.pos )
	if ( particle ) then
		local size = math.Rand(70, 100)
		particle:SetLifeTime( 0 )
		particle:SetDieTime( size/1000 )
		
		particle:SetStartSize( size * self.scale )
		particle:SetEndSize( 0 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		particle:SetRoll(math.Rand(0, math.tau))
		particle:SetRollDelta(math.random(-5,5))
		particle:SetAirResistance( 70 )
		particle:SetGravity( Vector( 0, 0, 30 ) )
		particle:SetCollide( true )
	end
	self.sequence = 0
	self:SetNextClientThink(CurTime() + 0.3)
	emitter:Finish()
end
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
