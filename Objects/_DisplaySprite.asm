; ---------------------------------------------------------------------------
; Subroutine to	display	a sprite/object
;
; input:
;	a0 = address of OST for object
; ---------------------------------------------------------------------------

DisplaySprite:
		lea	(v_sprite_queue).w,a1
		move.w	ost_priority(a0),d0			; get sprite priority (as high byte of a word)
		lsr.w	#1,d0					; d0 = priority * $80
		andi.w	#$380,d0
		adda.w	d0,a1					; jump to position in queue
		cmpi.w	#$7E,(a1)				; is this part of the queue full?
		bcc.s	@full					; if yes, branch
		addq.w	#2,(a1)					; increment sprite count
		adda.w	(a1),a1					; jump to empty position
		move.w	a0,(a1)					; insert RAM address for object

	@full:
		rts	

; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	display	a 2nd sprite/object
;
; input:
;	a1 = address of OST for object
; ---------------------------------------------------------------------------

DisplaySprite_a1:
		lea	(v_sprite_queue).w,a2
		move.w	ost_priority(a1),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bcc.s	@full
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

	@full:
		rts	

; End of function DisplaySprite_a1
