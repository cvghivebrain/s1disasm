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
		move.w	(v_boundary_top).w,(v_boundary_top_debugcopy).w ; buffer level top boundary
		move.w	(v_boundary_bottom_next).w,(v_boundary_bottom_debugcopy).w ; buffer level bottom boundary
		move.w	#0,(v_boundary_top).w
		move.w	#$720,(v_boundary_bottom_next).w	; set new boundaries
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		andi.w	#$7FF,(v_camera_y_pos).w
		andi.w	#$3FF,(v_bg1_y_pos).w
		move.b	#0,ost_frame(a0)
		move.b	#0,ost_anim(a0)
		cmpi.b	#id_Special,(v_gamemode).w		; is game mode $10 (special stage)?
		bne.s	.islevel				; if not, branch

		move.w	#0,(v_ss_rotation_speed).w		; stop special stage rotating
		move.w	#0,(v_ss_angle).w			; make special stage "upright"
		moveq	#id_DebugList_Ending,d0			; use 6th debug	item list
		bra.s	.selectlist
; ===========================================================================

.islevel:
		moveq	#0,d0
		move.b	(v_zone).w,d0

.selectlist:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2				; get address of debug list
		move.w	(a2)+,d6				; get number of items in list
		cmp.b	(v_debug_item_index).w,d6		; have you gone past the last item?
		bhi.s	.noreset				; if not, branch
		move.b	#0,(v_debug_item_index).w		; back to start of list

	.noreset:
		bsr.w	Debug_GetFrame				; get mappings, VRAM & frame id from debug list
		move.b	#debug_move_delay,(v_debug_move_delay).w
		move.b	#1,(v_debug_move_speed).w

Debug_Action:	; Routine 2
		moveq	#id_DebugList_Ending,d0
		cmpi.b	#id_Special,(v_gamemode).w
		beq.s	.isntlevel

		moveq	#0,d0
		move.b	(v_zone).w,d0

	.isntlevel:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2				; get address of debug list
		move.w	(a2)+,d6				; get number of items in list
		bsr.w	Debug_Control
		jmp	(DisplaySprite).l

; ---------------------------------------------------------------------------
; Subroutine for controls while debug is in use

; input:
;	d6.w = number of items in debug list
;	a2 = address of first item in debug list

;	uses d0.l, d1.l, d2.l, d3.l, d4.l
; ---------------------------------------------------------------------------

Debug_Control:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(v_joypad_press_actual).w,d4
		andi.w	#btnDir,d4				; is up/down/left/right	pressed?
		bne.s	.dirpressed				; if yes, branch

		move.b	(v_joypad_hold_actual).w,d0
		andi.w	#btnDir,d0				; is up/down/left/right	held?
		bne.s	.dirheld				; if yes, branch

		move.b	#debug_move_delay,(v_debug_move_delay).w
		move.b	#debug_move_speed,(v_debug_move_speed).w
		bra.w	Debug_ChgItem
; ===========================================================================

.dirheld:
		subq.b	#1,(v_debug_move_delay).w		; decrement timer
		bne.s	.chk_up					; if not 0, branch
		move.b	#1,(v_debug_move_delay).w		; set delay timer to 1 frame
		addq.b	#1,(v_debug_move_speed).w		; increment speed
		bne.s	.dirpressed				; if not 0, branch
		move.b	#-1,(v_debug_move_speed).w

