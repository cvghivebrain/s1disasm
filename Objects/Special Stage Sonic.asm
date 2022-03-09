; ---------------------------------------------------------------------------
; Object 09 - Sonic (special stage)
; ---------------------------------------------------------------------------

SonicSpecial:
		tst.w	(v_debug_active).w			; is debug mode	being used?
		beq.s	SSS_Normal				; if not, branch
		bsr.w	SS_FixCamera
		bra.w	DebugMode
; ===========================================================================

SSS_Normal:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SSS_Index(pc,d0.w),d1
		jmp	SSS_Index(pc,d1.w)
; ===========================================================================
SSS_Index:	index *,,2
		ptr SSS_Main
		ptr SSS_ChkDebug
		ptr SSS_ExitStage
		ptr SSS_Exit2

ost_ss_item:		equ $30					; item id Sonic is touching
ost_ss_item_address:	equ $32					; RAM address of item in layout Sonic is touching (4 bytes)
ost_ss_updown_time:	equ $36					; time until UP/DOWN can be triggered again
ost_ss_r_time:		equ $37					; time until R can be triggered again
ost_ss_restart_time:	equ $38					; time until game mode changes after exiting SS (2 bytes; nonfunctional)
ost_ss_ghost:		equ $3A					; status of ghost blocks - 0 = ghost; 1 = passed; 2 = solid
; ===========================================================================

SSS_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#vram_sonic/sizeof_cell,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#0,ost_priority(a0)
		move.b	#id_Roll,ost_anim(a0)
		bset	#status_jump_bit,ost_status(a0)
		bset	#status_air_bit,ost_status(a0)

SSS_ChkDebug:	; Routine 2
		tst.w	(f_debug_enable).w			; is debug mode	cheat enabled?
		beq.s	@not_debug				; if not, branch
		btst	#bitB,(v_joypad_press_actual).w		; is button B pressed?
		beq.s	@not_debug				; if not, branch
		move.w	#1,(v_debug_active).w			; change Sonic into a ring

	@not_debug:
		move.b	#0,ost_ss_item(a0)
		moveq	#0,d0
		move.b	ost_status(a0),d0
		andi.w	#status_air,d0				; read air bit of status
		move.w	SSS_Modes(pc,d0.w),d1
		jsr	SSS_Modes(pc,d1.w)
		jsr	(Sonic_LoadGfx).l
		jmp	(DisplaySprite).l
; ===========================================================================
SSS_Modes:	index *
		ptr SSS_OnWall
		ptr SSS_InAir
; ===========================================================================

SSS_OnWall:
		bsr.w	SSS_Jump
		bsr.w	SSS_Move
		bsr.w	SSS_Fall
		bra.s	SSS_Display
; ===========================================================================

SSS_InAir:
		bsr.w	nullsub_2
		bsr.w	SSS_Move
		bsr.w	SSS_Fall

SSS_Display:
		bsr.w	SSS_ChkItems
		bsr.w	SSS_ChkItems2
		jsr	(SpeedToPos).l
		bsr.w	SS_FixCamera
		move.w	(v_ss_angle).w,d0
		add.w	(v_ss_rotation_speed).w,d0
		move.w	d0,(v_ss_angle).w
		jsr	(Sonic_Animate).l
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_Move:
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	@not_left				; if not, branch
		bsr.w	SSS_MoveLeft

	@not_left:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	@not_right				; if not, branch
		bsr.w	SSS_MoveRight

	@not_right:
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0				; is left or right being pressed?
		bne.s	SSS_UpdatePos				; if yes, branch
		move.w	ost_inertia(a0),d0			; get inertia
		beq.s	SSS_UpdatePos				; branch if 0
		bmi.s	@inertia_neg				; branch if negative
		subi.w	#$C,d0					; subtract $C
		bcc.s	@update_inertia				; branch if positive (after subtraction)
		move.w	#0,d0					; set to 0 if negative (after subtraction)

	@update_inertia:
		move.w	d0,ost_inertia(a0)			; set new inertia
		bra.s	SSS_UpdatePos
; ===========================================================================

