; ---------------------------------------------------------------------------
; Dynamic level events

;	uses d0, d1, a1
; ---------------------------------------------------------------------------

DynamicLevelEvents:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w)			; run level-specific events
		moveq	#2,d1
		move.w	(v_boundary_bottom_next).w,d0		; new boundary y pos is written here
		sub.w	(v_boundary_bottom).w,d0
		beq.s	.keep_boundary				; branch if boundary is where it should be
		bcc.s	.move_boundary_down			; branch if new boundary is below current one

		neg.w	d1
		move.w	(v_camera_y_pos).w,d0
		cmp.w	(v_boundary_bottom_next).w,d0
		bls.s	.camera_below				; branch if camera y pos is above boundary
		move.w	d0,(v_boundary_bottom).w		; match boundary to camera
		andi.w	#$FFFE,(v_boundary_bottom).w		; round down to nearest 2px

	.camera_below:
		add.w	d1,(v_boundary_bottom).w		; move boundary up 2px
		move.b	#1,(f_boundary_bottom_change).w

	.keep_boundary:
		rts	
; ===========================================================================

.move_boundary_down:
		move.w	(v_camera_y_pos).w,d0
		addq.w	#8,d0
		cmp.w	(v_boundary_bottom).w,d0
		bcs.s	.down_2px				; branch if boundary is at least 8px below camera
		btst	#status_air_bit,(v_ost_player+ost_status).w
		beq.s	.down_2px				; branch if Sonic isn't in the air
		add.w	d1,d1
		add.w	d1,d1					; boundary moves 8px instead of 2px

	.down_2px:
		add.w	d1,(v_boundary_bottom).w		; move boundary down 2px (or 8px)
		move.b	#1,(f_boundary_bottom_change).w
		rts

; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	index offset(*)
		ptr DLE_GHZ
		ptr DLE_LZ
		ptr DLE_MZ
		ptr DLE_SLZ
		ptr DLE_SYZ
		ptr DLE_SBZ
		zonewarning DLE_Index,2
		ptr DLE_Ending

; ---------------------------------------------------------------------------
; Green	Hill Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_GHZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_GHZx(pc,d0.w),d0
		jmp	DLE_GHZx(pc,d0.w)
; ===========================================================================
DLE_GHZx:	index offset(*)
		ptr DLE_GHZ1
		ptr DLE_GHZ2
		ptr DLE_GHZ3
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_boundary_bottom_next).w	; initial boundary
		cmpi.w	#$1780,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1780

		move.w	#$400,(v_boundary_bottom_next).w	; set lower y-boundary

	.exit:
		rts	
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_boundary_bottom_next).w
		cmpi.w	#$ED0,(v_camera_x_pos).w
		bcs.s	.exit

		move.w	#$200,(v_boundary_bottom_next).w
		cmpi.w	#$1600,(v_camera_x_pos).w
		bcs.s	.exit

		move.w	#$400,(v_boundary_bottom_next).w
		cmpi.w	#$1D60,(v_camera_x_pos).w
		bcs.s	.exit

		move.w	#$300,(v_boundary_bottom_next).w

	.exit:
		rts	
; ===========================================================================

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_GHZ3_Index(pc,d0.w),d0
		jmp	DLE_GHZ3_Index(pc,d0.w)
; ===========================================================================
DLE_GHZ3_Index:	index offset(*)
		ptr DLE_GHZ3_Main
		ptr DLE_GHZ3_Boss
		ptr DLE_GHZ3_End
; ===========================================================================

DLE_GHZ3_Main:
		move.w	#$300,(v_boundary_bottom_next).w
		cmpi.w	#$380,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $380

		move.w	#$310,(v_boundary_bottom_next).w
		cmpi.w	#$960,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $960

		cmpi.w	#$280,(v_camera_y_pos).w
		bcs.s	.final_section				; branch if camera is above $280

		move.w	#$400,(v_boundary_bottom_next).w
		cmpi.w	#$1380,(v_camera_x_pos).w
		bcc.s	.skip_underground			; branch if camera is right of $1380

		move.w	#$4C0,(v_boundary_bottom_next).w
		move.w	#$4C0,(v_boundary_bottom).w

	.skip_underground:
		cmpi.w	#$1700,(v_camera_x_pos).w
		bcc.s	.final_section				; branch if camera is right of $1700

	.exit:
		rts	
