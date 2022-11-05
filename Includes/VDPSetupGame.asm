; ---------------------------------------------------------------------------
; Subroutine to	clear CRAM and set default VDP register values

; output:
;	a0 = vdp_control_port ($C00004)
;	a1 = vdp_data_port ($C00000)
;	a5 = vdp_control_port ($C00004)

;	uses d0.l, d7.l, a2
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#((VDPSetupArray_end-VDPSetupArray)/2)-1,d7
	.setreg:
		move.w	(a2)+,(a0)
		dbf	d7,.setreg				; set the VDP registers

		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_mode_buffer).w		; save $8134 to buffer for later use
		move.w	#vdp_hint_counter+223,(v_vdp_hint_counter).w ; horizontal interrupt every 224th scanline

		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l		; set VDP to CRAM write
		move.w	#$40-1,d7
	.clrCRAM:
		move.w	d0,(a1)
		dbf	d7,.clrCRAM				; clear	the CRAM

		clr.l	(v_fg_y_pos_vsram).w
		clr.l	(v_fg_x_pos_hscroll).w
		pushr	d1					; save d1 to stack (d1 is used by dma_fill)
		dma_fill	0,$FFFF,0			; clear the VRAM (also sets a5 to vdp_control_port)
		popr	d1					; restore d1
		rts

; ===========================================================================
VDPSetupArray:	dc.w vdp_md_color				; $8004 ; normal colour mode
		dc.w vdp_enable_vint|vdp_enable_dma|vdp_ntsc_display|vdp_md_display ; $8134
		dc.w vdp_fg_nametable+(vram_fg>>10)		; set foreground nametable address
		dc.w vdp_window_nametable+(vram_window>>10)	; set window nametable address
		dc.w vdp_bg_nametable+(vram_bg>>13)		; set background nametable address
		dc.w vdp_sprite_table+(vram_sprites>>9)		; set sprite table address
		dc.w vdp_sprite_table2				; unused
		dc.w vdp_bg_color+0				; set background colour (palette entry 0)
		dc.w vdp_sms_hscroll				; unused
		dc.w vdp_sms_vscroll				; unused
		dc.w vdp_hint_counter+0				; default horizontal interrupt register
		dc.w vdp_full_vscroll|vdp_full_hscroll		; $8B00 ; full-screen vertical/horizontal scrolling
		dc.w vdp_320px_screen_width			; $8C81 ; 40-cell display mode
		dc.w vdp_hscroll_table+(vram_hscroll>>10)	; set background hscroll address
		dc.w vdp_nametable_hi				; unused
		dc.w vdp_auto_inc+2				; set VDP increment size
		dc.w vdp_plane_width_64|vdp_plane_height_32	; $9001 ; 64x32 cell plane size
		dc.w vdp_window_x_pos				; window horizontal position
		dc.w vdp_window_y_pos				; window vertical position
	VDPSetupArray_end:
