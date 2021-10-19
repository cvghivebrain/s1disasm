; ---------------------------------------------------------------------------
; Object 53 - collapsing floors	(MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

CollapseFloor:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	CFlo_Index(pc,d0.w),d1
		jmp	CFlo_Index(pc,d1.w)
; ===========================================================================
CFlo_Index:	index *,,2
		ptr CFlo_Main
		ptr CFlo_Touch
		ptr CFlo_Collapse
		ptr CFlo_Display
		ptr CFlo_Delete
		ptr CFlo_WalkOff

ost_cfloor_wait_time:	equ $38	; time delay for collapsing floor
ost_cfloor_flag:	equ $3A	; 1 = Sonic has touched the floor
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_CFlo,ost_mappings(a0)
		move.w	#$2B8+tile_pal3,ost_tile(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	@notSLZ

		move.w	#tile_Nem_SlzBlock+tile_pal3,ost_tile(a0) ; SLZ specific code
		addq.b	#id_frame_cfloor_slz,ost_frame(a0)

	@notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	@notSBZ
		move.w	#tile_Nem_SbzFloor+tile_pal3,ost_tile(a0) ; SBZ specific code

	@notSBZ:
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#7,ost_cfloor_wait_time(a0)
		move.b	#$44,ost_actwidth(a0)

CFlo_Touch:	; Routine 2
		tst.b	ost_cfloor_flag(a0) ; has Sonic touched the object?
		beq.s	@solid		; if not, branch
		tst.b	ost_cfloor_wait_time(a0) ; has time delay reached zero?
		beq.w	CFlo_Fragment	; if yes, branch
		subq.b	#1,ost_cfloor_wait_time(a0) ; subtract 1 from time

	@solid:
		move.w	#$20,d1		; width
		bsr.w	DetectPlatform	; set platform status bit & goto CFlo_Collapse next if platform is touched
		tst.b	ost_subtype(a0)	; is subtype over $80?
		bpl.s	@remstate	; if not, branch
		btst	#status_platform_bit,ost_status(a1)
		beq.s	@remstate
		bclr	#render_xflip_bit,ost_render(a0)
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@remstate	; branch if Sonic is left of the platform
		bset	#render_xflip_bit,ost_render(a0)

	@remstate:
		bra.w	RememberState
; ===========================================================================

CFlo_Collapse:	; Routine 4
		tst.b	ost_cfloor_wait_time(a0) ; has time delay reached zero?
		beq.w	CFlo_Collapse_Now	; if yes, branch
		move.b	#1,ost_cfloor_flag(a0) ; set object as "touched"
		subq.b	#1,ost_cfloor_wait_time(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CFlo_WalkOff:	; Routine $A
		move.w	#$20,d1
		bsr.w	ExitPlatform
		move.w	ost_x_pos(a0),d2
		bsr.w	MoveWithPlatform2
		bra.w	RememberState
; End of function CFlo_WalkOff

; ===========================================================================

CFlo_Display:	; Routine 6
		tst.b	ost_cfloor_wait_time(a0) ; has time delay reached zero?
		beq.s	CFlo_TimeZero	; if yes, branch
		tst.b	ost_cfloor_flag(a0) ; has Sonic touched the object?
		bne.w	loc_8402	; if yes, branch
		subq.b	#1,ost_cfloor_wait_time(a0); subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_8402:
		subq.b	#1,ost_cfloor_wait_time(a0)
		bsr.w	CFlo_WalkOff
		lea	(v_ost_player).w,a1
		btst	#status_platform_bit,ost_status(a1)
		beq.s	loc_842E
		tst.b	ost_cfloor_wait_time(a0)
		bne.s	locret_843A
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_pushing_bit,ost_status(a1)
		move.b	#1,ost_anim_restart(a1)

loc_842E:
		move.b	#0,ost_cfloor_flag(a0)
		move.b	#id_CFlo_Display,ost_routine(a0) ; run "CFlo_Display" routine

locret_843A:
		rts	
; ===========================================================================

CFlo_TimeZero:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)
		bpl.s	CFlo_Delete
		rts	
; ===========================================================================

CFlo_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts	
; ===========================================================================

CFlo_Fragment:
		move.b	#0,ost_cfloor_flag(a0)

CFlo_Collapse_Now:
		lea	(CFlo_Data2).l,a4
		btst	#0,ost_subtype(a0)
		beq.s	loc_846C
		lea	(CFlo_Data3).l,a4

loc_846C:
		moveq	#7,d1
		addq.b	#1,ost_frame(a0)
		bra.s	loc_8486	; jump to address in GHZ Collapsing Ledge.asm