; ===========================================================================

.final_section:
		move.w	#$300,(v_boundary_bottom_next).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Boss next
		rts	
; ===========================================================================

DLE_GHZ3_Boss:
		cmpi.w	#$960,(v_camera_x_pos).w
		bcc.s	.dont_return				; branch if camera is right of $960
		subq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Main next

	.dont_return:
		cmpi.w	#$2960,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $2960
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossGreenHill,ost_id(a1)		; load GHZ boss	object
		move.w	#$2A60,ost_x_pos(a1)
		move.w	#$280,ost_y_pos(a1)

	.fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_End next
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts	
; ===========================================================================

DLE_GHZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w	; set boundary to current position
		rts

; ---------------------------------------------------------------------------
; Labyrinth Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_LZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_LZx(pc,d0.w),d0
		jmp	DLE_LZx(pc,d0.w)
; ===========================================================================
DLE_LZx:	index offset(*)
		ptr DLE_LZ12
		ptr DLE_LZ12
		ptr DLE_LZ3
		ptr DLE_SBZ3
; ===========================================================================

DLE_LZ12:
		rts						; no events for acts 1/2
; ===========================================================================

DLE_LZ3:
		tst.b	(v_button_state+$F).w			; has switch $F	been pressed?
		beq.s	.skip_layout				; if not, branch
		lea	(v_level_layout+(sizeof_levelrow*2)+6).w,a1 ; address of layout at row 2, column 6
		cmpi.b	#7,(a1)
		beq.s	.skip_layout				; branch if already modified
		move.b	#7,(a1)					; modify level layout
		play.w	1, bsr.w, sfx_Rumbling			; play rumbling sound

	.skip_layout:
		tst.b	(v_dle_routine).w
		bne.s	.skip_boss				; branch if boss is already loaded
		cmpi.w	#$1CA0,(v_camera_x_pos).w
		bcs.s	.skip_boss2				; branch if camera is left of $1CA0
		cmpi.w	#$600,(v_camera_y_pos).w
		bcc.s	.skip_boss2				; branch if camera is below $600

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossLabyrinth,ost_id(a1)		; load LZ boss object

	.fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; don't load boss again
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.skip_boss2:
		rts	
; ===========================================================================

.skip_boss:
		rts	
; ===========================================================================

DLE_SBZ3:
		cmpi.w	#$D00,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $D00
		cmpi.w	#$18,(v_ost_player+ost_y_pos).w		; has Sonic reached the top of the level?
		bcc.s	.exit					; if not, branch

		clr.b	(v_last_lamppost).w
		move.w	#1,(f_restart).w			; restart level
		move.w	#id_FZ,(v_zone).w			; set level number to 0502 (FZ)
		move.b	#1,(v_lock_multi).w			; lock controls, position & animation

	.exit:
		rts

; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_MZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_MZx(pc,d0.w),d0
		jmp	DLE_MZx(pc,d0.w)
; ===========================================================================
DLE_MZx:	index offset(*)
		ptr DLE_MZ1
		ptr DLE_MZ2
		ptr DLE_MZ3
; ===========================================================================

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_MZ1_Index(pc,d0.w),d0
		jmp	DLE_MZ1_Index(pc,d0.w)
; ===========================================================================
DLE_MZ1_Index:	index offset(*)
		ptr DLE_MZ1_0
		ptr DLE_MZ1_2
		ptr DLE_MZ1_4
		ptr DLE_MZ1_6
; ===========================================================================

