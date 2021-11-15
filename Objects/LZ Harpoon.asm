; ---------------------------------------------------------------------------
; Object 16 - harpoon (LZ)
; ---------------------------------------------------------------------------

Harpoon:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Harp_Index(pc,d0.w),d1
		jmp	Harp_Index(pc,d1.w)
; ===========================================================================
Harp_Index:	index *,,2
		ptr Harp_Main
		ptr Harp_Move
		ptr Harp_Wait

ost_harp_time:	equ $30						; time between stabbing/retracting
; ===========================================================================

Harp_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Harp,ost_mappings(a0)
		move.w	#tile_Nem_Harpoon,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	ost_subtype(a0),ost_anim(a0)		; get type (vert/horiz)
		move.b	#$14,ost_actwidth(a0)
		move.w	#60,ost_harp_time(a0)			; set time to 1 second

Harp_Move:	; Routine 2
		lea	(Ani_Harp).l,a1
		bsr.w	AnimateSprite
		moveq	#0,d0
		move.b	ost_frame(a0),d0			; get frame number
		move.b	@types(pc,d0.w),ost_col_type(a0)	; get collision type
		bra.w	RememberState

	@types:
		dc.b id_col_8x4+id_col_hurt, id_col_24x4+id_col_hurt, id_col_40x4+id_col_hurt, id_col_4x8+id_col_hurt, id_col_4x24+id_col_hurt, id_col_4x40+id_col_hurt
		even

Harp_Wait:	; Routine 4
		subq.w	#1,ost_harp_time(a0)			; decrement timer
		bpl.s	@chkdel					; branch if time remains
		move.w	#60,ost_harp_time(a0)			; reset timer
		subq.b	#2,ost_routine(a0)			; run "Harp_Move" subroutine
		bchg	#0,ost_anim(a0)				; reverse animation

	@chkdel:
		bra.w	RememberState
