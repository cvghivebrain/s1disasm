; ---------------------------------------------------------------------------
; Labels and file names for Nemesis-compressed graphics
; ---------------------------------------------------------------------------
		if Revision=0
		filedef	Nem_SegaLogo,"Graphics Nemesis\Sega Logo",nem		; large Sega logo
		else
		filedef	Nem_SegaLogo,"Graphics Nemesis\Sega Logo (JP1)",nem		; large Sega logo
		endc
		filedef	Nem_TitleFg,"Graphics Nemesis\Title Screen Foreground",nem
		filedef	Nem_TitleSonic,"Graphics Nemesis\Title Screen Sonic",nem
		filedef	Nem_TitleTM,"Graphics Nemesis\Title Screen TM",nem
		filedef	Nem_JapNames,"Graphics Nemesis\Hidden Japanese Credits",nem
		filedef	Art_Text,"Graphics\Level Select & Debug Text",bin
		
		; Special Stage
		filedef Nem_SSWalls,"Graphics Nemesis\Special Stage Walls",nem	; special stage walls
		filedef Nem_SSBgFish,"Graphics Nemesis\Special Stage Birds & Fish",nem ; special stage birds and fish background
		filedef Nem_SSBgCloud,"Graphics Nemesis\Special Stage Clouds",nem	; special stage clouds background
		filedef Nem_SSGOAL,"Graphics Nemesis\Special Stage GOAL",nem		; special stage GOAL block
		filedef Nem_SSRBlock,"Graphics Nemesis\Special Stage R",nem		; special stage R block
		filedef Nem_SS1UpBlock,"Graphics Nemesis\Special Stage 1UP",nem	; special stage 1UP block
		filedef Nem_SSEmStars,"Graphics Nemesis\Special Stage Emerald Twinkle",nem ; special stage stars from a collected emerald
		filedef Nem_SSRedWhite,"Graphics Nemesis\Special Stage Red-White",nem ; special stage red/white block
		filedef Nem_SSZone1,"Graphics Nemesis\Special Stage ZONE1",nem	; special stage ZONE1 block
		filedef Nem_SSZone2,"Graphics Nemesis\Special Stage ZONE2",nem	; ZONE2 block
		filedef Nem_SSZone3,"Graphics Nemesis\Special Stage ZONE3",nem	; ZONE3 block
		filedef Nem_SSZone4,"Graphics Nemesis\Special Stage ZONE4",nem	; ZONE4 block
		filedef Nem_SSZone5,"Graphics Nemesis\Special Stage ZONE5",nem	; ZONE5 block
		filedef Nem_SSZone6,"Graphics Nemesis\Special Stage ZONE6",nem	; ZONE6 block
		filedef Nem_SSUpDown,"Graphics Nemesis\Special Stage UP-DOWN",nem	; special stage UP/DOWN block
		filedef Nem_SSEmerald,"Graphics Nemesis\Special Stage Emeralds",nem	; special stage chaos emeralds
		filedef Nem_SSGhost,"Graphics Nemesis\Special Stage Ghost",nem	; special stage ghost block
		filedef Nem_SSWBlock,"Graphics Nemesis\Special Stage W",nem		; special stage W block
		filedef Nem_SSGlass,"Graphics Nemesis\Special Stage Glass",nem	; special stage destroyable glass block
		filedef Nem_ResultEm,"Graphics Nemesis\Special Stage Result Emeralds",nem ; chaos emeralds on special stage results screen
		
		; GHZ
		filedef Nem_Stalk,"Graphics Nemesis\GHZ Flower Stalk",nem
		filedef Nem_Swing,"Graphics Nemesis\GHZ Swinging Platform",nem
		filedef Nem_Bridge,"Graphics Nemesis\GHZ Bridge",nem
		filedef Nem_Ball,"Graphics Nemesis\GHZ Giant Ball",nem
		filedef Nem_Spikes,"Graphics Nemesis\Spikes",nem
		filedef Nem_SpikePole,"Graphics Nemesis\GHZ Spiked Helix Pole",nem
		filedef Nem_PurpleRock,"Graphics Nemesis\GHZ Purple Rock",nem
		filedef Nem_GhzSmashWall,"Graphics Nemesis\GHZ Smashable Wall",nem
		filedef Nem_GhzEdgeWall,"Graphics Nemesis\GHZ Walls",nem
		filedef Nem_GhzUnkLog,"Graphics Nemesis\Unused - GHZ Log",nem
		filedef Nem_GhzUnkBlock,"Graphics Nemesis\Unused - GHZ Block",nem
		
		; LZ
		filedef Nem_Water,"Graphics Nemesis\LZ Water Surface",nem
		filedef Nem_Splash,"Graphics Nemesis\LZ Waterfall & Splashes",nem
		filedef Nem_LzSpikeBall,"Graphics Nemesis\LZ Spiked Ball & Chain",nem
		filedef Nem_FlapDoor,"Graphics Nemesis\LZ Flapping Door",nem
		filedef Nem_Bubbles,"Graphics Nemesis\LZ Bubbles & Countdown",nem
		filedef Nem_LzHalfBlock,"Graphics Nemesis\LZ 32x16 Block",nem
		filedef Nem_LzDoorV,"Graphics Nemesis\LZ Vertical Door",nem
		filedef Nem_Harpoon,"Graphics Nemesis\LZ Harpoon",nem
		filedef Nem_LzPole,"Graphics Nemesis\LZ Breakable Pole",nem
		filedef Nem_LzDoorH,"Graphics Nemesis\LZ Horizontal Door",nem
		filedef Nem_LzWheel,"Graphics Nemesis\LZ Wheel",nem
		filedef Nem_Gargoyle,"Graphics Nemesis\LZ Gargoyle & Fireball",nem
		filedef Nem_LzPlatform,"Graphics Nemesis\LZ Rising Platform",nem
		filedef Nem_Cork,"Graphics Nemesis\LZ Cork",nem
		filedef Nem_LzBlock,"Graphics Nemesis\LZ 32x32 Block",nem
		filedef Nem_Sbz3HugeDoor,"Graphics Nemesis\SBZ3 Huge Sliding Door",nem
		
		; MZ
		filedef Nem_MzMetal,"Graphics Nemesis\MZ Metal Blocks",nem
		filedef Nem_MzButton,"Graphics Nemesis\MZ Button",nem
		filedef Nem_MzGlass,"Graphics Nemesis\MZ Green Glass Block",nem
		filedef Nem_Fireball,"Graphics Nemesis\Fireballs",nem
		filedef Nem_Lava,"Graphics Nemesis\MZ Lava",nem
		filedef Nem_MzBlock,"Graphics Nemesis\MZ Green Pushable Block",nem
		filedef Nem_MzUnkBlock,"Graphics Nemesis\Unused - MZ Background",nem
		filedef Nem_MzUnkGrass,"Graphics Nemesis\Unused - MZ Grass",nem
		
		; SLZ
		filedef Nem_Seesaw,"Graphics Nemesis\SLZ Seesaw",nem
		filedef Nem_SlzSpike,"Graphics Nemesis\SLZ Little Spikeball",nem
		filedef Nem_Fan,"Graphics Nemesis\SLZ Fan",nem
		filedef Nem_SlzWall,"Graphics Nemesis\SLZ Breakable Wall",nem
		filedef Nem_Pylon,"Graphics Nemesis\SLZ Pylon",nem
		filedef Nem_SlzSwing,"Graphics Nemesis\SLZ Swinging Platform",nem
		filedef Nem_SlzBlock,"Graphics Nemesis\SLZ 32x32 Block",nem
		filedef Nem_SlzCannon,"Graphics Nemesis\SLZ Cannon",nem
		
		; SYZ
		filedef Nem_Bumper,"Graphics Nemesis\SYZ Bumper",nem
		filedef Nem_SmallSpike,"Graphics Nemesis\SYZ Small Spikeball",nem
		filedef Nem_Button,"Graphics Nemesis\Button",nem
		filedef Nem_BigSpike,"Graphics Nemesis\SYZ Large Spikeball",nem
		
		; SBZ
		filedef Nem_SbzDisc,"Graphics Nemesis\SBZ Running Disc",nem
		filedef Nem_SbzJunction,"Graphics Nemesis\SBZ Junction Wheel",nem
		filedef Nem_Cutter,"Graphics Nemesis\SBZ Pizza Cutter",nem
		filedef Nem_Stomper,"Graphics Nemesis\SBZ Stomper",nem
		filedef Nem_SpinPlatform,"Graphics Nemesis\SBZ Spinning Platform",nem
		filedef Nem_TrapDoor,"Graphics Nemesis\SBZ Trapdoor",nem
		filedef Nem_SbzFloor,"Graphics Nemesis\SBZ Collapsing Floor",nem
		filedef Nem_Electric,"Graphics Nemesis\SBZ Electrocuter",nem
		filedef Nem_SbzBlock,"Graphics Nemesis\SBZ Vanishing Block",nem
		filedef Nem_FlamePipe,"Graphics Nemesis\SBZ Flaming Pipe",nem
		filedef Nem_SbzDoorV,"Graphics Nemesis\SBZ Small Vertical Door",nem
		filedef Nem_SlideFloor,"Graphics Nemesis\SBZ Sliding Floor Trap",nem
		filedef Nem_SbzDoorH,"Graphics Nemesis\SBZ Large Horizontal Door",nem
		filedef Nem_Girder,"Graphics Nemesis\SBZ Crushing Girder",nem
		
		; Enemies
		filedef Nem_BallHog,"Graphics Nemesis\Ball Hog",nem
		filedef Nem_Crabmeat,"Graphics Nemesis\Crabmeat",nem
		filedef Nem_Buzz,"Graphics Nemesis\Buzz Bomber",nem
		filedef Nem_Burrobot,"Graphics Nemesis\Burrobot",nem
		filedef Nem_Chopper,"Graphics Nemesis\Chopper",nem
		filedef Nem_Jaws,"Graphics Nemesis\Jaws",nem
		filedef Nem_Roller,"Graphics Nemesis\Roller",nem
		filedef Nem_Motobug,"Graphics Nemesis\Motobug",nem
		filedef Nem_Newtron,"Graphics Nemesis\Newtron",nem
		filedef Nem_Yadrin,"Graphics Nemesis\Yadrin",nem
		filedef Nem_Batbrain,"Graphics Nemesis\Batbrain",nem
		filedef Nem_Bomb,"Graphics Nemesis\Bomb Enemy",nem
		filedef Nem_Orbinaut,"Graphics Nemesis\Orbinaut",nem
		filedef Nem_Cater,"Graphics Nemesis\Caterkiller",nem
		filedef Nem_Splats,"Graphics Nemesis\Unused - Splats Enemy",nem
		filedef Nem_UnkExplode,"Graphics Nemesis\Unused - Explosion",nem
		
		; Items
		filedef Nem_TitleCard,"Graphics Nemesis\Title Cards",nem
		filedef Nem_Hud,"Graphics Nemesis\HUD",nem				; HUD (rings, time, score)
		filedef Nem_Lives,"Graphics Nemesis\HUD - Life Counter Icon",nem
		filedef Nem_Ring,"Graphics Nemesis\Rings",nem
		filedef Nem_Shield,"Graphics Nemesis\Shield",nem
		filedef Nem_Stars,"Graphics Nemesis\Invincibility",nem
		filedef Nem_Monitors,"Graphics Nemesis\Monitors",nem
		filedef Nem_Explode,"Graphics Nemesis\Explosion",nem
		filedef Nem_Points,"Graphics Nemesis\Points",nem			; points from destroyed enemy or object
		filedef Nem_GameOver,"Graphics Nemesis\Game Over",nem		; game over / time over
		filedef Nem_HSpring,"Graphics Nemesis\Spring Horizontal",nem
		filedef Nem_VSpring,"Graphics Nemesis\Spring Vertical",nem
		filedef Nem_SignPost,"Graphics Nemesis\Signpost",nem			; end of level signpost
		filedef Nem_Lamp,"Graphics Nemesis\Lamppost",nem
		filedef Nem_BigFlash,"Graphics Nemesis\Giant Ring Flash",nem
		filedef Nem_Bonus,"Graphics Nemesis\Hidden Bonuses",nem		; hidden bonuses at end of a level
		filedef	Art_BigRing,"Graphics\Giant Ring",bin
		
		; Continue
		filedef Nem_ContSonic,"Graphics Nemesis\Continue Screen Sonic",nem
		filedef Nem_MiniSonic,"Graphics Nemesis\Continue Screen Stuff",nem
		
		; Animals
		filedef Nem_Rabbit,"Graphics Nemesis\Animal Rabbit",nem
		filedef Nem_Chicken,"Graphics Nemesis\Animal Chicken",nem
		filedef Nem_BlackBird,"Graphics Nemesis\Animal Blackbird",nem
		filedef Nem_Seal,"Graphics Nemesis\Animal Seal",nem
		filedef Nem_Pig,"Graphics Nemesis\Animal Pig",nem
		filedef Nem_Flicky,"Graphics Nemesis\Animal Flicky",nem
		filedef Nem_Squirrel,"Graphics Nemesis\Animal Squirrel",nem
		
		; Levels
		filedef Nem_GHZ_1st,"Graphics Nemesis\8x8 - GHZ1",nem		; GHZ primary patterns
		filedef Nem_GHZ_2nd,"Graphics Nemesis\8x8 - GHZ2",nem		; GHZ secondary patterns
		filedef Nem_LZ,"Graphics Nemesis\8x8 - LZ",nem			; LZ primary patterns
		filedef Nem_MZ,"Graphics Nemesis\8x8 - MZ",nem			; MZ primary patterns
		filedef Nem_SLZ,"Graphics Nemesis\8x8 - SLZ",nem			; SLZ primary patterns
		filedef Nem_SYZ,"Graphics Nemesis\8x8 - SYZ",nem			; SYZ primary patterns
		filedef Nem_SBZ,"Graphics Nemesis\8x8 - SBZ",nem			; SBZ primary patterns
		
		; Bosses & ending
		filedef Nem_Eggman,"Graphics Nemesis\Boss - Main",nem
		filedef Nem_Weapons,"Graphics Nemesis\Boss - Weapons",nem
		filedef Nem_Prison,"Graphics Nemesis\Prison Capsule",nem
		filedef Nem_Sbz2Eggman,"Graphics Nemesis\Boss - Eggman in SBZ2 & FZ",nem
		filedef Nem_FzBoss,"Graphics Nemesis\Boss - Final Zone",nem
		filedef Nem_FzEggman,"Graphics Nemesis\Boss - Eggman after FZ Fight",nem
		filedef Nem_Exhaust,"Graphics Nemesis\Boss - Exhaust Flame",nem
		filedef Nem_EndEm,"Graphics Nemesis\Ending - Emeralds",nem
		filedef Nem_EndSonic,"Graphics Nemesis\Ending - Sonic",nem
		filedef Nem_TryAgain,"Graphics Nemesis\Ending - Try Again",nem
		filedef Nem_EndFlower,"Graphics Nemesis\Ending - Flowers",nem
		filedef Kos_EndFlowers,"Graphics Kosinski\Ending Flowers",kos
		filedef Nem_CreditText,"Graphics Nemesis\Ending - Credits",nem
		filedef Nem_EndStH,"Graphics Nemesis\Ending - StH Logo",nem
		if Revision=0
		filedef	Nem_EndEggman,"Graphics Nemesis\Unused - Eggman Ending",nem
		endc
		
		if Revision=0
		filedef Nem_Smoke,"Graphics Nemesis\Unused - Smoke",nem
		filedef Nem_SyzSparkle,"Graphics Nemesis\Unused - SYZ Sparkles",nem
		filedef Nem_LzSonic,"Graphics Nemesis\Unused - LZ Sonic Holding Breath",nem ; Sonic holding his breath
		filedef Nem_UnkFire,"Graphics Nemesis\Unused - Fireball",nem		; unused fireball
		filedef Nem_Warp,"Graphics Nemesis\Unused - Special Stage Warp",nem	; entry to special stage flash
		filedef Nem_Goggle,"Graphics Nemesis\Unused - Goggles",nem		; unused goggles
		endc
