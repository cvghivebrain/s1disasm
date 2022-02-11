; ---------------------------------------------------------------------------
; Object 27 - explosion	from a destroyed enemy or monitor

; spawned by:
;	ReactToItem - routine 0
;	Monitor - routine 2
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
		addq.b	#2,ost_routine(a0)			; goto ExItem_Main next
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	ExItem_Main				; branch if none found
		move.b	#id_Animals,ost_id(a1)			; load animal object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_enemy_combo(a0),ost_enemy_combo(a1)

ExItem_Main:	; Routine 2
		addq.b	#2,ost_routine(a0)			; goto ExItem_Animate next
		move.l	#Map_ExplodeItem,ost_mappings(a0)
		move.w	#tile_Nem_Explode,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0)			; set frame duration to 7 frames
		move.b	#id_frame_ex_0,ost_frame(a0)
		play.w	1, jsr, sfx_Break			; play breaking enemy sound

ExItem_Animate:	; Routine 4 (2 for ExplosionBomb)
ExBom_Animate:
		subq.b	#1,ost_anim_time(a0)			; subtract 1 from frame duration
		bpl.s	@display
		move.b	#7,ost_anim_time(a0)			; set frame duration to 7 frames
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#5,ost_frame(a0)			; is the final frame (05) displayed?
		beq.w	DeleteObject				; if yes, branch

	@display:
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Object 3F - explosion	from a destroyed boss, bomb or cannonball

; spawned by:
;	Cannonball, Bomb, BossPlasma, BossBall, BossSpikeball, BossExplode, Prison
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
		addq.b	#2,ost_routine(a0)			; goto ExBom_Animate next
		move.l	#Map_ExplodeBomb,ost_mappings(a0)
		move.w	#tile_Nem_Explode,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0)
		move.b	#id_frame_ex_0_0,ost_frame(a0)
		play.w	1, jmp, sfx_Bomb			; play exploding bomb sound
