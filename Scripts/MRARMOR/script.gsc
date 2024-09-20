init( )
{
	level.botsopt = getDvarint("mzbots");
	if ( level.botsopt == 0 )
	{
		level thread OnPlayerConnected( );
		level.armoronweaponswitchlongpress = 1;
		level.hitmarkerpriorities["standardspreadarmor"] = 250;
    	level.hitmarkerpriorities["standardarmor"] = 150;
		thread scripts\mp\damagefeedback::init();
    	thread scripts\mp\lightarmor::init();
		level scripts\mp\gametypes\br_armor::main( );
		level scripts\mp\gametypes\br_armor::initarmor( );
        level.damageinfo = getDvarint("dmgdisplay");

	}

}
OnPlayerConnected( )
{
	if ( level.botsopt == 0 )
	{
    	level Endon( "game_ended" );
    	while ( true )
    	{
        	level WaitTill( "connected", player );
        	player thread OnPlayerSpawned( );
            if ( !isDefined( level.mzsmode ) )
              player thread ArmorSounds( );
            player thread MPStimV2( );
    	}
	}
}

OnPlayerSpawned( )
{
	while ( true )
	{
		self WaitTill( "spawned_player" );
        self.cracksoundplayed = 0;
        self.playedknockdownsound = 0;
	}
}


ArmorSounds( )
{
    if ( level.mparmor == 1 )
    {
    for (;;)
    {
        self WaitTill( "damage" , damagedSize , playerInfo , var_2 , damagedPoint , damageType , var_5 , var_6 , var_7 , var_8 , weaponName , REALDAMAGEPOINT , var_11 , var_12 , killstreakInfo );
        if ( self.health >= 100 )
        {
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo playlocalsound("hit_marker_3d_armor");
            playerInfo setclientomnvar( "damage_feedback_icon", "hitarmorlight" );
            playerInfo setclientomnvar( "damage_feedback_icon_notify", 1 );
            /*
            REALDAMAGEPOINT = REALDAMAGEPOINT + ( 0, 0, 70 );

            PlayFX( "dism1", REALDAMAGEPOINT );
            PlayFX( scripts\engine\utility::GetFX( "dism1" ) , REALDAMAGEPOINT );
            PlayFX( "dism2", REALDAMAGEPOINT );
            PlayFX( scripts\engine\utility::GetFX( "dism2" ) , REALDAMAGEPOINT );
            PlayFX( "dism3", REALDAMAGEPOINT );
            PlayFX( scripts\engine\utility::GetFX( "dism3" ) , REALDAMAGEPOINT );
            PlayFX( "dism4", REALDAMAGEPOINT );
            PlayFX( scripts\engine\utility::GetFX( "dism3" ) , REALDAMAGEPOINT );
            iprintln(REALDAMAGEPOINT);
            iprintln(self.origin);

            I1 = scripts\engine\utility::fxexists( "dism1" );
            playerInfo iprintln(I1);
            I2 = scripts\engine\utility::fxexists( "dism2" );
            playerInfo iprintln(I2);
            I3 = scripts\engine\utility::fxexists( "dism3" );
            playerInfo iprintln(I3);*/
        }
        if ( self.health <= 100 && self.cracksoundplayed == 0 && self.maxhealth != 100 )
        {
            if ( damagedSize >= 100 )
              wait 0.8;
            playerInfo playlocalsound("hit_marker_3d_armor_break");
            playerInfo playlocalsound("hit_marker_3d_armor_break");
            playerInfo playlocalsound("hit_marker_3d_armor_break");
            playerInfo setclientomnvar( "damage_feedback_icon_notify", 1 );
            playerInfo setclientomnvar( "damage_feedback_icon", "hitarmorlightbreak" );
            self.cracksoundplayed = 1;
        }
        if ( level.damageinfo == 1 )
        {
            playerInfo iprintln(damagedSize , " given");
        }
        /*if ( self.inlaststand == 1 && self.playedknockdownsound == 0 )
          wait 1;
          self.playedknockdownsound = 1;
          playerInfo setclientomnvar( "damage_feedback_icon_notify", 1 );
          playerInfo setclientomnvar( "damage_feedback_icon", "hitlaststand" );*/
    }
    }
}

MPStimV2( )
{
    while ( true )
    {
        self waittill( "force_regeneration" );
        self SetMoveSpeedScale( 1.3 );
        self iPrintlnBold( "^1Speed boost applied" );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.5 );
        wait 0.5;
        self SetMoveSpeedScale( 1.4 );
        wait 0.5;
        self SetMoveSpeedScale( 1.4 );
        wait 0.5;
        self SetMoveSpeedScale( 1.4 );
        wait 0.5;
        self SetMoveSpeedScale( 1.4 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        self iPrintlnBold( "^53 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        self iPrintlnBold( "^52 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        self iPrintlnBold( "^51 TACT LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1 );
        self iPrintlnBold( "^2Speed boost is finished" );
    }
}