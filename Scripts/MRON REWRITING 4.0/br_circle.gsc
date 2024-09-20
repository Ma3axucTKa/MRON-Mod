initcircle()
{
    if ( scripts\mp\gametypes\br_gametypes::isfeaturedisabled( "circle" ) )
    {
        level.br_circle_disabled = 1;
        return;
    }

    if ( !isdefined( level.br_level ) )
        return;

    level.br_circle = spawnstruct();
    level.br_circle.mapbounds = level.br_level.br_mapbounds;

    if ( level.mapname == "mp_quarry2" || level.mapname == "mp_prison" || level.mapname == "mp_lumber" )
        level.br_circle.damagetick = [ 9, 9, 9, 9, 9 ];
    else
        level.br_circle.damagetick = [ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ];

    var_0 = getdvarvector( "br_final_circle_override", ( 0, 0, 0 ) );

    if ( length( var_0 ) > 0 )
        level.br_circle.br_finalcircleoverride = var_0;

    setomnvar( "ui_br_minimap_radius", level.br_level.br_circleminimapradii[0] );
    level.br_circle.circleindex = -1;
    _precalcsafecirclecenters();
}

getsafecircleorigin()
{
    if ( isdefined( level.br_circle ) && isdefined( level.br_circle.safecircleent ) )
        return ( level.br_circle.safecircleent.origin[0], level.br_circle.safecircleent.origin[1], 0 );
    else
        return ( 0, 0, 0 );
}

getsafecircleradius()
{
    if ( isdefined( level.br_circle ) && isdefined( level.br_circle.safecircleent ) )
        return level.br_circle.safecircleent.origin[2];
    else
        return 0;
}

getdangercircleorigin()
{
    if ( isdefined( level.br_circle ) && isdefined( level.br_circle.dangercircleent ) )
        return ( level.br_circle.dangercircleent.origin[0], level.br_circle.dangercircleent.origin[1], 0 );
    else
        return ( 0, 0, 0 );
}

getdangercircleradius()
{
    if ( isdefined( level.br_circle ) && isdefined( level.br_circle.dangercircleent ) )
        return level.br_circle.dangercircleent.origin[2];
    else
        return 0;
}

getnextsafecircleorigin()
{
    var_0 = level.br_circle.circleindex + 2;

    if ( var_0 < level.br_level.br_circlecenters.size )
        return level.br_level.br_circlecenters[var_0];
    else
        return undefined;
}

getnextsafecircleradius()
{
    var_0 = level.br_circle.circleindex + 2;

    if ( var_0 < level.br_level.br_circleradii.size )
        return level.br_level.br_circleradii[var_0];
    else
        return undefined;
}

canseesafecircleui()
{
    return true;
}

canseedangercircleui()
{
    return true;
}

playercanseedangercircleworld()
{
    if ( istrue( self.wasingulag ) )
        return 0;

    if ( istrue( self.gulag ) )
    {
        if ( istrue( self.gulagarena ) || istrue( self.jailed ) )
            return 0;
    }

    return canseedangercircleui();
}

cancircledamageplayer( var_0 )
{
    return var_0 playercanseedangercircleworld() && !istrue( var_0.gulag ) && !istrue( var_0.inrespawnc130 );
}

tryplaycoughaudio()
{
}

circledamagetick()
{
    level endon( "game_ended" );

    while ( level.br_circle.circleindex < 0 )
        waitframe();

    var_0 = getdvarfloat( "scr_br_circle_object_cleanup_threshold", 2400.0 );

    for (;;)
    {
        if ( isdefined( level.br_circle.dangercircleent ) )
        {
            var_1 = level.br_circle.circleindex;

            if ( var_1 > level.br_circle.damagetick.size - 1 )
                var_1 = level.br_circle.damagetick.size - 1;

            var_2 = level.br_circle.damagetick[var_1];

            if ( isdefined( level.circledamagemultiplier ) )
                var_2 = var_2 * level.circledamagemultiplier;

            if ( var_2 > 0 )
            {
                var_3 = getdangercircleorigin();
                var_4 = getdangercircleradius();

                foreach ( var_6 in level.players )
                {
                    if ( !isdefined( var_6 ) || !isdefined( var_6.origin ) )
                        continue;

                    if ( distance2dsquared( var_3, var_6.origin ) > var_4 * var_4 )
                    {
                        if ( var_6 cancircledamageplayer( var_6 ) )
                        {
                            var_6 updateindangercirclestate( 1 );

                            if ( scripts\cp_mp\gasmask::hasgasmask( var_6 ) )
                            {
                                if ( !istrue( var_6.gasmaskequipped ) )
                                    var_6 notify( "toggle_gasmask" );

                                var_6 scripts\cp_mp\gasmask::processdamage( var_2 );
                            }
                            else
                            {
                                var_6 dodamage( var_2, var_6.origin, var_6, undefined, "MOD_TRIGGER_HURT", "danger_circle_br" );

                                if ( var_6 scripts\mp\gametypes\br_public::hasarmor() )
                                    var_6 scripts\mp\gametypes\br_public::damagearmor( var_2 );

                                var_6 tryplaycoughaudio();
                            }
                        }

                        continue;
                    }

                    var_6 updateindangercirclestate( 0 );

                    if ( scripts\cp_mp\gasmask::hasgasmask( var_6 ) )
                    {
                        if ( istrue( var_6.gasmaskequipped ) )
                            var_6 notify( "toggle_gasmask" );
                    }
                }

                var_8 = var_4 + var_0;
                scripts\mp\gametypes\br_plunder::dangercircletick( var_3, var_8 );
                scripts\mp\gametypes\br_respawn::dangercircletick( var_3, var_8 );
                scripts\mp\gametypes\br_quest_util::dangercircletick( var_3, var_4, var_8 );
                scripts\mp\gametypes\br_armory_kiosk::dangercircletick( var_3, var_8 );
                scripts\mp\gametypes\br_vehicles::dangercircletick( var_3, var_4 );
                scripts\mp\gametypes\br_pickups::dangercircletick( var_3, var_4 );
                scripts\mp\gametypes\br_publicevents::dangercircletick( var_3, var_4 );
            }
        }

        wait 1;
    }
}

