; ---------------------------------------------------------------------------
; Object 09 - Sonic (special stage)
; ---------------------------------------------------------------------------

SonicSpecial:
		tst.w	(v_debug_active).w			; is debug mode	being used?
		beq.s	Obj09_Normal				; if not, branch
		bsr.w	SS_FixCamera
		bra.w	DebugMode
; ===========================================================================

Obj09_Normal:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj09_Index(pc,d0.w),d1
		jmp	Obj09_Index(pc,d1.w)
; ===========================================================================
Obj09_Index:	index *,,2
		ptr Obj09_Main
		ptr Obj09_ChkDebug
		ptr Obj09_ExitStage
		ptr Obj09_Exit2

ost_ss_item:		equ $30					; item id Sonic is touching
ost_ss_item_address:	equ $32					; RAM address of item in layout Sonic is touching (4 bytes)
ost_ss_updown_time:	equ $36					; time until UP/DOWN can be triggered again
ost_ss_r_time:		equ $37					; time until R can be triggered again
ost_ss_restart_time:	equ $38					; time until game mode changes after exiting SS (2 bytes; nonfunctional)
ost_ss_ghost:		equ $3A					; status of ghost blocks - 0 = ghost; 1 = passed; 2 = solid
; ===========================================================================

Obj09_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#$780,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#0,ost_priority(a0)
		move.b	#id_Roll,ost_anim(a0)
		bset	#status_jump_bit,ost_status(a0)
		bset	#status_air_bit,ost_status(a0)

Obj09_ChkDebug:	; Routine 2
		tst.w	(f_debug_enable).w			; is debug mode	cheat enabled?
		beq.s	Obj09_NoDebug				; if not, branch
		btst	#bitB,(v_joypad_press_actual).w		; is button B pressed?
		beq.s	Obj09_NoDebug				; if not, branch
		move.w	#1,(v_debug_active).w			; change Sonic into a ring

Obj09_NoDebug:
		move.b	#0,ost_ss_item(a0)
		moveq	#0,d0
		move.b	ost_status(a0),d0
		andi.w	#2,d0
		move.w	Obj09_Modes(pc,d0.w),d1
		jsr	Obj09_Modes(pc,d1.w)
		jsr	(Sonic_LoadGfx).l
		jmp	(DisplaySprite).l
; ===========================================================================
Obj09_Modes:	index *
		ptr Obj09_OnWall
		ptr Obj09_InAir
; ===========================================================================

Obj09_OnWall:
		bsr.w	Obj09_Jump
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall
		bra.s	Obj09_Display
; ===========================================================================

Obj09_InAir:
		bsr.w	nullsub_2
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall

Obj09_Display:
		bsr.w	Obj09_ChkItems
		bsr.w	Obj09_ChkItems2
		jsr	(SpeedToPos).l
		bsr.w	SS_FixCamera
		move.w	(v_ss_angle).w,d0
		add.w	(v_ss_rotation_speed).w,d0
		move.w	d0,(v_ss_angle).w
		jsr	(Sonic_Animate).l
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Move:
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	Obj09_ChkRight				; if not, branch
		bsr.w	Obj09_MoveLeft

Obj09_ChkRight:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	loc_1BA78				; if not, branch
		bsr.w	Obj09_MoveRight

loc_1BA78:
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	loc_1BAA8
		move.w	ost_inertia(a0),d0
		beq.s	loc_1BAA8
		bmi.s	loc_1BA9A
		subi.w	#$C,d0
		bcc.s	loc_1BA94
		move.w	#0,d0

loc_1BA94:
		move.w	d0,ost_inertia(a0)
		bra.s	loc_1BAA8
; ===========================================================================

loc_1BA9A:
		addi.w	#$C,d0
		bcc.s	loc_1BAA4
		move.w	#0,d0

loc_1BAA4:
		move.w	d0,ost_inertia(a0)

loc_1BAA8:
		move.b	(v_ss_angle).w,d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(CalcSine).l
		muls.w	ost_inertia(a0),d1
		add.l	d1,ost_x_pos(a0)
		muls.w	ost_inertia(a0),d0
		add.l	d0,ost_y_pos(a0)
		movem.l	d0-d1,-(sp)
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		bsr.w	sub_1BCE8
		beq.s	loc_1BAF2
		movem.l	(sp)+,d0-d1
		sub.l	d1,ost_x_pos(a0)
		sub.l	d0,ost_y_pos(a0)
		move.w	#0,ost_inertia(a0)
		rts	
; ===========================================================================

loc_1BAF2:
		movem.l	(sp)+,d0-d1
		rts	
