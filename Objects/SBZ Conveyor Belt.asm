; ---------------------------------------------------------------------------
; Object 68 - conveyor belts (SBZ)

; spawned by:
;	ObjPos_SBZ2 - subtypes $20/$21/$40/$E0/$E1
; ---------------------------------------------------------------------------

Conveyor:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Conv_Index(pc,d0.w),d1
		jmp	Conv_Index(pc,d1.w)
; ===========================================================================
Conv_Index:	index offset(*),,2
		ptr Conv_Main
		ptr Conv_Action

		rsobj Conveyor,$36
ost_convey_speed:	rs.w 1					; $36 ; speed - can also be negative
ost_convey_width:	rs.b 1					; $38 ; width/2
		rsobjend
; ===========================================================================

Conv_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Conv_Action next
		move.b	#128,ost_convey_width(a0)		; set width to 128px
		move.b	ost_subtype(a0),d1			; get object type
		andi.b	#$F,d1					; read only low nybble
		beq.s	.typeis0				; if zero, branch
		move.b	#56,ost_convey_width(a0)		; set width to 56px

	.typeis0:
		move.b	ost_subtype(a0),d1			; get object type
		andi.b	#$F0,d1					; read only high nybble
		ext.w	d1
		asr.w	#4,d1					; divide by $10
		move.w	d1,ost_convey_speed(a0)			; set belt speed

Conv_Action:	; Routine 2
		bsr.s	Conv_MoveSonic				; check collision and move Sonic
		out_of_range.s	.delete
		rts	

	.delete:
		jmp	(DeleteObject).l
; ===========================================================================

Conv_MoveSonic:
		moveq	#0,d2
		move.b	ost_convey_width(a0),d2			; d2 = width/2
		move.w	d2,d3
		add.w	d3,d3					; d3 = width
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0 = distance between Sonic and conveyor centre (-ve if Sonic is left)
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	.notonconveyor				; branch if not in range
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		addi.w	#$30,d1
		cmpi.w	#$30,d1
		bcc.s	.notonconveyor				; branch if not in range on y axis
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	.notonconveyor				; if yes, branch
		move.w	ost_convey_speed(a0),d0
		add.w	d0,ost_x_pos(a1)			; apply conveyor speed/direction to Sonic

	.notonconveyor:
		rts	
