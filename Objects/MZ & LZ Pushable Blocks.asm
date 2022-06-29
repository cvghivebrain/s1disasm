; ---------------------------------------------------------------------------
; Object 33 - pushable blocks (MZ, unused in LZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 0/$81
; ---------------------------------------------------------------------------

PushBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	PushB_Index(pc,d0.w),d1
		jmp	PushB_Index(pc,d1.w)
; ===========================================================================
PushB_Index:	index *,,2
		ptr PushB_Main
		ptr PushB_Action
		ptr PushB_ChkVisible

PushB_Var:
PushB_Var_0:	dc.b $10, id_frame_pblock_single		; object width,	frame number
PushB_Var_1:	dc.b $40, id_frame_pblock_four

sizeof_PushB_Var:	equ PushB_Var_1-PushB_Var

		rsobj PushBlock,$30
ost_pblock_lava_speed:	rs.w 1					; $30 ; x axis speed when block is on lava
ost_pblock_lava_flag:	rs.b 1					; $32 ; 1 = block is on lava
ost_pblock_x_start:	rs.w 1					; $34 ; original x position
ost_pblock_y_start:	rs.w 1					; $36 ; original y position
		rsobjend
; ===========================================================================

PushB_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto PushB_Action next
		move.b	#$F,ost_height(a0)
		move.b	#$F,ost_width(a0)
		move.l	#Map_Push,ost_mappings(a0)
		move.w	#tile_Nem_MzBlock+tile_pal3,ost_tile(a0) ; MZ specific code
		cmpi.b	#id_LZ,(v_zone).w			; is current zone Labyrinth?
		bne.s	@notLZ					; if not, branch
		move.w	#$3DE+tile_pal3,ost_tile(a0)		; LZ specific code

	@notLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_pblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_pblock_y_start(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype
		add.w	d0,d0
		andi.w	#$E,d0					; read low nybble
		lea	PushB_Var(pc,d0.w),a2			; get width & frame values from array
		move.b	(a2)+,ost_displaywidth(a0)
		move.b	(a2)+,ost_frame(a0)
		tst.b	ost_subtype(a0)				; is subtype 0?
		beq.s	@chkgone				; if yes, branch
		move.w	#tile_Nem_MzBlock+tile_pal3+tile_hi,ost_tile(a0) ; make sprite appear in foreground

	@chkgone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	PushB_Action
		bclr	#7,2(a2,d0.w)
		bset	#0,2(a2,d0.w)
		bne.w	DeleteObject

PushB_Action:	; Routine 2
		tst.b	ost_pblock_lava_flag(a0)		; is block on lava?
		bne.w	PushB_OnLava				; if yes, branch
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	PushB_Solid				; make block solid & update its position
		cmpi.w	#id_MZ_act1,(v_zone).w			; is the level MZ act 1?
		bne.s	PushB_Display				; if not, branch
		bclr	#7,ost_subtype(a0)
		move.w	ost_x_pos(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	PushB_Display
		cmpi.w	#$AA1,d0				; is block between $A20 and $AA1 on x axis?
		bcc.s	PushB_Display				; if not, branch
		
		move.w	(v_cstomp_y_pos).w,d0			; get y pos of nearby chain stomper
		subi.w	#$1C,d0
		move.w	d0,ost_y_pos(a0)			; set y pos of block so it's resting on the stomper
		bset	#7,(v_cstomp_y_pos).w			; set high bit of high byte of stomper y pos
		bset	#7,ost_subtype(a0)			; set flag to disable gravity for block

	PushB_Display:
		out_of_range.s	PushB_ChkDel
		bra.w	DisplaySprite
; ===========================================================================

PushB_ChkDel:
		out_of_range.s	PushB_ChkDel2,ost_pblock_x_start(a0)
		move.w	ost_pblock_x_start(a0),ost_x_pos(a0)
		move.w	ost_pblock_y_start(a0),ost_y_pos(a0)
		move.b	#id_PushB_ChkVisible,ost_routine(a0)
		bra.s	PushB_ChkVisible
; ===========================================================================

PushB_ChkDel2:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@del
		bclr	#0,2(a2,d0.w)

	@del:
		bra.w	DeleteObject
; ===========================================================================

PushB_ChkVisible:
		; Routine 4
		bsr.w	CheckOffScreen_Wide			; is block still on screen?
		beq.s	@visible				; if yes, branch
		move.b	#id_PushB_Action,ost_routine(a0)
		clr.b	ost_pblock_lava_flag(a0)
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)

	@visible:
		rts	
; ===========================================================================

PushB_OnLava:
		move.w	ost_x_pos(a0),-(sp)
		cmpi.b	#4,ost_routine2(a0)
		bcc.s	@pushing				; branch if ost_routine2 = 4 or 6 (PushB_Solid_Lava/PushB_Solid_Push)
		bsr.w	SpeedToPos				; update position

	@pushing:
		btst	#status_air_bit,ost_status(a0)		; has block been thrown into the air?
		beq.s	PushB_OnLava_ChkWall			; if not, branch
		addi.w	#$18,ost_y_vel(a0)			; apply gravity
		jsr	(FindFloorObj).l
		tst.w	d1					; has block hit the floor?
		bpl.w	@goto_solid				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)				; stop falling
		bclr	#status_air_bit,ost_status(a0)
		move.w	(a1),d0					; get 16x16 tile the block is on
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0				; is it block $16A+ (lava)?
		bcs.s	@goto_solid				; if not, branch
		move.w	ost_pblock_lava_speed(a0),d0
		asr.w	#3,d0
		move.w	d0,ost_x_vel(a0)			; make block float horizontally
		move.b	#1,ost_pblock_lava_flag(a0)
		clr.w	ost_y_sub(a0)

	@goto_solid:
		bra.s	PushB_OnLava_Solid
; ===========================================================================

PushB_OnLava_ChkWall:
		tst.w	ost_x_vel(a0)
		beq.w	PushB_OnLava_Sink			; branch if block isn't moving
		bmi.s	@wall_left				; branch if moving left
	
	@wall_right:
		moveq	#0,d3
		move.b	ost_displaywidth(a0),d3
		jsr	(FindWallRightObj).l
		tst.w	d1					; has block touched a wall?
		bmi.s	PushB_Stop				; if yes, branch
		bra.s	PushB_OnLava_Solid
; ===========================================================================

	@wall_left:
		moveq	#0,d3
		move.b	ost_displaywidth(a0),d3
		not.w	d3
		jsr	(FindWallLeftObj).l
		tst.w	d1					; has block touched a wall?
		bmi.s	PushB_Stop				; if yes, branch
		bra.s	PushB_OnLava_Solid
; ===========================================================================

PushB_Stop:
		clr.w	ost_x_vel(a0)				; stop block moving
		bra.s	PushB_OnLava_Solid
; ===========================================================================

PushB_OnLava_Sink:
		addi.l	#$2001,ost_y_pos(a0)			; sink in lava, $2001 subpixels each frame
		cmpi.b	#$A0,ost_y_sub+1(a0)			; has block been sinking for 160 frames?
		bcc.s	PushB_OnLava_Sunk			; if yes, branch

PushB_OnLava_Solid:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	PushB_Solid				; make block solid & update its position
		bsr.s	PushB_ChkGeyser
		bra.w	PushB_Display
; ===========================================================================

PushB_OnLava_Sunk:
		move.w	(sp)+,d4
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		bra.w	PushB_ChkDel

; ---------------------------------------------------------------------------
; Subroutine to load lava geysers when the block reaches specific x pos
; ---------------------------------------------------------------------------

PushB_ChkGeyser:
		cmpi.w	#id_MZ_act2,(v_zone).w			; is the level MZ act 2?
		bne.s	@not_mz2				; if not, branch
		move.w	#-$20,d2
		cmpi.w	#$DD0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$CC0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$BA0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		rts

@not_mz2:
		cmpi.w	#id_MZ_act3,(v_zone).w			; is the level MZ act 3?
		bne.s	@not_mz3				; if not, branch
		move.w	#$20,d2
		cmpi.w	#$560,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$5C0,ost_x_pos(a0)
		beq.s	PushB_LoadLava

	@not_mz3:
		rts	
; ===========================================================================

PushB_LoadLava:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_GeyserMaker,ost_id(a1)		; load lava geyser object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		add.w	d2,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		addi.w	#$10,ost_y_pos(a1)
		move.l	a0,ost_gmake_parent(a1)			; record block OST address as geyser's parent

	@fail:
		rts

; ---------------------------------------------------------------------------
; Subroutine to make the block solid, update its speed/position when pushed
; or on lava
;
; input:
;	d1 = width
;	d2 = height / 2 (when jumping)
;	d3 = height / 2 (when walking)
;	d4 = x-axis position
; ---------------------------------------------------------------------------

PushB_Solid:
		move.b	ost_routine2(a0),d0
		beq.w	PushB_Solid_Detect			; branch if ost_routine2 = 0
		subq.b	#2,d0
		bne.s	PushB_Solid_Lava			; branch if ost_routine2 > 2

		bsr.w	ExitPlatform
		btst	#status_platform_bit,ost_status(a1)
		bne.s	@on_block				; branch if Sonic is on the block
		clr.b	ost_routine2(a0)
		rts

	@on_block:
		move.w	d4,d2
		bra.w	MoveWithPlatform
; ===========================================================================

PushB_Solid_Lava:
		subq.b	#2,d0
		bne.s	PushB_Solid_Push			; branch if ost_routine2 = 6
		bsr.w	SpeedToPos				; update position
		addi.w	#$18,ost_y_vel(a0)			; apply gravity
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.w	@exit					; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)				; stop falling
		clr.b	ost_routine2(a0)			; goto PushB_Solid next
		move.w	(a1),d0					; get 16x16 tile the block is on
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0				; is it block $16A+ (lava)?
		bcs.s	@exit					; if not, branch
		move.w	ost_pblock_lava_speed(a0),d0
		asr.w	#3,d0
		move.w	d0,ost_x_vel(a0)			; make block float horizontally
		move.b	#1,ost_pblock_lava_flag(a0)
		clr.w	ost_y_sub(a0)

	@exit:
		rts	
