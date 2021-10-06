; ---------------------------------------------------------------------------
; Object 4B - giant ring for entry to special stage
; ---------------------------------------------------------------------------

GiantRing:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GRing_Index(pc,d0.w),d1
		jmp	GRing_Index(pc,d1.w)
; ===========================================================================
GRing_Index:	index *,,2
		ptr GRing_Main
		ptr GRing_Animate
		ptr GRing_Collect
		ptr GRing_Delete
; ===========================================================================

GRing_Main:	; Routine 0
		move.l	#Map_GRing,ost_mappings(a0)
		move.w	#$400+tile_pal2,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$40,ost_actwidth(a0)
		tst.b	ost_render(a0)
		bpl.s	GRing_Animate
		cmpi.b	#6,(v_emeralds).w ; do you have 6 emeralds?
		beq.w	GRing_Delete	; if yes, branch
		cmpi.w	#50,(v_rings).w	; do you have at least 50 rings?
		bcc.s	GRing_Okay	; if yes, branch
		rts	
; ===========================================================================

GRing_Okay:
		addq.b	#2,ost_routine(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$52,ost_col_type(a0)
		move.w	#$C40,(v_giantring_gfx_offset).w ; Signal that Art_BigRing should be loaded ($C40 is the size of Art_BigRing)

GRing_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,ost_frame(a0)
		out_of_range	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

GRing_Collect:	; Routine 4
		subq.b	#2,ost_routine(a0)
		move.b	#0,ost_col_type(a0)
		bsr.w	FindFreeObj
		bne.w	GRing_PlaySnd
		move.b	#id_RingFlash,0(a1) ; load giant ring flash object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.l	a0,ost_flash_parent(a1)
		move.w	(v_ost_player+ost_x_pos).w,d0
		cmp.w	ost_x_pos(a0),d0 ; has Sonic come from the left?
		bcs.s	GRing_PlaySnd	; if yes, branch
		bset	#render_xflip_bit,ost_render(a1) ; reverse flash object

GRing_PlaySnd:
		sfx	sfx_GiantRing,0,0,0 ; play giant ring sound
		bra.s	GRing_Animate
; ===========================================================================

GRing_Delete:	; Routine 6
		bra.w	DeleteObject
