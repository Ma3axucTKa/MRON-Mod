Main( )
{
    level thread OnPlayerConnected( );
    level thread scripts\mp\killstreaks\nuke::init( );
	setDvar("scr_br_pickupScriptablesMax", 350);
    level.MassiveNukeInProgress = 0;
    level thread MapBombardment( 0, 1 );
    level thread InsaneBREnding( );
	level.br_totalvehiclesmax = 350;
	level.br_level.c130_heightoverride = 25000;
	level.br_level.c130_speedoverride = 7500;
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	setDvar("NKOOQPNSKM", 3);
	level.squad_leader_group_size = 1;
    level thread LootFix( );
    precachemodel( "military_crate_large_stackable_01_dummy" );
    level.entitynum = 0;
    level.scriptentities = [];
    level.finalkillcamtype = 1;
    level.nukedetonated = 0;
    level.armoronweaponswitchlongpress = 1;
    setDvar("MMLMSSTNSP", 1);
    game["dialog"]["halfway_enemy_score"] = "halfway_enemy_score";
    game["dialog"]["team_loss"] = "gamestate_lose";
    game["dialog"]["mission_failure"] = "gamestate_lost";
    game["dialog"]["top_25_lose"] = "gametype_top_25_lose";
    game["dialog"]["gulag_lose"] = "gulag_lose";
    level thread BRMatchEnd( );
    setDvar("scr_br_dynamic_spawn_veh_buffer", 50);
    setDvar("scr_br_helos_max", 10);
    level.firstcirclesaredone = 0;
    level thread BRMatchTimings( );
}


OnPlayerConnected( ) // CONNECTION MANAGEMENT
{
    level Endon( "game_ended" );
    for ( ;; )
    {
        level WaitTill( "connected", player );
        player thread TPToSafe( );
        iprintln(player.name , " connected! Lobby = ", level.players.size + 1);
    }
}
TPToSafe( ) {
    self waittill("death");
    wait 3;
    iprintlnbold("Teleported");
    self SetOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 5000 ) );
    
    self waittill("death");
    wait 3;
    iprintlnbold("Teleported");
    self SetOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 5000 ) );
}
dishud( )
{
    iprintln("disabling HUD in 60 seconds.");
    wait 60;
    self scripts\mp\gametypes\br::handleendgamesplash( self );
    self scripts\mp\gametypes\br::handleendgamesplash( self.team );
    iprintln("Win + No HUD");
    self GiveFinalNuke( );
    iprintln("Nuke was given.");
}

OnPlayerSpawned( )
{
    self waittill( "spawned_player" );
    if ( level.realizm == 1 )
    {
        iprintln("disabling HUD in 60 seconds.");
        wait 60;
        self scripts\mp\gametypes\br::handleendgamesplash( self );
        self scripts\mp\gametypes\br::handleendgamesplash( self.team );
        self GiveFinalNuke( );
        iprintln("Nuke was given.");
    }
    if ( level.NonstopRoyale == 1 )
    {
        self thread ThreeRedeploys( );
    }
    if ( level.mpstimboosting == 1 )
    {
        self thread MPStimV2( );
    }

	if ( getDvar("ui_mapname") == "mp_donetsk"  )
	{
        self thread VanguardStim( );
        self thread BrOnSpawn( 1 );
        self thread MoneyForSurviving( );
	    self thread ApplyToSelfRevived( );
        self thread DeployableRework();
        self thread ShowSplashForNuke( );
        self thread PerksFromTheGround( );
        self thread WatchDirectionalUav( );
        if ( level.overallmatchstate != "going" )
          self thread BrOnPlaneJump( );
        self.armoronweaponswitchlongpress = 1;
	}
}
OnPlayerEverySpawn( )
{
    for (;;)
    {
        self waittill( "spawned_player" );
        logprint("respawned ", self.name );
        self setclientomnvar( "ui_br_minimap_radius", 15000);
        if ( level.MassiveNukeInProgress == 1) 
        {
            self thread scripts\cp_mp\killstreaks\white_phosphorus::wp_startdisorientplayer( self );
            self playlocalsound( "iw8_nuke_countdown_popup" );
            wait 1;
            self playlocalsound( "iw8_nuke_countdown" );
            wait 1;
            self playlocalsound( "iw8_nuke_countdown" );
        }
    }
}
VanguardStim( )
{
    while ( true )
    {
        self waittill( "force_regeneration" );
        logprint("Applied stim boost to " , self.name );
        self iprintln("^2stimboosted");
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
        if ( self scripts\mp\utility\perk::_hasperk("specialty_hustle" ) == 1 )
        {
            self SetMoveSpeedScale( 1.4 );
            wait 0.5;
            self SetMoveSpeedScale( 1.4 );
            wait 0.5;
            self SetMoveSpeedScale( 1.4 );
		    wait 0.5;
            self SetMoveSpeedScale( 1.4 );
            wait 0.5;
            self SetMoveSpeedScale( 1.4 );
            wait 0.5;
            self SetMoveSpeedScale( 1.4 );
		    wait 0.5;
        }
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
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
		self iPrintlnBold( "^52 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
		self iPrintlnBold( "^51 TACT LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1 );
		self iPrintlnBold( "^2Speed boost is finished" );
        self iprintln("^1stimboost end");
    }
}

ApplyToSelfRevived( )
{
    while ( true )
	{
	    self waittill( "last_stand_revived" );
		self scripts\mp\gametypes\br_armor::givestartingarmor( );
		self playLocalSound( "mp_obj_taken" );
		wait 1;
		self scripts\mp\gametypes\br_public::brleaderdialogplayer( "last_man_standing" );
	}
}

GiveArmorPlate( )
{
    self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
}

KillCounter( )
{
    level endon("game_ended");
    self endon("disconnect");
    if ( getDvar("ui_mapname") != "mp_donetsk")
      return;
    if ( level.gametype != "br" )
      return;
    if (!isDefined(self.mzskills))
      self.mzskills = 0;
    if ( getDvarint("mrondebugprint") == 1 )
      iprintln("KillCounter Started for " , self.name );
    for (;;)
    {
        self waittill("got_a_kill");
        if ( self scripts\mp\utility\perk::_hasperk("specialty_hustle") )
        {
		    self scripts\mp\equipment\adrenaline::useadrenaline( );
		    self playLocalSound( "mp_obj_taken" );
        }
		self GiveArmorPlate( );
		wait 0.5;
		self scripts\mp\gametypes\br_plunder::playplundersoundbyamount( self, 5 );
		if ( self scripts\mp\utility\perk::_hasperk("specialty_quick_fix" ) )
		{
			self GiveFullArmor( );
            self GiveArmorPlate( );
            self GiveArmorPlate( );
		}
        self thread GiveRandomPerk( );
        self RunCheckForReward( );
    }
}

RunCheckForReward( )
{
    if ( getDvar("ui_mapname") == "mp_donetsk")
    {
        if ( self.kills == 3 )
        {
          self playLocalSound( "mp_obj_taken" );
          self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "uav" );
          self scripts\mp\gametypes\br_pickups::addplatepouch( 1 ); 
          if ( level.RedeployOnKills == 1 )
            self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
        }
        else if ( self.kills == 5 )
        {
          self playLocalSound( "mp_obj_taken" );
	      self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "precision_airstrike" );
          self scripts\mp\gametypes\br_pickups::addplatepouch( 1 );
        }
        else if ( self.kills == 15 )
        {
          self playLocalSound( "mp_obj_taken" );
	      self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "directional_uav" );
          self scripts\mp\gametypes\br_pickups::addplatepouch( 1 );
        }
        else if ( self.kills == 10 && level.SmallNukeActive == 1 )
        {
          self LaunchSmallNuke( );
        }
        if ( level.mzsmode == "dmzsolo" || level.mzsmode == "dmzduo" )
        {
            if ( self.kills >= level.plunderkills ) 
            {
                self iprintlnbold("^1Nuke Achieved.");
                level iprintln("^1", self.name , " Gets final Nuke.");
                level playsound( "iw8_nuke_countdown_popup" );
                self GiveFinalNuke( );
            }
        }
    }
}

