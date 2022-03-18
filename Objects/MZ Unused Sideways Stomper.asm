; ---------------------------------------------------------------------------
; Object 45 - unused sideway-facing spiked stomper (MZ)

; spawned by:
;	SideStomp
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

SStom_Len:	dc.w $3800					; 0 - short
		dc.w $A000					; 1 - long
		dc.w $5000					; 2 - medium (non-functional; see SStom_Move)

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
		move.b	ost_subtype(a0),d0			; get subtype
		add.w	d0,d0
		move.w	SStom_Len(pc,d0.w),d2			; get pole length based on subtype
		lea	(SStom_Var).l,a2
		movea.l	a0,a1					; 1st object is main metal block
		moveq	#3,d1					; 3 additional objects
		bra.s	@load

	@loop:
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found

	@load:
		move.b	(a2)+,ost_routine(a1)			; goto SStom_Solid/SStom_Spikes/SStom_Pole/SStom_Display next
		move.b	#id_SideStomp,ost_id(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	(a2)+,d0				; get relative x pos
		ext.w	d0
		add.w	ost_x_pos(a0),d0			; add to actual x pos
		move.w	d0,ost_x_pos(a1)
		move.l	#Map_SStom,ost_mappings(a1)
		move.w	#tile_Nem_MzMetal,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.w	ost_x_pos(a1),ost_mash_x_start(a1)
		move.w	ost_x_pos(a0),ost_mash_y_start(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#$20,ost_displaywidth(a1)
		move.w	d2,ost_mash_max_length(a1)		; set max pole length from subtype
		move.b	#4,ost_priority(a1)
		cmpi.b	#id_frame_mash_spikes,(a2)		; is subobject spikes?
		bne.s	@notspikes				; if not, branch
		move.b	#id_col_16x24+id_col_hurt,ost_col_type(a1) ; use harmful collision type

	@notspikes:
		move.b	(a2)+,ost_frame(a1)
		move.l	a0,ost_mash_parent(a1)			; save address of OST of parent
		dbf	d1,@loop				; repeat 3 times

		move.b	#3,ost_priority(a1)

	@fail:
		move.b	#$10,ost_displaywidth(a0)

SStom_Solid:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	SStom_Move				; update position of main block
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	SStom_ChkDel
; ===========================================================================

SStom_Pole:	; Routine 8
		movea.l	ost_mash_parent(a0),a1			; get parent OST
		move.b	ost_mash_length(a1),d0			; get current pole length
		addi.b	#$10,d0
		lsr.b	#5,d0					; divide by $20
		addq.b	#id_frame_mash_pole1,d0			; first pole frame (3)
		move.b	d0,ost_frame(a0)			; udpate frame

SStom_Spikes:	; Routine 4
		movea.l	ost_mash_parent(a0),a1			; get parent OST
		moveq	#0,d0
		move.b	ost_mash_length(a1),d0			; get current pole length
		neg.w	d0					; make it -ve
		add.w	ost_mash_x_start(a0),d0			; add to initial x pos
		move.w	d0,ost_x_pos(a0)			; update x pos

SStom_Display:	; Routine 6
		bsr.w	DisplaySprite

SStom_ChkDel:
		out_of_range	DeleteObject,ost_mash_y_start(a0)
		rts	

; ---------------------------------------------------------------------------
; Subroutine to move the main metal block
; ---------------------------------------------------------------------------

SStom_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	SStom_Move_Index(pc,d0.w),d1
		jmp	SStom_Move_Index(pc,d1.w)
; End of function SStom_Move

; ===========================================================================
SStom_Move_Index:
		index *
		ptr SStom_Move_0				; 0
		ptr SStom_Move_0				; 1 - same as 0
		;ptr SStom_Move_0				; 2 - missing
; ===========================================================================

SStom_Move_0:
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