; End of function Obj09_Move


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_MoveLeft:
		bset	#status_xflip_bit,ost_status(a0)
		move.w	ost_inertia(a0),d0
		beq.s	loc_1BB06
		bpl.s	loc_1BB1A

loc_1BB06:
		subi.w	#$C,d0
		cmpi.w	#-$800,d0
		bgt.s	loc_1BB14
		move.w	#-$800,d0

loc_1BB14:
		move.w	d0,ost_inertia(a0)
		rts	
; ===========================================================================

loc_1BB1A:
		subi.w	#$40,d0
		bcc.s	loc_1BB22
		nop	

loc_1BB22:
		move.w	d0,ost_inertia(a0)
		rts	
; End of function Obj09_MoveLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_MoveRight:
		bclr	#status_xflip_bit,ost_status(a0)
		move.w	ost_inertia(a0),d0
		bmi.s	loc_1BB48
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_1BB42
		move.w	#$800,d0

loc_1BB42:
		move.w	d0,ost_inertia(a0)
		bra.s	locret_1BB54
; ===========================================================================

loc_1BB48:
		addi.w	#$40,d0
		bcc.s	loc_1BB50
		nop	

loc_1BB50:
		move.w	d0,ost_inertia(a0)

locret_1BB54:
		rts	
; End of function Obj09_MoveRight


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Jump:
		move.b	(v_joypad_press).w,d0
		andi.b	#btnABC,d0				; is A,	B or C pressed?
		beq.s	Obj09_NoJump				; if not, branch
		move.b	(v_ss_angle).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)
		play.w	1, jsr, sfx_Jump			; play jumping sound

Obj09_NoJump:
		rts	
; End of function Obj09_Jump


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


nullsub_2:
		rts	
; End of function nullsub_2

; ===========================================================================
; ---------------------------------------------------------------------------
; unused subroutine to limit Sonic's upward vertical speed
; ---------------------------------------------------------------------------
		move.w	#-$400,d1
		cmp.w	ost_y_vel(a0),d1
		ble.s	locret_1BBB4
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnABC,d0
		bne.s	locret_1BBB4
		move.w	d1,ost_y_vel(a0)

locret_1BBB4:
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	fix the	camera on Sonic's position (special stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_FixCamera:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		move.w	(v_camera_x_pos).w,d0
		subi.w	#$A0,d3
		bcs.s	loc_1BBCE
		sub.w	d3,d0
		sub.w	d0,(v_camera_x_pos).w

loc_1BBCE:
		move.w	(v_camera_y_pos).w,d0
		subi.w	#$70,d2
		bcs.s	locret_1BBDE
		sub.w	d2,d0
		sub.w	d0,(v_camera_y_pos).w

locret_1BBDE:
		rts	
; End of function SS_FixCamera

; ===========================================================================

Obj09_ExitStage:
		addi.w	#$40,(v_ss_rotation_speed).w		; increase stage rotation
		cmpi.w	#$1800,(v_ss_rotation_speed).w		; check if it's up to $1800
		bne.s	@not1800				; if not, branch
		move.b	#id_Level,(v_gamemode).w		; set game mode to normal level

	@not1800:
		cmpi.w	#$3000,(v_ss_rotation_speed).w		; check if it's up to $3000
		blt.s	@not3000				; if not, branch
		move.w	#0,(v_ss_rotation_speed).w		; stop rotation
		move.w	#$4000,(v_ss_angle).w
		addq.b	#2,ost_routine(a0)			; goto Obj09_Exit2 next
		move.w	#$3C,ost_ss_restart_time(a0)

	@not3000:
		move.w	(v_ss_angle).w,d0
		add.w	(v_ss_rotation_speed).w,d0
		move.w	d0,(v_ss_angle).w
		jsr	(Sonic_Animate).l
		jsr	(Sonic_LoadGfx).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l
; ===========================================================================

Obj09_Exit2:
		subq.w	#1,ost_ss_restart_time(a0)
		bne.s	loc_1BC40
		move.b	#id_Level,(v_gamemode).w

loc_1BC40:
		jsr	(Sonic_Animate).l
		jsr	(Sonic_LoadGfx).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_Fall:
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		move.b	(v_ss_angle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	ost_x_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0
		move.w	ost_y_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	sub_1BCE8
		beq.s	loc_1BCB0
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,ost_x_vel(a0)
		bclr	#status_air_bit,ost_status(a0)
		add.l	d1,d2
		bsr.w	sub_1BCE8
		beq.s	loc_1BCC6
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,ost_y_vel(a0)
		rts	
; ===========================================================================

loc_1BCB0:
		add.l	d1,d2
		bsr.w	sub_1BCE8
		beq.s	loc_1BCD4
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,ost_y_vel(a0)
		bclr	#status_air_bit,ost_status(a0)

loc_1BCC6:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,ost_x_vel(a0)
		move.w	d1,ost_y_vel(a0)
		rts	
; ===========================================================================

loc_1BCD4:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,ost_x_vel(a0)
		move.w	d1,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)
		rts	
