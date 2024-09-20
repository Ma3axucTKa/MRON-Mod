//MRON copyright 2025
Main( )
{
    level.mzsmode = getdvar("mzsmode");
    level thread scripts\mp\killstreaks\nuke::init( );
    level.nukedetonated = 0;
    level thread TimeMetrics( );
    level thread OnPlayerConnected( );
    level thread InitDefaultDvars( );
    level thread DefineGameRules( );
    level thread VehiclesFix( );
    if ( getDvarint("printmrondebug") >= 1 )
      level thread LegacyDebugPrint( );
}
TimeMetrics( ) // TIME MANAGEMENT
{
    level waittill("prematch_done");
    logprint("Started Metrics.");
    setDvar("mzsmatchstate", "going");
    level thread LoadMZSDef( );
    for (;;)
    {
        if (!isDefined(level.Metrics))
          level.MetricsTime = 0;
        wait 30;
        level.MetricsTime = level.MetricsTime + 30;
        if ( level.MetricsTime >= 901 )
          setDvar("mzsmatchstate", "lategoing");
    }
}
OnPlayerConnected( ) // CONNECTIONS MANAGEMENT
{
    for (;;)
    {
      level waittill("connected", player);
      player thread OnPlayerFirstSpawn( );
      player thread OnPlayerEveryDeath( );
      if ( level.gametype == "br" )
        player thread OnPlayerBREverySpawn( );
    }
}
OnPlayerFirstSpawn( ) {
    self waittill("spawned_player");
    self thread BonusOnKill( );
    self thread VanguardStim( );
    if ( level.gametype == "br" )
      self thread OnPlayerBRFirstSpawn( );
}
OnPlayerEveryDeath( )
{
    level endon("game_ended");
    for (;;)
    {
        self waittill("death");
        // processing
    }
}
OnPlayerBRFirstSpawn( ) // PLAYER BR PROCESSING
{
    if (getDvar("mzsmatchstate") != "going" )
    {
        self waittill("prematch_done");
        self GiveRedeploy( );
        self thread ApplyToSelfRevived( );
        self thread VanguardStim( );
        self thread BrOnPlaneJump( );
        if ( level.ResurgenceEnabled >= 1 )
          self waittill("death");
          while ( !self isonground() )
            waitframe();
            self thread ResurgenceInitTimer( );

    }
    if (getDvar("mzsmatchstate") == "going" )
    {
        self GiveRedeploy( );
        self.origin = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 5000 );
        if ( level.ResurgenceEnabled >= 1 )
          self waittill("death");
          while ( !self isonground() )
            waitframe();
            self thread ResurgenceInitTimer( );
    }
}
OnPlayerBREverySpawn( ) {
    level endon("game_ended");
    if ( getDvar("mzsmatchstate" != "going") )
      level waittill("prematch_done");
    for (;;)
    {
        self waittill("spawned_player");
        self WriteGameMode( );
        while ( !self isonground() )
          waitframe();
          self thread ProvideWeapon(
          /* weaponID */      "Random",
          /* inProjectile */  "Random" ,
          /* onlyGroup */     undefined ,
          /* attachmentID */  "Random",
          /* camoID */        "Random" ,
          /* akimbo */        undefined,
          /* changeHand */    true ,
          /* notice */        undefined
        );

          self scripts\cp_mp\utility\inventory_utility::_takeweapon( "iw8_fists_mp" );
          self GiveArmorPlate( );
          self GiveArmorPlate( );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_919", 30, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_762", 60, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_50cal", 10, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_12g", 6, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_rocket", 1, 0 );

    }
}
BrOnPlaneJump( )
{
    self waittill( "infil_jump_done" );
    self thread PerksFromTheGround( );
    setomnvar( "ui_br_minimap_radius", 15000);
    self scripts\mp\gametypes\br_pickups::addselfrevivetoken( );
	self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_equip_gasmask", 1, undefined, 1 );
	self scripts\mp\gametypes\br_armor::givearmorvalue( 150 );
	wait 0.5;
	self scripts\mp\gametypes\br_plunder::playplundersoundbyamount( self, 5 );
	if ( scripts\mp\utility\game::getsubgametype( ) == "br" )
	{
	  while ( !self isonground() )
        waitframe(); // EMDOOM EDITION
        self thread ProvideWeapon(
          /* weaponID */      "Random",
          /* inProjectile */  "Random" ,
          /* onlyGroup */     undefined ,
          /* attachmentID */  "Random",
          /* camoID */        "Random" ,
          /* akimbo */        undefined,
          /* changeHand */    true ,
          /* notice */        undefined
        );
        self scripts\cp_mp\utility\inventory_utility::_takeweapon( "iw8_fists_mp" );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_919", 30, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_762", 60, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_50cal", 10, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_12g", 6, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_rocket", 1, 0 );
        self playlocalsound( "iw8_support_box_use" );
        self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
	}
	else
	{
	}
}
ResurgenceTracker( )
{
    if ( 0 < level.ResurgenceMode )
    {
        level.ResurgenceEnabled = 1;

        while ( true )
        {
            if ( level.TimeMetrics == 210 )
            {
                level.ResurgenceEnabled = 0;
                level scripts\mp\gametypes\br_killstreaks::dangernotifyplayer( self, "gulag_closed", undefined, 2 );
                level.bannedplayer = undefined;
                if ( level.mzsmode == "resurgsolo" || level.mzsmode == "resurgduo" || level.mzsmode == "resurgtrio" || level.mzsmode == "resurgsquad" )
                iPrintln("^1Resurgence was disabled!");
                level scripts\mp\gametypes\br_publicevents::showsplashtoall( "br_inflation_respawn_tokens_disabled" );
                level playsound("iw8_mp_cop_new_obj");
                wait 1;
                level playsound("iw8_cop_new_obj");
                wait 1;
                level playsound("mp_cop_new_obj");
                wait 1;
                level playsound("cop_new_obj");
                break;
            }

            wait 15;
        }
    }
}
LegacyDebugPrint( skipprematchwaiting )
{
    if ( skipprematchwaiting <= 0 )
      level waittill("prematch_done");
    iprintln("Prematch done.");
    for (;;)
    {
        foreach ( player in level.players )
        {
            if ( self isHost( ) )
            {
                wait 30;
                iprintln( self.origin , " cords");
                iprintln( self.kills , " kills");
            }
        }
    }
    wait 2;
    iprintln(level.ResurgenceEnabled , " ResurgenceEnabled");
    iprintln(level.ResurgenceMode , " ResurgenceMode");
    iprintln(level.TimeMetrics, " TimeMetrics");
    iprintln(level.resurgtimer, " resurg timer");
    wait 2;
    iprintln(level.mzsmode, " mzsmode");
    iprintln(level.gametype, " level gametype");
    wait 5;
    level LegacyDebugPrint( 1 );
}
ResurgenceInitTimer()
{
    if ( level.ResurgenceEnabled == 0 )
      return;
	self scripts\mp\hud_message::showsplash( "br_respawn_token_disabled" );
	if ( isDefined(self.resurgtimer))
	{
	    self iPrintln("^3Survive " , self.resurgtimer , "^3sec to get redeployment!");
		wait self.resurgtimer;
		self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
		self scripts\mp\hud_message::showsplash( "br_inflation_respawn_token_pickup" );
        self iPrintln("^3You survived the timer!");
		self.resurgtimer = self.resurgtimer + 3;
		return self.resurgtimer;
        self waittill("player_spawned");
        while ( !self isonground() )
          waitframe();
          self thread ResurgenceInitTimer( );
	}
	else
	{
		wait level.resurgtimer;
		self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
		self scripts\mp\hud_message::showsplash( "br_inflation_respawn_token_pickup" );
		self.resurgtimer = level.resurgtimer + 3;
		return self.resurgtimer;
        self waittill("player_spawned");
        while ( !self isonground() )
          waitframe();
          self thread ResurgenceInitTimer( );
	}
}
DefineGameRules( ) {
	setDvar("scr_br_dropbag_delay", 300);
	if( level.mzsmode == "mrduo") // Mini Royale Duos
	{
	level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 30);
	setDvar("scr_player_maxhealth", 175);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	level thread RandomRealism( 5 );
	}
	else if ( level.mzsmode == "resurgtrio") // Resurgence Trios
	{
    level.ResurgenceMode = 1;
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 20;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	level thread RandomRealism( 15 );
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgsquad") // Resurgence Quads
	{
    level.ResurgenceMode = 1;
	level.squad_max_size = 4;
	level.maxteamsize = 4;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 20;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	level thread RandomRealism( 15 );
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgsolo") // Resurgence Solos
	{
    level.ResurgenceMode = 1;
	level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 15;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	level thread RandomRealism( 2 );
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgduo") // Resurgence Duos
	{
    level.ResurgenceMode = 1;
	level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 15;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "dynresurgtrio") // Dynamic Resurgence Trios
	{
    level.ResurgenceMode = 1;
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 15;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	}
	else if( level.mzsmode == "mrsolo") // Mini Royale Solos
	{
	level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 30);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	}
	else if ( level.mzsmode == "killduo" ) // Killrace Royale Duos
	{
	level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_alt_mode_inflation", 1);
	setDvar("scr_br_dropbag_delay", 75);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	setDvar("scr_br_armor_heal_amount", 75);
	}
	else if ( level.mzsmode == "killsolo" ) // Killrace Royale Solos
	{
	level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_alt_mode_inflation", 1);
	setDvar("scr_br_dropbag_delay", 75);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	setDvar("scr_br_armor_heal_amount", 75);
	level.gasmaskmaxhealth = 20;
	}
	else if ( level.mzsmode == "killtrio" ) // Killrace Royale Trios
	{
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_alt_mode_inflation", 1);
	setDvar("scr_br_dropbag_delay", 75);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	setDvar("scr_br_armor_heal_amount", 75);
	level.gasmaskmaxhealth = 20;
	}
	else if ( level.mzsmode == "eventtrio" )
	{
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 20);
	setDvar("scr_br_dropbag_delay", 1);
	setDvar("scr_allow_custom_loadouts", 0);
	level.br_allowloadout = 0;
	level thread RandomRealism( 65 );
	}
    else if ( level.mzsmode == "dmzduo" ) // DMZ royale duo
    {
    level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
    }
    else if ( level.mzsmode == "dmzsolo" ) // DMZ royale solo
    {
    level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
    }
}
LoadMZSDef( )
{
    foreach ( z in level.players )
    {
        z SetClientDvar("TriggerDefLoading", 1 );
    }
}
VehiclesFix( )
{
    if (scripts\mp\utility\game::getgametype() == "br")
	{
        while ( true )
	    {
	        level waittill("br_circle_set");
			wait 30;
		    scripts\mp\gametypes\br_vehicles::brvehiclesreset( );
		    scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
			wait 30;
		    scripts\mp\gametypes\br_vehicles::brvehiclesreset( );
		    scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
		    scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
            level waittill("br_circle_set");
            wait 210;
            scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
	    }
    }
}
InitDefaultDvars( ) {
    level.armoronweaponswitchlongpress = 1;
    setDvar("mzsmatchstate", "prematch");
    setDvar( "set scr_br_pickupScriptablesMax", 500 );
    setDvar("scr_br_platePouchCount", 3);
	scripts\mp\gametypes\br_gametypes::enablefeature( "allowLateJoiners" );
	scripts\mp\gametypes\br_gametypes::disablefeature( "gulag" );
	setDvar("scr_br_dropbag2_delay", 650);
    level.br_totalvehiclesmax = 150;
	level.br_level.c130_heightoverride = 25000;
	level.br_level.c130_speedoverride = 7500;
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	setDvar("NKOOQPNSKM", 3);
	level.squad_leader_group_size = 1;
    setDvar("scr_br_lastStandReviveTimer", 3);
}
RandomRealism( chance ) // REALISM MANAGEMENT
{
	level endOn("game_ended");
	l_randomprok = RandomIntRange( 0, 100 );
	if ( l_randomprok <= chance )
	{
		level.tacticalmode = 1;
		foreach( player in level.players )
		{
			self setclientdvar("scriptable_lootoutlinecolor", 1 );
			self setclientdvar("scr_game_enableMinimap", 0 );
			self setclientdvar("ui_showMinimap", 0 );
			self setclientdvar("scr_game_tacticalmode", 1 );
			self setclientomnvar( "ui_hide_minimap", 1 );
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
}
BonusOnKill( ) // KILL MANAGEMENT
{
	while ( true )
	{
		self waittill("got_a_kill");
		LocalCashValue = RandomIntRange( 15, 20 );
		for ( i = 0; i < LocalCashValue; i++ )
        {
            if ( getDvar("mzsmatchstate") == "ongoing")
              self scripts\mp\gametypes\br_plunder::takeplunderpickup();   
        }
        self scripts\mp\equipment\adrenaline::useadrenaline( );
		self playLocalSound( "mp_obj_taken" );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
        self GiveArmorPlate( );
		self GiveRandomPerk( );
        self scripts\mp\gametypes\br_plunder::playplundersoundbyamount( self, 5 );
        if ( scripts\mp\utility\perk::_hasperk("specialty_quick_fix" ) )
		{
			self scripts\mp\gametypes\br_armor::givearmorvalue( 150 );
		}
	}
}
KillCounter( )
{
    level endon("game_ended");
    if (!isDefined(self.kills))
      self.kills = 0;
    for (;;)
    {
        self waittill("got_a_kill");
        if ( getDvar("mzsmatchstate") == "ongoing")
          self.kills = self.kills + 1;
    }
    if ( self.kills == 3 )
      self playLocalSound( "mp_obj_taken" );
      self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "uav" );
      self scripts\mp\gametypes\br_pickups::addplatepouch( 1 ); 
    if ( self.kills == 5 )
      self playLocalSound( "mp_obj_taken" );
	  self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "precision_airstrike" );
      self scripts\mp\gametypes\br_pickups::addplatepouch( 1 );
    if ( self.kills == 15 )
      self playLocalSound( "mp_obj_taken" );
	  self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "directional_uav" );
      self scripts\mp\gametypes\br_pickups::addplatepouch( 1 );
      if ( level.mzsmode == "dmzsolo" || level.mzsmode == "dmzduo" )
        self iprintln("Nuke points: 10");
        self iprintlnbold("Nuke points: 10");
    if ( self.kills == 30 )
    {
        if ( level.mzsmode == "dmzsolo" || level.mzsmode == "dmzduo" )
        {
            self iprintln("^1Nuke Achieved.");
            self iprintlnbold("^1Nuke Achieved.");
            self GiveFinalNuke( );
            foreach ( player in level.players )
            {
                if ( player.name != self.name )
                  player scripts\mp\utility\dialog::leaderdialogonplayer( "mission_failure" );
            }
            self waittill( "used_nuke" );
            self thread LaunchFinalNuke( );
            wait 30;
            self thread scripts\mp\gametypes\br::brendgame( self, self );
        }
    }
}
WriteGameMode( continueornot )
{
    switch (level.mzsmode) {
        case "resurgsolo":
        self iprintln("^5Survive the timer to get redeployment.");
        self iprintln("^3You're playing Resurgence!");
        break;
        case "resurgduo":
        self iprintln("^5Survive the timer to get redeployment.");
        self iprintln("^3You're playing Resurgence!");
        break;
        case "resurgtrio":
        self iprintln("^5Survive the timer to get redeployment.");
        self iprintln("^3You're playing Resurgence!");
        break;
        case "resurgsquad":
        self iprintln("^5Survive the timer to get redeployment.");
        self iprintln("^3You're playing Resurgence!");
        break;
        case "mrsolo":
        self iprintln("^5Have at least $3000 to be redeployed.");
        self iprintln("^3You're playing Mini Royale!");
        break;
        case "mrduo":
        self iprintln("^5Have at least $3000 to be redeployed.");
        self iprintln("^3You're playing Mini Royale!");
        break;
        case "killsolo":
        self iprintln("^5Redeployments are free. Gain perks for kills!");
        self iprintln("^3You're playing KillRace Royale!");
        break;
        case "killduo":
        self iprintln("^5Redeployments are free. Gain perks for kills!");
        self iprintln("^3You're playing KillRace Royale!");
        break;
        case "eventtrio":
        self iprintln("^5The Gas moves fast! Get on the ground!");
        self iprintln("^3You're playing Event Royale!");
        case "dmzsolo":
        self iprintln("^5The Gas moves fast! Reach 30 kills and launch Nuke to win.");
        self iprintln("^3You're playing DMZ Royale!");
        break;
        case "dmzduo":
        self iprintln("^5The Gas moves fast! Reach 30 kills and launch Nuke to win.");
        self iprintln("^3You're playing DMZ Royale!");
        break;
    }
}
PlayingBonuses( )
{
    if ( level.TimeMetrics >= 60 )
    {
        while ( true )
	    {
            level waittill( "br_circle_set" );
            self thread GiveRandomPerk( );
			wait 10;
	        LocalCashValue = RandomIntRange( 15 ,20 );
	        for ( i = 0; i < LocalCashValue; i++ )
            {
                self scripts\mp\gametypes\br_plunder::takeplunderpickup();    
            }
            self GiveArmorPlate( );
            self scripts\mp\gametypes\br_plunder::playplundersoundbyamount( self, 5 );
		}
	}
	else
	  return false;
}

