; ---------------------------------------------------------------------------
; Object 24 - buzz bomber missile vanishing (referenced but never used)

; spawned by:
;	Missile
; ---------------------------------------------------------------------------

MissileDissolve:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	MDis_Index(pc,d0.w),d1
		jmp	MDis_Index(pc,d1.w)
; ===========================================================================
MDis_Index:	index *,,2
		ptr MDis_Main
		ptr MDis_Animate
; ===========================================================================

MDis_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto MDis_Animate next
		move.l	#Map_MisDissolve,ost_mappings(a0)
		move.w	#$41C,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#$C,ost_displaywidth(a0)
		move.b	#9,ost_anim_time(a0)
		move.b	#0,ost_frame(a0)
		play.w	1, jsr, sfx_BuzzExplode			; play missile explosion sound

MDis_Animate:	; Routine 2
		subq.b	#1,ost_anim_time(a0)			; subtract 1 from frame duration
		bpl.s	.display
		move.b	#9,ost_anim_time(a0)			; set frame duration to 9 frames
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#4,ost_frame(a0)			; has animation completed?
		beq.w	DeleteObject				; if yes, branch

	.display:
		bra.w	DisplaySprite