updateindangercirclestate( var_0 )
{
    if ( !isdefined( self.isincircle ) )
    {
        self.isincircle = var_0;
        self.lastcircleeventtime = gettime();
    }

    if ( self.isincircle != var_0 )
    {
        self.isincircle = var_0;
        var_1 = gettime();

        if ( var_0 )
        {
            scripts\cp_mp\challenges::startchallengetimer( "alive_in_gas" );
            scripts\mp\gametypes\br_analytics::branalytics_circleenter( self, var_1 - self.lastcircleeventtime );
        }
        else
        {
            scripts\cp_mp\challenges::stopchallengetimer( "alive_in_gas" );
            scripts\mp\gametypes\br_analytics::branalytics_circleexit( self, var_1 - self.lastcircleeventtime );
        }

        self.lastcircleeventtime = var_1;
    }
}

startuiclosetimer( var_0, var_1, var_2 )
{
    level endon( "game_ended" );
    setomnvar( "ui_hardpoint_timer", gettime() + int( var_0 * 1000 ) );
    level waittill("br_circle_set");
    level waittill("br_circle_set");
    level waittill("br_circle_set");
    level waittill("br_circle_set");

    if ( !var_1 )
    {
        foreach ( var_4 in level.players )
        {
            if ( !isbot( var_4 ) && !var_4 scripts\mp\gametypes\br_public::isplayeringulag() )
            {
                if ( istrue( var_2 ) )
                {
                    var_4 thread scripts\mp\hud_message::showsplash( "br_final_circle" );
                    continue;
                }

                var_4 thread scripts\mp\hud_message::showsplash( "br_new_circle" );
            }
        }
    }

    if ( istrue( var_2 ) )
        setomnvar( "ui_br_circle_state", 3 );
    else
        setomnvar( "ui_br_circle_state", 0 );

    var_6 = [ 60, 30, 20, 10, 0 ];
    var_7 = var_6.size - 1;

    for ( var_8 = 0; var_8 < var_6.size; var_8++ )
    {
        if ( var_0 > var_6[var_8] )
        {
            var_7 = var_8;
            break;
        }
    }

    if ( var_0 < var_6[var_7] )
        return;

    wait( var_0 - var_6[var_7] );

    for ( var_8 = var_7; var_8 < var_6.size - 1; var_8++ )
    {
        if ( var_8 == 2 )
            thread scripts\mp\music_and_dialog::br_circle_closing_music( var_1, var_2 );

        if ( var_8 == 3 )
            setomnvar( "ui_br_circle_state", 2 );

        wait( var_6[var_8] - var_6[var_8 + 1] );
    }

    foreach ( var_4 in level.players )
    {
        if ( !isbot( var_4 ) && !var_4 scripts\mp\gametypes\br_public::isplayeringulag() )
        {
            var_4 thread scripts\mp\hud_message::showsplash( "br_circle_moving" );
            var_4 playlocalsound( "br_circle_closing" );
        }
    }

    setomnvar( "ui_br_circle_state", 1 );
}

_hidesafecircleui()
{
    var_0 = self;
    var_0 setclientomnvar( "ui_br_circle0_start_time", 0 );
}

setpreviewuicircle( var_0 )
{
    foreach ( var_2 in level.players )
    {
        if ( !isbot( var_2 ) )
        {
            var_2 setclientomnvar( "ui_br_circle0_start_entity", var_0 );
            var_2 setclientomnvar( "ui_br_circle0_end_entity", var_0 );
        }
    }
}

setstaticuicircles( var_0, var_1, var_2, var_3 )
{
    foreach ( var_5 in level.players )
    {
        if ( !isbot( var_5 ) )
        {
            var_6 = _safecircledurationforplayer( var_5, var_0 );
            var_5 setclientomnvar( "ui_br_circle0_start_time", gettime() );
            var_5 setclientomnvar( "ui_br_circle0_duration", var_6 );
            var_5 setclientomnvar( "ui_br_circle0_start_entity", var_1 );
            var_5 setclientomnvar( "ui_br_circle0_end_entity", var_1 );

            if ( istrue( var_3 ) )
                var_5 _hidesafecircleui();

            var_6 = _dangercircledurationforplayer( var_5, var_0 );
            var_5 setclientomnvar( "ui_br_circle1_start_time", gettime() );
            var_5 setclientomnvar( "ui_br_circle1_duration", var_6 );
            var_5 setclientomnvar( "ui_br_circle1_start_entity", var_2 );
            var_5 setclientomnvar( "ui_br_circle1_end_entity", var_2 );
        }
    }

    thread updatecirclehide( var_0, var_1, var_2 );
}

setclosinguicircle( var_0, var_1, var_2, var_3 )
{
    foreach ( var_5 in level.players )
    {
        if ( !isbot( var_5 ) )
        {
            var_6 = _safecircledurationforplayer( var_5, var_0 );
            var_5 setclientomnvar( "ui_br_circle0_start_time", gettime() );
            var_5 setclientomnvar( "ui_br_circle0_duration", var_6 );
            var_5 setclientomnvar( "ui_br_circle0_start_entity", var_1 );
            var_5 setclientomnvar( "ui_br_circle0_end_entity", var_1 );

            if ( istrue( var_3 ) )
                var_5 _hidesafecircleui();

            var_6 = _dangercircledurationforplayer( var_5, var_0 );
            var_5 setclientomnvar( "ui_br_circle1_start_time", gettime() );
            var_5 setclientomnvar( "ui_br_circle1_duration", var_6 );
            var_5 setclientomnvar( "ui_br_circle1_start_entity", var_2 );
            var_5 setclientomnvar( "ui_br_circle1_end_entity", var_1 );
        }
    }

    thread updatecirclehide( var_0, var_1, var_2 );
}