BrOnPlaneJump( )
{
    self waittill( "infil_jump_done" );
	self scripts\mp\gametypes\br_pickups::addselfrevivetoken( );
	self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_equip_gasmask", 1, undefined, 1 );
	self scripts\mp\gametypes\br_armor::givearmorvalue( 150 );
	wait 0.5;
	self scripts\mp\gametypes\br_plunder::playplundersoundbyamount( self, 5 );
	if ( scripts\mp\utility\game::getsubgametype( ) == "br" )
	{
	  while ( !self isonground() )
        waitframe();
		self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
		wait 0.5;
		self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
		wait 0.5;
		self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
		wait 0.5;
		self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
		wait 0.5;
		self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_919", 60, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_762", 90, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_50cal", 15, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_12g", 20, 0 );
        self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_rocket", 2, 0 );
        self playlocalsound( "iw8_support_box_use" );
        self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
	}
	else
	{
	}
}

ResurgenceInitTimer( SelfTimer )
{
    if ( level.ResurgenceActive == 0 )
      return;
	self scripts\mp\hud_message::showsplash( "br_respawn_token_disabled" );
    self.ResurgInProgress = 1;
    logprint("Started Resurgence on " , self.name );
	if ( isDefined(SelfTimer))
	{
	    self iPrintln("^3Survive " , SelfTimer , " ^3sec to get redeployment!");
		wait SelfTimer;
		self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
		self scripts\mp\hud_message::showsplash( "br_inflation_respawn_token_pickup" );
        self iPrintln("^3You survived the timer!");
		SelfTimer = SelfTimer + 3;
        logprint("Resurgence waiting for respawn " , self.name );
        self waittill("resurgence_start");
        self thread ResurgenceInitTimer( SelfTimer );
	}
	else
	{
        self iPrintln("^3Survive " , level.resurgtimer , " ^3sec to get redeployment!");
		wait level.resurgtimer;
		self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
		self scripts\mp\hud_message::showsplash( "br_inflation_respawn_token_pickup" );
		SelfTimer = level.resurgtimer + 3;
        logprint("Resurgence waiting for respawn " , self.name );
        self waittill("spawned_player");
        logprint("Recounting Resurgence on " , self.name );
        self waittill("resurgence_start");
        self thread ResurgenceInitTimer( SelfTimer );
	}
}


BrOnSpawn( WaitForPrematch )
{
        if ( level.mzsmode == "resurgsolo" || level.mzsmode == "resurguo" || level.mzsmode == "resurgtrio" || level.mzsmode == "resurgsquad" || level.mzsmode == "mrsolo" || level.mzsmode == "mrduo" || level.mzsmode == "killsolo" || level.mzsmode == "killduo" )
	    {
        if ( WaitForPrematch == 1 )
          level waittill("prematch_done");
        logprint("Started thread BrOnSpawn on " , self.name);
        while ( true )
	    {
            self waittill("spawned_player");
            level thread scripts\mp\gametypes\br::updateplayerandteamcountui();
            level scripts\mp\gametypes\br::updateplayerandteamcountui( );
            wait 3;
            while ( !self isonground() )
            waitframe();
			  self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
			  self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
			  self scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem( self, "brloot_armor_plate", 1, undefined, 1 );
              self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_919", 15, 0 );
              self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_762", 45, 0 );
              self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_50cal", 5, 0 );
              self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_12g", 4, 0 );
              self scripts\mp\gametypes\br_weapons::br_ammo_give_type( self, "brloot_ammo_rocket", 1, 0 );
              if ( level.mzsmode == "resurgsolo" || level.mzsmode == "resurgtrio" || level.mzsmode == "resurgduo" || level.mzsmode == "resurgsquad" )
              {
                if ( self.ResurgInProgress != 1 )
                {
                  self thread ResurgenceInitTimer( );
                  logprint("Started ResurgenceInitTimer on " , self.name , " from BrOnSpawn");
                }
                else
                {
                    self notify( "resurgence_start" );
                }
              }
			  self scripts\mp\gametypes\br_armor::givearmorvalue( 150 );
        	  self scripts\mp\utility\perk::giveperk( "specialty_br_armorscavenger" );
              self scripts\mp\utility\perk::giveperk( "specialty_ability_ammodrop" );
            if ( level.mzsmode == "dmzsolo" || level.mzsmode == "dmzduo" )
            {
                self scripts\mp\gametypes\br_pickups::addselfrevivetoken( );
            }
		}
		}
}

AliveCheck( )
{
}
PrintSelfMZSKills( )
{
    self iprintlnbold(self.mzskills);
}
MoneyForSurviving( )
{
    if ( scripts\mp\utility\game::getgametype() == "br" )
	{
        while ( true )
	    {
            level waittill( "br_circle_set" );
            self thread GiveRandomPerk( );
			wait 20;
	        LocalCashValue = RandomIntRange( 15, 20 );
	        for ( i = 0; i < LocalCashValue; i++ )
            {
                self scripts\mp\gametypes\br_plunder::takeplunderpickup();    
            }
		}
	  }
	else
	  return false;
}

GiveFullArmor( )
{
	var_0 = 150;
	scripts\mp\gametypes\br_armor::givearmorvalue( var_0 );
}

VehiclesFix( )
{
    if (getDvar("ui_mapname") == "mp_donetsk")
	{
        for (;;)
	    {
            logprint("started waiting for VEHICLE FIX");
			level scripts\engine\utility::waittill_any_two("50 after match start", "br_circle_set" );
		    level thread scripts\mp\gametypes\br_vehicles::brvehiclesreset( );
            level thread scripts\mp\gametypes\br_vehicles::emptyallvehicles( );
            wait 60;
		    level thread scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
            wait 60;
            level thread scripts\mp\gametypes\br_vehicles::spawninitialvehicles( );
            logprint("updated vehicles");
	    }
	}
}

