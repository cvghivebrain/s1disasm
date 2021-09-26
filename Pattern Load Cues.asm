; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
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

plcm:	macro gfx,vram,suffix
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
	else
		if ~def(tile_\gfx)
		tile_\gfx: equ plcm_vram/$20
		endc
	endc
	endm

vram_crabmeat:	equ $8000
vram_bomb:	equ $8000
vram_orbinaut:	equ $8520
vram_buzz:	equ $8880
vram_yadrin:	equ $8F60
vram_cater:	equ $9FE0
vram_button:	equ $A1E0
vram_spikes:	equ $A360
vram_hspring:	equ $A460
vram_vspring:	equ $A660
vram_animal1:	equ $B000
vram_animal2:	equ $B240

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main-2)/6)-1
		plcm	Nem_Lamp, $F400		; lamppost
		plcm	Nem_Hud, $D940		; HUD
		plcm	Nem_Lives, $FA80	; lives	counter
		plcm	Nem_Ring, $F640 	; rings
		plcm	Nem_Points, $F2E0	; points from enemy
	PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	dc.w ((PLC_Main2end-PLC_Main2-2)/6)-1
		plcm	Nem_Monitors, $D000	; monitors
		plcm	Nem_Shield, $A820	; shield
		plcm	Nem_Stars	 	; invincibility	stars ($AB80)
	PLC_Main2end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	dc.w ((PLC_Explodeend-PLC_Explode-2)/6)-1
		plcm	Nem_Explode, $B400	; explosion
	PLC_Explodeend:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	dc.w ((PLC_GameOverend-PLC_GameOver-2)/6)-1
		plcm	Nem_GameOver, $ABC0	; game/time over
	PLC_GameOverend:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	dc.w ((PLC_GHZ2-PLC_GHZ-2)/6)-1
		plcm	Nem_GHZ_1st, 0		; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0	; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00	; flower stalk
		plcm	Nem_PplRock, $7A00	; purple rock
		plcm	Nem_Crabmeat, vram_crabmeat ; crabmeat enemy ($8000)
		plcm	Nem_Buzz, vram_buzz	; buzz bomber enemy ($8880)
		plcm	Nem_Chopper		; chopper enemy ($8F60)
		plcm	Nem_Newtron		; newtron enemy ($9360)
		plcm	Nem_Motobug		; motobug enemy ($9E00)
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring ; horizontal spring
		plcm	Nem_VSpring, vram_vspring ; vertical spring

PLC_GHZ2:	dc.w ((PLC_GHZ2end-PLC_GHZ2-2)/6)-1
		plcm	Nem_Swing, $7000	; swinging platform
		plcm	Nem_Bridge		; bridge ($71C0)
		plcm	Nem_SpikePole		; spiked pole ($7300)
		plcm	Nem_Ball		; giant	ball ($7540)
		plcm	Nem_GhzWall1, $A1E0	; breakable wall
		plcm	Nem_GhzWall2, $6980	; normal wall
	PLC_GHZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		dc.w ((PLC_LZ2-PLC_LZ-2)/6)-1
		plcm	Nem_LZ,0		; LZ main patterns
		plcm	Nem_LzBlock1, $3C00	; block
		plcm	Nem_LzBlock2		; blocks ($3E00)
		plcm	Nem_Splash, $4B20	; waterfalls and splash
		plcm	Nem_Water, $6000	; water	surface
		plcm	Nem_LzSpikeBall		; spiked ball ($6200)
		plcm	Nem_FlapDoor		; flapping door ($6500)
		plcm	Nem_Bubbles		; bubbles and numbers ($6900)
		plcm	Nem_LzBlock3		; block ($7780)
		plcm	Nem_LzDoor1		; vertical door ($7880)
		plcm	Nem_Harpoon		; harpoon ($7980)
		plcm	Nem_Burrobot, $94C0	; burrobot enemy