updatecirclehide( var_0, var_1, var_2 )
{
    level notify( "update_circle_omnvars" );
    level endon( "update_circle_omnvars" );

    for (;;)
    {
        level waittill( "update_circle_hide" );

        foreach ( var_4 in level.players )
        {
            if ( !isbot( var_4 ) )
            {
                var_5 = _safecircledurationforplayer( var_4, var_0 );
                var_4 setclientomnvar( "ui_br_circle0_duration", var_5 );
                var_5 = _dangercircledurationforplayer( var_4, var_0 );
                var_4 setclientomnvar( "ui_br_circle1_duration", var_5 );
            }
        }
    }
}

_dangercircledurationforplayer( var_0, var_1 )
{
    if ( canseedangercircleui() )
        return int( var_1 * 1000 );
    else
        return 0;
}

_safecircledurationforplayer( var_0, var_1 )
{
    if ( canseesafecircleui() )
        return int( var_1 * 1000 );
    else
        return 0;
}

islastcircle()
{
    return level.br_circle.circleindex >= level.br_level.br_circleradii.size - 1 || !( level.br_level.br_circleradii[level.br_circle.circleindex + 1] > 0 );
}

isvalidpointinbounds( var_0, var_1, var_2 )
{
    if ( !scripts\mp\gametypes\br_c130::ispointinbounds( var_0, 1 ) )
        return 0;

    if ( istrue( var_1 ) && _ispointinbadarea( var_0 ) )
        return 0;

    if ( isdefined( var_2 ) )
    {
        var_3 = getmintimetillpointindangercircle( var_0 );

        if ( var_2 > var_3 )
            return 0;
    }

    return 1;
}

getrandompointinboundscircle( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7 )
{
    var_8 = 8;
    var_9 = var_0;
    var_10 = 0;
    var_11 = 0;

    for ( var_12 = 360; var_10 < var_8; var_10++ )
    {
        var_13 = getrandompointincircle( var_0, var_1, var_2, var_3, 1, 0, var_11, var_12 );

        if ( isvalidpointinbounds( var_13, var_6, var_7 ) )
        {
            var_9 = var_13;

            if ( istrue( var_5 ) && isnavmeshloaded() )
            {
                var_13 = getclosestpointonnavmesh( var_9 );

                if ( isvalidpointinbounds( var_13, var_6, var_7 ) )
                    break;
            }
            else
                break;
        }

        var_14 = level.br_level.br_circlecenters[0] - var_0;
        var_14 = ( var_14[0], var_14[1], 0 );
        var_15 = vectortoangles( var_14 )[1];
        var_16 = ( 1.0 - var_10 / var_8 ) * 180;
        var_11 = var_15 - var_16;
        var_12 = var_15 + var_16;
    }

    return var_9;
}

getrandompointincircle( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7 )
{
    var_8 = 0.0;

    if ( isdefined( var_2 ) )
        var_8 = var_2;

    var_9 = 1.0;

    if ( isdefined( var_3 ) )
        var_9 = var_3;

    if ( !isdefined( var_4 ) )
        var_4 = 1;

    if ( !isdefined( var_5 ) )
        var_5 = 1;

    if ( !isdefined( var_6 ) )
        var_6 = 0;

    if ( !isdefined( var_7 ) )
        var_7 = 360;

    var_10 = squared( var_1 * var_8 );
    var_11 = squared( var_1 * var_9 );
    var_12 = undefined;

    if ( var_10 == var_11 )
        var_12 = sqrt( var_10 );
    else
        var_12 = sqrt( randomfloatrange( var_10, var_11 ) );

    var_13 = var_6 + randomfloat( var_7 - var_6 );
    var_14 = ( var_12 * cos( var_13 ), var_12 * sin( var_13 ), 0 );
    var_15 = var_0 + var_14;

    if ( var_4 )
        var_15 = scripts\engine\utility::drop_to_ground( ( var_0[0], var_0[1], 4000 ) + var_14 );

    if ( var_5 && isnavmeshloaded() )
        var_15 = getclosestpointonnavmesh( var_15 );

    return var_15;
}

getrandompointincurrentcircle( var_0, var_1 )
{
    var_2 = getdangercircleorigin();
    var_3 = level.br_level.br_circleradii[level.br_circle.circleindex + 1];
    return getrandompointincircle( var_2, var_3, var_0, var_1 );
}

ispointincurrentsafecircle( var_0 )
{
    if ( !isdefined( level.br_circle.dangercircleent ) )
        return 0;

    var_1 = ( level.br_circle.dangercircleent.origin[0], level.br_circle.dangercircleent.origin[1], 0 );
    var_2 = level.br_level.br_circleradii[level.br_circle.circleindex + 1];
    var_3 = distance2dsquared( var_0, var_1 );

    if ( var_3 < var_2 * var_2 )
        return 1;

    return 0;
}

ispointinnextsafecircle( var_0 )
{
    var_1 = getnextsafecircleorigin();
    var_2 = getnextsafecircleradius();

    if ( !isdefined( var_1 ) || !isdefined( var_2 ) )
        return 0;

    var_3 = distance2dsquared( var_0, var_1 );

    if ( var_3 < var_2 * var_2 )
        return 1;

    return 0;
}

