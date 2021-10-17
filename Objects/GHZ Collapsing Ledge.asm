; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

CollapseLedge:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Ledge_Index(pc,d0.w),d1
		jmp	Ledge_Index(pc,d1.w)
; ===========================================================================
Ledge_Index:	index *,,2
		ptr Ledge_Main
		ptr Ledge_Touch
		ptr Ledge_Collapse
		ptr Ledge_Display
		ptr Ledge_Delete
		ptr Ledge_WalkOff

ost_ledge_wait_time:	equ $38	; time between touching the ledge and it collapsing
ost_ledge_flag:		equ $3A	; collapse flag
; ===========================================================================

Ledge_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Ledge,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#7,ost_ledge_wait_time(a0) ; set time delay for collapse
		move.b	#$64,ost_actwidth(a0)
		move.b	ost_subtype(a0),ost_frame(a0)
		move.b	#$38,ost_height(a0)
		bset	#render_useheight_bit,ost_render(a0)

Ledge_Touch:	; Routine 2
		tst.b	ost_ledge_flag(a0) ; is ledge collapsing?
		beq.s	@slope		; if not, branch
		tst.b	ost_ledge_wait_time(a0)	; has time reached zero?
		beq.w	Ledge_Fragment	; if yes, branch
		subq.b	#1,ost_ledge_wait_time(a0) ; subtract 1 from time

	@slope:
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		bsr.w	SlopeObject
		bra.w	RememberState
; ===========================================================================

Ledge_Collapse:	; Routine 4
		tst.b	ost_ledge_wait_time(a0)
		beq.w	loc_847A
		move.b	#1,ost_ledge_flag(a0) ; set collapse flag
		subq.b	#1,ost_ledge_wait_time(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Ledge_WalkOff:	; Routine $A
		move.w	#$30,d1
		bsr.w	ExitPlatform
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		move.w	ost_x_pos(a0),d2
		bsr.w	SlopeObject_NoChk
		bra.w	RememberState
; End of function Ledge_WalkOff

; ===========================================================================

Ledge_Display:	; Routine 6
		tst.b	ost_ledge_wait_time(a0)	; has time delay reached zero?
		beq.s	Ledge_TimeZero	; if yes, branch
		tst.b	ost_ledge_flag(a0) ; is ledge collapsing?
		bne.w	loc_82D0	; if yes, branch
		subq.b	#1,ost_ledge_wait_time(a0) ; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_82D0:
		subq.b	#1,ost_ledge_wait_time(a0)
		bsr.w	Ledge_WalkOff
		lea	(v_ost_player).w,a1
		btst	#status_platform_bit,ost_status(a1)
		beq.s	loc_82FC
		tst.b	ost_ledge_wait_time(a0)
		bne.s	locret_8308
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_pushing_bit,ost_status(a1)
		move.b	#1,ost_anim_restart(a1)

loc_82FC:
		move.b	#0,ost_ledge_flag(a0)
		move.b	#id_Ledge_Display,ost_routine(a0) ; run "Ledge_Display" routine

locret_8308:
		rts	
; ===========================================================================

Ledge_TimeZero:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)
		bpl.s	Ledge_Delete
		rts	
; ===========================================================================

Ledge_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts	

; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge, part 2
; ---------------------------------------------------------------------------

include_CollapseLedge_2:	macro

Ledge_Fragment:
		move.b	#0,ost_ledge_flag(a0)

loc_847A:
		lea	(CFlo_Data1).l,a4
		moveq	#$18,d1
		addq.b	#2,ost_frame(a0)

loc_8486:
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		add.w	d0,d0
		movea.l	ost_mappings(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#render_rawmap_bit,ost_render(a0)
		move.b	0(a0),d4
		move.b	ost_render(a0),d5
		movea.l	a0,a1
		bra.s	loc_84B2
; ===========================================================================

loc_84AA:
		bsr.w	FindFreeObj
		bne.s	loc_84F2
		addq.w	#5,a3

loc_84B2:
		move.b	#id_Ledge_Display,ost_routine(a1)
		move.b	d4,0(a1)
		move.l	a3,ost_mappings(a1)
		move.b	d5,ost_render(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.b	ost_actwidth(a0),ost_actwidth(a1)
		move.b	(a4)+,ost_ledge_wait_time(a1)
		cmpa.l	a0,a1
		bhs.s	loc_84EE
		bsr.w	DisplaySprite_a1

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		bsr.w	DisplaySprite
		sfx	sfx_Collapse,1,0,0 ; play collapsing sound
		
		endm
		