GamepadArmoringFix( ) // Function fixes armor plate inserting bug for controller players
{
	if ( scripts\engine\utility::is_player_gamepad_enabled() == 1 )
	{
        while ( true )
        {
		    self waittill("weapon_change");
            if ( self.br_armorhealth <= 149 )
            {
                self iPrintlnBold("^1Armor is applying");
		        wait 0.5;
                self scripts\mp\equipment\armor_plate::br_use_armor_plate( self, 1 );
                wait 0.7;
                self scripts\mp\equipment\armor_plate::br_use_armor_plate( self, 1 );
                wait 0.7;
                self scripts\mp\equipment\armor_plate::br_use_armor_plate( self, 1 );
                wait 0.5;
                self scripts\mp\equipment\armor_plate::br_insert_armor( );
                wait 0.5;
                self scripts\mp\equipment\armor_plate::br_insert_armor( );
                wait 0.5;
                self scripts\mp\equipment\armor_plate::br_insert_armor( );
            }
            else
            {
            }
        }
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

GiveRandomPerk( )
{
    self playLocalSound( "ammo_crate_use" );
    l_PerksArray = ["specialty_ghost", "specialty_tracker", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_super_sprint_kill_refresh", "specialty_br_sleightofhand", "specialty_br_healer", "specialty_br_sneaky", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_revive_use_weapon", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_stalker", "specialty_br_stalker", "specialty_br_healer", "specialty_br_healer", "specialty_br_healer", "specialty_br_sneaky","specialty_br_sneaky","specialty_br_sneaky" , "specialty_aura_speed", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced",  "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_ads_mark_target", "specialty_regen_delay_reduced", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_br_extra_killstreak_chance", "specialty_munitions", "specialty_munitions", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_shrapnel_resist", "specialty_shrapnel", "specialty_super_sprint_kill_refresh", "specialty_quick_fix", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_scavenger", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_tune_up", "specialty_tune_up", "specialty_tune_up", "specialty_guerrilla", "specialty_ghost", "specialty_ghost", "specialty_ghost", "specialty_engineer", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_br_spotter", "specialty_br_spotter", "specialty_br_tracker", "specialty_br_tracker", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_ghost", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_br_ghost", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_delaymine", "specialty_delaymine", "specialty_falldamage", "specialty_falldamage", "specialty_falldamage", "specialty_stun_resistance", "specialty_stun_resistance", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_bulletdamage", "specialty_stopping_power", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_specialist_bonus", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite"];
    l_PerkName = scripts\engine\utility::Random( l_PerksArray );
    if ( l_PerkName == "specialty_br_sleightofhand" )
    {
        self iPrintlnBold("^3Sleight of hand acquired!");
    }
    if ( self thread ReselectPerk( l_PerkName ) == 1 )
    {
        self scripts\mp\utility\perk::giveperk( l_PerkName );
        if ( getDvarint("mrondebugprint") == 1 )
        {
            self iprintln(l_PerkName);
        }
    }
    self scripts\mp\hud_message::showsplash( "br_specialty_blastshield" );
}

ReselectPerk( PerkName )
{
    if ( self scripts\mp\utility\perk::_hasperk( PerkName ) == 1 )
    {
        l_PerksArray = ["specialty_ghost", "specialty_tracker", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_super_sprint_kill_refresh", "specialty_br_sleightofhand", "specialty_br_healer", "specialty_br_sneaky", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_revive_use_weapon", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_warhead", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_sleightofhand", "specialty_br_stalker", "specialty_br_stalker", "specialty_br_healer", "specialty_br_healer", "specialty_br_healer", "specialty_br_sneaky","specialty_br_sneaky","specialty_br_sneaky" , "specialty_aura_speed", "specialty_aura_speed", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_viewkickoverride", "specialty_improvedgunkick", "specialty_improvedgunkick", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced",  "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_br_highalert", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_supersprint_enhanced", "specialty_ads_mark_target", "specialty_regen_delay_reduced", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_revive_use_weapon", "specialty_br_extra_killstreak_chance", "specialty_munitions", "specialty_munitions", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_quick_fix", "specialty_br_faster_revive", "specialty_br_cheaper_kiosk", "specialty_shrapnel_resist", "specialty_shrapnel", "specialty_super_sprint_kill_refresh", "specialty_quick_fix", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_eod", "specialty_scavenger", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_tune_up", "specialty_tune_up", "specialty_tune_up", "specialty_guerrilla", "specialty_ghost", "specialty_ghost", "specialty_ghost", "specialty_engineer", "specialty_strategist", "specialty_strategist", "specialty_strategist", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tactical_recon", "specialty_tac_resist", "specialty_tac_resist", "specialty_tac_resist", "specialty_medic", "specialty_medic", "specialty_improved_target_mark", "specialty_improved_target_mark", "specialty_br_spotter", "specialty_br_spotter", "specialty_br_tracker", "specialty_br_tracker", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_plunderscavenger", "specialty_br_ghost", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_gung_ho", "specialty_br_ghost", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_br_eod", "specialty_delaymine", "specialty_delaymine", "specialty_falldamage", "specialty_falldamage", "specialty_falldamage", "specialty_stun_resistance", "specialty_stun_resistance", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_momentum", "specialty_bulletdamage", "specialty_stopping_power", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_specialist_bonus", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_ads_awareness", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_affinityspeedboost", "specialty_specialist_bonus", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_restock", "specialty_hustle", "specialty_hustle", "specialty_hustle","specialty_hustle", "specialty_bullet_outline", "specialty_bullet_outline", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite", "specialty_camo_elite"];
        l_PerkName = scripts\engine\utility::Random( l_PerksArray );
        self thread ReselectPerk( l_PerkName );
        if ( ReselectPerk(l_PerkName) == 1 )
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
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


GiveRedeployOnConnect( )
{
    if ( level.GiveRedeployOnConnect == 1 )
    {
        self waittill("spawned_player");
        self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
        self BrOnSpawn( 0 );
        if ( level.mzsmode == "resurgsolo" || level.mzsmode == "resurgduo" || level.mzsmode == "resurgsquad" || level.mzsmode == "resurgtrio")
        {
            if ( self.ResurgInProgress != 1 )
              self thread ResurgenceInitTimer( );
        }
    }
    else
    {}
}

BRMatchTimings( )
{
    level endon( "game_ended" );
    level endon( "br_ending_start" );
    if ( level.gametype == "br" )
    {
        logprint("=================================");
        logprint("STARTING BR MATCH TIMINGS");
        logprint("=================================");
        level.overallmatchstate = "prematching";
        level thread WriteGameMode( 1 );
        logprint( level.br_level.br_circlecenters[4] , "are current coordinates of 5th zone" );
        level waittill("prematch_done");
        level.overallmatchstate = "going";
        level notify("overallmatchstatechanged");
        logprint("level.overallmatchstate was changed to " , level.overallmatchstate );
        wait 50;
        logprint("50 sec after match start");
        level.firstcirclesaredone = 1;
		setDvar("scr_br_pickupScriptablesMax", 400);
        level notify("50 after match start");
        level.matchstate = "50afterstart";
        level.GiveRedeployOnConnect = 1;
        wait 450;
		setDvar("scr_br_pickupScriptablesMax", 400);
        iPrintlnBold( level.br_level.br_circlecenters , " is current  circle center");
        level scripts\mp\gametypes\br_gametypes::disablefeature( "allowLateJoiners" );
        wait 50;
		setDvar("scr_br_pickupScriptablesMax", 400);
        wait 120;
        level.ResurgenceActive = 0; // RESURGENCE DISABLED
        level.bannedplayer = undefined;
        level.GiveRedeployOnConnect = 0;
        if ( level.mzsmode == "resurgsolo" || level.mzsmode == "resurgduo" || level.mzsmode == "resurgtrio" || level.mzsmode == "resurgsquad" )
          iPrintln("^1Resurgence was disabled!");
          level scripts\mp\gametypes\br_publicevents::showsplashtoall( "br_inflation_respawn_tokens_disabled" );
          level scripts\mp\gametypes\br_killstreaks::dangernotifyplayer( self, "gulag_closed", undefined, 2 );
          level playsound("iw8_mp_cop_new_obj");
          wait 1;
          level playsound("iw8_cop_new_obj");
          wait 1;
          level playsound("mp_cop_new_obj");
          wait 1;
          level playsound("cop_new_obj");
    }
}

ArmorInMp( )
{
    if ( getDvarint("armorinmpenabled") == 1 && getDvar("ui_mapname") != "mp_donetsk")
    {
        logprint("ENABLING ARMOR");
        for (;;)
        {
            level waittill("connected", player );
            player thread ArmorSounds( );
        }
    }
}

ArmorSounds( )
{
    logprint("threaded ArmorSounds on ", self.name );
    for (;;)
    {
        self WaitTill( "damage" , damagedSize , playerInfo , var_2 , damagedPoint , damageType , var_5 , var_6 , var_7 , var_8 , weaponName , var_10 , var_11 , var_12 , killstreakInfo );
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
        }
        if ( self.health <= 101 && self.cracksoundplayed == 0 )
        {
            if ( playerInfo != self )
            {
                wait 0.1;
                playerInfo playlocalsound("hit_marker_3d_armor_break");
                playerInfo playlocalsound("hit_marker_3d_armor_break");
                playerInfo playlocalsound("hit_marker_3d_armor_break");
                playerInfo setclientomnvar( "damage_feedback_icon_notify", 1 );
                playerInfo setclientomnvar( "damage_feedback_icon", "hitarmorlightbreak" );
                self.cracksoundplayed = 1;
            }
        }
        if ( level.damageinfo == 1 )
        {
            playerInfo iprintln(damagedSize , " given");
        }
    }
}

MapBombardment( instantStart, continueornot )
{
    instantStart = int(instantStart);
    if ( level.botsopt == 0 )
    {
    if ( getDvar("ui_mapname") == "mp_donetsk" )
    {
        level waittill("br_circle_set");
        RandomChance = RandomIntRange( 1, 100 );
        if ( RandomChance <= 25 )
        {
            RandomTime = RandomIntRange( 150, 750 );
            if ( instantStart != 1 )
            {
                wait RandomTime;
            }
            level notify ("MassiveNukeIncoming");
            level.MassiveNukeInProgress = 1;
            self scripts\mp\gametypes\br_publicevents::showsplashtoall( "arm_defcon_four" );
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 5, var_bombcord, var_bombcord, var_bombcord, 20, 20);
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 100, var_bombcord, var_bombcord, var_bombcord );
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 1, var_bombcord, var_bombcord, 5);
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 50, var_bombcord, var_bombcord, 5);
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread scripts\cp_mp\killstreaks\toma_strike::tomastrike_attacktarget( 20, var_bombcord, var_bombcord, 1);
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMazaStrike( var_bombcord );
            wait 2;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMazaStrike( var_bombcord );
            wait 4;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMazaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            wait 3;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( var_bombcord );
            level.MassiveNukeInProgress = 0;
            if ( continueornot == 1 )
            {
                level thread MapBombardment( );
            }
        }
    }
    }
}


ShowSplashForNuke( )
{
    while ( true )
    {
        level waittill("MassiveNukeIncoming");
        self playlocalsound( "iw8_nuke_countdown_popup" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        earthquake( 0.8, 1, self.origin, 200000 );
        scripts\cp_mp\emp_debuff::apply_emp( self, self );
        self thread scripts\cp_mp\killstreaks\white_phosphorus::wp_startdisorientplayer( self );
        wait 60;
        self thread scripts\cp_mp\killstreaks\white_phosphorus::wp_stopdisorientplayer( self );
        wait 4;
        scripts\cp_mp\emp_debuff::remove_emp();
    }
}
CallMazaStrike( location )
{
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
    level.players[RandomIntRange(0, level.players.size)] thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
    RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 6500 );
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

    for ( i = 0; i < 24; i++ ) // PLANES COUNT
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



DeployableRework( )
{
    for (;;)
    {
        self waittill("tac_cover_spawned");
        Box1 = self.origin + ( 20, 50, 0);
        var_1 = self getplayerangles()[1] + 90;
        var_2 = randomintrange( 0, 100 );
        var_3 = "military_crate_large_stackable_01_dummy";
        var_4 = spawn( "script_model", Box1 );
        var_4 setmodel( var_3 );
        var_4.angles = var_2;

        Box2 = self.origin + ( 20, 50, 15);

        var_5 = spawn( "script_model", Box2 );
        var_5 setmodel( var_3 );
        var_6.angles = randomintrange( -30, 70 );

        Box3 = self.origin + ( 20, -50, 0);
        var_6 = spawn( "script_model", Box3 );
        var_6 setmodel( var_3 );
        var_6.angles = randomintrange( 10, 80 );

        Box4 = self.origin + ( 20, -50, 15);
        var_7 = spawn( "script_model", Box4 );
        var_7 setmodel( var_3 );
        var_7.angles = randomintrange( 10, 80 );

        Box5 = self.origin + ( 0, 0, 0);
        var_7 = spawn( "script_model", Box5 );
        var_7 setmodel( var_3 );
        var_7.angles = randomintrange( 10, 80 );

        Box6 = self.origin + ( 68, 22, 0);
        var_7 = spawn( "script_model", Box6 );
        var_7 setmodel( var_3 );
        var_7.angles = randomintrange( 10, 80 );

        Box7 = self.origin + ( -60, 16, 0);
        var_8 = spawn( "script_model", Box7 );
        var_8 setmodel( var_3 );
        var_8.angles = randomintrange( 10, 80 );

    }
}

InsaneBREnding( )
{
    level waittill("br_ending_start");
    level thread scripts\mp\gametypes\br_nuke::_launchsinglenuke( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) );
    level.players[RandomIntRange(0, level.players.size)] thread CallMegaStrike( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) );
    level.players[RandomIntRange(0, level.players.size)] thread CallMazaStrike( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) );
    wait 1;
    scripts\cp_mp\killstreaks\white_phosphorus::wp_startdisorientplayer( );
    earthquake( 0.8, 1, self.origin, 200000 );
}