@inertia_neg:
		addi.w	#$C,d0					; add $C to inertia
		bcc.s	@update_inertia2			; branch if negative
		move.w	#0,d0					; set to 0 if positive (after addition)

	@update_inertia2:
		move.w	d0,ost_inertia(a0)			; set new inertia

SSS_UpdatePos:
		move.b	(v_ss_angle).w,d0			; get stage angle
		addi.b	#$20,d0
		andi.b	#$C0,d0					; read only bits 7 and 6
		neg.b	d0
		jsr	(CalcSine).l				; convert to sine
		muls.w	ost_inertia(a0),d1
		add.l	d1,ost_x_pos(a0)			; add (inertia*cosine) to x pos
		muls.w	ost_inertia(a0),d0
		add.l	d0,ost_y_pos(a0)			; add (inertia*sine) to y pos
		movem.l	d0-d1,-(sp)				; save values to stack
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		bsr.w	SSS_FindWall				; detect nearby walls
		beq.s	@no_collide				; branch if none found
		movem.l	(sp)+,d0-d1
		sub.l	d1,ost_x_pos(a0)			; cancel position updates
		sub.l	d0,ost_y_pos(a0)
		move.w	#0,ost_inertia(a0)			; stop Sonic
		rts	
; ===========================================================================

@no_collide:
		movem.l	(sp)+,d0-d1
		rts	
; End of function SSS_Move


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_MoveLeft:
		bset	#status_xflip_bit,ost_status(a0)
		move.w	ost_inertia(a0),d0			; get inertia
		beq.s	@inertia_0				; branch if 0
		bpl.s	@inertia_positive			; branch if positive (moving right)

	@inertia_0:
		subi.w	#$C,d0					; subtract $C from inertia
		cmpi.w	#-sonic_ss_max_speed,d0
		bgt.s	@update_inertia
		move.w	#-sonic_ss_max_speed,d0			; set minimum inertia

	@update_inertia:
		move.w	d0,ost_inertia(a0)
		rts	
; ===========================================================================

@inertia_positive:
		subi.w	#$40,d0
		bcc.s	@wait
		nop	

	@wait:
		move.w	d0,ost_inertia(a0)
		rts	
; End of function SSS_MoveLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_MoveRight:
		bclr	#status_xflip_bit,ost_status(a0)
		move.w	ost_inertia(a0),d0			; get inertia
		bmi.s	@inertia_neg				; branch if negative (moving left)
		addi.w	#$C,d0					; add $C to inertia
		cmpi.w	#sonic_ss_max_speed,d0
		blt.s	@update_inertia
		move.w	#sonic_ss_max_speed,d0			; set maximum inertia

	@update_inertia:
		move.w	d0,ost_inertia(a0)
		bra.s	@exit
; ===========================================================================

@inertia_neg:
		addi.w	#$40,d0
		bcc.s	@wait
		nop	

	@wait:
		move.w	d0,ost_inertia(a0)

	@exit:
		rts	
; End of function SSS_MoveRight


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_Jump:
		move.b	(v_joypad_press).w,d0
		andi.b	#btnABC,d0				; is A,	B or C pressed?
		beq.s	@exit					; if not, branch
		move.b	(v_ss_angle).w,d0			; get SS angle
		andi.b	#$FC,d0					; round down to 4
		neg.b	d0
		subi.b	#$40,d0
		jsr	(CalcSine).l				; convert to sine/cosine
		muls.w	#sonic_jump_power,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)
		muls.w	#sonic_jump_power,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)		; goto SSS_InAir next
		play.w	1, jsr, sfx_Jump			; play jumping sound

	@exit:
		rts	
; End of function SSS_Jump


; ---------------------------------------------------------------------------
; unused subroutine to limit Sonic's upward vertical speed
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


nullsub_2:
		rts
		
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
		subi.w	#160,d3
		bcs.s	@ignore_x				; branch if Sonic is within 160px of left edge
		sub.w	d3,d0
		sub.w	d0,(v_camera_x_pos).w

	@ignore_x:
		move.w	(v_camera_y_pos).w,d0
		subi.w	#112,d2
		bcs.s	@ignore_y				; branch if Sonic is within 112px of top edge
		sub.w	d2,d0
		sub.w	d0,(v_camera_y_pos).w

	@ignore_y:
		rts	