dangercircleenthidefromplayers()
{
    self endon( "death" );

    for (;;)
    {
        self show();

        foreach ( var_1 in level.players )
        {
            if ( !var_1 playercanseedangercircleworld() )
                self hidefromplayer( var_1 );
        }

        level waittill( "update_circle_hide" );
    }
}

_ispointinbadarea( var_0 )
{
    if ( getdvarint( "scr_br_badAreaKillswitch", 0 ) == 1 )
        return 0;

    if ( !isdefined( level.br_badcircleareas ) || level.br_badcircleareas.size == 0 )
        return 0;

    foreach ( var_2 in level.br_badcircleareas )
    {
        var_3 = distance2dsquared( var_0, var_2.origin );

        if ( var_3 < var_2.radiussq )
            return 0;
    }

    return 0;
}

_precalcsafecirclecenters( var_0, var_1 )
{
  level.br_level.br_circlecenters = [];
  var_2 = ( level.br_circle.mapbounds[0] + level.br_circle.mapbounds[1] ) * 0.5;
  level.br_level.br_circlecenters[0] = ( var_2[0], var_2[1], 0.0 );
  var_3 = getdvarfloat( "scr_br_circle_first_placement_scale", 0.0 );
  var_4 = var_3 * level.br_level.br_circleradii[1];
  var_5 = [];
  var_5[0] = level.br_circle.mapbounds[0][0] - var_4;
  var_5[1] = level.br_circle.mapbounds[0][1] - var_4;
  var_5[2] = level.br_circle.mapbounds[1][0] + var_4;
  var_5[3] = level.br_circle.mapbounds[1][1] + var_4;
  var_6 = min( var_5[0], var_5[2] );
  var_7 = max( var_5[0], var_5[2] );
  var_8 = min( var_5[1], var_5[3] );
  var_9 = max( var_5[1], var_5[3] );
  var_10 = var_2[0];
  var_11 = var_2[1];

  if ( isdefined( level.br_circle.br_finalcircleoverride ) )
  {
    var_12 = level.br_circle.br_finalcircleoverride[0];
    var_13 = level.br_circle.br_finalcircleoverride[1];

    if ( scripts\mp\gametypes\br_c130::ispointinbounds( ( var_12, var_13, 0 ), 1 ) && !_ispointinbadarea( ( var_12, var_13, 0 ) ) )
    {
      var_10 = var_12;
      var_11 = var_13;
    }
  }
  else
  {
    var_14 = 8;

    for ( var_15 = 0; var_15 < var_14; var_15++ )
    {
      var_12 = randomfloatrange( var_6, var_7 );
      var_13 = randomfloatrange( var_8, var_9 );

      if ( scripts\mp\gametypes\br_c130::ispointinbounds( ( var_12, var_13, 0 ), 1 ) && !_ispointinbadarea( ( var_12, var_13, 0 ) ) )
      {
        var_10 = var_12;
        var_11 = var_13;
        break;
      }

      var_6 = var_6 * 0.9;
      var_7 = var_7 * 0.9;
      var_8 = var_8 * 0.9;
      var_9 = var_9 * 0.9;
    }
  }

  var_16 = level.br_level.br_circleradii.size - 1;
  level.br_level.br_circlecenters[var_16] = scripts\engine\utility::drop_to_ground( ( var_10, var_11, 4000 ) );

  if ( istrue( var_1 ) )
    return;

  var_17 = getdvarfloat( "scr_br_circle_max_speed", 200 );
  var_18 = getdvarint( "scr_br_circle_clamp_max_circle_speed", 0 );
  var_19 = getdvarint( "scr_br_circle_snap_to_nav_mesh", 0 );

  if ( !var_19 && scripts\mp\gametypes\br_gametypes::isfeatureenabled( "circleSnapToNavMesh" ) )
    var_19 = 1;

  for ( var_20 = var_16 - 1; var_20 >= 0; var_20-- )
  {
    var_21 = level.br_level.br_circlecenters[var_20 + 1];
    var_22 = level.br_level.br_circleradii[var_20];
    var_23 = 0.0;
    var_24 = 1.0 - level.br_level.br_circleradii[var_20 + 1] / var_22;
    var_25 = var_23 + randomfloat( var_24 - var_23 );
    var_26 = level.br_level.br_circleclosetimes[var_20];
    var_27 = level.br_level.br_circleradii[var_20 + 1];
    var_28 = var_22 - var_27;
    var_29 = var_28 / var_26;
    var_30 = max( 0, var_17 - var_29 );
    var_31 = var_30 * var_26;
    var_32 = var_31 / var_22;
    var_33 = var_25 > var_32;

    if ( var_33 && !istrue( var_0 ) )
    {
      var_34 = var_29 + var_25 * var_22 / var_26;
      dlog_recordevent( "dlog_event_br_circle_speed_warning", [ "player_speed", var_17, "circle_speed", var_34, "circle_close_time", float( var_26 ), "circle_current_radius", float( var_22 ), "circle_next_radius", float( var_27 ) ] );
    }

    if ( var_20 )
    {
      if ( var_18 && var_33 )
        var_25 = var_23 + randomfloat( var_32 - var_23 );

      level.br_level.br_circlecenters[var_20] = getrandompointinboundscircle( var_21, var_22, var_25, var_25, 1, var_19, 1 );
      continue;
    }
  }
    level thread scripts\mp\art::BrCirclesMainModule( );
    level notify( "calc_circle_centers" );

}

CheckForOutBounds( var_0 )
{
    if (  _ispointinbadarea( var_0 ) == 1 )
    {
        var_0 = level.br_level.br_circlecenters[4] + ( RandomIntRange( -20000 , 20000 ) , RandomIntRange( -20000 , 20000 ) , 0 );
        level thread CheckForOutBounds( var_0 );
    }
    else if ( _ispointinbadarea( var_0 ) == 0 )
    {
    }
}