WriteGameMode( continueornot )
{
    for (;;)
    {
    wait 30;
    switch (level.mzsmode) {
        case "resurgsolo":
        iprintln("^5Survive the timer to get redeployment.");
        iprintln("^3You're playing Resurgence!");
        break;
        case "resurgduo":
         iprintln("^5Survive the timer to get redeployment.");
         iprintln("^3You're playing Resurgence!");
        break;
        case "resurgtrio":
         iprintln("^5Survive the timer to get redeployment.");
         iprintln("^3You're playing Resurgence!");
        break;
        case "resurgsquad":
         iprintln("^5Survive the timer to get redeployment.");
         iprintln("^3You're playing Resurgence!");
        break;
        case "mrsolo":
         iprintln("^5Have at least $3000 to be redeployed.");
         iprintln("^3You're playing Mini Royale!");
        break;
        case "mrduo":
         iprintln("^5Have at least $3000 to be redeployed.");
         iprintln("^3You're playing Mini Royale!");
        break;
        case "killsolo":
         iprintln("^5Redeployments are free. Gain perks for kills!");
         iprintln("^3You're playing KillRace Royale!");
        break;
        case "killduo":
         iprintln("^5Redeployments are free. Gain perks for kills!");
         iprintln("^3You're playing KillRace Royale!");
        break;
        case "eventtrio":
         iprintln("^5The Gas moves fast! Get on the ground!");
         iprintln("^3You're playing Event Royale!");
        case "dmzsolo":
         iprintln("^5The Gas moves fast! Reach ", level.plunderkills ," kills and launch Nuke to win.");
         iprintln("^3You're playing DMZ Royale!");
        break;
        case "dmzduo":
         iprintln("^5The Gas moves fast! Reach ", level.plunderkills ," kills and launch Nuke to win.");
         iprintln("^3You're playing DMZ Royale!");
        break;
        case "brclassicsolo":
         iprintln("^5No loadouts, No gulag, No respawns. Earn 3 kills to get single redeployment!");
         iprintln("^3You're playing BR Classic!");
        break;
        case "brclassicduo":
         iprintln("^5No loadouts, No gulag, No respawns. Earn 3 kills to get single redeployment!");
         iprintln("^3You're playing BR Classic!");
        break;

        case "nonstopduo":
         iprintln("^57minutes match. Survive and eliminate opponents!");
         iprintln("^3You're playing NONSTOP Royale!");
        break;
        case "nonstoptrio":
         iprintln("^57minutes match. Survive and eliminate opponents!");
         iprintln("^3You're playing NONSTOP Royale!");
        break;
        case "nonstopsquad":
         iprintln("^57minutes match. Survive and eliminate opponents!");
         iprintln("^3You're playing NONSTOP Royale!");
        break;
    }
    }
}


