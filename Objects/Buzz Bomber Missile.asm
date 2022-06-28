; ---------------------------------------------------------------------------
; Object 23 - missile that Buzz	Bomber and Newtron throws

; spawned by:
;	BuzzBomber - subtype 0
;	Newtron - subtype 1
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

		rsobj Missile,$32
ost_missile_wait_time:	rs.w 1					; $32 ; time delay
		rsset $3C
ost_missile_parent:	rs.l 1					; $3C ; address of OST of parent object
		rsobjend
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,ost_missile_wait_time(a0)		; decrement timer
		bpl.s	Msl_ChkCancel				; branch if time remains
		addq.b	#2,ost_routine(a0)			; goto Msl_Animate next
		move.l	#Map_Missile,ost_mappings(a0)
		move.w	#tile_Nem_Buzz+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_displaywidth(a0)
		andi.b	#status_xflip+status_yflip,ost_status(a0)
		tst.b	ost_subtype(a0)				; was object created by	a Newtron?
		beq.s	Msl_Animate				; if not, branch

		move.b	#id_Msl_FromNewt,ost_routine(a0)	; goto Msl_FromNewt next
		move.b	#id_col_6x6+id_col_hurt,ost_col_type(a0)
		move.b	#id_ani_buzz_missile,ost_anim(a0)
		bra.s	Msl_Animate2
; ===========================================================================

Msl_Animate:	; Routine 2
		bsr.s	Msl_ChkCancel
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite				; goto Msl_FromBuzz after animation is finished
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel	the missile
; ---------------------------------------------------------------------------

Msl_ChkCancel:
		movea.l	ost_missile_parent(a0),a1
		cmpi.b	#id_ExplosionItem,ost_id(a1)		; has Buzz Bomber been destroyed?
		beq.s	Msl_Delete				; if yes, branch
		rts

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		btst	#status_broken_bit,ost_status(a0)	; is high bit of status set? (it never is)
		bne.s	@explode				; if yes, branch
		move.b	#id_col_6x6+id_col_hurt,ost_col_type(a0)
		move.b	#id_ani_buzz_missile,ost_anim(a0)
		bsr.w	SpeedToPos
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_boundary_bottom).w,d0
		addi.w	#224,d0
		cmp.w	ost_y_pos(a0),d0			; has object moved below the level boundary?
		bcs.s	Msl_Delete				; if yes, branch
		rts	
; ===========================================================================

	@explode:
		move.b	#id_MissileDissolve,ost_id(a0)		; change object to an explosion (Obj24)
		move.b	#id_MDis_Main,ost_routine(a0)
		bra.w	MissileDissolve
; ===========================================================================

Msl_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Msl_FromNewt:	; Routine 8
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	Msl_Delete				; if not, branch
		bsr.w	SpeedToPos				; update position

Msl_Animate2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_Missile_animation:	macro

Ani_Missile:	index *
		ptr ani_buzz_flare
		ptr ani_buzz_missile
		
ani_buzz_flare:
		dc.b 7
		dc.b id_frame_buzz_flare1
		dc.b id_frame_buzz_flare2
		dc.b afRoutine
		even

ani_buzz_missile:
		dc.b 1
		dc.b id_frame_buzz_ball1
		dc.b id_frame_buzz_ball2
		dc.b afEnd
		even

		endm
