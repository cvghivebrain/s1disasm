; ---------------------------------------------------------------------------
; Align and pad.
; input: length to align to, value to use as padding (default is 0)
; ---------------------------------------------------------------------------

align:		macro
		if narg=1
		dcb.b (\1-(*%\1))%\1,0
		else
		dcb.b (\1-(*%\1))%\1,\2
		endc
		endm

; ---------------------------------------------------------------------------
; Save and restore registers from the stack.
; ---------------------------------------------------------------------------

pushr:		macro
		if strlen("\1")>2
		movem.l	\1,-(sp)				; save multiple registers
		else
		move.l	\1,-(sp)				; save one register
		endc
		endm

popr:		macro
		if strlen("\1")>2
		movem.l	(sp)+,\1				; restore multiple registers
		else
		move.l	(sp)+,\1				; restore one register
		endc
		endm

; ---------------------------------------------------------------------------
; Align and pad RAM sections so that they are divisible by a longword.
; ---------------------------------------------------------------------------

rsalign:	macro
		rs.b (\1-(__rs%\1))%\1
		endm

rsblock:	macro
		rsalign 2					; align to even address
		rsblock_\1: equ __rs
		endm

rsblockend:	macro
		rs.b (4-((__rs-rsblock_\1)%4))%4		; align to 4 (starting from rsblock)
		loops_to_clear_\1: equ ((__rs-rsblock_\1)/4)-1	; number of loops needed to clear block with longword writes
		endm

; ---------------------------------------------------------------------------
; Organise object RAM usage.
; ---------------------------------------------------------------------------

rsobj:		macro name,start
		rsobj_name: equs "\name"			; remember name of current object
		if strlen("\start")>0
		rsset \start					; start at specified position
		else
		rsset ost_used					; start at end of regular OST usage
		endc
		pusho						; save options
		opt	ae+					; enable auto evens
		endm

rsobjend:	macro
		if __rs>sizeof_ost
		inform	3,"OST for \rsobj_name exceeds maximum by $%h bytes.",__rs-sizeof_ost
		else
		;inform	0,"0-$%h bytes of OST for \rsobj_name used, leaving $%h bytes unused.",__rs-1,sizeof_ost-__rs
		endc
		popo
		endm

; ---------------------------------------------------------------------------
; Create a pointer index.
; input: start location (usually * or 0; leave blank to make pointers
;  relative to themselves), id start (default 0), id increment (default 1)
; ---------------------------------------------------------------------------

index:		macro
		nolist
		pusho
		opt	m-

		if strlen("\1")>0				; check if start is defined
		index_start: = \1
		else
		index_start: = -1
		endc
		if strlen("\0")=0				; check if width is defined (b, w, l)
		index_width: equs "w"				; use w by default
		else
		index_width: equs "\0"
		endc
		
		if strlen("\2")=0				; check if first pointer id is defined
		ptr_id: = 0					; use 0 by default
		else
		ptr_id: = \2
		endc
		if strlen("\3")=0				; check if pointer id increment is defined
		ptr_id_inc: = 1					; use 1 by default
		else
		ptr_id_inc: = \3
		endc
		
		popo
		list
		endm

; ---------------------------------------------------------------------------
; Item in a pointer index.
; input: pointer target, pointer label array (optional)
; ---------------------------------------------------------------------------

ptr:		macro
		nolist
		pusho
		opt	m-

		if index_start=-1
		dc.\index_width \1-*
		else
		dc.\index_width \1-index_start
		endc
		
		if ~def(prefix_id)
		prefix_id: equs "id_"
		endc
		
		if instr("\1",".")=1				; check if pointer is local
		else
			if ~def(\prefix_id\\1)
			\prefix_id\\1: equ ptr_id		; create id for pointer
			else
			\prefix_id\\1_\$ptr_id: equ ptr_id	; if id already exists, append number
			endc
		endc
		
		ptr_id: = ptr_id+ptr_id_inc			; increment id

		popo
		list
		endm

; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if narg=1
		move.l	#($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),\controlport
		endc
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to VRAM/CRAM/VSRAM.
; input: source, length, destination ([vram address]|cram|vsram),
;  cram/vsram destination (0 by default)
; ---------------------------------------------------------------------------

dma:		macro
		dma_type: = $4000
		dma_type2: = $80
		
		if strcmp("\3","cram")
		dma_type: = $C000
			if strlen("\4")=0
			dma_dest: = 0
			else
			dma_dest: = \4
			endc
		elseif strcmp("\3","vsram")
		dma_type2: = $90
			if strlen("\4")=0
			dma_dest: = 0
			else
			dma_dest: = \4
			endc
		else
		dma_dest: = \3
		endc
		
		lea	(vdp_control_port).l,a5
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#dma_type+(dma_dest&$3FFF),(a5)
		move.w	#dma_type2+((dma_dest&$C000)>>14),(v_vdp_dma_buffer).w
		move.w	(v_vdp_dma_buffer).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value.
; input: value, length, destination
; ---------------------------------------------------------------------------