; End of function SS_FixCamera

; ===========================================================================

SSS_ExitStage:
		addi.w	#$40,(v_ss_rotation_speed).w		; increase stage rotation
		cmpi.w	#$1800,(v_ss_rotation_speed).w		; check if it's up to $1800
		bne.s	@not1800				; if not, branch
		move.b	#id_Level,(v_gamemode).w		; set game mode to normal level

	@not1800:
		cmpi.w	#$3000,(v_ss_rotation_speed).w		; check if it's up to $3000
		blt.s	@not3000				; if not, branch
		move.w	#0,(v_ss_rotation_speed).w		; stop rotation
		move.w	#$4000,(v_ss_angle).w
		addq.b	#2,ost_routine(a0)			; goto SSS_Exit2 next
		move.w	#60,ost_ss_restart_time(a0)

	@not3000:
		move.w	(v_ss_angle).w,d0
		add.w	(v_ss_rotation_speed).w,d0
		move.w	d0,(v_ss_angle).w
		jsr	(Sonic_Animate).l
		jsr	(Sonic_LoadGfx).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l
; ===========================================================================

SSS_Exit2:
		subq.w	#1,ost_ss_restart_time(a0)
		bne.s	@wait
		move.b	#id_Level,(v_gamemode).w

	@wait:
		jsr	(Sonic_Animate).l
		jsr	(Sonic_LoadGfx).l
		bsr.w	SS_FixCamera
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_Fall:
		move.l	ost_y_pos(a0),d2
		move.l	ost_x_pos(a0),d3
		move.b	(v_ss_angle).w,d0			; get special stage angle
		andi.b	#$FC,d0					; round down to multiple of 4
		jsr	(CalcSine).l				; convert to sine/cosine
		move.w	ost_x_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0					; d0 = (ost_x_vel*$100)+(sine*$2A)
		move.w	ost_y_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1					; d1 = (ost_y_vel*$100)+(cosine*$2A)
		add.l	d0,d3					; d3 = ost_x_pos+d0
		bsr.w	SSS_FindWall				; detect wall to right
		beq.s	loc_1BCB0				; branch if not found
		sub.l	d0,d3					; d3 = ost_x_pos
		moveq	#0,d0
		move.w	d0,ost_x_vel(a0)			; stop moving right
		bclr	#status_air_bit,ost_status(a0)
		add.l	d1,d2					; d2 = ost_y_pos+d1
		bsr.w	SSS_FindWall				; detect wall below
		beq.s	loc_1BCC6				; branch if not found
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,ost_y_vel(a0)			; stop moving down
		rts	
; ===========================================================================

loc_1BCB0:
		add.l	d1,d2
		bsr.w	SSS_FindWall				; detect wall below
		beq.s	SSS_Fall_NoWall				; branch if not found
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,ost_y_vel(a0)			; stop moving down
		bclr	#status_air_bit,ost_status(a0)

loc_1BCC6:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,ost_x_vel(a0)
		move.w	d1,ost_y_vel(a0)
		rts	
; ===========================================================================

SSS_Fall_NoWall:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,ost_x_vel(a0)
		move.w	d1,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)		; Sonic is in the air, touching no walls
		rts	
; End of function SSS_Fall


; ---------------------------------------------------------------------------
; Wall detection subroutine

; input:
;	d2 = y position
;	d3 = x position

