; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtype 0/1
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
		ptr Ledge_WaitFall
		ptr Ledge_Delete
		ptr Ledge_WalkOff

ost_ledge_wait_time:	equ $38					; time between touching the ledge and it collapsing
ost_ledge_flag:		equ $3A					; flag set when ledge is stood on
; ===========================================================================

Ledge_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Ledge_Touch next
		move.l	#Map_Ledge,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#7,ost_ledge_wait_time(a0)		; set time delay for collapse
		move.b	#$64,ost_actwidth(a0)
		move.b	ost_subtype(a0),ost_frame(a0)
		move.b	#$38,ost_height(a0)
		bset	#render_useheight_bit,ost_render(a0)

Ledge_Touch:	; Routine 2
		tst.b	ost_ledge_flag(a0)			; has ledge been stood on?
		beq.s	@slope					; if not, branch
		tst.b	ost_ledge_wait_time(a0)			; has time reached zero?
		beq.w	Ledge_Fragment				; if yes, branch
		subq.b	#1,ost_ledge_wait_time(a0)		; decrement timer

	@slope:
		move.w	#$30,d1					; width
		lea	(Ledge_SlopeData).l,a2			; heightmap
		bsr.w	SlopeObject				; detect collision with Sonic, update relevant flags & goto Ledge_Collapse next
		bra.w	RememberState
; ===========================================================================

Ledge_Collapse:	; Routine 4
		tst.b	ost_ledge_wait_time(a0)
		beq.w	Ledge_Fragment_2
		move.b	#1,ost_ledge_flag(a0)			; set flag
		subq.b	#1,ost_ledge_wait_time(a0)

; ---------------------------------------------------------------------------
; Subroutine to update Sonic's position and status on ledge
; ---------------------------------------------------------------------------

Ledge_WalkOff:	; Routine $A
		move.w	#$30,d1					; width
		bsr.w	ExitPlatform				; allow Sonic to walk off the ledge
		move.w	#$30,d1					; width
		lea	(Ledge_SlopeData).l,a2			; heightmap
		move.w	ost_x_pos(a0),d2
		bsr.w	SlopeObject_NoChk			; update Sonic's y position
		bra.w	RememberState
; End of function Ledge_WalkOff

; ===========================================================================

Ledge_WaitFall:	; Routine 6
		tst.b	ost_ledge_wait_time(a0)			; has time delay reached zero?
		beq.s	Ledge_FallNow				; if yes, branch
		tst.b	ost_ledge_flag(a0)			; has ledge been stood on?
		bne.w	@stood_on				; if yes, branch
		subq.b	#1,ost_ledge_wait_time(a0)		; decrement timer
		bra.w	DisplaySprite
; ===========================================================================

@stood_on:
		subq.b	#1,ost_ledge_wait_time(a0)		; decrement timer
		bsr.w	Ledge_WalkOff				; update Sonic's y position & platform status
		lea	(v_ost_player).w,a1
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on ledge?
		beq.s	@platform_clear				; if not, branch
		tst.b	ost_ledge_wait_time(a0)			; has time reached 0?
		bne.s	@exit					; if not, branch
		bclr	#status_platform_bit,ost_status(a1)	; clear platform status
		bclr	#status_pushing_bit,ost_status(a1)
		move.b	#id_Run,ost_anim_restart(a1)

	@platform_clear:
		move.b	#0,ost_ledge_flag(a0)
		move.b	#id_Ledge_WaitFall,ost_routine(a0)	; goto Ledge_WaitFall next

	@exit:
		rts	
; ===========================================================================

Ledge_FallNow:
		bsr.w	ObjectFall				; apply gravity and update position
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	Ledge_Delete				; if not, branch
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

Ledge_Fragment_2:
		lea	(Ledge_FragTiming).l,a4			; fragment timing data
		moveq	#$19-1,d1				; number of fragments, minus 1
		addq.b	#2,ost_frame(a0)			; use frame consisting of smaller pieces

; ---------------------------------------------------------------------------
; Subroutine to turn an object into fragments

; input:
;	a4 = address of fragment timing values
;	d1 = number of fragments, minus 1
; ---------------------------------------------------------------------------

FragmentObject:
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		add.w	d0,d0
		movea.l	ost_mappings(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3					; jump to raw sprite data
		bset	#render_rawmap_bit,ost_render(a0)	; use raw mappings
		move.b	ost_id(a0),d4
		move.b	ost_render(a0),d5
		movea.l	a0,a1					; replace ledge object with fragment
		bra.s	@skip_findost
; ===========================================================================

@loop:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@display				; branch if not found
		addq.w	#5,a3					; next sprite piece

@skip_findost:
		move.b	#id_Ledge_WaitFall,ost_routine(a1)	; id_CFlo_WaitFall in CollapseFloor object
		move.b	d4,ost_id(a1)
		move.l	a3,ost_mappings(a1)
		move.b	d5,ost_render(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.b	ost_actwidth(a0),ost_actwidth(a1)
		move.b	(a4)+,ost_ledge_wait_time(a1)		; each fragment has different timing
		cmpa.l	a0,a1					; is this fragment the first? (i.e. parent object)
		bhs.s	@firstfrag				; if yes, branch
		bsr.w	DisplaySprite_a1

	@firstfrag:
		dbf	d1,@loop				; repeat for all fragments

	@display:
		bsr.w	DisplaySprite
		play.w	1, jmp, sfx_Collapse			; play collapsing sound

Ledge_FragTiming:
		dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C
		even
		
		endm
		
