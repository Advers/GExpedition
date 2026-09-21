ENT.Base = "base_gmodentity" 
AddCSLuaFile()
ENT.Spawnable = false
ENT.Type = "anim"
if not SERVER then return end
gexnpcregistry = gexnpcregistry or {}
spawnsizes = {
	npc_gex_hobo = {
		mins = Vector(-24,-24,-4),
		maxs = Vector(24,24,78)
	},
	npc_gex_hooker = {
		mins = Vector(-24,-24,-4),
		maxs = Vector(24,24,78)
	},
	npc_gex_lightpass = {
		mins = Vector(-24,-24,-4),
		maxs = Vector(24,24,78)
	},
	npc_gex_roach = {
		mins = Vector(-3),
		maxs = Vector(3)
	},
	npc_gex_mantiswalker = {
		mins = Vector(-96,-96,-4),
		maxs = Vector(96,96,200)
	},
	npc_gex_boxingbug = {
		mins = Vector(-96,-96,-4),
		maxs = Vector(96,96,100)
	},
	npc_gex_trussman = {
		mins = Vector(-96,-96,-4),
		maxs = Vector(96,96,600)
	},
	npc_gex_mixgolem = {
		mins = Vector(-28,-28,-4),
		maxs = Vector(28,28,98)
	},
	npc_gex_trashsummoner = {
		mins = Vector(-28,-28,-4),
		maxs = Vector(28,28,98)
	},
	npc_gex_vermin = {
		mins = Vector(-12),
		maxs = Vector(12)
	},
	npc_gex_trashflopper = {
		mins = Vector(-12),
		maxs = Vector(12)
	},
	npc_gex_bastard = {
		mins = Vector(-24),
		maxs = Vector(24)
	},
	npc_gex_trashfly = {
		mins = Vector(-24),
		maxs = Vector(24)
	},
}
encounters = {
	outdoorchaossunny = {
		npc_gex_mantiswalker = 0.0625,
		npc_gex_bastard = 0.05,
	},
	rot = {
		npc_gex_trashsummoner = 0.1,
		npc_gex_trashflopper = 0.7,
		npc_gex_trashfly = 0.05,
	},
	infestation = {
		npc_gex_roach = 0.7,
		npc_gex_vermin = 0.7,
	},
	clusterfuck = {
		npc_gex_roach = 0.3,
		npc_gex_trashsummoner = 0.05,
		npc_gex_trashflopper = 0.05,
		npc_gex_trashfly = 0.025,
		npc_gex_boxingbug = 0.1,
		npc_gex_bastard = 0.15,
		npc_gex_vermin = 0.2,
	},
	boxingbugs = {
		npc_gex_boxingbug = 0.4,
	},
	bastards = {
		npc_gex_bastard = 0.7,
	},
	golemguard = {
		npc_gex_mixgolem = 0.25,
		npc_gex_lightpass = 0.01,
	},
	demonswarm = {
		npc_gex_hooker = 0.7,
		npc_gex_trussman = 0.01,
		npc_gex_lightpass = 0.2,
	},
}
spawnpools = {
	garbage = {
		"rot",
		"infestation",
		"clusterfuck",
	},
	wasteland = {
		"outdoorchaossunny",
		"outdoorchaossunny",
		"outdoorchaossunny",
		"rot",
	},
	darkfantasy = {
		"boxingbugs",
		"golemguard",
		"demonswarm",
		"rot",
	},
	demonden = {
		"demonswarm",
		"rot"
	},
	temple = {
		"golemguard"
	}
}
hook.Add("InitPostEntity","addmorespawnpools",function()
	print("loading gex spawnpools...")
	if gexnpcregistry.npc_gex_hobo then
		encounters.hoboclan = {
			npc_gex_roach = 0.01,
			npc_gex_hobo = 0.5,
		}
		spawnpools.garbage[#spawnpools.garbage+1] = "hoboclan"
	end
end)
function ENT:TriggerSpawner()
	local chosenSpawnpool = spawnpools[self.spawnpool or "garbage"]
	local encounter = encounters[chosenSpawnpool[math.random(1,#chosenSpawnpool)]]
	for _ = 1,(self.tries or 1) do
		for class,chance in pairs(encounter) do
			if math.random()<chance then
				self:SpawnEnt(class)
			end
		end
	end
end
function ENT:SpawnEnt(class)
	local trace = util.TraceHull({start = self:GetPos(), endpos = self:GetPos() + Vector(math.random()-0.5,math.random()-0.5,-math.random()/2):GetNormalized() * (self.radius or 128), mins = spawnsizes[class].mins, maxs = spawnsizes[class].maxs})
	if trace.FractionLeftSolid ~= 0 or trace.StartSolid then return end
	local newSummon = ents.Create(class)
	newSummon:SetPos(trace.HitPos)
	newSummon:Spawn()
	newSummon:Activate()
	print(trace.HitPos)
end
function ENT:KeyValue( key, value )
	self[key] = value
end
function ENT:Initialize()
	self:SetNoDraw(true)
	local key = "gexspawnerwaitForTrigger"..math.random()
	timer.Create(key,math.random(0.9,1.1),-1,function()
		if not IsValid(self) then return end
		for _,value in pairs(player.GetAll()) do --util.TraceLine({start = self:GetPos(), endpos = value:WorldSpaceCenter()}).Entity == value
			if IsValid(value) and value:WorldSpaceCenter():Distance(self:GetPos()) < (tonumber(self.triggerradius) or 1000) then
				self:TriggerSpawner()
				timer.Remove(key)
			end
		end
	end)
end