; output:
;	d5 = flag: 0 = no collision (e.g. rings); -1 = collision with solid wall
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_FindWall:
		lea	(v_ss_layout).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4					; d4 = y pos
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4					; divide by width of SS blocks (24 pixels)
		mulu.w	#$80,d4					; multiply by bytes per SS row
		adda.l	d4,a1					; jump to position in layout
		moveq	#0,d4
		swap	d3
		move.w	d3,d4					; d4 = x pos
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4					; divide by width of SS blocks (24 pixels)
		adda.w	d4,a1					; jump to position in layout
		moveq	#0,d5
		move.b	(a1)+,d4				; get id of wall/item
		bsr.s	SSS_FindWall_Chk
		move.b	(a1)+,d4				; get id of adjacent wall/item
		bsr.s	SSS_FindWall_Chk
		adda.w	#$7E,a1					; next row
		move.b	(a1)+,d4				; get id of adjacent wall/item
		bsr.s	SSS_FindWall_Chk
		move.b	(a1)+,d4				; get id of adjacent wall/item
		bsr.s	SSS_FindWall_Chk
		tst.b	d5
		rts	
; End of function SSS_FindWall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_FindWall_Chk:
		beq.s	@no_collide				; branch if 0
		cmpi.b	#id_SS_Item_1Up,d4			; is the item an extra life?
		beq.s	@no_collide				; if yes, branch
		cmpi.b	#id_SS_Item_Em1-1,d4			; is the item an emerald or ghost block ($3B+)?
		bcs.s	@collide				; if yes, branch
		cmpi.b	#id_SS_Item_Glass5,d4			; is the item a flashing glass block ($4B+)?
		bcc.s	@collide				; if not, branch

	@no_collide:
		rts	
; ===========================================================================

@collide:
		move.b	d4,ost_ss_item(a0)
		move.l	a1,ost_ss_item_address(a0)
		moveq	#-1,d5					; set flag for collision
		rts	
; End of function SSS_FindWall_Chk


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_ChkItems:
		lea	(v_ss_layout).l,a1			; get layout address
		moveq	#0,d4
		move.w	ost_y_pos(a0),d4			; d4 = y pos
		addi.w	#$50,d4
		divu.w	#$18,d4					; divide by width of SS blocks (24 pixels)
		mulu.w	#$80,d4					; multiply by bytes per SS row
		adda.l	d4,a1					; jump to position in layout
		moveq	#0,d4
		move.w	ost_x_pos(a0),d4			; d4 = x pos
		addi.w	#$20,d4
		divu.w	#$18,d4					; divide by width of SS blocks (24 pixels)
		adda.w	d4,a1					; jump to position in layout
		move.b	(a1),d4					; get id of wall/item
		bne.s	SSS_ChkRing				; branch if not 0
		tst.b	ost_ss_ghost(a0)			; check ghost block status
		bne.w	SSS_MakeGhostSolid			; branch if passed/solid
		moveq	#0,d4
		rts	
; ===========================================================================

SSS_ChkRing:
		cmpi.b	#id_SS_Item_Ring,d4			; is the item a	ring?
		bne.s	SSS_Chk1Up				; if not, branch
		bsr.w	SS_FindFreeUpdate			; find free item update slot
		bne.s	@noslot
		move.b	#id_SS_UpdateRing,(a2)			; item sparkles and vanishes
		move.l	a1,4(a2)

	@noslot:
		jsr	(CollectRing).l				; get a ring
		cmpi.w	#50,(v_rings).w				; check if you have 50 rings
		bcs.s	@nocontinue				; if not, branch
		bset	#0,(v_ring_reward).w			; set flag
		bne.s	@nocontinue				; branch if flag was already set
		addq.b	#1,(v_continues).w			; add 1 to number of continues
		play.w	0, jsr, sfx_Continue			; play extra continue sound

	@nocontinue:
		moveq	#0,d4
		rts	
; ===========================================================================

SSS_Chk1Up:
		cmpi.b	#id_SS_Item_1Up,d4			; is the item an extra life?
		bne.s	SSS_ChkEmerald
		bsr.w	SS_FindFreeUpdate
		bne.s	@noslot
		move.b	#id_SS_Update1Up,(a2)
		move.l	a1,4(a2)

	@noslot:
		addq.b	#1,(v_lives).w				; add 1 to number of lives
		addq.b	#1,(f_hud_lives_update).w		; update the lives counter
		play.w	0, jsr, mus_ExtraLife			; play extra life music
		moveq	#0,d4
		rts	
; ===========================================================================

