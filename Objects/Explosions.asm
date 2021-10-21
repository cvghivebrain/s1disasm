; ---------------------------------------------------------------------------
; Object 27 - explosion	from a destroyed enemy or monitor
; ---------------------------------------------------------------------------

ExplosionItem:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	ExItem_Index(pc,d0.w),d1
		jmp	ExItem_Index(pc,d1.w)
; ===========================================================================
ExItem_Index:	index *,,2
		ptr ExItem_Animal
		ptr ExItem_Main
		ptr ExItem_Animate
; ===========================================================================

ExItem_Animal:	; Routine 0
		addq.b	#2,ost_routine(a0)
		bsr.w	FindFreeObj
		bne.s	ExItem_Main
		move.b	#id_Animals,0(a1) ; load animal object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_enemy_combo(a0),ost_enemy_combo(a1)

ExItem_Main:	; Routine 2
		addq.b	#2,ost_routine(a0)
		move.l	#Map_ExplodeItem,ost_mappings(a0)
		move.w	#tile_Nem_Explode,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0) ; set frame duration to 7 frames
		move.b	#id_frame_ex_0,ost_frame(a0)
		sfx	sfx_Break,0,0,0 ; play breaking enemy sound

ExItem_Animate:	; Routine 4 (2 for ExplosionBomb)
ExBom_Animate:
		subq.b	#1,ost_anim_time(a0) ; subtract 1 from frame duration
		bpl.s	@display
		move.b	#7,ost_anim_time(a0) ; set frame duration to 7 frames
		addq.b	#1,ost_frame(a0) ; next frame
		cmpi.b	#5,ost_frame(a0) ; is the final frame (05) displayed?
		beq.w	DeleteObject	; if yes, branch

	@display:
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3F - explosion	from a destroyed boss, bomb or cannonball
; ---------------------------------------------------------------------------

ExplosionBomb:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	ExBom_Index(pc,d0.w),d1
		jmp	ExBom_Index(pc,d1.w)
; ===========================================================================
ExBom_Index:	index *,,2
		ptr ExBom_Main
		ptr ExBom_Animate
; ===========================================================================

ExBom_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_ExplodeBomb,ost_mappings(a0)
		move.w	#tile_Nem_Explode,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0)
		move.b	#id_frame_ex_0_0,ost_frame(a0)
		sfx	sfx_Bomb,1,0,0	; play exploding bomb sound
