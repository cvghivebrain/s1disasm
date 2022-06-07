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
; Align and pad RAM sections so that they are divisible by a longword.
; ---------------------------------------------------------------------------

rsalign:	macros
		rs.b (\1-(__rs%\1))%\1

rsblock:	macro
		rsalign 2					; align to even address
		rsblock_\1: equ __rs
		endm

rsblockend:	macro
		rs.b (4-((__rs-rsblock_\1)%4))%4		; align to 4 (starting from rsblock)
		loops_to_clear_\1: equ ((__rs-rsblock_\1)/4)-1	; number of loops needed to clear block with longword writes
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
		
		if strcmp("\index_width","b")
		index_width_int: = 1
		elseif strcmp("\index_width","w")
		index_width_int: = 2
		elseif strcmp("\index_width","l")
		index_width_int: = 4
		else
		fail
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
		
		tmp_array: equs "empty"				; clear tmp_array

		popo
		list
		endm
	
; ---------------------------------------------------------------------------
; Create a mirrored pointer index. Used to keep Sonic's mappings & DPLC
; indexes aligned.
; input: same as index (see above), prefix, pointer label array
; ---------------------------------------------------------------------------

mirror_index:	macro
		nolist
		pusho
		opt	m-

		index.\0 \1,\2,\3
		ptr_prefix: equs "\4"
		ptr_pos: = 1
		ptr_bar: = instr(1,"\5","|")			; find first bar
		while ptr_bar>0
		ptr_sub: substr ptr_pos,ptr_bar-1,"\5"		; get label
		ptr \ptr_prefix\_\ptr_sub			; create pointer
		ptr_pos: = ptr_bar+1
		ptr_bar: = instr(ptr_pos,"\5","|")		; find next bar
		endw
		ptr_sub: substr ptr_pos,,"\5"
		ptr \ptr_prefix\_\ptr_sub			; final pointer

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
		
		if instr("\1","@")=1				; check if pointer is local
		else
			if ~def(\prefix_id\\1)
			\prefix_id\\1: equ ptr_id		; create id for pointer
			else
			\prefix_id\\1_\$ptr_id: equ ptr_id	; if id already exists, append number
			endc
		endc
		
		if strlen("\2")=0				; check if label should be stored
		else
			if strcmp("\tmp_array","empty")
			tmp_array: equs "\1"			; store first label
			else
			tmp_array: equs "\tmp_array|\1"		; store subsequent labels
			endc
		\2: equs tmp_array
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
