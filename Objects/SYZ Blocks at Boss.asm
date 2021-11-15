; ---------------------------------------------------------------------------
; Object 76 - blocks that Eggman picks up (SYZ)
; ---------------------------------------------------------------------------

BossBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj76_Index(pc,d0.w),d1
		jmp	Obj76_Index(pc,d1.w)
; ===========================================================================
Obj76_Index:	index *,,2
		ptr Obj76_Main
		ptr Obj76_Action
		ptr loc_19762

ost_bblock_mode:	equ $29					; same as subtype = solid; $FF = lifted; $A = breaking
ost_bblock_boss:	equ $34					; address of OST of main boss object (4 bytes)
; ===========================================================================

Obj76_Main:	; Routine 0
		moveq	#0,d4
		move.w	#$2C10,d5
		moveq	#9,d6
		lea	(a0),a1
		bra.s	Obj76_MakeBlock
; ===========================================================================

Obj76_Loop:
		jsr	(FindFreeObj).l
		bne.s	Obj76_ExitLoop

Obj76_MakeBlock:
		move.b	#id_BossBlock,(a1)
		move.l	#Map_BossBlock,ost_mappings(a1)
		move.w	#0+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$10,ost_actwidth(a1)
		move.b	#$10,ost_height(a1)
		move.b	#3,ost_priority(a1)
		move.w	d5,ost_x_pos(a1)			; set x position
		move.w	#$582,ost_y_pos(a1)
		move.w	d4,ost_subtype(a1)			; blocks have subtypes 0-9
		addi.w	#$101,d4
		addi.w	#$20,d5					; add $20 to next x-position
		addq.b	#2,ost_routine(a1)
		dbf	d6,Obj76_Loop				; repeat sequence 9 more times

Obj76_ExitLoop:
		rts	
; ===========================================================================

Obj76_Action:	; Routine 2
		move.b	ost_bblock_mode(a0),d0			; check mode
		cmp.b	ost_subtype(a0),d0
		beq.s	Obj76_Solid				; branch if same as subtype
		tst.b	d0
		bmi.s	loc_19718				; branch if $FF

loc_19712:
		bsr.w	Obj76_Break
		bra.s	Obj76_Display
; ===========================================================================

loc_19718:
		movea.l	ost_bblock_boss(a0),a1
		tst.b	ost_col_property(a1)
		beq.s	loc_19712
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		addi.w	#$2C,ost_y_pos(a0)
		cmpa.w	a0,a1
		bcs.s	Obj76_Display
		move.w	ost_y_vel(a1),d0
		ext.l	d0
		asr.l	#8,d0
		add.w	d0,ost_y_pos(a0)
		bra.s	Obj76_Display
; ===========================================================================

Obj76_Solid:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l

Obj76_Display:
		jmp	(DisplaySprite).l
; ===========================================================================

loc_19762:	; Routine 4
		tst.b	ost_render(a0)
		bpl.s	Obj76_Delete
		jsr	(ObjectFall).l
		jmp	(DisplaySprite).l
; ===========================================================================

Obj76_Delete:
		jmp	(DeleteObject).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj76_Break:
		lea	Obj76_FragSpeed(pc),a4
		lea	Obj76_FragPos(pc),a5
		moveq	#1,d4
		moveq	#3,d1
		moveq	#$38,d2
		addq.b	#2,ost_routine(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#8,ost_height(a0)
		lea	(a0),a1
		bra.s	Obj76_MakeFrag
; ===========================================================================

Obj76_LoopFrag:
		jsr	(FindNextFreeObj).l
		bne.s	loc_197D4

Obj76_MakeFrag:
		lea	(a0),a2
		lea	(a1),a3
		moveq	#3,d3

loc_197AA:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d3,loc_197AA

		move.w	(a4)+,ost_x_vel(a1)
		move.w	(a4)+,ost_y_vel(a1)
		move.w	(a5)+,d3
		add.w	d3,ost_x_pos(a1)
		move.w	(a5)+,d3
		add.w	d3,ost_y_pos(a1)
		move.b	d4,ost_frame(a1)
		addq.w	#1,d4
		dbf	d1,Obj76_LoopFrag			; repeat sequence 3 more times

loc_197D4:
		play.w	1, jmp, sfx_Smash			; play smashing sound
; End of function Obj76_Break

; ===========================================================================
Obj76_FragSpeed:dc.w -$180, -$200
		dc.w $180, -$200
		dc.w -$100, -$100
		dc.w $100, -$100
Obj76_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10