runcircles( var_0 )
{
    level endon( "game_ended" );
    level endon( "br_ending_start" );
    level.br_circle.safecircleent = spawn( "script_model", ( level.br_level.br_circlecenters[1][0], level.br_level.br_circlecenters[1][1], level.br_level.br_circleradii[1] ) );
    level.br_circle.safecircleent.hidden = 1;
    level.br_circle.safecircleui = spawn( "script_model", level.br_circle.safecircleent.origin );
    level.br_circle.safecircleui.hidden = 1;
    level.br_circle.dangercircleent = spawnbrcircle( level.br_level.br_circlecenters[0][0], level.br_level.br_circlecenters[0][1], level.br_level.br_circleradii[0] );
    level.br_circle.dangercircleent.hidden = 0;
    level.br_circle.dangercircleent thread dangercircleenthidefromplayers();
    level.br_circle.dangercircleui = spawn( "script_model", level.br_circle.dangercircleent.origin );
    level.br_circle.dangercircleui.hidden = 0;
    setpreviewuicircle( level.br_circle.safecircleent );
    hidedangercircle();

    if ( istrue( var_0 ) )
        level waittill( "infils_ready" );

    if ( istrue( level.usegulag ) )
        scripts\mp\gametypes\br_gulag::setupgulagtimer();

    showdangercircle();
    level.br_circle thread circledamagetick();
    level thread stopcirclesatgameend();

    for ( var_1 = 0; var_1 < level.br_level.br_circledelaytimes.size; var_1++ )
        circletimer( var_1 );

    scripts\mp\gametypes\br_armory_kiosk::disableallarmorykiosks();
}

stopcirclesatgameend()
{
    level notify( "stopCirclesAtGameEnd" );
    level endon( "stopCirclesAtGameEnd" );
    level scripts\engine\utility::waittill_any_two( "game_ended", "br_ending_start" );
    setomnvar( "ui_hardpoint_timer", 0 );
}

getcircleindexforpoint( var_0 )
{
    if ( !isdefined( level.br_circle ) )
        return -1;

    var_1 = -1;

    for ( var_2 = 0; var_2 < level.br_level.br_circlecenters.size; var_2++ )
    {
        var_3 = level.br_level.br_circlecenters[var_2];
        var_4 = level.br_level.br_circleradii[var_2];
        var_5 = distance2d( var_0, var_3 );

        if ( var_5 > var_4 )
            break;

        var_1 = var_2;
    }

    return var_1;
}

getmintimetillpointindangercircle( var_0 )
{
    if ( istrue( level.br_circle_disabled ) )
        return 99999;

    if ( !isdefined( level.br_circle ) )
        return -1;

    var_1 = 0.0;

    if ( level.br_circle.circleindex >= 0 )
    {
        var_2 = level.br_circle.circleindex;
        var_3 = level.br_circle.starttime;
        var_4 = level.br_circle.dangercircleent.origin[2];
        var_5 = level.br_circle.dangercircleent.origin;
    }
    else
    {
        var_2 = 0;
        var_3 = gettime();
        var_4 = level.br_level.br_circleradii[0];
        var_5 = level.br_level.br_circlecenters[0];
    }

    var_6 = getcircleindexforpoint( var_0 );

    if ( var_6 < 0 )
        return var_1;
    else if ( var_6 < var_2 )
        return var_1;
    else if ( var_6 == var_2 )
    {
        if ( distance2d( var_5, var_0 ) > var_4 )
            return var_1;
    }

    for ( var_7 = var_2 + 1; var_7 < var_6; var_7++ )
    {
        var_1 = var_1 + level.br_level.br_circleclosetimes[var_7];
        var_1 = var_1 + level.br_level.br_circledelaytimes[var_7];
    }

    var_8 = level.br_level.br_circledelaytimes[var_2];
    var_9 = level.br_level.br_circleclosetimes[var_2];
    var_10 = ( gettime() - var_3 ) / 1000;

    if ( var_6 > var_2 )
    {
        var_11 = var_8 + var_9;
        var_1 = var_1 + ( var_11 - var_10 );
        var_1 = var_1 + level.br_level.br_circledelaytimes[var_6];
        var_12 = level.br_level.br_circleclosetimes[var_6];
        var_13 = level.br_level.br_circlecenters[var_6];
        var_14 = level.br_level.br_circlecenters[var_6 + 1];
        var_15 = level.br_level.br_circleradii[var_6];
        var_16 = level.br_level.br_circleradii[var_6 + 1];
    }
    else
    {
        if ( var_10 < var_8 )
        {
            var_1 = var_1 + ( var_8 - var_10 );
            var_12 = var_9;
        }
        else
            var_12 = var_9 - ( var_10 - var_8 );

        var_13 = var_5;
        var_14 = level.br_level.br_circlecenters[var_2 + 1];
        var_15 = var_4;
        var_16 = level.br_level.br_circleradii[var_2 + 1];
    }

    var_15 = float( var_15 );
    var_16 = float( var_16 );
    var_17 = var_0[0];
    var_18 = var_17 * var_17;
    var_19 = var_13[0];
    var_20 = var_19 * var_19;
    var_21 = ( var_14[0] - var_13[0] ) / var_12;
    var_22 = var_21 * var_21;
    var_23 = var_0[1];
    var_24 = var_23 * var_23;
    var_25 = var_13[1];
    var_26 = var_25 * var_25;
    var_27 = ( var_14[1] - var_13[1] ) / var_12;
    var_28 = var_27 * var_27;
    var_29 = var_15;
    var_30 = var_29 * var_29;
    var_31 = ( var_16 - var_15 ) / var_12;
    var_32 = var_31 * var_31;
    var_33 = sqrt( pow( 2 * var_17 * var_21 - 2 * var_19 * var_21 + 2 * var_23 * var_27 - 2 * var_25 * var_27 + 2 * var_29 * var_31, 2 ) - 4 * ( -1 * var_22 - var_28 + var_32 ) * ( -1 * var_18 + 2 * var_17 * var_19 - var_20 - var_24 + 2 * var_23 * var_25 - var_26 + var_30 ) );
    var_34 = -2 * var_17 * var_21 + 2 * var_19 * var_21 - 2 * var_23 * var_27 + 2 * var_25 * var_27 - 2 * var_29 * var_31;
    var_35 = 2 * ( -1 * var_22 - var_28 + var_32 );
    var_36 = ( -1 * var_33 + var_34 ) / var_35;
    var_37 = ( var_33 + var_34 ) / var_35;

    if ( var_36 < 0 )
        var_38 = var_37;
    else if ( var_37 < 0 )
        var_38 = var_36;
    else
        var_38 = min( var_36, var_37 );

    var_1 = var_1 + var_38;
    return var_1;
}

