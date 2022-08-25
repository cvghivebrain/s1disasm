; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		lsl.w	#4,d0					; multiply by 16
		lea	(LevelHeaders).l,a2			; address of level headers
		lea	(a2,d0.w),a2				; jump to relevant level header
		pushr	a2					; save address to stack
		addq.l	#4,a2					; skip to 16x16 mappings pointer
		movea.l	(a2)+,a0				; load pointer
		lea	(v_16x16_tiles).w,a1			; RAM address for 16x16 mappings
		move.w	#0,d0					; value to add to each tile = 0
		bsr.w	EniDec
		movea.l	(a2)+,a0				; load 256x256 mappings pointer
		lea	(v_256x256_tiles).l,a1			; RAM address for 256x256 mappings
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad				; load level layout (doesn't involve level headers)
		move.w	(a2)+,d0				; load music id (unused, overwritten on next line)
		move.w	(a2),d0					; load palette id
		andi.w	#$FF,d0					; read only low byte (high byte was duplicate)
		cmpi.w	#id_SBZ_act3,(v_zone).w			; is level SBZ3 (LZ4) ?
		bne.s	.notSBZ3				; if not, branch
		moveq	#id_Pal_SBZ3,d0				; use SB3 palette

	.notSBZ3:
		cmpi.w	#id_SBZ_act2,(v_zone).w			; is level SBZ2?
		beq.s	.isSBZorFZ				; if yes, branch
		cmpi.w	#id_FZ,(v_zone).w			; is level FZ?
		bne.s	.normalpal				; if not, branch

	.isSBZorFZ:
		moveq	#id_Pal_SBZ2,d0				; use SBZ2/FZ palette

	.normalpal:
		bsr.w	PalLoad_Next				; load palette (based on d0)
		popr	a2				; retrieve level header address from stack
		addq.w	#4,a2					; jump to 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0					; read 2nd PLC id
		beq.s	.skipPLC				; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bsr.w	AddPLC					; load pattern load cues

	.skipPLC:
		rts

; ---------------------------------------------------------------------------
; Level	layout loading subroutine

; Levels are "cropped" in ROM. In RAM the level and background each comprise
; eight $40 byte rows, which are stored alternately.
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		lea	(v_level_layout).w,a3
		move.w	#((v_sprite_queue-v_level_layout)/4)-1,d1
		moveq	#0,d0

	.clear_ram:
		move.l	d0,(a3)+
		dbf	d1,.clear_ram				; clear the RAM ($A400-ABFF)

		lea	(v_level_layout).w,a3			; RAM address for level layout
		moveq	#0,d1
		bsr.w	LevelLayoutLoad2			; load level layout into RAM
		lea	(v_level_layout+level_max_width).w,a3	; RAM address for background layout
		moveq	#2,d1

; "LevelLayoutLoad2" is	run twice - for	the level and the background

LevelLayoutLoad2:
		move.w	(v_zone).w,d0				; get zone & act numbers as word
		lsl.b	#6,d0					; move act number (bits 0/1) next to zone number
		lsr.w	#5,d0					; d0 = zone/act expressed as one byte
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0					; d0 = zone/act * 6 (because level index is 6 bytes per act)
		add.w	d1,d0					; add d1: 0 for level; 2 for background
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1				; jump to actual level data
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1				; load cropped level width (in tiles)
		move.b	(a1)+,d2				; load cropped level height (in tiles)

	.loop_row:
		move.w	d1,d0
		movea.l	a3,a0

	.loop_tile:
		move.b	(a1)+,(a0)+
		dbf	d0,.loop_tile				; load 1 row
		lea	sizeof_levelrow(a3),a3			; do next row
		dbf	d2,.loop_row				; repeat for number of rows
		rts

; ---------------------------------------------------------------------------
; Level Headers
; ---------------------------------------------------------------------------

lhead:		macro plc1,lvlgfx,plc2,sixteen,twofivesix,music,pal
		dc.l (plc1<<24)+lvlgfx
		dc.l (plc2<<24)+sixteen
		dc.l twofivesix
		dc.b 0, music, pal, pal
		endm

include_levelheaders:	macro

LevelHeaders:

; 1st PLC, level gfx (unused), 2nd PLC, 16x16 data, 256x256 data,
; music (unused), palette (unused), palette

;			1st PLC				2nd PLC				256x256 data			palette
;					level gfx*			16x16 data			music*

		lhead	id_PLC_GHZ,	Nem_GHZ_2nd,	id_PLC_GHZ2,	Blk16_GHZ,	Blk256_GHZ,	mus_GHZ,	id_Pal_GHZ ; Green Hill
		lhead	id_PLC_LZ,	Nem_LZ,		id_PLC_LZ2,	Blk16_LZ,	Blk256_LZ,	mus_LZ,		id_Pal_LZ ; Labyrinth
		lhead	id_PLC_MZ,	Nem_MZ,		id_PLC_MZ2,	Blk16_MZ,	Blk256_MZ,	mus_MZ,		id_Pal_MZ ; Marble
		lhead	id_PLC_SLZ,	Nem_SLZ,	id_PLC_SLZ2,	Blk16_SLZ,	Blk256_SLZ,	mus_SLZ,	id_Pal_SLZ ; Star Light
		lhead	id_PLC_SYZ,	Nem_SYZ,	id_PLC_SYZ2,	Blk16_SYZ,	Blk256_SYZ,	mus_SYZ,	id_Pal_SYZ ; Spring Yard
		lhead	id_PLC_SBZ,	Nem_SBZ,	id_PLC_SBZ2,	Blk16_SBZ,	Blk256_SBZ,	mus_SBZ,	id_Pal_SBZ1 ; Scrap Brain
		zonewarning LevelHeaders,$10
		lhead	0,		Nem_GHZ_2nd,	0,		Blk16_GHZ,	Blk256_GHZ,	mus_SBZ,	id_Pal_Ending ; Ending
		even

; * music and level gfx are actually set elsewhere, so these values are useless

		endm
