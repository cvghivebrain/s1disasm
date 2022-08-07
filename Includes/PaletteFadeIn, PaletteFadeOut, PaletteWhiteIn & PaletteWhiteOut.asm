; ---------------------------------------------------------------------------
; Subroutine to	fade in from black

;	uses d0, d1, d2, d3, d4, a0, a1
; ---------------------------------------------------------------------------

PaletteFadeIn:
		move.w	#palfade_all,(v_palfade_start).w	; set start position = 0; size = $40 ($3F)

PalFadeIn_Alt:							; start position and size are already set
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		moveq	#cBlack,d1
		move.b	(v_palfade_size).w,d0

	.fill:
		move.w	d1,(a0)+
		dbf	d0,.fill				; fill palette with black

		move.w	#(7*3),d4				; max number of colour changes needed (000 to $EEE)

	.mainloop:
		move.b	#id_VBlank_Fade,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait for frame to end
		bsr.s	FadeIn_FromBlack			; update palette
		bsr.w	RunPLC					; decompress gfx if PLC contains anything
		dbf	d4,.mainloop
		rts
; ===========================================================================

FadeIn_FromBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0			; current palette (starts as all black)
		lea	(v_pal_dry_next).w,a1			; target palette
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_palfade_size).w,d0

	.addcolour:
		bsr.s	FadeIn_AddColour			; raise RGB levels (until they match target palette)
		dbf	d0,.addcolour				; repeat for size of palette

		cmpi.b	#id_LZ,(v_zone).w			; is level Labyrinth?
		bne.s	.exit					; if not, branch

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		lea	(v_pal_water_next).w,a1
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_palfade_size).w,d0

	.addcolour_water:
		bsr.s	FadeIn_AddColour			; raise RGB levels for underwater palette
		dbf	d0,.addcolour_water			; repeat for size of palette

	.exit:
		rts
; ===========================================================================

FadeIn_AddColour:
.addblue:
		move.w	(a1)+,d2				; d2 = target colour
		move.w	(a0),d3					; d3 = current colour
		cmp.w	d2,d3
		beq.s	.next					; branch if perfect match

		move.w	d3,d1
		addi.w	#$200,d1				; increase blue	value
		cmp.w	d2,d1
		bhi.s	.addgreen				; branch if blue already matched
		move.w	d1,(a0)+				; update blue
		rts	
; ===========================================================================

.addgreen:
		move.w	d3,d1
		addi.w	#$20,d1					; increase green value
		cmp.w	d2,d1
		bhi.s	.addred					; branch if green already matched
		move.w	d1,(a0)+				; update green
		rts	
; ===========================================================================

.addred:
		addq.w	#2,(a0)+				; increase red value
		rts	
; ===========================================================================

.next:
		addq.w	#2,a0					; next colour
		rts

; ---------------------------------------------------------------------------
; Subroutine to fade out to black

;	uses d0, d1, d2, d4, a0
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#palfade_all,(v_palfade_start).w	; start position = 0; size = $40 ($3F)
		move.w	#(7*3),d4				; max number of colour changes needed ($EEE to 000)

	.mainloop:
		move.b	#id_VBlank_Fade,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait for frame to end
		bsr.s	FadeOut_ToBlack				; update palette
		bsr.w	RunPLC					; decompress gfx if PLC contains anything
		dbf	d4,.mainloop
		rts
; ===========================================================================

FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0			; current palette
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_palfade_size).w,d0

	.decolour:
		bsr.s	FadeOut_DecColour			; lower RGB levels
		dbf	d0,.decolour				; repeat for size of palette

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_palfade_size).w,d0

	.decolour_water:
		bsr.s	FadeOut_DecColour			; lower RGB levels for underwater palette
		dbf	d0,.decolour_water			; repeat for size of palette
		rts
; ===========================================================================

FadeOut_DecColour:
.dered:
		move.w	(a0),d2					; d2 = current colour
		beq.s	.next					; branch if already black

		move.w	d2,d1
		andi.w	#$E,d1					; d1 = red value
		beq.s	.degreen				; branch if 0
		subq.w	#2,(a0)+				; decrease red value
		rts	
; ===========================================================================

.degreen:
		move.w	d2,d1
		andi.w	#$E0,d1					; d1 = green value
		beq.s	.deblue					; branch if 0
		subi.w	#$20,(a0)+				; decrease green value
		rts	
; ===========================================================================

.deblue:
		move.w	d2,d1
		andi.w	#$E00,d1				; d1 = blue value
		beq.s	.next					; branch if 0
		subi.w	#$200,(a0)+				; decrease blue	value
		rts	
; ===========================================================================

.next:
		addq.w	#2,a0					; next colour
		rts

; ---------------------------------------------------------------------------
; Subroutine to	fade in from white (Special Stage)