.dirpressed:
		move.b	(v_joypad_hold_actual).w,d4

	.chk_up:
		moveq	#0,d1
		move.b	(v_debug_move_speed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1					; d1 = speed * $1000
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		btst	#bitUp,d4				; is up	being held?
		beq.s	.chk_down				; if not, branch
		sub.l	d1,d2					; move Sonic up
		bcc.s	.chk_down
		moveq	#0,d2					; keep Sonic within top boundary

	.chk_down:
		btst	#bitDn,d4				; is down being held?
		beq.s	.chk_left				; if not, branch
		add.l	d1,d2					; move Sonic down
		cmpi.l	#$7FF0000,d2				; is Sonic above $7FF? (bottom boundary)
		bcs.s	.chk_left				; if yes, branch
		move.l	#$7FF0000,d2				; keep Sonic within bottom boundary

	.chk_left:
		btst	#bitL,d4				; is left being held?
		beq.s	.chk_right				; if not, branch
		sub.l	d1,d3					; move Sonic left
		bcc.s	.chk_right
		moveq	#0,d3					; keep Sonic within left boundary

	.chk_right:
		btst	#bitR,d4				; is right being held?
		beq.s	.update_pos				; if not, branch
		add.l	d1,d3					; move Sonic right (no boundary check for right side)

	.update_pos:
		move.l	d2,ost_y_pos(a0)
		move.l	d3,ost_x_pos(a0)

Debug_ChgItem:
		btst	#bitA,(v_joypad_hold_actual).w		; is button A held?
		beq.s	.createitem				; if not, branch
		btst	#bitC,(v_joypad_press_actual).w		; is button C pressed?
		beq.s	.nextitem				; if not, branch

		subq.b	#1,(v_debug_item_index).w		; go back 1 item
		bcc.s	.display				; if item is 0 or higher, branch
		add.b	d6,(v_debug_item_index).w		; if item is -1, loop to last item
		bra.s	.display
; ===========================================================================

.nextitem:
		btst	#bitA,(v_joypad_press_actual).w		; is button A pressed?
		beq.s	.createitem				; if not, branch
		addq.b	#1,(v_debug_item_index).w		; go forwards 1 item
		cmp.b	(v_debug_item_index).w,d6
		bhi.s	.display
		move.b	#0,(v_debug_item_index).w		; loop back to first item

	.display:
		bra.w	Debug_GetFrame
; ===========================================================================

.createitem:
		btst	#bitC,(v_joypad_press_actual).w		; is button C pressed?
		beq.s	.backtonormal				; if not, branch
		jsr	(FindFreeObj).l
		bne.s	.backtonormal
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_mappings(a0),ost_id(a1)		; create object (object id is held in high byte of mappings pointer)
		move.b	ost_render(a0),ost_render(a1)
		move.b	ost_render(a0),ost_status(a1)
		andi.b	#$FF-status_broken,ost_status(a1)	; remove broken flag from status
		moveq	#0,d0
		move.b	(v_debug_item_index).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),ost_subtype(a1)		; get subtype from debug list
		rts	
; ===========================================================================

.backtonormal:
		btst	#bitB,(v_joypad_press_actual).w		; is button B pressed?
		beq.s	.stayindebug				; if not, branch
		moveq	#0,d0
		move.w	d0,(v_debug_active).w			; deactivate debug mode
		move.l	#Map_Sonic,(v_ost_player+ost_mappings).w
		move.w	#tile_sonic,(v_ost_player+ost_tile).w
		move.b	d0,(v_ost_player+ost_anim).w
		move.w	d0,ost_x_sub(a0)
		move.w	d0,ost_y_sub(a0)
		move.w	(v_boundary_top_debugcopy).w,(v_boundary_top).w ; restore level boundaries
		move.w	(v_boundary_bottom_debugcopy).w,(v_boundary_bottom_next).w
		cmpi.b	#id_Special,(v_gamemode).w		; are you in the special stage?
		bne.s	.stayindebug				; if not, branch

		clr.w	(v_ss_angle).w
		move.w	#$40,(v_ss_rotation_speed).w		; set new level rotation speed
		move.l	#Map_Sonic,(v_ost_player+ost_mappings).w
		move.w	#tile_sonic,(v_ost_player+ost_tile).w
		move.b	#id_Roll,(v_ost_player+ost_anim).w
		bset	#status_jump_bit,(v_ost_player+ost_status).w
		bset	#status_air_bit,(v_ost_player+ost_status).w

	.stayindebug:
		rts

