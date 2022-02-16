; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ)

; spawned by:
;	DynamicLevelEvents - routine 0
;	BossGreenHill - routines 2/4/6
; ---------------------------------------------------------------------------

BossGreenHill:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BGHZ_Index(pc,d0.w),d1
		jmp	BGHZ_Index(pc,d1.w)
; ===========================================================================
BGHZ_Index:	index *,,2
		ptr BGHZ_Main
		ptr BGHZ_ShipMain
		ptr BGHZ_FaceMain
		ptr BGHZ_FlameMain

BGHZ_ObjData:	dc.b id_BGHZ_ShipMain, id_ani_boss_ship		; routine number, animation
		dc.b id_BGHZ_FaceMain, id_ani_boss_face1
		dc.b id_BGHZ_FlameMain,	id_ani_boss_blank

ost_bghz_parent_x_pos:	equ $30					; parent x position (2 bytes)
ost_bghz_parent:	equ $34					; address of OST of parent object (4 bytes)
ost_bghz_parent_y_pos:	equ $38					; parent y position (2 bytes)
ost_bghz_wait_time:	equ $3C					; time to wait between each action (2 bytes)
ost_bghz_flash_num:	equ $3E					; number of times to make boss flash when hit
ost_bghz_wobble:	equ $3F					; wobble state as Eggman moves back & forth (1 byte incremented every frame & interpreted by CalcSine)
; ===========================================================================

BGHZ_Main:	; Routine 0
		lea	(BGHZ_ObjData).l,a2			; get data for routine number & animation
		movea.l	a0,a1					; replace current object with 1st in list
		moveq	#2,d1					; 2 additional objects
		bra.s	@load_boss
; ===========================================================================

@loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	@fail					; branch if not found

@load_boss:
		move.b	(a2)+,ost_routine(a1)			; goto BGHZ_ShipMain/BGHZ_FaceMain/BGHZ_FlameMain next
		move.b	#id_BossGreenHill,ost_id(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.l	#Map_Eggman,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.b	#3,ost_priority(a1)
		move.b	(a2)+,ost_anim(a1)
		move.l	a0,ost_bghz_parent(a1)			; save address of OST of parent
		dbf	d1,@loop				; repeat sequence 2 more times

	@fail:
		move.w	ost_x_pos(a0),ost_bghz_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_bghz_parent_y_pos(a0)
		move.b	#id_col_24x24,ost_col_type(a0)
		move.b	#8,ost_col_property(a0)			; set number of hits to 8

BGHZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	BGHZ_ShipIndex(pc,d0.w),d1
		jsr	BGHZ_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	ost_status(a0),d0
		andi.b	#status_xflip+status_yflip,d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
BGHZ_ShipIndex:	index *,,2
		ptr BGHZ_ShipStart
		ptr BGHZ_MakeBall
		ptr BGHZ_ShipMove
		ptr BGHZ_ChgDir
		ptr BGHZ_Explode
		ptr BGHZ_Recover
		ptr BGHZ_Escape
; ===========================================================================

BGHZ_ShipStart:
		move.w	#$100,ost_y_vel(a0)			; move ship down
		bsr.w	BossMove				; update parent position
		cmpi.w	#$338,ost_bghz_parent_y_pos(a0)		; has ship reached target position?
		bne.s	BGHZ_Update				; if not, branch
		move.w	#0,ost_y_vel(a0)			; stop ship
		addq.b	#2,ost_routine2(a0)			; goto BGHZ_MakeBall next

BGHZ_Update:
		move.b	ost_bghz_wobble(a0),d0			; get wobble byte
		jsr	(CalcSine).l				; convert to sine
		asr.w	#6,d0					; divide by 64
		add.w	ost_bghz_parent_y_pos(a0),d0		; add y pos
		move.w	d0,ost_y_pos(a0)			; update actual y pos
		move.w	ost_bghz_parent_x_pos(a0),ost_x_pos(a0)	; update actual x pos
		addq.b	#2,ost_bghz_wobble(a0)			; increment wobble (wraps to 0 after $FE)
		cmpi.b	#id_BGHZ_Explode,ost_routine2(a0)
		bcc.s	@exit
		tst.b	ost_status(a0)				; has boss been beaten?
		bmi.s	@beaten					; if yes, branch
		tst.b	ost_col_type(a0)			; is ship collision clear?
		bne.s	@exit					; if not, branch
		tst.b	ost_bghz_flash_num(a0)			; is ship flashing?
		bne.s	@flash					; if yes, branch
		move.b	#$20,ost_bghz_flash_num(a0)		; set ship to flash 32 times
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

	@flash:
		lea	(v_pal_dry_line2+2).w,a1		; load 2nd palette, 2nd entry
		moveq	#0,d0					; move 0 (black) to d0
		tst.w	(a1)					; is colour white?
		bne.s	@is_white				; if yes, branch
		move.w	#cWhite,d0				; move $EEE (white) to d0

	@is_white:
		move.w	d0,(a1)					; load colour stored in	d0
		subq.b	#1,ost_bghz_flash_num(a0)		; decrement flash counter
		bne.s	@exit					; branch if not 0
		move.b	#id_col_24x24,ost_col_type(a0)		; enable boss collision again

	@exit:
		rts	
