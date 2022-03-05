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
		beq.s	@keep_boundary				; branch if boundary is where it should be
		bcc.s	@move_boundary_down			; branch if new boundary is below current one

		neg.w	d1
		move.w	(v_camera_y_pos).w,d0
		cmp.w	(v_boundary_bottom_next).w,d0
		bls.s	@camera_below				; branch if camera y pos is above boundary
		move.w	d0,(v_boundary_bottom).w		; match boundary to camera
		andi.w	#$FFFE,(v_boundary_bottom).w		; round down to nearest 2px

	@camera_below:
		add.w	d1,(v_boundary_bottom).w		; move boundary up 2px
		move.b	#1,(f_boundary_bottom_change).w

	@keep_boundary:
		rts	
; ===========================================================================

@move_boundary_down:
		move.w	(v_camera_y_pos).w,d0
		addq.w	#8,d0
		cmp.w	(v_boundary_bottom).w,d0
		bcs.s	@down_2px				; branch if boundary is at least 8px below camera
		btst	#status_air_bit,(v_ost_player+ost_status).w
		beq.s	@down_2px				; branch if Sonic isn't in the air
		add.w	d1,d1
		add.w	d1,d1					; boundary moves 8px instead of 2px

	@down_2px:
		add.w	d1,(v_boundary_bottom).w		; move boundary down 2px (or 8px)
		move.b	#1,(f_boundary_bottom_change).w
		rts

; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	index *
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
DLE_GHZx:	index *
		ptr DLE_GHZ1
		ptr DLE_GHZ2
		ptr DLE_GHZ3
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_boundary_bottom_next).w	; initial boundary
		cmpi.w	#$1780,(v_camera_x_pos).w
		bcs.s	@exit					; branch if camera is left of $1780

		move.w	#$400,(v_boundary_bottom_next).w	; set lower y-boundary

	@exit:
		rts	
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_boundary_bottom_next).w
		cmpi.w	#$ED0,(v_camera_x_pos).w
		bcs.s	@exit

		move.w	#$200,(v_boundary_bottom_next).w
		cmpi.w	#$1600,(v_camera_x_pos).w
		bcs.s	@exit

		move.w	#$400,(v_boundary_bottom_next).w
		cmpi.w	#$1D60,(v_camera_x_pos).w
		bcs.s	@exit

		move.w	#$300,(v_boundary_bottom_next).w

	@exit:
		rts	
; ===========================================================================

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_GHZ3_Index(pc,d0.w),d0
		jmp	DLE_GHZ3_Index(pc,d0.w)
; ===========================================================================
DLE_GHZ3_Index:	index *
		ptr DLE_GHZ3_Main
		ptr DLE_GHZ3_Boss
		ptr DLE_GHZ3_End
; ===========================================================================

DLE_GHZ3_Main:
		move.w	#$300,(v_boundary_bottom_next).w
		cmpi.w	#$380,(v_camera_x_pos).w
		bcs.s	@exit					; branch if camera is left of $380

		move.w	#$310,(v_boundary_bottom_next).w
		cmpi.w	#$960,(v_camera_x_pos).w
		bcs.s	@exit					; branch if camera is left of $960

		cmpi.w	#$280,(v_camera_y_pos).w
		bcs.s	@final_section				; branch if camera is above $280

		move.w	#$400,(v_boundary_bottom_next).w
		cmpi.w	#$1380,(v_camera_x_pos).w
		bcc.s	@skip_underground			; branch if camera is right of $1380

		move.w	#$4C0,(v_boundary_bottom_next).w
		move.w	#$4C0,(v_boundary_bottom).w

	@skip_underground:
		cmpi.w	#$1700,(v_camera_x_pos).w
		bcc.s	@final_section				; branch if camera is right of $1700

	@exit:
		rts	
; ===========================================================================

@final_section:
		move.w	#$300,(v_boundary_bottom_next).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Boss next
		rts	
; ===========================================================================

DLE_GHZ3_Boss:
		cmpi.w	#$960,(v_camera_x_pos).w
		bcc.s	@dont_return				; branch if camera is right of $960
		subq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Main next

	@dont_return:
		cmpi.w	#$2960,(v_camera_x_pos).w
		bcs.s	@exit					; branch if camera is left of $2960
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_BossGreenHill,ost_id(a1)		; load GHZ boss	object
		move.w	#$2A60,ost_x_pos(a1)
		move.w	#$280,ost_y_pos(a1)

	@fail:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_End next
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

@exit:
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
DLE_LZx:	index *
		ptr DLE_LZ12
		ptr DLE_LZ12
		ptr DLE_LZ3
		ptr DLE_SBZ3
; ===========================================================================

DLE_LZ12:
		rts	