SSS_ChkEmerald:
		cmpi.b	#id_SS_Item_Em1,d4			; is the item an emerald?
		bcs.s	SSS_ChkGhost
		cmpi.b	#id_SS_Item_Em6,d4
		bhi.s	SSS_ChkGhost
		bsr.w	SS_FindFreeUpdate
		bne.s	@noslot
		move.b	#id_SS_UpdateEmerald,(a2)
		move.l	a1,4(a2)

	@noslot:
		cmpi.b	#6,(v_emeralds).w			; do you have all the emeralds?
		beq.s	@noemerald				; if yes, branch
		subi.b	#id_SS_Item_Em1,d4
		moveq	#0,d0
		move.b	(v_emeralds).w,d0
		lea	(v_emerald_list).w,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,(v_emeralds).w			; add 1 to number of emeralds

	@noemerald:
		play.w	1, jsr, mus_Emerald			; play emerald music
		moveq	#0,d4
		rts	
; ===========================================================================

SSS_ChkGhost:
		cmpi.b	#id_SS_Item_Ghost,d4			; is the item a	ghost block?
		bne.s	SSS_ChkGhostTag				; if not, branch
		move.b	#1,ost_ss_ghost(a0)			; mark the ghost block as "passed"

SSS_ChkGhostTag:
		cmpi.b	#id_SS_Item_Ghost2,d4			; is the item a	switch for ghost blocks?
		bne.s	@noghost				; if not, branch
		cmpi.b	#1,ost_ss_ghost(a0)			; have the ghost blocks been passed?
		bne.s	@noghost				; if not, branch
		move.b	#2,ost_ss_ghost(a0)			; mark the ghost blocks as "solid"

	@noghost:
		moveq	#-1,d4
		rts	
; ===========================================================================

SSS_MakeGhostSolid:
		cmpi.b	#2,ost_ss_ghost(a0)			; is the ghost marked as "solid"?
		bne.s	@notsolid				; if not, branch
		lea	(v_ss_layout+$1020).l,a1		; get layout address (blocks before $1020 are blank)
		moveq	#$40-1,d1

	@looprow:
		moveq	#$40-1,d2

	@loopitem:
		cmpi.b	#id_SS_Item_Ghost,(a1)			; is the item a	ghost block?
		bne.s	@noreplace				; if not, branch
		move.b	#id_SS_Item_RedWhi,(a1)			; replace ghost	block with a solid block

	@noreplace:
		addq.w	#1,a1
		dbf	d2,@loopitem
		lea	$40(a1),a1
		dbf	d1,@looprow

@notsolid:
		clr.b	ost_ss_ghost(a0)
		moveq	#0,d4
		rts	
; End of function SSS_ChkItems


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SSS_ChkItems2:
		move.b	ost_ss_item(a0),d0			; get item id
		bne.s	SSS_ChkBumper				; branch if not 0
		subq.b	#1,ost_ss_updown_time(a0)		; decrement timer for UP/DOWN usage
		bpl.s	@updown_off				; branch if positive
		move.b	#0,ost_ss_updown_time(a0)		; set to 0

	@updown_off:
		subq.b	#1,ost_ss_r_time(a0)
		bpl.s	@r_off
		move.b	#0,ost_ss_r_time(a0)

	@r_off:
		rts	
; ===========================================================================

