; ---------------------------------------------------------------------------
; Subroutine to	copy a tile map from RAM to VRAM fg/bg nametable

; input:
;	d0.l = VRAM fg/bg nametable address (as VDP command)
;	d1.w = width-1 (cells)
;	d2.w = height-1 (cells)
;	a1 = tile map address

; output:
;	a6 = vdp_data_port ($C00000)

;	uses d0.l, d2.w, d3.w, d4.l, a1
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#sizeof_vram_row<<16,d4			; d4 = $800000

	.loop_row:
		move.l	d0,4(a6)				; move d0 to vdp_control_port
		move.w	d1,d3

	.loop_cell:
		move.w	(a1)+,(a6)				; write value to nametable
		dbf	d3,.loop_cell				; next tile
		add.l	d4,d0					; goto next line
		dbf	d2,.loop_row				; next line
		rts
