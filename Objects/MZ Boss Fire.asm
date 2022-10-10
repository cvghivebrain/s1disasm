; ---------------------------------------------------------------------------
; Object 74 - fireball that Eggman drops (MZ)

; spawned by:
;	BossMarble - subtype 1
;	BossFire - subtype 0
; ---------------------------------------------------------------------------

BossFire:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BFire_Index(pc,d0.w),d0
		jsr	BFire_Index(pc,d0.w)
		jmp	(DisplaySprite).l
; ===========================================================================
BFire_Index:	index offset(*),,2
		ptr BFire_Main
		ptr BFire_Action
		ptr BFire_TempFire
		ptr BFire_TempFireDel

		rsobj BossFire
ost_bfire_wait_time:	rs.b 1					; $29 ; time to wait between events
		rsset $30
ost_bfire_x_start:	rs.w 1					; $30 ; original x position
ost_bfire_x_prev:	rs.w 1					; $32 ; x position where most recent fire spread object was spawned
		rsset $38
ost_bfire_y_start:	rs.w 1					; $38 ; original y position
		rsobjend
; ===========================================================================

BFire_Main:	; Routine 0
		move.b	#8,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#5,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_bfire_y_start(a0)
		move.b	#8,ost_displaywidth(a0)
		addq.b	#2,ost_routine(a0)			; goto BFire_Action next
		tst.b	ost_subtype(a0)				; is subtype 0?
		bne.s	BFire_First				; if not, branch
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		addq.b	#2,ost_routine(a0)			; goto BFire_TempFire next
		bra.w	BFire_TempFire
; ===========================================================================

; Original fireball dropped by Eggman's ship
BFire_First:
		move.b	#30,ost_bfire_wait_time(a0)		; wait half a second before dropping
		play.w	1, jsr, sfx_FireBall			; play fireball sound

BFire_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	BFire_Index2(pc,d0.w),d0
		jsr	BFire_Index2(pc,d0.w)
		jsr	(SpeedToPos).l				; update position
		lea	(Ani_Fire).l,a1
		jsr	(AnimateSprite).l
		cmpi.w	#$2E8,ost_y_pos(a0)			; has fireball fallen into the lava in the middle?
		bhi.s	BFire_Delete				; if yes, branch
		rts	
; ===========================================================================

BFire_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
BFire_Index2:	index offset(*),,2
		ptr BFire_Drop
		ptr BFire_Duplicate
		ptr BFire_FireSpread
		ptr BFire_FallEdge
; ===========================================================================

BFire_Drop:
		bset	#status_yflip_bit,ost_status(a0)	; invert fireball so only tail is visible
		subq.b	#1,ost_bfire_wait_time(a0)		; decrement timer
		bpl.s	.exit					; branch if time remains
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		clr.b	ost_subtype(a0)
		addi.w	#$18,ost_y_vel(a0)			; apply gravity
		bclr	#status_yflip_bit,ost_status(a0)	; yflip fireball so it's pointing down
		bsr.w	FindFloorObj
		tst.w	d1					; has fireball hit the floor?
		bpl.s	.exit					; if not, branch
		addq.b	#2,ost_routine2(a0)			; goto BFire_Duplicate when it hits the floor

	.exit:
		rts	
; ===========================================================================

BFire_Duplicate:
		subq.w	#2,ost_y_pos(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#$A0,ost_x_vel(a0)			; move right
		clr.w	ost_y_vel(a0)				; stop falling
		move.w	ost_x_pos(a0),ost_bfire_x_start(a0)	; save position where the fireball landed
		move.w	ost_y_pos(a0),ost_bfire_y_start(a0)
		move.b	#3,ost_bfire_wait_time(a0)
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	.fail					; branch if not found
		lea	(a1),a3					; a3 = address of OST of new object
		lea	(a0),a2					; a2 = address of OST of original object
		moveq	#(sizeof_ost/16)-1,d0

	.loop:
		move.l	(a2)+,(a3)+				; duplicate object
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d0,.loop

		neg.w	ost_x_vel(a1)				; make duplicate move left
		addq.b	#2,ost_routine2(a1)			; goto BFire_FireSpread next

	.fail:
		addq.b	#2,ost_routine2(a0)			; goto BFire_FireSpread next
		rts	

