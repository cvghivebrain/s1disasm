; ---------------------------------------------------------------------------
; Object 7A - Eggman (SLZ)

; spawned by:
;	DynamicLevelEvents - routine 0
;	BossStarLight - routines 2/4/6
; ---------------------------------------------------------------------------

BSLZ_Delete:
		jmp	(DeleteObject).l


BossStarLight:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BSLZ_Index(pc,d0.w),d1
		jmp	BSLZ_Index(pc,d1.w)
; ===========================================================================
BSLZ_Index:	index *,,2
		ptr BSLZ_Main
		ptr BSLZ_ShipMain
		ptr BSLZ_FaceMain
		ptr BSLZ_FlameMain
		ptr BSLZ_TubeMain

BSLZ_ObjData:	dc.b id_BSLZ_ShipMain, id_ani_boss_ship, 4	; routine number, animation, priority
		dc.b id_BSLZ_FaceMain, id_ani_boss_face1, 4
		dc.b id_BSLZ_FlameMain, id_ani_boss_blank, 4
		dc.b id_BSLZ_TubeMain, 0, 3
; ===========================================================================

BSLZ_Main:
		move.w	#$2188,ost_x_pos(a0)
		move.w	#$228,ost_y_pos(a0)
		move.w	ost_x_pos(a0),ost_boss_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_boss_parent_y_pos(a0)
		move.b	#id_col_24x24,ost_col_type(a0)
		move.b	#hitcount_slz,ost_col_property(a0)	; set number of hits to 8
		lea	BSLZ_ObjData(pc),a2			; get data for routine number, animation & priority
		movea.l	a0,a1					; replace current object with 1st in list
		moveq	#3,d1					; 3 additional objects
		bra.s	.load_boss
; ===========================================================================

.loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossStarLight,ost_id(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

.load_boss:
		bclr	#status_xflip_bit,ost_status(a0)
		clr.b	ost_routine2(a1)
		move.b	(a2)+,ost_routine(a1)			; goto BSLZ_ShipMain/BSLZ_FaceMain/BSLZ_FlameMain/BSLZ_TubeMain next
		move.b	(a2)+,ost_anim(a1)
		move.b	(a2)+,ost_priority(a1)
		move.l	#Map_Bosses,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_displaywidth(a1)
		move.l	a0,ost_boss_parent(a1)			; save address of OST of parent
		dbf	d1,.loop				; repeat sequence 3 more times

	.fail:
		lea	(v_ost_all+sizeof_ost).w,a1		; start at first OST slot after Sonic
		lea	ost_boss_seesaw(a0),a2			; where to save seesaw OST addresses
		moveq	#id_Seesaw,d0
		moveq	#$3E,d1					; check first $40 OSTs (there are $80 total)

	.find_loop:
		cmp.b	(a1),d0					; is object a seesaw?
		bne.s	.notgood				; if not, branch
		tst.b	ost_subtype(a1)				; is seesaw empty?
		beq.s	.notgood				; if not, branch
		move.w	a1,(a2)+				; set pointer to seesaw OST

	.notgood:
		adda.w	#sizeof_ost,a1				; next OST slot
		dbf	d1,.find_loop				; repeat for remaining OST slots

BSLZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	BSLZ_ShipIndex(pc,d0.w),d0
		jsr	BSLZ_ShipIndex(pc,d0.w)
		lea	(Ani_Bosses).l,a1
		jsr	(AnimateSprite).l
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
BSLZ_ShipIndex:	index *,,2
		ptr BSLZ_ShipStart
		ptr BSLZ_ShipMove
		ptr BSLZ_MakeBall
		ptr BSLZ_Explode
		ptr BSLZ_Recover
		ptr BSLZ_Escape
; ===========================================================================

BSLZ_ShipStart:
		move.w	#-$100,ost_x_vel(a0)			; move ship left
		cmpi.w	#$2120,ost_boss_parent_x_pos(a0)	; has ship reached right side of screen?
		bcc.s	BSLZ_Update				; if not, branch
		addq.b	#2,ost_routine2(a0)			; goto BSLZ_ShipMove next

BSLZ_Update:
		bsr.w	BossMove				; update parent position
		move.b	ost_boss_wobble(a0),d0			; get wobble byte
		addq.b	#2,ost_boss_wobble(a0)			; increment wobble (wraps to 0 after $FE)
		jsr	(CalcSine).l				; convert to sine
		asr.w	#6,d0					; divide by 64
		add.w	ost_boss_parent_y_pos(a0),d0		; add y pos
		move.w	d0,ost_y_pos(a0)			; update actual y pos
		move.w	ost_boss_parent_x_pos(a0),ost_x_pos(a0)	; update actual x pos
		bra.s	BSLZ_Update_SkipPos			; check for hit
; ===========================================================================

BSLZ_Update_SkipWobble:
		bsr.w	BossMove				; update parent position
		move.w	ost_boss_parent_y_pos(a0),ost_y_pos(a0)	; update actual position
		move.w	ost_boss_parent_x_pos(a0),ost_x_pos(a0)

BSLZ_Update_SkipPos:
		cmpi.b	#id_BSLZ_Explode,ost_routine2(a0)
		bcc.s	.exit
		tst.b	ost_status(a0)				; has boss been beaten?
		bmi.s	.beaten					; if yes, branch
		tst.b	ost_col_type(a0)			; is ship collision clear?
		bne.s	.exit					; if not, branch
		tst.b	ost_boss_flash_num(a0)			; is ship flashing?
		bne.s	.flash					; if yes, branch
		move.b	#$20,ost_boss_flash_num(a0)		; set ship to flash 32 times
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

	.flash:
		lea	(v_pal_dry_line2+2).w,a1		; load 2nd palette, 2nd entry
		moveq	#0,d0					; move 0 (black) to d0
		tst.w	(a1)					; is colour white?
		bne.s	.is_white				; if yes, branch
		move.w	#boss_flash_color,d0			; move $EEE (white) to d0

	.is_white:
		move.w	d0,(a1)					; load colour stored in	d0
		subq.b	#1,ost_boss_flash_num(a0)		; decrement flash counter
		bne.s	.exit					; branch if not 0
		move.b	#id_col_24x24,ost_col_type(a0)		; enable boss collision again

	.exit:
		rts	
; ===========================================================================

.beaten:
		moveq	#100,d0
		bsr.w	AddPoints				; give Sonic 1000 points
		move.b	#6,ost_routine2(a0)
		move.b	#120,ost_boss_wait_time(a0)		; set timer to 2 seconds
		clr.w	ost_x_vel(a0)
		rts	
; ===========================================================================

BSLZ_ShipMove:
		move.w	ost_boss_parent_x_pos(a0),d0
		move.w	#$200,ost_x_vel(a0)			; move ship right
		btst	#status_xflip_bit,ost_status(a0)	; is ship facing left?
		bne.s	.face_right				; if not, branch
		neg.w	ost_x_vel(a0)				; move ship left
		cmpi.w	#$2008,d0				; has ship reached left side of screen?
		bgt.s	.find_seesaw				; if not, branch
		bra.s	.chg_dir
; ===========================================================================

.face_right:
		cmpi.w	#$2138,d0				; has ship reached right side of screen?
		blt.s	.find_seesaw				; if not, branch

.chg_dir:
		bchg	#status_xflip_bit,ost_status(a0)	; change direction

.find_seesaw:
		move.w	ost_x_pos(a0),d0
		moveq	#-1,d1
		moveq	#3-1,d2					; number of seesaws
		lea	ost_boss_seesaw(a0),a2			; get OST addresses for the 3 seesaws
		moveq	#$28,d4					; dist from centre to right side of seesaw
		tst.w	ost_x_vel(a0)
		bpl.s	.moving_right				; branch if ship is moving right
		neg.w	d4					; dist from centre to left side of seesaw

	.moving_right:
	.loop:
		move.w	(a2)+,d1
		movea.l	d1,a3					; a3 = address of seesaw OST
		btst	#status_platform_bit,ost_status(a3)	; is Sonic on the seesaw?
		bne.s	.sonic_on_seesaw			; if yes, branch
		move.w	ost_x_pos(a3),d3
		add.w	d4,d3					; d3 = x position of left/right side of seesaw
		sub.w	d0,d3
		beq.s	.seesaw_found				; branch if ship is directly over side of seesaw

	.sonic_on_seesaw:
		dbf	d2,.loop

		move.b	d2,ost_subtype(a0)			; set subtype to -1 if no seesaw is found
		bra.w	BSLZ_Update				; update position, check for hit
; ===========================================================================

.seesaw_found:
		move.b	d2,ost_subtype(a0)			; number of seesaw the ship is above (0/1/2)
		addq.b	#2,ost_routine2(a0)			; goto BSLZ_MakeBall next
		move.b	#$28,ost_boss_wait_time(a0)		; set timer to 40 frames
		bra.w	BSLZ_Update				; update position, check for hit
; ===========================================================================

BSLZ_MakeBall:
		cmpi.b	#$28,ost_boss_wait_time(a0)		; has timer started counting down yet?
		bne.s	.wait_next				; if yes, branch
		moveq	#-1,d0
		move.b	ost_subtype(a0),d0			; get number of seesaw the ship is above (0/1/2)
		ext.w	d0
		bmi.s	.exit					; branch if no seesaw found (-1)
		subq.w	#2,d0
		neg.w	d0					; switch between 0 and 2
		add.w	d0,d0
		lea	ost_boss_seesaw(a0),a1
		move.w	(a1,d0.w),d0
		movea.l	d0,a2					; get address of OST of seesaw
		lea	(v_ost_all+sizeof_ost).w,a1		; first OST slot excluding Sonic
		moveq	#$3E,d1					; check first $40 OSTs (there are $80 total)

	.loop:
		cmp.l	ost_bspike_seesaw(a1),d0		; does seesaw already have a spikeball?
		beq.s	.exit					; if yes, branch
		adda.w	#sizeof_ost,a1				; next OST slot
		dbf	d1,.loop				; repeat for all OST slots

		pushr	a0					; save current OST address to stack
		lea	(a2),a0					; pretend the seesaw is current object
		jsr	(FindNextFreeObj).l			; find free OST slot after this one
		popr	a0					; restore current OST
		bne.s	.exit					; branch if free OST slot not found

		move.b	#id_BossSpikeball,(a1)			; load spiked ball object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		addi.w	#$20,ost_y_pos(a1)
		move.b	ost_status(a2),ost_status(a1)
		move.l	a2,ost_bspike_seesaw(a1)		; save seesaw OST address to spikeball

	.wait_next:
		subq.b	#1,ost_boss_wait_time(a0)		; decrement timer
		beq.s	.exit					; branch if 0
		bra.w	BSLZ_Update_SkipPos			; check for hit
; ===========================================================================

.exit:
		subq.b	#2,ost_routine2(a0)			; goto BSLZ_ShipMove next
		bra.w	BSLZ_Update				; update position, check for hit
; ===========================================================================

BSLZ_Explode:
		subq.b	#1,ost_boss_wait_time(a0)		; decrement timer
		bmi.s	.stop_exploding				; branch if below 0
		bra.w	BossExplode				; load explosion object
; ===========================================================================

.stop_exploding:
		addq.b	#2,ost_routine2(a0)			; goto BSLZ_Recover next
		clr.w	ost_y_vel(a0)				; stop moving
		bset	#status_xflip_bit,ost_status(a0)	; ship face right
		bclr	#status_broken_bit,ost_status(a0)
		clr.w	ost_x_vel(a0)
		move.b	#-$18,ost_boss_wait_time(a0)		; set timer (counts up)
		tst.b	(v_boss_status).w
		bne.s	.exit
		move.b	#1,(v_boss_status).w			; set boss beaten flag

	.exit:
		bra.w	BSLZ_Update_SkipPos
; ===========================================================================

BSLZ_Recover:
		addq.b	#1,ost_boss_wait_time(a0)		; increment timer
		beq.s	.stop_falling				; branch if 0
		bpl.s	.ship_recovers				; branch if 1 or more
		addi.w	#$18,ost_y_vel(a0)			; apply gravity (falls)
		bra.s	.update
; ===========================================================================

.stop_falling:
		clr.w	ost_y_vel(a0)				; stop falling
		bra.s	.update
; ===========================================================================

.ship_recovers:
		cmpi.b	#$20,ost_boss_wait_time(a0)		; have 32 frames passed since ship stopped falling?
		bcs.s	.ship_rises				; if not, branch
		beq.s	.ship_rising				; if exactly 32, branch
		cmpi.b	#$2A,ost_boss_wait_time(a0)		; have 42 frames passed since ship stopped rising?
		bcs.s	.update					; if not, branch
		addq.b	#2,ost_routine2(a0)			; goto BSLZ_Escape next
		bra.s	.update
; ===========================================================================

.ship_rises:
		subq.w	#8,ost_y_vel(a0)			; move ship upwards
		bra.s	.update
; ===========================================================================

.ship_rising:
		clr.w	ost_y_vel(a0)
		play.w	0, jsr, mus_SLZ				; play SLZ music

.update:
		bra.w	BSLZ_Update_SkipWobble			; update position
; ===========================================================================

BSLZ_Escape:
		move.w	#$400,ost_x_vel(a0)			; move ship right
		move.w	#-$40,ost_y_vel(a0)			; move ship upwards
		cmpi.w	#$2160,(v_boundary_right).w		; check for new boundary
		bcc.s	.chkdel
		addq.w	#2,(v_boundary_right).w			; expand right edge of level boundary
		bra.s	.update
; ===========================================================================

.chkdel:
		tst.b	ost_render(a0)				; is ship on-screen?
		bpl.w	BSLZ_Delete				; if not, branch

.update:
		bsr.w	BossMove				; update parent position
		bra.w	BSLZ_Update				; update position
; ===========================================================================

BSLZ_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#id_ani_boss_face1,d1
		movea.l	ost_boss_parent(a0),a1			; get address of OST of parent object
		move.b	ost_routine2(a1),d0
		cmpi.b	#id_BSLZ_Explode,d0
		bmi.s	.chk_hit
		moveq	#id_ani_boss_defeat,d1
		bra.s	.update
; ===========================================================================

.chk_hit:
		tst.b	ost_col_type(a1)			; is boss collision on?
		bne.s	.chk_sonic_hurt				; if yes, branch
		moveq	#id_ani_boss_hit,d1			; use hit animation
		bra.s	.update
; ===========================================================================

.chk_sonic_hurt:
		cmpi.b	#id_Sonic_Hurt,(v_ost_player+ost_routine).w ; is Sonic hurt or dead?
		bcs.s	.update					; if not, branch
		moveq	#id_ani_boss_laugh,d1

.update:
		move.b	d1,ost_anim(a0)				; set animation
		cmpi.b	#id_BSLZ_Escape,d0			; is ship on BSLZ_Escape?
		bne.s	.display				; if not, branch
		move.b	#id_ani_boss_panic,ost_anim(a0)		; use sweating animation
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BSLZ_Delete				; if not, branch

	.display:
		bra.s	BSLZ_FaceFlame_Display
; ===========================================================================

BSLZ_FlameMain:; Routine 6
		move.b	#id_ani_boss_flame1,ost_anim(a0)
		movea.l	ost_boss_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BSLZ_Escape,ost_routine2(a1)	; is ship on BSLZ_Escape?
		bne.s	.chk_flame				; if not, branch
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BSLZ_Delete				; if not, branch
		move.b	#id_ani_boss_bigflame,ost_anim(a0)	; use big flame animation
		bra.s	BSLZ_FaceFlame_Display
; ===========================================================================

.chk_flame:
		cmpi.b	#id_BSLZ_Recover,ost_routine2(a1)
		bgt.s	BSLZ_FaceFlame_Display			; branch if on BSLZ_Escape
		cmpi.b	#id_BSLZ_MakeBall,ost_routine2(a1)
		blt.s	BSLZ_FaceFlame_Display			; branch if on BSLZ_ShipStart/BSLZ_ShipMove
		move.b	#id_ani_boss_blank,ost_anim(a0)		; hide flame

BSLZ_FaceFlame_Display:
		lea	(Ani_Bosses).l,a1
		jsr	(AnimateSprite).l

BSLZ_Tube_Display:
		movea.l	ost_boss_parent(a0),a1			; get address of OST of parent object
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================

BSLZ_TubeMain:	; Routine 8
		movea.l	ost_boss_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BSLZ_Escape,ost_routine2(a1)	; is ship on BSLZ_Escape?
		bne.s	.display				; if not, branch
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BSLZ_Delete				; if not, branch

	.display:
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#tile_Nem_Weapons+tile_pal2,ost_tile(a0)
		move.b	#id_frame_boss_widepipe,ost_frame(a0)
		bra.s	BSLZ_Tube_Display
