; ---------------------------------------------------------------------------
; Object 74 - lava that	Eggman drops (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj74_Index(pc,d0.w),d0
		jsr	Obj74_Index(pc,d0.w)
		jmp	(DisplaySprite).l
; ===========================================================================
Obj74_Index:	index *,,2
		ptr Obj74_Main
		ptr Obj74_Action
		ptr loc_18886
		ptr Obj74_Delete3

ost_bfire_wait_time:	equ $29	; time to wait between events
ost_bfire_x_start:	equ $30	; original x position (2 bytes)
ost_bfire_x_prev:	equ $32 ; x position where most recent fire spread object was spawned (2 bytes)
ost_bfire_y_start:	equ $38	; original y position (2 bytes)
; ===========================================================================

Obj74_Main:	; Routine 0
		move.b	#8,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#5,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_bfire_y_start(a0)
		move.b	#8,ost_actwidth(a0)
		addq.b	#2,ost_routine(a0) ; goto Obj74_Action next
		tst.b	ost_subtype(a0)	; is subtype 0?
		bne.s	Obj74_First	; if not, branch
		move.b	#$8B,ost_col_type(a0)
		addq.b	#2,ost_routine(a0) ; goto loc_18886 next
		bra.w	loc_18886
; ===========================================================================

; Original fireball launched from Eggman's ship
Obj74_First:
		move.b	#30,ost_bfire_wait_time(a0) ; wait half a second before dropping
		sfx	sfx_Fireball,0,0,0 ; play lava sound

Obj74_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Obj74_Index2(pc,d0.w),d0
		jsr	Obj74_Index2(pc,d0.w)
		jsr	(SpeedToPos).l
		lea	(Ani_Fire).l,a1
		jsr	(AnimateSprite).l
		cmpi.w	#$2E8,ost_y_pos(a0)
		bhi.s	Obj74_Delete
		rts	
; ===========================================================================

Obj74_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
Obj74_Index2:	index *,,2
		ptr Obj74_Drop
		ptr Obj74_MakeFlame
		ptr Obj74_FireSpread
		ptr Obj74_FallEdge
; ===========================================================================

Obj74_Drop:
		bset	#status_yflip_bit,ost_status(a0) ; invert fireball so only tail is visible
		subq.b	#1,ost_bfire_wait_time(a0) ; decrement timer
		bpl.s	locret_18780	; branch if time remains
		move.b	#$8B,ost_col_type(a0)
		clr.b	ost_subtype(a0)
		addi.w	#$18,ost_y_vel(a0)
		bclr	#status_yflip_bit,ost_status(a0) ; yflip fireball so it's poining down
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_18780
		addq.b	#2,ost_routine2(a0) ; goto Obj74_MakeFlame when it hits the floor

locret_18780:
		rts	
; ===========================================================================

Obj74_MakeFlame:
		subq.w	#2,ost_y_pos(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#$A0,ost_x_vel(a0) ; move right
		clr.w	ost_y_vel(a0)	; stop falling
		move.w	ost_x_pos(a0),ost_bfire_x_start(a0)
		move.w	ost_y_pos(a0),ost_bfire_y_start(a0)
		move.b	#3,ost_bfire_wait_time(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_187CA
		lea	(a1),a3
		lea	(a0),a2
		moveq	#3,d0

Obj74_Loop:
		move.l	(a2)+,(a3)+	; duplicate object
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d0,Obj74_Loop

		neg.w	ost_x_vel(a1)	; make duplicate move left
		addq.b	#2,ost_routine2(a1) ; goto Obj74_FireSpread next

loc_187CA:
		addq.b	#2,ost_routine2(a0)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj74_FireSpread2:
		jsr	(FindNextFreeObj).l
		bne.s	locret_187EE
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_BossFire,(a1)
		move.w	#$67,ost_subtype(a1)

locret_187EE:
		rts	
; End of function Obj74_FireSpread2

; ===========================================================================

Obj74_FireSpread:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	loc_18826
		move.w	ost_x_pos(a0),d0
		cmpi.w	#$1940,d0
		bgt.s	loc_1882C
		move.w	ost_bfire_x_start(a0),d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		andi.w	#$10,d0
		andi.w	#$10,d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		bsr.s	Obj74_FireSpread2
		move.w	ost_x_pos(a0),ost_bfire_x_prev(a0)

loc_1881E:
		move.w	ost_x_pos(a0),ost_bfire_x_start(a0)
		rts	
; ===========================================================================

loc_18826:
		addq.b	#2,ost_routine2(a0)
		rts	
; ===========================================================================

loc_1882C:
		addq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

Obj74_FallEdge:
		bclr	#status_yflip_bit,ost_status(a0)
		addi.w	#$24,ost_y_vel(a0) ; make flame fall
		move.w	ost_x_pos(a0),d0
		sub.w	ost_bfire_x_prev(a0),d0
		bpl.s	loc_1884A
		neg.w	d0

loc_1884A:
		cmpi.w	#$12,d0
		bne.s	loc_18856
		bclr	#tile_hi_bit,ost_tile(a0)

loc_18856:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_1887E
		subq.b	#1,ost_bfire_wait_time(a0)
		beq.s	Obj74_Delete2
		clr.w	ost_y_vel(a0)
		move.w	ost_bfire_x_prev(a0),ost_x_pos(a0)
		move.w	ost_bfire_y_start(a0),ost_y_pos(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		subq.b	#2,ost_routine2(a0)

locret_1887E:
		rts	
; ===========================================================================

Obj74_Delete2:
		jmp	(DeleteObject).l
; ===========================================================================

loc_18886:	; Routine 4
		bset	#tile_hi_bit,ost_tile(a0)
		subq.b	#1,ost_bfire_wait_time(a0)
		bne.s	Obj74_Animate
		move.b	#1,ost_anim(a0)
		subq.w	#4,ost_y_pos(a0)
		clr.b	ost_col_type(a0)

Obj74_Animate:
		lea	(Ani_Fire).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

Obj74_Delete3:	; Routine 6
		jmp	(DeleteObject).l

	Obj7A_Delete:
		jmp	(DeleteObject).l
