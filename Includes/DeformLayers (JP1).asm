; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeformLayers:
		tst.b	(f_disable_scrolling).w
		beq.s	@bgscroll
		rts	
; ===========================================================================

	@bgscroll:
		clr.w	(v_fg_redraw_direction).w
		clr.w	(v_bg1_redraw_direction).w
		clr.w	(v_bg2_redraw_direction).w
		clr.w	(v_bg3_redraw_direction).w
		bsr.w	ScrollHorizontal
		bsr.w	ScrollVertical
		bsr.w	DynamicLevelEvents
		move.w	(v_camera_y_pos).w,(v_fg_y_pos_vsram).w
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; End of function DeformLayers

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	index *
		ptr Deform_GHZ
		ptr Deform_LZ
		ptr Deform_MZ
		ptr Deform_SLZ
		ptr Deform_SYZ
		ptr Deform_SBZ
		zonewarning Deform_Index,2
		ptr Deform_GHZ
; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_GHZ:
	; block 3 - distant mountains
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block3
	; block 2 - hills & waterfalls
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block2
	; calculate Y position
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_camera_y_pos).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	@limitY
		moveq	#0,d0
	@limitY:
		move.w	d0,d4
		move.w	d0,(v_bg_y_pos_vsram).w
		move.w	(v_camera_x_pos).w,d0
		cmpi.b	#id_Title,(v_gamemode).w
		bne.s	@notTitle
		moveq	#0,d0					; reset foreground position in title screen
	@notTitle:
		neg.w	d0
		swap	d0
	; auto-scroll clouds
		lea	(v_bgscroll_buffer).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
	; calculate background scroll	
		move.w	(v_bgscroll_buffer).w,d0
		add.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	@gotoCloud2
	@cloudLoop1:						; upper cloud (32px)
		move.l	d0,(a1)+
		dbf	d1,@cloudLoop1

	@gotoCloud2:
		move.w	(v_bgscroll_buffer+4).w,d0
		add.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#$F,d1
	@cloudLoop2:						; middle cloud (16px)
		move.l	d0,(a1)+
		dbf	d1,@cloudLoop2

		move.w	(v_bgscroll_buffer+8).w,d0
		add.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#$F,d1
	@cloudLoop3:						; lower cloud (16px)
		move.l	d0,(a1)+
		dbf	d1,@cloudLoop3

		move.w	#$2F,d1
		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
	@mountainLoop:						; distant mountains (48px)
		move.l	d0,(a1)+
		dbf	d1,@mountainLoop

		move.w	#$27,d1
		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
	@hillLoop:						; hills & waterfalls (40px)
		move.l	d0,(a1)+
		dbf	d1,@hillLoop

		move.w	(v_bg2_x_pos).w,d0
		move.w	(v_camera_x_pos).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1
	@waterLoop:						; water deformation
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,@waterLoop
		rts
; End of function Deform_GHZ

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_LZ:
	; plain background scroll
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_XY

		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
		lea	(Lz_Scroll_Data).l,a3			; get foreground wobble data
		lea	(Drown_WobbleData).l,a2			; get background wobble data
		move.b	(v_water_ripple_y_pos).w,d2		; get high byte of y pos. of wobble effect
		move.b	d2,d3
		addi.w	#$80,(v_water_ripple_y_pos).w		; high byte increments every other frame

		add.w	(v_bg1_y_pos).w,d2
		andi.w	#$FF,d2
		add.w	(v_camera_y_pos).w,d3
		andi.w	#$FF,d3
		lea	(v_hscroll_buffer).w,a1
		move.w	#$DF,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		move.w	(v_water_height_actual).w,d4
		move.w	(v_camera_y_pos).w,d5
	; write normal scroll before meeting water position
	@normalLoop:		
		cmp.w	d4,d5					; is current y >= water y?
		bge.s	@underwaterLoop				; if yes, branch
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,@normalLoop
		rts
	; apply water deformation when underwater
	@underwaterLoop:
		move.b	(a3,d3),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,@underwaterLoop
		rts

