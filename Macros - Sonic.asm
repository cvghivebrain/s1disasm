; ---------------------------------------------------------------------------
; compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
	@end:
		if (@end-loc)-(ZoneCount*elementsize)<>0
		inform 1,"Size of \loc ($%h) does not match ZoneCount ($\#ZoneCount).",(@end-loc)/elementsize
		endc
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,width,height
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		bsr.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if (narg=2)
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	obX(a0),d0	; get object position
		endc
		andi.w	#$FF80,d0	; round down to nearest $80
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
		cmpi.w	#128+320+192,d0
		bhi.\0	exit
		endm

; ---------------------------------------------------------------------------
; play a sound effect or music
; input: track, terminate routine, branch or jump, move operand size
; ---------------------------------------------------------------------------

music:		macro track,terminate,branch,byte
		  if OptimiseSound=1
			move.b	#track,(v_snddriver_ram+v_playsnd1).l
		    if terminate=1
			rts
		    endc
		  else
	 	    if byte=1
			move.b	#track,d0
		    else
			move.w	#track,d0
		    endc
		    if branch=1
		      if terminate=0
			bsr.w	PlaySound
		      else
			bra.w	PlaySound
		      endc
		    else
		      if terminate=0
			jsr	(PlaySound).l
		      else
			jmp	(PlaySound).l
		      endc
		    endc
		  endc
		endm

sfx:		macro track,terminate,branch,byte
		  if OptimiseSound=1
			move.b	#track,(v_snddriver_ram+v_playsnd2).l
		    if terminate=1
			rts
		    endc
		  else
	 	    if byte=1
			move.b	#track,d0
		    else
			move.w	#track,d0
		    endc
		    if branch=1
		      if terminate=0
			bsr.w	PlaySound_Special
		      else
			bra.w	PlaySound_Special
		      endc
		    else
		      if terminate=0
			jsr	(PlaySound_Special).l
		      else
			jmp	(PlaySound_Special).l
		      endc
		    endc
		  endc
		endm

; ---------------------------------------------------------------------------
; Sprite mappings header and footer
; ---------------------------------------------------------------------------

spritemap:	macro
		if ~def(current_sprite)
		current_sprite: = 1
		endc
		sprite_start: = *+1
		dc.b (sprite_\#current_sprite-sprite_start)/5
		endm

endsprite:	macro
		sprite_\#current_sprite: equ *
		current_sprite: = current_sprite+1
		endm

; ---------------------------------------------------------------------------
; Sprite mappings piece
; input: xpos, ypos, size, tile index
; optional: xflip, yflip, pal2|pal3|pal4, hi (any order)
; ---------------------------------------------------------------------------

piece:		macro
		dc.b \2		; ypos
		sprite_width:	substr	1,1,"\3"
		sprite_height:	substr	3,3,"\3"
		dc.b ((sprite_width-1)<<2)+sprite_height-1
		sprite_xpos: = \1
		sprite_tile: = \4
		
		sprite_xflip: = 0
		sprite_yflip: = 0
		sprite_hi: = 0
		sprite_pal: = 0
		rept narg-4
			if strcmp("\5","xflip")
			sprite_xflip: = $800
			elseif strcmp("\5","yflip")
			sprite_yflip: = $1000
			elseif strcmp("\5","hi")
			sprite_hi: = $8000
			elseif strcmp("\5","pal2")
			sprite_pal: = $2000
			elseif strcmp("\5","pal3")
			sprite_pal: = $4000
			elseif strcmp("\5","pal4")
			sprite_pal: = $6000
			else
			endc
		shift
		endr
		
		dc.w sprite_tile+sprite_xflip+sprite_yflip+sprite_hi+sprite_pal
		dc.b sprite_xpos
		endm