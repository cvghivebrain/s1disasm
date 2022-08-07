; ---------------------------------------------------------------------------
; Subroutine to	update the HUD

; output:
;	a6 = vdp_data_port ($C00000)
;	uses d0, d1, d2, d3, d4, d6, a1, a2, a3
; ---------------------------------------------------------------------------

hudVRAM:	macro loc
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),d0
		endm

HUD_Update:
		tst.w	(f_debug_enable).w			; is debug mode	on?
		bne.w	HudDebug				; if yes, branch
		tst.b	(f_hud_score_update).w			; does the score need updating?
		beq.s	.chkrings				; if not, branch

		clr.b	(f_hud_score_update).w
		hudVRAM	$DC80					; set VRAM address
		move.l	(v_score).w,d1				; load score
		bsr.w	Hud_Score

	.chkrings:
		tst.b	(v_hud_rings_update).w			; does the ring	counter	need updating?
		beq.s	.chktime				; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_ZeroRings				; reset rings to 0 if Sonic is hit

	.notzero:
		clr.b	(v_hud_rings_update).w
		hudVRAM	$DF40					; set VRAM address
		moveq	#0,d1
		move.w	(v_rings).w,d1				; load number of rings
		bsr.w	Hud_Rings

	.chktime:
		tst.b	(f_hud_time_update).w			; does the time	need updating?
		beq.s	.chklives				; if not, branch
		tst.w	(f_pause).w				; is the game paused?
		bne.s	.chklives				; if yes, branch
		lea	(v_time).w,a1
		cmpi.l	#(9*$10000)+(59*$100)+59,(a1)+		; is the time 9:59:59?
		beq.s	TimeOver				; if yes, branch

		addq.b	#1,-(a1)				; increment 1/60s counter
		cmpi.b	#60,(a1)				; check if passed 60
		bcs.s	.chklives
		move.b	#0,(a1)
		addq.b	#1,-(a1)				; increment second counter
		cmpi.b	#60,(a1)				; check if passed 60
		bcs.s	.updatetime
		move.b	#0,(a1)
		addq.b	#1,-(a1)				; increment minute counter
		cmpi.b	#9,(a1)					; check if passed 9
		bcs.s	.updatetime
		move.b	#9,(a1)					; keep as 9

	.updatetime:
		hudVRAM	$DE40
		moveq	#0,d1
		move.b	(v_time_min).w,d1			; load	minutes
		bsr.w	Hud_Mins
		hudVRAM	$DEC0
		moveq	#0,d1
		move.b	(v_time_sec).w,d1			; load	seconds
		bsr.w	Hud_Secs

	.chklives:
		tst.b	(f_hud_lives_update).w			; does the lives counter need updating?
		beq.s	.chkbonus				; if not, branch
		clr.b	(f_hud_lives_update).w
		bsr.w	Hud_Lives

	.chkbonus:
		tst.b	(f_pass_bonus_update).w			; do time/ring bonus counters need updating?
		beq.s	.finish					; if not, branch
		clr.b	(f_pass_bonus_update).w
		locVRAM	$AE00
		moveq	#0,d1
		move.w	(v_time_bonus).w,d1			; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ring_bonus).w,d1			; load ring bonus
		bsr.w	Hud_TimeRingBonus

	.finish:
		rts	
; ===========================================================================

TimeOver:
		clr.b	(f_hud_time_update).w
		lea	(v_ost_player).w,a0
		movea.l	a0,a2					; a2 = object killing Sonic (himself in this case)
		bsr.w	KillSonic				; kill Sonic
		move.b	#1,(f_time_over).w			; flag for GAME OVER object to use correct frame
		rts	
; ===========================================================================

HudDebug:
		bsr.w	HudDb_XY
		tst.b	(v_hud_rings_update).w			; does the ring	counter	need updating?
		beq.s	.objcounter				; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_ZeroRings				; reset rings to 0 if Sonic is hit

	.notzero:
		clr.b	(v_hud_rings_update).w
		hudVRAM	$DF40					; set VRAM address
		moveq	#0,d1
		move.w	(v_rings).w,d1				; load number of rings
		bsr.w	Hud_Rings

	.objcounter:
		hudVRAM	$DEC0					; set VRAM address
		moveq	#0,d1
		move.b	(v_spritecount).w,d1			; load "number of objects" counter
		bsr.w	Hud_Secs
		tst.b	(f_hud_lives_update).w			; does the lives counter need updating?
		beq.s	.chkbonus				; if not, branch
		clr.b	(f_hud_lives_update).w
		bsr.w	Hud_Lives

	.chkbonus:
		tst.b	(f_pass_bonus_update).w			; does the ring/time bonus counter need updating?
		beq.s	.finish					; if not, branch
		clr.b	(f_pass_bonus_update).w
		locVRAM	$AE00					; set VRAM address
		moveq	#0,d1
		move.w	(v_time_bonus).w,d1			; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ring_bonus).w,d1			; load ring bonus
		bsr.w	Hud_TimeRingBonus

	.finish:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	set rings counter to 0 on HUD