dma_fill:	macro value,length,loc
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$94000000+(((length)&$FF00)<<8)+$9300+((length)&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14),(a5)
		move.w	#value,(vdp_data_port).l
		endm

; ---------------------------------------------------------------------------
; Disable display
; ---------------------------------------------------------------------------

disable_display:	macro
		move.w	(v_vdp_mode_buffer).w,d0		; $81xx
		andi.b	#$BF,d0					; clear bit 6
		move.w	d0,(vdp_control_port).l
		endm

; ---------------------------------------------------------------------------
; Enable display
; ---------------------------------------------------------------------------

enable_display:	macro
		move.w	(v_vdp_mode_buffer).w,d0		; $81xx
		ori.b	#$40,d0					; set bit 6
		move.w	d0,(vdp_control_port).l
		endm

; ---------------------------------------------------------------------------
; Compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
	.end:
		if (.end-loc)-(ZoneCount*elementsize)<>0
		inform 1,"Size of \loc ($%h) does not match ZoneCount ($\#ZoneCount).",(.end-loc)/elementsize
		endc
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,x,y,width,height
		lea	(source).l,a1
		vram_loc: = (loc)+(sizeof_vram_row*(y))+((x)*2)
		locVRAM	vram_loc,d0
		moveq	#width-1,d1
		moveq	#height-1,d2
		bsr.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (ost_x_pos(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if narg=2
		move.w	pos,d0					; get object position (if specified as not ost_x_pos)
		else
		move.w	ost_x_pos(a0),d0			; get object position
		endc
		andi.w	#$FF80,d0				; round down to nearest $80
		move.w	(v_camera_x_pos).w,d1			; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0					; d0 = approx distance between object and screen (negative if object is left of screen)
		cmpi.w	#128+320+192,d0
		bhi.\0	exit					; branch if d0 is negative or higher than 640
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
		if \4<0						; is tile index negative?
			sprite_tile: = $10000+(\4)		; convert signed to unsigned
		else
			sprite_tile: = \4
		endc
		
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
		
		dc.w (sprite_tile+sprite_xflip+sprite_yflip+sprite_hi+sprite_pal)&$FFFF
		dc.b sprite_xpos
		endm

; ---------------------------------------------------------------------------
; Object placement
; input: xpos, ypos, object id, subtype
; optional: xflip, yflip, rem (any order)
; ---------------------------------------------------------------------------

objpos:		macro
		dc.w \1		; xpos
		obj_ypos: = \2
		if strcmp("\3","0")
		obj_id: = 0
		else
		obj_id: = id_\3
		endc
		obj_sub\@: equ \4
		obj_xflip: = 0
		obj_yflip: = 0
		obj_rem: = 0
		rept narg-4
			if strcmp("\5","xflip")
			obj_xflip: = $4000
			elseif strcmp("\5","yflip")
			obj_yflip: = $8000
			elseif strcmp("\5","rem")
			obj_rem: = $80
			else
			endc
		shift
		endr
		
		dc.w obj_ypos+obj_xflip+obj_yflip
		dc.b obj_id+obj_rem, obj_sub\@
		endm

endobj:		macro
		objpos $FFFF,0,0,0
		endm

; ---------------------------------------------------------------------------
; Define an external file
; input: label, file name (including folder), extension (actual),
;  extension (uncompressed)
; ---------------------------------------------------------------------------

filedef:	macro lbl,file,ex1,ex2
		filename: equs \file				; get file name without quotes
		file_\lbl: equs "\filename\.\ex1"		; record file name
		sizeof_\lbl: equ filesize("\filename\.\ex2")	; record file size of associated uncompressed file
		endm

; ---------------------------------------------------------------------------
; Incbins a file
; input: label (must have been declared by filedef)
; ---------------------------------------------------------------------------

incfile:	macro lbl
		filename: equs file_\lbl			; get file name
	\lbl:	incbin	"\filename"				; write file to ROM
		even
		endm

; ---------------------------------------------------------------------------
; Declares a blank object
; input: label
; ---------------------------------------------------------------------------

blankobj:	macro
	\1:	rts
		endm

; ---------------------------------------------------------------------------
; Long conditional jumps
; ---------------------------------------------------------------------------

jcond:		macro btype,jumpto
		btype.s	.nojump\@
		jmp	jumpto
	.nojump\@:
		endm

jhi:		macro
		jcond bls,\1
		endm

jcc:		macro
		jcond bcs,\1
		endm

jhs:		macro
		jcc	\1
		endm

jls:		macro
		jcond bhi,\1
		endm

jcs:		macro
		jcond bcc,\1
		endm

jlo:		macro
		jcs	\1
		endm

jeq:		macro
		jcond bne,\1
		endm

jne:		macro
		jcond beq,\1
		endm

jgt:		macro
		jcond ble,\1
		endm

jge:		macro
		jcond blt,\1
		endm

jle:		macro
		jcond bgt,\1
		endm

jlt:		macro
		jcond bge,\1
		endm

jpl:		macro
		jcond bmi,\1
		endm

jmi:		macro
		jcond bpl,\1
		endm
