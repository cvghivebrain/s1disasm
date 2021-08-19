; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge (max length $10)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
Bri_Index:	index *,,2
		ptr Bri_Main
		ptr Bri_Action
		ptr Bri_Platform
		ptr Bri_Delete
		ptr Bri_Delete
		ptr Bri_Display

ost_bridge_child_list:	equ $29	; OST indices of child objects (up to 15 bytes)
ost_bridge_y_start:	equ $3C	; original y position (2 bytes)
ost_bridge_bend:	equ $3E	; number of pixels a log has been deflected
ost_bridge_current_log:	equ $3F	; log Sonic is currently standing on
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bri,ost_mappings(a0)
		move.w	#tile_Nem_Bridge+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$80,ost_actwidth(a0)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		move.b	0(a0),d4	; copy object number ($11) to d4
		lea	ost_subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1		; copy bridge length to d1
		move.b	#0,(a2)+	; clear bridge length
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3		; d3 is position of leftmost log
		subq.b	#2,d1
		bcs.s	Bri_Action	; don't make more if bridge has only 1 log

@buildloop:
		bsr.w	FindFreeObj
		bne.s	Bri_Action
		addq.b	#1,ost_subtype(a0)
		cmp.w	ost_x_pos(a0),d3 ; is this log on the left?
		bne.s	@notleft	; if not, branch

		addi.w	#$10,d3
		move.w	d2,ost_y_pos(a0)
		move.w	d2,ost_bridge_y_start(a0)
		move.w	a0,d5
		subi.w	#v_objspace&$FFFF,d5 ; get RAM address of child OST
		lsr.w	#6,d5		; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+	; save child OST indices as series of bytes
		addq.b	#1,ost_subtype(a0)

	@notleft:
		move.w	a1,d5
		subi.w	#v_objspace&$FFFF,d5 ; get RAM address of child OST
		lsr.w	#6,d5		; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+	; save child OST indices as series of bytes
		
		move.b	#id_Bri_Display,ost_routine(a1)
		move.b	d4,0(a1)	; load bridge object (d4 = $11)
		move.w	d2,ost_y_pos(a1)
		move.w	d2,ost_bridge_y_start(a1)
		move.w	d3,ost_x_pos(a1)
		move.l	#Map_Bri,ost_mappings(a1)
		move.w	#tile_Nem_Bridge+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		addi.w	#$10,d3
		dbf	d1,@buildloop ; repeat d1 times (length of bridge)

Bri_Action:	; Routine 2
		bsr.s	Bri_Solid
		tst.b	ost_bridge_bend(a0)
		beq.s	@display
		subq.b	#4,ost_bridge_bend(a0) ; move log back up
		bsr.w	Bri_Bend

	@display:
		bsr.w	DisplaySprite
		bra.w	Bri_ChkDel

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Bri_Solid:
		moveq	#0,d1
		move.b	ost_subtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_player).w,a1
		tst.w	ost_y_vel(a1)
		bmi.w	Plat_Exit
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		cmp.w	d2,d0
		bcc.w	Plat_Exit
		bra.s	Plat_NoXCheck
; End of function Bri_Solid