hidedangercircle()
{
    if ( !isdefined( level.br_circle ) || !isdefined( level.br_circle.dangercircleui ) )
        return;

    level.br_circle.dangercircleui.hidden++;
    level.br_circle.dangercircleent.hidden++;
    level notify( "update_circle_hide" );
}

hidesafecircle()
{
    level.br_circle.safecircleui.hidden--;
    level.br_circle.safecircleent.hidden--;
    level notify( "update_circle_hide" );
}

showdangercircle()
{
    var_0 = level.br_circle.dangercircleent.hidden || level.br_circle.dangercircleent.hidden;
    level.br_circle.dangercircleui.hidden--;
    level.br_circle.dangercircleent.hidden--;
    var_1 = level.br_circle.dangercircleui.hidden || level.br_circle.dangercircleent.hidden;

    if ( var_0 && !var_1 )
        level notify( "update_circle_hide" );
}

showsafecircle()
{
    var_0 = level.br_circle.safecircleui.hidden || level.br_circle.safecircleent.hidden;
    level.br_circle.safecircleui.hidden--;
    level.br_circle.safecircleent.hidden--;
    var_1 = level.br_circle.safecircleui.hidden || level.br_circle.safecircleent.hidden;

    if ( var_0 && !var_1 )
        level notify( "update_circle_hide" );
}

circletimer( var_0 )
{
    level endon( "game_ended" );
    level endon( "br_ending_start" );

    if ( istrue( scripts\mp\gametypes\br_gametypes::runbrgametypefunc( "circleTimer", var_0 ) ) )
        return;

    level.br_circle.starttime = gettime();
    level.br_circle.circleindex = var_0;
    var_1 = var_0 == 0;
    var_2 = var_0 == level.br_level.br_circleclosetimes.size - 1;
    var_3 = level.br_level.br_circledelaytimes[var_0];
    var_4 = level.br_level.br_circleclosetimes[var_0];
    var_5 = level.br_level.br_circleradii[var_0 + 1];
    setomnvar( "ui_br_circle_num", var_0 + 1 );
    thread scripts\mp\gametypes\br_gulag::circletimer( var_0 );
    level thread br_lerp_minimap_zoom( var_0 );
    var_6 = level.br_level.br_circlecenters[var_0 + 1];
    level.br_circle.centertarget = var_6;
    level.br_circle.safecircleent.origin = ( level.br_circle.centertarget[0], level.br_circle.centertarget[1], var_5 );
    level.respawnclosets = gathervalidspawnclosets( var_6, var_5 );
    cleanupoutercrates();
    gatheroutercrates( var_6, var_5 );
    var_7 = level.br_level.br_circleshowdelaydanger[var_0];

    if ( var_7 > 0 )
    {
        hidedangercircle();
        scripts\engine\utility::delaythread( var_7, ::showdangercircle );
    }

    var_8 = level.br_level.br_circleshowdelaysafe[var_0];

    if ( var_8 > 0 )
    {
        hidesafecircle();
        scripts\engine\utility::delaythread( var_8, ::showsafecircle );
    }

    level thread startuiclosetimer( var_3, var_1, var_2 );
    level.br_circle.safecircleui.origin = level.br_circle.safecircleent.origin;
    level.br_circle.dangercircleui.origin = getdangercircleorigin() + ( 0, 0, getdangercircleradius() );
    setstaticuicircles( var_3, level.br_circle.safecircleui, level.br_circle.dangercircleui, var_2 );
    level thread _schedulenukes( var_3 );

    if ( var_1 )
        scripts\mp\gametypes\br_public::brleaderdialog( "first_circle", 1 );
    else
        scripts\mp\gametypes\br_public::brleaderdialog( "new_circle", 1 );

    if ( istrue( level.usegulag ) )
        level thread scripts\mp\gametypes\br_gulag::transitioncircle( var_5, var_3 );

    level notify( "br_circle_set" );
    wait( var_3 );
    level notify( "br_circle_started" );

    if ( scripts\mp\gametypes\br_public::isbotpracticematch() )
        level.circleclosing = 1;

    setomnvar( "ui_hardpoint_timer", gettime() + int( var_4 * 1000 ) );

    if ( var_2 )
        scripts\mp\gametypes\br_public::brleaderdialog( "final_circle", 1 );
    else
        scripts\mp\gametypes\br_public::brleaderdialog( "circle_closing", 1 );

    thread brcirclebattlechatter( var_0 );
    level.br_circle.safecircleui.origin = level.br_circle.safecircleent.origin;
    level.br_circle.dangercircleui.origin = getdangercircleorigin() + ( 0, 0, getdangercircleradius() );
    setclosinguicircle( int( var_4 ), level.br_circle.safecircleent, level.br_circle.dangercircleui, var_2 );
    level.br_circle.dangercircleent brcirclemoveto( level.br_circle.centertarget[0], level.br_circle.centertarget[1], var_5, var_4 );
    thread scripts\mp\music_and_dialog::br_danger_circle_closing_music( var_1, var_2 );
    wait( var_4 );
    var_9 = 5;

    if ( var_9 > 0 && var_0 < var_9 )
    {
        scripts\mp\rank::addglobalrankxpmultiplier( 1.2, "cirlceMult_" + scripts\engine\utility::string( var_0 ) );
        scripts\mp\weaponrank::addweaponrankxpmultiplier( 1.2, "cirlceMult_" + scripts\engine\utility::string( var_0 ) );
    }

    if ( scripts\mp\gametypes\br_public::isbotpracticematch() )
        level.circleclosing = 0;

    cleanupouterspawnclosets( var_6, var_5 );
}