; input:
;	a6 = vdp_data_port ($C00000)

;	uses d0, d1, d2, d3, d4, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_ZeroRings:
		locVRAM	$DF40					; rings counter VRAM address
		lea	Hud_TilesRings(pc),a2			; tile list
		move.w	#3-1,d2					; number of characters
		bra.s	Hud_Base_Load

; ---------------------------------------------------------------------------
; Subroutine to	load uncompressed HUD patterns ("E", "0", colon)

; output:
;	a6 = vdp_data_port ($C00000)
;	uses d0, d1, d2, d3, d4, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_Base:
		lea	(vdp_data_port).l,a6
		bsr.w	Hud_Lives				; update lives counter
		locVRAM	$DC40					; VRAM address
		lea	Hud_TilesBase(pc),a2			; tile list
		move.w	#15-1,d2				; number of characters

Hud_Base_Load:
		lea	Art_Hud(pc),a1				; address of HUD gfx

.loop_chars:
		move.w	#((sizeof_cell/4)*2)-1,d1		; each character consist of 2 cells
		move.b	(a2)+,d0				; get tile id
		bmi.s	.blank_char				; branch if $FF
		ext.w	d0
		lsl.w	#5,d0					; multiply tile id by $20
		lea	(a1,d0.w),a3				; jump to relevant gfx

	.loop_gfx:
		move.l	(a3)+,(a6)				; write 2 cells to VRAM
		dbf	d1,.loop_gfx

.next_char:
		dbf	d2,.loop_chars				; repeat for all characters

		rts	
; ===========================================================================

.blank_char:
		move.l	#0,(a6)					; erase character
		dbf	d1,.blank_char

		bra.s	.next_char

Hud_TilesBase:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF,	0	; "E      0" in score
		dc.b 0, $14, 0, 0				; "0:00" in time
Hud_TilesRings:	dc.b $FF, $FF, 0				; "  0" in rings
		even

; ---------------------------------------------------------------------------
; Subroutine to	load debug mode	numbers	patterns

; input:
;	a6 = vdp_data_port ($C00000)

;	uses d1, d2, d6, a1, a3
; ---------------------------------------------------------------------------

HudDb_XY:
		locVRAM	$DC40					; VRAM address, starts at "E" in score
		move.w	(v_camera_x_pos).w,d1
		swap	d1					; camera x pos in high word
		move.w	(v_ost_player+ost_x_pos).w,d1		; Sonic x pos in low word
		bsr.s	HudDb_XY2
		move.w	(v_camera_y_pos).w,d1
		swap	d1					; camera y pos in high word
		move.w	(v_ost_player+ost_y_pos).w,d1		; Sonic y pos in low word

HudDb_XY2:
		moveq	#8-1,d6					; number of digits
		lea	(Art_Text).l,a1				; debug number gfx

	.loop:
		rol.w	#4,d1
		move.w	d1,d2					; copy nybble to d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	.is_0to9				; branch if 0-9
		addq.w	#7,d2					; use later tile for A-F

	.is_0to9:
		lsl.w	#5,d2					; multiply by $20
		lea	(a1,d2.w),a3				; jump to relevant tile in gfx
		rept sizeof_cell/4
		move.l	(a3)+,(a6)				; copy tile to VRAM
		endr
		swap	d1
		dbf	d6,.loop				; repeat for all digits stored in d1

		rts

; ---------------------------------------------------------------------------
; Subroutine to	load rings numbers patterns

; input:
;	d0 = VDP instruction for VRAM address
;	d1 = number of rings
;	a6 = vdp_data_port ($C00000)

;	uses d1, d2, d3, d4, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_Rings:
		lea	(Hud_100).l,a2				; multiples of 10
		moveq	#3-1,d6					; number of digits
		bra.s	Hud_LoadArt

