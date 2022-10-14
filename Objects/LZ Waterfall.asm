; ---------------------------------------------------------------------------
; Object 65 - waterfalls (LZ)

; spawned by:
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtypes 0/2/3/4/5/6/7/8/9/$49/$A9
; ---------------------------------------------------------------------------

Waterfall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	WFall_Index(pc,d0.w),d1
		jmp	WFall_Index(pc,d1.w)
; ===========================================================================
WFall_Index:	index offset(*),,2
		ptr WFall_Main
		ptr WFall_Animate
		ptr WFall_ChkDel
		ptr WFall_OnWater
		ptr WFall_Priority
; ===========================================================================

WFall_Main:	; Routine 0
		addq.b	#4,ost_routine(a0)			; goto WFall_ChkDel next
		move.l	#Map_WFall,ost_mappings(a0)
		move.w	#tile_Nem_Splash+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$18,ost_displaywidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	ost_subtype(a0),d0			; get object type
		bpl.s	.under80				; branch if $00-$7F
		bset	#tile_hi_bit,ost_tile(a0)

	.under80:
		andi.b	#$F,d0					; read only the	low nybble
		move.b	d0,ost_frame(a0)			; set frame number
		cmpi.b	#type_wfall_splash,d0			; is object type $x9 (splash)?
		bne.s	WFall_ChkDel				; if not, branch

		clr.b	ost_priority(a0)			; object is in front of Sonic
		subq.b	#2,ost_routine(a0)			; goto WFall_Animate next
		btst	#6,ost_subtype(a0)			; is object type $49 ?
		beq.s	.not49					; if not, branch

		move.b	#id_WFall_OnWater,ost_routine(a0)	; goto WFall_OnWater next

	.not49:
		btst	#5,ost_subtype(a0)			; is object type $A9 ?
		beq.s	WFall_Animate				; if not, branch
		move.b	#id_WFall_Priority,ost_routine(a0)	; goto WFall_Priority next

WFall_Animate:	; Routine 2
		lea	(Ani_WFall).l,a1
		jsr	(AnimateSprite).l

WFall_ChkDel:	; Routine 4
		bra.w	DespawnObject
; ===========================================================================

WFall_OnWater:	; Routine 6
		move.w	(v_water_height_actual).w,d0
		subi.w	#$10,d0
		move.w	d0,ost_y_pos(a0)			; match object position to water height
		bra.s	WFall_Animate
; ===========================================================================

WFall_Priority:	; Routine 8
		bclr	#tile_hi_bit,ost_tile(a0)
		cmpi.b	#7,(v_level_layout+$106).w		; has level been modified by pressing a button? (LZ3 only)
		bne.s	.animate				; if not, branch
		bset	#tile_hi_bit,ost_tile(a0)		; high priority sprite

	.animate:
		bra.s	WFall_Animate

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_WFall:	index offset(*)
		ptr ani_wfall_splash
		
ani_wfall_splash:
		dc.b 5
		dc.b id_frame_wfall_splash1
		dc.b id_frame_wfall_splash2
		dc.b id_frame_wfall_splash3
		dc.b afEnd
		even
