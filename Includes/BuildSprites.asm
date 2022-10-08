
BldSpr_ScrPos:	dc.l 0						; blank
		dc.l v_camera_x_pos&$FFFFFF			; main screen x position
		dc.l v_bg1_x_pos&$FFFFFF			; background x position	1
		dc.l v_bg3_x_pos&$FFFFFF			; background x position	2
		
; ---------------------------------------------------------------------------
; Subroutine to	convert	objects into proper Mega Drive sprites

; output:
;	a2 = address of last sprite in sprite buffer

;	uses d0.l, d1.w, d2.w, d3.w, d4.w, d5.l, d6.l, d7.l, a0, a1, a4
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_sprite_buffer).w,a2			; set address for sprite table - $280 bytes, copied to VRAM at VBlank
		moveq	#0,d5
		lea	(v_sprite_queue).w,a4			; address of sprite queue - $400 bytes, 8 sections of $80 bytes (1 word for count, $3F words for OST addresses)
		moveq	#8-1,d7					; there are 8 priority levels

	.priority_loop:
		tst.w	(a4)					; are there objects left in current section?
		beq.w	.next_priority				; if not, branch
		moveq	#2,d6					; start address within current section (1st word is object count)

	.object_loop:
		movea.w	(a4,d6.w),a0				; load address of OST of object
		tst.b	(a0)
		beq.w	.next_object				; if object id is 0, branch

		bclr	#render_onscreen_bit,ost_render(a0)	; set as not visible
		move.b	ost_render(a0),d0
		move.b	d0,d4
		andi.w	#render_rel+render_bg,d0		; get drawing coordinate system
		beq.s	.abs_screen_coords			; branch if 0 (absolute screen coordinates)
		movea.l	BldSpr_ScrPos(pc,d0.w),a1		; get address for camera x position (or background x position if render_bg is used)

		; check object is visible
		moveq	#0,d0
		move.b	ost_displaywidth(a0),d0
		move.w	ost_x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1					; d1 = x pos of object's right edge on screen
		bmi.w	.next_object				; branch if object is outside left side of screen
		move.w	d3,d1
		sub.w	d0,d1					; d1 = x pos of object's left edge on screen
		cmpi.w	#320,d1
		bge.s	.next_object				; branch if object is outside right side of screen
		addi.w	#128,d3					; d3 = x pos of object on screen, +128px for VDP sprite coordinate

		btst	#render_useheight_bit,d4		; is use height flag on?
		beq.s	.assume_height				; if not, branch
		moveq	#0,d0
		move.b	ost_height(a0),d0
		move.w	ost_y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1					; d1 = y pos of object's bottom edge on screen
		bmi.s	.next_object				; branch if object is outside top side of screen
		move.w	d2,d1
		sub.w	d0,d1					; d1 = y pos of object's top edge on screen
		cmpi.w	#224,d1
		bge.s	.next_object				; branch if object is outside bottom side of screen
		addi.w	#128,d2					; d2 = y pos of object on screen, +128px for VDP sprite coordinate
		bra.s	.draw_object
; ===========================================================================

	.abs_screen_coords:
		move.w	ost_y_screen(a0),d2			; d2 = y pos
		move.w	ost_x_pos(a0),d3			; d3 = x pos
		bra.s	.draw_object
; ===========================================================================

	.assume_height:
		move.w	ost_y_pos(a0),d2
		sub.w	4(a1),d2				; d2 = y pos of object on screen
		addi.w	#128,d2
		cmpi.w	#96,d2
		blo.s	.next_object				; branch if > 32px outside top side of screen
		cmpi.w	#384,d2
		bhs.s	.next_object				; branch if > 32px outside bottom side of screen

	.draw_object:
		movea.l	ost_mappings(a0),a1			; get address of mappings
		moveq	#0,d1
		btst	#render_rawmap_bit,d4			; is raw mappings flag on?
		bne.s	.draw_now				; if yes, branch

		move.b	ost_frame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1				; jump to frame within mappings
		move.b	(a1)+,d1				; number of sprite pieces
		subq.b	#1,d1					; subtract 1 for loops
		bmi.s	.skip_draw				; branch if frame contained 0 sprite pieces

	.draw_now:
		bsr.w	BuildSpr_Draw				; write data from sprite pieces to buffer

	.skip_draw:
		bset	#render_onscreen_bit,ost_render(a0)	; set object as visible

	.next_object:
		addq.w	#2,d6					; read next object in sprite queue
		subq.w	#2,(a4)					; number of objects left
		bne.w	.object_loop				; branch if not 0

	.next_priority:
		lea	sizeof_priority(a4),a4			; next priority section ($80)
		dbf	d7,.priority_loop			; repeat for all sections
		move.b	d5,(v_spritecount).w			; set sprite count
		cmpi.b	#countof_max_sprites,d5			; max displayable sprites ($50)
		beq.s	.max_sprites				; branch if at max
		move.l	#0,(a2)					; set next sprite to link to first
		rts	
