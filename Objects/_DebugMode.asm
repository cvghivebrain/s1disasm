; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(v_debuguse).w,d0
		move.w	Debug_Index(pc,d0.w),d1
		jmp	Debug_Index(pc,d1.w)
; ===========================================================================
Debug_Index:	index *
		ptr Debug_Main
		ptr Debug_Action
; ===========================================================================

Debug_Main:	; Routine 0
		addq.b	#2,(v_debuguse).w
		move.w	(v_limittop2).w,(v_limittopdb).w ; buffer level x-boundary
		move.w	(v_limitbtm1).w,(v_limitbtmdb).w ; buffer level y-boundary
		move.w	#0,(v_limittop2).w
		move.w	#$720,(v_limitbtm1).w
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		andi.w	#$7FF,(v_screenposy).w
		andi.w	#$3FF,(v_bgscreenposy).w
		move.b	#0,ost_frame(a0)
		move.b	#id_Walk,ost_anim(a0)
		cmpi.b	#id_Special,(v_gamemode).w ; is game mode $10 (special stage)?
		bne.s	@islevel	; if not, branch

		move.w	#0,(v_ssrotate).w ; stop special stage rotating
		move.w	#0,(v_ssangle).w ; make	special	stage "upright"
		moveq	#6,d0		; use 6th debug	item list
		bra.s	@selectlist
; ===========================================================================

@islevel:
		moveq	#0,d0
		move.b	(v_zone).w,d0

@selectlist:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(v_debugitem).w,d6 ; have you gone past the last item?
		bhi.s	@noreset	; if not, branch
		move.b	#0,(v_debugitem).w ; back to start of list

	@noreset:
		bsr.w	Debug_ShowItem
		move.b	#12,(v_debugxspeed).w
		move.b	#1,(v_debugyspeed).w

Debug_Action:	; Routine 2
		moveq	#6,d0
		cmpi.b	#id_Special,(v_gamemode).w
		beq.s	@isntlevel

		moveq	#0,d0
		move.b	(v_zone).w,d0

	@isntlevel:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	Debug_Control
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Debug_Control:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(v_joypad_press_actual).w,d4
		andi.w	#btnDir,d4	; is up/down/left/right	pressed?
		bne.s	@dirpressed	; if yes, branch

		move.b	(v_joypad_hold_actual).w,d0
		andi.w	#btnDir,d0	; is up/down/left/right	held?
		bne.s	@dirheld	; if yes, branch

		move.b	#12,(v_debugxspeed).w
		move.b	#15,(v_debugyspeed).w
		bra.w	Debug_ChgItem
; ===========================================================================

@dirheld:
		subq.b	#1,(v_debugxspeed).w
		bne.s	loc_1D01C
		move.b	#1,(v_debugxspeed).w
		addq.b	#1,(v_debugyspeed).w
		bne.s	@dirpressed
		move.b	#-1,(v_debugyspeed).w

@dirpressed:
		move.b	(v_joypad_hold_actual).w,d4

loc_1D01C:
		moveq	#0,d1
		move.b	(v_debugyspeed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		btst	#bitUp,d4	; is up	being pressed?
		beq.s	loc_1D03C	; if not, branch
		sub.l	d1,d2
		bcc.s	loc_1D03C
		moveq	#0,d2

loc_1D03C:
		btst	#bitDn,d4	; is down being	pressed?
		beq.s	loc_1D052	; if not, branch
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_1D052
		move.l	#$7FF0000,d2

loc_1D052:
		btst	#bitL,d4
		beq.s	loc_1D05E
		sub.l	d1,d3
		bcc.s	loc_1D05E
		moveq	#0,d3

loc_1D05E:
		btst	#bitR,d4
		beq.s	loc_1D066
		add.l	d1,d3

loc_1D066:
		move.l	d2,ost_y_pos(a0)
		move.l	d3,ost_x_pos(a0)

Debug_ChgItem:
		btst	#bitA,(v_joypad_hold_actual).w ; is button A pressed?
		beq.s	@createitem	; if not, branch
		btst	#bitC,(v_joypad_press_actual).w ; is button C pressed?
		beq.s	@nextitem	; if not, branch
		subq.b	#1,(v_debugitem).w ; go back 1 item
		bcc.s	@display
		add.b	d6,(v_debugitem).w
		bra.s	@display
; ===========================================================================

@nextitem:
		btst	#bitA,(v_joypad_press_actual).w ; is button A pressed?
		beq.s	@createitem	; if not, branch
		addq.b	#1,(v_debugitem).w ; go forwards 1 item
		cmp.b	(v_debugitem).w,d6
		bhi.s	@display
		move.b	#0,(v_debugitem).w ; loop back to first item

	@display:
		bra.w	Debug_ShowItem
; ===========================================================================

@createitem:
		btst	#bitC,(v_joypad_press_actual).w ; is button C pressed?
		beq.s	@backtonormal	; if not, branch
		jsr	(FindFreeObj).l
		bne.s	@backtonormal
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_mappings(a0),0(a1)	; create object (object id is held in high byte of mappings pointer)
		move.b	ost_render(a0),ost_render(a1)
		move.b	ost_render(a0),ost_status(a1)
		andi.b	#$FF-status_onscreen,ost_status(a1) ; remove onscreen flag from status
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),ost_subtype(a1)
		rts	
; ===========================================================================

@backtonormal:
		btst	#bitB,(v_joypad_press_actual).w ; is button B pressed?
		beq.s	@stayindebug	; if not, branch
		moveq	#0,d0
		move.w	d0,(v_debuguse).w ; deactivate debug mode
		move.l	#Map_Sonic,(v_ost_player+ost_mappings).w
		move.w	#vram_sonic/$20,(v_ost_player+ost_tile).w
		move.b	d0,(v_ost_player+ost_anim).w
		move.w	d0,ost_x_sub(a0)
		move.w	d0,ost_y_sub(a0)
		move.w	(v_limittopdb).w,(v_limittop2).w ; restore level boundaries
		move.w	(v_limitbtmdb).w,(v_limitbtm1).w
		cmpi.b	#id_Special,(v_gamemode).w ; are you in the special stage?
		bne.s	@stayindebug	; if not, branch

		clr.w	(v_ssangle).w
		move.w	#$40,(v_ssrotate).w ; set new level rotation speed
		move.l	#Map_Sonic,(v_ost_player+ost_mappings).w
		move.w	#vram_sonic/$20,(v_ost_player+ost_tile).w
		move.b	#id_Roll,(v_ost_player+ost_anim).w
		bset	#status_jump_bit,(v_ost_player+ost_status).w
		bset	#status_air_bit,(v_ost_player+ost_status).w

	@stayindebug:
		rts	
; End of function Debug_Control


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Debug_ShowItem:
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),ost_mappings(a0) ; load mappings for item
		move.w	6(a2,d0.w),ost_tile(a0) ; load VRAM setting for item
		move.b	5(a2,d0.w),ost_frame(a0) ; load frame number for item
		rts	
; End of function Debug_ShowItem
; ---------------------------------------------------------------------------
; Debug	mode item lists
; ---------------------------------------------------------------------------
DebugList:	index *
		ptr @GHZ
		ptr @LZ
		ptr @MZ
		ptr @SLZ
		ptr @SYZ
		ptr @SBZ
		zonewarning DebugList,2
		ptr @Ending

dbug:		macro map,object,subtype,frame,vram
		dc.l map+(object<<24)
		dc.b subtype,frame
		dc.w vram
		endm

