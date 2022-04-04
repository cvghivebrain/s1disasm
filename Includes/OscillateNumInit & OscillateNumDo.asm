; ---------------------------------------------------------------------------
; Subroutine to initialise oscillating numbers

;	uses d1, a1, a2
; ---------------------------------------------------------------------------

OscillateNumInit:
		lea	(v_oscillating_direction).w,a1
		lea	(@baselines).l,a2
		moveq	#((@end-@baselines)/2)-1,d1

	@loop:
		move.w	(a2)+,(a1)+				; copy baseline values to RAM
		dbf	d1,@loop
		rts	


; ===========================================================================
@baselines:	dc.w %0000000001111100				; direction bitfield (0 = up; 1 = down)

		; start value, start rate
		dc.w $80, 0					; 0 - LZ water height, MZ grass platforms
		dc.w $80, 0					; 4 - MZ grass platforms, SBZ saws
		dc.w $80, 0					; 8 - MZ magma animation, MZ grass platforms, SYZ/SLZ floating blocks
		dc.w $80, 0					; $C - MZ grass platforms, MZ/LZ moving blocks, GHZ/SYZ/SLZ platforms, SBZ saws, SYZ large spikeball
		dc.w $80, 0					; $10 - MZ glass block, MZ purple block
		dc.w $80, 0					; $14 - MZ purple block
		dc.w $80, 0					; $18 - GHZ/MZ/SLZ/SBZ swinging platforms, GHZ/SYZ/SLZ platforms
		dc.w $80, 0					; $1C - MZ/LZ moving blocks, SYZ/SLZ floating blocks
		dc.w $80, 0					; $20 - SLZ circling platforms
		dc.w $50F0, $11E				; $24 - SLZ circling platforms
		dc.w $2080, $B4					; $28 - SYZ/SLZ floating blocks
		dc.w $3080, $10E				; $2C - SYZ/SLZ floating blocks
		dc.w $5080, $1C2				; $30 - SYZ/SLZ floating blocks
		dc.w $7080, $276				; $34 - SYZ/SLZ floating blocks
		dc.w $80, 0					; $38 - unused
		dc.w $80, 0					; $3C - unused
	@end:
		even

; ---------------------------------------------------------------------------
; Subroutine to run oscillating numbers

;	uses d0, d1, d2, d3, d4, a1, a2
; ---------------------------------------------------------------------------

OscillateNumDo:
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; has Sonic just died?
		bcc.s	@end					; if yes, branch
		lea	(v_oscillating_direction).w,a1
		lea	(@settings).l,a2
		move.w	(a1)+,d3				; get oscillation direction bitfield
		moveq	#$F,d1					; bit to test/store direction

@loop:
		move.w	(a2)+,d2				; get frequency
		move.w	(a2)+,d4				; get amplitude
		btst	d1,d3					; check oscillation direction
		bne.s	@down					; branch if 1

	@up:
		move.w	2(a1),d0				; get current rate
		add.w	d2,d0					; add frequency
		move.w	d0,2(a1)				; update rate
		add.w	d0,0(a1)				; add rate to value
		cmp.b	0(a1),d4
		bhi.s	@next					; branch if value is below middle value
		bset	d1,d3					; set direction to down
		bra.s	@next

	@down:
		move.w	2(a1),d0				; get current rate
		sub.w	d2,d0					; subtract frequency
		move.w	d0,2(a1)				; update rate
		add.w	d0,0(a1)				; add rate to value
		cmp.b	0(a1),d4
		bls.s	@next					; branch if value is above middle value
		bclr	d1,d3					; set direction to up

	@next:
		addq.w	#4,a1					; next value/rate
		dbf	d1,@loop				; repeat for all bits in direction bitfield
		move.w	d3,(v_oscillating_direction).w		; update direction bitfield

@end:
		rts

; ===========================================================================
@settings:	; frequency, middle value
		dc.w 2,	$10					; 0 - LZ water height, MZ grass platforms
		dc.w 2,	$18					; 4 - MZ grass platforms, SBZ saws
		dc.w 2,	$20					; 8 - MZ magma animation, MZ grass platforms, SYZ/SLZ floating blocks
		dc.w 2,	$30					; $C - MZ grass platforms, MZ/LZ moving blocks, GHZ/SYZ/SLZ platforms, SBZ saws, SYZ large spikeball
		dc.w 4,	$20					; $10 - MZ glass block, MZ purple block
		dc.w 8,	8					; $14 - MZ purple block
		dc.w 8,	$40					; $18 - GHZ/MZ/SLZ/SBZ swinging platforms, GHZ/SYZ/SLZ platforms
		dc.w 4,	$40					; $1C - MZ/LZ moving blocks, SYZ/SLZ floating blocks
		dc.w 2,	$50					; $20 - SLZ circling platforms
		dc.w 2,	$50					; $24 - SLZ circling platforms
		dc.w 2,	$20					; $28 - SYZ/SLZ floating blocks
		dc.w 3,	$30					; $2C - SYZ/SLZ floating blocks
		dc.w 5,	$50					; $30 - SYZ/SLZ floating blocks
		dc.w 7,	$70					; $34 - SYZ/SLZ floating blocks
		dc.w 2,	$10					; $38 - unused
		dc.w 2,	$10					; $3C - unused
		even
