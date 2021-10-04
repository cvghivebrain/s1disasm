; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(v_debug_active_hi).w,d0
		move.w	Debug_Index(pc,d0.w),d1
		jmp	Debug_Index(pc,d1.w)
; ===========================================================================
Debug_Index:	index *
		ptr Debug_Main
		ptr Debug_Action
; ===========================================================================

Debug_Main:	; Routine 0
		addq.b	#2,(v_debug_active_hi).w
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

		move.w	#0,(v_ss_rotation_speed).w ; stop special stage rotating
		move.w	#0,(v_ss_angle).w ; make	special	stage "upright"
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
		cmp.b	(v_debug_item_index).w,d6 ; have you gone past the last item?
		bhi.s	@noreset	; if not, branch
		move.b	#0,(v_debug_item_index).w ; back to start of list

	@noreset:
		bsr.w	Debug_ShowItem
		move.b	#12,(v_debug_x_speed).w
		move.b	#1,(v_debug_y_speed).w

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

		move.b	#12,(v_debug_x_speed).w
		move.b	#15,(v_debug_y_speed).w
		bra.w	Debug_ChgItem
; ===========================================================================

@dirheld:
		subq.b	#1,(v_debug_x_speed).w
		bne.s	loc_1D01C
		move.b	#1,(v_debug_x_speed).w
		addq.b	#1,(v_debug_y_speed).w
		bne.s	@dirpressed
		move.b	#-1,(v_debug_y_speed).w

@dirpressed:
		move.b	(v_joypad_hold_actual).w,d4

loc_1D01C:
		moveq	#0,d1
		move.b	(v_debug_y_speed).w,d1
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
		subq.b	#1,(v_debug_item_index).w ; go back 1 item
		bcc.s	@display
		add.b	d6,(v_debug_item_index).w
		bra.s	@display
; ===========================================================================

@nextitem:
		btst	#bitA,(v_joypad_press_actual).w ; is button A pressed?
		beq.s	@createitem	; if not, branch
		addq.b	#1,(v_debug_item_index).w ; go forwards 1 item
		cmp.b	(v_debug_item_index).w,d6
		bhi.s	@display
		move.b	#0,(v_debug_item_index).w ; loop back to first item

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
		move.b	(v_debug_item_index).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),ost_subtype(a1)
		rts	
; ===========================================================================

@backtonormal:
		btst	#bitB,(v_joypad_press_actual).w ; is button B pressed?
		beq.s	@stayindebug	; if not, branch
		moveq	#0,d0
		move.w	d0,(v_debug_active).w ; deactivate debug mode
		move.l	#Map_Sonic,(v_ost_player+ost_mappings).w
		move.w	#vram_sonic/$20,(v_ost_player+ost_tile).w
		move.b	d0,(v_ost_player+ost_anim).w
		move.w	d0,ost_x_sub(a0)
		move.w	d0,ost_y_sub(a0)
		move.w	(v_limittopdb).w,(v_limittop2).w ; restore level boundaries
		move.w	(v_limitbtmdb).w,(v_limitbtm1).w
		cmpi.b	#id_Special,(v_gamemode).w ; are you in the special stage?
		bne.s	@stayindebug	; if not, branch

		clr.w	(v_ss_angle).w
		move.w	#$40,(v_ss_rotation_speed).w ; set new level rotation speed
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
		move.b	(v_debug_item_index).w,d0
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
		dc.l map+(id_\object<<24)
		dc.b subtype,frame
		dc.w vram
		endm

