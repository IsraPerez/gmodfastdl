
// includes
include( "shared.lua" );

//---------- Info
SWEP.DrawAmmo			= true;
SWEP.DrawCrosshair		= true;
SWEP.ViewModelFOV		= 62;
SWEP.ViewModelFlip		= false;
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;
SWEP.SprintAngles		= {
	Translate	= Vector( 0, 0, -15 ),
	Rotate		= Angle( 45, 0, 10 ),

};

//---------- Killicon
killicon.AddFont( "weapon_nomad", "HL2MPTypeDeath", "/", Color( 255, 128, 255, 255 ) );