; ===========================================================================

	.max_sprites:
		move.b	#0,-5(a2)				; set current sprite to link to first
		rts

; ---------------------------------------------------------------------------
; Subroutine to	convert	and add sprite mappings to the sprite buffer
;
; input:
;	d1.w = number of sprite pieces
;	d2.w = VDP y position
;	d3.w = VDP x position
;	d4.b = render flags (ost_render)
;	d5.b = current sprite count
;	a1 = current address in sprite mappings
;	a2 = current address in sprite buffer

;	uses d0, d1.w, d4.w, d5.b, a1, a2
; ---------------------------------------------------------------------------

BuildSpr_Draw:
		movea.w	ost_tile(a0),a3				; get VRAM setting (tile, x/yflip, palette, priority)
		btst	#render_xflip_bit,d4
		bne.s	BuildSpr_FlipX				; branch if xflipped
		btst	#render_yflip_bit,d4
		bne.w	BuildSpr_FlipY				; branch if yflipped


BuildSpr_Normal:
	.loop:
		cmpi.b	#$50,d5					; check sprite limit
		beq.s	.return					; branch if at max sprites

		move.b	(a1)+,d0				; get relative y pos from mappings
		ext.w	d0
		add.w	d2,d0					; add VDP y pos
		move.w	d0,(a2)+				; write y pos to sprite buffer

		move.b	(a1)+,(a2)+				; write sprite size to buffer
		addq.b	#1,d5					; increment sprite counter
		move.b	d5,(a2)+				; write link to next sprite in buffer

		move.b	(a1)+,d0				; get high byte of tile number from mappings
		lsl.w	#8,d0					; move to high byte of word
		move.b	(a1)+,d0				; get low byte
		add.w	a3,d0					; add VRAM setting
		move.w	d0,(a2)+				; write to buffer

		move.b	(a1)+,d0				; get relative x pos from mappings
		ext.w	d0
		add.w	d3,d0					; add VDP x pos
		andi.w	#$1FF,d0				; keep within 512px
		bne.s	.x_not_0				; branch if x pos isn't 0
		addq.w	#1,d0					; add 1 to prevent sprite masking (sprites at x pos 0 act as masks)

	.x_not_0:
		move.w	d0,(a2)+				; write to buffer
		dbf	d1,.loop				; next sprite piece

	.return:
		rts

; ===========================================================================

BuildSpr_FlipX:
		btst	#render_yflip_bit,d4			; is object also y-flipped?
		bne.w	BuildSpr_FlipXY				; if yes, branch

	.loop:
		cmpi.b	#$50,d5					; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0				; y position
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4				; size
		move.b	d4,(a2)+	
		addq.b	#1,d5					; link
		move.b	d5,(a2)+
		move.b	(a1)+,d0				; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0	
		add.w	a3,d0
		eori.w	#$800,d0				; toggle xflip in VDP
		move.w	d0,(a2)+				; write to buffer
		move.b	(a1)+,d0				; get x-offset
		ext.w	d0
		neg.w	d0					; negate it
		add.b	d4,d4					; calculate flipped position by size
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0				; keep within 512px
		bne.s	.x_not_0
		addq.w	#1,d0

	.x_not_0:
		move.w	d0,(a2)+				; write to buffer
		dbf	d1,.loop				; process next sprite piece

	.return:
		rts

; ===========================================================================

BuildSpr_FlipY:
		cmpi.b	#$50,d5					; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0				; get y-offset
		move.b	(a1),d4					; get size
		ext.w	d0
		neg.w	d0					; negate y-offset
		lsl.b	#3,d4					; calculate flip offset
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0					; add y-position
		move.w	d0,(a2)+				; write to buffer
		move.b	(a1)+,(a2)+				; size
		addq.b	#1,d5
		move.b	d5,(a2)+				; link
		move.b	(a1)+,d0				; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0				; toggle yflip in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0				; x-position
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.x_not_0
		addq.w	#1,d0

	.x_not_0:
		move.w	d0,(a2)+				; write to buffer
		dbf	d1,BuildSpr_FlipY			; process next sprite piece

	.return:
		rts

; ===========================================================================

BuildSpr_FlipXY:
		cmpi.b	#$50,d5					; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0				; calculated flipped y
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+				; write to buffer
		move.b	(a1)+,d4				; size
		move.b	d4,(a2)+				; link
		addq.b	#1,d5
		move.b	d5,(a2)+				; art tile
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0				; toggle x/yflip in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0				; calculate flipped x
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.x_not_0
		addq.w	#1,d0

	.x_not_0:
		move.w	d0,(a2)+				; write to buffer
		dbf	d1,BuildSpr_FlipXY			; process next sprite piece

	.return:
		rts	
