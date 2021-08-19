
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
		move.b	ost_subtype(a0),d1 ; get bridge width
		lsl.w	#3,d1		; multiply by 8
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_75BE
		lsr.w	#4,d0		; d0 = relative position of log Sonic is standing on, divided by 16
		move.b	d0,ost_bridge_current_log(a0)
		move.b	ost_bridge_bend(a0),d0 ; get current bend
		cmpi.b	#$40,d0
		beq.s	loc_75B6	; branch if $40
		addq.b	#4,ost_bridge_bend(a0) ; increase bend

loc_75B6:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_75BE:
		rts	
; End of function Bri_WalkOff
