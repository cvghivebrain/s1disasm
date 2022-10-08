; ---------------------------------------------------------------------------
; Subroutine to	add an object to the sprite queue for display by BuildSprites
;
; input:
;	a0 = address of OST for object

;	uses d0.w, a1
; ---------------------------------------------------------------------------

DisplaySprite:
		lea	(v_sprite_queue).w,a1
		move.w	ost_priority(a0),d0			; get sprite priority (as high byte of a word)
		lsr.w	#1,d0					; d0 = priority * $80
		andi.w	#$380,d0
		adda.w	d0,a1					; jump to priority section in queue
		cmpi.w	#sizeof_priority-2,(a1)			; is this section full? ($7E)
		bcc.s	.full					; if yes, branch
		addq.w	#2,(a1)					; increment sprite count
		adda.w	(a1),a1					; jump to empty position
		move.w	a0,(a1)					; insert RAM address for OST of object

	.full:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	add a child object to the sprite queue
;
; input:
;	a1 = address of OST for object

;	uses d0.w, a2
; ---------------------------------------------------------------------------

DisplaySprite_a1:
		lea	(v_sprite_queue).w,a2
		move.w	ost_priority(a1),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a2
		cmpi.w	#sizeof_priority-2,(a2)
		bcc.s	.full
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

	.full:
		rts
