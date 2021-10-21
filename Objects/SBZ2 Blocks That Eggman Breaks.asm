; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate when Eggman presses a switch (SBZ2)
; ---------------------------------------------------------------------------

FalseFloor:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FFloor_Index(pc,d0.w),d1
		jmp	FFloor_Index(pc,d1.w)
; ===========================================================================
FFloor_Index:	index *,,2
		ptr FFloor_Main
		ptr FFloor_ChkBreak
		ptr loc_19C36
		ptr loc_19C62
		ptr loc_19C72
		ptr loc_19C80

ost_ffloor_children:	equ $30	; addresses of OSTs of child objects (2 bytes * 8)
; ===========================================================================

FFloor_Main:	; Routine 0
		move.w	#$2080,ost_x_pos(a0)
		move.w	#$5D0,ost_y_pos(a0)
		move.b	#$80,ost_actwidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		moveq	#0,d4
		move.w	#$2010,d5	; initial x position
		moveq	#7,d6
		lea	ost_ffloor_children(a0),a2

FFloor_MakeBlock:
		jsr	(FindFreeObj).l
		bne.s	FFloor_ExitMake
		move.w	a1,(a2)+
		move.b	#id_FalseFloor,(a1) ; load block object
		move.l	#Map_FFloor,ost_mappings(a1)
		move.w	#$518+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$10,ost_actwidth(a1)
		move.b	#$10,ost_height(a1)
		move.b	#3,ost_priority(a1)
		move.w	d5,ost_x_pos(a1) ; set x position
		move.w	#$5D0,ost_y_pos(a1)
		addi.w	#$20,d5		; add $20 for next x position
		move.b	#8,ost_routine(a1)
		dbf	d6,FFloor_MakeBlock ; repeat sequence 7 more times

FFloor_ExitMake:
		addq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

FFloor_ChkBreak:; Routine 2
		cmpi.w	#$474F,ost_subtype(a0) ; is object set to disintegrate?
		bne.s	FFloor_Solid	; if not, branch
		clr.b	ost_frame(a0)
		addq.b	#2,ost_routine(a0) ; next subroutine

FFloor_Solid:
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		neg.b	d0
		ext.w	d0
		addq.w	#8,d0
		asl.w	#4,d0
		move.w	#$2100,d4
		sub.w	d0,d4
		move.b	d0,ost_actwidth(a0)
		move.w	d4,ost_x_pos(a0)
		moveq	#$B,d1
		add.w	d0,d1
		moveq	#$10,d2
		moveq	#$11,d3
		jmp	(SolidObject).l
; ===========================================================================

loc_19C36:	; Routine 4
		subi.b	#$E,ost_anim_time(a0)
		bcc.s	FFloor_Solid2
		moveq	#-1,d0
		move.b	ost_frame(a0),d0
		ext.w	d0
		add.w	d0,d0
		move.w	ost_ffloor_children(a0,d0.w),d0
		movea.l	d0,a1
		move.w	#$474F,ost_subtype(a1)
		addq.b	#1,ost_frame(a0)
		cmpi.b	#8,ost_frame(a0)
		beq.s	loc_19C62

FFloor_Solid2:
		bra.s	FFloor_Solid
; ===========================================================================

loc_19C62:	; Routine 6
		bclr	#status_platform_bit,ost_status(a0)
		bclr	#status_platform_bit,(v_ost_player+ost_status).w
		bra.w	loc_1982C
; ===========================================================================

loc_19C72:	; Routine 8
		cmpi.w	#$474F,ost_subtype(a0) ; is object set to disintegrate?
		beq.s	FFloor_Break	; if yes, branch
		jmp	(DisplaySprite).l
; ===========================================================================

loc_19C80:	; Routine $A
		tst.b	ost_render(a0)
		bpl.w	loc_1982C
		jsr	(ObjectFall).l
		jmp	(DisplaySprite).l
; ===========================================================================

FFloor_Break:
		lea	FFloor_FragSpeed(pc),a4
		lea	FFloor_FragPos(pc),a5
		moveq	#1,d4
		moveq	#3,d1
		moveq	#$38,d2
		addq.b	#2,ost_routine(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#8,ost_height(a0)
		lea	(a0),a1
		bra.s	FFloor_MakeFrag
; ===========================================================================

FFloor_LoopFrag:
		jsr	(FindNextFreeObj).l
		bne.s	FFloor_BreakSnd

FFloor_MakeFrag:
		lea	(a0),a2
		lea	(a1),a3
		moveq	#3,d3

loc_19CC4:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d3,loc_19CC4

		move.w	(a4)+,ost_y_vel(a1)
		move.w	(a5)+,d3
		add.w	d3,ost_x_pos(a1)
		move.w	(a5)+,d3
		add.w	d3,ost_y_pos(a1)
		move.b	d4,ost_frame(a1)
		addq.w	#1,d4
		dbf	d1,FFloor_LoopFrag ; repeat sequence 3 more times

FFloor_BreakSnd:
		sfx	sfx_Smash,0,0,0 ; play smashing sound
		jmp	(DisplaySprite).l
; ===========================================================================
FFloor_FragSpeed:dc.w $80, 0
		dc.w $120, $C0
FFloor_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10
