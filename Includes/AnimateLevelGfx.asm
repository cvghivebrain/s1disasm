; ---------------------------------------------------------------------------
; Subroutine to	load uncompressed gfx for level animations & giant ring

; output:
;	a6 = vdp_data_port ($C00000)
;	uses d0, d1, d2, d3, a1, a2, a3, a4
; ---------------------------------------------------------------------------

AnimateLevelGfx:
		tst.w	(f_pause).w				; is the game paused?
		bne.s	.ispaused				; if yes, branch
		lea	(vdp_data_port).l,a6
		bsr.w	LoadArt_GiantRing			; load giant ring gfx if needed
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	AniArt_Index(pc,d0.w),d0
		jmp	AniArt_Index(pc,d0.w)

	.ispaused:
		rts	

; ===========================================================================
AniArt_Index:	index offset(*)
		ptr AniArt_GHZ
		ptr AniArt_none
		ptr AniArt_MZ
		ptr AniArt_none
		ptr AniArt_none
		ptr AniArt_SBZ
		zonewarning AniArt_Index,2
		ptr AniArt_Ending

; ---------------------------------------------------------------------------
; Animated pattern routine - Green Hill
; ---------------------------------------------------------------------------

AniArt_GHZ:

AniArt_GHZ_Waterfall:

tilecount:	= 8						; number of tiles per frame

		subq.b	#1,(v_levelani_0_time).w		; decrement timer
		bpl.s	AniArt_GHZ_Bigflower			; branch if not 0

		move.b	#5,(v_levelani_0_time).w		; time to display each frame
		lea	(Art_GhzWater).l,a1			; load waterfall patterns
		move.b	(v_levelani_0_frame).w,d0
		addq.b	#1,(v_levelani_0_frame).w		; increment frame counter
		andi.w	#1,d0					; there are only 2 frames
		beq.s	.isframe0				; branch if frame 0
		lea	tilecount*sizeof_cell(a1),a1		; use graphics for frame 1

	.isframe0:
		locVRAM	$6F00					; VRAM address
		move.w	#tilecount-1,d1				; number of 8x8	tiles
		bra.w	LoadTiles
; ===========================================================================

AniArt_GHZ_Bigflower:

tilecount:	= 16						; number of tiles per frame

		subq.b	#1,(v_levelani_1_time).w
		bpl.s	AniArt_GHZ_Smallflower

		move.b	#$F,(v_levelani_1_time).w
		lea	(Art_GhzFlower1).l,a1			; load big flower patterns
		move.b	(v_levelani_1_frame).w,d0
		addq.b	#1,(v_levelani_1_frame).w
		andi.w	#1,d0					; there are only 2 frames
		beq.s	.isframe0
		lea	tilecount*sizeof_cell(a1),a1

	.isframe0:
		locVRAM	$6B80
		move.w	#tilecount-1,d1
		bra.w	LoadTiles
; ===========================================================================

AniArt_GHZ_Smallflower:

tilecount:	= 12						; number of tiles per frame

		subq.b	#1,(v_levelani_2_time).w		; decrement timer
		bpl.s	.end					; branch if not -1

		move.b	#7,(v_levelani_2_time).w
		move.b	(v_levelani_2_frame).w,d0
		addq.b	#1,(v_levelani_2_frame).w		; increment frame counter
		andi.w	#3,d0					; there are 4 frames
		move.b	.sequence(pc,d0.w),d0			; get actual frame number from list
		btst	#0,d0					; is frame 0 or 2? (actual frame, not frame counter)
		bne.s	.isframe1				; if not, branch
		move.b	#$7F,(v_levelani_2_time).w		; set longer duration for frames 0 and 2

	.isframe1:
		lsl.w	#7,d0					; multiply frame num by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; multiply that by 3 (i.e. 12 tiles per frame)
		locVRAM	$6D80
		lea	(Art_GhzFlower2).l,a1			; load small flower patterns
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#tilecount-1,d1
		bsr.w	LoadTiles

	.end:
		rts	

.sequence:	dc.b 0,	1, 2, 1

; ---------------------------------------------------------------------------
; Animated pattern routine - Marble
; ---------------------------------------------------------------------------

AniArt_MZ:

AniArt_MZ_Lava:

tilecount:	= 8						; number of tiles per frame

		subq.b	#1,(v_levelani_0_time).w		; decrement timer
		bpl.s	AniArt_MZ_Magma				; branch if not -1

		move.b	#$13,(v_levelani_0_time).w		; time to display each frame
		lea	(Art_MzLava1).l,a1			; lava surface gfx
		moveq	#0,d0
		move.b	(v_levelani_0_frame).w,d0
		addq.b	#1,d0					; increment frame counter
		cmpi.b	#3,d0					; there are 3 frames
		bne.s	.frame01or2				; branch if frame 0, 1 or 2
		moveq	#0,d0					; wrap to 0 if 3

	.frame01or2:
		move.b	d0,(v_levelani_0_frame).w
		mulu.w	#tilecount*sizeof_cell,d0
		adda.w	d0,a1					; jump to appropriate tile
		locVRAM	$5C40
		move.w	#tilecount-1,d1
		bsr.w	LoadTiles

