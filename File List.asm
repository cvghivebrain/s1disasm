; ---------------------------------------------------------------------------
; File definitions - block mappings
; ---------------------------------------------------------------------------

		filedef	Blk16_GHZ,"16x16 Mappings\GHZ",eni,unc
		filedef	Blk16_MZ,"16x16 Mappings\MZ",eni,unc
		filedef	Blk16_SYZ,"16x16 Mappings\SYZ",eni,unc
		filedef	Blk16_LZ,"16x16 Mappings\LZ",eni,unc
		filedef	Blk16_SLZ,"16x16 Mappings\SLZ",eni,unc
		filedef	Blk16_SBZ,"16x16 Mappings\SBZ",eni,unc

		filedef	Blk256_GHZ,"256x256 Mappings\GHZ",kos,unc
		if Revision=0
		filedef	Blk256_MZ,"256x256 Mappings\MZ (REV00)",kos,unc
		else
		filedef	Blk256_MZ,"256x256 Mappings\MZ",kos,unc
		endc
		filedef	Blk256_SYZ,"256x256 Mappings\SYZ",kos,unc
		filedef	Blk256_LZ,"256x256 Mappings\LZ",kos,unc
		filedef	Blk256_SLZ,"256x256 Mappings\SLZ",kos,unc
		if Revision=0
		filedef	Blk256_SBZ,"256x256 Mappings\SBZ (REV00)",kos,unc
		else
		filedef	Blk256_SBZ,"256x256 Mappings\SBZ",kos,unc
		endc