PLC_LZ2:	dc.w ((PLC_LZ2end-PLC_LZ2-2)/6)-1
		plcm	Nem_LzPole, $7BC0	; pole that breaks
		plcm	Nem_LzDoor2		; large	horizontal door ($7CC0)
		plcm	Nem_LzWheel		; wheel ($7EC0)
		plcm	Nem_Gargoyle, $5D20	; gargoyle head
		if Revision=0
		plcm	Nem_LzSonic, $8800	; Sonic	holding	his breath
		endc
		plcm	Nem_LzPlatfm, $89E0	; rising platform
		plcm	Nem_Orbinaut,,LZ	; orbinaut enemy ($8CE0)
		plcm	Nem_Jaws		; jaws enemy ($90C0)
		plcm	Nem_LzSwitch, vram_button ; switch ($A1E0)
		plcm	Nem_Cork, $A000		; cork block
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring ; horizontal spring
		plcm	Nem_VSpring, vram_vspring ; vertical spring
	PLC_LZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		dc.w ((PLC_MZ2-PLC_MZ-2)/6)-1
		plcm	Nem_MZ,0		; MZ main patterns
		plcm	Nem_MzMetal, $6000	; metal	blocks
		plcm	Nem_Fireball		; fireballs ($68A0)
		plcm	Nem_Swing, $7000	; swinging platform
		plcm	Nem_MzGlass		; green	glassy block ($71C0)
		plcm	Nem_Lava		; lava ($7500)
		plcm	Nem_Buzz, vram_buzz	; buzz bomber enemy ($8880)
		plcm	Nem_Yadrin, vram_yadrin	; yadrin enemy ($8F60)
		plcm	Nem_Batbrain		; basaran enemy ($9700)
		plcm	Nem_Cater, vram_cater	; caterkiller enemy ($9FE0)

PLC_MZ2:	dc.w ((PLC_MZ2end-PLC_MZ2-2)/6)-1
		plcm	Nem_MzSwitch, $A260	; switch
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring	; horizontal spring
		plcm	Nem_VSpring, vram_vspring	; vertical spring
		plcm	Nem_MzBlock, $5700	; green	stone block
	PLC_MZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	dc.w ((PLC_SLZ2-PLC_SLZ-2)/6)-1
		plcm	Nem_SLZ,0		; SLZ main patterns
		plcm	Nem_Bomb, vram_bomb	; bomb enemy ($8000)
		plcm	Nem_Orbinaut, vram_orbinaut ; orbinaut enemy ($8520)
		plcm	Nem_Fireball, $9000,SLZ	; fireballs
		plcm	Nem_SlzBlock, $9C00	; block
		plcm	Nem_SlzWall, $A260	; breakable wall
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring ; horizontal spring
		plcm	Nem_VSpring, vram_vspring ; vertical spring

PLC_SLZ2:	dc.w ((PLC_SLZ2end-PLC_SLZ2-2)/6)-1
		plcm	Nem_Seesaw, $6E80	; seesaw
		plcm	Nem_Fan			; fan ($7400)
		plcm	Nem_Pylon		; foreground pylon ($7980)
		plcm	Nem_SlzSwing		; swinging platform ($7B80)
		plcm	Nem_SlzCannon, $9B00	; fireball launcher
		plcm	Nem_SlzSpike, $9E00	; spikeball
	PLC_SLZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Spring Yard
; ---------------------------------------------------------------------------
PLC_SYZ:	dc.w ((PLC_SYZ2-PLC_SYZ-2)/6)-1
		plcm	Nem_SYZ,0		; SYZ main patterns
		plcm	Nem_Crabmeat, vram_crabmeat ; crabmeat enemy ($8000)
		plcm	Nem_Buzz, vram_buzz	; buzz bomber enemy ($8880)
		plcm	Nem_Yadrin, vram_yadrin	; yadrin enemy ($8F60)
		plcm	Nem_Roller		; roller enemy ($9700)

PLC_SYZ2:	dc.w ((PLC_SYZ2end-PLC_SYZ2-2)/6)-1
		plcm	Nem_Bumper, $7000	; bumper
		plcm	Nem_BigSpike		; large	spikeball ($72C0)
		plcm	Nem_SmallSpike		; small	spikeball ($7740)
		plcm	Nem_Cater, vram_cater	; caterkiller enemy ($9FE0)
		plcm	Nem_LzSwitch, vram_button ; switch ($A1E0)
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring ; horizontal spring
		plcm	Nem_VSpring, vram_vspring ; vertical spring
	PLC_SYZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Scrap Brain
; ---------------------------------------------------------------------------
PLC_SBZ:	dc.w ((PLC_SBZ2-PLC_SBZ-2)/6)-1
		plcm	Nem_SBZ,0		; SBZ main patterns
		plcm	Nem_Stomper, $5800	; moving platform and stomper
		plcm	Nem_SbzDoor1		; door ($5D00)
		plcm	Nem_Girder		; girder ($5E00)
		plcm	Nem_BallHog		; ball hog enemy ($6040)
		plcm	Nem_SbzWheel1, $6880	; spot on large	wheel
		plcm	Nem_SbzWheel2		; wheel	that grabs Sonic ($6900)
		plcm	Nem_BigSpike,,SBZ	; large	spikeball ($7220)
		plcm	Nem_Cutter		; pizza	cutter ($76A0)
		plcm	Nem_FlamePipe		; flaming pipe ($7B20)
		plcm	Nem_SbzFloor		; collapsing floor ($7EA0)
		plcm	Nem_SbzBlock, $9860	; vanishing block