AniArt_MZ_Magma:

tilecount:	= 4						; 4 per column, 16 total

		subq.b	#1,(v_levelani_1_time).w		; decrement timer
		bpl.s	AniArt_MZ_Torch				; branch if not -1
		
		move.b	#1,(v_levelani_1_time).w		; time between each gfx change
		moveq	#0,d0
		move.b	(v_levelani_0_frame).w,d0		; get surface lava frame number
		lea	(Art_MzLava2).l,a4			; magma gfx
		ror.w	#7,d0					; multiply frame num by $200
		adda.w	d0,a4					; jump to appropriate tile
		locVRAM	$5A40
		moveq	#0,d3
		move.b	(v_levelani_1_frame).w,d3
		addq.b	#1,(v_levelani_1_frame).w		; increment frame counter (unused)
		move.b	(v_oscillating_0_to_40).w,d3		; get oscillating value
		move.w	#4-1,d2					; number of columns of tiles

	.loop:
		move.w	d3,d0
		add.w	d0,d0
		andi.w	#$1E,d0					; d0 = low nybble of oscillating value * 2
		lea	(AniArt_MZ_Magma_Index).l,a3
		move.w	(a3,d0.w),d0
		lea	(a3,d0.w),a3
		movea.l	a4,a1					; a1 = magma gfx
		move.w	#((tilecount*sizeof_cell)/4)-1,d1	; $1F
		jsr	(a3)					; copy gfx to VRAM
		addq.w	#4,d3					; increment initial oscillating value
		dbf	d2,.loop				; repeat 3 times
		rts	
; ===========================================================================

AniArt_MZ_Torch:

tilecount:	= 6						; number of tiles per frame

		subq.b	#1,(v_levelani_2_time).w		; decrement timer
		bpl.w	.end					; branch if not 0
		
		move.b	#7,(v_levelani_2_time).w		; time to display each frame
		lea	(Art_MzTorch).l,a1			; torch gfx
		moveq	#0,d0
		move.b	(v_levelani_3_frame).w,d0
		addq.b	#1,(v_levelani_3_frame).w		; increment frame counter
		andi.b	#3,(v_levelani_3_frame).w		; there are 4 frames
		mulu.w	#tilecount*sizeof_cell,d0
		adda.w	d0,a1					; jump to appropriate tile
		locVRAM	$5E40
		move.w	#tilecount-1,d1
		bra.w	LoadTiles

.end:
		rts

; ---------------------------------------------------------------------------
; Animated pattern routine - Scrap Brain
; ---------------------------------------------------------------------------

AniArt_SBZ:

tilecount:	= 12						; number of tiles per frame

		tst.b	(v_levelani_2_frame).w
		beq.s	.smokepuff				; branch if counter hits 0
		
		subq.b	#1,(v_levelani_2_frame).w		; decrement counter
		bra.s	.chk_smokepuff2
; ===========================================================================

.smokepuff:
		subq.b	#1,(v_levelani_0_time).w		; decrement timer
		bpl.s	.chk_smokepuff2				; branch if not 0
		
		move.b	#7,(v_levelani_0_time).w		; time to display each frame
		lea	(Art_SbzSmoke).l,a1			; smoke gfx
		locVRAM	$8900
		move.b	(v_levelani_0_frame).w,d0
		addq.b	#1,(v_levelani_0_frame).w		; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff				; branch if frame 0
		subq.w	#1,d0
		mulu.w	#tilecount*sizeof_cell,d0
		lea	(a1,d0.w),a1
		move.w	#tilecount-1,d1
		bra.w	LoadTiles
; ===========================================================================

.untilnextpuff:
		move.b	#180,(v_levelani_2_frame).w		; time between smoke puffs (3 seconds)

.clearsky:
		move.w	#(tilecount/2)-1,d1
		bsr.w	LoadTiles
		lea	(Art_SbzSmoke).l,a1
		move.w	#(tilecount/2)-1,d1
		bra.w	LoadTiles				; load blank tiles for no smoke puff
; ===========================================================================

.chk_smokepuff2:
		tst.b	(v_levelani_2_time).w
		beq.s	.smokepuff2				; branch if counter hits 0
		
		subq.b	#1,(v_levelani_2_time).w		; decrement counter
		bra.s	.end
; ===========================================================================

