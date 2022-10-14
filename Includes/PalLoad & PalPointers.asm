; ---------------------------------------------------------------------------
; Subroutines to load palette that will be used after fading in

; input:
;	d0.w = index number for palette

;	uses d0.w, d7.w, a1, a2, a3
; ---------------------------------------------------------------------------

PalLoad_Next:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		adda.w	#v_pal_dry_next-v_pal_dry,a3		; jump to next palette RAM address
		move.w	(a1)+,d7				; get length of palette data

	.loop:
		move.l	(a2)+,(a3)+				; move data to RAM
		dbf	d7,.loop
		rts

; ---------------------------------------------------------------------------
; Subroutines to load palette immediately

; input:
;	d0.w = index number for palette

;	uses d0.w, d7.w, a1, a2, a3
; ---------------------------------------------------------------------------

PalLoad_Now:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		move.w	(a1)+,d7				; get length of palette

	.loop:
		move.l	(a2)+,(a3)+				; move data to RAM
		dbf	d7,.loop
		rts

; ---------------------------------------------------------------------------
; Subroutines to load underwater palette immediately

; input:
;	d0.w = index number for palette

;	uses d0.w, d7.w, a1, a2, a3
; ---------------------------------------------------------------------------

PalLoad_Water:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		suba.w	#v_pal_dry-v_pal_water,a3		; jump to underwater palette RAM address
		move.w	(a1)+,d7				; get length of palette data

	.loop:
		move.l	(a2)+,(a3)+				; move data to RAM
		dbf	d7,.loop
		rts

; ---------------------------------------------------------------------------
; Subroutines to load underwater palette that will be used after fading in

; input:
;	d0.w = index number for palette

;	uses d0.w, d7.w, a1, a2, a3
; ---------------------------------------------------------------------------

PalLoad_Water_Next:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2				; get palette data address
		movea.w	(a1)+,a3				; get target RAM address
		suba.w	#v_pal_dry-v_pal_water_next,a3		; jump to next underwater palette RAM address
		move.w	(a1)+,d7				; get length of palette data

	.loop:
		move.l	(a2)+,(a3)+				; move data to RAM
		dbf	d7,.loop
		rts

; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:		macro paladdress,ramaddress,colours
		id_\paladdress:	equ (*-PalPointers)/8
		dc.l paladdress
		dc.w ramaddress, (colours>>1)-1
		endm

PalPointers:

;			palette address, RAM address, number of colours

		palp	Pal_SegaBG,v_pal_dry_line1,$40		; 0 - Sega logo
		palp	Pal_Title,v_pal_dry_line1,$40		; 1 - title screen
		palp	Pal_LevelSel,v_pal_dry_line1,$40	; 2 - level select
		palp	Pal_Sonic,v_pal_dry_line1,$10		; 3 - Sonic
PalPointers_Levels:
		palp	Pal_GHZ,v_pal_dry_line2,$30		; 4 - GHZ
		palp	Pal_LZ,v_pal_dry_line2,$30		; 5 - LZ
		palp	Pal_MZ,v_pal_dry_line2,$30		; 6 - MZ
		palp	Pal_SLZ,v_pal_dry_line2,$30		; 7 - SLZ
		palp	Pal_SYZ,v_pal_dry_line2,$30		; 8 - SYZ
		palp	Pal_SBZ1,v_pal_dry_line2,$30		; 9 - SBZ1
		zonewarning PalPointers_Levels,8
		palp	Pal_Special,v_pal_dry_line1,$40		; $A (10) - special stage
		palp	Pal_LZWater,v_pal_dry_line1,$40		; $B (11) - LZ underwater
		palp	Pal_SBZ3,v_pal_dry_line2,$30		; $C (12) - SBZ3
		palp	Pal_SBZ3Water,v_pal_dry_line1,$40	; $D (13) - SBZ3 underwater
		palp	Pal_SBZ2,v_pal_dry_line2,$30		; $E (14) - SBZ2
		palp	Pal_LZSonWater,v_pal_dry_line1,$10	; $F (15) - LZ Sonic underwater
		palp	Pal_SBZ3SonWat,v_pal_dry_line1,$10	; $10 (16) - SBZ3 Sonic underwater
		palp	Pal_SSResult,v_pal_dry_line1,$40	; $11 (17) - special stage results
		palp	Pal_Continue,v_pal_dry_line1,$20	; $12 (18) - special stage results continue
		palp	Pal_Ending,v_pal_dry_line1,$40		; $13 (19) - ending sequence
		even