; ---------------------------------------------------------------------------
; Subroutine to spawn another fireball in the current one's position
; ---------------------------------------------------------------------------

BFire_SpawnFire:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	.fail					; branch if not found
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_BossFire,(a1)			; load fireball object
		move.w	#$67,ost_subtype(a1)			; subtype 0, timer 1.7 seconds

	.fail:
		rts

; ===========================================================================

BFire_FireSpread:
		bsr.w	FindFloorObj
		tst.w	d1					; is fireball touching the floor?
		bpl.s	.not_on_floor				; if not, branch
		move.w	ost_x_pos(a0),d0
		cmpi.w	#$1940,d0				; is fireball outside the right edge of the screen?
		bgt.s	.outside_right				; if yes, branch
		move.w	ost_bfire_x_start(a0),d1
		cmp.w	d0,d1
		beq.s	.skip_fire
		andi.w	#$10,d0
		andi.w	#$10,d1
		cmp.w	d0,d1
		beq.s	.skip_fire
		bsr.s	BFire_SpawnFire				; load another fireball object
		move.w	ost_x_pos(a0),ost_bfire_x_prev(a0)

	.skip_fire:
		move.w	ost_x_pos(a0),ost_bfire_x_start(a0)
		rts	
; ===========================================================================

.not_on_floor:
		addq.b	#2,ost_routine2(a0)			; goto BFire_FallEdge next
		rts	
; ===========================================================================

.outside_right:
		addq.b	#2,ost_routine(a0)			; goto BFire_TempFire next
		rts	
; ===========================================================================

BFire_FallEdge:
		bclr	#status_yflip_bit,ost_status(a0)
		addi.w	#$24,ost_y_vel(a0)			; make flame fall
		move.w	ost_x_pos(a0),d0
		sub.w	ost_bfire_x_prev(a0),d0			; d0 = distance from last new fireball object spawn
		bpl.s	.is_pos
		neg.w	d0					; make d0 positive

	.is_pos:
		cmpi.w	#$12,d0
		bne.s	.not_18px				; branch if not 18px
		bclr	#tile_hi_bit,ost_tile(a0)		; clear priority bit so it's drawn behind the lava

	.not_18px:
		bsr.w	FindFloorObj
		tst.w	d1					; has fireball hit the floor?
		bpl.s	.not_on_floor				; if not, branch
		subq.b	#1,ost_bfire_wait_time(a0)		; decrement timer (starts at 3)
		beq.s	.delete					; branch if time remains
		clr.w	ost_y_vel(a0)				; stop falling
		move.w	ost_bfire_x_prev(a0),ost_x_pos(a0)	; return to previous position
		move.w	ost_bfire_y_start(a0),ost_y_pos(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		subq.b	#2,ost_routine2(a0)			; goto BFire_FireSpread next

	.not_on_floor:
		rts	
; ===========================================================================

.delete:
		jmp	(DeleteObject).l
; ===========================================================================

BFire_TempFire:	; Routine 4
		bset	#tile_hi_bit,ost_tile(a0)
		subq.b	#1,ost_bfire_wait_time(a0)		; decrement timer
		bne.s	.wait					; branch if time remains
		move.b	#id_ani_fire_vertcollide,ost_anim(a0)	; use animation for vertical fireball disappearing
		subq.w	#4,ost_y_pos(a0)
		clr.b	ost_col_type(a0)			; make fireball harmless

	.wait:
		lea	(Ani_Fire).l,a1
		jmp	(AnimateSprite).l			; animate and goto BFire_TempFireDel if 2nd animation ran
; ===========================================================================

BFire_TempFireDel:
		; Routine 6
		jmp	(DeleteObject).l