DLE_MZ1_0:
		move.w	#$1D0,(v_boundary_bottom_next).w
		cmpi.w	#$700,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $700

		move.w	#$220,(v_boundary_bottom_next).w
		cmpi.w	#$D00,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $D00

		move.w	#$340,(v_boundary_bottom_next).w
		cmpi.w	#$340,(v_camera_y_pos).w
		bcs.s	.exit					; branch if camera is above $340

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_2 next

	.exit:
		rts	
; ===========================================================================

DLE_MZ1_2:
		cmpi.w	#$340,(v_camera_y_pos).w
		bcc.s	.next					; branch if camera is below $340

		subq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_0 next
		rts	
; ===========================================================================

.next:
		move.w	#0,(v_boundary_top).w
		cmpi.w	#$E00,(v_camera_x_pos).w
		bcc.s	.exit					; branch if camera is right of $E00

		move.w	#$340,(v_boundary_top).w
		move.w	#$340,(v_boundary_bottom_next).w
		cmpi.w	#$A90,(v_camera_x_pos).w
		bcc.s	.exit					; branch if camera is right of $A90

		move.w	#$500,(v_boundary_bottom_next).w
		cmpi.w	#$370,(v_camera_y_pos).w
		bcs.s	.exit					; branch if camera is above $370

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_4 next

	.exit:
		rts	
; ===========================================================================

DLE_MZ1_4:
		cmpi.w	#$370,(v_camera_y_pos).w
		bcc.s	.next					; branch if camera is below $370

		subq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_2 next
		rts	
; ===========================================================================

.next:
		cmpi.w	#$500,(v_camera_y_pos).w
		bcs.s	.exit					; branch if camera is above $500
		if Revision=0
		else
			cmpi.w	#$B80,(v_camera_x_pos).w
			bcs.s	.exit				; branch if camera is left of $B80
		endc
		move.w	#$500,(v_boundary_top).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_6 next

	.exit:
		rts	
; ===========================================================================

DLE_MZ1_6:
		if Revision=0
		else
			cmpi.w	#$B80,(v_camera_x_pos).w
			bcc.s	.skip_mid			; branch if camera is right of $B80

			cmpi.w	#$340,(v_boundary_top).w
			beq.s	.exit				; branch if top boundary is set for middle section

			subq.w	#2,(v_boundary_top).w		; move top boundary up 2px
			rts
	.skip_mid:
			cmpi.w	#$500,(v_boundary_top).w
			beq.s	.skip_btm			; branch if top boundary is set for bottom section

			cmpi.w	#$500,(v_camera_y_pos).w
			bcs.s	.exit				; branch if camera is above $500

			move.w	#$500,(v_boundary_top).w
	.skip_btm:
		endc

		cmpi.w	#$E70,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $E70

		move.w	#0,(v_boundary_top).w
		move.w	#$500,(v_boundary_bottom_next).w
		cmpi.w	#$1430,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1430

		move.w	#$210,(v_boundary_bottom_next).w

	.exit:
		rts	
; ===========================================================================

DLE_MZ2:
		move.w	#$520,(v_boundary_bottom_next).w
		cmpi.w	#$1700,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1700

		move.w	#$200,(v_boundary_bottom_next).w

	.exit:
		rts	
; ===========================================================================

DLE_MZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_MZ3_Index(pc,d0.w),d0
		jmp	DLE_MZ3_Index(pc,d0.w)
; ===========================================================================
DLE_MZ3_Index:	index offset(*)
		ptr DLE_MZ3_Boss
		ptr DLE_MZ3_End
; ===========================================================================

DLE_MZ3_Boss:
		move.w	#$720,(v_boundary_bottom_next).w
		cmpi.w	#$1560,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1560

		move.w	#$210,(v_boundary_bottom_next).w
		cmpi.w	#$17F0,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $17F0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossMarble,ost_id(a1)		; load MZ boss object
		move.w	#$19F0,ost_x_pos(a1)
		move.w	#$22C,ost_y_pos(a1)

	.fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ3_End next
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts	
; ===========================================================================