; End of function Obj09_Fall


; ---------------------------------------------------------------------------
; Item detection subroutine

; input:
;	d2 = Sonic's y position
;	d3 = Sonic's x position
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1BCE8:
		lea	($FF0000).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		move.b	(a1)+,d4
		bsr.s	sub_1BD30
		tst.b	d5
		rts	
; End of function sub_1BCE8


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1BD30:
		beq.s	locret_1BD44
		cmpi.b	#$28,d4					; is the item an extra life?
		beq.s	locret_1BD44
		cmpi.b	#$3A,d4					; is the item an emerald or ghost block ($3B-$4A)?
		bcs.s	loc_1BD46
		cmpi.b	#$4B,d4
		bcc.s	loc_1BD46

locret_1BD44:
		rts	
; ===========================================================================

loc_1BD46:
		move.b	d4,ost_ss_item(a0)
		move.l	a1,ost_ss_item_address(a0)
		moveq	#-1,d5
		rts	
; End of function sub_1BD30


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_ChkItems:
		lea	($FF0000).l,a1
		moveq	#0,d4
		move.w	ost_y_pos(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	ost_x_pos(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	Obj09_ChkCont
		tst.b	ost_ss_ghost(a0)
		bne.w	Obj09_MakeGhostSolid
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkCont:
		cmpi.b	#$3A,d4					; is the item a	ring?
		bne.s	Obj09_Chk1Up
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetCont
		move.b	#1,(a2)
		move.l	a1,4(a2)

Obj09_GetCont:
		jsr	(CollectRing).l
		cmpi.w	#50,(v_rings).w				; check if you have 50 rings
		bcs.s	Obj09_NoCont
		bset	#0,(v_ring_reward).w
		bne.s	Obj09_NoCont
		addq.b	#1,(v_continues).w			; add 1 to number of continues
		play.w	0, jsr, sfx_Continue			; play extra continue sound

Obj09_NoCont:
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_Chk1Up:
		cmpi.b	#$28,d4					; is the item an extra life?
		bne.s	Obj09_ChkEmer
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_Get1Up
		move.b	#3,(a2)
		move.l	a1,4(a2)

Obj09_Get1Up:
		addq.b	#1,(v_lives).w				; add 1 to number of lives
		addq.b	#1,(f_hud_lives_update).w		; update the lives counter
		play.w	0, jsr, mus_ExtraLife			; play extra life music
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkEmer:
		cmpi.b	#$3B,d4					; is the item an emerald?
		bcs.s	Obj09_ChkGhost
		cmpi.b	#$40,d4
		bhi.s	Obj09_ChkGhost
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GetEmer
		move.b	#5,(a2)
		move.l	a1,4(a2)

Obj09_GetEmer:
		cmpi.b	#6,(v_emeralds).w			; do you have all the emeralds?
		beq.s	Obj09_NoEmer				; if yes, branch
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	(v_emeralds).w,d0
		lea	(v_emerald_list).w,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,(v_emeralds).w			; add 1 to number of emeralds

Obj09_NoEmer:
		play.w	1, jsr, mus_Emerald			; play emerald music
		moveq	#0,d4
		rts	
; ===========================================================================

Obj09_ChkGhost:
		cmpi.b	#$41,d4					; is the item a	ghost block?
		bne.s	Obj09_ChkGhostTag
		move.b	#1,ost_ss_ghost(a0)			; mark the ghost block as "passed"

Obj09_ChkGhostTag:
		cmpi.b	#$4A,d4					; is the item a	switch for ghost blocks?
		bne.s	Obj09_NoGhost
		cmpi.b	#1,ost_ss_ghost(a0)			; have the ghost blocks been passed?
		bne.s	Obj09_NoGhost				; if not, branch
		move.b	#2,ost_ss_ghost(a0)			; mark the ghost blocks as "solid"

Obj09_NoGhost:
		moveq	#-1,d4
		rts	
; ===========================================================================

Obj09_MakeGhostSolid:
		cmpi.b	#2,ost_ss_ghost(a0)			; is the ghost marked as "solid"?
		bne.s	Obj09_GhostNotSolid			; if not, branch
		lea	($FF1020).l,a1
		moveq	#$3F,d1

Obj09_GhostLoop2:
		moveq	#$3F,d2

Obj09_GhostLoop:
		cmpi.b	#$41,(a1)				; is the item a	ghost block?
		bne.s	Obj09_NoReplace				; if not, branch
		move.b	#$2C,(a1)				; replace ghost	block with a solid block

Obj09_NoReplace:
		addq.w	#1,a1
		dbf	d2,Obj09_GhostLoop
		lea	$40(a1),a1
		dbf	d1,Obj09_GhostLoop2

Obj09_GhostNotSolid:
		clr.b	ost_ss_ghost(a0)
		moveq	#0,d4
		rts	
; End of function Obj09_ChkItems


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj09_ChkItems2:
		move.b	ost_ss_item(a0),d0
		bne.s	Obj09_ChkBumper
		subq.b	#1,ost_ss_updown_time(a0)
		bpl.s	loc_1BEA0
		move.b	#0,ost_ss_updown_time(a0)

loc_1BEA0:
		subq.b	#1,ost_ss_r_time(a0)
		bpl.s	locret_1BEAC
		move.b	#0,ost_ss_r_time(a0)

locret_1BEAC:
		rts	
; ===========================================================================

Obj09_ChkBumper:
		cmpi.b	#$25,d0					; is the item a	bumper?
		bne.s	Obj09_GOAL
		move.l	ost_ss_item_address(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	ost_x_pos(a0),d1
		sub.w	ost_y_pos(a0),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_BumpSnd
		move.b	#2,(a2)
		move.l	ost_ss_item_address(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_BumpSnd:
		play.w	1, jmp, sfx_Bumper			; play bumper sound
; ===========================================================================

Obj09_GOAL:
		cmpi.b	#$27,d0					; is the item a	"GOAL"?
		bne.s	Obj09_UPblock
		addq.b	#2,ost_routine(a0)			; run routine "Obj09_ExitStage"
		play.w	1, jsr, sfx_Goal			; play "GOAL" sound
		rts	
; ===========================================================================

Obj09_UPblock:
		cmpi.b	#$29,d0					; is the item an "UP" block?
		bne.s	Obj09_DOWNblock
		tst.b	ost_ss_updown_time(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,ost_ss_updown_time(a0)
		btst	#6,(v_ss_rotation_speed+1).w
		beq.s	Obj09_UPsnd
		asl	(v_ss_rotation_speed).w			; increase stage rotation speed
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.b	#$2A,(a1)				; change item to a "DOWN" block

Obj09_UPsnd:
		play.w	1, jmp, sfx_ActionBlock			; play up/down sound
; ===========================================================================

Obj09_DOWNblock:
		cmpi.b	#$2A,d0					; is the item a	"DOWN" block?
		bne.s	Obj09_Rblock
		tst.b	ost_ss_updown_time(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,ost_ss_updown_time(a0)
		btst	#6,(v_ss_rotation_speed+1).w
		bne.s	Obj09_DOWNsnd
		asr	(v_ss_rotation_speed).w			; reduce stage rotation speed
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.b	#$29,(a1)				; change item to an "UP" block

Obj09_DOWNsnd:
		play.w	1, jmp, sfx_ActionBlock			; play up/down sound
; ===========================================================================

Obj09_Rblock:
		cmpi.b	#$2B,d0					; is the item an "R" block?
		bne.s	Obj09_ChkGlass
		tst.b	ost_ss_r_time(a0)
		bne.w	Obj09_NoGlass
		move.b	#$1E,ost_ss_r_time(a0)
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_RevStage
		move.b	#4,(a2)
		move.l	ost_ss_item_address(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

Obj09_RevStage:
		neg.w	(v_ss_rotation_speed).w			; reverse stage rotation
		play.w	1, jmp, sfx_ActionBlock			; play R-block sound
; ===========================================================================

Obj09_ChkGlass:
		cmpi.b	#$2D,d0					; is the item a	glass block?
		beq.s	Obj09_Glass				; if yes, branch
		cmpi.b	#$2E,d0
		beq.s	Obj09_Glass
		cmpi.b	#$2F,d0
		beq.s	Obj09_Glass
		cmpi.b	#$30,d0
		bne.s	Obj09_NoGlass				; if not, branch

Obj09_Glass:
		bsr.w	SS_RemoveCollectedItem
		bne.s	Obj09_GlassSnd
		move.b	#6,(a2)
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0					; change glass type when touched
		cmpi.b	#$30,d0
		bls.s	Obj09_GlassUpdate			; if glass is	still there, branch
		clr.b	d0					; remove the glass block when it's destroyed

Obj09_GlassUpdate:
		move.b	d0,4(a2)				; update the stage layout

Obj09_GlassSnd:
		play.w	1, jmp, sfx_Diamonds			; play diamond block sound
; ===========================================================================

Obj09_NoGlass:
		rts	
; End of function Obj09_ChkItems2
