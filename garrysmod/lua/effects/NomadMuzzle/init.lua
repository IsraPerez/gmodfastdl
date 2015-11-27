
/*------------------------------------
	Init
------------------------------------*/
function EFFECT:Init( data )

	// get weapon
	self.Weapon = data:GetEntity();
	
	// setup to follow the weapon
	self.Entity:SetRenderBounds( Vector() * -16, Vector() * 16 );
	self.Entity:SetParent( self.Weapon );
	
	// create the muzzle sprite effect
	self.Sprite = MuzzleSprite(
		self.Weapon,
		math.Rand( 24, 32 ),
		math.Rand( 0.25, 0.35 ),
		"modulus/light",
		Color( 255, 128, 255, 255 ),
		FX_SPRITE_SHRINK | FX_SPRITE_FADEOUT | FX_OFFSET_SHRINK,
		5,
		4,
		math.Rand( 16, 24 )
		
	);
	
	// get our owner.
	if( ValidEntity( self.Weapon ) ) then
	
		// get muzzle pos
		local pos, dir = GetMuzzle( self.Weapon, 1 );
		
		// muzzle light
		local dynlight = DynamicLight( self.Weapon:EntIndex() );
			dynlight.Pos = pos;
			dynlight.Size = 200;
			dynlight.Decay = 400;
			dynlight.R = 255;
			dynlight.G = 128;
			dynlight.B = 255;
			dynlight.Brightness = 2;
			dynlight.DieTime = CurTime() + 0.35;
		
	end
	
end

/*------------------------------------
	Think
------------------------------------*/
function EFFECT:Think( )

	return self.Sprite:IsFinished();
	
end

/*------------------------------------
	Render
------------------------------------*/
function EFFECT:Render( )
	
	self.Sprite:Draw();
	
end