GiveArmorPlate( ) // SHORTENERS MANAGEMENT
{
    self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
}
GiveRandomPerk( )
{
    self playLocalSound( "ammo_crate_use" );
    l_PerksArray = ["specialty_ghost", "specialty_tracker", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_super_sprint_kill_refresh", "specialty_br_sleightofhand", "specialty_br_healer", "specialty_br_sneaky", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_revive_use_weapon", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_stalker", "specialty_br_stalker", "specialty_br_healer", "specialty_br_healer", "specialty_br_healer", "specialty_br_sneaky","specialty_br_sneaky","specialty_br_sneaky" , "specialty_aura_speed", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced",  "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_ads_mark_target", "specialty_regen_delay_reduced", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_br_extra_killstreak_chance", "specialty_munitions", "specialty_munitions", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_shrapnel_resist", "specialty_shrapnel", "specialty_super_sprint_kill_refresh", "specialty_quick_fix", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_scavenger", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_tune_up", "specialty_tune_up", "specialty_tune_up", "specialty_guerrilla", "specialty_ghost", "specialty_ghost", "specialty_ghost", "specialty_engineer", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_br_spotter", "specialty_br_spotter", "specialty_br_tracker", "specialty_br_tracker", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_ghost", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_br_ghost", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_delaymine", "specialty_delaymine", "specialty_falldamage", "specialty_falldamage", "specialty_falldamage", "specialty_stun_resistance", "specialty_stun_resistance", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_bulletdamage", "specialty_stopping_power", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_specialist_bonus", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite"];
    l_PerkName = scripts\engine\utility::Random( l_PerksArray );
    self scripts\mp\utility\perk::giveperk( l_PerkName );
    self scripts\mp\hud_message::showsplash( "br_specialty_blastshield" );
}

GiveRandomBasedPerk( )
{
    l_BasePerksArray = ["specialty_ghost", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_tracker", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_scavenger", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_tune_up", "specialty_tune_up", "specialty_tune_up", "specialty_ghost", "specialty_ghost", "specialty_engineer", "specialty_spotter", "specialty_spotter", "specialty_tracker", "specialty_tracker", "specialty_ghost", "specialty_ghost", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_surveillance", "specialty_surveillance", "specialty_surveillance", "specialty_surveillance", "specialty_surveillance", "specialty_specialist_bonus", "specialty_coldblooded", "specialty_coldblooded", "specialty_coldblooded"];
    l_PerkName = scripts\engine\utility::Random( l_BasePerksArray );
    self scripts\mp\utility\perk::giveperk( l_PerkName );
    self scripts\mp\hud_message::showsplash( l_PerkName );
    if ( l_PerkName == "specialty_br_sleightofhand" )
    {
        self iPrintlnBold("^3Sleight of hand acquired!");
    }
}
PerksFromTheGround( )
{
    self EndOn("disconnect");
    self EndOn("game_ended");
    while ( true )
    {
        self waittill( "got_loot" );
        if ( RandomIntRange(0, 100) <= 24 )
        {
            self playLocalSound( "ammo_crate_use" );
            l_PerksArray = ["specialty_ghost", "specialty_tracker", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_super_sprint_kill_refresh", "specialty_br_sleightofhand", "specialty_br_healer", "specialty_br_sneaky", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_revive_use_weapon", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_stalker", "specialty_br_stalker", "specialty_br_healer", "specialty_br_healer", "specialty_br_healer", "specialty_br_sneaky","specialty_br_sneaky","specialty_br_sneaky" , "specialty_aura_speed", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced",  "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_ads_mark_target", "specialty_regen_delay_reduced", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_br_extra_killstreak_chance", "specialty_munitions", "specialty_munitions", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_shrapnel_resist", "specialty_shrapnel", "specialty_super_sprint_kill_refresh", "specialty_quick_fix", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_scavenger", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_tune_up", "specialty_tune_up", "specialty_tune_up", "specialty_guerrilla", "specialty_ghost", "specialty_ghost", "specialty_ghost", "specialty_engineer", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_br_spotter", "specialty_br_spotter", "specialty_br_tracker", "specialty_br_tracker", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_ghost", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_br_ghost", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_delaymine", "specialty_delaymine", "specialty_falldamage", "specialty_falldamage", "specialty_falldamage", "specialty_stun_resistance", "specialty_stun_resistance", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_bulletdamage", "specialty_stopping_power", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_specialist_bonus", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite"];
            l_PerkName = scripts\engine\utility::Random( l_PerksArray );
            self scripts\mp\utility\perk::giveperk( l_PerkName );
            self scripts\mp\hud_message::showsplash( "br_specialty_blastshield" );
        }
        else 
        {
            return;
        }
    }
}
GiveRedeploy( )
{
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
}





















// NUKES MANAGEMENT AND ALL RELATED
LaunchFinalNuke( )
{
    level notify ("MassiveNukeIncoming");
    level.MassiveNukeInProgress = 1;
    self scripts\mp\gametypes\br_publicevents::showsplashtoall( "arm_defcon_four" );
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 5, var_bombcord, var_bombcord, var_bombcord, 20, 20);
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 100, var_bombcord, var_bombcord, var_bombcord );
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 1, var_bombcord, var_bombcord, 5);
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 50, var_bombcord, var_bombcord, 5);
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 20, var_bombcord, var_bombcord, 1);
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMazaStrike( var_bombcord );
    wait 2;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMazaStrike( var_bombcord );
    wait 4;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMazaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 5;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    wait 3;
    var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    self thread CallMegaStrike( var_bombcord );
    level thread scripts\mp\killstreaks\nuke::init( );
    wait 3;
    self thread scripts\mp\killstreaks\nuke::tryusenuke( );
    wait 2;
    self thread scripts\mp\killstreaks\nuke::nuke_vision(self, self);
}
CallMegaStrike( location )
{
    level Endon( "game_ended" );


    l_RandomX = RandomIntRange( -15000 , 15000 );
    l_RandomY = RandomIntRange( -15000 , 15000 );
    l_RandomZ = RandomIntRange( 5000 , 20000 );
    l_StartLocation = location + ( l_RandomX , l_RandomY , l_RandomZ );
    l_EndLocation = location + ( -( l_RandomX ) , -( l_RandomY ) , l_RandomZ );
    l_Time = 6;
    
    l_NewObject = Spawn( "script_model" , l_StartLocation );
    l_NewObject SetModel( "veh8_mil_air_acharlie130" );
    l_NewObject PlayLoopSound( "iw8_ks_ac130_lp" );
    
    l_Angles = VectorToAngles( l_EndLocation - l_StartLocation );
    l_NewObject.angles = l_Angles;

    WaitFrame( );

    l_NewObject thread OnProcessAttackMazaStrike( /* location */ location , /* owner */ self , /* distance */ 7500 , /* weap */ "iw8_la_gromeo_mp" );
    l_NewObject thread OnProcessAttackMazaStrike( /* location */ location , /* owner */ self , /* distance */ 7500 , /* weap */ "iw8_la_gromeo_mp" );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , l_NewObject.origin , RandomLocation );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , l_NewObject.origin , RandomLocation );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , l_NewObject.origin , RandomLocation );
    
    l_NewObject MoveTo( l_EndLocation , l_Time );
    wait l_Time;
    l_NewObject Delete( );
}