; ---------------------------------------------------------------------------
; As above, but for the score
; ---------------------------------------------------------------------------

Hud_Score:
		lea	(Hud_100000).l,a2			; multiples of 10
		moveq	#6-1,d6					; number of digits

Hud_LoadArt:
		moveq	#0,d4
		lea	Art_Hud(pc),a1				; address of HUD number gfx

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3				; d3 = multiple of 10

	.find_digit:
		sub.l	d3,d1
		bcs.s	.digit_found				; branch if score is less than the value in d3
		addq.w	#1,d2					; increment digit counter
		bra.s	.find_digit				; repeat until d2 = digit
; ===========================================================================

.digit_found:
		add.l	d3,d1
		tst.w	d2
		beq.s	.digit_0				; branch if digit is 0
		move.w	#1,d4					; set flag to load gfx for digit

	.digit_0:
		tst.w	d4
		beq.s	.skip_digit				; branch if digit was 0
		lsl.w	#6,d2					; multiply by $40 (size of 2 tiles per digit)
		move.l	d0,4(a6)				; set target VRAM address
		lea	(a1,d2.w),a3				; jump to relevant gfx source
		rept (sizeof_cell/4)*2
		move.l	(a3)+,(a6)				; copy 2 tiles to VRAM
		endr

	.skip_digit:
		addi.l	#(sizeof_cell*2)<<16,d0			; next VRAM address, 2 tiles ahead
		dbf	d6,.loop				; repeat for number of digits

		rts

; ---------------------------------------------------------------------------
; Subroutine to	load countdown numbers on the continue screen

; input:
;	d1 = number on countdown

; output:
;	a6 = vdp_data_port ($C00000)

;	uses d1, d2, d3, d6, a1, a2, a3
; ---------------------------------------------------------------------------

ContScrCounter:
		locVRAM	$DF80
		lea	(vdp_data_port).l,a6
		lea	(Hud_10).l,a2
		moveq	#2-1,d6					; number of digits
		moveq	#0,d4
		lea	Art_Hud(pc),a1				; address of number gfx

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3				; d3 = multiple of 10

.find_digit:
		sub.l	d3,d1
		blo.s	.digit_found				; branch if number is less than the value in d3
		addq.w	#1,d2					; increment digit counter
		bra.s	.find_digit				; repeat until d2 = digit
; ===========================================================================

.digit_found:
		add.l	d3,d1
		lsl.w	#6,d2					; multiply by $40 (size of 2 tiles per digit)
		lea	(a1,d2.w),a3				; jump to relevant gfx source
		rept (sizeof_cell/4)*2
		move.l	(a3)+,(a6)				; copy 2 tiles to VRAM
		endr
		dbf	d6,.loop				; repeat 1 more	time

		rts

; ---------------------------------------------------------------------------
; HUD counter sizes
; ---------------------------------------------------------------------------

Hud_100000:	dc.l 100000
Hud_10000:	dc.l 10000
Hud_1000:	dc.l 1000
Hud_100:	dc.l 100
Hud_10:		dc.l 10
Hud_1:		dc.l 1

; ---------------------------------------------------------------------------
; Subroutine to	load time numbers patterns

; input:
;	d0 = VDP instruction for VRAM address
;	d1 = number on time counter
;	a6 = vdp_data_port ($C00000)

;	uses d1, d2, d3, d4, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_Mins:
		lea	(Hud_1).l,a2				; multiples of 10
		moveq	#1-1,d6					; number of digits
		bra.s	Hud_Time_Load

Hud_Secs:
		lea	(Hud_10).l,a2				; multiples of 10
		moveq	#2-1,d6					; number of digits

Hud_Time_Load:
		moveq	#0,d4
		lea	Art_Hud(pc),a1				; address of HUD number gfx

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3				; d3 = multiple of 10

	.find_digit:
		sub.l	d3,d1
		bcs.s	.digit_found				; branch if time is less than the value in d3
		addq.w	#1,d2					; increment digit counter
		bra.s	.find_digit				; repeat until d2 = digit
; ===========================================================================