Lz_Scroll_Data:
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; End of function Deform_LZ

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_MZ:
	; block 1 - dungeon interior
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#redraw_bottom,d6
		bsr.w	BGScroll_Block1
	; block 3 - mountains
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#redraw_bottom+redraw_left,d6
		bsr.w	BGScroll_Block3
	; block 2 - bushes & antique buildings
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#redraw_left,d6
		bsr.w	BGScroll_Block2
	; calculate y-position of background
		move.w	#$200,d0				; start with 512px, ignoring 2 chunks
		move.w	(v_camera_y_pos).w,d1
		subi.w	#$1C8,d1				; 0% scrolling when y <= 56px 
		bcs.s	@noYscroll
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0
	@noYscroll:
		move.w	d0,(v_bg2_y_pos).w
		move.w	d0,(v_bg3_y_pos).w
		bsr.w	BGScroll_YAbsolute
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
	; do something with redraw flags
		move.b	(v_bg1_redraw_direction).w,d0
		or.b	(v_bg2_redraw_direction).w,d0
		or.b	d0,(v_bg3_redraw_direction).w
		clr.b	(v_bg1_redraw_direction).w
		clr.b	(v_bg2_redraw_direction).w
	; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#2,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#5,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#4,d1
	@cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@cloudLoop

		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#1,d1
	@mountainLoop:		
		move.w	d0,(a1)+
		dbf	d1,@mountainLoop

		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
		move.w	#8,d1
	@bushLoop:		
		move.w	d0,(a1)+
		dbf	d1,@bushLoop

		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		move.w	#$F,d1
	@interiorLoop:		
		move.w	d0,(a1)+
		dbf	d1,@interiorLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		subi.w	#$200,d0				; subtract 512px (unused 2 chunks)
		move.w	d0,d2
		cmpi.w	#$100,d0
		bcs.s	@limitY
		move.w	#$100,d0
	@limitY:
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
; End of function Deform_MZ

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ:
	; vertical scrolling
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	Bg_Scroll_Y
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
	; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1
	@starLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@starLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#4,d1
	@buildingLoop1:						; distant black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop1

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
	@buildingLoop2:						; closer buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop2

		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1
	@bottomLoop:						; bottom part of background
		move.w	d0,(a1)+
		dbf	d1,@bottomLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Bg_Scroll_X:
		lea	(v_hscroll_buffer).w,a1
		move.w	#$E,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	@pixelJump(pc,d2.w)			; skip pixels for first row
	@blockLoop:
		move.w	(a2)+,d0
	@pixelJump:		
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,@blockLoop
		rts

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SYZ:
	; vertical scrolling
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	Bg_Scroll_Y
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
	; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#7,d1
	@cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@cloudLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1
	@mountainLoop:		
		move.w	d0,(a1)+
		dbf	d1,@mountainLoop

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5,d1
	@buildingLoop:		
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop

		move.w	d2,d0
		move.w	d2,d1
		asr.w	#1,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$E,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#$D,d1
	@bushLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@bushLoop

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
; End of function Deform_SYZ

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SBZ:
		tst.b	(v_act).w
		bne.w	Deform_SBZ2
	; block 1 - lower black buildings
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#redraw_bottom,d6
		bsr.w	BGScroll_Block1
	; block 3 - distant brown buildings
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#redraw_bottom+redraw_left,d6
		bsr.w	BGScroll_Block3
	; block 2 - upper black buildings
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#redraw_left,d6
		bsr.w	BGScroll_Block2
	; vertical scrolling
		moveq	#0,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_YRelative

		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,(v_bg2_y_pos).w
		move.w	d0,(v_bg3_y_pos).w
		move.w	d0,(v_bg_y_pos_vsram).w
		move.b	(v_bg1_redraw_direction).w,d0
		or.b	(v_bg3_redraw_direction).w,d0
		or.b	d0,(v_bg2_redraw_direction).w
		clr.b	(v_bg1_redraw_direction).w
		clr.b	(v_bg3_redraw_direction).w
	; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		asr.w	#2,d2
		move.w	d2,d0
		asr.w	#1,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#4,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#3,d1
	@cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@cloudLoop

		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#9,d1
	@buildingLoop1:						; distant brown buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop1

		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
		move.w	#6,d1
	@buildingLoop2:						; upper black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop2

		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		move.w	#$A,d1
	@buildingLoop3:						; lower black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop3
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
;-------------------------------------------------------------------------------
Deform_SBZ2:;loc_68A2:
	; plain background deformation
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4		
		asl.l	#6,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_XY
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
	; copy fg & bg x-position to hscroll table
		lea	(v_hscroll_buffer).w,a1
		move.w	#223,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
	@loop:		
		move.l	d0,(a1)+
		dbf	d1,@loop
		rts
; End of function Deform_SBZ