@GHZ:
	dc.w (@GHZend-@GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Crab,	Crabmeat,	0,	0,	tile_Nem_Crabmeat
	dbug	Map_Buzz,	BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Chop,	Chopper,	0,	0,	tile_Nem_Chopper
	dbug	Map_Spike,	Spikes,		0,	0,	tile_Nem_Spikes
	dbug	Map_Plat_GHZ,	BasicPlatform,	0,	0,	0+tile_pal3
	dbug	Map_PRock,	PurpleRock,	0,	0,	tile_Nem_PplRock+tile_pal4
	dbug	Map_Moto,	MotoBug,	0,	0,	tile_Nem_Motobug
	dbug	Map_Spring,	Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Newt,	Newtron,	0,	0,	tile_Nem_Newtron+tile_pal2
	dbug	Map_Edge,	EdgeWalls,	0,	0,	tile_Nem_GhzWall2+tile_pal3
	dbug	Map_GBall,	Obj19,		0,	0,	tile_Nem_Ball+tile_pal3
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	dbug	Map_GRing,	GiantRing,	0,	0,	$400+tile_pal2
	dbug	Map_Bonus,	HiddenBonus,	1,	id_frame_bonus_10000,	tile_Nem_Bonus+tile_hi
	@GHZend:

@LZ:
	dc.w (@LZend-@LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Spring,	Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Jaws,	Jaws,		8,	0,	tile_Nem_Jaws+tile_pal2
	dbug	Map_Burro,	Burrobot,	0,	id_frame_burro_dig1,	tile_Nem_Burrobot+tile_hi
	dbug	Map_Harp,	Harpoon,	0,	id_frame_harp_h_retracted,	tile_Nem_Harpoon
	dbug	Map_Harp,	Harpoon,	2,	id_frame_harp_v_retracted,	tile_Nem_Harpoon
	dbug	Map_Push,	PushBlock,	0,	0,	tile_Nem_LzPole+tile_pal3
	dbug	Map_But,	Button,		0,	0,	$513
	dbug	Map_Spike,	Spikes,		0,	0,	tile_Nem_Spikes
	dbug	Map_MBlockLZ,	MovingBlock,	4,	0,	tile_Nem_LzBlock3+tile_pal3
	dbug	Map_LBlock,	LabyrinthBlock, 1,	id_frame_lblock_sinkblock,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	LabyrinthBlock, $13,	id_frame_lblock_riseplatform,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	LabyrinthBlock, 5,	id_frame_lblock_sinkblock,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_Gar,	Gargoyle,	0,	0,	$43E+tile_pal3
	dbug	Map_LBlock,	LabyrinthBlock, $27,	id_frame_lblock_cork,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LBlock,	LabyrinthBlock, $30,	id_frame_lblock_block,	tile_Nem_LzDoor2+tile_pal3
	dbug	Map_LConv,	LabyrinthConvey, $7F,	0,	tile_Nem_LzWheel
	dbug	Map_Orb,	Orbinaut,	0,	0,	tile_Nem_Orbinaut_LZ
	dbug	Map_Bub,	Bubble,		$84,	id_frame_bubble_bubmaker1,	tile_Nem_Bubbles+tile_hi
	dbug	Map_WFall,	Waterfall,	2,	id_frame_wfall_cornermedium,	tile_Nem_Splash+tile_pal3+tile_hi
	dbug	Map_WFall,	Waterfall,	9,	id_frame_wfall_splash1,	tile_Nem_Splash+tile_pal3+tile_hi
	dbug	Map_Pole,	Pole,		0,	0,	tile_Nem_LzPole+tile_pal3
	dbug	Map_Flap,	FlapDoor,	2,	0,	tile_Nem_FlapDoor+tile_pal3
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	@LZend:

@MZ:
	dc.w (@MZend-@MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Buzz,	BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Spike,	Spikes,		0,	0,	tile_Nem_Spikes
	dbug	Map_Spring,	Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Fire,	LavaMaker,	0,	0,	tile_Nem_Fireball
	dbug	Map_Brick,	MarbleBrick,	0,	0,	0+tile_pal3
	dbug	Map_Geyser,	GeyserMaker,	0,	0,	tile_Nem_Lava+tile_pal4
	dbug	Map_LWall,	LavaWall,	0,	0,	tile_Nem_Lava+tile_pal4
	dbug	Map_Push,	PushBlock,	0,	0,	tile_Nem_MzBlock+tile_pal3
	dbug	Map_Yad,	Yadrin,		0,	0,	tile_Nem_Yadrin+tile_pal2
	dbug	Map_Smab,	SmashBlock,	0,	0,	tile_Nem_MzBlock+tile_pal3
	dbug	Map_MBlock,	MovingBlock,	0,	0,	tile_Nem_MzBlock
	dbug	Map_CFlo,	CollapseFloor,	0,	0,	tile_Nem_MzBlock+tile_pal4
	dbug	Map_LTag,	LavaTag,	0,	0,	tile_Nem_Monitors+tile_hi
	dbug	Map_Bat,	Batbrain,	0,	0,	tile_Nem_Batbrain
	dbug	Map_Cat,	Caterkiller,	0,	0,	tile_Nem_Cater+tile_pal2
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	@MZend:

@SLZ:
	dc.w (@SLZend-@SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Elev,	Elevator,	0,	0,	0+tile_pal3
	dbug	Map_CFlo,	CollapseFloor,	0,	id_frame_cfloor_slz,	tile_Nem_SlzBlock+tile_pal3
	dbug	Map_Plat_SLZ,	BasicPlatform,	0,	0,	0+tile_pal3
	dbug	Map_Circ,	CirclingPlatform, 0,	0,	0+tile_pal3
	dbug	Map_Stair,	Staircase,	0,	0,	0+tile_pal3
	dbug	Map_Fan,	Fan,		0,	0,	tile_Nem_Fan+tile_pal3
	dbug	Map_Seesaw,	Seesaw,		0,	0,	tile_Nem_Seesaw
	dbug	Map_Spring,	Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Fire,	LavaMaker,	0,	0,	tile_Nem_Fireball_SLZ
	dbug	Map_Scen,	Scenery,	0,	0,	tile_Nem_SlzCannon+tile_pal3
	dbug	Map_Bomb,	Bomb,		0,	0,	tile_Nem_Bomb
	dbug	Map_Orb,	Orbinaut,	0,	0,	tile_Nem_Orbinaut+tile_pal2
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	@SLZend:

@SYZ:
	dc.w (@SYZend-@SYZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Spike,	Spikes,		0,	0,	tile_Nem_Spikes
	dbug	Map_Spring,	Springs,	0,	0,	tile_Nem_HSpring
	dbug	Map_Roll,	Roller,		0,	0,	tile_Nem_Roller
	dbug	Map_Light,	SpinningLight,	0,	0,	0
	dbug	Map_Bump,	Bumper,		0,	0,	tile_Nem_Bumper
	dbug	Map_Crab,	Crabmeat,	0,	0,	tile_Nem_Crabmeat
	dbug	Map_Buzz,	BuzzBomber,	0,	0,	tile_Nem_Buzz
	dbug	Map_Yad,	Yadrin,		0,	0,	tile_Nem_Yadrin+tile_pal2
	dbug	Map_Plat_SYZ,	BasicPlatform,	0,	0,	0+tile_pal3
	dbug	Map_FBlock,	FloatingBlock,	0,	0,	0+tile_pal3
	dbug	Map_But,	Button,		0,	0,	$513
	dbug	Map_Cat,	Caterkiller,	0,	0,	tile_Nem_Cater+tile_pal2
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	@SYZend:

@SBZ:
	dc.w (@SBZend-@SBZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	dbug	Map_Monitor,	Monitor,	0,	0,	tile_Nem_Monitors
	dbug	Map_Bomb,	Bomb,		0,	0,	tile_Nem_Bomb
	dbug	Map_Orb,	Orbinaut,	0,	0,	tile_Nem_Orbinaut
	dbug	Map_Cat,	Caterkiller,	0,	0,	tile_Nem_Cater_SBZ+tile_pal2
	dbug	Map_BBall,	SwingingPlatform, 7,	id_frame_bball_anchor,	tile_Nem_BigSpike_SBZ+tile_pal3
	dbug	Map_Disc,	RunningDisc,	$E0,	0,	tile_Nem_SbzWheel1+tile_pal3+tile_hi
	dbug	Map_MBlock,	MovingBlock,	$28,	id_frame_mblock_sbz,	tile_Nem_Stomper+tile_pal2
	dbug	Map_But,	Button,		0,	0,	$513
	dbug	Map_Trap,	SpinPlatform,	3,	0,	tile_Nem_TrapDoor+tile_pal3
	dbug	Map_Spin,	SpinPlatform,	$83,	0,	tile_Nem_SpinPform
	dbug	Map_Saw,	Saws,		2,	0,	tile_Nem_Cutter+tile_pal3
	dbug	Map_CFlo,	CollapseFloor,	0,	0,	tile_Nem_SbzFloor+tile_pal3
	dbug	Map_MBlock,	MovingBlock,	$39,	id_frame_mblock_sbzwide,	tile_Nem_SlideFloor+tile_pal3
	dbug	Map_Stomp,	ScrapStomp,	0,	id_frame_stomp_door,	tile_Nem_Stomper+tile_pal2
	dbug	Map_ADoor,	AutoDoor,	0,	0,	tile_Nem_SbzDoor1+tile_pal3
	dbug	Map_Stomp,	ScrapStomp,	$13,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
	dbug	Map_Saw,	Saws,		1,	id_frame_saw_pizzacutter1,	tile_Nem_Cutter+tile_pal3
	dbug	Map_Stomp,	ScrapStomp,	$24,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
	dbug	Map_Saw,	Saws,		4,	id_frame_saw_groundsaw1,	tile_Nem_Cutter+tile_pal3
	dbug	Map_Stomp,	ScrapStomp,	$34,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
	dbug	Map_VanP,	VanishPlatform, 0,	0,	tile_Nem_SbzBlock+tile_pal3
	dbug	Map_Flame,	Flamethrower,	$64,	id_frame_flame_pipe1,	tile_Nem_FlamePipe+tile_hi
	dbug	Map_Flame,	Flamethrower,	$64,	id_frame_flame_valve1,	tile_Nem_FlamePipe+tile_hi
	dbug	Map_Elec,	Electro,	4,	0,	tile_Nem_Electric
	dbug	Map_Gird,	Girder,		0,	0,	tile_Nem_Girder+tile_pal3
	dbug	Map_Invis,	Invisibarrier,	$11,	0,	tile_Nem_Monitors+tile_hi
	dbug	Map_Hog,	BallHog,	4,	0,	tile_Nem_BallHog+tile_pal2
	dbug	Map_Lamp,	Lamppost,	1,	0,	tile_Nem_Lamp
	@SBZend:

@Ending:
	dc.w (@Endingend-@Ending-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug	Map_Ring,	Rings,		0,	0,	tile_Nem_Ring+tile_pal2
	if Revision=0
	dbug	Map_Bump,	Bumper,		0,	0,	$380
	dbug	Map_Animal2,	Animals,	$A,	0,	$5A0
	dbug	Map_Animal2,	Animals,	$B,	0,	$5A0
	dbug	Map_Animal2,	Animals,	$C,	0,	$5A0
	dbug	Map_Animal1,	Animals,	$D,	0,	$553
	dbug	Map_Animal1,	Animals,	$E,	0,	$553
	dbug	Map_Animal1,	Animals,	$F,	0,	$573
	dbug	Map_Animal1,	Animals,	$10,	0,	$573
	dbug	Map_Animal2,	Animals,	$11,	0,	$585
	dbug	Map_Animal3,	Animals,	$12,	0,	$593
	dbug	Map_Animal2,	Animals,	$13,	0,	$565
	dbug	Map_Animal3,	Animals,	$14,	0,	$5B3
	else
	dbug	Map_Ring,	Rings,		0,	id_frame_ring_blank,	tile_Nem_Ring+tile_pal2
	endc
	@Endingend:

	even