@GHZ:
	dc.w (@GHZend-@GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	tile_Nem_Crabmeat
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Chop,	id_Chopper,	0,	0,	tile_Nem_Chopper
	dbug	Map_Spike,	id_Spikes,	0,	0,	tile_Nem_Spikes
	dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	0+tile_pal3
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	tile_Nem_PplRock+tile_pal4
	dbug	Map_Moto,	id_MotoBug,	0,	0,	tile_Nem_Motobug
	dbug	Map_Spring,	id_Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Newt,	id_Newtron,	0,	0,	tile_Nem_Newtron+tile_pal2
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	tile_Nem_GhzWall2+tile_pal3
	dbug	Map_GBall,	id_Obj19,	0,	0,	tile_Nem_Ball+tile_pal3
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	dbug	Map_GRing,	id_GiantRing,	0,	0,	$400+tile_pal2
	dbug	Map_Bonus,	id_HiddenBonus,	1,	1,	tile_Nem_Bonus+tile_hi
	@GHZend:

@LZ:
	dc.w (@LZend-@LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Spring,	id_Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Jaws,	id_Jaws,	8,	0,	tile_Nem_Jaws+tile_pal2
	dbug	Map_Burro,	id_Burrobot,	0,	2,	tile_Nem_Burrobot+tile_hi
	dbug	Map_Harp,	id_Harpoon,	0,	0,	tile_Nem_Harpoon
	dbug	Map_Harp,	id_Harpoon,	2,	3,	tile_Nem_Harpoon
	dbug	Map_Push,	id_PushBlock,	0,	0,	tile_Nem_LzPole+tile_pal3
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Spike,	id_Spikes,	0,	0,	tile_Nem_Spikes
	dbug	Map_MBlockLZ,	id_MovingBlock,	4,	0,	tile_Nem_LzBlock3+tile_pal3
	dbug	Map_LBlock,	id_LabyrinthBlock, 1,	0,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	id_LabyrinthBlock, $13,	1,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	id_LabyrinthBlock, 5,	0,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_Gar,	id_Gargoyle,	0,	0,	$43E+tile_pal3
	dbug	Map_LBlock,	id_LabyrinthBlock, $27,	2,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	id_LabyrinthBlock, $30,	3,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LConv,	id_LabyrinthConvey, $7F, 0,	tile_Nem_LzWheel
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	tile_Nem_Orbinaut_LZ
	dbug	Map_Bub,	id_Bubble,	$84,	$13,	tile_Nem_Bubbles+tile_hi
	dbug	Map_WFall,	id_Waterfall,	2,	2,	tile_Nem_Splash+tile_pal3+tile_hi
	dbug	Map_WFall,	id_Waterfall,	9,	9,	tile_Nem_Splash+tile_pal3+tile_hi
	dbug	Map_Pole,	id_Pole,	0,	0,	tile_Nem_LzPole+tile_pal3
	dbug	Map_Flap,	id_FlapDoor,	2,	0,	tile_Nem_FlapDoor+tile_pal3
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	@LZend:

@MZ:
	dc.w (@MZend-@MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Spike,	id_Spikes,	0,	0,	tile_Nem_Spikes
	dbug	Map_Spring,	id_Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	tile_Nem_Fireball
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	0+tile_pal3
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	tile_Nem_Lava+tile_pal4
	dbug	Map_LWall,	id_LavaWall,	0,	0,	tile_Nem_Lava+tile_pal4
	dbug	Map_Push,	id_PushBlock,	0,	0,	tile_Nem_MzBlock+tile_pal3
	dbug	Map_Yad,	id_Yadrin,	0,	0,	tile_Nem_Yadrin+tile_pal2
	dbug	Map_Smab,	id_SmashBlock,	0,	0,	tile_Nem_MzBlock+tile_pal3
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	tile_Nem_MzBlock
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	tile_Nem_MzBlock+tile_pal4
	dbug	Map_LTag,	id_LavaTag,	0,	0,	tile_Nem_Monitors+tile_hi
	dbug	Map_Bat,	id_Batbrain,	0,	0,	tile_Nem_Batbrain
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	tile_Nem_Cater+tile_pal2
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	@MZend:

@SLZ:
	dc.w (@SLZend-@SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Elev,	id_Elevator,	0,	0,	0+tile_pal3
	dbug	Map_CFlo,	id_CollapseFloor, 0,	2,	tile_Nem_SlzBlock+tile_pal3
	dbug	Map_Plat_SLZ,	id_BasicPlatform, 0,	0,	0+tile_pal3
	dbug	Map_Circ,	id_CirclingPlatform, 0,	0,	0+tile_pal3
	dbug	Map_Stair,	id_Staircase,	0,	0,	0+tile_pal3
	dbug	Map_Fan,	id_Fan,		0,	0,	tile_Nem_Fan+tile_pal3
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	tile_Nem_Seesaw
	dbug	Map_Spring,	id_Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	tile_Nem_Fireball_SLZ
	dbug	Map_Scen,	id_Scenery,	0,	0,	tile_Nem_SlzCannon+tile_pal3
	dbug	Map_Bomb,	id_Bomb,	0,	0,	tile_Nem_Bomb
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	tile_Nem_Orbinaut+tile_pal2
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	@SLZend:

@SYZ:
	dc.w (@SYZend-@SYZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Spike,	id_Spikes,	0,	0,	tile_Nem_Spikes
	dbug	Map_Spring,	id_Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Roll,	id_Roller,	0,	0,	tile_Nem_Roller
	dbug	Map_Light,	id_SpinningLight, 0,	0,	0
	dbug	Map_Bump,	id_Bumper,	0,	0,	tile_Nem_Bumper
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	tile_Nem_Crabmeat
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Yad,	id_Yadrin,	0,	0,	tile_Nem_Yadrin+tile_pal2
	dbug	Map_Plat_SYZ,	id_BasicPlatform, 0,	0,	0+tile_pal3
	dbug	Map_FBlock,	id_FloatingBlock, 0,	0,	0+tile_pal3
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	tile_Nem_Cater+tile_pal2
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	@SYZend:

@SBZ:
	dc.w (@SBZend-@SBZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Bomb,	id_Bomb,	0,	0,	tile_Nem_Bomb
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	tile_Nem_Orbinaut
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	tile_Nem_Cater_SBZ+tile_pal2
	dbug	Map_BBall,	id_SwingingPlatform, 7,	2,	tile_Nem_BigSpike_SBZ+tile_pal3
	dbug	Map_Disc,	id_RunningDisc,	$E0,	0,	tile_Nem_SbzWheel1+tile_pal3+tile_hi
	dbug	Map_MBlock,	id_MovingBlock,	$28,	2,	tile_Nem_Stomper+tile_pal2
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Trap,	id_SpinPlatform, 3,	0,	tile_Nem_TrapDoor+tile_pal3
	dbug	Map_Spin,	id_SpinPlatform, $83,	0,	tile_Nem_SpinPform
	dbug	Map_Saw,	id_Saws,	2,	0,	tile_Nem_Cutter+tile_pal3
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	tile_Nem_SbzFloor+tile_pal3
	dbug	Map_MBlock,	id_MovingBlock,	$39,	3,	tile_Nem_SlideFloor+tile_pal3
	dbug	Map_Stomp,	id_ScrapStomp,	0,	0,	tile_Nem_Stomper+tile_pal2
	dbug	Map_ADoor,	id_AutoDoor,	0,	0,	tile_Nem_SbzDoor1+tile_pal3
	dbug	Map_Stomp,	id_ScrapStomp,	$13,	1,	tile_Nem_Stomper+tile_pal2
	dbug	Map_Saw,	id_Saws,	1,	0,	tile_Nem_Cutter+tile_pal3
	dbug	Map_Stomp,	id_ScrapStomp,	$24,	1,	tile_Nem_Stomper+tile_pal2
	dbug	Map_Saw,	id_Saws,	4,	2,	tile_Nem_Cutter+tile_pal3
	dbug	Map_Stomp,	id_ScrapStomp,	$34,	1,	tile_Nem_Stomper+tile_pal2
	dbug	Map_VanP,	id_VanishPlatform, 0,	0,	tile_Nem_SbzBlock+tile_pal3
	dbug	Map_Flame,	id_Flamethrower, $64,	0,	tile_Nem_FlamePipe+tile_hi
	dbug	Map_Flame,	id_Flamethrower, $64,	$B,	tile_Nem_FlamePipe+tile_hi
	dbug	Map_Elec,	id_Electro,	4,	0,	tile_Nem_Electric
	dbug	Map_Gird,	id_Girder,	0,	0,	tile_Nem_Girder+tile_pal3
	dbug	Map_Invis,	id_Invisibarrier, $11,	0,	tile_Nem_Monitors+tile_hi
	dbug	Map_Hog,	id_BallHog,	4,	0,	tile_Nem_BallHog+tile_pal2
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	tile_Nem_Lamp
	@SBZend:

@Ending:
	dc.w (@Endingend-@Ending-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	id_Rings,	0,	0,	tile_Nem_Ring+tile_pal2
	if Revision=0
	dbug	Map_Bump,	id_Bumper,	0,	0,	$380
	dbug	Map_Animal2,	id_Animals,	$A,	0,	$5A0
	dbug	Map_Animal2,	id_Animals,	$B,	0,	$5A0
	dbug	Map_Animal2,	id_Animals,	$C,	0,	$5A0
	dbug	Map_Animal1,	id_Animals,	$D,	0,	$553
	dbug	Map_Animal1,	id_Animals,	$E,	0,	$553
	dbug	Map_Animal1,	id_Animals,	$F,	0,	$573
	dbug	Map_Animal1,	id_Animals,	$10,	0,	$573
	dbug	Map_Animal2,	id_Animals,	$11,	0,	$585
	dbug	Map_Animal3,	id_Animals,	$12,	0,	$593
	dbug	Map_Animal2,	id_Animals,	$13,	0,	$565
	dbug	Map_Animal3,	id_Animals,	$14,	0,	$5B3
	else
	dbug	Map_Ring,	id_Rings,	0,	8,	tile_Nem_Ring+tile_pal2
	endc
	@Endingend:

	even