; ===========================================================================

PushB_Solid_Push:
		bsr.w	SpeedToPos				; update position
		move.w	ost_x_pos(a0),d0
		andi.w	#$C,d0
		bne.w	PushB_Solid_Exit			; branch if bits 2 or 3 of x pos are set
		andi.w	#$FFF0,ost_x_pos(a0)			; snap to grid
		move.w	ost_x_vel(a0),ost_pblock_lava_speed(a0)	; set speed to move on lava
		clr.w	ost_x_vel(a0)
		subq.b	#2,ost_routine2(a0)			; goto PushB_Solid_Lava next
		rts	
; ===========================================================================

PushB_Solid_Detect:
		bsr.w	Solid_ChkCollision			; make block solid & update flags for interaction
		tst.w	d4
		beq.w	PushB_Solid_Exit			; branch if no collision
		bmi.w	PushB_Solid_Exit			; branch if top/bottom collision
		tst.b	ost_pblock_lava_flag(a0)
		beq.s	PushB_Solid_Side			; branch if not on lava
		bra.w	PushB_Solid_Exit
; ===========================================================================

PushB_Solid_Side:
		tst.w	d0					; where is Sonic?
		beq.w	PushB_Solid_Exit			; if inside the object, branch
		bmi.s	PushB_Solid_Left			; if left of the object, branch
		btst	#status_xflip_bit,ost_status(a1)	; is Sonic facing left?
		bne.w	PushB_Solid_Exit			; if yes, branch
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	ost_displaywidth(a0),d3
		jsr	(FindWallRightObj).l
		move.w	(sp)+,d0
		tst.w	d1					; has object hit right wall?
		bmi.w	PushB_Solid_Exit			; if not, branch
		addi.l	#$10000,ost_x_pos(a0)			; move 1px right and clear subpixels
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	PushB_Solid_Side_Sonic
; ===========================================================================