; ===========================================================================

DLE_LZ3:
		tst.b	(v_button_state+$F).w			; has switch $F	been pressed?
		beq.s	loc_6F28				; if not, branch
		lea	(v_level_layout+$106).w,a1
		cmpi.b	#7,(a1)
		beq.s	loc_6F28
		move.b	#7,(a1)					; modify level layout
		play.w	1, bsr.w, sfx_Rumbling			; play rumbling sound

loc_6F28:
		tst.b	(v_dle_routine).w
		bne.s	locret_6F64
		cmpi.w	#$1CA0,(v_camera_x_pos).w
		bcs.s	locret_6F62
		cmpi.w	#$600,(v_camera_y_pos).w
		bcc.s	locret_6F62
		bsr.w	FindFreeObj
		bne.s	loc_6F4A
		move.b	#id_BossLabyrinth,ost_id(a1)		; load LZ boss object

loc_6F4A:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss patterns
; ===========================================================================

locret_6F62:
		rts	
; ===========================================================================

locret_6F64:
		rts	
; ===========================================================================

DLE_SBZ3:
		cmpi.w	#$D00,(v_camera_x_pos).w
		bcs.s	locret_6F8C
		cmpi.w	#$18,(v_ost_player+ost_y_pos).w		; has Sonic reached the top of the level?
		bcc.s	locret_6F8C				; if not, branch
		clr.b	(v_last_lamppost).w
		move.w	#1,(f_restart).w			; restart level
		move.w	#(id_SBZ<<8)+2,(v_zone).w		; set level number to 0502 (FZ)
		move.b	#1,(v_lock_multi).w			; freeze Sonic

locret_6F8C:
		rts	
; ===========================================================================
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
DLE_MZx:	index *
		ptr DLE_MZ1
		ptr DLE_MZ2
		ptr DLE_MZ3
; ===========================================================================

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_6FB2(pc,d0.w),d0
		jmp	off_6FB2(pc,d0.w)
; ===========================================================================
off_6FB2:	index *
		ptr loc_6FBA
		ptr loc_6FEA
		ptr loc_702E
		ptr loc_7050
; ===========================================================================

loc_6FBA:
		move.w	#$1D0,(v_boundary_bottom_next).w
		cmpi.w	#$700,(v_camera_x_pos).w
		bcs.s	locret_6FE8
		move.w	#$220,(v_boundary_bottom_next).w
		cmpi.w	#$D00,(v_camera_x_pos).w
		bcs.s	locret_6FE8
		move.w	#$340,(v_boundary_bottom_next).w
		cmpi.w	#$340,(v_camera_y_pos).w
		bcs.s	locret_6FE8
		addq.b	#2,(v_dle_routine).w

locret_6FE8:
		rts	
; ===========================================================================

loc_6FEA:
		cmpi.w	#$340,(v_camera_y_pos).w
		bcc.s	loc_6FF8
		subq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

loc_6FF8:
		move.w	#0,(v_boundary_top).w
		cmpi.w	#$E00,(v_camera_x_pos).w
		bcc.s	locret_702C
		move.w	#$340,(v_boundary_top).w
		move.w	#$340,(v_boundary_bottom_next).w
		cmpi.w	#$A90,(v_camera_x_pos).w
		bcc.s	locret_702C
		move.w	#$500,(v_boundary_bottom_next).w
		cmpi.w	#$370,(v_camera_y_pos).w
		bcs.s	locret_702C
		addq.b	#2,(v_dle_routine).w

locret_702C:
		rts	
; ===========================================================================

loc_702E:
		cmpi.w	#$370,(v_camera_y_pos).w
		bcc.s	loc_703C
		subq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

loc_703C:
		cmpi.w	#$500,(v_camera_y_pos).w
		bcs.s	locret_704E
		if Revision=0
		else
			cmpi.w	#$B80,(v_camera_x_pos).w
			bcs.s	locret_704E
		endc
		move.w	#$500,(v_boundary_top).w
		addq.b	#2,(v_dle_routine).w

locret_704E:
		rts	
; ===========================================================================

loc_7050:
		if Revision=0
		else
			cmpi.w	#$B80,(v_camera_x_pos).w
			bcc.s	locj_76B8
			cmpi.w	#$340,(v_boundary_top).w
			beq.s	locret_7072
			subq.w	#2,(v_boundary_top).w
			rts
	locj_76B8:
			cmpi.w	#$500,(v_boundary_top).w
			beq.s	locj_76CE
			cmpi.w	#$500,(v_camera_y_pos).w
			bcs.s	locret_7072
			move.w	#$500,(v_boundary_top).w
	locj_76CE:
		endc

		cmpi.w	#$E70,(v_camera_x_pos).w
		bcs.s	locret_7072
		move.w	#0,(v_boundary_top).w
		move.w	#$500,(v_boundary_bottom_next).w
		cmpi.w	#$1430,(v_camera_x_pos).w
		bcs.s	locret_7072
		move.w	#$210,(v_boundary_bottom_next).w

