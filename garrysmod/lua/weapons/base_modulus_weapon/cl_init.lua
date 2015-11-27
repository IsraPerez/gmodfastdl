
// includes
include( "shared.lua" );

//---------- Info
SWEP.DrawAmmo			= true;
SWEP.DrawCrosshair		= false;
SWEP.ViewModelFOV		= 62;
SWEP.ViewModelFlip		= false;
SWEP.SwayScale			= 6.0;
SWEP.BobScale			= 4.0;
SWEP.SprintTime			= UnPredictedCurTime();
SWEP.SprintInvert		= false;

//---------- Materials
local star = Material( "gui/silkicons/star" );

/*------------------------------------
	CustomAmmoDisplay
------------------------------------*/
function SWEP:CustomAmmoDisplay()

	// setup ammo display table
	self.AmmoDisplay = self.AmmoDisplay or {};
	self.AmmoDisplay.Draw = self.DrawAmmo;
	self.AmmoDisplay.PrimaryClip = -1;
	self.AmmoDisplay.PrimaryAmmo = -1;
	self.AmmoDisplay.SecondaryAmmo = -1;
	
	// have primary clip?
	if( self.Primary && self.Primary.Ammo != "" && self.Primary.ClipSize != -1 ) then
	
		self.AmmoDisplay.PrimaryClip = self:GetAmmo( self.Primary.Ammo );
		self.AmmoDisplay.PrimaryAmmo = LocalPlayer():GetCustomAmmo( self.Primary.Ammo );
		
	// have primary ammo?
	elseif( self.Primary && self.Primary.Ammo != "" && self.Primary.ClipSize == -1 ) then
	
		self.AmmoDisplay.PrimaryClip = LocalPlayer():GetCustomAmmo( self.Primary.Ammo );
		self.AmmoDisplay.PrimaryAmmo = -1;
	
	end
	
	// have secondary clip?
	if( self.Secondary && self.Secondary.Ammo != "" && self.Secondary.ClipSize != -1 ) then
	
		self.AmmoDisplay.SecondaryAmmo = self:GetAmmo( self.Secondary.Ammo );
		
	// have secondary ammo?
	elseif( self.Secondary && self.Secondary.Ammo != "" && self.Secondary.ClipSize == -1 ) then
	
		self.AmmoDisplay.SecondaryAmmo = LocalPlayer():GetCustomAmmo( self.Secondary.Ammo );
	
	end
	
	return self.AmmoDisplay;

end


/*------------------------------------
	FreezeMovement
------------------------------------*/
function SWEP:FreezeMovement( )

	return false;

end

/*------------------------------------
	ViewModelDrawn
------------------------------------*/
function SWEP:ViewModelDrawn( )
end

/*------------------------------------
	DrawHUD
------------------------------------*/
function SWEP:DrawHUD()
end

/*------------------------------------
	DrawWeaponSelection
------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	// calculate center
	local cx = x + wide * 0.5 - 32;
	local cy = y + tall * 0.5 - 32;

	// draw icon
	surface.SetMaterial( star );
	surface.SetDrawColor( 255, 255, 255, alpha );
	surface.DrawTexturedRect(
		cx, cy,
		64, 64
	
	);

end

/*------------------------------------
	PrintWeaponInfo
------------------------------------*/
function SWEP:PrintWeaponInfo( x, y, alpha )
end

/*------------------------------------
	HUDShouldDraw
------------------------------------*/
function SWEP:HUDShouldDraw( element )

	return true;

end

