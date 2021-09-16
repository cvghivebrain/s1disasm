; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz	Bomber throws
; ---------------------------------------------------------------------------

Missile:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Msl_Index(pc,d0.w),d1
		jmp	Msl_Index(pc,d1.w)
; ===========================================================================
Msl_Index:	index *,,2
		ptr Msl_Main
		ptr Msl_Animate
		ptr Msl_FromBuzz
		ptr Msl_Delete
		ptr Msl_FromNewt

ost_missile_wait_time:	equ $32	; time delay (2 bytes)
ost_missile_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,ost_missile_wait_time(a0)
		bpl.s	Msl_ChkCancel
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Missile,ost_mappings(a0)
		move.w	#tile_Nem_Buzz+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		andi.b	#status_xflip+status_yflip,ost_status(a0)
		tst.b	ost_subtype(a0)	; was object created by	a Newtron?
		beq.s	Msl_Animate	; if not, branch

		move.b	#id_Msl_FromNewt,ost_routine(a0) ; run "Msl_FromNewt" routine
		move.b	#$87,ost_col_type(a0)
		move.b	#id_ani_buzz_missile,ost_anim(a0)
		bra.s	Msl_Animate2
; ===========================================================================

Msl_Animate:	; Routine 2
		bsr.s	Msl_ChkCancel
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel	the missile
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Msl_ChkCancel:
		movea.l	ost_missile_parent(a0),a1
		cmpi.b	#id_ExplosionItem,0(a1) ; has Buzz Bomber been destroyed?
		beq.s	Msl_Delete	; if yes, branch
		rts	
; End of function Msl_ChkCancel

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		btst	#status_onscreen_bit,ost_status(a0)
		bne.s	@explode
		move.b	#$87,ost_col_type(a0)
		move.b	#id_ani_buzz_missile,ost_anim(a0)
		bsr.w	SpeedToPos
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0 ; has object moved below the level boundary?
		bcs.s	Msl_Delete	; if yes, branch
		rts	
; ===========================================================================

	@explode:
		move.b	#id_MissileDissolve,0(a0) ; change object to an explosion (Obj24)
		move.b	#0,ost_routine(a0)
		bra.w	MissileDissolve
; ===========================================================================

Msl_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Msl_FromNewt:	; Routine 8
		tst.b	ost_render(a0)
		bpl.s	Msl_Delete
		bsr.w	SpeedToPos

Msl_Animate2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts	