PLC_SBZ2:	dc.w ((PLC_SBZ2end-PLC_SBZ2-2)/6)-1
		plcm	Nem_Cater, $5600, SBZ	; caterkiller enemy
		plcm	Nem_Bomb, vram_bomb	; bomb enemy ($8000)
		plcm	Nem_Orbinaut, vram_orbinaut ; orbinaut enemy ($8520)
		plcm	Nem_SlideFloor, $8C00	; floor	that slides away
		plcm	Nem_SbzDoor2		; horizontal door ($8DE0)
		plcm	Nem_Electric		; electric orb ($8FC0)
		plcm	Nem_TrapDoor		; trapdoor ($9240)
		plcm	Nem_SbzFloor, $7F20	; collapsing floor
		plcm	Nem_SpinPform, $9BE0	; small	spinning platform
		plcm	Nem_LzSwitch, vram_button ; switch ($A1E0)
		plcm	Nem_Spikes, vram_spikes	; spikes
		plcm	Nem_HSpring, vram_hspring ; horizontal spring
		plcm	Nem_VSpring, vram_vspring ; vertical spring
	PLC_SBZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	dc.w ((PLC_TitleCardend-PLC_TitleCard-2)/6)-1
		plcm	Nem_TitleCard, $B000
	PLC_TitleCardend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	dc.w ((PLC_Bossend-PLC_Boss-2)/6)-1
		plcm	Nem_Eggman, $8000	; Eggman main patterns
		plcm	Nem_Weapons		; Eggman's weapons ($8D80)
		plcm	Nem_Prison, $93A0	; prison capsule
		plcm	Nem_Bomb, $A300, Boss	; bomb enemy (partially overwritten - shrapnel remains)
		plcm	Nem_SlzSpike, $A300, Boss ; spikeball (SLZ boss)
		plcm	Nem_Exhaust, $A540	; exhaust flame
	PLC_Bossend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	dc.w ((PLC_Signpostend-PLC_Signpost-2)/6)-1
		plcm	Nem_SignPost, $D000	; signpost
		plcm	Nem_Bonus, $96C0	; hidden bonus points
		plcm	Nem_BigFlash, $8C40	; giant	ring flash effect
	PLC_Signpostend:
; ---------------------------------------------------------------------------
; Pattern load cues - beta special stage warp effect
; ---------------------------------------------------------------------------
PLC_Warp:
		if Revision=0
		dc.w ((PLC_Warpend-PLC_Warp-2)/6)-1
		plcm	Nem_Warp, $A820
		endc
	PLC_Warpend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	dc.w ((PLC_SpeStageend-PLC_SpecialStage-2)/6)-1
		plcm	Nem_SSBgCloud, 0	; bubble and cloud background
		plcm	Nem_SSBgFish		; bird and fish	background ($A20)
		plcm	Nem_SSWalls		; walls ($2840)
		plcm	Nem_Bumper		; bumper ($4760)
		plcm	Nem_SSGOAL		; GOAL block ($4A20)
		plcm	Nem_SSUpDown		; UP and DOWN blocks ($4C60)
		plcm	Nem_SSRBlock, $5E00	; R block
		plcm	Nem_SS1UpBlock, $6E00	; 1UP block
		plcm	Nem_SSEmStars, $7E00	; emerald collection stars
		plcm	Nem_SSRedWhite, $8E00	; red and white	block
		plcm	Nem_SSGhost, $9E00	; ghost	block
		plcm	Nem_SSWBlock, $AE00	; W block
		plcm	Nem_SSGlass, $BE00	; glass	block
		plcm	Nem_SSEmerald, $EE00	; emeralds
		plcm	Nem_SSZone1, $F2E0	; ZONE 1 block
		plcm	Nem_SSZone2		; ZONE 2 block ($F400)
		plcm	Nem_SSZone3		; ZONE 3 block ($F520)
	PLC_SpeStageend:
		plcm	Nem_SSZone4, $F2E0	; ZONE 4 block
		plcm	Nem_SSZone5		; ZONE 5 block ($F400)
		plcm	Nem_SSZone6		; ZONE 6 block ($F520)
; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	dc.w ((PLC_GHZAnimalsend-PLC_GHZAnimals-2)/6)-1
		plcm	Nem_Rabbit, vram_animal1	; rabbit
		plcm	Nem_Flicky, vram_animal2	; flicky
	PLC_GHZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	dc.w ((PLC_LZAnimalsend-PLC_LZAnimals-2)/6)-1
		plcm	Nem_BlackBird, vram_animal1	; blackbird
		plcm	Nem_Seal, vram_animal2		; seal
	PLC_LZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	dc.w ((PLC_MZAnimalsend-PLC_MZAnimals-2)/6)-1
		plcm	Nem_Squirrel, vram_animal1	; squirrel
		plcm	Nem_Seal, vram_animal2		; seal
	PLC_MZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	dc.w ((PLC_SLZAnimalsend-PLC_SLZAnimals-2)/6)-1
		plcm	Nem_Pig, vram_animal1		; pig
		plcm	Nem_Flicky, vram_animal2	; flicky
	PLC_SLZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SYZ animals
; ---------------------------------------------------------------------------
PLC_SYZAnimals:	dc.w ((PLC_SYZAnimalsend-PLC_SYZAnimals-2)/6)-1
		plcm	Nem_Pig, vram_animal1		; pig
		plcm	Nem_Chicken, vram_animal2	; chicken
	PLC_SYZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SBZ animals
; ---------------------------------------------------------------------------
PLC_SBZAnimals:	dc.w ((PLC_SBZAnimalsend-PLC_SBZAnimals-2)/6)-1
		plcm	Nem_Rabbit, vram_animal1		; rabbit
		plcm	Nem_Chicken, vram_animal2	; chicken
	PLC_SBZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage results screen
; ---------------------------------------------------------------------------
PLC_SSResult:dc.w ((PLC_SpeStResultend-PLC_SSResult-2)/6)-1
		plcm	Nem_ResultEm, $A820	; emeralds
		plcm	Nem_MiniSonic		; mini Sonic ($AA20)
	PLC_SpeStResultend:
; ---------------------------------------------------------------------------
; Pattern load cues - ending sequence
; ---------------------------------------------------------------------------
PLC_Ending:	dc.w ((PLC_Endingend-PLC_Ending-2)/6)-1
		plcm	Nem_GHZ_1st,0		; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0	; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00	; flower stalk
		plcm	Nem_EndFlower, $7400	; flowers
		plcm	Nem_EndEm		; emeralds ($78A0)
		plcm	Nem_EndSonic		; Sonic ($7C20)
		if Revision=0
		plcm	Nem_EndEggman, $A480	; Eggman's death (unused)
		endc
		plcm	Nem_Rabbit, $AA60	; rabbit
		plcm	Nem_Chicken		; chicken ($ACA0)
		plcm	Nem_BlackBird		; blackbird ($AE60)
		plcm	Nem_Seal		; seal ($B0A0)
		plcm	Nem_Pig			; pig ($B260)
		plcm	Nem_Flicky		; flicky ($B4A0)
		plcm	Nem_Squirrel		; squirrel ($B660)
		plcm	Nem_EndStH		; "SONIC THE HEDGEHOG" ($B8A0)
	PLC_Endingend:
; ---------------------------------------------------------------------------
; Pattern load cues - "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
PLC_TryAgain:	dc.w ((PLC_TryAgainend-PLC_TryAgain-2)/6)-1
		plcm	Nem_EndEm, $78A0, TryAgain ; emeralds
		plcm	Nem_TryAgain		; Eggman ($7C20)
		plcm	Nem_CreditText, $B400	; credits alphabet
	PLC_TryAgainend:
; ---------------------------------------------------------------------------
; Pattern load cues - Eggman on SBZ 2
; ---------------------------------------------------------------------------
PLC_EggmanSBZ2:	dc.w ((PLC_EggmanSBZ2end-PLC_EggmanSBZ2-2)/6)-1
		plcm	Nem_SbzBlock, $A300	; block
		plcm	Nem_Sbz2Eggman, $8000	; Eggman
		plcm	Nem_LzSwitch, $9400, SBZ2 ; switch
	PLC_EggmanSBZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - final boss
; ---------------------------------------------------------------------------
PLC_FZBoss:	dc.w ((PLC_FZBossend-PLC_FZBoss-2)/6)-1
		plcm	Nem_FzEggman, $7400	; Eggman after boss
		plcm	Nem_FzBoss, $6000	; FZ boss
		plcm	Nem_Eggman, $8000	; Eggman main patterns
		plcm	Nem_Sbz2Eggman, $8E00, FZ ; Eggman without ship
		plcm	Nem_Exhaust, $A540	; exhaust flame
	PLC_FZBossend:
		even
