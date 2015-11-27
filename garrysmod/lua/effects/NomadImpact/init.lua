
/*------------------------------------
	Init
------------------------------------*/
function EFFECT:Init( data )

	local i;
	local Pos = data:GetOrigin();
	local Normal = data:GetNormal();
	
	// create an emitter
	local emitter = ParticleEmitter( Pos );
	
	// streaks
	for i = 1, 32 do
	
		// create
		local particle = emitter:Add( "modulus/light", Pos + Normal * 2 );
			particle:SetVelocity( ( Normal + VectorRand() * 0.75 ):GetNormal() * math.Rand( 50, 75 ) );
			particle:SetDieTime( math.Rand( 1, 3 ) );
			particle:SetStartAlpha( 255 );
			particle:SetEndAlpha( 0 );
			particle:SetStartSize( math.Rand( 1, 2 ) );
			particle:SetEndSize( 0 );
			particle:SetRoll( 0 );
			particle:SetColor( 255, 128, 255 );
			particle:SetGravity( Vector( 0, 0, -250 ) );
			particle:SetCollide( true );
			particle:SetBounce( 0.3 );
			particle:SetAirResistance( 5 );

	end
	
	// light
	local dynlight = DynamicLight( math.random( 1, 2048 ) );
		dynlight.Pos = Pos;
		dynlight.Size = 200;
		dynlight.Decay = 400;
		dynlight.R = 255;
		dynlight.G = 128;
		dynlight.B = 255;
		dynlight.Brightness = 2;
		dynlight.DieTime = CurTime() + 0.35;

	// cleanup
	emitter:Finish();
	
end

/*------------------------------------
	Think
------------------------------------*/
function EFFECT:Think( )

	return false;
	
end

/*------------------------------------

------------------------------------*/
function EFFECT:Render( )

end