.smokepuff2:
		subq.b	#1,(v_levelani_1_time).w		; decrement timer
		bpl.s	.end					; branch if not 0
		
		move.b	#7,(v_levelani_1_time).w		; time to display each frame
		lea	(Art_SbzSmoke).l,a1			; smoke gfx
		locVRAM	$8A80
		move.b	(v_levelani_1_frame).w,d0
		addq.b	#1,(v_levelani_1_frame).w		; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff2				; branch if frame 0
		subq.w	#1,d0
		mulu.w	#tilecount*sizeof_cell,d0
		lea	(a1,d0.w),a1
		move.w	#tilecount-1,d1
		bra.w	LoadTiles
; ===========================================================================

.untilnextpuff2:
		move.b	#120,(v_levelani_2_time).w		; time between smoke puffs (2 seconds)
		bra.s	.clearsky
; ===========================================================================

.end:
		rts

; ---------------------------------------------------------------------------
; Animated pattern routine - ending sequence
; ---------------------------------------------------------------------------

AniArt_Ending:

AniArt_Ending_BigFlower:

tilecount:	= 16						; number of tiles per frame

		subq.b	#1,(v_levelani_1_time).w		; decrement timer
		bpl.s	AniArt_Ending_SmallFlower		; branch if not 0
		
		move.b	#7,(v_levelani_1_time).w
		lea	(Art_GhzFlower1).l,a1			; big flower gfx
		lea	(v_ghz_flower_buffer).w,a2		; load 2nd big flower from RAM
		move.b	(v_levelani_1_frame).w,d0
		addq.b	#1,(v_levelani_1_frame).w		; increment frame counter
		andi.w	#1,d0					; only 2 frames
		beq.s	.isframe0				; branch if frame 0
		lea	tilecount*sizeof_cell(a1),a1
		lea	tilecount*sizeof_cell(a2),a2

	.isframe0:
		locVRAM	$6B80
		move.w	#tilecount-1,d1
		bsr.w	LoadTiles
		movea.l	a2,a1
		locVRAM	$7200
		move.w	#tilecount-1,d1
		bra.w	LoadTiles
; ===========================================================================

AniArt_Ending_SmallFlower:

tilecount:	= 12						; number of tiles per frame

		subq.b	#1,(v_levelani_2_time).w		; decrement timer
		bpl.s	AniArt_Ending_Flower3			; branch if not 0
		
		move.b	#7,(v_levelani_2_time).w
		move.b	(v_levelani_2_frame).w,d0
		addq.b	#1,(v_levelani_2_frame).w		; increment frame counter
		andi.w	#7,d0					; max 8 frames
		move.b	.sequence(pc,d0.w),d0			; get actual frame num from sequence data
		lsl.w	#7,d0					; multiply by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; multiply by 3
		locVRAM	$6D80
		lea	(Art_GhzFlower2).l,a1			; small flower gfx
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#tilecount-1,d1
		bra.w	LoadTiles
		
.sequence:	dc.b 0,	0, 0, 1, 2, 2, 2, 1

; ===========================================================================

AniArt_Ending_Flower3:

tilecount:	= 16						; number of tiles per frame

		subq.b	#1,(v_levelani_4_time).w		; decrement timer
		bpl.s	AniArt_Ending_Flower4			; branch if not 0
		
		move.b	#$E,(v_levelani_4_time).w
		move.b	(v_levelani_4_frame).w,d0
		addq.b	#1,(v_levelani_4_frame).w		; increment frame counter
		andi.w	#3,d0					; max 4 frames
		move.b	AniArt_Ending_Flower3_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0					; multiply by $100
		add.w	d0,d0					; multiply by 2
		locVRAM	$7000
		lea	(v_ghz_flower_buffer+$400).w,a1		; special flower gfx (from RAM)
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#tilecount-1,d1
		bra.w	LoadTiles

AniArt_Ending_Flower3_sequence:	dc.b 0,	1, 2, 1

; ===========================================================================

AniArt_Ending_Flower4:

tilecount:	= 16						; number of tiles per frame

		subq.b	#1,(v_levelani_5_time).w		; decrement timer
		bpl.s	.end					; branch if not 0
		
		move.b	#$B,(v_levelani_5_time).w
		move.b	(v_levelani_5_frame).w,d0
		addq.b	#1,(v_levelani_5_frame).w		; increment frame counter
		andi.w	#3,d0
		move.b	AniArt_Ending_Flower3_sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#8,d0					; multiply by $100
		add.w	d0,d0					; multiply by 2
		locVRAM	$6800
		lea	(v_ghz_flower_buffer+$A00).w,a1		; load special flower patterns (from RAM)
		lea	(a1,d0.w),a1				; jump to appropriate tile
		move.w	#tilecount-1,d1
		bra.w	LoadTiles

.end:
		rts	
; ===========================================================================

