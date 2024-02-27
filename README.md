# MRON-Mod
Resurgence Mini Royale Mod for CoD Warzone
This modification allows you to play Battle Royale normally in Call of Duty: Modern Warfare 2019 (IW8x, 1.20)
It includes:
1. Configs
2. Scripts
3. Dll

Scripts are used when you're hosting matches, so if you're just a player, not hoster, you can play without them. Same goes for scripts, but they also stand for visuals ingame. Dll is needed for visual features only.

INSTALLATION 

1. Download latest release .zip. Open it.
2. Put all .cfg and .json files from Configs folder to /Documents/Call of Duty Modern Warfare/players/
3. Put script.gscbin to your game folder and 1816.gscbin to your game folder/donetsk/scripts/
4. Put discord_game_sdk.dll to your game folder with replacement.
5. Done! Launch the game and press F1 to see menu.

HOW TO USE

To open menu, press F1. Main section is MiniRoyale. Click it. There you can choose Circle Preset (which stays for gas zone location), Execute br_core.cfg (which is VERY IMPORTANT before going in match) and Playlists themselves. IMPORTANT: If you're the hoster, you don't need to Execute br_core.cfg. Just select the playlist! It automatically executes br_core.cfg, so executing it again AFTER choosing playlist can override needed settings. Use Circle Preset 1 to debug bots. Current script version is buggy about bots, so crashes are expected. Remember that if you go too far from hoster (more than 500m), you will fall through map (no collisions). Also remember that if you set your FPS more than 84, your game will crash in no more than 5 minutes.

The script is written with GSC which Call of Duty uses. script.gscbin stays for main Circles Module and can be up to 6 KB. 1816.gscbin stays for all other features and can be up to 47 KB.
