; ---------------------------------------------------------------------------
; Object 73 - Eggman (MZ)

; spawned by:
;	DynamicLevelEvents
; ---------------------------------------------------------------------------

BossMarble:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BMZ_Index(pc,d0.w),d1
		jmp	BMZ_Index(pc,d1.w)
; ===========================================================================
BMZ_Index:	index *,,2
		ptr BMZ_Main
		ptr BMZ_ShipMain
		ptr BMZ_FaceMain
		ptr BMZ_FlameMain
		ptr BMZ_TubeMain

BMZ_ObjData:	dc.b id_BMZ_ShipMain, id_ani_boss_ship, 4	; routine number, animation, priority
		dc.b id_BMZ_FaceMain, id_ani_boss_face1, 4
		dc.b id_BMZ_FlameMain, id_ani_boss_blank, 4
		dc.b id_BMZ_TubeMain, id_ani_boss_ship, 3

ost_bmz_parent_x_pos:	equ $30					; parent x position (2 bytes)
ost_bmz_fireball_time:	equ $34					; time between fireballs coming out of lava - parent only
ost_bmz_parent:		equ $34					; address of OST of parent object - children only (4 bytes)
ost_bmz_parent_y_pos:	equ $38					; parent y position (2 bytes)
ost_bmz_wait_time:	equ $3C					; time to wait between each action (2 bytes)
ost_bmz_flash_num:	equ $3E					; number of times to make boss flash when hit
ost_bmz_wobble:		equ $3F					; wobble state as Eggman moves back & forth (1 byte incremented every frame & interpreted by CalcSine)
; ===========================================================================

BMZ_Main:	; Routine 0
		move.w	ost_x_pos(a0),ost_bmz_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_bmz_parent_y_pos(a0)
		move.b	#id_col_24x24,ost_col_type(a0)
		move.b	#8,ost_col_property(a0)			; set number of hits to 8
		lea	BMZ_ObjData(pc),a2			; get routine number, animation & priority
		movea.l	a0,a1					; replace current object with 1st in list
		moveq	#3,d1					; 3 additional objects
		bra.s	@load_boss
; ===========================================================================

@loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	BMZ_ShipMain				; branch if not found
		move.b	#id_BossMarble,ost_id(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

@load_boss:
		bclr	#status_xflip_bit,ost_status(a0)
		clr.b	ost_routine2(a1)
		move.b	(a2)+,ost_routine(a1)			; goto BMZ_ShipMain/BMZ_FaceMain/BMZ_FlameMain/BMZ_TubeMain next
		move.b	(a2)+,ost_anim(a1)
		move.b	(a2)+,ost_priority(a1)
		move.l	#Map_Bosses,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.l	a0,ost_bmz_parent(a1)			; save address of OST of parent
		dbf	d1,@loop				; repeat sequence 3 more times

BMZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	BMZ_ShipIndex(pc,d0.w),d1
		jsr	BMZ_ShipIndex(pc,d1.w)
		lea	(Ani_Bosses).l,a1
		jsr	(AnimateSprite).l
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
BMZ_ShipIndex:index *,,2
		ptr BMZ_ShipStart
		ptr BMZ_ShipMove
		ptr BMZ_Explode
		ptr BMZ_Recover
		ptr BMZ_Escape
; ===========================================================================

BMZ_ShipStart:
		move.b	ost_bmz_wobble(a0),d0			; get wobble byte
		addq.b	#2,ost_bmz_wobble(a0)			; increment wobble (wraps to 0 after $FE)
		jsr	(CalcSine).l				; convert to sine
		asr.w	#2,d0					; divide by 4
		move.w	d0,ost_y_vel(a0)			; set as y speed
		move.w	#-$100,ost_x_vel(a0)			; move ship left
		bsr.w	BossMove				; update parent position
		cmpi.w	#$1910,ost_bmz_parent_x_pos(a0)		; has boss reached target position?
		bne.s	@not_at_pos				; if not, branch
		addq.b	#2,ost_routine2(a0)			; goto BMZ_ShipMove next
		clr.b	ost_subtype(a0)
		clr.l	ost_x_vel(a0)				; stop moving

	@not_at_pos:
		jsr	(RandomNumber).l
		move.b	d0,ost_bmz_fireball_time(a0)		; set fireball timer to random value