PushB_Solid_Left:
		btst	#status_xflip_bit,ost_status(a1)	; is Sonic facing right?
		beq.s	PushB_Solid_Exit			; if yes, branch
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	ost_displaywidth(a0),d3
		not.w	d3
		jsr	(FindWallLeftObj).l
		move.w	(sp)+,d0
		tst.w	d1					; has object hit left wall?
		bmi.s	PushB_Solid_Exit			; if not, branch
		subi.l	#$10000,ost_x_pos(a0)			; move 1px left and clear subpixels
		moveq	#-1,d0
		move.w	#-$40,d1

PushB_Solid_Side_Sonic:
		lea	(v_ost_player).w,a1
		add.w	d0,ost_x_pos(a1)			; + or - 1 to Sonic's x position
		move.w	d1,ost_inertia(a1)			; + or - $40 to Sonic's inertia
		move.w	#0,ost_x_vel(a1)
		move.w	d0,-(sp)
		play.w	1, jsr, sfx_Push			; play pushing sound
		move.w	(sp)+,d0
		tst.b	ost_subtype(a0)				; is bit 7 of subtype set? (no gravity flag)
		bmi.s	PushB_Solid_Exit			; if yes, branch
		move.w	d0,-(sp)
		jsr	(FindFloorObj).l
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	@align_floor				; branch if object is within 4px of floor
		move.w	#$400,ost_x_vel(a0)
		tst.w	d0
		bpl.s	@moving_right				; branch if moving right
		neg.w	ost_x_vel(a0)				; move left

	@moving_right:
		move.b	#6,ost_routine2(a0)			; goto PushB_Solid_Push next
		bra.s	PushB_Solid_Exit
; ===========================================================================

	@align_floor:
		add.w	d1,ost_y_pos(a0)

PushB_Solid_Exit:
		rts	