br_lerp_minimap_zoom( var_0 )
{
    level endon( "game_ended" );

    if ( var_0 > 0 )
    {
        var_1 = var_0 - 1;
        var_2 = level.br_level.br_circleminimapradii[var_0];
        var_3 = level.br_level.br_circleminimapradii[var_1];

        if ( var_2 == var_3 )
            return;

        var_4 = 0.05;
        var_5 = 2;
        var_6 = var_5 / var_4;
        var_7 = int( ( var_3 - var_2 ) / var_6 );
        var_8 = level.br_level.br_circleminimapradii[var_1];

        for ( var_9 = 0; var_9 < var_6; var_9++ )
        {
            var_8 = var_8 - var_7;
            setomnvar( "ui_br_minimap_radius", var_8 );
            wait( var_4 );
        }

        setomnvar( "ui_br_minimap_radius", level.br_level.br_circleminimapradii[var_0] );
    }
    else
        setomnvar( "ui_br_minimap_radius", level.br_level.br_circleminimapradii[var_0] );
}

_schedulenukes( var_0 )
{
    level endon( "game_ended" );

    if ( !getdvarint( "br_enable_circle_nuke", 0 ) )
        return;

    var_1 = var_0 - scripts\mp\gametypes\br_nuke::getbrnuketraveltime() - 2.0;
    var_1 = max( 0.05, var_1 );
    wait( var_1 );
    var_2 = getdangercircleorigin();
    var_3 = getdangercircleradius();
    var_4 = getdvarint( "scr_br_nukesPerCircle", 3 );
    var_5 = getdvarint( "scr_br_nukeAngleDelta", 5 );
    var_6 = 360 / var_4;
    var_7 = [];
    var_8 = randomint( 360 );

    for ( var_9 = 0; var_9 < var_4; var_9++ )
    {
        var_10 = int( var_8 + var_6 * var_9 ) % 360 + randomintrange( -1 * var_5, var_5 );
        var_11 = anglestoforward( ( 0, var_10, 0 ) );
        var_12 = var_2 + var_11 * randomfloatrange( var_3 + 8000, var_3 + 12000 );
        var_12 = scripts\engine\utility::drop_to_ground( var_12 + ( 0, 0, 10000 ) );
        var_7[var_7.size] = var_12;
    }

    level thread scripts\mp\gametypes\br_nuke::launchbrnukes( var_7 );
}

cleanupouterspawnclosets( var_0, var_1 )
{
    var_2 = var_1 * var_1;

    if ( isdefined( level.revivetriggers ) )
    {
        foreach ( var_6, var_4 in level.revivetriggers )
        {
            if ( isdefined( var_4 ) && distance2dsquared( var_0, var_4.trigger.origin ) > var_2 )
            {
                var_5 = gathervalidspawnclosets( var_4.trigger.origin, var_1 );

                if ( isdefined( var_5 ) && var_5.size > 0 )
                    var_4.victim scripts\mp\teamrevive::relocatetrigger( var_5[0].origin );
                else
                    var_4.victim scripts\mp\teamrevive::removetrigger( var_6 );
            }
        }
    }
}

gathervalidspawnclosets( var_0, var_1 )
{
    if ( isdefined( level.respawnclosets ) )
    {
        var_2 = scripts\engine\utility::get_array_of_closest( var_0, level.respawnclosets, undefined, undefined, var_1 );
        return var_2;
    }

    return undefined;
}

gatheroutercrates( var_0, var_1 )
{
    var_2 = var_1 * var_1;

    foreach ( var_4 in level.br_pickups.crates )
    {
        if ( isdefined( var_4 ) && distance2dsquared( var_0, var_4.origin ) > var_2 )
            level.br_pickups.outercrates[level.br_pickups.outercrates.size] = var_4;
    }
}

cleanupoutercrates()
{
    level.br_pickups.outercrates = [];
}

applycirclesettings()
{
    var_0 = getdvarfloat( "scr_br_circle_time_scale", 1.0 );
    var_1 = level.br_level;
    var_1.br_circleclosetimes = _applydvarstosettings( var_1.br_circleclosetimes, "close_time", var_0 );
    var_1.br_circledelaytimes = _applydvarstosettings( var_1.br_circledelaytimes, "delay_time", var_0 );
    var_1.br_circleshowdelaydanger = _applydvarstosettings( var_1.br_circleshowdelaydanger, "show_delay_danger", var_0 );
    var_1.br_circleshowdelaysafe = _applydvarstosettings( var_1.br_circleshowdelaysafe, "show_delay_safe", var_0 );

    if ( !isdefined( var_1.br_circleradiizero ) )
        var_1.br_circleradiizero = level.br_level.br_circleradii[0];

    assertcirclesettings();
}

