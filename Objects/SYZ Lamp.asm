; ---------------------------------------------------------------------------
; Object 12 - lamp (SYZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Light_Index(pc,d0.w),d1
		jmp	Light_Index(pc,d1.w)
; ===========================================================================
Light_Index:	index *,,2
		ptr Light_Main
		ptr Light_Animate
; ===========================================================================

Light_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Light,ost_mappings(a0)
		move.w	#0,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#6,ost_priority(a0)

Light_Animate:	; Routine 2
		subq.b	#1,ost_anim_time(a0)
		bpl.s	@chkdel
		move.b	#7,ost_anim_time(a0)
		addq.b	#1,ost_frame(a0)
		cmpi.b	#6,ost_frame(a0)
		bcs.s	@chkdel
		move.b	#0,ost_frame(a0)

	@chkdel:
		out_of_range	DeleteObject
		bra.w	DisplaySprite
