; ---------------------------------------------------------------------------
; Object 53 - collapsing floors	(MZ, SLZ, SBZ)

; spawned by:
;	ObjPos_MZ1 - subtype 1
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes 1/$81
;	ObjPos_SBZ1, ObjPos_SBZ2 - subtype 1
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
		ptr CFlo_WaitFall
		ptr CFlo_Delete
		ptr CFlo_WalkOff

ost_cfloor_wait_time:	equ $38					; time delay for collapsing floor
ost_cfloor_flag:	equ $3A					; 1 = Sonic has touched the floor
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto CFlo_Touch next
		move.l	#Map_CFlo,ost_mappings(a0)
		move.w	#$2B8+tile_pal3,ost_tile(a0)
		cmpi.b	#id_SLZ,(v_zone).w			; check if level is SLZ
		bne.s	@notSLZ

		move.w	#tile_Nem_SlzBlock+tile_pal3,ost_tile(a0) ; SLZ specific code
		addq.b	#id_frame_cfloor_slz,ost_frame(a0)

	@notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ
		bne.s	@notSBZ
		move.w	#tile_Nem_SbzFloor+tile_pal3,ost_tile(a0) ; SBZ specific code

	@notSBZ:
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#7,ost_cfloor_wait_time(a0)
		move.b	#$44,ost_displaywidth(a0)

CFlo_Touch:	; Routine 2
		tst.b	ost_cfloor_flag(a0)			; has Sonic touched the object?
		beq.s	@solid					; if not, branch
		tst.b	ost_cfloor_wait_time(a0)		; has time delay reached zero?
		beq.w	CFlo_Fragment				; if yes, branch
		subq.b	#1,ost_cfloor_wait_time(a0)		; subtract 1 from time

	@solid:
		move.w	#$20,d1					; width
		bsr.w	DetectPlatform				; set platform status bit & goto CFlo_Collapse next if platform is touched
		tst.b	ost_subtype(a0)				; is subtype over $80?
		bpl.s	@remstate				; if not, branch
		btst	#status_platform_bit,ost_status(a1)
		beq.s	@remstate
		bclr	#render_xflip_bit,ost_render(a0)
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@remstate				; branch if Sonic is left of the platform
		bset	#render_xflip_bit,ost_render(a0)

	@remstate:
		bra.w	DespawnObject
; ===========================================================================

CFlo_Collapse:	; Routine 4
		tst.b	ost_cfloor_wait_time(a0)		; has time delay reached zero?
		beq.w	CFlo_Collapse_Now			; if yes, branch
		move.b	#1,ost_cfloor_flag(a0)			; set object as "touched"
		subq.b	#1,ost_cfloor_wait_time(a0)		; decrement timer


CFlo_WalkOff:	; Routine $A
		move.w	#$20,d1
		bsr.w	ExitPlatform				; goto CFlo_Touch next if Sonic leaves platform
		move.w	ost_x_pos(a0),d2
		bsr.w	MoveWithPlatform2
		bra.w	DespawnObject
; End of function CFlo_WalkOff

; ===========================================================================

CFlo_WaitFall:	; Routine 6
		tst.b	ost_cfloor_wait_time(a0)		; has time delay reached zero?
		beq.s	CFlo_FallNow				; if yes, branch
		tst.b	ost_cfloor_flag(a0)			; has Sonic touched the object?
		bne.w	@has_touched				; if yes, branch
		subq.b	#1,ost_cfloor_wait_time(a0)		; decrement timer
		bra.w	DisplaySprite
; ===========================================================================

@has_touched:
		subq.b	#1,ost_cfloor_wait_time(a0)		; decrement timer
		bsr.w	CFlo_WalkOff				; check if Sonic leaves platform
		lea	(v_ost_player).w,a1
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on platform?
		beq.s	@skip_platform				; if not, branch
		tst.b	ost_cfloor_wait_time(a0)
		bne.s	@skip_platform2				; branch if time delay > 0
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_pushing_bit,ost_status(a1)
		move.b	#id_Run,ost_anim_restart(a1)

	@skip_platform:
		move.b	#0,ost_cfloor_flag(a0)
		move.b	#id_CFlo_WaitFall,ost_routine(a0)	; goto CFlo_WaitFall next

	@skip_platform2:
		rts	
; ===========================================================================

CFlo_FallNow:
		bsr.w	ObjectFall				; apply gravity & update position
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	CFlo_Delete				; if not, branch
		rts	
; ===========================================================================

CFlo_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts	
; ===========================================================================

CFlo_Fragment:
		move.b	#0,ost_cfloor_flag(a0)

CFlo_Collapse_Now:
		lea	(CFlo_FragTiming_0).l,a4
		btst	#0,ost_subtype(a0)			; is subtype = 0?
		beq.s	@type_0					; if yes, branch
		lea	(CFlo_FragTiming_1).l,a4

	@type_0:
		moveq	#8-1,d1
		addq.b	#1,ost_frame(a0)			; use broken frame which comprises 8 sprites
		bra.s	FragmentObject				; split into 8 fragments, goto CFlo_WaitFall next
								; see GHZ Collapsing Ledge.asm

include_CollapseFloor_fragtiming:	macro

CFlo_FragTiming_0:
		dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2		; unused
CFlo_FragTiming_1:
		dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2
		even

		endm