;	uses d0, d1, d2, d3, d4, a0, a1
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#palfade_all,(v_palfade_start).w	; start position = 0; size = $40
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		move.w	#cWhite,d1
		move.b	(v_palfade_size).w,d0

	.fill:
		move.w	d1,(a0)+
		dbf	d0,.fill				; fill palette with white

		move.w	#(7*3),d4				; max number of colour changes needed ($EEE to 0)

	.mainloop:
		move.b	#id_VBlank_Fade,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait for frame to end
		bsr.s	WhiteIn_FromWhite			; update palette
		bsr.w	RunPLC					; decompress gfx if PLC contains anything
		dbf	d4,.mainloop
		rts
; ===========================================================================

WhiteIn_FromWhite:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0			; current palette (starts as all white)
		lea	(v_pal_dry_next).w,a1			; target palette
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_palfade_size).w,d0

	.decolour:
		bsr.s	WhiteIn_DecColour			; lower RGB levels (until they match target palette)
		dbf	d0,.decolour				; repeat for size of palette

		cmpi.b	#id_LZ,(v_zone).w			; is level Labyrinth?
		bne.s	.exit					; if not, branch

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		lea	(v_pal_water_next).w,a1
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_palfade_size).w,d0

	.decolour_water:
		bsr.s	WhiteIn_DecColour			; lower RGB levels for underwater palette
		dbf	d0,.decolour_water			; repeat for size of palette

	.exit:
		rts
; ===========================================================================

WhiteIn_DecColour:
.deblue:
		move.w	(a1)+,d2				; d2 = target colour
		move.w	(a0),d3					; d3 = current colour
		cmp.w	d2,d3
		beq.s	.next					; branch if perfect match

		move.w	d3,d1
		subi.w	#$200,d1				; decrease blue	value
		bcs.s	.degreen				; branch if already 0
		cmp.w	d2,d1
		blo.s	.degreen				; branch if blue already matched
		move.w	d1,(a0)+				; update blue
		rts	
; ===========================================================================

.degreen:
		move.w	d3,d1
		subi.w	#$20,d1					; decrease green value
		bcs.s	.dered					; branch if already 0
		cmp.w	d2,d1
		blo.s	.dered					; branch if green already matched
		move.w	d1,(a0)+				; update green
		rts	
; ===========================================================================

.dered:
		subq.w	#2,(a0)+				; decrease red value
		rts	
; ===========================================================================

.next:
		addq.w	#2,a0					; next colour
		rts

; ---------------------------------------------------------------------------
; Subroutine to fade to white (Special Stage)

;	uses d0, d1, d2, d4, a0
; ---------------------------------------------------------------------------

PaletteWhiteOut:
		move.w	#palfade_all,(v_palfade_start).w	; start position = 0; size = $40 ($3F)
		move.w	#(7*3),d4				; max number of colour changes needed (000 to $EEE)

	.mainloop:
		move.b	#id_VBlank_Fade,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait for frame to end
		bsr.s	WhiteOut_ToWhite			; update palette
		bsr.w	RunPLC					; decompress gfx if PLC contains anything
		dbf	d4,.mainloop
		rts
; ===========================================================================

WhiteOut_ToWhite:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0			; current palette
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_palfade_size).w,d0

	.addcolour:
		bsr.s	WhiteOut_AddColour			; raise RGB levels
		dbf	d0,.addcolour				; repeat for size of palette

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		move.b	(v_palfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_palfade_size).w,d0

	.addcolour_water:
		bsr.s	WhiteOut_AddColour			; raise RGB levels for underwater palette
		dbf	d0,.addcolour_water			; repeat for size of palette
		rts
; ===========================================================================

WhiteOut_AddColour:
.addred:
		move.w	(a0),d2					; d2 = current colour
		cmpi.w	#cWhite,d2
		beq.s	.next					; branch if already white

		move.w	d2,d1
		andi.w	#$E,d1					; d1 = red value
		cmpi.w	#cRed,d1
		beq.s	.addgreen				; branch if max value
		addq.w	#2,(a0)+				; increase red value
		rts	
; ===========================================================================

.addgreen:
		move.w	d2,d1
		andi.w	#$E0,d1					; d1 = green value
		cmpi.w	#cGreen,d1
		beq.s	.addblue				; branch if max value
		addi.w	#$20,(a0)+				; increase green value
		rts	
; ===========================================================================

.addblue:
		move.w	d2,d1
		andi.w	#$E00,d1				; d1 = blue value
		cmpi.w	#cBlue,d1
		beq.s	.next					; branch if max value
		addi.w	#$200,(a0)+				; increase blue	value
		rts	
; ===========================================================================

.next:
		addq.w	#2,a0					; next colour
		rts
