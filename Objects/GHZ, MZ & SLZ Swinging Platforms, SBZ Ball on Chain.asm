; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;	    - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Solid:
		lea	(v_ost_player).w,a1
		tst.w	ost_y_vel(a1)
		bmi.w	Plat_Exit
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit
		move.w	ost_y_pos(a0),d0
		sub.w	d3,d0
		bra.w	Plat_NoXCheck_AltY
; End of function Obj15_Solid

include_SwingingPlatform_1:	macro

SwingingPlatform:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	index *,,2
		ptr Swing_Main
		ptr Swing_SetSolid
		ptr Swing_Action2
		ptr Swing_Delete
		ptr Swing_Delete
		ptr Swing_Display
		ptr Swing_Action

ost_swing_y_start:	equ $38	; original y-axis position (2 bytes)
ost_swing_x_start:	equ $3A	; original x-axis position (2 bytes)
ost_swing_radius:	equ $3C	; distance of chainlink from anchor
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Swing_GHZ,ost_mappings(a0) ; GHZ and MZ specific code
		move.w	#tile_Nem_Swing+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#8,ost_height(a0)
		move.w	ost_y_pos(a0),ost_swing_y_start(a0)
		move.w	ost_x_pos(a0),ost_swing_x_start(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	@notSLZ

		move.l	#Map_Swing_SLZ,ost_mappings(a0) ; SLZ specific code
		move.w	#tile_Nem_SlzSwing+tile_pal3,ost_tile(a0)
		move.b	#$20,ost_actwidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#id_col_32x8+id_col_hurt,ost_col_type(a0)

	@notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	@length

		move.l	#Map_BBall,ost_mappings(a0) ; SBZ specific code
		move.w	#tile_Nem_BigSpike_SBZ,ost_tile(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#$18,ost_height(a0)
		move.b	#id_col_16x16+id_col_hurt,ost_col_type(a0)
		move.b	#id_Swing_Action,ost_routine(a0) ; goto Swing_Action next

@length:
		move.b	0(a0),d4
		moveq	#0,d1
		lea	ost_subtype(a0),a2 ; move chain length to a2
		move.b	(a2),d1		; d1 = chain length
		move.w	d1,-(sp)
		andi.w	#$F,d1		; max length is 15
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3		; d3 = chain length in pixels
		addq.b	#8,d3
		move.b	d3,ost_swing_radius(a0)
		subq.b	#8,d3
		tst.b	ost_frame(a0)
		beq.s	@makechain
		addq.b	#8,d3
		subq.w	#1,d1

@makechain:
		bsr.w	FindFreeObj
		bne.s	@fail
		addq.b	#1,ost_subtype(a0)
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5		; convert child OST address to index
		move.b	d5,(a2)+	; save child OST index to byte list in parent OST
		move.b	#id_Swing_Display,ost_routine(a1) ; goto Swing_Display next
		move.b	d4,0(a1)	; load swinging	object
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		bclr	#tile_pal34_bit,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#4,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#id_frame_swing_chain,ost_frame(a1)
		move.b	d3,ost_swing_radius(a1) ; radius is smaller for chainlinks closer to top
		subi.b	#$10,d3
		bcc.s	@notanchor
		move.b	#id_frame_swing_anchor,ost_frame(a1)
		move.b	#3,ost_priority(a1)
		bset	#tile_pal34_bit,ost_tile(a1)

	@notanchor:
		dbf	d1,@makechain ; repeat d1 times (chain length)

	@fail:
		move.w	a0,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,ost_angle(a0)
		move.w	#-$200,ost_ball_angle(a0)
		move.w	(sp)+,d1
		btst	#4,d1		; is object type $1x ?
		beq.s	@not1x		; if not, branch
		move.l	#Map_GBall,ost_mappings(a0) ; use GHZ ball mappings
		move.w	#tile_Nem_Ball+tile_pal3,ost_tile(a0)
		move.b	#id_frame_ball_check1,ost_frame(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_col_20x20+id_col_hurt,ost_col_type(a0) ; make object hurt when touched

	@not1x:
		cmpi.b	#id_SBZ,(v_zone).w ; is zone SBZ?
		beq.s	Swing_Action	; if yes, branch

Swing_SetSolid:	; Routine 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		moveq	#0,d3
		move.b	ost_height(a0),d3
		bsr.w	Swing_Solid

Swing_Action:	; Routine $C
		bsr.w	Swing_Move
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel
; ===========================================================================

Swing_Action2:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		bsr.w	ExitPlatform
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	Swing_Move
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	ost_height(a0),d3
		addq.b	#1,d3
		bsr.w	MoveWithPlatform
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel

		rts
		
		endm

; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;	    - spiked ball on a chain (SBZ), part 2
; ---------------------------------------------------------------------------

include_SwingingPlatform_2:	macro

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Move:
		move.b	(v_oscillating_table+$18).w,d0
		move.w	#$80,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0
		add.w	d1,d0

	@no_xflip:
		bra.s	Swing_Move2
; End of function Swing_Move

		endm

; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;	    - spiked ball on a chain (SBZ), part 3
; ---------------------------------------------------------------------------

include_SwingingPlatform_3:	macro

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Move2:
		bsr.w	CalcSine
		move.w	ost_swing_y_start(a0),d2
		move.w	ost_swing_x_start(a0),d3
		lea	ost_subtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

	@loop:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_ost_all&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	ost_swing_radius(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a1)
		move.w	d5,ost_x_pos(a1)
		dbf	d6,@loop
		rts	
; End of function Swing_Move2

; ===========================================================================

Swing_ChkDel:
		out_of_range	Swing_DelAll,ost_swing_x_start(a0)
		rts	
; ===========================================================================

Swing_DelAll:
		moveq	#0,d2
		lea	ost_subtype(a0),a2
		move.b	(a2)+,d2

	@loop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,@loop	; repeat for length of chain
		rts	
; ===========================================================================

Swing_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Swing_Display:	; Routine $A
		bra.w	DisplaySprite

		endm
		