
// client files
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

// includes
include( "shared.lua" );

//---------- Info
SWEP.Weight			= 1;
SWEP.AutoSwitchTo		= true;
SWEP.AutoSwitchFrom		= true;

// translation table
local ActivityIndex = {
	["pistol"] 	= ACT_HL2MP_IDLE_SMG1,
	["smg"]		= ACT_HL2MP_IDLE_SMG1,
	["grenade"]	= ACT_HL2MP_IDLE_GRENADE,
	["ar2"]		= ACT_HL2MP_IDLE_AR2,
	["shotgun"]	= ACT_HL2MP_IDLE_SHOTGUN,
	["rpg"]		= ACT_HL2MP_IDLE_RPG,
	["physgun"]	= ACT_HL2MP_IDLE_PHYSGUN,
	["crossbow"]	= ACT_HL2MP_IDLE_CROSSBOW,
	["melee"]	= ACT_HL2MP_IDLE_MELEE,
	["slam"]	= ACT_HL2MP_IDLE_SLAM,
	["passive"]	= ACT_HL2MP_IDLE_PASSIVE,
	["melee2"]	= ACT_HL2MP_IDLE_MELEE2,
	["knife"]	= ACT_HL2MP_IDLE_KNIFE,
	["fist"]	= ACT_HL2MP_IDLE_FIST,
	
};

/*------------------------------------
	SetWeaponHoldType
------------------------------------*/
function SWEP:SetWeaponHoldType( hold_type )

	// find the base activity
	local index = ActivityIndex[ hold_type ];
	
	// no index?
	if( !index ) then
	
		// alert them.
		Msg( "Error! Weapons activity is nil\n" );
		
		// bye bye
		return;
	
	end
	
	// setup activity translate table.
	self.ActivityTranslate = {
		[ ACT_HL2MP_IDLE ]			= index,
		[ ACT_HL2MP_RUN ]			= index + 1,
		[ ACT_HL2MP_IDLE_CROUCH ]		= index + 2,
		[ ACT_HL2MP_WALK_CROUCH ]		= index + 3,
		[ ACT_HL2MP_GESTURE_RANGE_ATTACK ]	= index + 4,
		[ ACT_HL2MP_GESTURE_RELOAD ]		= index + 5,
		[ ACT_HL2MP_JUMP ]			= index + 6,
		[ ACT_RANGE_ATTACK1 ]			= index + 7,
		
	};
	
	// ai translate table
	self.ActivityTranslateAI = {};
	self.ActivityTranslateAI [ ACT_IDLE ] 					= ACT_IDLE_SMG1;
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1;
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1;
	self.ActivityTranslateAI [ ACT_RELOAD ] 				= ACT_RELOAD_SMG1;
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 				= ACT_WALK_AIM_SMG1;
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 				= ACT_RUN_AIM_SMG1;
	self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 			= ACT_GESTURE_RANGE_ATTACK_SMG1;
	self.ActivityTranslateAI [ ACT_WALK ] 					= ACT_WALK_AGITATED;
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 				= ACT_WALK_AIM_STEALTH;
	self.ActivityTranslateAI [ ACT_RUN ] 					= ACT_RUN_AGITATED;
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 				= ACT_RUN_AIM_SHOTGUN;
	self.ActivityTranslateAI [ ACT_RUN_CROUCH ] 				= ACT_RUN_CROUCH_RIFLE;
	self.ActivityTranslateAI [ ACT_RUN_CROUCH_AIM ] 			= ACT_RUN_CROUCH_AIM_RIFLE;

end

/*------------------------------------
	TranslateActivity
------------------------------------*/
function SWEP:TranslateActivity( activity )

	// npc or player?
	local translation_table = self.ActivityTranslate;
	if( self.Owner:IsNPC() ) then translation_table = self.ActivityTranslateAI; end

	// fetch the translated activity
	local act = translation_table[ activity ];
	if( act ) then return act; end
	
	// no activity
	return -1;

end

/*------------------------------------
	OnDrop
------------------------------------*/
function SWEP:OnDrop( )

end

/*------------------------------------
	Equip
------------------------------------*/
function SWEP:Equip( pl )

end

/*------------------------------------
	EquipAmmo
------------------------------------*/
function SWEP:EquipAmmo( pl )

end

/*------------------------------------
	AcceptInput
------------------------------------*/
function SWEP:AcceptInput( name, activator, caller )

	return true;

end

/*------------------------------------
	KeyValue
------------------------------------*/
function SWEP:KeyValue( key, value )
end


/*------------------------------------
	GetCapabilities
------------------------------------*/
function SWEP:GetCapabilities()

	return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1;

end

/*------------------------------------
	NPCShoot_Secondary
------------------------------------*/
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )

	if( ValidEntity( self.Owner ) ) then

		self:SecondaryAttack();
		
	end

end

/*------------------------------------
	NPCShoot_Primary
------------------------------------*/
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

	if( ValidEntity( self.Owner ) ) then

		self:PrimaryAttack();
		
	end

end

/*------------------------------------
	NPC weapon usage
------------------------------------*/
AccessorFunc( SWEP, "fNPCMinBurst", "NPCMinBurst" );
AccessorFunc( SWEP, "fNPCMaxBurst", "NPCMaxBurst" );
AccessorFunc( SWEP, "fNPCFireRate", "NPCFireRate" );
AccessorFunc( SWEP, "fNPCMinRestTime", "NPCMinRest" );
AccessorFunc( SWEP, "fNPCMaxRestTime", "NPCMaxRest" );
