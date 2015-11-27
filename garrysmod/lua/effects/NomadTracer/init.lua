
/*------------------------------------
	Init
------------------------------------*/
function EFFECT:Init( data )

	// dist, dir, etc.
	local endpos = data:GetOrigin();
	local startpos = GetTracerOrigin( data );
	local dist = ( endpos - startpos ):Length();
	local dir = ( endpos - startpos ):Normalize();

	// length
	local length = math.random( 128, 500 );
	local speed = 7000;
	
	// life
	local life = ( dist + length ) / speed;
	
	// create the tracer
	self.Line = DiscreetLine(
		startpos, dir,
		speed,
		length,
		dist,
		16,
		life,
		"modulus/spark",
		Color( 255, 128, 255, 255 )
		
	);
	// renderbounds
	self.Entity:SetRenderBoundsWS( startpos, endpos );

end

/*------------------------------------
	Think
------------------------------------*/
function EFFECT:Think( )

	return self.Line:IsFinished();

end

/*------------------------------------
	Render
------------------------------------*/
function EFFECT:Render( )

	self.Line:Draw();
	
end