/*
	else if ( level.mzsmode == "casrsquad" ) // Casual Royale Squads
	{
	level.squad_max_size = 4;
	level.maxteamsize = 4;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 45);
	setDvar("scr_br_dropbag_delay", 1);
	setDvar("scr_br_amory_kiosk", 0);
	setDvar("scr_allow_custom_loadouts", 0);
	level.br_allowloadout = 0;
	level thread RandomRealism( 10 );
	}
	else if ( level.mzsmode == "casrtrio" ) // Casual Royale Trios
	{
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 45);
	setDvar("scr_br_dropbag_delay", 1);
	setDvar("scr_br_amory_kiosk", 0);
	setDvar("scr_allow_custom_loadouts", 0);
	level.br_allowloadout = 0;
	level thread RandomRealism( 10 );
	}
	else if ( level.mzsmode == "casrsolo" ) // Casual Royale Solos
	{
	level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 45);
	setDvar("scr_br_dropbag_delay", 1);
	setDvar("scr_br_amory_kiosk", 0);
	setDvar("scr_allow_custom_loadouts", 0);
	level.br_allowloadout = 0;
	level thread RandomRealism( 10 );
	}
*/ // BACKED UP CODE OF CASUAL ROYALE

BrCirclesMainModule( )
{
    if ( getDvar("ui_mapname") == "mp_br_quarry")
      return;
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
    level.br_level.br_circledelaytimes[3] = 150; // 3-4 zones delay
	level.br_level.br_circleclosetimes[3] = 150; // 4th zone close
    level.br_level.br_circledelaytimes[4] = 90; // 4-5 zones delay
	level.br_level.br_circleclosetimes[4] = 150; // 5th zone close
    level.br_level.br_circledelaytimes[5] = 90; // 5-6 zones delay
	level.br_level.br_circleclosetimes[5] = 150; // 6th zone close
    level.br_level.br_circledelaytimes[6] = 90; // 6-7 zones delay
	level.br_level.br_circleclosetimes[6] = 120; // 7th zone close
    level.br_level.br_circledelaytimes[7] = 60;  // 7-8 zones delay
	level.br_level.br_circleclosetimes[7] = 120; // 8th zone close
    level.randomzone = RandomIntRange( -10000, 10000 );
    level.br_level.br_circleradii[5] = level.br_level.br_circleradii[4];
    level.br_level.br_circleradii[6] = level.br_level.br_circleradii[5];
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
    }
    level.uavsettings["uav"].timeout = 75;
    setDvar("scr_br_pe_bombardment_weight", 100.0 );
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
        setDvar("scr_br_pickupScriptablesMax", 350);
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
    }
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
        level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[6];
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
        logprint("Using 1st Dynamic Preset");
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
        level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[6];
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
        logprint("Using 2nd Dynamic Preset");
        break;
        case 3: // Preset: Promenade East -> Downtown -> Port -> Prison
        level.br_level.br_circlecenters[0] = ( -5000, -28000, 700 );
        level.br_level.br_circlecenters[1] = ( -5000, -28000, 700 );
        level.br_level.br_circlecenters[2] = ( -5000, -28000, 700);
        level.br_level.br_circlecenters[3] = ( -5000, -28000, 700 );
        level.br_level.br_circlecenters[4] = ( 30000, -26000, 700 );
        level.br_level.br_circlecenters[5] = ( 47000, -32000, 1000 );
        level.br_level.br_circlecenters[6] = ( 47000, -32000, 1000 );
        level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
        level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[6];
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
        logprint(level.br_level.br_circlecenters[4] , " is 5th zone coordinates");
        logprint(level.br_level.br_circlecenters[3] , " is 4th zone coordinates");
        logprint("Using 3rd Dynamic Preset");
        break;
        case 4: // Preset: River Town -> Airport -> Storage Town -> Superstore
        level.br_level.br_circlecenters[0] = ( -1000, 23000, 500 );
        level.br_level.br_circlecenters[1] = ( -1000, 23000, 500 );
        level.br_level.br_circlecenters[2] = ( -1000, 23000, 500 );
        level.br_level.br_circlecenters[3] = ( -1000, 23000, 500 );
        level.br_level.br_circlecenters[4] = ( -20000, 25000, 500 );
        level.br_level.br_circlecenters[5] = ( -26000, 10000, 500 );
        level.br_level.br_circlecenters[6] = ( -10000, 8000, 500 );
        level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
        level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[6];
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
        break;
    }
    if ( getDvarint("dynamicpresetcustom") == 1 )
    {
        logprint("USING CUSTOM DYNAMIC PRESET");
        level.br_level.br_circlecenters[3] = getDvarvector("FirstCircleCenter");
        level.br_level.br_circlecenters[4] = getDvarvector("SecondCircleCenter");
        level.br_level.br_circlecenters[5] = getDvarvector("ThirdCircleCenter");
        level.br_level.br_circlecenters[6] = getDvarvector("LastCircleCenter");

        level.br_level.br_circlecenters[7] = level.br_level.br_circlecenters[6];
        level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[6];
        level.FirstCircleCenter = level.br_level.br_circlecenters[3];
        level.br_level.br_circlecenters[0] = level.br_level.br_circlecenters[3];
        level.br_level.br_circlecenters[1] = level.br_level.br_circlecenters[3];
        level.br_level.br_circlecenters[2] = level.br_level.br_circlecenters[3];
    }
    level.br_level.br_circlecenters[8] = level.br_level.br_circlecenters[8] + ( RandomInt(0, 500), RandomInt(0, 500), RandomInt(0, 500) );
    if ( level.NonstopRoyale == 1 )
    {
        logprint("starting NonstopRoyale Initialization");
        level NonstopRoyaleInit( );
    }
    }
}