DLE_MZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w	; set boundary to current position
		rts

; ---------------------------------------------------------------------------
; Star Light Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SLZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SLZx(pc,d0.w),d0
		jmp	DLE_SLZx(pc,d0.w)
; ===========================================================================
DLE_SLZx:	index offset(*)
		ptr DLE_SLZ12
		ptr DLE_SLZ12
		ptr DLE_SLZ3
; ===========================================================================

DLE_SLZ12:
		rts						; no events for acts 1/2
; ===========================================================================

DLE_SLZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SLZ3_Index(pc,d0.w),d0
		jmp	DLE_SLZ3_Index(pc,d0.w)
; ===========================================================================
DLE_SLZ3_Index:	index offset(*)
		ptr DLE_SLZ3_Main
		ptr DLE_SLZ3_Boss
		ptr DLE_SLZ3_End
; ===========================================================================

DLE_SLZ3_Main:
		cmpi.w	#$1E70,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1E70

		move.w	#$210,(v_boundary_bottom_next).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_SLZ3_Boss next

	.exit:
		rts	
; ===========================================================================

DLE_SLZ3_Boss:
		cmpi.w	#$2000,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $2000

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossStarLight,(a1)			; load SLZ boss object

	.fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_SLZ3_End next
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts	
; ===========================================================================

DLE_SLZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w	; set boundary to current position
		rts
		rts

; ---------------------------------------------------------------------------
; Spring Yard Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SYZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SYZx(pc,d0.w),d0
		jmp	DLE_SYZx(pc,d0.w)
; ===========================================================================
DLE_SYZx:	index offset(*)
		ptr DLE_SYZ1
		ptr DLE_SYZ2
		ptr DLE_SYZ3
; ===========================================================================

DLE_SYZ1:
		rts						; no events for act 1	
; ===========================================================================

DLE_SYZ2:
		move.w	#$520,(v_boundary_bottom_next).w
		cmpi.w	#$25A0,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $25A0

		move.w	#$420,(v_boundary_bottom_next).w
		cmpi.w	#$4D0,(v_ost_player+ost_y_pos).w
		bcs.s	.exit					; branch if Sonic is above $4D0

		move.w	#$520,(v_boundary_bottom_next).w

	.exit:
		rts	
; ===========================================================================

DLE_SYZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SYZ3_Index(pc,d0.w),d0
		jmp	DLE_SYZ3_Index(pc,d0.w)
; ===========================================================================
DLE_SYZ3_Index:	index offset(*)
		ptr DLE_SYZ3_Main
		ptr DLE_SYZ3_Boss
		ptr DLE_SYZ3_End
; ===========================================================================

DLE_SYZ3_Main:
		cmpi.w	#$2AC0,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $2AC0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.exit					; branch if not found
		move.b	#id_BossBlock,(a1)			; load blocks that boss picks up
		addq.b	#2,(v_dle_routine).w			; goto DLE_SYZ3_Boss next

	.exit:
		rts	
; ===========================================================================

DLE_SYZ3_Boss:
		cmpi.w	#$2C00,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $2C00

		move.w	#$4CC,(v_boundary_bottom_next).w
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_BossSpringYard,(a1)			; load SYZ boss	object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SYZ3_End next

	.fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts	
; ===========================================================================

DLE_SYZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w	; set boundary to current position
		rts

; ---------------------------------------------------------------------------
; Scrap	Brain Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SBZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SBZx(pc,d0.w),d0
		jmp	DLE_SBZx(pc,d0.w)
; ===========================================================================
DLE_SBZx:	index offset(*)
		ptr DLE_SBZ1
		ptr DLE_SBZ2
		ptr DLE_FZ
; ===========================================================================

DLE_SBZ1:
		move.w	#$720,(v_boundary_bottom_next).w
		cmpi.w	#$1880,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1880

		move.w	#$620,(v_boundary_bottom_next).w
		cmpi.w	#$2000,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $2000

		move.w	#$2A0,(v_boundary_bottom_next).w

	.exit:
		rts	
; ===========================================================================

DLE_SBZ2:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_SBZ2_Index(pc,d0.w),d0
		jmp	DLE_SBZ2_Index(pc,d0.w)
; ===========================================================================
DLE_SBZ2_Index:	index offset(*)
		ptr DLE_SBZ2_Main
		ptr DLE_SBZ2_Blocks
		ptr DLE_SBZ2_Eggman
		ptr DLE_SBZ2_End
; ===========================================================================

DLE_SBZ2_Main:
		move.w	#$800,(v_boundary_bottom_next).w
		cmpi.w	#$1800,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1800

		move.w	#$510,(v_boundary_bottom_next).w
		cmpi.w	#$1E00,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1E00

		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_Blocks next

	.exit:
		rts	
; ===========================================================================

DLE_SBZ2_Blocks:
		cmpi.w	#$1EB0,(v_camera_x_pos).w
		bcs.s	.exit					; branch if camera is left of $1EB0

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.exit					; branch if not found
		move.b	#id_FalseFloor,(a1)			; load collapsing block object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_Eggman next
		moveq	#id_PLC_EggmanSBZ2,d0
		bra.w	AddPLC					; load SBZ2 Eggman gfx
; ===========================================================================

.exit:
		rts	
; ===========================================================================

DLE_SBZ2_Eggman:
		cmpi.w	#$1F60,(v_camera_x_pos).w
		bcs.s	.set_boundary				; branch if camera is left of $1F60

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_ScrapEggman,(a1)			; load SBZ2 Eggman object
		addq.b	#2,(v_dle_routine).w			; goto DLE_SBZ2_End next

	.fail:
		move.b	#1,(f_boss_boundary).w			; lock screen

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_SBZ2_End:
		cmpi.w	#$2050,(v_camera_x_pos).w
		bcs.s	DLE_SBZ2_SetBoundary			; branch if camera is left of $2050
		rts	
; ===========================================================================

DLE_SBZ2_SetBoundary:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w	; set boundary to current position
		rts	
; ===========================================================================

DLE_FZ:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_FZ_Index(pc,d0.w),d0
		jmp	DLE_FZ_Index(pc,d0.w)
; ===========================================================================
DLE_FZ_Index:	index offset(*)
		ptr DLE_FZ_Main
		ptr DLE_FZ_Boss
		ptr DLE_FZ_Arena
		ptr DLE_FZ_Wait
		ptr DLE_FZ_End
; ===========================================================================

DLE_FZ_Main:
		cmpi.w	#$2148,(v_camera_x_pos).w
		bcs.s	.set_boundary				; branch if camera is left of $2148

		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Boss next
		moveq	#id_PLC_FZBoss,d0
		bsr.w	AddPLC					; load FZ boss gfx

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Boss:
		cmpi.w	#$2300,(v_camera_x_pos).w
		bcs.s	.set_boundary				; branch if camera is left of $2300

		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.set_boundary				; branch if not found
		move.b	#id_BossFinal,(a1)			; load FZ boss object
		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Arena next
		move.b	#1,(f_boss_boundary).w			; lock screen

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Arena:
		cmpi.w	#$2450,(v_camera_x_pos).w		; boss arena is here
		bcs.s	.set_boundary				; branch if camera is left of $2450

		addq.b	#2,(v_dle_routine).w			; goto DLE_FZ_Wait next

	.set_boundary:
		bra.s	DLE_SBZ2_SetBoundary
; ===========================================================================

DLE_FZ_Wait:
		rts						; wait until boss is beaten
; ===========================================================================

DLE_FZ_End:
		bra.s	DLE_SBZ2_SetBoundary			; allow scrolling right

; ---------------------------------------------------------------------------
; Ending sequence dynamic level events (empty)
; ---------------------------------------------------------------------------

DLE_Ending:
		rts	