locret_7072:
		rts	
; ===========================================================================

DLE_MZ2:
		move.w	#$520,(v_boundary_bottom_next).w
		cmpi.w	#$1700,(v_camera_x_pos).w
		bcs.s	locret_7088
		move.w	#$200,(v_boundary_bottom_next).w

locret_7088:
		rts	
; ===========================================================================

DLE_MZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7098(pc,d0.w),d0
		jmp	off_7098(pc,d0.w)
; ===========================================================================
off_7098:	index *
		ptr DLE_MZ3_Boss
		ptr DLE_MZ3_End
; ===========================================================================

DLE_MZ3_Boss:
		move.w	#$720,(v_boundary_bottom_next).w
		cmpi.w	#$1560,(v_camera_x_pos).w
		bcs.s	locret_70E8
		move.w	#$210,(v_boundary_bottom_next).w
		cmpi.w	#$17F0,(v_camera_x_pos).w
		bcs.s	locret_70E8
		bsr.w	FindFreeObj
		bne.s	loc_70D0
		move.b	#id_BossMarble,ost_id(a1)		; load MZ boss object
		move.w	#$19F0,ost_x_pos(a1)
		move.w	#$22C,ost_y_pos(a1)

loc_70D0:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss patterns
; ===========================================================================

locret_70E8:
		rts	
; ===========================================================================

DLE_MZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w
		rts	
; ===========================================================================
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
DLE_SLZx:	index *
		ptr DLE_SLZ12
		ptr DLE_SLZ12
		ptr DLE_SLZ3
; ===========================================================================

DLE_SLZ12:
		rts	
; ===========================================================================

DLE_SLZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7118(pc,d0.w),d0
		jmp	off_7118(pc,d0.w)
; ===========================================================================
off_7118:	index *
		ptr DLE_SLZ3_Main
		ptr DLE_SLZ3_Boss
		ptr DLE_SLZ3_End
; ===========================================================================

DLE_SLZ3_Main:
		cmpi.w	#$1E70,(v_camera_x_pos).w
		bcs.s	locret_7130
		move.w	#$210,(v_boundary_bottom_next).w
		addq.b	#2,(v_dle_routine).w

locret_7130:
		rts	
; ===========================================================================

DLE_SLZ3_Boss:
		cmpi.w	#$2000,(v_camera_x_pos).w
		bcs.s	locret_715C
		bsr.w	FindFreeObj
		bne.s	loc_7144
		move.b	#id_BossStarLight,(a1)			; load SLZ boss object

loc_7144:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss patterns
; ===========================================================================

locret_715C:
		rts	
; ===========================================================================

DLE_SLZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w
		rts
		rts
; ===========================================================================
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
DLE_SYZx:	index *
		ptr DLE_SYZ1
		ptr DLE_SYZ2
		ptr DLE_SYZ3
; ===========================================================================

DLE_SYZ1:
		rts	
; ===========================================================================

DLE_SYZ2:
		move.w	#$520,(v_boundary_bottom_next).w
		cmpi.w	#$25A0,(v_camera_x_pos).w
		bcs.s	locret_71A2
		move.w	#$420,(v_boundary_bottom_next).w
		cmpi.w	#$4D0,(v_ost_player+ost_y_pos).w
		bcs.s	locret_71A2
		move.w	#$520,(v_boundary_bottom_next).w

locret_71A2:
		rts	
; ===========================================================================

DLE_SYZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_71B2(pc,d0.w),d0
		jmp	off_71B2(pc,d0.w)
; ===========================================================================
off_71B2:	index *
		ptr DLE_SYZ3_Main
		ptr DLE_SYZ3_Boss
		ptr DLE_SYZ3_End
; ===========================================================================

DLE_SYZ3_Main:
		cmpi.w	#$2AC0,(v_camera_x_pos).w
		bcs.s	locret_71CE
		bsr.w	FindFreeObj
		bne.s	locret_71CE
		move.b	#id_BossBlock,(a1)			; load blocks that boss picks up
		addq.b	#2,(v_dle_routine).w

locret_71CE:
		rts	
; ===========================================================================

DLE_SYZ3_Boss:
		cmpi.w	#$2C00,(v_camera_x_pos).w
		bcs.s	locret_7200
		move.w	#$4CC,(v_boundary_bottom_next).w
		bsr.w	FindFreeObj
		bne.s	loc_71EC
		move.b	#id_BossSpringYard,(a1)			; load SYZ boss	object
		addq.b	#2,(v_dle_routine).w

