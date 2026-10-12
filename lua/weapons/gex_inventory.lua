AddCSLuaFile()
SWEP.Name			= "Inventory"
SWEP.Author 		= "Formal Lizard & Adversarius"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Quick use selection wheel for GEx"
SWEP.Spawnable = true
--DEFINE_BASECLASS( "weapon_csbasegun" )

function SWEP:Initialize()
	self:SetWeaponHoldType('knife')
end
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_eq_defuser.mdl"
SWEP.Slot = 5
SWEP.SlotPos = 8
SWEP.m_bPlayPickupSound = false --WOW GREAT NAMING SCHEME GARRY
SWEP.UseHands = true
SWEP.BobScale = 4
SWEP.SwayScale = 20
SWEP.DrawAmmo = true
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"
SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.ViewModelFOV = 20

function SWEP:Think()
	self.ViewModelFOV = math.sin(CurTime())*30+40
end
function SWEP:PrimaryAttack()
	if CLIENT then
		local answer = Gex_ToggleInventory()
		print(answer)
		if answer then 
			self:EmitSound("npc/combine_soldier/zipline_hitground2.wav",0,math.random(70,100),0.2)
		else
			self:EmitSound("npc/combine_soldier/zipline_clip1.wav",0,math.random(70,100),0.1)
		end
	end
end
function SWEP:SecondaryAttack()
	
end