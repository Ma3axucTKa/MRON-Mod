init( )
{
		level.br_totalvehiclesmax = 350;
		level.mzsmode = getDvar("mzsmode");
		level thread scripts\mp\art::DefineGameSettings( );
		level.squad_leader_group_size = 1;
		level.br_level.c130_heightoverride = 25000;
		level.br_level.c130_speedoverride = 7500;
		level thread OnPlayerConnected( );
		level.armoronweaponswitchlongpress = 1;
		setDvar("scr_br_pickupScriptablesMax", 300);
		setDvar("scr_br_lastStandReviveTimer", 3 );
		level.damageinfo = getDvarint("dmgdisplay");
		level thread scripts\mp\art::ArmorInMp( );
		level.mpstimboosting = getDvarint("mpstimboosting", 0);
		level.plunderkills = getDvarint("plunderkills", 20);
		level thread scripts\mp\art::VehiclesFix( );
		if ( level.NonStopRoyale == 1 )
		{
			level.br_level.c130_heightoverride = 8000;
			level.br_level.c130_speedoverride = 5000;
		}
}
OnPlayerConnected( )
{
    	level Endon( "game_ended" );
    	while ( true )
    	{
        	level WaitTill( "connected", player );
        	player thread OnPlayerSpawned( );
    	}
}

OnPlayerSpawned( )
{
	level Endon( "game_ended" );
    self Endon( "disconnect" );
	self thread scripts\mp\art::OnPlayerSpawned( );
	logprint("Started Thread OnPlayerSpawned for ", self.name );
	self thread scripts\mp\art::KillCounter( );
	if ( level.mzsmode == "killduo" && level.gametype == "br" )
	{
		self thread BonusOnKill( );
	}
	level.weaponmapdata["iw8_ar_galima"].uihidden = 0;
   	level.weaponmapdata["iw8_sn_golf28"].uihidden = 0;
   	level.weaponmapdata["iw8_lm_dblmg"].uihidden = 0;
   	level.weaponmapdata["iw8_sn_xmike109"].uihidden = 0;
   	level.weaponmapdata["iw8_la_mike32"].uihidden = 0;
   	level.weaponmapdata["iw8_fists"].uihidden = 0;
   	level.weaponmapdata["iw8_sm_victor"].uihidden = 0;
   	level.weaponmapdata["iw8_sm_charlie9"].uihidden = 0;
	if ( level.gametype != "br" )
	{
		for (;;)
		{
			self WaitTill( "spawned_player" );
			self.cracksoundplayed = 0;
		}
	}
}
BonusOnKill( )
{
	while ( true )
	{
		self waittill("got_a_kill");
		self scripts\mp\gametypes\br_armor::givearmorvalue( 150 );
		LocalCashValue = RandomIntRange( 15, 20 );
		for ( i = 0; i < LocalCashValue; i++ )
        {
            self scripts\mp\gametypes\br_plunder::takeplunderpickup();   
        }
		self thread scripts\mp\art::GiveRandomPerk( );
	}
}
/*RandomRealism( chance )
{
	level endOn("game_ended");
	l_randomprok = RandomIntRange( 0, 100 );
	if ( l_randomprok <= chance )
	{
		level.tacticalmode = 1;
		foreach( player in level.players )
		{
		}
		setDvar("scr_game_tacticalmode", 1 );
		setDvar("scr_game_enableMinimap", 0 );
		setDvar("ui_showMinimap", 0 );
		setDvar("scriptable_lootoutlinecolor", 1);
	}
	else
	{
		level.tacticalmode = 0;
		foreach( player in level.players )
		{
			self setclientdvar("scriptable_lootoutlinecolor", 5);
			setDvar("scriptable_lootoutlinecolor", 5);
		}
	}
}*/
