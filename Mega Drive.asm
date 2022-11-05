; ---------------------------------------------------------------------------
; Standard Mega Drive constants & macros
; ---------------------------------------------------------------------------

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
	; Status register bits
	video_mode_bit:		equ 0				; 0 if NTSC, 1 if PAL
	dma_status_bit:		equ 1				; 1 if a DMA is in progress
	hblank_bit:		equ 2				; 1 if HBlank is in progress
	vblank_bit:		equ 3				; 1 if VBlank is in progress
	interlaced_counter_bit:	equ 4				; 0 if even frame displayed in interlaced mode, 1 if odd
	hardware_collision_bit:	equ 5				; 1 if any two sprites have non-transparent pixels overlapping
	sprite_limit_bit:	equ 6				; 1 if sprite limit (16 in H32, 20 in H40) has been reached on current scanline
	vertical_interrupt_bit: equ 7				; 1 if a vertical interrupt has just occurred
	fifo_full_bit:		equ 8				; 1 if VDP FIFO is full
	fifo_empty_bit:		equ 9				; 1 if VDP FIFO is empty
	
	; VDP register settings
	vdp_mode_register1:	equ $8000
	vdp_left_border:	equ vdp_mode_register1+$20	; blank leftmost 8px to bg colour
	vdp_enable_hint:	equ vdp_mode_register1+$10	; enable horizontal interrupts
	vdp_md_color:		equ vdp_mode_register1+4	; Mega Drive colour mode
	vdp_freeze_hvcounter:	equ vdp_mode_register1+2	; freeze H/V counter on interrupts
	vdp_disable_display:	equ vdp_mode_register1+1
	
	vdp_mode_register2:	equ $8100
	vdp_128kb_vram:		equ vdp_mode_register2+$80	; use 128kB of VRAM, Teradrive only
	vdp_hide_display:	equ vdp_mode_register2+$40	; fill display with bg colour
	vdp_enable_vint:	equ vdp_mode_register2+$20	; enable vertical interrupts
	vdp_enable_dma:		equ vdp_mode_register2+$10	; enable DMA operations
	vdp_pal_display:	equ vdp_mode_register2+8	; 240px screen height (PAL)
	vdp_ntsc_display:	equ vdp_mode_register2		; 224px screen height (NTSC)
	vdp_md_display:		equ vdp_mode_register2+4	; mode 5 Mega Drive display
	
	vdp_fg_nametable:	equ $8200			; fg (plane A) nametable setting
	vdp_window_nametable:	equ $8300			; window nametable setting
	vdp_bg_nametable:	equ $8400			; bg (plane B) nametable setting
	vdp_sprite_table:	equ $8500			; sprite table setting
	vdp_sprite_table2:	equ $8600			; sprite table setting for 128kB VRAM
	vdp_bg_color:		equ $8700			; bg colour id (+0..$3F)
	vdp_sms_hscroll:	equ $8800
	vdp_sms_vscroll:	equ $8900
	vdp_hint_counter:	equ $8A00			; number of lines between horizontal interrupts
	
	vdp_mode_register3:	equ $8B00
	vdp_enable_xint:	equ vdp_mode_register3+8	; enable external interrupts
	vdp_16px_vscroll:	equ vdp_mode_register3+4	; 16px column vertical scroll mode
	vdp_full_vscroll:	equ vdp_mode_register3		; full screen vertical scroll mode
	vdp_1px_hscroll:	equ vdp_mode_register3+3	; 1px row horizontal scroll mode
	vdp_8px_hscroll:	equ vdp_mode_register3+2	; 8px row horizontal scroll mode
	vdp_full_hscroll:	equ vdp_mode_register3		; full screen horizontal scroll mode
	
	vdp_mode_register4:	equ $8C00
	vdp_320px_screen_width:	equ vdp_mode_register4+$81	; 320px wide screen mode
	vdp_256px_screen_width:	equ vdp_mode_register4		; 256px wide screen mode
	vdp_shadow_highlight:	equ vdp_mode_register4+8	; enable shadow/highlight mode
	vdp_interlace:		equ vdp_mode_register4+2	; enable interlace mode
	vdp_interlace_x2:	equ vdp_mode_register4+6	; enable double height interlace mode (e.g. Sonic 2 two player game)
	
	vdp_hscroll_table:	equ $8D00			; horizontal scroll table setting
	vdp_nametable_hi:	equ $8E00			; high bits of fg/bg nametable settings for 128kB VRAM
	vdp_auto_inc:		equ $8F00			; value added to VDP address after each write
	
	vdp_plane_size:		equ $9000			; fg/bg plane dimensions
	vdp_plane_height_128:	equ vdp_plane_size+$30		; height = 128 cells (1024px)
	vdp_plane_height_64:	equ vdp_plane_size+$10		; height = 64 cells (512px)
	vdp_plane_height_32:	equ vdp_plane_size		; height = 32 cells (256px)
	vdp_plane_width_128:	equ vdp_plane_size+3		; width = 128 cells (1024px)
	vdp_plane_width_64:	equ vdp_plane_size+1		; width = 64 cells (512px)
	vdp_plane_width_32:	equ vdp_plane_size		; width = 32 cells (256px)
	
	vdp_window_x_pos:	equ $9100
	vdp_window_right:	equ vdp_window_x_pos+$80	; draw window from x pos to right edge of screen
	vdp_window_left:	equ vdp_window_x_pos		; draw window from x pos to left edge of screen
	
	vdp_window_y_pos:	equ $9200
	vdp_window_bottom:	equ vdp_window_y_pos+$80	; draw window from y pos to bottom edge of screen
	vdp_window_top:		equ vdp_window_y_pos		; draw window from y pos to top edge of screen
	
	vdp_dma_length_low:	equ $9300
	vdp_dma_length_hi:	equ $9400
	vdp_dma_source_low:	equ $9500
	vdp_dma_source_mid:	equ $9600
	vdp_dma_source_hi:	equ $9700
	vdp_dma_68k_copy:	equ vdp_dma_source_hi		; DMA 68k to VRAM copy mode
	vdp_dma_vram_fill:	equ vdp_dma_source_hi+$80	; DMA VRAM fill mode
	vdp_dma_vram_copy:	equ vdp_dma_source_hi+$C0	; DMA VRAM to VRAM copy mode