.digit_found:
		add.l	d3,d1
		tst.w	d2
		beq.s	.digit_0				; branch if digit is 0
		move.w	#1,d4					; unused flag

	.digit_0:
		lsl.w	#6,d2					; multiply by $40 (size of 2 tiles per digit)
		move.l	d0,4(a6)				; set target VRAM address
		lea	(a1,d2.w),a3				; jump to relevant gfx source
		rept (sizeof_cell/4)*2
		move.l	(a3)+,(a6)				; copy 2 tiles to VRAM
		endr
		addi.l	#(sizeof_cell*2)<<16,d0			; next VRAM address, 2 tiles ahead
		dbf	d6,.loop				; repeat for number of digits

		rts

; ---------------------------------------------------------------------------
; Subroutine to	load time/ring bonus numbers patterns

; input:
;	d0 = VDP instruction for VRAM address
;	d1 = number on bonus counter
;	a6 = vdp_data_port ($C00000)

;	uses d1, d2, d3, d4, d5, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_TimeRingBonus:
		lea	(Hud_1000).l,a2				; multiples of 10
		moveq	#4-1,d6					; number of digits
		moveq	#0,d4
		lea	Art_Hud(pc),a1				; address of HUD number gfx

.loop:
		moveq	#0,d2
		move.l	(a2)+,d3				; d3 = multiple of 10

	.find_digit:
		sub.l	d3,d1
		bcs.s	.digit_found				; branch if bonus is less than the value in d3
		addq.w	#1,d2					; increment digit counter
		bra.s	.find_digit				; repeat until d2 = digit
; ===========================================================================

.digit_found:
		add.l	d3,d1
		tst.w	d2
		beq.s	.digit_0				; branch if digit is 0
		move.w	#1,d4					; set flag to load gfx for digit

	.digit_0:
		tst.w	d4
		beq.s	.skip_digit				; branch if digit was 0
		lsl.w	#6,d2					; multiply by $40 (size of 2 tiles per digit)
		lea	(a1,d2.w),a3				; jump to relevant gfx source
		rept (sizeof_cell/4)*2
		move.l	(a3)+,(a6)				; copy 2 tiles to VRAM
		endr

.next:
		dbf	d6,.loop				; repeat for number of digits

		rts	
; ===========================================================================

.skip_digit:
		moveq	#((sizeof_cell/4)*2)-1,d5

	.loop_erase:
		move.l	#0,(a6)					; write blank digit to VRAM
		dbf	d5,.loop_erase

		bra.s	.next

; ---------------------------------------------------------------------------
; Subroutine to	load uncompressed lives	counter	patterns

; input:
;	a6 = vdp_data_port ($C00000)

;	uses d0, d1, d2, d3, d4, d5, d6, a1, a2, a3
; ---------------------------------------------------------------------------

Hud_Lives:
		hudVRAM	$FBA0					; VRAM address of lives counter
		moveq	#0,d1
		move.b	(v_lives).w,d1				; load number of lives
		lea	(Hud_10).l,a2				; multiples of 10
		moveq	#2-1,d6					; number of digits
		moveq	#0,d4
		lea	Art_LivesNums(pc),a1			; address of lives counter gfx

.loop:
		move.l	d0,4(a6)				; set VRAM address
		moveq	#0,d2
		move.l	(a2)+,d3				; d3 = multiple of 10

	.find_digit:
		sub.l	d3,d1
		bcs.s	.digit_found				; branch if lives is less than the value in d3
		addq.w	#1,d2					; increment digit counter
		bra.s	.find_digit				; repeat until d2 = digit
; ===========================================================================

.digit_found:
		add.l	d3,d1
		tst.w	d2
		beq.s	.digit_0				; branch if digit is 0
		move.w	#1,d4					; set flag to load gfx for digit

	.digit_0:
		tst.w	d4
		beq.s	.skip_digit				; branch if digit was 0

.show_digit:
		lsl.w	#5,d2					; multiply by $20 (size of cell)
		lea	(a1,d2.w),a3				; jump to relevant gfx source
		rept sizeof_cell/4
		move.l	(a3)+,(a6)				; copy tile to VRAM
		endr

.next:
		addi.l	#(sizeof_cell*2)<<16,d0			; next VRAM address, 2 tiles ahead (1st & 2nd digits are not adjacent)
		dbf	d6,.loop				; repeat 1 more time

		rts	
; ===========================================================================

.skip_digit:
		tst.w	d6
		beq.s	.show_digit				; branch if this is the 2nd digit
		moveq	#(sizeof_cell/4)-1,d5

	.loop_erase:
		move.l	#0,(a6)					; write blank digit to VRAM
		dbf	d5,.loop_erase
		bra.s	.next