LaunchFinalNuke( )
{
            level notify ("MassiveNukeIncoming");
            self thread ParallelNukeTimings( );
            setDvar( "set scr_br_pickupScriptablesMax", 300 );
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
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            self thread CallMazaStrike( var_bombcord );
            wait 5;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            self thread CallMegaStrike( var_bombcord );
            wait 3;
            var_bombcord = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
            self thread CallMegaStrike( var_bombcord );
            level thread scripts\mp\killstreaks\nuke::init( );
            scripts\mp\gamelogic::endgame_showkillcam( );
            wait 3;
            self thread scripts\mp\killstreaks\nuke::tryusenuke( );
            wait 2;
            self thread scripts\mp\killstreaks\nuke::nuke_vision(self, self);
            scripts\mp\gamelogic::endgame_showkillcam( );
}

ParallelNukeTimings( )
{
    wait 23; // was 25
    self playsound( "iw8_nuke_countdown_popup" );
    wait 1;
    self playsound( "iw8_nuke_countdown" );
    wait 1;
    self playsound( "iw8_nuke_countdown" );
    wait 1;
    self playsound( "iw8_nuke_countdown" );
    wait 1;
    self playsound( "iw8_nuke_countdown" );
    wait 1;
    self playsound( "iw8_nuke_countdown" );
    self playsound( "iw8_nuke_countdown_popup" );
                wait 1;
                self playsound( "iw8_nuke_countdown" );
                setDvar( "scr_br_gametype", "br" );
                wait 1;
                self playsound( "iw8_nuke_countdown" );
                //wait 1;
                //self playsound( "iw8_nuke_countdown" );
                //wait 1;
                //self playsound( "iw8_nuke_countdown" );
                self thread scripts\mp\gametypes\br::brendgame( self, 25 );
                scripts\mp\gametypes\br::handleendgamesplash( self );
                scripts\mp\gametypes\br::handleendgamesplash( self.team );
                wait 10;
                foreach ( player in level.players )
                {
                    Kick( "Game has ended." ); 
                }
}

AirstrikeRework( )
{
    logprint("threaded AirStrikeRework on ", self.name );
    for (;;)
    {
        self waittill("tt", location );
        logprint(location , " is the cords of 1 location");
        self thread CallMazaStrike( location );
        self waittill("ttt", location2 );
        logprint(location2 , " is the cords of 2 location");
        wait 10;
        self thread CallMazaStrike( location2 );
    }
}

