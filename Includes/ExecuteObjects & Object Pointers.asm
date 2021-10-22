; ---------------------------------------------------------------------------
; Object code execution subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


		lea	(v_ost_all).w,a0 ; set address for object RAM
		moveq	#$7F,d7
		moveq	#0,d0
		cmpi.b	#6,(v_ost_player+ost_routine).w
		bhs.s	loc_D362

loc_D348:
		move.b	(a0),d0		; load object number from RAM
		beq.s	loc_D358
		add.w	d0,d0
		add.w	d0,d0
		movea.l	Obj_Index-4(pc,d0.w),a1
		jsr	(a1)		; run the object's code
		moveq	#0,d0

loc_D358:
		lea	SST_size(a0),a0	; next object
		dbf	d7,loc_D348
		rts	
; ===========================================================================

loc_D362:
		moveq	#$1F,d7
		bsr.s	loc_D348
		moveq	#$5F,d7

loc_D368:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_D378
		tst.b	ost_render(a0)
		bpl.s	loc_D378
		bsr.w	DisplaySprite

loc_D378:
		lea	SST_size(a0),a0

loc_D37C:
		dbf	d7,loc_D368
		rts
; End of function ExecuteObjects

; ===========================================================================
; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
Obj_Index:
		index.l 0,1		; longword, absolute (relative to 0), start ids at 1

		ptr SonicPlayer		; $01
		ptr NullObject
		ptr NullObject
		ptr NullObject		; $04
		ptr NullObject
		ptr NullObject
		ptr NullObject
		ptr Splash		; $08
		ptr SonicSpecial
		ptr DrownCount
		ptr Pole
		ptr FlapDoor		; $0C
		ptr Signpost
		ptr TitleSonic
		ptr PSBTM
		ptr Obj10		; $10
		ptr Bridge
		ptr SpinningLight
		ptr LavaMaker
		ptr LavaBall		; $14
		ptr SwingingPlatform
		ptr Harpoon
		ptr Helix
		ptr BasicPlatform	; $18
		ptr Obj19
		ptr CollapseLedge
		ptr WaterSurface
		ptr Scenery		; $1C
		ptr MagicSwitch
		ptr BallHog
		ptr Crabmeat
		ptr Cannonball		; $20
		ptr HUD
		ptr BuzzBomber
		ptr Missile
		ptr MissileDissolve	; $24
		ptr Rings
		ptr Monitor
		ptr ExplosionItem
		ptr Animals		; $28
		ptr Points
		ptr AutoDoor
		ptr Chopper
		ptr Jaws		; $2C
		ptr Burrobot
		ptr PowerUp
		ptr LargeGrass
		ptr GlassBlock		; $30
		ptr ChainStomp
		ptr Button
		ptr PushBlock
		ptr TitleCard		; $34
		ptr GrassFire
		ptr Spikes
		ptr RingLoss
		ptr ShieldItem		; $38
		ptr GameOverCard
		ptr GotThroughCard
		ptr PurpleRock
		ptr SmashWall		; $3C
		ptr BossGreenHill
		ptr Prison
		ptr ExplosionBomb
		ptr MotoBug		; $40
		ptr Springs
		ptr Newtron
		ptr Roller
		ptr EdgeWalls		; $44
		ptr SideStomp
		ptr MarbleBrick
		ptr Bumper
		ptr BossBall		; $48
		ptr WaterSound
		ptr VanishSonic
		ptr GiantRing
		ptr GeyserMaker		; $4C
		ptr LavaGeyser
		ptr LavaWall
		ptr Obj4F
		ptr Yadrin		; $50
		ptr SmashBlock
		ptr MovingBlock
		ptr CollapseFloor
		ptr LavaTag		; $54
		ptr Batbrain
		ptr FloatingBlock
		ptr SpikeBall
		ptr BigSpikeBall	; $58
		ptr Elevator
		ptr CirclingPlatform
		ptr Staircase
		ptr Pylon		; $5C
		ptr Fan
		ptr Seesaw
		ptr Bomb
		ptr Orbinaut		; $60
		ptr LabyrinthBlock
		ptr Gargoyle
		ptr LabyrinthConvey
		ptr Bubble		; $64
		ptr Waterfall
		ptr Junction
		ptr RunningDisc
		ptr Conveyor		; $68
		ptr SpinPlatform
		ptr Saws
		ptr ScrapStomp
		ptr VanishPlatform	; $6C
		ptr Flamethrower
		ptr Electro
		ptr SpinConvey
		ptr Girder		; $70
		ptr Invisibarrier
		ptr Teleport
		ptr BossMarble
		ptr BossFire		; $74
		ptr BossSpringYard
		ptr BossBlock
		ptr BossLabyrinth
		ptr Caterkiller		; $78
		ptr Lamppost
		ptr BossStarLight
		ptr BossSpikeball
		ptr RingFlash		; $7C
		ptr HiddenBonus
		ptr SSResult
		ptr SSRChaos
		ptr ContScrItem		; $80
		ptr ContSonic
		ptr ScrapEggman
		ptr FalseFloor
		ptr EggmanCylinder	; $84
		ptr BossFinal
		ptr BossPlasma
		ptr EndSonic
		ptr EndChaos		; $88
		ptr EndSTH
		ptr CreditsText
		ptr EndEggman
		ptr TryChaos		; $8C