OnProcessAttackMazaStrike( location , owner , distance , weap )
{
    level Endon( "game_ended" );
    owner Endon( "disconnect" );

    l_Location = ( location[0] , location[1] , self.origin[2] );

    while ( IsDefined( self ) )
    {
        if ( Distance( self.origin , l_Location ) < distance )
        {
            l_LeftPoint = self.origin + ( AnglesToLeft( self.angles ) * 200 ) + ( AnglesToUp( self.angles ) * -( 100 ) );
            
            scripts\cp_mp\utility\weapon_utility::_MagicBullet( MakeWeapon( weap ) , l_LeftPoint , location , owner );

            wait 0.5;

            location = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );

            l_RightPoint = self.origin + ( AnglesToRight( self.angles ) * 200 ) + ( AnglesToUp( self.angles ) * -( 100 ) );
            
            scripts\cp_mp\utility\weapon_utility::_MagicBullet( MakeWeapon( weap ) , l_RightPoint , location , owner );

            wait 0.1;
        }
        wait 0.01;
    }
}
CallMazaStrike( location )
{
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 1000 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    level Endon( "game_ended" );
    self Endon( "disconnect" );

    l_OptName = "VanguardAirstrike";
    
    self Notify( "end_" + l_OptName );
    WaitFrame();
    
    level.lvlStat[l_OptName + "Deleting"] = true;

    level.lvlStat[l_OptName + "_Object"] = [];

    l_RandomX = undefined;
    l_RandomY = undefined;
    if ( scripts\engine\utility::Cointoss( ) )  { l_RandomX = RandomIntRange( -15000 , -10000 ); }
    else                                        { l_RandomX = RandomIntRange( 10000 , 15000 ); }
    if ( scripts\engine\utility::Cointoss( ) )  { l_RandomY = RandomIntRange( -15000 , -10000 ); }
    else                                        { l_RandomY = RandomIntRange( 10000 , 15000 ); }
    l_RandomZ = RandomIntRange( 1500 , 2000 );
    l_StartLocation = location + ( l_RandomX , l_RandomY , l_RandomZ );
    l_EndLocation = location + ( -( l_RandomX ) , -( l_RandomY ) , l_RandomZ );
    l_AirLocation = ( location[0] , location[1] , l_RandomZ );
    l_Angle = VectorToAngles( l_EndLocation - l_StartLocation );
    l_Time = 0;
    l_Location = l_StartLocation;
    l_WeaponID = "";

    l_Array =
    [
        "veh8_mil_air_alfa10" ,
        "veh8_mil_air_alfa10_east"
    ];

    l_WeaponArray =
    [
        "iw8_la_gromeo_mp"
    ];

    for ( i = 0; i < 30; i++ ) // PLANES COUNT
    {
        l_ModelID = scripts\engine\utility::Random( l_Array );

        l_Location = l_StartLocation;
        if ( scripts\engine\utility::Cointoss( ) )  { l_Location = l_Location + ( AnglesToForward( l_Angle )    * RandomIntRange( 500 , 1500 ) ); }
        else                                        { l_Location = l_Location + ( AnglesToForward( l_Angle )    * RandomIntRange( -500 , -1500 ) ); }
        if ( scripts\engine\utility::Cointoss( ) )  { l_Location = l_Location + ( AnglesToLeft( l_Angle )       * RandomIntRange( 4000 , 4000 ) ); }
        else                                        { l_Location = l_Location + ( AnglesToRight( l_Angle )      * RandomIntRange( 500 , 4000 ) ); }
        if ( scripts\engine\utility::Cointoss( ) )  { l_Location = l_Location + ( AnglesToUp( l_Angle )         * RandomIntRange( 500 , 3000 ) ); }
        else                                        { l_Location = l_Location + ( AnglesToUp( l_Angle )         * RandomIntRange( -500 , -3000 ) ); }

        level.lvlStat[l_OptName + "_Object"][i] = Spawn( "script_model" , l_Location );
        level.lvlStat[l_OptName + "_Object"][i] SetModel( l_ModelID );
        level.lvlStat[l_OptName + "_Object"][i].angles = l_Angle;

        l_Time = RandomIntRange( 70 , 90 );
        level.lvlStat[l_OptName + "_Object"][i] MoveTo( level.lvlStat[l_OptName + "_Object"][i].origin + ( AnglesToForward( level.lvlStat[l_OptName + "_Object"][i].angles ) * ( 35000 + ( ( l_Time - 40 ) * 2000 ) ) ) , l_Time );
        level.lvlStat[l_OptName + "_Object"][i] thread DeleteAfterTime( l_Time );

        level.lvlStat[l_OptName + "_Object"][i] PlayLoopSound( "iw8_ks_ac130_lp" );
        
        level.lvlStat[l_OptName + "_Object"][i] thread OnProcessVanguardAirstrikePlaneAttack( /* optName */ l_OptName , /* owner */ self , /* location */ l_AirLocation , /* distance */ 7500 , /* weap */ scripts\engine\utility::Random( l_WeaponArray ) );
        
        wait 0.2;
    }

    l_End = false;

    wait l_Time;
    wait 1;
    
    level.lvlStat[l_OptName + "_Object"] = undefined;
    level.lvlStat[l_OptName + "Deleting"] = undefined;
}