; ---------------------------------------------------------------------------
; File definitions - graphics
; ---------------------------------------------------------------------------

		; Title screen
		if Revision=0
		filedef	Nem_SegaLogo,"Graphics Nemesis\Sega Logo",nem,bin
		else
		filedef	Nem_SegaLogo,"Graphics Nemesis\Sega Logo (JP1)",nem,bin
		endc
		filedef	Nem_TitleFg,"Graphics Nemesis\Title Screen Foreground",nem,bin
		filedef	Nem_TitleSonic,"Graphics Nemesis\Title Screen Sonic",nem,bin
		filedef	Nem_TitleTM,"Graphics Nemesis\Title Screen TM",nem,bin
		filedef	Nem_JapNames,"Graphics Nemesis\Hidden Japanese Credits",nem,bin
		filedef	Art_Text,"Graphics\Level Select & Debug Text",bin,bin
		
		; Special Stage
		filedef Nem_SSWalls,"Graphics Nemesis\Special Stage Walls",nem,bin
		filedef Nem_SSBgFish,"Graphics Nemesis\Special Stage Birds & Fish",nem,bin
		filedef Nem_SSBgCloud,"Graphics Nemesis\Special Stage Clouds",nem,bin
		filedef Nem_SSGOAL,"Graphics Nemesis\Special Stage GOAL",nem,bin
		filedef Nem_SSRBlock,"Graphics Nemesis\Special Stage R",nem,bin
		filedef Nem_SS1UpBlock,"Graphics Nemesis\Special Stage 1UP",nem,bin
		filedef Nem_SSEmStars,"Graphics Nemesis\Special Stage Emerald Twinkle",nem,bin
		filedef Nem_SSRedWhite,"Graphics Nemesis\Special Stage Red-White",nem,bin
		filedef Nem_SSZone1,"Graphics Nemesis\Special Stage ZONE1",nem,bin
		filedef Nem_SSZone2,"Graphics Nemesis\Special Stage ZONE2",nem,bin
		filedef Nem_SSZone3,"Graphics Nemesis\Special Stage ZONE3",nem,bin
		filedef Nem_SSZone4,"Graphics Nemesis\Special Stage ZONE4",nem,bin
		filedef Nem_SSZone5,"Graphics Nemesis\Special Stage ZONE5",nem,bin
		filedef Nem_SSZone6,"Graphics Nemesis\Special Stage ZONE6",nem,bin
		filedef Nem_SSUpDown,"Graphics Nemesis\Special Stage UP-DOWN",nem,bin
		filedef Nem_SSEmerald,"Graphics Nemesis\Special Stage Emeralds",nem,bin
		filedef Nem_SSGhost,"Graphics Nemesis\Special Stage Ghost",nem,bin
		filedef Nem_SSWBlock,"Graphics Nemesis\Special Stage W",nem,bin
		filedef Nem_SSGlass,"Graphics Nemesis\Special Stage Glass",nem,bin
		filedef Nem_ResultEm,"Graphics Nemesis\Special Stage Result Emeralds",nem,bin
		
		; GHZ
		filedef Nem_Stalk,"Graphics Nemesis\GHZ Flower Stalk",nem,bin
		filedef Nem_Swing,"Graphics Nemesis\GHZ Swinging Platform",nem,bin
		filedef Nem_Bridge,"Graphics Nemesis\GHZ Bridge",nem,bin
		filedef Nem_Ball,"Graphics Nemesis\GHZ Giant Ball",nem,bin
		filedef Nem_Spikes,"Graphics Nemesis\Spikes",nem,bin
		filedef Nem_SpikePole,"Graphics Nemesis\GHZ Spiked Helix Pole",nem,bin
		filedef Nem_PurpleRock,"Graphics Nemesis\GHZ Purple Rock",nem,bin
		filedef Nem_GhzSmashWall,"Graphics Nemesis\GHZ Smashable Wall",nem,bin
		filedef Nem_GhzEdgeWall,"Graphics Nemesis\GHZ Walls",nem,bin
		filedef Nem_GhzUnkLog,"Graphics Nemesis\Unused - GHZ Log",nem,bin
		filedef Nem_GhzUnkBlock,"Graphics Nemesis\Unused - GHZ Block",nem,bin
		
		; LZ
		filedef Nem_Water,"Graphics Nemesis\LZ Water Surface",nem,bin
		filedef Nem_Splash,"Graphics Nemesis\LZ Waterfall & Splashes",nem,bin
		filedef Nem_LzSpikeBall,"Graphics Nemesis\LZ Spiked Ball & Chain",nem,bin
		filedef Nem_FlapDoor,"Graphics Nemesis\LZ Flapping Door",nem,bin
		filedef Nem_Bubbles,"Graphics Nemesis\LZ Bubbles & Countdown",nem,bin
		filedef Nem_LzHalfBlock,"Graphics Nemesis\LZ 32x16 Block",nem,bin
		filedef Nem_LzDoorV,"Graphics Nemesis\LZ Vertical Door",nem,bin
		filedef Nem_Harpoon,"Graphics Nemesis\LZ Harpoon",nem,bin
		filedef Nem_LzPole,"Graphics Nemesis\LZ Breakable Pole",nem,bin
		filedef Nem_LzDoorH,"Graphics Nemesis\LZ Horizontal Door",nem,bin
		filedef Nem_LzWheel,"Graphics Nemesis\LZ Wheel",nem,bin
		filedef Nem_Gargoyle,"Graphics Nemesis\LZ Gargoyle & Fireball",nem,bin
		filedef Nem_LzPlatform,"Graphics Nemesis\LZ Rising Platform",nem,bin
		filedef Nem_Cork,"Graphics Nemesis\LZ Cork",nem,bin
		filedef Nem_LzBlock,"Graphics Nemesis\LZ 32x32 Block",nem,bin
		filedef Nem_Sbz3HugeDoor,"Graphics Nemesis\SBZ3 Huge Sliding Door",nem,bin
		
		; MZ
		filedef Nem_MzMetal,"Graphics Nemesis\MZ Metal Blocks",nem,bin
		filedef Nem_MzButton,"Graphics Nemesis\MZ Button",nem,bin
		filedef Nem_MzGlass,"Graphics Nemesis\MZ Green Glass Block",nem,bin
		filedef Nem_Fireball,"Graphics Nemesis\Fireballs",nem,bin
		filedef Nem_Lava,"Graphics Nemesis\MZ Lava",nem,bin
		filedef Nem_MzBlock,"Graphics Nemesis\MZ Green Pushable Block",nem,bin
		filedef Nem_MzUnkBlock,"Graphics Nemesis\Unused - MZ Background",nem,bin
		filedef Nem_MzUnkGrass,"Graphics Nemesis\Unused - MZ Grass",nem,bin
		
		; SLZ
		filedef Nem_Seesaw,"Graphics Nemesis\SLZ Seesaw",nem,bin
		filedef Nem_SlzSpike,"Graphics Nemesis\SLZ Little Spikeball",nem,bin
		filedef Nem_Fan,"Graphics Nemesis\SLZ Fan",nem,bin
		filedef Nem_SlzWall,"Graphics Nemesis\SLZ Breakable Wall",nem,bin
		filedef Nem_Pylon,"Graphics Nemesis\SLZ Pylon",nem,bin
		filedef Nem_SlzSwing,"Graphics Nemesis\SLZ Swinging Platform",nem,bin
		filedef Nem_SlzBlock,"Graphics Nemesis\SLZ 32x32 Block",nem,bin
		filedef Nem_SlzCannon,"Graphics Nemesis\SLZ Cannon",nem,bin
		
		; SYZ
		filedef Nem_Bumper,"Graphics Nemesis\SYZ Bumper",nem,bin
		filedef Nem_SmallSpike,"Graphics Nemesis\SYZ Small Spikeball",nem,bin
		filedef Nem_Button,"Graphics Nemesis\Button",nem,bin
		filedef Nem_BigSpike,"Graphics Nemesis\SYZ Large Spikeball",nem,bin
		
		; SBZ
		filedef Nem_SbzDisc,"Graphics Nemesis\SBZ Running Disc",nem,bin
		filedef Nem_SbzJunction,"Graphics Nemesis\SBZ Junction Wheel",nem,bin
		filedef Nem_Cutter,"Graphics Nemesis\SBZ Pizza Cutter",nem,bin
		filedef Nem_Stomper,"Graphics Nemesis\SBZ Stomper",nem,bin
		filedef Nem_SpinPlatform,"Graphics Nemesis\SBZ Spinning Platform",nem,bin
		filedef Nem_TrapDoor,"Graphics Nemesis\SBZ Trapdoor",nem,bin
		filedef Nem_SbzFloor,"Graphics Nemesis\SBZ Collapsing Floor",nem,bin
		filedef Nem_Electric,"Graphics Nemesis\SBZ Electrocuter",nem,bin
		filedef Nem_SbzBlock,"Graphics Nemesis\SBZ Vanishing Block",nem,bin
		filedef Nem_FlamePipe,"Graphics Nemesis\SBZ Flaming Pipe",nem,bin
		filedef Nem_SbzDoorV,"Graphics Nemesis\SBZ Small Vertical Door",nem,bin
		filedef Nem_SlideFloor,"Graphics Nemesis\SBZ Sliding Floor Trap",nem,bin
		filedef Nem_SbzDoorH,"Graphics Nemesis\SBZ Large Horizontal Door",nem,bin
		filedef Nem_Girder,"Graphics Nemesis\SBZ Crushing Girder",nem,bin
		
		; Enemies
		filedef Nem_BallHog,"Graphics Nemesis\Ball Hog",nem,bin
		filedef Nem_Crabmeat,"Graphics Nemesis\Crabmeat",nem,bin
		filedef Nem_Buzz,"Graphics Nemesis\Buzz Bomber",nem,bin
		filedef Nem_Burrobot,"Graphics Nemesis\Burrobot",nem,bin
		filedef Nem_Chopper,"Graphics Nemesis\Chopper",nem,bin
		filedef Nem_Jaws,"Graphics Nemesis\Jaws",nem,bin
		filedef Nem_Roller,"Graphics Nemesis\Roller",nem,bin
		filedef Nem_Motobug,"Graphics Nemesis\Motobug",nem,bin
		filedef Nem_Newtron,"Graphics Nemesis\Newtron",nem,bin
		filedef Nem_Yadrin,"Graphics Nemesis\Yadrin",nem,bin
		filedef Nem_Batbrain,"Graphics Nemesis\Batbrain",nem,bin
		filedef Nem_Bomb,"Graphics Nemesis\Bomb Enemy",nem,bin
		filedef Nem_Orbinaut,"Graphics Nemesis\Orbinaut",nem,bin
		filedef Nem_Cater,"Graphics Nemesis\Caterkiller",nem,bin
		filedef Nem_Splats,"Graphics Nemesis\Unused - Splats Enemy",nem,bin
		filedef Nem_UnkExplode,"Graphics Nemesis\Unused - Explosion",nem,bin
		
		; Items
		filedef Nem_TitleCard,"Graphics Nemesis\Title Cards",nem,bin
		filedef Nem_Hud,"Graphics Nemesis\HUD",nem,bin
		filedef Nem_Lives,"Graphics Nemesis\HUD - Life Counter Icon",nem,bin
		filedef Nem_Ring,"Graphics Nemesis\Rings",nem,bin
		filedef Nem_Shield,"Graphics Nemesis\Shield",nem,bin
		filedef Nem_Stars,"Graphics Nemesis\Invincibility",nem,bin
		filedef Nem_Monitors,"Graphics Nemesis\Monitors",nem,bin
		filedef Nem_Explode,"Graphics Nemesis\Explosion",nem,bin
		filedef Nem_Points,"Graphics Nemesis\Points",nem,bin ; points from destroyed enemy or object
		filedef Nem_GameOver,"Graphics Nemesis\Game Over",nem,bin ; game over / time over
		filedef Nem_HSpring,"Graphics Nemesis\Spring Horizontal",nem,bin
		filedef Nem_VSpring,"Graphics Nemesis\Spring Vertical",nem,bin
		filedef Nem_SignPost,"Graphics Nemesis\Signpost",nem,bin ; end of level signpost
		filedef Nem_Lamp,"Graphics Nemesis\Lamppost",nem,bin
		filedef Nem_BigFlash,"Graphics Nemesis\Giant Ring Flash",nem,bin
		filedef Nem_Bonus,"Graphics Nemesis\Hidden Bonuses",nem,bin ; hidden bonuses at end of a level
		filedef	Art_BigRing,"Graphics\Giant Ring",bin,bin
		
		; Continue
		filedef Nem_ContSonic,"Graphics Nemesis\Continue Screen Sonic",nem,bin
		filedef Nem_MiniSonic,"Graphics Nemesis\Continue Screen Stuff",nem,bin ; small "CONTINUE" text and mini Sonic
		
		; Animals
		filedef Nem_Rabbit,"Graphics Nemesis\Animal Rabbit",nem,bin
		filedef Nem_Chicken,"Graphics Nemesis\Animal Chicken",nem,bin
		filedef Nem_BlackBird,"Graphics Nemesis\Animal Blackbird",nem,bin
		filedef Nem_Seal,"Graphics Nemesis\Animal Seal",nem,bin
		filedef Nem_Pig,"Graphics Nemesis\Animal Pig",nem,bin
		filedef Nem_Flicky,"Graphics Nemesis\Animal Flicky",nem,bin
		filedef Nem_Squirrel,"Graphics Nemesis\Animal Squirrel",nem,bin
		
		; Levels
		filedef Nem_GHZ_1st,"Graphics Nemesis\8x8 - GHZ1",nem,bin
		filedef Nem_GHZ_2nd,"Graphics Nemesis\8x8 - GHZ2",nem,bin
		filedef Nem_LZ,"Graphics Nemesis\8x8 - LZ",nem,bin
		filedef Nem_MZ,"Graphics Nemesis\8x8 - MZ",nem,bin
		filedef Nem_SLZ,"Graphics Nemesis\8x8 - SLZ",nem,bin
		filedef Nem_SYZ,"Graphics Nemesis\8x8 - SYZ",nem,bin
		filedef Nem_SBZ,"Graphics Nemesis\8x8 - SBZ",nem,bin
		
		; Bosses & ending
		filedef Nem_Eggman,"Graphics Nemesis\Boss - Main",nem,bin
		filedef Nem_Weapons,"Graphics Nemesis\Boss - Weapons",nem,bin
		filedef Nem_Prison,"Graphics Nemesis\Prison Capsule",nem,bin
		filedef Nem_Sbz2Eggman,"Graphics Nemesis\Boss - Eggman in SBZ2 & FZ",nem,bin
		filedef Nem_FzBoss,"Graphics Nemesis\Boss - Final Zone",nem,bin
		filedef Nem_FzEggman,"Graphics Nemesis\Boss - Eggman after FZ Fight",nem,bin
		filedef Nem_Exhaust,"Graphics Nemesis\Boss - Exhaust Flame",nem,bin
		filedef Nem_EndEm,"Graphics Nemesis\Ending - Emeralds",nem,bin
		filedef Nem_EndSonic,"Graphics Nemesis\Ending - Sonic",nem,bin
		filedef Nem_TryAgain,"Graphics Nemesis\Ending - Try Again",nem,bin
		filedef Nem_EndFlower,"Graphics Nemesis\Ending - Flowers",nem,bin
		filedef Kos_EndFlowers,"Graphics Kosinski\Ending Flowers",kos,bin
		filedef Nem_CreditText,"Graphics Nemesis\Ending - Credits",nem,bin
		filedef Nem_EndStH,"Graphics Nemesis\Ending - StH Logo",nem,bin
		if Revision=0
		filedef	Nem_EndEggman,"Graphics Nemesis\Unused - Eggman Ending",nem,bin
		endc
		
		; Unused
		if Revision=0
		filedef Nem_Smoke,"Graphics Nemesis\Unused - Smoke",nem,bin
		filedef Nem_SyzSparkle,"Graphics Nemesis\Unused - SYZ Sparkles",nem,bin
		filedef Nem_LzSonic,"Graphics Nemesis\Unused - LZ Sonic Holding Breath",nem,bin
		filedef Nem_UnkFire,"Graphics Nemesis\Unused - Fireball",nem,bin
		filedef Nem_Warp,"Graphics Nemesis\Unused - Special Stage Warp",nem,bin
		filedef Nem_Goggle,"Graphics Nemesis\Unused - Goggles",nem,bin
		endc