; ===========================================================================

@beaten:
		moveq	#100,d0
		bsr.w	AddPoints				; give Sonic 1000 points
		move.b	#id_BGHZ_Explode,ost_routine2(a0)
		move.w	#179,ost_bghz_wait_time(a0)		; set timer to 3 seconds
		rts	

; ---------------------------------------------------------------------------
; Subroutine to load explosions when a boss is beaten
; ---------------------------------------------------------------------------

BossExplode:
		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		andi.b	#7,d0					; read bits 0-2
		bne.s	@fail					; branch if any are set
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_ExplosionBomb,ost_id(a1)		; load explosion object every 8th frame
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,ost_x_pos(a1)			; randomise position
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,ost_y_pos(a1)

	@fail:
		rts	
; End of function BossExplode

; ---------------------------------------------------------------------------
; Subroutine to	translate a boss's speed to position
; ---------------------------------------------------------------------------

BossMove:
		move.l	ost_bghz_parent_x_pos(a0),d2
		move.l	ost_bghz_parent_y_pos(a0),d3
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	ost_y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,ost_bghz_parent_x_pos(a0)
		move.l	d3,ost_bghz_parent_y_pos(a0)
		rts	
; End of function BossMove

; ===========================================================================


BGHZ_MakeBall:
		move.w	#-$100,ost_x_vel(a0)			; move ship left
		move.w	#-$40,ost_y_vel(a0)			; move ship upwards
		bsr.w	BossMove				; update parent position
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a0)	; has ship reached target position?
		bne.s	@wait					; if not, branch
		move.w	#0,ost_x_vel(a0)			; stop ship
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine2(a0)			; goto BGHZ_ShipMove next
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_BossBall,ost_id(a1)			; load swinging ball object
		move.w	ost_bghz_parent_x_pos(a0),ost_x_pos(a1)
		move.w	ost_bghz_parent_y_pos(a0),ost_y_pos(a1)
		move.l	a0,ost_ball_parent(a1)

	@fail:
		move.w	#119,ost_bghz_wait_time(a0)		; set wait time to 2 seconds

	@wait:
		bra.w	BGHZ_Update				; update actual position, check for hits
; ===========================================================================

BGHZ_ShipMove:
		subq.w	#1,ost_bghz_wait_time(a0)		; decrement timer
		bpl.s	@wait					; branch if time remains
		addq.b	#2,ost_routine2(a0)			; goto BGHZ_ChgDir next
		move.w	#63,ost_bghz_wait_time(a0)		; set wait time to 1 second
		move.w	#$100,ost_x_vel(a0)			; set speed
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a0)	; has ship moved after ball was spawned?
		bne.s	@wait					; if yes, branch
		move.w	#127,ost_bghz_wait_time(a0)		; set timer to 2 seconds
		move.w	#$40,ost_x_vel(a0)			; set initial speed as slower

	@wait:
		btst	#status_xflip_bit,ost_status(a0)	; is ship facing left?
		bne.s	@face_right				; if not, branch
		neg.w	ost_x_vel(a0)				; go left instead

	@face_right:
		bra.w	BGHZ_Update				; update actual position, check for hits
; ===========================================================================

BGHZ_ChgDir:
		subq.w	#1,ost_bghz_wait_time(a0)		; decrement timer
		bmi.s	@chg_dir				; branch if below 0
		bsr.w	BossMove				; update parent position
		bra.s	@update_pos
; ===========================================================================

@chg_dir:
		bchg	#status_xflip_bit,ost_status(a0)	; change direction
		move.w	#63,ost_bghz_wait_time(a0)		; set wait time
		subq.b	#2,ost_routine2(a0)			; goto BGHZ_ShipMove next
		move.w	#0,ost_x_vel(a0)			; stop moving

@update_pos:
		bra.w	BGHZ_Update				; update actual position, check for hits
; ===========================================================================