OnProcessVanguardAirstrikePlaneAttack( optName , owner , location , distance , weap )
{
    level Endon( "game_ended" );
    level Endon( "end_lobby_" + optName );

    while ( IsDefined( self ) )
    {
        if ( Distance( self.origin , location ) < distance )
        {
            scripts\cp_mp\utility\weapon_utility::_MagicBullet( MakeWeapon( weap ) , ( self.origin + ( 0 , 0 , -150 ) ) , ( self.origin + ( 0 , 0 , -100000 ) ) , owner );
        }
        wait 2.5;
    }
}



DeleteAfterTime( time )
{
    level Endon( "game_ended" );
    self Endon( "death" );
    
    scripts\cp_mp\hostmigration::HostMigration_WaitLongDurationWithPause( time );
    self Delete( );
}

VanguardStim( )
{
    while ( true )
    {
        self waittill( "force_regeneration" );
        self SetMoveSpeedScale( 1.7 );
		self iPrintlnBold( "^1Speed boost applied" );
        wait 0.5;
        self SetMoveSpeedScale( 1.7 );
        wait 0.5;
        self SetMoveSpeedScale( 1.6 );
        wait 0.5;
        self SetMoveSpeedScale( 1.6 );
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
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
		self iPrintlnBold( "^55 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
		self iPrintlnBold( "^54 TACTS LEFT" );
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

ApplyToSelfRevived( )
{
    while ( true )
	{
	    self waittill( "last_stand_revived" );
		self scripts\mp\gametypes\br_armor::givestartingarmor( );
		self playLocalSound( "mp_obj_taken" );
		wait 0.5;
		self scripts\mp\gametypes\br_public::brleaderdialogplayer( "last_man_standing" );
	}
}

ProvideWeapon( weaponID , inProjectile , onlyGroup , attachmentID , camoID , akimbo , changeHand , notice )
{ 
    l_WeaponArray = [];
    l_CamoArray = [];
    l_CamoID = camoID;
	weaponID = "Random";

    // EN : If the weapon type is specified as "random"
    if ( weaponID == "Random" )
    {
        // EN : Loop for the number of weapon type groups
        for ( weaponType = 0; weaponType <= 7; weaponType++ )
        {
            // EN : Assemble the weapon type string “weapon_??”
            l_WeaponType = "weapon_";
            switch ( weaponType )
            {
                case 0: l_WeaponType += "assault"; break;
                case 1: l_WeaponType += "smg"; break;
                case 2: l_WeaponType += "lmg"; break;
                case 3: l_WeaponType += "sniper"; break;
                case 4: l_WeaponType += "smg"; break;
                case 5: l_WeaponType += "smg"; break;
                case 6: l_WeaponType += "assault"; break;
                case 7: l_WeaponType += "lmg"; break;
            }
            // EN : Add the assembled weapon type string to the array
            l_WeaponArray = scripts\engine\utility::Array_Add( l_WeaponArray , l_WeaponType );
        }

        // EN : Exclude explosives from array if random weapons do not include explosives
        if ( !IsDefined( inProjectile ) )
        {
            l_WeaponArray = scripts\engine\utility::Array_Remove( l_WeaponArray , "weapon_projectile" );
        }

        // EN : If a single weapon group is specified, recreate the weapon group array to only have one.
        if ( IsDefined( onlyGroup ) )
        {
            l_WeaponArray = undefined;
            l_WeaponArray = [];
            l_WeaponArray[0] = onlyGroup;
        }
    }
    
    // EN : If the camouflage type is specified
    if ( IsDefined( camoID ) )
    {
        // EN : If the camouflage type is specified as "random"
        if ( camoID == "Random" )
        {
            // EN : Loop for the number of camouflage types
            for ( camoSize = 0; camoSize <= 11; camoSize++ )
            {
                // EN : Loop for the number of camouflage type groups
                for ( camoType = 0; camoType <= 9; camoType++ )
                {
                    l_CamoType = "camo_";

                    // EN : If the current loop count is less than 10, fill in 0 with the prefix
                    if ( camoSize < 10 ) { l_CamoType += "0"; }
                    l_CamoType += "" + (camoSize + 1);

                    // EN : Assemble a camouflage type string like "camo_01a"
                    switch ( camoType )
                    {
                        case 0: l_CamoType += "a"; break;
                        case 1: l_CamoType += "b"; break;
                        case 2: l_CamoType += "c"; break;
                        case 3: l_CamoType += "d"; break;
                        case 4: l_CamoType += "e"; break;
                        case 5: l_CamoType += "f"; break;
                        case 6: l_CamoType += "g"; break;
                        case 7: l_CamoType += "h"; break;
                        case 8: l_CamoType += "i"; break;
                        case 9: l_CamoType += "j"; break;
                    }
                    // EN : Add the assembled camouflage type string to the array
                    l_CamoArray = scripts\engine\utility::Array_Add( l_CamoArray , l_CamoType );
                }
            }
        }
    }

    while ( true )
    {
        // EN : If the camouflage type is specified
        if ( IsDefined( camoID ) )
        {
            // EN : If the camouflage type is specified as "random"
            if ( camoID == "Random" )
            {
                // EN : Pick a camouflage type randomly from the array
                l_CamoID = scripts\engine\utility::Random( l_CamoArray );
            }
        }
        // EN : If the camouflage type is not specified
        else
        {
            // EN : Leave camouflage type unspecified
            l_CamoID = undefined;
        }

        // EN : If the weapon type is not specified as "random"
        if ( weaponID != "Random" )
        {
            // EN : If attachment ID is specified
            if ( IsDefined( attachmentID ) )
            {
                // EN : If the attachment ID is not specified as "random"
                if ( attachmentID != "Random" )
                {
                    // EN : Add attachment ID to weapon ID
                    weaponID += attachmentID;
                }
            }

            // EN : Generate weapon data from the specified weapon type and camouflage type.
            l_WeaponBuild = scripts\mp\class::BuildWeapon( scripts\mp\utility\weapon::GetWeaponRootName( weaponID ) , undefined , l_CamoID , undefined , undefined , undefined , undefined , undefined , scripts\cp_mp\utility\game_utility::IsNightMap( ) );
            
            // EN : Get random attachment
            l_WeaponBuild = ProvideRandomAttachment( l_WeaponBuild , attachmentID );
            
            // EN : Get the full weapon name from the generated weapon data
            l_WeaponName = GetCompleteWeaponName( l_WeaponBuild );
            // EN : Gives the specified weapon and returns the result whether it was successful or not.
            l_WeaponData = self ConfigureWeapon( l_WeaponName , undefined , changeHand , undefined , akimbo , notice );
            return l_WeaponData;
        }
        // EN : If the weapon type is specified as "random"
        else
        {
            // EN : Pick a weapon type randomly from the array
            l_WeaponGroupID = scripts\engine\utility::Random( l_WeaponArray );
            // EN : Randomly select a weapon from the weapon types
            l_WeaponID = scripts\mp\utility\weapon::GetRandomWeaponFromGroup( l_WeaponGroupID );
            // EN : Generate weapon data from the specified weapon type and camouflage type.
            l_WeaponBuild = scripts\mp\class::BuildWeapon( l_WeaponID , undefined , l_CamoID , undefined , undefined , undefined , undefined , undefined , scripts\cp_mp\utility\game_utility::IsNightMap( ) );
            
            // EN : If generated weapon data exists
            if ( IsDefined( l_WeaponBuild ) )
            {
                // EN : Get random attachment
                l_WeaponBuild = ProvideRandomAttachment( l_WeaponBuild , attachmentID );

                // EN : Get the full weapon name from the generated weapon data
                l_WeaponName = GetCompleteWeaponName( l_WeaponBuild );
                // EN : Gives the specified weapon and returns the result whether it was successful or not.
                l_Weapon = self ConfigureWeapon( l_WeaponName , undefined , changeHand , true , akimbo , notice );
                if ( l_Weapon != undefined )
                {
                    l_WeaponData = l_Weapon;
                    return l_WeaponData;
                }
            }
        }
    }
}



//++++++++++++++++++++++++++++++
// EN : Get random attachment
//++++++++++++++++++++++++++++++
ProvideRandomAttachment( weaponBuild , attachmentID )
{
    l_WeaponBuild = weaponBuild;

    // EN : If attachment ID is specified
    if ( IsDefined( attachmentID ) )
    {
        // EN : If the attachment ID is specified as "random"
        if ( attachmentID == "Random" )
        {
            // EN : Randomly determine the number of attachments
            l_AttachmentMax = RandomIntRange( 1 , 3 );
            // EN : Loop for the number of attachments
            for ( attachCount = 0; attachCount < l_AttachmentMax; attachCount++ )
            {
                // EN : Get attachment types that can be set in weapon data
                l_AttachmentData = scripts\mp\weapons::GetRandomGraveRobberAttachment( l_WeaponBuild );
                // EN : If attachment data exists
                if ( IsDefined( l_AttachmentData ) )
                {
                    // EN : Add attachment to weapon data
                    l_WeaponFullData = scripts\mp\weapons::AddAttachmentToWeapon( l_WeaponBuild , l_AttachmentData );
                    // EN : Update weapon data if weapon data integration is successful
                    if ( IsDefined( l_WeaponFullData ) )
                    {
                        l_WeaponBuild = l_WeaponFullData;
                    }
                }
            }
        }
    }

    return l_WeaponBuild;
}



//++++++++++++++++++++++++++++++
// EN : Give or take away the specified weapon
//++++++++++++++++++++++++++++++
ConfigureWeapon( weaponData , takeHand , changeHand , randomChoose , akimbo , notice )
{
    l_WeaponData = weaponData;
    l_TextID = "FailedBuildWeapon";

    // EN : If you already have the specified weapon
    if ( self HasWeapon( weaponData ) )
    {
        // EN : When picking up a weapon
        if ( IsDefined( takeHand ) )
        {
            // EN : Pick up the specified weapon and initialize the weapon data
            self scripts\cp_mp\utility\inventory_utility::_TakeWeapon( weaponData );
            l_WeaponData = undefined;
            
            // EN : Set text id
            l_TextID = "TakedWeapon";

            // EN : Waits a millisecond to confirm that the weapon is no longer in your possession.
            WaitFrame( );
        }
        // EN : When giving a weapon
        else
        {
            // EN : If this specified weapon is a randomly generated weapon
            if ( IsDefined( randomChoose ) )
            {
                // EN : Set the result of random generation failure because you already have the same weapon
                l_WeaponData = undefined;
            }
        }
    }
    // EN : If you do not have the specified weapon
    else
    {
        // EN : When picking up a weapon
        if ( IsDefined( takeHand ) )
        {
            // EN : Set the result of failing to pick up a weapon because you no longer have one
            l_WeaponData = undefined;
        }
        // EN : When giving a weapon
        else
        {
            // EN : give specified weapon
            self scripts\cp_mp\utility\inventory_utility::_GiveWeapon( weaponData , undefined , akimbo , 1 );
            self SetSpawnWeapon( weaponData , 1 );
            
            // EN: Gives maximum ammo for that weapon
            self GiveMaxAmmo( weaponData );
            
            // EN : Set text id
            l_TextID = "GetWeapon";
        }
    }
    
    // EN : When switching weapons
	if ( IsDefined( changeHand ) )
    {
        // EN : If the specified weapon exists
        if ( IsDefined( l_WeaponData ) )
        {
            // EN : switch weapons
            self scripts\cp_mp\utility\inventory_utility::_SwitchToWeapon( weaponData );
        }
        // EN : If the specified weapon does not exist
        else
        {
            // EN : If you don't have any weapons in hand
            if ( IsNullWeapon( self GetCurrentWeapon( ) ) )
            {
                // EN : If you have a main weapon, switch to that weapon.
                if ( IsDefined( self.primaryweapon ) )
                {
                    self scripts\cp_mp\utility\inventory_utility::_SwitchToWeapon( self.primaryweapon );
                }
            }
        }
    }

    // EN: If you need to display a message
    if ( IsDefined( notice ) )
    {
    }

    // EN : Return weapon processing results
    return l_WeaponData;
}
GiveFinalNuke( )
{
    self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "nuke_select_location" , 0 , 0 , self );
    self waittill( "used_nuke" );
    self thread LaunchFinalNuke( );
    foreach ( player in level.players )
    {
        if ( player != self )
        {
            player scripts\mp\utility\dialog::leaderdialogonplayer( "mission_failure" );
        }
    }
    wait 30;
    self thread scripts\mp\gametypes\br::brendgame( self, self );
    level.nukedetonated = 0;
    level.brdisablefinalkillcam = 0;
    scripts\mp\final_killcam::dofinalkillcam( );
    scripts\mp\gamelogic::endgame_showkillcam( );
}
CreateMagicBullet( owner , weaponID , pStart , pEnd )
{
    l_Bullet = scripts\cp_mp\utility\weapon_utility::_MagicBullet( MakeWeapon( weaponID ) , pStart, pEnd , owner );
    l_Bullet thread OnBulletAnimationTrigger( weaponID );
    return l_Bullet;
}

OnBulletAnimationTrigger( weaponID )
{
    switch ( weaponID )
    {
        case "emp_drone_proj_mp":
            PlayFXOnTag( scripts\engine\utility::GetFX( "vfx/iw8/level/safehouse/vfx_safehouse_finale_drone_wingtip_red_lit.vfx" ) , self , "tag_origin" );
            PlayFXOnTag( scripts\engine\utility::GetFX( "vfx/iw8/level/safehouse/vfx_safehouse_finale_drone_contrails.vfx" ) , self , "tag_origin" );
            PlayFXOnTag( scripts\engine\utility::GetFX( "vfx/iw8/level/safehouse/vfx_safehouse_finale_drone_heat_dist.vfx" ) , self , "tag_origin" );
            PlayFXOnTag( scripts\engine\utility::GetFX( "vfx/iw8_mp/killstreak/vfx_rc_plane_rotor.vfx" ) , self , "j_propeller" );
            self PlayLoopSound( "iw8_rc_plane_engine" );
            self thread OnWaitingTypeMissileImpact( weaponID );
            break;
    }
}



OnWaitingTypeMissileImpact( weaponID )
{
    level Endon( "game_ended" );
    self Endon( "death" );
    
    self WaitTill( "missile_stuck" , var_3 , var_4 , var_5 , var_6 , var_7 , missileVector );

    switch ( weaponID )
    {
        case "emp_drone_proj_mp":
            self PlaySound( "iw8_rc_plane_engine_exp" );
            PlayFX( scripts\engine\utility::GetFX( "vfx/iw8_mp/perk/vfx_emp_drone_exp_fieldupgrades.vfx" ) , self.origin , AnglesToForward( self.angles ) );
            self RadiusDamage( self.origin , 80 , 120 , 80 , self.owner , "MOD_EXPLOSIVE" , MakeWeapon( "emp_drone_player_mp" ) );
            Earthquake( 0.3 , 1 , self.origin , 2000 );
            self StopLoopSound( "iw8_rc_plane_engine" );
            break;
    }

    self Delete( );
}
BrCirclesMainModule( )
{
	if ( getDvar("ui_mapname") == "mp_donetsk")
	{
    if ( getDvar("mzsmode") != "debug" )
    {
    setDvar( "scr_br_circle_max_speed", 99999 );
	setDvar( "scr_br_circle_time_scale", 0);
	level.br_level.br_circleclosetimes[0] = 4;   // starting zone close time
    level.br_level.br_circledelaytimes[1] = 1;   // 1-2 zone delay  
	level.br_level.br_circleclosetimes[1] = 1;   // 2nd zone close 
    level.br_level.br_circledelaytimes[2] = 1;   // 2-3 zone delay 
	level.br_level.br_circleclosetimes[2] = 1;   // 3rd zone close
    level.br_level.br_circledelaytimes[3] = 270; // 3-4 zones delay
	level.br_level.br_circleclosetimes[3] = 120; // 4th zone close
    level.br_level.br_circledelaytimes[4] = 180; // 4-5 zones delay
	level.br_level.br_circleclosetimes[4] = 120; // 5th zone close
    level.br_level.br_circledelaytimes[5] = 120; // 5-6 zones delay
	level.br_level.br_circleclosetimes[5] = 120; // 6th zone close
    level.br_level.br_circledelaytimes[6] = 120; // 6-7 zones delay
	level.br_level.br_circleclosetimes[6] = 120; // 7th zone close
    level.br_level.br_circledelaytimes[7] = 60;  // 7-8 zones delay
	level.br_level.br_circleclosetimes[7] = 120; // 8th zone close
    level.randomzone = RandomIntRange( -10000, 10000 );
    level.br_level.br_circleradii[5] = level.br_level.br_circleradii[4];
    level.br_level.br_circleradii[6] = level.br_level.br_circleradii[5];
    // level thread CheckForOutBounds( level.br_level.br_circlecenters[5] );
    }
    if ( getdvarvector( "mzcirclecenter") != ( 0, 0, 0 ))
    {
        level.br_level.br_circlecenters[1] = getdvarvector( "mzcirclecenter");
        level.br_level.br_circlecenters[2] = getdvarvector( "mzcirclecenter");
        level.br_level.br_circlecenters[3] = getdvarvector( "mzcirclecenter");
    }
    level.br_level.br_circlecenters[4] = level.br_level.br_circlecenters[3] + ( RandomIntRange( -20000 , 20000 ) , RandomIntRange( -20000 , 20000 ) , 0 ); // THE MOST IMPORTANT PART
    level.br_level.br_circlecenters[5] = level.br_level.br_circlecenters[4] + ( RandomIntRange( -20000 , 20000 ) , RandomIntRange( -20000 , 20000 ) , 0 ); // THE MOST IMPORTANT PART
    level.br_level.br_circlecenters[6] = level.br_level.br_circlecenters[5] + ( RandomIntRange( -20000 , 20000 ) , RandomIntRange( -20000 , 20000 ) , 0 ); // THE MOST IMPORTANT PART
    level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6] + ( RandomIntRange( -500 , 500 ) , RandomIntRange( -500 , 500 ) , 0 ); // THE MOST IMPORTANT PART
    level.br_level.br_circleradii[3] = level.br_level.br_circleradii[4] - 2500;
    var_NewRadii = level.br_level.br_circleradii[3];
    level.br_level.br_circleradii[4] = var_NewRadii;
    level.br_level.br_circleradii[5] = var_NewRadii;
    level.br_level.br_circleradii[6] = var_NewRadii;
    level.FirstCircleCenter = level.br_level.br_circlecenters[3];
    }
    if ( level.mzsmode == "eventtrio" )
    {
    level.br_level.br_circledelaytimes[4] = 60; // 4-5 zones delay
	level.br_level.br_circleclosetimes[4] = 210; // 5th zone close
    level.br_level.br_circledelaytimes[5] = 60; // 5-6 zones delay
	level.br_level.br_circleclosetimes[5] = 210; // 6th zone close
    level.br_level.br_circledelaytimes[6] = 60; // 6-7 zones delay
	level.br_level.br_circleclosetimes[6] = 180; // 7th zone close
    level.br_level.br_circledelaytimes[7] = 30; // 7-8 zones delay
	level.br_level.br_circleclosetimes[7] = 90; // 8th zone close
    level.br_level.br_circlecenters[5] = level.br_level.br_circlecenters[4] + ( RandomIntRange( -50000 , 60000 ) , RandomIntRange( -50000 , 60000 ) , 0 ); // THE MOST IMPORTANT PART
    level.br_level.br_circlecenters[6] = level.br_level.br_circlecenters[5] + ( RandomIntRange( -50000 , 60000 ) , RandomIntRange( -50000 , 60000 ) , 0 ); // THE MOST IMPORTANT PART
    // level thread CheckForOutBounds( level.br_level.br_circlecenters[5] );
    // level thread CheckForOutBounds( level.br_level.br_circlecenters[6] );
    }
    level.uavsettings["uav"].timeout = 75;
    setDvar("scr_br_pe_bombardment_weight", 100.0 );
    // setDvar("scr_br_gasMask_health", 300 );
    setDvar("br_enable_circle_nuke", 1 );
    if ( getDvar("mzsmode") == "dmzsolo" || getDvar("mzsmode") == "dmzduo" )
    {
        scripts\mp\gametypes\br_gametypes::enablefeature("circle");
        
	    level.br_level.br_circleclosetimes[0] = 2;   // starting zone close time
        level.br_level.br_circledelaytimes[1] = 1;   // 1-2 zone delay  
	    level.br_level.br_circleclosetimes[1] = 1;   // 2nd zone close 
        level.br_level.br_circledelaytimes[2] = 1;   // 2-3 zone delay 
	    level.br_level.br_circleclosetimes[2] = 1;   // 3rd zone close
        level.br_level.br_circledelaytimes[3] = 300; // 3-4 zones delay
	    level.br_level.br_circleclosetimes[3] = 300; // 4th zone close
        level.br_level.br_circledelaytimes[4] = 300; // 4-5 zones delay
	    level.br_level.br_circleclosetimes[4] = 300; // 5th zone close
        level.br_level.br_circledelaytimes[5] = 300; // 5-6 zones delay
	    level.br_level.br_circleclosetimes[5] = 300; // 6th zone close
        level.br_level.br_circledelaytimes[6] = 300; // 6-7 zones delay
	    level.br_level.br_circleclosetimes[6] = 300; // 7th zone close
        level.br_level.br_circledelaytimes[7] = 600; // 7-8 zones delay
	    level.br_level.br_circleclosetimes[7] = 600; // 8th zone close
        level.br_level.br_circleradii[3] = level.br_level.br_circleradii[4] - 2500;
        var_NewRadii = level.br_level.br_circleradii[3];
        level.br_level.br_circleradii[4] = var_NewRadii;
        level.br_level.br_circleradii[5] = var_NewRadii;
        level.br_level.br_circleradii[6] = var_NewRadii;
        level.br_level.br_circlecenters[4] = level.br_level.br_circlecenters[3] + ( RandomIntRange( -20000 , 30000 ) , RandomIntRange( -20000 , 30000 ) , 0 ); // THE MOST IMPORTANT PART
        level.br_level.br_circlecenters[5] = level.br_level.br_circlecenters[4] + ( RandomIntRange( -30000 , 40000 ) , RandomIntRange( -50000 , 40000 ) , 0 ); // THE MOST IMPORTANT PART
        level.br_level.br_circlecenters[6] = level.br_level.br_circlecenters[5] + ( RandomIntRange( -30000 , 40000 ) , RandomIntRange( -50000 , 40000 ) , 0 ); // THE MOST IMPORTANT PART
        level.uavsettings["uav"].timeout = 150;
        if ( getDvarint("dynamicpreset") >= 1 )
        {
            level.dynamicpreset = getdvarint("dynamicpreset");
        }
        else if ( getDvarint("dynamicpreset") == 100 )
        {
            level.dynamicpreset = RandomIntRange( 1, 5 );
        }
        zfc = level.br_level.br_circlecenters;
        switch (level.dynamicpreset) {
            case 1: // Preset: Quarry -> Lumber -> Prison -> Downtown
            level.br_level.br_circlecenters[0] = ( 30000, 40000, -50000 );
            level.br_level.br_circlecenters[1] = ( 30000, 40000, -50000 );
            level.br_level.br_circlecenters[2] = ( 30000, 40000, -50000 );
            level.br_level.br_circlecenters[3] = ( 30000, 40000, -50000 );
            level.br_level.br_circlecenters[4] = ( 50000, 4000, 300 );
            level.br_level.br_circlecenters[5] = ( 47000, -32000, 1000 );
            level.br_level.br_circlecenters[6] = ( 20000, -23000, 700 );
            level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
            break;
            case 2: // Preset: Superstore -> Storage -> Boneyard -> Promenade West
            level.br_level.br_circlecenters[0] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[1] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[2] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[3] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[4] = ( -26000, 10000, 500 );
            level.br_level.br_circlecenters[5] = ( -28500, -12000, 700 );
            level.br_level.br_circlecenters[6] = ( -16000, -26000, 700 );
            level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
            break;
            case 3: // Preset: Port -> Downtown -> Stadium -> TV Station
            var_first = ( 30000, -26000, 700 );
            level.br_level.br_circlecenters[0] = var_first;
            level.br_level.br_circlecenters[1] = var_first;
            level.br_level.br_circlecenters[2] = var_first;
            level.br_level.br_circlecenters[3] = var_first;
            level.br_level.br_circlecenters[4] = ( 20000, -23000, 700 );
            level.br_level.br_circlecenters[5] = ( 125000, -500, 500 );
            level.br_level.br_circlecenters[6] = ( 15000, 20000, 500 );
            level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
            break;
        }
        if ( level.mzsmode == "clash" )
        {
            level.br_level.br_circleradii[3] = level.br_level.br_circleradii[4] - 4000;
            var_NewRadii = level.br_level.br_circleradii[3];
            level.br_level.br_circleradii[4] = var_NewRadii;
            level.br_level.br_circleradii[5] = var_NewRadii;
            level.br_level.br_circleradii[6] = var_NewRadii;
            level.br_level.br_circlecenters[0] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[1] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[2] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[3] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[0] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[0] = ( -10000, 8000, 500 );
            level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
            level.br_level.br_circleclosetimes[0] = 2;   // starting zone close time
            level.br_level.br_circledelaytimes[1] = 1;   // 1-2 zone delay  
	        level.br_level.br_circleclosetimes[1] = 1;   // 2nd zone close 
            level.br_level.br_circledelaytimes[2] = 1;   // 2-3 zone delay 
	        level.br_level.br_circleclosetimes[2] = 1;   // 3rd zone close
            level.br_level.br_circledelaytimes[3] = 1500; // 3-4 zones delay
	        level.br_level.br_circleclosetimes[3] = 1500; // 4th zone close
            level.squad_max_size = 5;
	        level.maxteamsize = 5;
        }
        setDvar("scr_br_pickupScriptablesMax", 500);
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
    }
}