BMZ_Update:
		move.w	ost_bmz_parent_y_pos(a0),ost_y_pos(a0)	; update actual position
		move.w	ost_bmz_parent_x_pos(a0),ost_x_pos(a0)
		cmpi.b	#id_BMZ_Explode,ost_routine2(a0)
		bcc.s	@exit
		tst.b	ost_status(a0)				; has boss been beaten?
		bmi.s	@beaten					; if yes, branch
		tst.b	ost_col_type(a0)			; is ship collision clear?
		bne.s	@exit					; if not, branch
		tst.b	ost_bmz_flash_num(a0)			; is ship flashing?
		bne.s	@flash					; if yes, branch
		move.b	#$28,ost_bmz_flash_num(a0)		; set ship to flash 40 times
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

	@flash:
		lea	(v_pal_dry_line2+2).w,a1		; load 2nd palette, 2nd entry
		moveq	#0,d0					; move 0 (black) to d0
		tst.w	(a1)					; is colour white?
		bne.s	@is_white				; if yes, branch
		move.w	#cWhite,d0				; move $EEE (white) to d0

	@is_white:
		move.w	d0,(a1)					; load colour stored in	d0
		subq.b	#1,ost_bmz_flash_num(a0)		; decrement flash counter
		bne.s	@exit					; branch if not 0
		move.b	#id_col_24x24,ost_col_type(a0)		; enable boss collision again

	@exit:
		rts	
; ===========================================================================

@beaten:
		moveq	#100,d0
		bsr.w	AddPoints				; give Sonic 1000 points
		move.b	#id_BMZ_Explode,ost_routine2(a0)
		move.w	#180,ost_bmz_wait_time(a0)		; set timer to 3 seconds
		clr.w	ost_x_vel(a0)				; stop boss moving
		rts	
; ===========================================================================

BMZ_ShipMove:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.w	BMZ_ShipMove_Index(pc,d0.w),d0
		jsr	BMZ_ShipMove_Index(pc,d0.w)		; jump to subroutine based on subtype
		andi.b	#6,ost_subtype(a0)			; clear bits except bits 1-2
		bra.w	BMZ_Update				; update actual position, check for hits
; ===========================================================================
BMZ_ShipMove_Index:
		index *,,2
		ptr BMZ_ChgDir
		ptr BMZ_DropFire
		ptr BMZ_ChgDir
		ptr BMZ_DropFire
; ===========================================================================

BMZ_ChgDir:
		tst.w	ost_x_vel(a0)				; is ship moving horizontally?
		bne.s	@is_moving_h				; if yes, branch
		moveq	#$40,d0					; ship should move down
		cmpi.w	#$22C,ost_bmz_parent_y_pos(a0)		; is ship at its highest? (i.e. above platform)
		beq.s	@at_peak				; if yes, branch
		bcs.s	@above_max				; branch if ship goes above max
		neg.w	d0					; ship should move up

	@above_max:
		move.w	d0,ost_y_vel(a0)			; set y speed
		bra.w	BossMove				; update parent position
; ===========================================================================

@at_peak:
		move.w	#$200,ost_x_vel(a0)			; move ship right
		move.w	#$100,ost_y_vel(a0)			; move ship down
		btst	#status_xflip_bit,ost_status(a0)	; is ship facing left?
		bne.s	@face_right				; if not, branch
		neg.w	ost_x_vel(a0)				; move left instead

@is_moving_h:
	@face_right:
		cmpi.b	#$18,ost_bmz_flash_num(a0)		; has boss recently been hit?
		bcc.s	@skip_movement				; if yes, branch
		bsr.w	BossMove
		subq.w	#4,ost_y_vel(a0)

	@skip_movement:
		subq.b	#1,ost_bmz_fireball_time(a0)		; decrement fireball timer
		bcc.s	@skip_fireball				; branch if time remains

		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_FireBall,ost_id(a1)			; load fireball object that comes from lava
		move.w	#$2E8,ost_y_pos(a1)			; set y position as beneath lava
		jsr	(RandomNumber).l
		andi.l	#$FFFF,d0
		divu.w	#$50,d0
		swap	d0
		addi.w	#$1878,d0
		move.w	d0,ost_x_pos(a1)			; randomise x pos
		lsr.b	#7,d1
		move.w	#$FF,ost_subtype(a1)			; flag fireball as being spawned by boss

	@fail:
		jsr	(RandomNumber).l
		andi.b	#$1F,d0
		addi.b	#$40,d0
		move.b	d0,ost_bmz_fireball_time(a0)		; reset fireball timer as random

	@skip_fireball:
		btst	#status_xflip_bit,ost_status(a0)	; is ship facing right?
		beq.s	@chk_left				; if yes, branch
		cmpi.w	#$1910,ost_bmz_parent_x_pos(a0)		; is boss on far right of screen?
		blt.s	@exit					; if not, branch
		move.w	#$1910,ost_bmz_parent_x_pos(a0)		; keep from moving further
		bra.s	@stop_moving_h