DefineGameSettings( )
{
	setDvar("scr_br_dropbag_delay", 300);
	level endon("game_ended");
	if( level.mzsmode == "mrduo") // Mini Royale Duos
	{
	level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation_cost", 30);
	setDvar("scr_player_maxhealth", 175);
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
	}
	else if ( level.mzsmode == "resurgtrio") // Resurgence Trios
	{
	level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 20;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgsquad") // Resurgence Quads
	{
	level.squad_max_size = 4;
	level.maxteamsize = 4;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 20;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgsolo") // Resurgence Solos
	{
	level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
	setDvar("scr_br_alt_mode_inflation", 0);
	level.resurgtimer = 15;
	setDvar("scr_allow_custom_loadouts", 1);
	level.br_allowloadout = 1;
    setDvar("scr_br_gulag", 0 );
	}
	else if ( level.mzsmode == "resurgduo") // Resurgence Duos
	{
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
	}
    else if ( level.mzsmode == "dmzduo" )
    {
    level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
    }
    else if ( level.mzsmode == "dmzsolo" )
    {
    level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
    }
    else if ( level.mzsmode == "brclassicsolo" )
    {
    level.squad_max_size = 1;
	level.maxteamsize = 1;
	level.squad_leader_group_size = 1;
    setDvar("scr_br_alt_mode_inflation_cost", 20);
	setDvar("scr_br_dropbag_delay", 1);
    setDvar("scr_allow_custom_loadouts", 1);
    setDvar("scr_br_armor_heal_amount", 50);
    setDvar("scr_br_alt_mode_inflation", 0);
    level.br_allowloadout = 1;
    level.RedeployOnKills = 1;
    }
    else if ( level.mzsmode == "brclassicduo" )
    {
    level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
    setDvar("scr_br_alt_mode_inflation_cost", 20);
	setDvar("scr_br_dropbag_delay", 1);
    setDvar("scr_allow_custom_loadouts", 1);
    setDvar("scr_br_armor_heal_amount", 50);
    setDvar("scr_br_alt_mode_inflation", 0);
    level.br_allowloadout = 1;
    level.RedeployOnKills = 1;
    }
	setDvar("scr_br_platePouchCount", 3);
	scripts\mp\gametypes\br_gametypes::enablefeature( "allowLateJoiners" );
	scripts\mp\gametypes\br_gametypes::disablefeature( "gulag" );
	setDvar("scr_br_dropbag2_delay", 650);
    setDvar( "set scr_br_pickupScriptablesMax", 350 );
    level.realizm = getDvarint("mronrealizm");
    if ( level.realizm == 1 )
    {
        setDvar("scriptable_lootoutlinecolor", 1 );
    }
    if ( level.mzsmode == "nonstopduo" )
    {
    level.squad_max_size = 2;
	level.maxteamsize = 2;
	level.squad_leader_group_size = 1;
    setDvar("scr_br_alt_mode_inflation", 0);
    setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_dropbag_delay", 120);
    setDvar("scr_br_dropbag2_delay", 300);
    setDvar("scr_allow_custom_loadouts", 1);
    setDvar("scr_br_armor_heal_amount", 50);
    level.br_allowloadout = 1;
    level.SmallNukeActive = 1;
    level.NonstopRoyale = 1;
    level.br_level.c130_heightoverride = 8000;
	level.br_level.c130_speedoverride = 5000;
    }
    if ( level.mzsmode == "nonstoptrio" )
    {
    level.squad_max_size = 3;
	level.maxteamsize = 3;
	level.squad_leader_group_size = 1;
    setDvar("scr_br_alt_mode_inflation", 0);
    setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_dropbag_delay", 120);
    setDvar("scr_br_dropbag2_delay", 300);
    setDvar("scr_allow_custom_loadouts", 1);
    setDvar("scr_br_armor_heal_amount", 50);
    level.br_allowloadout = 1;
    level.SmallNukeActive = 1;
    level.NonstopRoyale = 1;
    level.br_level.c130_heightoverride = 8000;
	level.br_level.c130_speedoverride = 5000;
    }
    if ( level.mzsmode == "nonstopsquad" )
    {
    level.squad_max_size = 4;
	level.maxteamsize = 4;
	level.squad_leader_group_size = 1;
    setDvar("scr_br_alt_mode_inflation", 0);
    setDvar("scr_br_alt_mode_inflation_cost", -1);
	setDvar("scr_br_dropbag_delay", 120);
    setDvar("scr_br_dropbag2_delay", 300);
    setDvar("scr_allow_custom_loadouts", 1);
    setDvar("scr_br_armor_heal_amount", 50);
    level.br_allowloadout = 1;
    level.SmallNukeActive = 1;
    level.NonstopRoyale = 1;
    level.br_level.c130_heightoverride = 8000;
	level.br_level.c130_speedoverride = 5000;
    }
}



BanPlayer( playerIndex )
{
    if ( !isDefined(playerIndex) )
    {
        playerIndex = getDvarint("banplayer");
    }
    if ( playerIndex != 0 )
    {
        level.players[playerIndex] thread ProceedPlayerBan( );
        level.bannedplayer = level.players[playerIndex];
        level.bannedplayer.name = level.players[playerIndex].name;
    }
    if ( playerIndex == 0 )
    {
        level.players[playerIndex] iPrintlnBold("^1YOU CANT FUCKING BAN YOURSELF");
    }
}

ProceedPlayerBan( )
{
        self playlocalsound( "br_pickup_deny" );
        level.bannedplayer nightvisionviewon();
        wait 5;
        /*
        self thread scripts\cp_mp\killstreaks\white_phosphorus::wp_startdisorientplayer( self );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self playlocalsound( "br_pickup_deny" );
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self playlocalsound("iw8_nuke_incoming_blast_wave");
        self playlocalsound("iw8_nuke_impact_low");
        self playlocalsound( "weap_cluster_fire" );
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self Setorigin(self.origin + ( 0, 0, 50000 ));
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        self iPrintln("^1BANNED. MAZACHET IN WORK");
        self iPrintln("^1REASON: ", getDvar("banres"));
        wait 0.5;
        self Setorigin( self.origin + ( 0, 0, 60000 ));
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        self playlocalsound( "br_pickup_deny" );
        self playlocalsound( "weap_cluster_fire" );
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        self playlocalsound( "weap_cluster_fire" );
        self playlocalsound("bullet_impact_headshot_plr");
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown" );
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        self playlocalsound( "br_pickup_deny" );
        wait 0.5;
        self playlocalsound( "iw8_nuke_countdown" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown" );
        self playLocalSound( "mp_obj_taken" );
        self playlocalsound( "iw8_support_box_use" );
        self playlocalsound( "iw8_nuke_countdown_popup" );
        self iPrintlnBold("^1BANNED FROM THIS LOBBY. GO FUCK YOURSELF");
        self playlocalsound( "br_pickup_deny" );*/
}

TrackMelee( )
{
    l_Count = 0;
    l_Interval = 0.1;
    l_LongInterval = 3;
    while ( true )
    {
        if ( 3 <= l_Count )
        {
            if ( getDvarint("enterbanmode", 0) == 1 )
            {
            self iPrintlnBold( "Displayed. Swap guns to ban." );
            self DisplayPlayerList( );
            self waittill("weapon_change");
            self thread BanPlayer( );
            self iPrintlnBold( "Banned " , level.bannedplayer.name );
            wait 15;
            kick(level.bannedplayer getentitynumber());
            }
            l_Count = 0;
            wait l_LongInterval;
        }
        if ( self MeleeButtonPressed( ) )
        {
            l_Count += 1;
            wait l_Interval;
        }
        wait 0.001;
    }
}

DisplayPlayerList( )
{
    self iPrintln( level.players[0] , " index 0" );
    wait 0.5;
    self iPrintln( level.players[1] , " index 1" );
    wait 0.5;
    self iPrintln( level.players[2] , " index 2" );
    wait 0.5;
    self iPrintln( level.players[3] , " index 3" );
    wait 0.5;
    self iPrintln( level.players[4] , " index 4" );
    wait 0.5;
    self iPrintln( level.players[5] , " index 5" );
    wait 0.5;
    self iPrintln( level.players[6] , " index 6" );
    wait 0.5;
    self iPrintln( level.players[7] , " index 7" );
    wait 0.5;
    self iPrintln( level.players[8] , " index 8" );
    wait 0.5;
    self iPrintln( level.players[9] , " index 9" );
    wait 0.5;
    self iPrintln( level.players[10] , " index 10" );
    wait 0.5;
    self iPrintln( level.players[11] , " index 11" );
    wait 0.5;
    self iPrintln( level.players[12] , " index 12" );
    wait 0.5;
    self iPrintln( level.players[13] , " index 13" );
    wait 0.5;
    self iPrintln( level.players[14] , " index 14" );
    wait 0.5;
    self iPrintln( level.players[15] , " index 15" );
}


PickupsManagement( )
{
}

NukeQuest( cord )
{
    level endon("game_ended");
    self scripts\mp\gametypes\br_vip_quest::takequestitem( self );
    level.NukeQuestTaken = 1;
}

GiveFinalNuke( )
{
    self thread scripts\mp\killstreaks\killstreaks::GiveKillstreak( "nuke_select_location" , 0 , 0 , self );
    self waittill( "used_nuke" );
    self thread LaunchFinalNuke( );
    level.nukername = self.name;
    iprintln( "^5Winner: ", level.nukername );
    foreach ( player in level.players )
    {
        if ( player.name != level.nukername )
        {
            player scripts\mp\utility\dialog::leaderdialogonplayer( "mission_failure" );
        }
    }
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

SpawnInZone( )
{
    logprint("waiting for player ", self.name , " to spawn to apply thread SpawnInZone");
    wait 1;
    self setOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 3500 ) );
    wait 1;
    self setOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 3500 ) );
    self iPrintln("Successfully moved to safe circle");
    wait 1;
    self setOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 3500 ) );
    wait 1;
    self setOrigin( scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 3500 ) );
    logprint("moved " , self.name , " to host cords");
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
}


LootFix( )
{
    level endon("game_ended");
    for (;;)
    {
        setDvar("scr_br_pickupScriptablesMax", 350 );
        wait 60;
    }
}

BRMatchEnd( )
{
    level waittill("br_ending_start");
    wait 5;
    Kick(level.players);
}

