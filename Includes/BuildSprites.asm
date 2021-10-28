
BldSpr_ScrPos:	dc.l 0				; blank
		dc.l v_camera_x_pos&$FFFFFF	; main screen x position
		dc.l v_bg1_x_pos&$FFFFFF	; background x position	1
		dc.l v_bg3_x_pos&$FFFFFF	; background x position	2
		
; ---------------------------------------------------------------------------
; Subroutine to	convert	objects to proper Mega Drive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSprites:
		lea	(v_spritetablebuffer).w,a2 ; set address for sprite table - $280 bytes, copied to VRAM at VBlank
		moveq	#0,d5
		lea	(v_sprite_queue).w,a4
		moveq	#7,d7		; there are 8 priority levels

	@priorityLoop:
		tst.w	(a4)		; are there objects left to draw?
		beq.w	@nextPriority	; if not, branch
		moveq	#2,d6

	@objectLoop:
		movea.w	(a4,d6.w),a0	; load address of OST of object
		tst.b	(a0)		; if null, branch
		beq.w	@skipObject
		bclr	#render_onscreen_bit,ost_render(a0) ; set as not visible

		move.b	ost_render(a0),d0
		move.b	d0,d4
		andi.w	#render_rel+render_bg,d0 ; get drawing coordinate system
		beq.s	@screenCoords	; branch if 0 (absolute screen coordinates)
		movea.l	BldSpr_ScrPos(pc,d0.w),a1 ; get screen x position (or background x position if render_bg is used)
	; check object bounds
		moveq	#0,d0
		move.b	ost_actwidth(a0),d0
		move.w	ost_x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	@skipObject	; left edge out of bounds
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	@skipObject	; right edge out of bounds
		addi.w	#128,d3		; VDP sprites start at 128px

		btst	#render_useheight_bit,d4 ; is use height flag on?
		beq.s	@assumeHeight	; if not, branch
		moveq	#0,d0
		move.b	ost_height(a0),d0
		move.w	ost_y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	@skipObject	; top edge out of bounds
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	@skipObject
		addi.w	#128,d2		; VDP sprites start at 128px
		bra.s	@drawObject
; ===========================================================================

	@screenCoords:
		move.w	ost_y_screen(a0),d2 ; special variable for screen Y
		move.w	ost_x_pos(a0),d3
		bra.s	@drawObject
; ===========================================================================

	@assumeHeight:
		move.w	ost_y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2
		cmpi.w	#$60,d2
		blo.s	@skipObject
		cmpi.w	#$180,d2
		bhs.s	@skipObject

	@drawObject:
		movea.l	ost_mappings(a0),a1
		moveq	#0,d1
		btst	#render_rawmap_bit,d4 ; is raw mappings flag on?
		bne.s	@drawFrame	; if yes, branch
		move.b	ost_frame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1	; get mappings frame address
		move.b	(a1)+,d1	; number of sprite pieces
		subq.b	#1,d1
		bmi.s	@setVisible

	@drawFrame:
		bsr.w	BuildSpr_Draw	; write data from sprite pieces to buffer

	@setVisible:
		bset	#render_onscreen_bit,ost_render(a0) ; set object as visible

	@skipObject:
		addq.w	#2,d6
		subq.w	#2,(a4)		; number of objects left
		bne.w	@objectLoop

	@nextPriority:
		lea	$80(a4),a4
		dbf	d7,@priorityLoop
		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	@spriteLimit
		move.l	#0,(a2)
		rts	
; ===========================================================================

	@spriteLimit:
		move.b	#0,-5(a2)	; set last sprite link
		rts	
; End of function BuildSprites


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSpr_Draw:
		movea.w	ost_tile(a0),a3
		btst	#render_xflip_bit,d4
		bne.s	BuildSpr_FlipX
		btst	#render_yflip_bit,d4
		bne.w	BuildSpr_FlipY


BuildSpr_Normal:
		cmpi.b	#$50,d5		; check sprite limit
		beq.s	@return
		move.b	(a1)+,d0	; get y-offset
		ext.w	d0
		add.w	d2,d0		; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; write sprite size
		addq.b	#1,d5		; increment sprite counter
		move.b	d5,(a2)+	; set as sprite link
		move.b	(a1)+,d0	; get art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0		; add art tile offset
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d0	; get x-offset
		ext.w	d0
		add.w	d3,d0		; add x-position
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	@writeX
		addq.w	#1,d0

	@writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_Normal ; process next sprite piece

	@return:
		rts	
; End of function BuildSpr_Normal

; ===========================================================================

BuildSpr_FlipX:
		btst	#render_yflip_bit,d4 ; is object also y-flipped?
		bne.w	BuildSpr_FlipXY	; if yes, branch

	@loop:
		cmpi.b	#$50,d5		; check sprite limit
		beq.s	@return
		move.b	(a1)+,d0	; y position
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+	
		addq.b	#1,d5		; link
		move.b	d5,(a2)+
		move.b	(a1)+,d0	; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0	
		add.w	a3,d0
		eori.w	#$800,d0	; toggle xflip in VDP
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d0	; get x-offset
		ext.w	d0
		neg.w	d0		; negate it
		add.b	d4,d4		; calculate flipped position by size
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	@writeX
		addq.w	#1,d0

	@writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,@loop	; process next sprite piece

	@return:
		rts	
; ===========================================================================

BuildSpr_FlipY:
		cmpi.b	#$50,d5		; check sprite limit
		beq.s	@return
		move.b	(a1)+,d0	; get y-offset
		move.b	(a1),d4		; get size
		ext.w	d0
		neg.w	d0		; negate y-offset
		lsl.b	#3,d4		; calculate flip offset
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0		; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; size
		addq.b	#1,d5
		move.b	d5,(a2)+	; link
		move.b	(a1)+,d0	; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0	; toggle yflip in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0	; x-position
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@writeX
		addq.w	#1,d0

	@writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipY ; process next sprite piece

	@return:
		rts	
; ===========================================================================

BuildSpr_FlipXY:
		cmpi.b	#$50,d5		; check sprite limit
		beq.s	@return
		move.b	(a1)+,d0	; calculated flipped y
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+	; link
		addq.b	#1,d5
		move.b	d5,(a2)+	; art tile
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0	; toggle x/yflip in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0	; calculate flipped x
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@writeX
		addq.w	#1,d0

	@writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipXY ; process next sprite piece

	@return:
		rts	