; ===========================================================================

@chk_left:
		cmpi.w	#$1830,ost_bmz_parent_x_pos(a0)		; is boss on far left of screen?
		bgt.s	@exit					; if not, branch
		move.w	#$1830,ost_bmz_parent_x_pos(a0)		; keep from moving further

@stop_moving_h:
		clr.w	ost_x_vel(a0)				; stop moving horizontally
		move.w	#-$180,ost_y_vel(a0)			; move straight up
		cmpi.w	#$22C,ost_bmz_parent_y_pos(a0)		; is ship at its highest?
		bcc.s	@drop_fire				; if not, branch
		neg.w	ost_y_vel(a0)				; start moving down

	@drop_fire:
		addq.b	#2,ost_subtype(a0)			; goto BMZ_DropFire next

@exit:
		rts	
; ===========================================================================

BMZ_DropFire:
		bsr.w	BossMove				; update parent position
		move.w	ost_bmz_parent_y_pos(a0),d0
		subi.w	#$22C,d0
		bgt.s	@exit					; branch if ship is below highest
		move.w	#$22C,d0
		tst.w	ost_y_vel(a0)
		beq.s	@skip_fireball				; branch if ship already stopped moving up
		clr.w	ost_y_vel(a0)				; stop ship moving up
		move.w	#80,ost_bmz_wait_time(a0)		; set timer to 1.3 seconds
		bchg	#status_xflip_bit,ost_status(a0)	; turn ship around
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@skip_fireball				; branch if not found
		move.w	ost_bmz_parent_x_pos(a0),ost_x_pos(a1)
		move.w	ost_bmz_parent_y_pos(a0),ost_y_pos(a1)
		addi.w	#$18,ost_y_pos(a1)
		move.b	#id_BossFire,(a1)			; load fireball object that comes from ship
		move.b	#1,ost_subtype(a1)			; set type to vertical

	@skip_fireball:
		subq.w	#1,ost_bmz_wait_time(a0)		; decrement timer
		bne.s	@exit					; branch if time remains
		addq.b	#2,ost_subtype(a0)			; goto BMZ_ChgDir next

	@exit:
		rts	
; ===========================================================================

BMZ_Explode:
		subq.w	#1,ost_bmz_wait_time(a0)		; decrement timer
		bmi.s	@stop_exploding				; branch if below 0
		bra.w	BossExplode				; load explosion object
; ===========================================================================

@stop_exploding:
		bset	#status_xflip_bit,ost_status(a0)	; ship face right
		bclr	#status_broken_bit,ost_status(a0)
		clr.w	ost_x_vel(a0)				; stop moving
		addq.b	#2,ost_routine2(a0)			; goto BMZ_Recover next
		move.w	#-$26,ost_bmz_wait_time(a0)		; set timer (counts up)
		tst.b	(v_boss_status).w
		bne.s	@exit
		move.b	#1,(v_boss_status).w			; set boss beaten flag
		clr.w	ost_y_vel(a0)

	@exit:
		rts	
; ===========================================================================

BMZ_Recover:
		addq.w	#1,ost_bmz_wait_time(a0)		; increment timer
		beq.s	@stop_falling				; branch if 0
		bpl.s	@ship_recovers				; branch if 1 or more
		cmpi.w	#$270,ost_bmz_parent_y_pos(a0)
		bcc.s	@stop_falling				; branch if ship drops below $270 on y axis
		addi.w	#$18,ost_y_vel(a0)			; apply gravity (falls)
		bra.s	@update
; ===========================================================================

@stop_falling:
		clr.w	ost_y_vel(a0)				; stop falling
		clr.w	ost_bmz_wait_time(a0)
		bra.s	@update
; ===========================================================================