; ---------------------------------------------------------------------------
; File definitions - palettes
; ---------------------------------------------------------------------------

		filedef Pal_TitleCyc,"Palettes\Cycle - Title Screen Water",bin,bin
		filedef Pal_GHZCyc,"Palettes\Cycle - GHZ",bin,bin
		filedef Pal_LZCyc1,"Palettes\Cycle - LZ Waterfall",bin,bin
		filedef Pal_LZCyc2,"Palettes\Cycle - LZ Conveyor Belt",bin,bin
		filedef Pal_LZCyc3,"Palettes\Cycle - LZ Conveyor Belt Underwater",bin,bin
		filedef Pal_SBZ3Cyc1,"Palettes\Cycle - SBZ3 Waterfall",bin,bin
		filedef Pal_MZCyc,"Palettes\Cycle - MZ (Unused)",bin,bin
		filedef Pal_SLZCyc,"Palettes\Cycle - SLZ",bin,bin
		filedef Pal_SYZCyc1,"Palettes\Cycle - SYZ1",bin,bin
		filedef Pal_SYZCyc2,"Palettes\Cycle - SYZ2",bin,bin
		filedef Pal_SBZCyc1,"Palettes\Cycle - SBZ 1",bin,bin
		filedef Pal_SBZCyc2,"Palettes\Cycle - SBZ 2",bin,bin
		filedef Pal_SBZCyc3,"Palettes\Cycle - SBZ 3",bin,bin
		filedef Pal_SBZCyc4,"Palettes\Cycle - SBZ 4",bin,bin
		filedef Pal_SBZCyc5,"Palettes\Cycle - SBZ 5",bin,bin
		filedef Pal_SBZCyc6,"Palettes\Cycle - SBZ 6",bin,bin
		filedef Pal_SBZCyc7,"Palettes\Cycle - SBZ 7",bin,bin
		filedef Pal_SBZCyc8,"Palettes\Cycle - SBZ 8",bin,bin
		filedef Pal_SBZCyc9,"Palettes\Cycle - SBZ 9",bin,bin
		filedef Pal_SBZCyc10,"Palettes\Cycle - SBZ 10",bin,bin
		filedef Pal_Sega1,"Palettes\Sega - Stripe",bin,bin
		filedef Pal_Sega2,"Palettes\Sega - All",bin,bin
		filedef Pal_SegaBG,"Palettes\Sega Background",bin,bin
		filedef Pal_Title,"Palettes\Title Screen",bin,bin
		filedef Pal_LevelSel,"Palettes\Level Select",bin,bin
		filedef Pal_Sonic,"Palettes\Sonic",bin,bin
		filedef Pal_GHZ,"Palettes\Green Hill Zone",bin,bin
		filedef Pal_LZ,"Palettes\Labyrinth Zone",bin,bin
		filedef Pal_LZWater,"Palettes\Labyrinth Zone Underwater",bin,bin
		filedef Pal_MZ,"Palettes\Marble Zone",bin,bin
		filedef Pal_SLZ,"Palettes\Star Light Zone",bin,bin
		filedef Pal_SYZ,"Palettes\Spring Yard Zone",bin,bin
		filedef Pal_SBZ1,"Palettes\SBZ Act 1",bin,bin
		filedef Pal_SBZ2,"Palettes\SBZ Act 2",bin,bin
		filedef Pal_Special,"Palettes\Special Stage",bin,bin
		filedef Pal_SBZ3,"Palettes\SBZ Act 3",bin,bin
		filedef Pal_SBZ3Water,"Palettes\SBZ Act 3 Underwater",bin,bin
		filedef Pal_LZSonWater,"Palettes\Sonic - LZ Underwater",bin,bin
		filedef Pal_SBZ3SonWat,"Palettes\Sonic - SBZ3 Underwater",bin,bin
		filedef Pal_SSResult,"Palettes\Special Stage Results",bin,bin
		filedef Pal_Continue,"Palettes\Special Stage Continue Bonus",bin,bin
		filedef Pal_Ending,"Palettes\Ending",bin,bin

; ---------------------------------------------------------------------------
; File definitions - sound
; ---------------------------------------------------------------------------

		filedef	SegaPCM,"sound\dac\sega",pcm,pcm