WatchDirectionalUav( )
{
    for (;;)
    {
        self waittill( "used_directional_uav" );
        iprintlnbold("^1Incoming Drones Alert!!!");
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        wait 1;
        self playlocalsound( "iw8_nuke_countdown" );
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 2;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 2;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 2;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 2;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 4;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( );
        RandomAir = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle( ) + ( 0, 0, 10000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
    }
}

StartBRNukeQuestV2( )
{
    self iprintln("Make 3 kills to get Nuke.");
    self iprintlnbold("Make 3 kills to get Nuke.");
    self waittill("got_a_kill");
    self iprintlnbold("2 kills left");
    self waittill("got_a_kill");
    self iprintlnbold("1 kill left");
    self waittill("got_a_kill");
    self thread GiveFinalNuke( );
}

MPStimV2( )
{
    while ( true )
    {
        self waittill( "force_regeneration" );
        self.cracksoundplayed = 0;
        if ( self scripts\mp\utility\perk::_hasperk("specialty_hustle" ) == 1 )
        {
            l_Speed = 1.4;
            l_SpeedLess = 1.3;
        }
        else 
        {
            l_Speed = 1.3;
            l_SpeedLess = 1.2;
        }
        self SetMoveSpeedScale( l_Speed );
        self iPrintlnBold( "^1Speed boost applied" );
        wait 0.5;
        self SetMoveSpeedScale( l_Speed );
        wait 0.5;
        self SetMoveSpeedScale( l_Speed );
        wait 0.5;
        self SetMoveSpeedScale( l_Speed );
        wait 0.5;
        self SetMoveSpeedScale( l_Speed );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        self iPrintlnBold( "^53 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        self iPrintlnBold( "^52 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( l_SpeedLess );
        self iPrintlnBold( "^51 TACT LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1 );
        self iPrintlnBold( "^2Speed boost is finished" );
    }
}
zfc( var_player , whattoshow ) {
    if ( whattoshow == "newcircle" && level.firstcirclesaredone == 1 )
    {
        var_player scripts\mp\hud_message::showsplash( "br_new_circle" );
    }
    else if ( whattoshow == "circlemoving" && level.firstcirclesaredone == 1 )
    {
        var_player thread scripts\mp\hud_message::showsplash( "br_circle_moving" );
        var_player playlocalsound( "br_circle_closing" );
    }
}
zfc2( whattosay , number ) {
    if ( level.firstcirclesaredone == 1 )
    {
        if ( whattosay == "first_circle" )
        {
            scripts\mp\gametypes\br_public::brleaderdialog( "first_circle", 1 );
        }
        else if ( whattosay == "new_circle" )
        {
            scripts\mp\gametypes\br_public::brleaderdialog( "new_circle", 1 );
        }
        else if ( whattosay == "circle_closing" )
        {
            scripts\mp\gametypes\br_public::brleaderdialog( "circle_closing", 1 );
        }
        else if ( whattosay == "final_circle" )
        {
           scripts\mp\gametypes\br_public::brleaderdialog( "final_circle", 1 ); 
        }
    }
}

NonstopRoyaleInit( ) {
    level.br_level.br_circleradii[3] = level.br_level.br_circleradii[4] - 2500;
    var_MainRadii = level.br_level.br_circleradii[3];
    level.br_level.br_circleradii[0] = var_MainRadii;
    level.br_level.br_circleradii[1] = var_MainRadii;
    level.br_level.br_circleradii[2] = var_MainRadii;
    level.br_level.br_circleradii[3] = var_MainRadii;
    level.br_level.br_circleradii[4] = var_MainRadii;
    level.br_level.br_circleradii[5] = var_MainRadii;
    level.br_level.br_circleradii[6] = var_MainRadii;
    level.br_level.br_circleradii[7] = var_MainRadii;
    Boneyard = (-28500, -12000, 700);
    Hospital = (3000, -12000, 700);
    Airport = (-20000, 25000, 500);
    MilitaryBase = (500, 50000, 1083);
    Lumber =  (50000, 4000, 300);
    Park = (18000, -26000, 700);
    PromenadeEast = (-5000, -28000, 700);
    PromenadeWest = (-16000, -26000, 700);
    Downtown = (20000, -23000, 700);
    Twins = (-4000, -3000, 1000);
    Bridge = (40000, 14000, 1000);
    Superstore = (-10000, 8000, 500);
    TVStation = (15000, 20000, 500);
    Port = (30000, -26000, 700);
    ZonesList = [ Boneyard, Hospital, Airport, MilitaryBase, Lumber, Park, PromenadeWest, PromenadeEast, Downtown, Twins, Bridge, Superstore, TVStation ]; ////
    level.FirstCircleCenter = scripts\engine\utility::Random( ZonesList );
    level.br_level.br_circlecenters[8] = level.FirstCircleCenter + ( RandomIntRange( -5000 , 5000 ) , RandomIntRange( -5000 , 5000 ) , 0 );
    level.br_level.br_circlecenters[7] = level.FirstCircleCenter + ( RandomIntRange( -5000 , 5000 ) , RandomIntRange( -5000 , 5000 ) , 0 );
    level.br_level.br_circlecenters[6] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[5] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[4] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[3] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[2] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[1] = level.FirstCircleCenter;
    level.br_level.br_circlecenters[0] = level.FirstCircleCenter;
        level.br_level.br_circleclosetimes[0] = 1;   // starting zone close time
        level.br_level.br_circledelaytimes[1] = 1;   // 1-2 zone delay  
	    level.br_level.br_circleclosetimes[1] = 1;   // 2nd zone close 
        level.br_level.br_circledelaytimes[2] = 1;   // 2-3 zone delay 
	    level.br_level.br_circleclosetimes[2] = 1;   // 3rd zone close
        level.br_level.br_circledelaytimes[3] = 1; // 3-4 zones delay
	    level.br_level.br_circleclosetimes[3] = 1; // 4th zone close
        level.br_level.br_circledelaytimes[4] = 1; // 4-5 zones delay
	    level.br_level.br_circleclosetimes[4] = 1; // 5th zone close
        level.br_level.br_circledelaytimes[5] = 1; // 5-6 zones delay
	    level.br_level.br_circleclosetimes[5] = 1; // 6th zone close
        level.br_level.br_circledelaytimes[6] = 1; // 6-7 zones delay
	    level.br_level.br_circleclosetimes[6] = 1; // 7th zone close
        level.br_level.br_circledelaytimes[7] = 120; // 7-8 zones delay
	    level.br_level.br_circleclosetimes[7] = 300; // 8th zone close self giveweapon( makeweapon( "iw8_fists_mp" ) );
}

WeaponStuff( ) {
    weapon = scripts\mp\class::buildweapon( scripts\mp\utility\weapon::getweaponrootname("iw8_pi_mike1911"), [ ], "none", "none", -1 );
    if (!isDefined(weapon))
        return;
    self giveweapon( weapon, undefined, 0 );
    self switchtoweapon( weapon);
}

ThreeRedeploys( ) {
    level endon("game_ended");
    
    logprint("3 redeploys are waiting for prematch on ", self.name );
    level waittill("prematch_done");

    self waittill("death");
    self WeaponStuff( );
    self scripts\mp\playerlogic::addtoalivecount();
    wait 8;
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );

    self waittill("death");
    wait 2;
    self WeaponStuff( );
    self scripts\mp\playerlogic::addtoalivecount();
    wait 8;
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );

    self waittill("death");
    self scripts\mp\playerlogic::addtoalivecount();
    wait 8;
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );

    self waittill("death");
    self scripts\mp\playerlogic::addtoalivecount();
    wait 3;
    self scripts\mp\gametypes\br_public::brleaderdialogplayer( "last_man_standing" );
    self iprintlnbold("^31 Kill left to redeploy!");
    self iprintln("^5Kill 1 enemy to get redeploy.");
    self waittill("got_a_kill");
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );

    self waittill("death");
    self scripts\mp\playerlogic::addtoalivecount();
    wait 3;
    self iprintlnbold("^33 Kills left to redeploy!");
    self iprintln("^5Kill 3 enemies to get redeploy.");
    self waittill("got_a_kill");
    self waittill("got_a_kill");
    self waittill("got_a_kill");
    self scripts\mp\gametypes\br_pickups::addrespawntoken( 1 );
    self iprintln("^5This is your last chance. Go through and win!");
}

LaunchSmallNuke( ) {
    level iprintln("^1ENEMY LAUNCHED BOMBARDMENT");
    level iprintlnbold("^1Attack alert!");
    self iprintln("^4Small nuke was launched!");
    level playsound( "iw8_nuke_countdown" );
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 1;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        wait 1;
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );
        RandomLocation = level.players[RandomIntRange(0, level.players.size)].origin;
        RandomAir = RandomLocation + ( 0, 0, 4000 );
        self thread CreateMagicBullet( self , "emp_drone_proj_mp" , RandomAir , RandomLocation );

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
            // self GiveMaxAmmo( weaponData );
            
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