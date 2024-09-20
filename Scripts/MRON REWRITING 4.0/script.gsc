init( )
{
	level.botsopt = getDvar("mzbots");
	if ( level.botsopt == 0 )
	{
		level.br_totalvehiclesmax = 150;
		level.mzsmode = getDvar("mzsmode");
		level.squad_leader_group_size = 1;
		level.br_level.c130_heightoverride = 25000;
		level.br_level.c130_speedoverride = 7500;
		level thread OnPlayerConnected( );
		level.armoronweaponswitchlongpress = 1;
		if ( level.mzsmode == "brsnd" )
        {
        }
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
    	}
	}
}

OnPlayerSpawned( )
{
	level Endon( "game_ended" );
    self Endon( "disconnect" );
	while ( true )
	{
		self WaitTill( "spawned_player" );
		level.weaponmapdata["iw8_ar_galima"].uihidden = 0;
   		level.weaponmapdata["iw8_sn_golf28"].uihidden = 0;
   		level.weaponmapdata["iw8_lm_dblmg"].uihidden = 0;
   		level.weaponmapdata["iw8_sn_xmike109"].uihidden = 0;
   		level.weaponmapdata["iw8_la_mike32"].uihidden = 0;
   		level.weaponmapdata["iw8_fists"].uihidden = 0;
   		level.weaponmapdata["iw8_sm_victor"].uihidden = 0;
   		level.weaponmapdata["iw8_sm_charlie9"].uihidden = 0;
	}
}


ResurgenceInitTimer()
{
}