loc_71EC:
		play.w	0, bsr.w, mus_Boss			; play boss music
		move.b	#1,(f_boss_boundary).w			; lock screen
		moveq	#id_PLC_Boss,d0
		bra.w	AddPLC					; load boss patterns
; ===========================================================================

locret_7200:
		rts	
; ===========================================================================

DLE_SYZ3_End:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w
		rts	
; ===========================================================================
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
DLE_SBZx:	index *
		ptr DLE_SBZ1
		ptr DLE_SBZ2
		ptr DLE_FZ
; ===========================================================================

DLE_SBZ1:
		move.w	#$720,(v_boundary_bottom_next).w
		cmpi.w	#$1880,(v_camera_x_pos).w
		bcs.s	locret_7242
		move.w	#$620,(v_boundary_bottom_next).w
		cmpi.w	#$2000,(v_camera_x_pos).w
		bcs.s	locret_7242
		move.w	#$2A0,(v_boundary_bottom_next).w

locret_7242:
		rts	
; ===========================================================================

DLE_SBZ2:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7252(pc,d0.w),d0
		jmp	off_7252(pc,d0.w)
; ===========================================================================
off_7252:	index *
		ptr DLE_SBZ2main
		ptr DLE_SBZ2boss
		ptr DLE_SBZ2boss2
		ptr DLE_SBZ2end
; ===========================================================================

DLE_SBZ2main:
		move.w	#$800,(v_boundary_bottom_next).w
		cmpi.w	#$1800,(v_camera_x_pos).w
		bcs.s	locret_727A
		move.w	#$510,(v_boundary_bottom_next).w
		cmpi.w	#$1E00,(v_camera_x_pos).w
		bcs.s	locret_727A
		addq.b	#2,(v_dle_routine).w

locret_727A:
		rts	
; ===========================================================================

DLE_SBZ2boss:
		cmpi.w	#$1EB0,(v_camera_x_pos).w
		bcs.s	locret_7298
		bsr.w	FindFreeObj
		bne.s	locret_7298
		move.b	#id_FalseFloor,(a1)			; load collapsing block object
		addq.b	#2,(v_dle_routine).w
		moveq	#id_PLC_EggmanSBZ2,d0
		bra.w	AddPLC					; load SBZ2 Eggman patterns
; ===========================================================================

locret_7298:
		rts	
; ===========================================================================

DLE_SBZ2boss2:
		cmpi.w	#$1F60,(v_camera_x_pos).w
		bcs.s	loc_72B6
		bsr.w	FindFreeObj
		bne.s	loc_72B0
		move.b	#id_ScrapEggman,(a1)			; load SBZ2 Eggman object
		addq.b	#2,(v_dle_routine).w

loc_72B0:
		move.b	#1,(f_boss_boundary).w			; lock screen

loc_72B6:
		bra.s	loc_72C2
; ===========================================================================

DLE_SBZ2end:
		cmpi.w	#$2050,(v_camera_x_pos).w
		bcs.s	loc_72C2
		rts	
; ===========================================================================

loc_72C2:
		move.w	(v_camera_x_pos).w,(v_boundary_left).w
		rts	
; ===========================================================================

DLE_FZ:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_72D8(pc,d0.w),d0
		jmp	off_72D8(pc,d0.w)
; ===========================================================================
off_72D8:	index *
		ptr DLE_FZmain
		ptr DLE_FZboss
		ptr DLE_FZend
		ptr locret_7322
		ptr DLE_FZend2
; ===========================================================================

DLE_FZmain:
		cmpi.w	#$2148,(v_camera_x_pos).w
		bcs.s	loc_72F4
		addq.b	#2,(v_dle_routine).w
		moveq	#id_PLC_FZBoss,d0
		bsr.w	AddPLC					; load FZ boss patterns

loc_72F4:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZboss:
		cmpi.w	#$2300,(v_camera_x_pos).w
		bcs.s	loc_7312
		bsr.w	FindFreeObj
		bne.s	loc_7312
		move.b	#id_BossFinal,(a1)			; load FZ boss object
		addq.b	#2,(v_dle_routine).w
		move.b	#1,(f_boss_boundary).w			; lock screen

loc_7312:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZend:
		cmpi.w	#$2450,(v_camera_x_pos).w
		bcs.s	loc_7320
		addq.b	#2,(v_dle_routine).w

loc_7320:
		bra.s	loc_72C2
; ===========================================================================

locret_7322:
		rts	
; ===========================================================================

DLE_FZend2:
		bra.s	loc_72C2
; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence dynamic level events (empty)
; ---------------------------------------------------------------------------

DLE_Ending:
		rts	
