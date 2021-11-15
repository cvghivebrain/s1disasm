; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge (max length $10)
; ---------------------------------------------------------------------------

Bridge:
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

ost_bridge_child_list:	equ $29					; OST indices of child objects (up to 15 bytes)
ost_bridge_y_start:	equ $3C					; original y position (2 bytes)
ost_bridge_bend:	equ $3E					; number of pixels a log has been deflected
ost_bridge_current_log:	equ $3F					; log Sonic is currently standing on
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
		move.b	0(a0),d4				; copy object number ($11) to d4
		lea	ost_subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1					; copy bridge length to d1
		move.b	#0,(a2)+				; clear bridge length
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3					; d3 is position of leftmost log
		subq.b	#2,d1
		bcs.s	Bri_Action				; don't make more if bridge has only 1 log

@buildloop:
		bsr.w	FindFreeObj
		bne.s	Bri_Action
		addq.b	#1,ost_subtype(a0)
		cmp.w	ost_x_pos(a0),d3			; is this log on the left?
		bne.s	@notleft				; if not, branch

		addi.w	#$10,d3
		move.w	d2,ost_y_pos(a0)
		move.w	d2,ost_bridge_y_start(a0)
		move.w	a0,d5
		subi.w	#v_ost_all&$FFFF,d5			; get RAM address of child OST
		lsr.w	#6,d5					; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+				; save child OST indices as series of bytes
		addq.b	#1,ost_subtype(a0)

	@notleft:
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5			; get RAM address of child OST
		lsr.w	#6,d5					; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+				; save child OST indices as series of bytes
		
		move.b	#id_Bri_Display,ost_routine(a1)
		move.b	d4,0(a1)				; load bridge object (d4 = $11)
		move.w	d2,ost_y_pos(a1)
		move.w	d2,ost_bridge_y_start(a1)
		move.w	d3,ost_x_pos(a1)
		move.l	#Map_Bri,ost_mappings(a1)
		move.w	#tile_Nem_Bridge+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		addi.w	#$10,d3
		dbf	d1,@buildloop				; repeat d1 times (length of bridge)

Bri_Action:	; Routine 2
		bsr.s	Bri_Solid
		tst.b	ost_bridge_bend(a0)
		beq.s	@display
		subq.b	#4,ost_bridge_bend(a0)			; move log back up
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
		lea	(v_ost_player).w,a1
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

; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge, part 2
; ---------------------------------------------------------------------------

include_Bridge_2:	macro

Bri_Platform:	; Routine 4
		bsr.s	Bri_WalkOff
		bsr.w	DisplaySprite
		bra.w	Bri_ChkDel

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Bri_WalkOff:
		moveq	#0,d1
		move.b	ost_subtype(a0),d1			; get bridge width
		lsl.w	#3,d1					; multiply by 8
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_75BE
		lsr.w	#4,d0					; d0 = relative position of log Sonic is standing on, divided by 16
		move.b	d0,ost_bridge_current_log(a0)
		move.b	ost_bridge_bend(a0),d0			; get current bend
		cmpi.b	#$40,d0
		beq.s	loc_75B6				; branch if $40
		addq.b	#4,ost_bridge_bend(a0)			; increase bend

loc_75B6:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_75BE:
		rts	
; End of function Bri_WalkOff

		endm

; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge, part 3
; ---------------------------------------------------------------------------

include_Bridge_3:	macro

Bri_MoveSonic:
		moveq	#0,d0
		move.b	ost_bridge_current_log(a0),d0		; get current log number
		move.b	ost_bridge_child_list(a0,d0.w),d0	; get OST index for that log
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0			; convert to address
		movea.l	d0,a2
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a2),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	ost_height(a1),d1
		sub.w	d1,d0
		move.w	d0,ost_y_pos(a1)			; change Sonic's position on y-axis
		rts	
; End of function Bri_MoveSonic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Bri_Bend:
		move.b	ost_bridge_bend(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	(Obj11_BendData2).l,a4
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	ost_bridge_current_log(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(Obj11_BendData).l,a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		lea	ost_bridge_child_list(a0),a2

loc_765C:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	ost_bridge_y_start(a1),d0
		move.w	d0,ost_y_pos(a1)
		dbf	d2,loc_765C
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		moveq	#0,d3
		move.b	ost_bridge_current_log(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_76CA
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_76CA

loc_76A4:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	ost_bridge_y_start(a1),d0
		move.w	d0,ost_y_pos(a1)
		dbf	d2,loc_76A4

locret_76CA:
		rts	
; End of function Bri_Bend

; ===========================================================================
; ---------------------------------------------------------------------------
; GHZ bridge-bending data
; (Defines how the bridge bends	when Sonic walks across	it)
; ---------------------------------------------------------------------------
Obj11_BendData:	incbin	"Misc Data\ghzbend1.bin"
		even
Obj11_BendData2:incbin	"Misc Data\ghzbend2.bin"
		even

; ===========================================================================

Bri_ChkDel:
		out_of_range	@deletebridge
		rts	
; ===========================================================================

@deletebridge:
		moveq	#0,d2
		lea	ost_subtype(a0),a2			; load bridge length
		move.b	(a2)+,d2				; move bridge length to	d2
		subq.b	#1,d2					; subtract 1
		bcs.s	@delparent

	@loop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		cmp.w	a0,d0
		beq.s	@skipdel
		bsr.w	DeleteChild

	@skipdel:
		dbf	d2,@loop				; repeat d2 times (bridge length)

@delparent:
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Bri_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Bri_Display:	; Routine $A
		bsr.w	DisplaySprite
		rts	
		
		endm
		
