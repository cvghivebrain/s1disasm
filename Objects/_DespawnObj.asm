; ---------------------------------------------------------------------------
; Routine to check if object is still on-screen: display if yes, delete if not
; ---------------------------------------------------------------------------

DespawnObj:
		out_of_range	@offscreen			; branch if object moves off screen
		bra.w	DisplaySprite				; display instead of despawn

	@offscreen:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0			; get respawn id
		beq.s	@delete					; branch if not set
		bclr	#7,2(a2,d0.w)				; clear high bit of respawn entry (i.e. object was despawned not broken)

	@delete:
		bra.w	DeleteObject				; delete the object