; ---------------------------------------------------------------------------
; Subroutine to get mappings, VRAM & frame info from debug list

;	uses d0.l
; ---------------------------------------------------------------------------

Debug_GetFrame:
		moveq	#0,d0
		move.b	(v_debug_item_index).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),ost_mappings(a0)		; load mappings for item
		move.w	6(a2,d0.w),ost_tile(a0)			; load VRAM setting for item
		move.b	5(a2,d0.w),ost_frame(a0)		; load frame number for item
		rts

; ---------------------------------------------------------------------------
; Debug	mode item lists
; ---------------------------------------------------------------------------

DebugList:	index *
		ptr DebugList_GHZ
		ptr DebugList_LZ
		ptr DebugList_MZ
		ptr DebugList_SLZ
		ptr DebugList_SYZ
		ptr DebugList_SBZ
		zonewarning DebugList,2
		ptr DebugList_Ending

dbug:		macro object,map,subtype,frame,vram
		dc.l map+(id_\object<<24)
		dc.b subtype,frame
		dc.w vram
		endm

DebugList_GHZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	Crabmeat,	Map_Crab,	0,	0,	tile_Nem_Crabmeat
		dbug	BuzzBomber,	Map_Buzz,	0,	0,	tile_Nem_Buzz
		dbug	Chopper,	Map_Chop,	0,	0,	tile_Nem_Chopper
		dbug	Spikes,		Map_Spike,	type_spike_3up+type_spike_still,	0,	tile_Nem_Spikes
		dbug	BasicPlatform,	Map_Plat_GHZ,	type_plat_still,	0,	0+tile_pal3
		dbug	PurpleRock,	Map_PRock,	0,	0,	tile_Nem_PurpleRock+tile_pal4
		dbug	MotoBug,	Map_Moto,	0,	0,	tile_Nem_Motobug
		dbug	Springs,	Map_Spring,	type_spring_red+type_spring_up,	0,	tile_Nem_HSpring
		dbug	Newtron,	Map_Newt,	0,	0,	tile_Nem_Newtron+tile_pal2
		dbug	EdgeWalls,	Map_Edge,	type_edge_shadow,	0,	tile_Nem_GhzEdgeWall+tile_pal3
		dbug	Obj19,		Map_GBall,	0,	0,	tile_Nem_Ball+tile_pal3
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
		dbug	GiantRing,	Map_GRing,	0,	0,	(vram_giantring/sizeof_cell)+tile_pal2
		dbug	HiddenBonus,	Map_Bonus,	type_bonus_10k,	id_frame_bonus_10000,	tile_Nem_Bonus+tile_hi
	.end:

DebugList_LZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	Springs,	Map_Spring,	type_spring_red+type_spring_up,	0,	tile_Nem_HSpring
		dbug	Jaws,		Map_Jaws,	8,	0,	tile_Nem_Jaws+tile_pal2
		dbug	Burrobot,	Map_Burro,	0,	id_frame_burro_dig1,	tile_Nem_Burrobot+tile_hi
		dbug	Harpoon,	Map_Harp,	type_harp_h,	id_frame_harp_h_retracted,	tile_Nem_Harpoon
		dbug	Harpoon,	Map_Harp,	type_harp_v,	id_frame_harp_v_retracted,	tile_Nem_Harpoon
		dbug	PushBlock,	Map_Push,	0,	0,	tile_Nem_LzPole+tile_pal3
		dbug	Button,		Map_But,	0,	0,	tile_Nem_Button+4
		dbug	Spikes,		Map_Spike,	type_spike_3up+type_spike_still,	0,	tile_Nem_Spikes
		dbug	MovingBlock,	Map_MBlockLZ,	type_mblock_1+type_mblock_rightdrop,	0,	tile_Nem_LzHalfBlock+tile_pal3
		dbug	LabyrinthBlock,	Map_LBlock,	type_lblock_sink,	id_frame_lblock_sinkblock,	tile_Nem_LzDoorH+tile_pal3
		dbug	LabyrinthBlock,	Map_LBlock,	type_lblock_rise,	id_frame_lblock_riseplatform,	tile_Nem_LzDoorH+tile_pal3
		dbug	LabyrinthBlock,	Map_LBlock,	type_lblock_sinkside,	id_frame_lblock_sinkblock,	tile_Nem_LzDoorH+tile_pal3
		dbug	Gargoyle,	Map_Gar,	0,	0,	$43E+tile_pal3
		dbug	LabyrinthBlock,	Map_LBlock,	type_lblock_cork,	id_frame_lblock_cork,	tile_Nem_LzDoorH+tile_pal3
		dbug	LabyrinthBlock,	Map_LBlock,	type_lblock_solid,	id_frame_lblock_block,	tile_Nem_LzDoorH+tile_pal3
		dbug	LabyrinthConvey, Map_LConv,	type_lcon_wheel,	0,	tile_Nem_LzWheel
		dbug	Orbinaut,	Map_Orb,	0,	0,	tile_Nem_Orbinaut_LZ
		dbug	Bubble,		Map_Bub,	$84,	id_frame_bubble_bubmaker1,	tile_Nem_Bubbles+tile_hi
		dbug	Waterfall,	Map_WFall,	type_wfall_cornermedium,	id_frame_wfall_cornermedium,	tile_Nem_Splash+tile_pal3+tile_hi
		dbug	Waterfall,	Map_WFall,	type_wfall_splash,	id_frame_wfall_splash1,	tile_Nem_Splash+tile_pal3+tile_hi
		dbug	Pole,		Map_Pole,	0,	0,	tile_Nem_LzPole+tile_pal3
		dbug	FlapDoor,	Map_Flap,	2,	0,	tile_Nem_FlapDoor+tile_pal3
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
	.end:

DebugList_MZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	BuzzBomber,	Map_Buzz,	0,	0,	tile_Nem_Buzz
		dbug	Spikes,		Map_Spike,	type_spike_3up+type_spike_still,	0,	tile_Nem_Spikes
		dbug	Springs,	Map_Spring,	type_spring_red+type_spring_up,	0,	tile_Nem_HSpring
		dbug	FireMaker,	Map_Fire,	0,	0,	tile_Nem_Fireball
		dbug	MarbleBrick,	Map_Brick,	type_brick_still,	0,	0+tile_pal3
		dbug	GeyserMaker,	Map_Geyser,	0,	0,	tile_Nem_Lava+tile_pal4
		dbug	LavaWall,	Map_LWall,	0,	0,	tile_Nem_Lava+tile_pal4
		dbug	PushBlock,	Map_Push,	type_pblock_single,	0,	tile_Nem_MzBlock+tile_pal3
		dbug	Yadrin,		Map_Yad,	0,	0,	tile_Nem_Yadrin+tile_pal2
		dbug	SmashBlock,	Map_Smab,	0,	0,	tile_Nem_MzBlock+tile_pal3
		dbug	MovingBlock,	Map_MBlock,	type_mblock_1+type_mblock_still,	0,	tile_Nem_MzBlock
		dbug	CollapseFloor,	Map_CFlo,	0,	0,	tile_Nem_MzBlock+tile_pal4
		dbug	LavaTag,	Map_LTag,	0,	0,	tile_Nem_Monitors+tile_hi
		dbug	Batbrain,	Map_Bat,	0,	0,	tile_Nem_Batbrain
		dbug	Caterkiller,	Map_Cat,	0,	0,	tile_Nem_Cater+tile_pal2
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
	.end:

DebugList_SLZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	Elevator,	Map_Elev,	type_elev_up_short,	0,	0+tile_pal3
		dbug	CollapseFloor,	Map_CFlo,	0,	id_frame_cfloor_slz,	tile_Nem_SlzBlock+tile_pal3
		dbug	BasicPlatform,	Map_Plat_SLZ,	type_plat_still,	0,	0+tile_pal3
		dbug	CirclingPlatform, Map_Circ,	0,	0,	0+tile_pal3
		dbug	Staircase,	Map_Stair,	type_stair_above,	0,	0+tile_pal3
		dbug	Fan,		Map_Fan,	type_fan_left_onoff,	0,	tile_Nem_Fan+tile_pal3
		dbug	Seesaw,		Map_Seesaw,	0,	0,	tile_Nem_Seesaw
		dbug	Springs,	Map_Spring,	type_spring_red+type_spring_up,	0,	tile_Nem_HSpring
		dbug	FireMaker,	Map_Fire,	0,	0,	tile_Nem_Fireball_SLZ
		dbug	Scenery,	Map_Scen,	type_scen_cannon,	0,	tile_Nem_SlzCannon+tile_pal3
		dbug	Bomb,		Map_Bomb,	0,	0,	tile_Nem_Bomb
		dbug	Orbinaut,	Map_Orb,	0,	0,	tile_Nem_Orbinaut+tile_pal2
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
	.end:

DebugList_SYZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	Spikes,		Map_Spike,	type_spike_3up+type_spike_still,	0,	tile_Nem_Spikes
		dbug	Springs,	Map_Spring,	type_spring_red+type_spring_up,	0,	tile_Nem_HSpring
		dbug	Roller,		Map_Roll,	0,	0,	tile_Nem_Roller
		dbug	SpinningLight,	Map_Light,	0,	0,	0
		dbug	Bumper,		Map_Bump,	0,	0,	tile_Nem_Bumper
		dbug	Crabmeat,	Map_Crab,	0,	0,	tile_Nem_Crabmeat
		dbug	BuzzBomber,	Map_Buzz,	0,	0,	tile_Nem_Buzz
		dbug	Yadrin,		Map_Yad,	0,	0,	tile_Nem_Yadrin+tile_pal2
		dbug	BasicPlatform,	Map_Plat_SYZ,	type_plat_still,	0,	0+tile_pal3
		dbug	FloatingBlock,	Map_FBlock,	type_fblock_syz1x1+type_fblock_still,	0,	0+tile_pal3
		dbug	Button,		Map_But,	0,	0,	tile_Nem_Button+4
		dbug	Caterkiller,	Map_Cat,	0,	0,	tile_Nem_Cater+tile_pal2
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
	.end:

DebugList_SBZ:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
		dbug	Monitor,	Map_Monitor,	0,	0,	tile_Nem_Monitors
		dbug	Bomb,		Map_Bomb,	0,	0,	tile_Nem_Bomb
		dbug	Orbinaut,	Map_Orb,	0,	0,	tile_Nem_Orbinaut
		dbug	Caterkiller,	Map_Cat,	0,	0,	tile_Nem_Cater_SBZ+tile_pal2
		dbug	SwingingPlatform, Map_BBall,	7,	id_frame_bball_anchor,	tile_Nem_BigSpike_SBZ+tile_pal3
		dbug	RunningDisc,	Map_Disc,	$E0,	0,	tile_Nem_SbzDisc+tile_pal3+tile_hi
		dbug	MovingBlock,	Map_MBlock,	type_mblock_sbz+type_mblock_updown,	id_frame_mblock_sbz,	tile_Nem_Stomper+tile_pal2
		dbug	Button,		Map_But,	0,	0,	tile_Nem_Button+4
		dbug	SpinPlatform,	Map_Trap,	3,	0,	tile_Nem_TrapDoor+tile_pal3
		dbug	SpinPlatform,	Map_Spin,	$83,	0,	tile_Nem_SpinPlatform
		dbug	Saws,		Map_Saw,	type_saw_pizza_updown,	0,	tile_Nem_Cutter+tile_pal3
		dbug	CollapseFloor,	Map_CFlo,	0,	0,	tile_Nem_SbzFloor+tile_pal3
		dbug	MovingBlock,	Map_MBlock,	type_mblock_sbzwide+type_mblock_slide,	id_frame_mblock_sbzwide,	tile_Nem_SlideFloor+tile_pal3
		dbug	ScrapStomp,	Map_Stomp,	0,	id_frame_stomp_door,	tile_Nem_Stomper+tile_pal2
		dbug	AutoDoor,	Map_ADoor,	0,	0,	tile_Nem_SbzDoorV+tile_pal3
		dbug	ScrapStomp,	Map_Stomp,	type_stomp_slow,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
		dbug	Saws,		Map_Saw,	type_saw_pizza_sideways,	id_frame_saw_pizzacutter1,	tile_Nem_Cutter+tile_pal3
		dbug	ScrapStomp,	Map_Stomp,	type_stomp_fast_short,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
		dbug	Saws,		Map_Saw,	type_saw_ground_left,	id_frame_saw_groundsaw1,	tile_Nem_Cutter+tile_pal3
		dbug	ScrapStomp,	Map_Stomp,	type_stomp_fast_long,	id_frame_stomp_stomper,	tile_Nem_Stomper+tile_pal2
		dbug	VanishPlatform,	Map_VanP,	0,	0,	tile_Nem_SbzBlock+tile_pal3
		dbug	Flamethrower,	Map_Flame,	$64,	id_frame_flame_pipe1,	tile_Nem_FlamePipe+tile_hi
		dbug	Flamethrower,	Map_Flame,	$64,	id_frame_flame_valve1,	tile_Nem_FlamePipe+tile_hi
		dbug	Electro,	Map_Elec,	4,	0,	tile_Nem_Electric
		dbug	Girder,		Map_Gird,	0,	0,	tile_Nem_Girder+tile_pal3
		dbug	Invisibarrier,	Map_Invis,	$11,	0,	tile_Nem_Monitors+tile_hi
		dbug	BallHog,	Map_Hog,	4,	0,	tile_Nem_BallHog+tile_pal2
		dbug	Lamppost,	Map_Lamp,	1,	0,	tile_Nem_Lamp
	.end:

DebugList_Ending:
		dc.w (.end-*-2)/8

;			object		mappings	subtype	frame	VRAM setting
		dbug	Rings,		Map_Ring,	0,	0,	tile_Nem_Ring+tile_pal2
	if Revision=0
		dbug	Bumper,		Map_Bump,	0,	0,	$380
		dbug	Animals,	Map_Animal2,	$A,	0,	$5A0
		dbug	Animals,	Map_Animal2,	$B,	0,	$5A0
		dbug	Animals,	Map_Animal2,	$C,	0,	$5A0
		dbug	Animals,	Map_Animal1,	$D,	0,	tile_Nem_Rabbit_End
		dbug	Animals,	Map_Animal1,	$E,	0,	tile_Nem_Rabbit_End
		dbug	Animals,	Map_Animal1,	$F,	0,	tile_Nem_BlackBird_End
		dbug	Animals,	Map_Animal1,	$10,	0,	tile_Nem_BlackBird_End
		dbug	Animals,	Map_Animal2,	$11,	0,	tile_Nem_Seal_End
		dbug	Animals,	Map_Animal3,	$12,	0,	tile_Nem_Pig_End
		dbug	Animals,	Map_Animal2,	$13,	0,	tile_Nem_Chicken_End
		dbug	Animals,	Map_Animal3,	$14,	0,	tile_Nem_Squirrel_End
	else
		dbug	Rings,		Map_Ring,	0,	id_frame_ring_blank,	tile_Nem_Ring+tile_pal2
	endc
	.end:
		even