/*------------------------------------
	GetViewModelPosition
------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	// why the hell am I doing this here?
	if( !self.OldSway ) then
	
		self.OldSway = self.SwayScale;
	
	end
	if( !self.OldBob ) then
	
		self.OldBob = self.BobScale;
	
	end

	// do we have sprint angles?
	if( self.SprintAngles && !self.CanUseInSprint ) then

		// should we start sprinting?
		if( self.Owner:KeyDown( IN_SPEED ) && !self.Sprinting ) then
		
			// subtract whatever time we had remaining to the time
			self.SprintTime = CurTime() + ( 0.25 - math.Clamp( self.SprintTime - CurTime(), 0, 0.25 ) );
			self.SprintInvert = false;
			self.Sprinting = true;
			
			// restore
			self.SwayScale = self.OldSway;
			self.BobScale = self.OldBob;
		
		// stop sprinting?
		elseif( !self.Owner:KeyDown( IN_SPEED ) && self.Sprinting ) then
		
			// subtract whatever time we had remaining to the time
			self.SprintTime = CurTime() + ( 0.25 - math.Clamp( self.SprintTime - CurTime(), 0, 0.25 ) );
			self.SprintInvert = true;
			self.Sprinting = false;
			
			// fix iron time
			if( self:GetIronsights() ) then
			
				// restore time
				self.IronTime = CurTime() + 0.25;
				
				// restore sway
				self.SwayScale = 0.3;
				self.BobScale = 0.1;
				
			end
			
		end

		// sprinting?
		if( self.Sprinting || self.SprintTime >= CurTime() ) then
		
			// calculate percent
			local percent = ( self.SprintTime - CurTime() ) / 0.25;
			percent = 1 - math.Clamp( percent, 0, 1 );
			
			// inverted?
			if( self.SprintInvert ) then
			
				percent = 1 - percent;
			
			end
			
			local forward = ang:Forward();
			local right = ang:Right();
			local up = ang:Up();
			
			// translate
			pos = pos + forward * self.SprintAngles.Translate.x * percent;
			pos = pos + right * self.SprintAngles.Translate.y * percent;
			pos = pos + up * self.SprintAngles.Translate.z * percent;
			
			// rotate
			ang:RotateAroundAxis( up, self.SprintAngles.Rotate.y * percent );
			ang:RotateAroundAxis( forward, self.SprintAngles.Rotate.r * percent );
			ang:RotateAroundAxis( right, self.SprintAngles.Rotate.p * percent );

			return pos, ang;
		
		end

	end
	
	// have ironsight?
	if( self.Ironsights ) then
	
		local enabled = self:GetIronsights();
		self.LastIron = self.LastIron || false;
		
		// it recently changed?
		if( enabled != self.LastIron ) then
		
			self.LastIron = enabled;
			self.IronTime = CurTime();
		
			// update bob/sway scale
			if( enabled ) then
			
				// set new
				self.SwayScale = 0.3;
				self.BobScale = 0.1;
				
			else
			
				// restore
				self.SwayScale = self.OldSway;
				self.BobScale = self.OldBob;
			
			end

		end
		
		// get iron time
		local irontime = self.IronTime || 0;
		
		// in iron sight?
		if( !enabled && irontime < CurTime() - 0.5 ) then
		
			return pos, ang;
		
		end
		
		// multiplier
		local mul = 1;
		
		// shift
		if( irontime > CurTime() - 0.5 ) then
		
			mul = math.Clamp( ( CurTime() - irontime ) / 0.5, 0, 1 );
			
			// invert?
			if( !enabled ) then
			
				mul = 1 - mul;
			
			end
		
		end
		
		// offset
		local offset = self.Ironsights.Pos;
		
		// have angles?
		if( self.Ironsights.Ang ) then
		
			// rotate
			ang = ang * 1;
			ang:RotateAroundAxis( ang:Right(), self.Ironsights.Ang.x * mul );
			ang:RotateAroundAxis( ang:Up(), self.Ironsights.Ang.y * mul );
			ang:RotateAroundAxis( ang:Forward(), self.Ironsights.Ang.z * mul );
		
		end
		
		// shift
		pos = pos + offset.x * ang:Right() * mul;
		pos = pos + offset.y * ang:Forward() * mul;
		pos = pos + offset.z * ang:Up() * mul;
		
		return pos, ang;
	
	end

	return pos, ang;

end

