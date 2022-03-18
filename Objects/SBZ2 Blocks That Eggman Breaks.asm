; ---------------------------------------------------------------------------
; Object 83 - blocks that disintegrate when Eggman presses a button (SBZ2)

; spawned by:
;	DynamicLevelEvents - routine 0
;	FalseFloor - routine 8
; ---------------------------------------------------------------------------

FFloor_Delete:
		jmp	(DeleteObject).l

include_FalseFloor_1:	macro

FalseFloor:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FFloor_Index(pc,d0.w),d1
		jmp	FFloor_Index(pc,d1.w)
; ===========================================================================
FFloor_Index:	index *,,2
		ptr FFloor_Main
		ptr FFloor_ChkBreak
		ptr FFloor_Break
		ptr FFloor_AllGone
		ptr FFloor_Block
		ptr FFloor_Frag

ost_ffloor_children:	equ $30					; addresses of OSTs of child objects (2 bytes * 8)
; ===========================================================================

FFloor_Main:	; Routine 0
		move.w	#$2080,ost_x_pos(a0)
		move.w	#$5D0,ost_y_pos(a0)
		move.b	#$80,ost_displaywidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		moveq	#0,d4
		move.w	#$2010,d5				; initial x position
		moveq	#8-1,d6					; 8 blocks
		lea	ost_ffloor_children(a0),a2

@loop:
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found
		move.w	a1,(a2)+				; save child OST address to list in parent OST
		move.b	#id_FalseFloor,(a1)			; load block object
		move.l	#Map_FFloor,ost_mappings(a1)
		move.w	#tile_Nem_SbzBlock_SBZ2+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$10,ost_displaywidth(a1)
		move.b	#$10,ost_height(a1)
		move.b	#3,ost_priority(a1)
		move.w	d5,ost_x_pos(a1)			; set x position
		move.w	#$5D0,ost_y_pos(a1)
		addi.w	#$20,d5					; add $20 for next x position
		move.b	#id_FFloor_Block,ost_routine(a1)	; goto FFloor_Block next
		dbf	d6,@loop				; repeat sequence 7 more times

	@fail:
		addq.b	#2,ost_routine(a0)			; goto FFloor_ChkBreak next
		rts	
; ===========================================================================

FFloor_ChkBreak:; Routine 2
		cmpi.w	#$474F,ost_subtype(a0)			; is object set to disintegrate? (by Eggman object)
		bne.s	FFloor_Solid				; if not, branch
		clr.b	ost_frame(a0)
		addq.b	#2,ost_routine(a0)			; goto FFloor_Break next

FFloor_Solid:
		moveq	#0,d0
		move.b	ost_frame(a0),d0			; get current frame (starts as 0, increments as blocks break)
		neg.b	d0					; make negative
		ext.w	d0
		addq.w	#8,d0					; d0 = 0 to 8
		asl.w	#4,d0					; multiply by 16
		move.w	#$2100,d4				; initial x position
		sub.w	d0,d4					; move right as the block shrinks
		move.b	d0,ost_displaywidth(a0)
		move.w	d4,ost_x_pos(a0)			; set x position
		moveq	#$B,d1
		add.w	d0,d1					; set width
		moveq	#$10,d2					; height
		moveq	#$11,d3
		jmp	(SolidObject).l
; ===========================================================================

FFloor_Break:	; Routine 4
		subi.b	#$E,ost_anim_time(a0)			; decrement timer
		bcc.s	@stay_solid				; branch if time remains (never happens)
		moveq	#-1,d0
		move.b	ost_frame(a0),d0			; get current frame (starts as 0, increments as blocks break)
		ext.w	d0
		add.w	d0,d0
		move.w	ost_ffloor_children(a0,d0.w),d0		; get address of OST for next child block
		movea.l	d0,a1
		move.w	#$474F,ost_subtype(a1)			; set that block to break
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#8,ost_frame(a0)			; have all blocks broken? (final frame)
		beq.s	FFloor_AllGone				; if yes, branch

	@stay_solid:
		bra.s	FFloor_Solid
; ===========================================================================

FFloor_AllGone:	; Routine 6
		bclr	#status_platform_bit,ost_status(a0)	; clear platform flags
		bclr	#status_platform_bit,(v_ost_player+ost_status).w
		bra.w	FFloor_Delete				; delete object
; ===========================================================================

FFloor_Block:	; Routine 8
		cmpi.w	#$474F,ost_subtype(a0)			; is block set to disintegrate?
		beq.s	FFloor_BlockBreak			; if yes, branch
		jmp	(DisplaySprite).l
; ===========================================================================

FFloor_Frag:	; Routine $A
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	FFloor_Delete				; if not, branch
		jsr	(ObjectFall).l				; apply gravity & update position
		jmp	(DisplaySprite).l
; ===========================================================================

FFloor_BlockBreak:
		lea	FFloor_FragSpeed(pc),a4			; y speed data
		lea	FFloor_FragPos(pc),a5			; x/y position data
		moveq	#id_frame_ffloor_topleft,d4		; frame id of first fragment (1)
		moveq	#4-1,d1					; number of fragments
		moveq	#$38,d2
		addq.b	#2,ost_routine(a0)			; goto FFloor_Frag next
		move.b	#8,ost_displaywidth(a0)
		move.b	#8,ost_height(a0)
		lea	(a0),a1					; replace block with first fragment
		bra.s	@first_frag
; ===========================================================================

	@loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	@fail					; branch if not found

@first_frag:
		lea	(a0),a2					; a2 = parent block OST
		lea	(a1),a3					; a3 = fragment OST
		moveq	#(sizeof_ost/16)-1,d3

	@copy_ost:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d3,@copy_ost				; copy contents of parent block OST to fragment OST

		move.w	(a4)+,ost_y_vel(a1)			; get initial y speed from FFloor_FragSpeed
		move.w	(a5)+,d3
		add.w	d3,ost_x_pos(a1)			; get position from FFloor_FragPos
		move.w	(a5)+,d3
		add.w	d3,ost_y_pos(a1)
		move.b	d4,ost_frame(a1)			; set frame
		addq.w	#1,d4					; next frame
		dbf	d1,@loop				; repeat sequence 3 more times

	@fail:
		play.w	1, jsr, sfx_Smash			; play smashing sound
		jmp	(DisplaySprite).l
; ===========================================================================
FFloor_FragSpeed:
		dc.w $80
		dc.w 0
		dc.w $120
		dc.w $C0

FFloor_FragPos:	dc.w -8, -8
		dc.w $10, 0
		dc.w 0,	$10
		dc.w $10, $10

		endm
		
