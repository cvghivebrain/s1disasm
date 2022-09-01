; ---------------------------------------------------------------------------
; Subroutine to	clear the screen
; Deletes fg/bg nametables and sprite/hscroll buffers

; input:
;	a5 = vdp_control_port ($C00004)

;	uses d0, d1, a1
; ---------------------------------------------------------------------------

ClearScreen:
		dma_fill	0,sizeof_vram_fg-1,vram_fg	; clear foreground nametable
		dma_fill	0,sizeof_vram_bg-1,vram_bg	; clear background nametable
		if Revision=0
			move.l	#0,(v_fg_y_pos_vsram).w		; clear screen y position
			move.l	#0,(v_fg_x_pos_hscroll).w	; clear screen x position (unused)
		else
			clr.l	(v_fg_y_pos_vsram).w
			clr.l	(v_fg_x_pos_hscroll).w
		endc

		lea	(v_sprite_buffer).w,a1
		moveq	#0,d0
		move.w	#(sizeof_vram_sprites/4),d1		; this should be ($280/4)-1, leading to a slight bug (first 2 colours of v_pal_water are cleared)
	.clearsprites:
		move.l	d0,(a1)+
		dbf	d1,.clearsprites			; clear sprite table (in RAM)

		lea	(v_hscroll_buffer).w,a1
		moveq	#0,d0
		move.w	#(sizeof_vram_hscroll_padded/4),d1	; this should be ($400/4)-1, leading to a slight bug (first 4 bytes of Sonic's object RAM are cleared)
	.clearhscroll:
		move.l	d0,(a1)+
		dbf	d1,.clearhscroll			; clear hscroll table (in RAM)
		rts