BGHZ_Explode:
		subq.w	#1,ost_bghz_wait_time(a0)		; decrement timer
		bmi.s	@stop_exploding				; branch if below 0
		bra.w	BossExplode				; load explosion object
; ===========================================================================

@stop_exploding:
		bset	#status_xflip_bit,ost_status(a0)	; ship face right
		bclr	#status_broken_bit,ost_status(a0)
		clr.w	ost_x_vel(a0)				; stop moving
		addq.b	#2,ost_routine2(a0)			; goto BGHZ_Recover next
		move.w	#-38,ost_bghz_wait_time(a0)		; set timer (counts up)
		tst.b	(v_boss_status).w
		bne.s	@exit
		move.b	#1,(v_boss_status).w			; set boss beaten flag

	@exit:
		rts	
; ===========================================================================

BGHZ_Recover:
		addq.w	#1,ost_bghz_wait_time(a0)		; increment timer
		beq.s	@stop_falling				; branch if 0
		bpl.s	@ship_recovers				; branch if 1 or more
		addi.w	#$18,ost_y_vel(a0)			; apply gravity (falls)
		bra.s	@update
; ===========================================================================

@stop_falling:
		clr.w	ost_y_vel(a0)				; stop falling
		bra.s	@update
; ===========================================================================

@ship_recovers:
		cmpi.w	#$30,ost_bghz_wait_time(a0)		; have 48 frames passed since ship stopped falling?
		bcs.s	@ship_rises				; if not, branch
		beq.s	@stop_rising				; if exactly 48, branch
		cmpi.w	#$38,ost_bghz_wait_time(a0)		; have 56 frames passed since ship stopped rising?
		bcs.s	@update					; if not, branch
		addq.b	#2,ost_routine2(a0)			; if yes, goto BGHZ_Escape next
		bra.s	@update
; ===========================================================================

@ship_rises:
		subq.w	#8,ost_y_vel(a0)			; move ship upwards
		bra.s	@update
; ===========================================================================

@stop_rising:
		clr.w	ost_y_vel(a0)				; stop ship rising
		play.w	0, jsr, mus_GHZ				; play GHZ music

@update:
		bsr.w	BossMove				; update parent position
		bra.w	BGHZ_Update				; update actual position, check for hits
; ===========================================================================

BGHZ_Escape:
		move.w	#$400,ost_x_vel(a0)			; move ship right
		move.w	#-$40,ost_y_vel(a0)			; move ship upwards
		cmpi.w	#$2AC0,(v_boundary_right).w		; check for new boundary
		beq.s	@chkdel
		addq.w	#2,(v_boundary_right).w			; expand right edge of level boundary
		bra.s	@update
; ===========================================================================

@chkdel:
		tst.b	ost_render(a0)				; is ship on-screen?
		bpl.s	@delete					; if not, branch

@update:
		bsr.w	BossMove				; update parent position
		bra.w	BGHZ_Update				; update actual position, check for hits
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#id_ani_boss_face1,d1
		movea.l	ost_bghz_parent(a0),a1			; get address of OST of parent object
		move.b	ost_routine2(a1),d0
		subq.b	#4,d0					; is ship on BGHZ_ShipMove?
		bne.s	@chk_recover				; if not, branch
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a1)	; is ship in middle while ball spawns?
		bne.s	@chk_hit				; if not, branch
		moveq	#id_ani_boss_laugh,d1			; laugh while ball spawns

@chk_recover:
		subq.b	#6,d0					; is ship on BGHZ_Recover?
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
		subq.b	#2,d0					; is ship on BGHZ_Escape?
		bne.s	@display				; if not, branch
		move.b	#id_ani_boss_panic,ost_anim(a0)		; use sweating animation
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch

	@display:
		bra.s	BGHZ_Display
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FlameMain:	; Routine 6
		move.b	#id_ani_boss_blank,ost_anim(a0)
		movea.l	ost_bghz_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BGHZ_Escape,ost_routine2(a1)	; is ship on BGHZ_Escape?
		bne.s	@chk_moving				; if not, branch
		move.b	#id_ani_boss_bigflame,ost_anim(a0)	; use big flame animation
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch
		bra.s	@display
; ===========================================================================

@chk_moving:
		move.w	ost_x_vel(a1),d0
		beq.s	@display				; branch if ship isn't moving
		move.b	#id_ani_boss_flame1,ost_anim(a0)

@display:
		bra.s	BGHZ_Display
; ===========================================================================

@delete:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_Display:
		movea.l	ost_bghz_parent(a0),a1			; get address of OST of parent object
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	ost_status(a0),d0
		andi.b	#status_xflip+status_yflip,d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