@ship_recovers:
		cmpi.w	#$30,ost_bmz_wait_time(a0)		; have 48 frames passed since ship stopped falling?
		bcs.s	@ship_rises				; if not, branch
		beq.s	@stop_rising				; if exactly 48, branch
		cmpi.w	#$38,ost_bmz_wait_time(a0)		; have 56 frames passed since ship stopped rising?
		bcs.s	@update					; if not, branch
		addq.b	#2,ost_routine2(a0)			; if yes, goto BMZ_Escape next
		bra.s	@update
; ===========================================================================

@ship_rises:
		subq.w	#8,ost_y_vel(a0)			; move ship upwards
		bra.s	@update
; ===========================================================================

@stop_rising:
		clr.w	ost_y_vel(a0)				; stop ship rising
		play.w	0, jsr, mus_MZ				; play MZ music

@update:
		bsr.w	BossMove				; update parent position
		bra.w	BMZ_Update				; update actual position
; ===========================================================================

BMZ_Escape:
		move.w	#$500,ost_x_vel(a0)			; move ship right
		move.w	#-$40,ost_y_vel(a0)			; move ship upwards
		cmpi.w	#$1960,(v_boundary_right).w		; check for new boundary
		bcc.s	@chkdel
		addq.w	#2,(v_boundary_right).w			; expand right edge of level boundary
		bra.s	@update
; ===========================================================================

@chkdel:
		tst.b	ost_render(a0)				; is ship on-screen?
		bpl.s	@delete					; if not, branch

@update:
		bsr.w	BossMove				; update parent position
		bra.w	BMZ_Update				; update actual position
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BMZ_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#id_ani_boss_face1,d1
		movea.l	ost_bmz_parent(a0),a1			; get address of OST of parent object
		move.b	ost_routine2(a1),d0
		subq.w	#2,d0					; is ship on BMZ_ShipMove?
		bne.s	@chk_explode				; if not, branch
		btst	#1,ost_subtype(a1)
		beq.s	@chk_hit
		tst.w	ost_y_vel(a1)
		bne.s	@chk_hit
		moveq	#id_ani_boss_laugh,d1
		bra.s	@update
; ===========================================================================

@chk_explode:
		subq.b	#2,d0					; is ship on BMZ_Explode/BMZ_Recover/BMZ_Escape?
		bmi.s	@chk_hit				; if not, branch
		moveq	#id_ani_boss_defeat,d1
		bra.s	@update
; ===========================================================================

@chk_hit:
		tst.b	ost_col_type(a1)			; is boss collision on?
		bne.s	@chk_sonic_hurt				; if yes, branch
		moveq	#id_ani_boss_hit,d1			; use hit animation
		bra.s	@update
; ===========================================================================

@chk_sonic_hurt:
		cmpi.b	#id_Sonic_Hurt,(v_ost_player+ost_routine).w ; is Sonic hurt or dead?
		bcs.s	@update					; if not, branch
		moveq	#id_ani_boss_laugh,d1			; use laughing animation

@update:
		move.b	d1,ost_anim(a0)				; set animation
		subq.b	#4,d0					; is ship on BMZ_Escape?
		bne.s	@display				; if not, branch
		move.b	#id_ani_boss_panic,ost_anim(a0)		; use sweating animation
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch

	@display:
		bra.s	BMZ_Display
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BMZ_FlameMain:	; Routine 6
		move.b	#id_ani_boss_blank,ost_anim(a0)
		movea.l	ost_bmz_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BMZ_Escape,ost_routine2(a1)		; is ship on BMZ_Escape?
		blt.s	@chk_moving				; if not, branch
		move.b	#id_ani_boss_bigflame,ost_anim(a0)	; use big flame animation
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch
		bra.s	@display
; ===========================================================================

@chk_moving:
		tst.w	ost_x_vel(a1)
		beq.s	@display				; branch if ship isn't moving
		move.b	#id_ani_boss_flame1,ost_anim(a0)

@display:
		bra.s	BMZ_Display
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BMZ_Display:
		lea	(Ani_Bosses).l,a1
		jsr	(AnimateSprite).l

BMZ_Display_SkipAnim:
		movea.l	ost_bmz_parent(a0),a1			; get address of OST of parent object
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================

BMZ_TubeMain:	; Routine 8
		movea.l	ost_bmz_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BMZ_Escape,ost_routine2(a1)		; is ship on BMZ_Escape?
		bne.s	@display				; if not, branch
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch

	@display:
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#tile_Nem_Weapons+tile_pal2,ost_tile(a0)
		move.b	#id_frame_boss_pipe,ost_frame(a0)
		bra.s	BMZ_Display_SkipAnim
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
