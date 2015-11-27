
//---------- Info
SWEP.Base			= "base_modulus_weapon";
SWEP.ViewModel			= "models/weapons/v_smg1.mdl";
SWEP.WorldModel			= "models/weapons/w_smg1.mdl";
SWEP.Category			= "Pulse";
SWEP.PrintName			= "Pulsesmg";
SWEP.Slot			= 1;
SWEP.SlotPos			= 0;
SWEP.Spawnable			= true;
SWEP.AdminSpawnable		= false;

//---------- Ironsight
SWEP.Ironsights = {
	Pos		= Vector( -6.5, -4, 2.65 ),
	Sensitivity	= 0.1,

};

//---------- Primary
SWEP.Primary = {
	ClipSize	= -1,
	DefaultClip	= -1,
	Automatic	= true,
	Ammo		= "crystal",
	Delay		= 0.1,

};

//---------- Secondary
SWEP.Secondary = {
	ClipSize	= -1,
	DefaultClip	= -1,
	Automatic	= false,
	Ammo		= "",
	Delay		= 0,

};

//---------- NPC Weapon
list.Set( "NPCWeapons", "weapon_nomad", "Nomad" );

/*------------------------------------
	Precache
------------------------------------*/
function SWEP:Precache( )

	util.PrecacheSound( "modulus/nomad1.wav" );
	util.PrecacheSound( "modulus/nomad2.wav" );
	util.PrecacheSound( "modulus/nomad3.wav" );
	util.PrecacheSound( "modulus/nomad4.wav" );
	util.PrecacheSound( "modulus/empty.wav" );

end


/*------------------------------------
	Initialize
------------------------------------*/
function SWEP:Initialize( )

	// base
	self.BaseClass.Initialize( self );

	// server
	if( SERVER ) then
	
		// holdtype
		self:SetWeaponHoldType( "ar2" );
		
	end
	
	// regenerate
	self.NextRegenerate = CurTime();
	
end

/*------------------------------------
	Think
------------------------------------*/
function SWEP:Think( )

	// base
	self.BaseClass.Think( self );
	
	// regenerate
	if( SERVER ) then
	
		if( self.NextRegenerate <= CurTime() ) then
		
			self.NextRegenerate = CurTime() + 0.2;
			
			// regenerate ammo
			local ammo = math.min( self.Owner:GetCustomAmmo( "crystal" ) + 1, 50 );
			self.Owner:SetCustomAmmo( "crystal", ammo );
		
		end
		
	end

end

/*------------------------------------
	BulletCallback
------------------------------------*/
local function BulletCallback( inflictor, attacker, tr, dmginfo )

	// perform impact effects.
	if( tr.MatType != MAT_FLESH ) then

		// hit
		if( tr.Hit && !tr.HitSky ) then
		
			// spew some flecks
			local effect = EffectData();
				effect:SetOrigin( tr.HitPos );
				effect:SetNormal( tr.HitNormal );
			util.Effect( "NomadImpact", effect, true, true );
			
			// decal
			util.Decal( "Modulus.Nomad", tr.HitPos + tr.HitNormal * 2, tr.HitPos - tr.HitNormal * 2 );

		end
	
	end
	
	// doesn't work... oh well.
	return { damage = true, effects = false };

end

/*------------------------------------
	PrimaryAttack
------------------------------------*/
function SWEP:PrimaryAttack( )

	// next attack
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );

	// not an npc?
	if( !self.Owner:IsNPC() ) then
	
		// enough ammo?
		if( !self:CanPrimaryAttack() ) then
		
			// sound
			self.Weapon:EmitSound( "modulus/empty.wav" );
			
			return;
		
		end
		
		// take ammo
		if( SERVER ) then
			
			// take ammo
			self:TakePrimaryAmmo( 1 );
			
			// set next regenerate
			self.NextRegenerate = CurTime() + 0.5;
			
		end
		
	end
	
	// create a bullet.
	local bullet = {
		Num		= 1,
		Src		= self.Owner:GetShootPos(),
		Dir		= self.Owner:GetAimVector(),
		Spread		= Vector( 0.080, 0.080, 0 ),
		Tracer		= 1,
		Force		= 15,
		Damage		= 15,
		HullSize	= HULL_TINY_CENTERED,
		AmmoType	= "Pistol",
		TracerName	= "NomadTracer",
		Attacker	= self.Owner,
		Callback	= function( a, b, c ) return BulletCallback( self.Weapon, a, b, c ); end,
		
	};
	
	// shoot
	self.Weapon:FireBullets( bullet );
	
	// sound
	self.Weapon:EmitSound( string.format( "modulus/nomad%d.wav", math.random( 4 ) ) );
	
	// animation
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	// muzzle flash.
	local effect = EffectData();
		effect:SetOrigin( self.Owner:GetShootPos() );
		effect:SetEntity( self.Weapon );
		effect:SetAttachment( 1 );
	util.Effect( "NomadMuzzle", effect );

end