_applydvarstosettings( var_0, var_1, var_2 )
{
    var_3 = getdvarfloat( "scr_br_circle_" + var_1 + "_scale", 1.0 );

    for ( var_4 = 0; var_4 < var_0.size; var_4++ )
    {
        var_5 = getdvarfloat( "scr_br_circle_override_" + var_1 + "_" + var_4, -1.0 );

        if ( var_5 > 0 )
            var_0[var_4] = var_5;

        var_0[var_4] = var_0[var_4] * var_2;
        var_0[var_4] = var_0[var_4] * var_3;
    }

    return var_0;
}

assertcirclesettings()
{
    circlesettingsassert( isdefined( level.br_level.br_circleclosetimes ), "level.br_level.br_circleCloseTimes not defined" );
    circlesettingsassert( isdefined( level.br_level.br_circledelaytimes ), "level.br_level.br_circleDelayTimes not defined" );
    circlesettingsassert( isdefined( level.br_level.br_circleshowdelaydanger ), "level.br_level.br_circleShowDelayDanger not defined" );
    circlesettingsassert( isdefined( level.br_level.br_circleshowdelaysafe ), "level.br_level.br_circleShowDelaySafe not defined" );
    circlesettingsassert( isdefined( level.br_level.br_circleminimapradii ), "level.br_level.br_circleMinimapRadii not defined" );
    circlesettingsassert( isdefined( level.br_level.br_circleradii ), "level.br_level.br_circleDelayTimes not defined" );
    var_0 = level.br_level.br_circleclosetimes.size;
    circlesettingsassert( var_0 == level.br_level.br_circledelaytimes.size, "level.br_level.br_circleDelayTimes size != " + var_0 );
    circlesettingsassert( var_0 == level.br_level.br_circleshowdelaydanger.size, "level.br_level.br_circleShowDelayDanger size != " + var_0 );
    circlesettingsassert( var_0 == level.br_level.br_circleshowdelaysafe.size, "level.br_level.br_circleShowDelaySafe size != " + var_0 );
    circlesettingsassert( var_0 == level.br_level.br_circleminimapradii.size, "level.br_level.br_circleMinimapRadii size != " + var_0 );
    circlesettingsassert( var_0 == level.br_level.br_circleradii.size - 1, "level.br_level.br_circleRadii size-1 != " + var_0 );

    for ( var_1 = 0; var_1 < level.br_level.br_circleshowdelaydanger.size; var_1++ )
    {
        var_2 = level.br_level.br_circledelaytimes[var_1];
        var_3 = level.br_level.br_circleshowdelaydanger[var_1];
        circlesettingsassert( var_3 <= var_2, "level.br_level.br_circleShowDelayDanger[" + var_1 + "] " + var_2 + " > " + var_3 );
    }

    for ( var_1 = 0; var_1 < level.br_level.br_circledelaytimes.size; var_1++ )
    {
        var_2 = level.br_level.br_circledelaytimes[var_1];
        var_3 = level.br_level.br_circleshowdelaysafe[var_1];
        circlesettingsassert( var_3 <= var_2, "level.br_level.br_circleDelayTimes[" + var_1 + "] " + var_2 + " > " + var_3 );
    }

    circlesettingsassert( level.br_level.br_circleradii[0] == level.br_level.br_circleradiizero, "Changing circle radius 0 is not supported" );
}

circlesettingsassert( var_0, var_1 )
{
    if ( !var_0 )
        return;
}

getcircleclosetime( var_0 )
{
    if ( !isdefined( level.br_level ) )
        return 0;

    if ( !isdefined( level.br_level.br_circledelaytimes ) || !level.br_level.br_circledelaytimes.size )
        return 0;

    var_1 = level.br_level.br_circledelaytimes.size;

    if ( var_0 >= var_1 )
        var_0 = var_1 - 1;

    var_2 = 0;

    for ( var_3 = 0; var_3 <= var_0; var_3++ )
    {
        var_4 = level.br_level.br_circledelaytimes[var_3];
        var_5 = level.br_level.br_circleclosetimes[var_3];
        var_2 = var_2 + var_4 + var_5;
    }

    return var_2;
}

brcirclebattlechatter( var_0 )
{
    var_1 = level.br_level.br_circledelaytimes[var_0] / 5;
    wait( var_1 );

    foreach ( var_3 in level.teamnamelist )
        level thread doteamcirclebattlechatter( level.teamdata[var_3] );
}

doteamcirclebattlechatter( var_0 )
{
    var_1 = getsafecircleorigin();
    var_2 = getsafecircleradius();

    if ( var_0["alivePlayers"].size <= 1 )
        return;

    var_3 = sortbydistance( var_0["alivePlayers"], var_1 );
    var_4 = distance2dsquared( var_1, var_3[0].origin );

    if ( var_4 > var_2 * var_2 )
    {
        if ( var_4 > var_2 * var_2 * 4 )
            level thread scripts\mp\battlechatter_mp::trysaylocalsound( var_3[0], "obj_sitrep_circle_outfar" );
        else
            level thread scripts\mp\battlechatter_mp::trysaylocalsound( var_3[0], "obj_sitrep_circle_out" );
    }
    else
    {
        var_5 = distance2dsquared( var_1, var_3[var_3.size - 1].origin );

        if ( var_5 > var_2 * var_2 )
            level thread scripts\mp\battlechatter_mp::trysaylocalsound( var_3[0], "obj_sitrep_circle_mixed" );
        else
            level thread scripts\mp\battlechatter_mp::trysaylocalsound( var_3[0], "obj_sitrep_circle_in" );
    }
}

createinvalidcirclearea( var_0, var_1 )
{
    var_2 = spawnstruct();
    var_2.origin = var_0;
    var_2.radius = var_1;
    var_2.radiussq = var_1 * var_1;
    return var_2;
}