vdp_counter:		equ $C00008

psg_input:		equ $C00011

debug_reg:		equ $C0001C

; Z80 addresses
z80_ram:		equ $A00000				; start of Z80 RAM
z80_dac3_pitch:		equ $A000EA
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
z80_ram_end:		equ $A02000				; end of non-reserved Z80 RAM
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

; I/O addresses
console_version:	equ $A10001
port_1_data_hi:		equ $A10002
port_1_data:		equ $A10003
port_2_data_hi:		equ $A10004
port_2_data:		equ $A10005
port_e_data_hi:		equ $A10006
port_e_data:		equ $A10007
port_1_control_hi:	equ $A10008
port_1_control:		equ $A10009
port_2_control_hi:	equ $A1000A
port_2_control:		equ $A1000B
port_e_control_hi:	equ $A1000C
port_e_control:		equ $A1000D

; Z80 addresses
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200

; Bank registers, et al
sram_access_reg:	equ $A130F1
bank_reg_1:		equ $A130F3				; Bank register for address $80000-$FFFFF
bank_reg_2:		equ $A130F5				; Bank register for address $100000-$17FFFF
bank_reg_3:		equ $A130F7				; Bank register for address $180000-$1FFFFF
bank_reg_4:		equ $A130F9				; Bank register for address $200000-$27FFFF
bank_reg_5:		equ $A130FB				; Bank register for address $280000-$2FFFFF
bank_reg_6:		equ $A130FD				; Bank register for address $300000-$37FFFF
bank_reg_7:		equ $A130FF				; Bank register for address $380000-$3FFFFF
tmss_sega:		equ $A14000				; contains the string "SEGA"
tmss_reg:		equ $A14101

; Memory sizes
sizeof_ram:		equ $10000
sizeof_vram:		equ $10000
sizeof_vsram:		equ $50
sizeof_z80_ram:		equ z80_ram_end-z80_ram			; $2000

; ---------------------------------------------------------------------------
; stop the Z80
; ---------------------------------------------------------------------------

stopZ80:	macros
		move.w	#$100,(z80_bus_request).l

; ---------------------------------------------------------------------------
; wait for Z80 to stop
; ---------------------------------------------------------------------------

waitZ80:	macro
	.wait\@:
		btst	#0,(z80_bus_request).l
		bne.s	.wait\@
		endm

; ---------------------------------------------------------------------------
; start the Z80
; ---------------------------------------------------------------------------

startZ80:	macros
		move.w	#0,(z80_bus_request).l

; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

resetZ80_assert: macros
		move.w	#0,(z80_reset).l

resetZ80_release: macros
		move.w	#$100,(z80_reset).l

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macros
		move	#$2700,sr

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macros
		move	#$2300,sr

; ---------------------------------------------------------------------------
; bankswitch between SRAM and ROM
; (remember to enable SRAM in the header first!)
; ---------------------------------------------------------------------------

gotoSRAM:	macros
		move.b  #1,(sram_access_reg).l

gotoROM:	macros
		move.b  #0,(sram_access_reg).l

