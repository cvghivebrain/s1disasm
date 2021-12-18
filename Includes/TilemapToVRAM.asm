; ---------------------------------------------------------------------------
; Subroutine to	copy a tile map from RAM to VRAM fg/bg nametable

; input:
;	a1 = tile map address
;	d0 = VRAM fg/bg nametable address (as VDP command)
;	d1 = width-1 (cells)
;	d2 = height-1 (cells)
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#sizeof_vram_row<<16,d4			; d4 = $800000

	@loop_row:
		move.l	d0,4(a6)				; move d0 to vdp_control_port
		move.w	d1,d3

	@loop_cell:
		move.w	(a1)+,(a6)				; write value to nametable
		dbf	d3,@loop_cell				; next tile
		add.l	d4,d0					; goto next line
		dbf	d2,@loop_row				; next line
		rts	
; End of function TilemapToVRAM
