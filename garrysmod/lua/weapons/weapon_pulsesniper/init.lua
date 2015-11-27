
// client files
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

// includes
include( "shared.lua" );

//---------- Info
SWEP.Weight			= 1;
SWEP.AutoSwitchTo		= true;
SWEP.AutoSwitchFrom		= true;

//---------- Resources
resource.AddFile( "materials/modulus/light.vmt" );
resource.AddFile( "materials/modulus/spark.vmt" );
resource.AddFile( "materials/decals/nomad.vmt" );
resource.AddFile( "scripts/decals/nomad_decals.txt" );
resource.AddFile( "materials/vgui/entities/weapon_nomad.vmt" );
resource.AddFile( "materials/vgui/entities/weapon_nomad.vtf" );
resource.AddFile( "sound/modulus/nomad1.wav" );
resource.AddFile( "sound/modulus/nomad2.wav" );
resource.AddFile( "sound/modulus/nomad3.wav" );
resource.AddFile( "sound/modulus/nomad4.wav" );
resource.AddFile( "sound/modulus/empty.wav" );

