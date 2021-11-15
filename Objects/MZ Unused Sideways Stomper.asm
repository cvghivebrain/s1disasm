; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

SideStomp:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SStom_Index(pc,d0.w),d1
		jmp	SStom_Index(pc,d1.w)
; ===========================================================================
SStom_Index:	index *,,2
		ptr SStom_Main
		ptr SStom_Solid
		ptr SStom_Spikes
		ptr SStom_Display
		ptr SStom_Pole

		;	routine			x pos	frame
SStom_Var:	dc.b	id_SStom_Solid,  	4,	id_frame_mash_block ; main block
		dc.b	id_SStom_Spikes,	-$1C,	id_frame_mash_spikes ; spikes
		dc.b	id_SStom_Pole,		$34,	id_frame_mash_pole1 ; pole
		dc.b	id_SStom_Display,	$28,	id_frame_mash_wallbracket ; wall bracket

;word_B9BE:	; Note that this indicates three subtypes
SStom_Len:	dc.w $3800					; short
		dc.w $A000					; long
		dc.w $5000					; medium

ost_mash_x_start:	equ $30					; original x position (2 bytes)
ost_mash_length:	equ $32					; current pole length (2 bytes)
ost_mash_max_length:	equ $34					; maximum pole length (2 bytes)
ost_mash_retract_flag:	equ $36					; 1 = retract (2 bytes)
ost_mash_wait_time:	equ $38					; time to wait while fully extended (2 bytes)
ost_mash_y_start:	equ $3A					; original y position (2 bytes)
ost_mash_parent:	equ $3C					; address of OST of parent object (4 bytes)
; ===========================================================================

SStom_Main:	; Routine 0
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	SStom_Len(pc,d0.w),d2
		lea	(SStom_Var).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	@load

	@loop:
		bsr.w	FindNextFreeObj
		bne.s	@fail

	@load:
		move.b	(a2)+,ost_routine(a1)
		move.b	#id_SideStomp,0(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_pos(a1)
		move.l	#Map_SStom,ost_mappings(a1)
		move.w	#tile_Nem_MzMetal,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.w	ost_x_pos(a1),ost_mash_x_start(a1)
		move.w	ost_x_pos(a0),ost_mash_y_start(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#$20,ost_actwidth(a1)
		move.w	d2,ost_mash_max_length(a1)
		move.b	#4,ost_priority(a1)
		cmpi.b	#1,(a2)					; is subobject spikes?
		bne.s	@notspikes				; if not, branch
		move.b	#id_col_16x24+id_col_hurt,ost_col_type(a1) ; use harmful collision type

	@notspikes:
		move.b	(a2)+,ost_frame(a1)
		move.l	a0,ost_mash_parent(a1)
		dbf	d1,@loop				; repeat 3 times

		move.b	#3,ost_priority(a1)

	@fail:
		move.b	#$10,ost_actwidth(a0)

SStom_Solid:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	SStom_Move
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	SStom_ChkDel
; ===========================================================================

SStom_Pole:	; Routine 8
		movea.l	ost_mash_parent(a0),a1
		move.b	ost_mash_length(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,ost_frame(a0)

SStom_Spikes:	; Routine 4
		movea.l	ost_mash_parent(a0),a1
		moveq	#0,d0
		move.b	ost_mash_length(a1),d0
		neg.w	d0
		add.w	ost_mash_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)

SStom_Display:	; Routine 6
		bsr.w	DisplaySprite

SStom_ChkDel:
		out_of_range	DeleteObject,ost_mash_y_start(a0)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SStom_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	off_BAD6(pc,d0.w),d1
		jmp	off_BAD6(pc,d1.w)
; End of function SStom_Move

; ===========================================================================
		; This indicates only two subtypes... that do the same thing
		; Compare to SStom_Len. This breaks subtype 02
off_BAD6:	index *
		ptr loc_BADA
		ptr loc_BADA
; ===========================================================================

loc_BADA:
		tst.w	ost_mash_retract_flag(a0)		; is flag set to retract?
		beq.s	@extend					; if not, branch
		tst.w	ost_mash_wait_time(a0)			; has time delay run out?
		beq.s	@retract				; if yes, branch
		subq.w	#1,ost_mash_wait_time(a0)		; decrement timer
		bra.s	@update_pos
; ===========================================================================

@retract:
		subi.w	#$80,ost_mash_length(a0)		; retract
		bcc.s	@update_pos				; branch if at least $80 is left on length
		move.w	#0,ost_mash_length(a0)			; set to 0
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_mash_retract_flag(a0)		; reset flag to extend
		bra.s	@update_pos
; ===========================================================================

@extend:
		move.w	ost_mash_max_length(a0),d1
		cmp.w	ost_mash_length(a0),d1			; is pole fully extended?
		beq.s	@update_pos				; if yes, branch
		move.w	ost_x_vel(a0),d0
		addi.w	#$70,ost_x_vel(a0)			; increase speed
		add.w	d0,ost_mash_length(a0)
		cmp.w	ost_mash_length(a0),d1			; is pole fully extended?
		bhi.s	@update_pos				; if not, branch
		move.w	d1,ost_mash_length(a0)
		move.w	#0,ost_x_vel(a0)			; stop
		move.w	#1,ost_mash_retract_flag(a0)		; set flag to retract
		move.w	#60,ost_mash_wait_time(a0)		; set delay to 1 second

@update_pos:
		moveq	#0,d0
		move.b	ost_mash_length(a0),d0
		neg.w	d0
		add.w	ost_mash_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		rts
