
function EFFECT:Init( data )

	self.pos = data:GetOrigin()
	self.scale = data:GetScale()
	self.magnitude = data:GetMagnitude()
	local ent = data:GetEntity()

	sound.Play( "ambient/explosions/explode_4.wav", self.pos, 140, math.random(80,90) )

	local dlight = DynamicLight( ent:EntIndex() )

	if ( dlight ) then

		dlight.Pos = self.pos
		dlight.r = 255
		dlight.g = 234
		dlight.b = 172
		dlight.Brightness = 3
		dlight.Size = 512
		dlight.DieTime = CurTime() + 2
		dlight.Decay = 512

	end
	local emitter = ParticleEmitter( self.pos )
	for i = 0, math.floor(math.random(20,30)*self.magnitude) do

		local dir = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ):GetNormalized()

		local particle = emitter:Add( "effects/yellowflare", self.pos )
		if ( particle ) then
			local size = math.random(400,1600)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( size/1000 )
			local color = HSVToColor( math.random(0,40), math.random(0.2,0.3), 1 )
			particle:SetColor(color.r,color.g,color.b)
			
			particle:SetStartSize( size * self.scale / math.sqrt(self.magnitude) )
			particle:SetEndSize( size * 1.5 * self.scale / math.sqrt(self.magnitude) )
			
			particle:SetStartAlpha( 127 )
			particle:SetEndAlpha( 0 )
			
			particle:SetVelocity( dir * 600000/size * self.scale )
			particle:SetRoll(math.random(0,360))
			particle:SetRollDelta(math.random(-5,5))
			particle:SetAirResistance( 70 )
			particle:SetGravity( Vector( 0, 0, 30 ) )
			particle:SetCollide( true )
		end

	end
	for i = 0, math.floor(math.random(20,30)*self.magnitude) do

		local dir = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ):GetNormalized()

		local particle = emitter:Add( "effects/fire_embers"..math.random(1,3), self.pos )
		if ( particle ) then
			
			local color = HSVToColor( math.random(0,40), math.random(0.1,0.3), 1 )
			particle:SetColor(color.r,color.g,color.b)
			
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.random(1,2) )
			
			particle:SetStartSize( math.random(100,400) * self.scale / math.sqrt(self.magnitude) )
			particle:SetEndSize( 0 )
			
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			
			particle:SetVelocity( dir * math.random(1200,2000) * self.scale )
			particle:SetRoll(math.random(0,360))
			particle:SetRollDelta(math.random(-5,5))
			particle:SetAirResistance( 70 )
			particle:SetGravity( Vector( 0, 0, -300 ) )
			particle:SetCollide( true )
		end

	end
	self.sequence = 0
	self:SetNextClientThink(CurTime() + 0.3)
	local decal = Material("gex/decals/scorch")
	util.DecalEx(decal,game.GetWorld(),self.pos,Vector(0,0,1),Color(0,0,0,0),0.3*self.scale,0.3*self.scale)
	emitter:Finish()
end
function EFFECT:Think()
	self.sequence = self.sequence + 1
	if self.sequence > 1 then
		local emitter = ParticleEmitter( self.pos )
		for i = 0, math.floor(math.random(5,10)*self.magnitude) do

			local dir = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ):GetNormalized()
			local particle = emitter:Add( "particles/smokey", self.pos )
			if ( particle ) then
				local size = math.random(200,700)
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.random(10,20) )
				
				particle:SetStartSize( 0 )
				particle:SetEndSize( size * 4 * self.scale / math.sqrt(self.magnitude))
				
				particle:SetStartAlpha( 60 )
				particle:SetEndAlpha( 0 )
				
				particle:SetColor(Color(64,64,64))
				particle:SetVelocity( dir * 150000/size * self.scale)
				particle:SetRoll(math.random(0,360))
				particle:SetRollDelta(math.random(-0.5,0.5))
				particle:SetAirResistance( 40 )
				particle:SetGravity( Vector( 0, 0, -30 ) )
				particle:SetCollide( true )
				particle:SetBounce( 1 )
			end

		end
		emitter:Finish()
		return false
	end
	return true
end

function EFFECT:Render()
end