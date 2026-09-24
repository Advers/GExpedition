print("wow that's some explosions")
function GExSplodeBasic(ent,pos,dmg,radius,attacker) --GEX BLAST!!!
	local effx = EffectData()
	effx:SetOrigin(pos)
	effx:SetMagnitude(2)
	effx:SetScale(radius/600)
	effx:SetFlags(0)
	util.BlastDamage(ent,attacker or ent,pos,radius,dmg)
	util.Effect("gex_explosionflashsmoke",effx,true,true)
end
