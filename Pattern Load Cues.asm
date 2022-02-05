; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
PatternLoadCues:
		index *
		ptr PLC_Main
		ptr PLC_Main2
		ptr PLC_Explode
		ptr PLC_GameOver
PLC_Levels:
		ptr PLC_GHZ
		ptr PLC_GHZ2
		ptr PLC_LZ
		ptr PLC_LZ2
		ptr PLC_MZ
		ptr PLC_MZ2
		ptr PLC_SLZ
		ptr PLC_SLZ2
		ptr PLC_SYZ
		ptr PLC_SYZ2
		ptr PLC_SBZ
		ptr PLC_SBZ2
		zonewarning PLC_Levels,4
		ptr PLC_TitleCard
		ptr PLC_Boss
		ptr PLC_Signpost
		ptr PLC_Warp
		ptr PLC_SpecialStage
PLC_Animals:
		ptr PLC_GHZAnimals
		ptr PLC_LZAnimals
		ptr PLC_MZAnimals
		ptr PLC_SLZAnimals
		ptr PLC_SYZAnimals
		ptr PLC_SBZAnimals
		zonewarning PLC_Animals,2
		ptr PLC_SSResult
		ptr PLC_Ending
		ptr PLC_TryAgain
		ptr PLC_EggmanSBZ2
		ptr PLC_FZBoss

plcm:		macro gfx,vram,suffix
		dc.l gfx
		if strlen("\vram")>0
			plcm_vram: = \vram
		else
			plcm_vram: = last_vram
		endc
		last_vram: = plcm_vram+sizeof_\gfx
		dc.w plcm_vram
		if strlen("\suffix")>0
			tile_\gfx\_\suffix: equ plcm_vram/$20
			vram_\gfx\_\suffix: equ plcm_vram
		else
			if ~def(tile_\gfx)
			tile_\gfx: equ plcm_vram/$20
			vram_\gfx: equ plcm_vram
			endc
		endc
		endm

plcheader:	macro *
		\*: equ *
		plc_count\@: equ (\*_end-*-2)/sizeof_plc
		dc.w plc_count\@-1
		endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	plcheader
		plcm	Nem_Lamp, $F400				; lamppost
		plcm	Nem_Hud, $D940				; HUD
		plcm	Nem_Lives, $FA80			; lives	counter
		plcm	Nem_Ring, $F640				; rings
		plcm	Nem_Points, $F2E0			; points from enemy
	PLC_Main_end:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	plcheader
		plcm	Nem_Monitors, $D000			; monitors
		plcm	Nem_Shield, $A820			; shield
		plcm	Nem_Stars				; invincibility	stars ($AB80)
	PLC_Main2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	plcheader
		plcm	Nem_Explode, $B400			; explosion
	PLC_Explode_end:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	plcheader
		plcm	Nem_GameOver, $ABC0			; game/time over
	PLC_GameOver_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	plcheader
		plcm	Nem_GHZ_1st, 0				; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0			; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00			; flower stalk
		plcm	Nem_PplRock, $7A00			; purple rock
		plcm	Nem_Crabmeat, vram_crabmeat		; crabmeat enemy ($8000)
		plcm	Nem_Buzz, vram_buzz			; buzz bomber enemy ($8880)
		plcm	Nem_Chopper				; chopper enemy ($8F60)
		plcm	Nem_Newtron				; newtron enemy ($9360)
		plcm	Nem_Motobug				; motobug enemy ($9E00)
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
	PLC_GHZ_end:

PLC_GHZ2:	plcheader
		plcm	Nem_Swing, $7000			; swinging platform
		plcm	Nem_Bridge				; bridge ($71C0)
		plcm	Nem_SpikePole				; spiked pole ($7300)
		plcm	Nem_Ball				; giant	ball ($7540)
		plcm	Nem_GhzWall1, $A1E0			; breakable wall
		plcm	Nem_GhzWall2, $6980			; normal wall
	PLC_GHZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		plcheader
		plcm	Nem_LZ,0				; LZ main patterns
		plcm	Nem_LzBlock1, $3C00			; block
		plcm	Nem_LzBlock2				; blocks ($3E00)
		plcm	Nem_Splash, $4B20			; waterfalls and splash
		plcm	Nem_Water, $6000			; water	surface
		plcm	Nem_LzSpikeBall				; spiked ball ($6200)
		plcm	Nem_FlapDoor				; flapping door ($6500)
		plcm	Nem_Bubbles				; bubbles and numbers ($6900)
		plcm	Nem_LzBlock3				; block ($7780)
		plcm	Nem_LzDoor1				; vertical door ($7880)
		plcm	Nem_Harpoon				; harpoon ($7980)
		plcm	Nem_Burrobot, $94C0			; burrobot enemy
	PLC_LZ_end:

PLC_LZ2:	plcheader
		plcm	Nem_LzPole, $7BC0			; pole that breaks
		plcm	Nem_LzDoor2				; large	horizontal door ($7CC0)
		plcm	Nem_LzWheel				; wheel ($7EC0)
		plcm	Nem_Gargoyle, $5D20			; gargoyle head
		if Revision=0
		plcm	Nem_LzSonic, $8800			; Sonic	holding	his breath
		endc
		plcm	Nem_LzPlatfm, $89E0			; rising platform
		plcm	Nem_Orbinaut,,LZ			; orbinaut enemy ($8CE0)
		plcm	Nem_Jaws				; jaws enemy ($90C0)
		plcm	Nem_LzSwitch, vram_button		; switch ($A1E0)
		plcm	Nem_Cork, $A000				; cork block
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
	PLC_LZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		plcheader
		plcm	Nem_MZ,0				; MZ main patterns
		plcm	Nem_MzMetal, $6000			; metal	blocks
		plcm	Nem_Fireball				; fireballs ($68A0)
		plcm	Nem_Swing, $7000			; swinging platform
		plcm	Nem_MzGlass				; green	glassy block ($71C0)
		plcm	Nem_Lava				; lava ($7500)
		plcm	Nem_Buzz, vram_buzz			; buzz bomber enemy ($8880)
		plcm	Nem_Yadrin, vram_yadrin			; yadrin enemy ($8F60)
		plcm	Nem_Batbrain				; basaran enemy ($9700)
		plcm	Nem_Cater, vram_cater			; caterkiller enemy ($9FE0)
	PLC_MZ_end:

PLC_MZ2:	plcheader
		plcm	Nem_MzSwitch, $A260			; switch
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
		plcm	Nem_MzBlock, $5700			; green	stone block
	PLC_MZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	plcheader
		plcm	Nem_SLZ,0				; SLZ main patterns
		plcm	Nem_Bomb, vram_bomb			; bomb enemy ($8000)
		plcm	Nem_Orbinaut, vram_orbinaut		; orbinaut enemy ($8520)
		plcm	Nem_Fireball, $9000,SLZ			; fireballs
		plcm	Nem_SlzBlock, $9C00			; block
		plcm	Nem_SlzWall, $A260			; breakable wall
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
	PLC_SLZ_end:

PLC_SLZ2:	plcheader
		plcm	Nem_Seesaw, $6E80			; seesaw
		plcm	Nem_Fan					; fan ($7400)
		plcm	Nem_Pylon				; foreground pylon ($7980)
		plcm	Nem_SlzSwing				; swinging platform ($7B80)
		plcm	Nem_SlzCannon, $9B00			; fireball launcher
		plcm	Nem_SlzSpike, $9E00			; spikeball
	PLC_SLZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Spring Yard
; ---------------------------------------------------------------------------
PLC_SYZ:	plcheader
		plcm	Nem_SYZ,0				; SYZ main patterns
		plcm	Nem_Crabmeat, vram_crabmeat		; crabmeat enemy ($8000)
		plcm	Nem_Buzz, vram_buzz			; buzz bomber enemy ($8880)
		plcm	Nem_Yadrin, vram_yadrin			; yadrin enemy ($8F60)
		plcm	Nem_Roller				; roller enemy ($9700)
	PLC_SYZ_end:

PLC_SYZ2:	plcheader
		plcm	Nem_Bumper, $7000			; bumper
		plcm	Nem_BigSpike				; large	spikeball ($72C0)
		plcm	Nem_SmallSpike				; small	spikeball ($7740)
		plcm	Nem_Cater, vram_cater			; caterkiller enemy ($9FE0)
		plcm	Nem_LzSwitch, vram_button		; switch ($A1E0)
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
	PLC_SYZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Scrap Brain
