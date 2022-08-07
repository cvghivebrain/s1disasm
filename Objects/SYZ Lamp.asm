; ---------------------------------------------------------------------------
; Object 12 - lamp (SYZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3
; ---------------------------------------------------------------------------

SpinningLight:
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
		addq.b	#2,ost_routine(a0)			; goto Light_Animate next
		move.l	#Map_Light,ost_mappings(a0)
		move.w	#0,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#6,ost_priority(a0)

Light_Animate:	; Routine 2
		subq.b	#1,ost_anim_time(a0)			; decrement animation timer
		bpl.s	.chkdel					; branch if time remains
		move.b	#7,ost_anim_time(a0)			; reset timer
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#id_frame_light_5+1,ost_frame(a0)	; is frame valid?
		bcs.s	.chkdel					; if yes, branch
		move.b	#id_frame_light_0,ost_frame(a0)		; reset to frame 0

	.chkdel:
		out_of_range	DeleteObject
		bra.w	DisplaySprite
