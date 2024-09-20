// should be great lol

init() {

    if (isDefined(level.patchInit))
       return;
    level thread onplayerconnect();
    level thread mronWatermark();
    level.patchInit = true;
}

onplayerconnect()
{
    for (;;)
    {
        level waittill( "connected", var_0 );
        var_0 thread onplayerspawned();
        var_0 thread onPlayerSpawned1();
        //var_0 thread setupPlayer();
        var_0 thread MPStimV2( );
        var_0 thread ArmorSounds();
        
    }
}

onPlayerSpawned1() {
    for (;;) {
        self waittill("spawned_player");
        self.cracksoundplayed = 0;
    }
}

onplayerspawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    self waittill( "spawned" );

    for (;;)
    {

        if ( self adsbuttonpressed() && self meleebuttonpressed() )
        {
            self iprintlnbold("heyyy");
        }
        wait 0.1;
    }

}

ArmorSounds( )
{
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
    }
}

MPStimV2( )
{
    for (;;)
    {
        self waittill( "force_regeneration" );
        if (getdvarint("mron_boostEnabled", 1)) {
        self SetMoveSpeedScale( 1.3 );
        self iPrintlnBold( "^1Speed boost applied" );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.3 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        self iPrintlnBold( "^53 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        self iPrintlnBold( "^52 TACTS LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1.2 );
        self iPrintlnBold( "^51 TACT LEFT" );
        wait 0.5;
        self SetMoveSpeedScale( 1 );
        self iPrintlnBold( "^2Speed boost is finished" );
        }
        
    }
}

mronWatermark() {
    level endon( "game_ended" );
    msgs = [
            "",
            "Host - " + scripts\mp\gamelogic::gethostplayer().name,
            "^7discord.gg/mronwarzone",
            "^3MRON Lobby",
            "",
            ""
            ];
    for (;;) {
        if (getdvarint("mron_watermark", 1)) {
            foreach (msg in msgs) {
                iprintln(msg);
            }
        }
        
        wait 30;
    }
}

firesalediscount( var_0, var_1 )
{
    
}

fix_wall_traversal( var_0, var_1 )
{
    
}

ontimelimit() {
}

_id_1318D( var_0, var_1 )
{
}