AniArt_none:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	transfer graphics to VRAM

; input:
;	a1 = source address
;	a6 = vdp_data_port ($C00000)
;	d1 = number of tiles to load (minus one)
; ---------------------------------------------------------------------------

LoadTiles:
		rept sizeof_cell/4
		move.l	(a1)+,(a6)				; copy 1 tile to VRAM
		endr
		dbf	d1,LoadTiles				; repeat for number of tiles
		rts

; ---------------------------------------------------------------------------
; Subroutines to animate MZ magma

; input:
;	d1 = number of longwords to write to VRAM
;	a1 = address of magma gfx (stored as 32x32 image)
;	a6 = vdp_data_port ($C00000)

;	uses d0
; ---------------------------------------------------------------------------

AniArt_MZ_Magma_Index:
		index offset(*)
		ptr AniArt_MZ_Magma_Shift0_Col0
		ptr AniArt_MZ_Magma_Shift1_Col0
		ptr AniArt_MZ_Magma_Shift2_Col0
		ptr AniArt_MZ_Magma_Shift3_Col0
		ptr AniArt_MZ_Magma_Shift0_Col1
		ptr AniArt_MZ_Magma_Shift1_Col1
		ptr AniArt_MZ_Magma_Shift2_Col1
		ptr AniArt_MZ_Magma_Shift3_Col1
		ptr AniArt_MZ_Magma_Shift0_Col2
		ptr AniArt_MZ_Magma_Shift1_Col2
		ptr AniArt_MZ_Magma_Shift2_Col2
		ptr AniArt_MZ_Magma_Shift3_Col2
		ptr AniArt_MZ_Magma_Shift0_Col3
		ptr AniArt_MZ_Magma_Shift1_Col3
		ptr AniArt_MZ_Magma_Shift2_Col3
		ptr AniArt_MZ_Magma_Shift3_Col3
; ===========================================================================

AniArt_MZ_Magma_Shift0_Col0:
		move.l	(a1),(a6)				; write 8px row to VRAM
		lea	$10(a1),a1				; read next 32px row from source
		dbf	d1,AniArt_MZ_Magma_Shift0_Col0		; repeat for column of 4 tiles
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift1_Col0:
		move.l	2(a1),d0
		move.b	1(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col0
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift2_Col0:
		move.l	2(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col0
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift3_Col0:
		move.l	4(a1),d0
		move.b	3(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col0
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift0_Col1:
		move.l	4(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col1
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift1_Col1:
		move.l	6(a1),d0
		move.b	5(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col1
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift2_Col1:
		move.l	6(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col1
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift3_Col1:
		move.l	8(a1),d0
		move.b	7(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col1
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift0_Col2:
		move.l	8(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col2
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift1_Col2:
		move.l	$A(a1),d0
		move.b	9(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col2
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift2_Col2:
		move.l	$A(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col2
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift3_Col2:
		move.l	$C(a1),d0
		move.b	$B(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col2
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift0_Col3:
		move.l	$C(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift0_Col3
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift1_Col3:
		move.l	$C(a1),d0
		rol.l	#8,d0
		move.b	0(a1),d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift1_Col3
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift2_Col3:
		move.w	$E(a1),(a6)
		move.w	0(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift2_Col3
		rts	
; ===========================================================================

AniArt_MZ_Magma_Shift3_Col3:
		move.l	0(a1),d0
		move.b	$F(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,AniArt_MZ_Magma_Shift3_Col3
		rts	

; ---------------------------------------------------------------------------
; Subroutine to load gfx for giant ring, 14 tiles per frame over 7 frames

; input:
;	a6 = vdp_data_port

;	uses d0, d1, a1
; ---------------------------------------------------------------------------

LoadArt_GiantRing:

tilecount:	= (sizeof_Art_BigRing/sizeof_cell)/7		; number of tiles to load per frame over 7 frames (14)

		tst.w	(v_giantring_gfx_offset).w		; $C40 is written here by GiantRing (98 tiles)
		bne.s	.loadTiles				; branch if not 0
		rts	
; ===========================================================================

.loadTiles:
		subi.w	#tilecount*sizeof_cell,(v_giantring_gfx_offset).w ; count down the 14 tiles we're going to load now
		lea	(Art_BigRing).l,a1			; giant ring gfx
		moveq	#0,d0
		move.w	(v_giantring_gfx_offset).w,d0
		lea	(a1,d0.w),a1				; jump to gfx for relevant section (this counts backwards)
		addi.w	#vram_giantring,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0					; d0 = VDP command for address vram_giantring + v_giantring_gfx_offset
		move.l	d0,4(a6)				; write to control port

		move.w	#tilecount-1,d1
		bra.w	LoadTiles				; load 14 tiles each time this subroutine runs