; ---------------------------------------------------------------------------
PLC_SBZ:	plcheader
		plcm	Nem_SBZ,0				; SBZ main patterns
		plcm	Nem_Stomper, $5800			; moving platform and stomper
		plcm	Nem_SbzDoor1				; door ($5D00)
		plcm	Nem_Girder				; girder ($5E00)
		plcm	Nem_BallHog				; ball hog enemy ($6040)
		plcm	Nem_SbzWheel1, $6880			; spot on large	wheel
		plcm	Nem_SbzWheel2				; wheel	that grabs Sonic ($6900)
		plcm	Nem_BigSpike,,SBZ			; large	spikeball ($7220)
		plcm	Nem_Cutter				; pizza	cutter ($76A0)
		plcm	Nem_FlamePipe				; flaming pipe ($7B20)
		plcm	Nem_SbzFloor				; collapsing floor ($7EA0)
		plcm	Nem_SbzBlock, $9860			; vanishing block
	PLC_SBZ_end:

PLC_SBZ2:	plcheader
		plcm	Nem_Cater, $5600, SBZ			; caterkiller enemy
		plcm	Nem_Bomb, vram_bomb			; bomb enemy ($8000)
		plcm	Nem_Orbinaut, vram_orbinaut		; orbinaut enemy ($8520)
		plcm	Nem_SlideFloor, $8C00			; floor	that slides away
		plcm	Nem_SbzDoor2				; horizontal door ($8DE0)
		plcm	Nem_Electric				; electric orb ($8FC0)
		plcm	Nem_TrapDoor				; trapdoor ($9240)
		plcm	Nem_SbzFloor, $7F20			; collapsing floor
		plcm	Nem_SpinPform, $9BE0			; small	spinning platform
		plcm	Nem_LzSwitch, vram_button		; switch ($A1E0)
		plcm	Nem_Spikes, vram_spikes			; spikes
		plcm	Nem_HSpring, vram_hspring		; horizontal spring
		plcm	Nem_VSpring, vram_vspring		; vertical spring
	PLC_SBZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	plcheader
		plcm	Nem_TitleCard, $B000
	PLC_TitleCard_end:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	plcheader
		plcm	Nem_Eggman, $8000			; Eggman main patterns
		plcm	Nem_Weapons				; Eggman's weapons ($8D80)
		plcm	Nem_Prison, $93A0			; prison capsule
		plcm	Nem_Bomb, $A300, Boss			; bomb enemy (partially overwritten - shrapnel remains)
		plcm	Nem_SlzSpike, $A300, Boss		; spikeball (SLZ boss)
		plcm	Nem_Exhaust, $A540			; exhaust flame
	PLC_Boss_end:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	plcheader
		plcm	Nem_SignPost, $D000			; signpost
		plcm	Nem_Bonus, $96C0			; hidden bonus points
		plcm	Nem_BigFlash, $8C40			; giant	ring flash effect
	PLC_Signpost_end:
; ---------------------------------------------------------------------------
; Pattern load cues - beta special stage warp effect
; ---------------------------------------------------------------------------
		if Revision=0
PLC_Warp:	plcheader
		plcm	Nem_Warp, $A820
		else
PLC_Warp:
		endc
	PLC_Warp_end:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	plcheader
		plcm	Nem_SSBgCloud, 0			; bubble and cloud background
		plcm	Nem_SSBgFish				; bird and fish	background ($A20)
		plcm	Nem_SSWalls				; walls ($2840)
		plcm	Nem_Bumper,,SS				; bumper ($4760)
		plcm	Nem_SSGOAL				; GOAL block ($4A20)
		plcm	Nem_SSUpDown				; UP and DOWN blocks ($4C60)
		plcm	Nem_SSRBlock, $5E00			; R block
		plcm	Nem_SS1UpBlock, $6E00			; 1UP block
		plcm	Nem_SSEmStars, $7E00			; emerald collection stars
		plcm	Nem_SSRedWhite, $8E00			; red and white	block
		plcm	Nem_SSGhost, $9E00			; ghost	block
		plcm	Nem_SSWBlock, $AE00			; W block
		plcm	Nem_SSGlass, $BE00			; glass	block
		plcm	Nem_SSEmerald, $EE00			; emeralds
		plcm	Nem_SSZone1, $F2E0			; ZONE 1 block
		plcm	Nem_SSZone2				; ZONE 2 block ($F400)
		plcm	Nem_SSZone3				; ZONE 3 block ($F520)
	PLC_SpecialStage_end:
		plcm	Nem_SSZone4, $F2E0			; ZONE 4 block
		plcm	Nem_SSZone5				; ZONE 5 block ($F400)
		plcm	Nem_SSZone6				; ZONE 6 block ($F520)
; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	plcheader
		plcm	Nem_Rabbit, vram_animal1		; rabbit
		plcm	Nem_Flicky, vram_animal2		; flicky
	PLC_GHZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	plcheader
		plcm	Nem_BlackBird, vram_animal1		; blackbird
		plcm	Nem_Seal, vram_animal2			; seal
	PLC_LZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	plcheader
		plcm	Nem_Squirrel, vram_animal1		; squirrel
		plcm	Nem_Seal, vram_animal2			; seal
	PLC_MZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	plcheader
		plcm	Nem_Pig, vram_animal1			; pig
		plcm	Nem_Flicky, vram_animal2		; flicky
	PLC_SLZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - SYZ animals
; ---------------------------------------------------------------------------
PLC_SYZAnimals:	plcheader
		plcm	Nem_Pig, vram_animal1			; pig
		plcm	Nem_Chicken, vram_animal2		; chicken
	PLC_SYZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - SBZ animals
; ---------------------------------------------------------------------------
PLC_SBZAnimals:	plcheader
		plcm	Nem_Rabbit, vram_animal1		; rabbit
		plcm	Nem_Chicken, vram_animal2		; chicken
	PLC_SBZAnimals_end:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage results screen
; ---------------------------------------------------------------------------
PLC_SSResult:	plcheader
		plcm	Nem_ResultEm, $A820			; emeralds
		plcm	Nem_MiniSonic				; mini Sonic ($AA20)
	PLC_SSResult_end:
; ---------------------------------------------------------------------------
; Pattern load cues - ending sequence
; ---------------------------------------------------------------------------
PLC_Ending:	plcheader
		plcm	Nem_GHZ_1st,0				; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0			; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00			; flower stalk
		plcm	Nem_EndFlower, $7400			; flowers
		plcm	Nem_EndEm				; emeralds ($78A0)
		plcm	Nem_EndSonic				; Sonic ($7C20)
		if Revision=0
		plcm	Nem_EndEggman, $A480			; Eggman's death (unused)
		endc
		plcm	Nem_Rabbit, $AA60, End			; rabbit
		plcm	Nem_Chicken,, End			; chicken ($ACA0)
		plcm	Nem_BlackBird,, End			; blackbird ($AE60)
		plcm	Nem_Seal,, End				; seal ($B0A0)
		plcm	Nem_Pig,, End				; pig ($B260)
		plcm	Nem_Flicky,, End			; flicky ($B4A0)
		plcm	Nem_Squirrel,, End			; squirrel ($B660)
		plcm	Nem_EndStH				; "SONIC THE HEDGEHOG" ($B8A0)
	PLC_Ending_end:
; ---------------------------------------------------------------------------
; Pattern load cues - "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
PLC_TryAgain:	plcheader
		plcm	Nem_EndEm, $78A0, TryAgain		; emeralds
		plcm	Nem_TryAgain				; Eggman ($7C20)
		plcm	Nem_CreditText, vram_credits		; credits alphabet ($B400)
	PLC_TryAgain_end:
; ---------------------------------------------------------------------------
; Pattern load cues - Eggman on SBZ 2
; ---------------------------------------------------------------------------
PLC_EggmanSBZ2:	plcheader
		plcm	Nem_SbzBlock, $A300, SBZ2		; block
		plcm	Nem_Sbz2Eggman, $8000			; Eggman
		plcm	Nem_LzSwitch, $9400, SBZ2		; switch
	PLC_EggmanSBZ2_end:
; ---------------------------------------------------------------------------
; Pattern load cues - final boss
; ---------------------------------------------------------------------------
PLC_FZBoss:	plcheader
		plcm	Nem_FzEggman, $7400			; Eggman after boss
		plcm	Nem_FzBoss, $6000			; FZ boss
		plcm	Nem_Eggman, $8000			; Eggman main patterns
		plcm	Nem_Sbz2Eggman, $8E00, FZ		; Eggman without ship
		plcm	Nem_Exhaust, $A540			; exhaust flame
	PLC_FZBoss_end:
		even