SSS_ChkBumper:
		cmpi.b	#id_SS_Item_Bumper,d0			; is the item a	bumper?
		bne.s	SSS_GOAL				; if not, branch
		move.l	ost_ss_item_address(a0),d1		; get address of bumper within layout
		subi.l	#v_ss_layout+1,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1					; d1 = x position of bumper
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2					; d2 = y position of bumper
		sub.w	ost_x_pos(a0),d1
		sub.w	ost_y_pos(a0),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)			; bounce Sonic away from bumper
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)
		bset	#status_air_bit,ost_status(a0)		; set Sonic's air flag
		bsr.w	SS_FindFreeUpdate			; find free item update slot
		bne.s	@noslot					; branch if not found
		move.b	#id_SS_UpdateBumper,(a2)
		move.l	ost_ss_item_address(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

	@noslot:
		play.w	1, jmp, sfx_Bumper			; play bumper sound
; ===========================================================================

SSS_GOAL:
		cmpi.b	#id_SS_Item_GOAL,d0			; is the item a	"GOAL"?
		bne.s	SSS_UPblock				; if not, branch
		addq.b	#2,ost_routine(a0)			; run routine "SSS_ExitStage"
		play.w	1, jsr, sfx_Goal			; play "GOAL" sound
		rts	
; ===========================================================================

SSS_UPblock:
		cmpi.b	#id_SS_Item_Up,d0			; is the item an "UP" block?
		bne.s	SSS_DOWNblock				; if not, branch
		tst.b	ost_ss_updown_time(a0)			; check UP/DOWN cooldown
		bne.w	SSS_ChkItems_End			; branch if time remains
		move.b	#30,ost_ss_updown_time(a0)		; set cooldown to half a second
		btst	#6,(v_ss_rotation_speed+1).w		; is SS rotation speed $40? (minimum)
		beq.s	@keepspeed				; if not, branch
		asl	(v_ss_rotation_speed).w			; increase stage rotation speed
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.b	#id_SS_Item_Down,(a1)			; change item to a "DOWN" block

	@keepspeed:
		play.w	1, jmp, sfx_ActionBlock			; play up/down sound
; ===========================================================================

SSS_DOWNblock:
		cmpi.b	#id_SS_Item_Down,d0			; is the item a	"DOWN" block?
		bne.s	SSS_Rblock				; if not, branch
		tst.b	ost_ss_updown_time(a0)			; check UP/DOWN cooldown
		bne.w	SSS_ChkItems_End
		move.b	#30,ost_ss_updown_time(a0)
		btst	#6,(v_ss_rotation_speed+1).w		; is SS rotation speed $40? (minimum)
		bne.s	@keepspeed				; if yes, branch
		asr	(v_ss_rotation_speed).w			; reduce stage rotation speed
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.b	#id_SS_Item_Up,(a1)			; change item to an "UP" block

	@keepspeed:
		play.w	1, jmp, sfx_ActionBlock			; play up/down sound
; ===========================================================================

SSS_Rblock:
		cmpi.b	#id_SS_Item_R,d0			; is the item an "R" block?
		bne.s	SSS_ChkGlass				; if not, branch
		tst.b	ost_ss_r_time(a0)			; check R cooldown
		bne.w	SSS_ChkItems_End
		move.b	#30,ost_ss_r_time(a0)
		bsr.w	SS_FindFreeUpdate			; find free item update slot
		bne.s	@noslot					; branch if not found
		move.b	#id_SS_UpdateR,(a2)
		move.l	ost_ss_item_address(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

	@noslot:
		neg.w	(v_ss_rotation_speed).w			; reverse stage rotation
		play.w	1, jmp, sfx_ActionBlock			; play R-block sound
; ===========================================================================

SSS_ChkGlass:
		cmpi.b	#id_SS_Item_Glass1,d0			; is the item a	glass block?
		beq.s	@glass					; if yes, branch
		cmpi.b	#id_SS_Item_Glass2,d0
		beq.s	@glass
		cmpi.b	#id_SS_Item_Glass3,d0
		beq.s	@glass
		cmpi.b	#id_SS_Item_Glass4,d0
		bne.s	SSS_ChkItems_End			; if not, branch

	@glass:
		bsr.w	SS_FindFreeUpdate			; find free item update slot
		bne.s	@noslot
		move.b	#id_SS_UpdateGlass,(a2)
		movea.l	ost_ss_item_address(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0					; change glass type when touched
		cmpi.b	#id_SS_Item_Glass4,d0
		bls.s	@update					; if glass is still there, branch
		clr.b	d0					; remove the glass block when it's destroyed

	@update:
		move.b	d0,4(a2)				; update the stage layout

	@noslot:
		play.w	1, jmp, sfx_Diamonds			; play diamond block sound
; ===========================================================================

SSS_ChkItems_End:
		rts	
; End of function SSS_ChkItems2
